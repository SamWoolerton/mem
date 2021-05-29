let default = () => {
  let router = Next.Router.useRouter()

  let id = Js.Dict.unsafeGet(router.query, "id")

  let activityLink = (stub, label) =>
    <div>
      <Next.Link href={`/passages/${id}/${stub}`}> <a> {label->React.string} </a> </Next.Link>
    </div>

  <div>
    <h1 className="text-3xl font-semibold"> {"Passage details"->React.string} </h1>
    <div>
      {activityLink("tap", "Tap")}
      {activityLink("bank", "Word bank")}
      {activityLink("unshuffle", "Unshuffle")}
      {activityLink("type", "Type")}
    </div>
  </div>
}
