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
