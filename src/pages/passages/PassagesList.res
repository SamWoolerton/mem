let default = () => {
  let passagesState = Recoil.useRecoilValue(State.passages)

  switch passagesState {
  | State.Loading => <div> {"Loading"->React.string} </div>
  | State.Stored(passages) =>
    <div>
      <h1 className="text-3xl font-semibold mt-3"> {"My passages"->React.string} </h1>
      <div className="mt-2">
        {passages
        ->Js.Array2.map(p =>
          <Next.Link href={"/passages/" ++ p.id->Belt.Int.toString} key={p.id->Belt.Int.toString}>
            <a className="px-4 py-3 bg-foreground flex">
              <div className="mr-auto">
                <div className="text-lg font-semibold">
                  {`${p.book} ${p.chapter->Belt.Int.toString} `->React.string}
                  {p.end_verse > p.start_verse
                    ? <span>
                        {`${p.start_verse->Belt.Int.toString}:${p.end_verse->Belt.Int.toString}`->React.string}
                      </span>
                    : <span> {p.start_verse->Belt.Int.toString->React.string} </span>}
                </div>
                <div className="text-gray-600 dark:text-gray-400"> {p.version->React.string} </div>
              </div>
              <Next.Link
                href={"/passages/" ++ p.id->Belt.Int.toString ++ "/unshuffle"}
                key={p.id->Belt.Int.toString}>
                <a>
                  <img
                    src={"/static/icons/Unshuffle.svg"}
                    className="w-12 block bg-background rounded-full"
                  />
                </a>
              </Next.Link>
            </a>
          </Next.Link>
        )
        ->React.array}
      </div>
    </div>
  }
}
