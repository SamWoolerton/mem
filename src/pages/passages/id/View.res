let default = () => {
  let passage = Hooks.usePassage()
  let router = Next.Router.useRouter()

  switch passage {
  | None => {
      Next.Router.push(router, "/passages")
      <div> {"Loading..."->React.string} </div>
    }
  | Some(p) => {
      let activityLink = (stub, label) =>
        <div>
          <Next.Link href={`/passages/${p.id->Belt.Int.toString}/${stub}`}>
            <a> {label->React.string} </a>
          </Next.Link>
        </div>

      <div>
        <h1 className="text-3xl font-semibold"> {"Passage details"->React.string} </h1>
        <div>
          {`${p.book} ${p.chapter->Belt.Int.toString} `->React.string}
          {p.end_verse > p.start_verse
            ? <span>
                {`${p.start_verse->Belt.Int.toString}:${p.end_verse->Belt.Int.toString}`->React.string}
              </span>
            : <span> {p.start_verse->Belt.Int.toString->React.string} </span>}
        </div>
        <div> {"TODO: Version: KJV"->React.string} </div>
        <div>
          {(p.verses
          ->Js.Array2.reduce(
            (acc, next) => acc + Js.String.split(" ", next.text)->Js.Array2.length,
            0,
          )
          ->Belt.Int.toString ++ " words")->React.string}
        </div>
        <div className="mt-3">
          <h3 className="text-lg font-semibold"> {"Quick links"->React.string} </h3>
          {activityLink("tap", "Tap")}
          {activityLink("bank", "Word bank")}
          {activityLink("unshuffle", "Unshuffle")}
          {activityLink("type", "Type")}
        </div>
        <div className="mt-3">
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
