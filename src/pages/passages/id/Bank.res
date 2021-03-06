open Js.Array2

type word = {
  index: int,
  text: string,
  visible: bool,
  firstHidden: bool,
}

let createWord = (text, index) => {
  // Make the first word and every fifth word after that invisible.
  {index: index, text: text, visible: index !== 0 && mod(index, 5) !== 0, firstHidden: index == 0}
}

let getWordsFromPassage = (passage: Model.passage) => {
  passage->Utility.getWordsFromPassage->mapi(createWord)
}

let getDistinctWords = (words: Js.Array2.t<word>, firstWord: word) => {
  let distinctWords = []
  for index in 0 to words->length - 1 {
    let addWord = words[index]
    let lastText = distinctWords->length > 0 ? distinctWords[distinctWords->length - 1].text : ""

    switch addWord.text != lastText && addWord.text != firstWord.text {
    | true => distinctWords->push(addWord)->ignore
    | _ => ()
    }
  }

  distinctWords
}

let firstAndRandomUnique = (words: Js.Array2.t<word>, maxNumber) => {
  let wordSelection = [words[0]]
  let distinctWords =
    words
    ->Js.Array2.slice(~start=1, ~end_=words->length)
    ->Js.Array2.sortInPlaceWith((word1, word2) => word1.text < word2.text ? -1 : 1)
    ->getDistinctWords(words[0])

  let maxIndex = length(distinctWords)
  let safeMaxNumber = maxIndex >= maxNumber ? maxNumber - 1 : maxIndex

  wordSelection
  ->pushMany(distinctWords->Belt.Array.shuffle->Js.Array2.slice(~start=0, ~end_=safeMaxNumber))
  ->ignore
  wordSelection->Belt.Array.shuffle
}

let getFirstHiddenIndex = (words: Js.Array2.t<word>) => {
  switch Js.Array2.find(words, item => item.visible == false) {
    | Some(item) => item.index
    | _ => -1
  }
}

let showVisible = (word: word) => {
  switch (word.visible, word.firstHidden) {
    // TODO Change this to use a standard colour instead of a custom one.
    | (false, true) => <span className="text-opacity-0 border-b-2 select-none border-blue-400 animate-pulse" key={Belt.Int.toString(word.index)}> {React.string(`${word.text} `)} </span>
    | (false, false) => <span className="text-opacity-0 border-b-2 select-none" key={Belt.Int.toString(word.index)}> {React.string(`${word.text} `)} </span>
    | _ => <span key={Belt.Int.toString(word.index)}> {React.string(`${word.text} `)} </span>
  }
}

let default = () => {
  let passage = Hooks.usePassage()
  let router = Next.Router.useRouter()
  let (words, updateWords) = React.useState(_ =>
    switch passage {
    | Some(p) => getWordsFromPassage(p)
    | _ => []
    }
  )

  let toggleVisiblity = (word: word) => {
    let newArr = Js.Array2.map(words, item =>
      item.firstHidden && item.text == word.text
        ? {index: item.index, text: item.text, visible: true, firstHidden: item.firstHidden}
        : item
    )

    let nextHiddenIndex = newArr->getFirstHiddenIndex

    let updNewArr = Js.Array2.map(newArr, item =>
      item.index == nextHiddenIndex 
        ? {index: item.index, text: item.text, visible: item.visible, firstHidden: true}
        : item
    )

    updateWords(_prev => updNewArr)    
  }

  let showWordOptions = (word: word) => {
    switch word.visible {
    | false =>
      <span
        key={word.text} 
        onClick={_ => toggleVisiblity(word)}
        className="button px-2 py-1 mx-2 cursor-pointer">
        {React.string(word.text)}
      </span>
    | true => <span />
    }
  }

  switch passage {
  | Loading => <div> {"Loading..."->React.string} </div>
  | None => {
      Next.Router.push(router, "/passages")
      <div> {"Passage not found"->React.string} </div>
    }
  | Some(p) =>
    let backlink = contents =>
      <Next.Link href={`/passages/${p.id->Belt.Int.toString}`}> <a> contents </a> </Next.Link>
    let wordSelection = if words->filter(word => !word.visible)->length > 0 {
      <div className="mt-2 p-4 bg-background footer-panel">
        <div className="-m-2 flex flex-wrap">
          {words
          ->filter(word => !word.visible)
          ->firstAndRandomUnique(6)
          ->map(showWordOptions)
          ->React.array}
        </div>
      </div>
    } else {
      backlink(<div className="button"> {"Return to passage"->React.string} </div>)
    }

    <div>
      <Next.Link href={`/passages/${p.id->Belt.Int.toString}`}>
        <a className="mt-2 block"> {"Back"->React.string} </a>
      </Next.Link>
      <h1 className="text-3xl font-semibold mt-1"> {"Fill in the gaps"->React.string} </h1>
      <p> {"Tap options to fill in the gaps"->React.string} </p>
      <div className="mt-4 px-5 py-4 bg-foreground">
        <div> {words->map(showVisible)->React.array} </div>
      </div>
      wordSelection
    </div>
  }
}
