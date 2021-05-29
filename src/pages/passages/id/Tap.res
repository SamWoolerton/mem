open Js.Array2

let default = () => {
  let router = Next.Router.useRouter()

  let pageId = Js.Dict.unsafeGet(router.query, "id")

  // TODO: get this to compile; no idea why it won't

  // let parsedPageId = Belt.Int.fromString(pageId)

  // let idOrDefault = Js.Option.default(1, parsedPageId)

  let passage = Recoil.useRecoilValue(State.passages)->Utility.getPassageById(1)

  let chunks = switch passage {
  // TODO: handle this better; needs to redirect to an error state, but handled gracefully

  | None => []

  | Some(p) => Utility.getChunksFromPassage(p)
  }

  let (counter, setCounter) = React.useState(_ => 0)

  let backlink = contents => <Next.Link href={`/passages/${pageId}`}> <a> contents </a> </Next.Link>

  let doneButton = if counter >= length(chunks) {
    backlink("Return to passage"->React.string)
  } else {
    React.null
  }

  let onClick = _ => {
    setCounter(prev => prev + 1)
  }

  <div onClick className="h-full">
    {backlink(<div> {"Back"->React.string} </div>)}
    <h1 className="text-3xl font-semibold"> {"Tap through passage"->React.string} </h1>
    <div>
      {filteri(chunks, (_chunk, index) => index <= counter)
      ->map(chunk => <span key={chunk}> {React.string(`${chunk} `)} </span>)
      ->React.array}
    </div>
    doneButton
  </div>
}
