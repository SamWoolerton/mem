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
        backlink("Return to passage"->React.string)
      } else {
        React.null
      }

      let onClick = _ => {
        setCounter(prev => prev + 1)
      }

      <div onClick className="h-full">
        {backlink(<div className="mt-2"> {"Back"->React.string} </div>)}
        <h1 className="text-3xl font-semibold mt-1"> {"Tap through passage"->React.string} </h1>
        <div>
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
