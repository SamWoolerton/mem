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
      let activityLink = (stub, label) =>
        <Next.Link href={`/passages/${p.id->Belt.Int.toString}/${stub}`}>
          <a className="bg-white px-3 py-2 m-2"> {label->React.string} </a>
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
        <div> {"TODO: Version: KJV"->React.string} </div>
        <div>
          {(p.verses
          ->Js.Array2.reduce(
            (acc, next) => acc + Js.String.split(" ", next.text)->Js.Array2.length,
            0,
          )
          ->Belt.Int.toString ++ " words")->React.string}
        </div>
        <div className="mt-4">
          <h3 className="text-lg font-semibold"> {"Quick links"->React.string} </h3>
          <div className="flex -mx-2">
            {activityLink("tap", "Tap")}
            {activityLink("bank", "Word bank")}
            {activityLink("unshuffle", "Unshuffle")}
            {activityLink("type", "Type")}
          </div>
        </div>
        <div className="mt-4 bg-white p-3">
          <h3 className="text-lg font-semibold"> {"Passage text"->React.string} </h3>
          <div>
            {p.verses
            ->Js.Array2.map(v =>
              <span key={v.id->Belt.Int.toString}> {v.text->React.string} </span>
            )
            ->React.array}
          </div>
        </div>
      </div>
    }
  }
}
