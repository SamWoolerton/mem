open Js.Array2

type word = {
  index: int,
  text: string,
  visible: bool,
}

let createWord = (text, index) => {
  // Make the first word and every fifth word after that invisible.
  {index: index, text: text, visible: index !== 0 && mod(index, 5) !== 0}
}

let getWordsFromPassage = (passage: Model.passage) => {
  passage
  ->Utility.getTextFromPassage
  ->Utility.getCustomSplitText(%re("/\s+/"))
  ->mapi(createWord)
}

let getUnderscoreString = string => {
  string
  ->Js.String2.replaceByRe(%re("/.(?=.*)/g"), "_")
  ->Js.String2.concat(" ")
  ->React.string
}

let showVisible = (word: word) => {
  switch word.visible {
  // TODO highlight the first visible word.
  // TODO make space after the hidden word use the standard formatting.
  | true => <span key={Belt.Int.toString(word.index)}> {React.string(`${word.text} `)} </span>
  | false =>
    <span key={Belt.Int.toString(word.index)} className="bg-background"> 
      {getUnderscoreString(word.text)}
    </span>
  }
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

  Js.Console.log(words[0])
  Js.Console.log(firstWord)
  distinctWords
} 

let firstAndRandomUnique = (words: Js.Array2.t<word>, maxNumber) => {
  let wordSelection = [words[0]]
  let distinctWords = words
                      ->Js.Array2.slice(~start=1, ~end_=words->length)
                      ->Js.Array2.sortInPlaceWith((word1, word2) => word1.text < word2.text ? -1 : 1)
                      ->getDistinctWords(words[0])

  let maxIndex = length(distinctWords) - 1
  let safeMaxNumber = (length(distinctWords) >= maxNumber ? maxNumber - 1 : maxIndex) 

  wordSelection->pushMany(distinctWords->Belt.Array.shuffle->Js.Array2.slice(~start=0, ~end_=safeMaxNumber))->ignore

  Js.Console.log(words[0])
  Js.Console.log(distinctWords)
  Js.Console.log(wordSelection)

  wordSelection->Belt.Array.shuffle
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
    let firstHiddenIndex = switch Js.Array2.find(words, item => item.visible == false) {
    | Some(item) => item.index
    | _ => -1
    }

    let newArr = Js.Array2.map(words, item =>
      item.index == firstHiddenIndex && item.text == word.text
        ? {index: item.index, text: item.text, visible: true}
        : item
    )

    updateWords(_prev => newArr)
  }

  let showWordOptions = (word: word) => {
    switch word.visible {
    | false =>
      <span
        key={word.text} //{Belt.Int.toString(word.index)}
        onClick={_ => toggleVisiblity(word)}
        className="bg-foreground px-2 py-1 mx-2 cursor-pointer">
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
    <div>
      <Next.Link href={`/passages/${p.id->Belt.Int.toString}`}>
        <a className="mt-2 block"> {"Back"->React.string} </a>
      </Next.Link>
      <h1 className="text-3xl font-semibold mt-1"> {"Fill in the gaps"->React.string} </h1>
      <p> {"Tap options to fill in the gaps"->React.string} </p>
      <div className="mt-4 px-5 py-4 bg-foreground">
        <div> {words->map(showVisible)->React.array} </div>
        // TODO: this probably should be fixed position at the bottom of the page instead
        <div className="mt-2 p-4 bg-background">
          <div className="-m-2 flex flex-wrap">
            {words
            ->filter(word => !word.visible)
            ->firstAndRandomUnique(6)
            ->map(showWordOptions)
            ->React.array}
          </div>
        </div>
      </div>
    </div>
  }
}
