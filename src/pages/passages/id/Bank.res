open Js.Array2

let default = () => {
  let router = Next.Router.useRouter()
  let pageId = Js.Dict.unsafeGet(router.query, "id")
  let parsedPageId = Belt.Int.fromString(pageId)

  // TODO: don't just get with default; handle error state
  let idOrDefault = Js.Option.default(1, parsedPageId)
  let passage = Recoil.useRecoilValue(State.passages)->Utility.getPassageById(idOrDefault)

  let words = switch passage {
  // TODO: handle this better; needs to redirect to an error state, but handled gracefully
  | None => []
  | Some(p) => Utility.getWordsFromPassage(p)
  }

  let showVisible = (word: Model.word) => {
    switch word.visible {
    | true => <span key={word.text}> {React.string(`${word.text} `)} </span>
    | false => <span key={word.text}> {React.string(`_____`)} </span>
    // TODO make each gap have an equal number of _ chars to chars in the word being hidden.
    }
  }

  // TODO handle a tap on an invisible word. 
  // Compare the tapped word to the first invisible word in the words array.
  // If the word matches, make it visible.
  // If it doesn't, increment the error counter.

  <div>
    <h1 className="text-3xl font-semibold"> {"Fill in the gaps"->React.string} </h1>
    <p> {React.string(`Tap options to fill in the gaps`)} </p>
    <div> {words->map(showVisible)->React.array} </div>
    // TODO to start with, show all invisible words.
    // TODO highlight the first visible word.
  </div>
}
