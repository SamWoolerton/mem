open Js.Array2

type word = {
  text: string,
  visible: bool,
}

let createWord = (str, index) => {
  let word: word = {text: str, visible: index !== 0 && mod(index, 5) !== 0} // Make the first word and every fifth word after that invisible.
  word
}

let getWordsFromPassage = (passage: Model.passage) => {
  passage->Utility.getTextFromPassage->Utility.getCustomSplitText(%re("/\s+/"))->mapi(createWord)
}

let showVisible = (word: word) => {
  switch word.visible {
  // TODO highlight the first visible word.
  | true => <span key={word.text}> {React.string(`${word.text} `)} </span>
  // TODO make each gap have an equal number of _ chars to chars in the word being hidden.
  | false => <span key={word.text}> {React.string(`_____`)} </span>
  }
}

// let selectWordOption = key => {

// }

let showWordOptions = (word: word) => {
  switch word.visible {
  | false => <span> <button key={word.text}> {React.string(word.text)} </button> <br /> </span> //onClick=selectWordOption(word.text)
  | true => <span />
  }
}

let firstAndRandom = (words: Js.Array2.t<word>, maxNumber) => {
  let maxIndex = length(words) - 1

  let safeMaxNumber = if length(words) >= maxNumber {
    maxNumber
  } else {
    maxIndex
  }

  let wordSelection = [words[0]]

  for index in 1 to safeMaxNumber - 1 {
    let temp = wordSelection->push(words[Js.Math.random_int(0, maxIndex)])
  }

  wordSelection
}

let default = () => {
  let passage = Hooks.usePassage()
  let router = Next.Router.useRouter()

  switch passage {
  | Loading => <div> {"Loading..."->React.string} </div>
  | None => {
      Next.Router.push(router, "/passages")
      <div> {"Passage not found"->React.string} </div>
    }
  | Some(p) => {
      let words = getWordsFromPassage(p)

      <div>
        <h1 className="text-3xl font-semibold"> {"Fill in the gaps"->React.string} </h1>
        <p> {"Tap options to fill in the gaps"->React.string} </p>
        <br />
        <div> {words->map(showVisible)->React.array} </div>
        <br />
        <div>
          {words
          ->filter(word => word.visible == false)
          ->firstAndRandom(8)
          ->map(showWordOptions)
          ->React.array}
        </div>
      </div>
    }
  }
}
