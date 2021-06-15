open Js.Array2

let default = () => {
  let passage = Hooks.usePassage()
  let router = Next.Router.useRouter()
  let (counter, setCounter) = React.useState(_ => 0)

  switch passage {
  | Loading => <div> {"Loading..."->React.string} </div>
  | None => {
      Next.Router.push(router, "/passages")
      <div> {"Passage not found"->React.string} </div>
    }
  | Some(p) => {
      let chunks = Utility.getChunksFromPassage(p)
      let backlink = contents =>
        <Next.Link href={`/passages/${p.id->Belt.Int.toString}`}> <a> contents </a> </Next.Link>
      let doneButton = if counter >= length(chunks) {
        backlink(<div className="button"> {"Return to passage"->React.string} </div>)
      } else {
        React.null
      }

      let onClick = _ => {
        setCounter(prev => prev + 1)
      }

      <div onClick className="h-full">
        {backlink(<div className="mt-2 block"> {"Back"->React.string} </div>)}
        <h1 className="text-3xl font-semibold mt-1"> {"Tap through passage"->React.string} </h1>
        // disable text selection so text doesn't get highlighted when repeatedly clicking/tapping
        <div className="select-none mb-4">
          {filteri(chunks, (_chunk, index) => index <= counter)
          ->mapi((chunk, i) =>
            <span key={`${i->Belt.Int.toString}-${chunk}}`}> {React.string(`${chunk} `)} </span>
          )
          ->React.array}
        </div>
        doneButton
      </div>
    }
  }
}
