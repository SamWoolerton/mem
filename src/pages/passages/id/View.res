let default = () => {
  let router = Next.Router.useRouter()

  let id = Js.Dict.unsafeGet(router.query, "id")

  <div>
    <h1 className="text-3xl font-semibold"> {"Passage details"->React.string} </h1>
    <p> {React.string(`Example paragraph about this passage.`)} </p>
    <p> {id->React.string} </p>
  </div>
}
