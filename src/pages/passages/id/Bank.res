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
  passage
  ->Utility.getTextFromPassage
  ->Utility.getCustomSplitText(%re("/\s+/"))
  ->mapi(createWord)
}

let showVisible = (word: word) => {
  switch word.visible {
  // TODO highlight the first visible word.
  | true => <span key={word.text}> {React.string(`${word.text} `)} </span>
  // TODO make each gap have an equal number of _ chars to chars in the word being hidden.
  | false => <span key={word.text}> {React.string(`_____`)} </span>
  }
}

let showWordOptions = (word: word) => {
  switch word.visible {
  | false => <span key={word.text}> {React.string(`${word.text} `)} <br /></span>
  | true => <span />
  }
}

let notVisible = (word: word) => {
  word.visible == false
}

let firstAndRandom = (words: Js.Array2.t<word>, maxNumber) => {
  let maxIndex = length(words) - 1

  let safeMaxNumber = if length(words) >= maxNumber {
    maxNumber
  } else {
    maxIndex
  } - 1

  let wordSelection = [words[0]]

  for index in 1 to safeMaxNumber {
    let temp = wordSelection->push(words[Js.Math.random_int(0, maxIndex)])
  }

  wordSelection
}

let default = () => {
  let router = Next.Router.useRouter()
  let pageId = Js.Dict.unsafeGet(router.query, "id")
  let parsedPageId = Belt.Int.fromString(pageId)

  // TODO: don't just get with default; handle error state
  let idOrDefault = Js.Option.default(1, parsedPageId)
  let passage = Recoil.useRecoilValue(State.passages)->Utility.getPassageById(idOrDefault)

  let words = switch passage {
  // TODO: handle this better; needs to redirect to an error state, but handled gracefully
  | Some(p) => getWordsFromPassage(p)
  | None => []
  }

  // TODO handle a tap on an invisible word.
  // Compare the tapped word to the first invisible word in the words array.
  // If the word matches, make it visible.
  // If it doesn't, increment the error counter.

  <div>
    <h1 className="text-3xl font-semibold"> {"Fill in the gaps"->React.string} </h1>
    <p> {"Tap options to fill in the gaps"->React.string} </p>
    <br />
    <div> {words->map(showVisible)->React.array} </div>
    <br />
    <div> {words
          ->filter(notVisible)
          ->firstAndRandom(1)
          ->map(showWordOptions)->React.array} </div>
  </div>
}
