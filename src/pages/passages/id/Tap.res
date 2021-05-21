let default = () => {
  let router = Next.Router.useRouter()

  let id = Js.Dict.unsafeGet(router.query, "id")

  <div>
    <h1 className="text-3xl font-semibold"> {"Tap through passage"->React.string} </h1>
    <p> {React.string(`Tap to show chunks`)} </p>
    <p> {id->React.string} </p>
  </div>
}
