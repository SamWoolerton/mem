let default = () => {
  let router = Next.Router.useRouter()
  let (password, setPassword) = React.useState(() => "")
  let (accessToken, setAccessToken) = React.useState(() => "")
  let (errorMessage, setErrorMessage) = React.useState(() => "")
  let darkMode = Hooks.usePrefersDarkMode()

  let disabledSubmit = password === ""

  let redirectToHomepage = () => Next.Router.push(router, "/")

  React.useEffect0(() => {
    setAccessToken(_prev =>
      router.asPath
      ->Js.String2.replace("/auth/reset-password#access_token=", "")
      ->Js.String2.split("&")
      ->Js.Array2.unsafe_get(0)
    )
    None
  })

  let authMethod = evt => {
    // form submission reloads the page
    ReactEvent.Form.preventDefault(evt)

    Supabase.Auth.resetPassword(Supabase.c, accessToken, {"password": password})
    ->Utility.Promise.tap(val => {
      switch val.error->Js.Nullable.toOption {
      | None => redirectToHomepage()
      | Some(err) => setErrorMessage(_prev => err.message)
      }
    })
    ->ignore
  }

  // TODO: pull in either reform or formality to make this way cleaner
  let input = (label, val, handler, kind) =>
    <label className="mt-2 block">
      <h3> {label->React.string} </h3>
      <input
        className="w-full p-1"
        value=val
        onChange={evt => {
          ReactEvent.Form.preventDefault(evt)
          let val = ReactEvent.Form.target(evt)["value"]
          handler(_prev => val)
        }}
        type_=kind
      />
    </label>

  <div className="flex h-full justify-center items-center">
    <div className="bg-foreground p-10 sm:w-2/3 md:w-1/2">
      <SignInUp.AuthLogo darkMode />
      <h3 className="text-xl mb-2 font-bold"> {"Reset password"->React.string} </h3>
      {errorMessage !== ""
        ? <div className="px-3 py-1 bg-red-100 text-red-800"> {errorMessage->React.string} </div>
        : React.null}
      <form onSubmit=authMethod>
        {input("New password", password, setPassword, "password")}
        <button className={"my-3 w-full"} type_="submit" disabled=disabledSubmit>
          {"Reset password"->React.string}
        </button>
      </form>
    </div>
  </div>
}
