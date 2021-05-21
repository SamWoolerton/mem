let default = () => {
  let router = Next.Router.useRouter()

  let id = Js.Dict.unsafeGet(router.query, "id")

  <div>
    <h1 className="text-3xl font-semibold"> {"Type out passage"->React.string} </h1>
    <p> {React.string(`Placeholder for typing out passage`)} </p>
    <p> {id->React.string} </p>
  </div>
}
