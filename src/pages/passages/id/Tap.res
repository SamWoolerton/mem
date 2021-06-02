open Js.Array2

let default = () => {
  let router = Next.Router.useRouter()
  let passages = Recoil.useRecoilValue(State.passages)
  let (counter, setCounter) = React.useState(_ => 0)

  let passage = Utility.getPassageForPage(router, passages)

  switch passage {
  | None => {
      Next.Router.push(router, "/passages")

      <div> {"Loading..."->React.string} </div>
    }
  | Some(p) => {
      let chunks = Utility.getChunksFromPassage(p)
      let backlink = contents =>
        <Next.Link href={`/passages/${p.id->Belt.Int.toString}`}> <a> contents </a> </Next.Link>
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
  }
}
