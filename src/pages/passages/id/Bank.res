let default = () => {
  let router = Next.Router.useRouter()

  let id = Js.Dict.unsafeGet(router.query, "id")

  <div>
    <h1 className="text-3xl font-semibold"> {"Fill in the gaps"->React.string} </h1>
    <p> {React.string(`Tap options to fill in the gaps`)} </p>
    <p> {id->React.string} </p>
  </div>
}
