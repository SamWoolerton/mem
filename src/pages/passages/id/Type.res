type state =
  | Attempt(string)
  | Done(array<Diff.diff>)

let default = () => {
  let passage = Hooks.usePassage()
  let router = Next.Router.useRouter()
  let (attempt, setAttempt) = React.useState(() => Attempt(""))

  switch passage {
  | Loading => <div> {"Loading..."->React.string} </div>
  | None => {
      Next.Router.push(router, "/passages")
      <div> {"Passage not found"->React.string} </div>
    }
  | Some(p) => {
      let verses = p.verses->Js.Array2.map(v => v.text)
      let passageText = Js.String2.concatMany("", verses)

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
        {switch attempt {
        | Attempt(s) =>
          <div className="h-full">
            <textarea
              value=s
              onChange={evt => {
                ReactEvent.Form.preventDefault(evt)
                let val = ReactEvent.Form.target(evt)["value"]
                setAttempt(_prev => Attempt(val))
              }}
              className="block my-2 w-full h-2/3"
            />
            <button
              onClick={_evt => {
                setAttempt(_prev => Done(Diff.diff(s, passageText)))
              }}>
              {"Check"->React.string}
            </button>
          </div>
        | Done(res) =>
          <div>
            <div>
              {Js.Array2.mapi(res, (d, i) =>
                <span key={i->Belt.Int.toString}>
                  {switch d {
                  | Diff.Remove(s) =>
                    <span className="line-through bg-red-100 text-red-800">
                      {s->React.string}
                    </span>
                  | Diff.Add(s) =>
                    <span className="bg-red-200 text-red-800"> {s->React.string} </span>
                  | Diff.Keep(s) =>
                    <span className="bg-green-100 text-green-800"> {s->React.string} </span>
                  }}
                </span>
              )->React.array}
            </div>
            doneButton
          </div>
        }}
      </div>
    }
  }
}
