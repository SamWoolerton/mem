type passage_status =
  | Loading
  | Some(Model.passage)
  | None

let usePassage = () => {
  let router = Next.Router.useRouter()
  let passages = Recoil.useRecoilValue(State.passages)

  let isServer = router.query->Js.Dict.get("id")->Js.Option.isNone
  switch (isServer, passages) {
  | (true, _)
  | (_, State.Loading) =>
    Loading
  | (_, State.Stored(p)) =>
    switch Utility.getPassageForPage(router, p) {
    | None => None
    | Some(passage) => Some(passage)
    }
  }
}

// JS implementation from https://usehooks.com/useDarkMode/
let usePrefersDarkMode = () => {
  // returns a list passed by reference, so when the colour scheme changes we can just check the same list again
  let queryList = MatchMedia.query("(prefers-color-scheme: dark)")
  let getValue = _ => queryList.matches
  let (value, setValue) = React.useState(getValue)

  React.useEffect0(() => {
    let handler = _ => setValue(getValue)

    // Note that this method has been deprecated in favour of `addEventListender("change", callback)
    // Not switching yet as old Safari doesn't support it, and still 3% usage per CanIUse
    MatchMedia.addListener(queryList, handler)

    Some(() => MatchMedia.removeListener(queryList, handler))
  })

  value
}
