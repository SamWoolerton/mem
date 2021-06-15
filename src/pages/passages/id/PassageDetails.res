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
      let activityLink = (stub, label, difficulty, icon) =>
        <Next.Link href={`/passages/${p.id->Belt.Int.toString}/${stub}`}>
          <a
            className="p-2 w-1/2 md:w-auto flex-grow"
            style={ReactDOM.Style.make(~minWidth="12rem", ())}>
            <div className="bg-foreground p-5 text-center">
              <img
                src={"/static/icons/" ++ icon ++ ".svg"}
                className="w-20 block mx-auto bg-background rounded-full"
              />
              <div className="mt-2 text-lg"> {label->React.string} </div>
              <div
                className="mt-1 text-sm uppercase text-gray-600 dark:text-gray-400 font-semibold">
                {difficulty->React.string}
              </div>
            </div>
          </a>
        </Next.Link>

      <div>
        <Next.Link href="/passages">
          <a className="mt-2 block"> {"Back"->React.string} </a>
        </Next.Link>
        <h1 className="text-3xl font-semibold mt-1">
          {`${p.book} ${p.chapter->Belt.Int.toString} `->React.string}
          {p.end_verse > p.start_verse
            ? <span>
                {`${p.start_verse->Belt.Int.toString}:${p.end_verse->Belt.Int.toString}`->React.string}
              </span>
            : <span> {p.start_verse->Belt.Int.toString->React.string} </span>}
        </h1>
        <div className="font-semibold text-xl text-gray-600 dark:text-gray-400 -mt-2">
          {p.version->React.string}
        </div>
        <div className="mt-2">
          {(p.verses
          ->Js.Array2.reduce(
            (acc, next) => acc + Js.String.split(" ", next.text)->Js.Array2.length,
            0,
          )
          ->Belt.Int.toString ++ " words")->React.string}
        </div>
        <div className="mt-4">
          <h3 className="text-lg font-semibold"> {"Quick links"->React.string} </h3>
          <div className="-mx-2 flex flex-wrap">
            {activityLink("tap", "Tap", "Beginner", "Tap")}
            {activityLink("bank", "Word bank", "Easy", "Bank")}
            {activityLink("unshuffle", "Unshuffle", "Medium", "Unshuffle")}
            {activityLink("type", "Type", "Advanced", "Type")}
          </div>
        </div>
        <div className="mt-4 bg-foreground px-4 py-3">
          <h3 className="text-lg font-semibold"> {"Passage text"->React.string} </h3>
          <div className="mt-2">
            {p.verses
            ->Js.Array2.map(v =>
              <span>
                <span className="text-gray-600 dark:text-gray-300 text-sm font-bold mx-1">
                  {` ${v.number->Belt.Int.toString} `->React.string}
                </span>
                <span key={v.id->Belt.Int.toString}> {v.text->React.string} </span>
              </span>
            )
            ->React.array}
          </div>
        </div>
      </div>
    }
  }
}
