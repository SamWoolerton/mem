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
  | false => <span key={word.text} className="bg-background"> {React.string(`_____`)} </span>
  }
}

// let selectWordOption = key => {

// }

let showWordOptions = (word: word) => {
  switch word.visible {
  // TODO: are keys always unique? React throws an error if they're not
  | false =>
    <span key={word.text} className="bg-foreground px-2 py-1 mx-2 cursor-pointer">
      {React.string(word.text)}
    </span> //onClick=selectWordOption(word.text)
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
    index->ignore
    temp->ignore
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
              ->firstAndRandom(8)
              ->map(showWordOptions)
              ->React.array}
            </div>
          </div>
        </div>
      </div>
    }
  }
}
