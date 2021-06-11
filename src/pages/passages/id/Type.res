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
      let backlink = contents =>
        <Next.Link href={`/passages/${p.id->Belt.Int.toString}`}> <a> contents </a> </Next.Link>
      let doneButton = if true {
        backlink("Return to passage"->React.string)
      } else {
        React.null
      }

      <div className="h-full">
        {backlink(<div className="mt-2"> {"Back"->React.string} </div>)}
        <h1 className="text-3xl font-semibold mt-1"> {"Type out passage"->React.string} </h1>
        doneButton
      </div>
    }
  }
}
