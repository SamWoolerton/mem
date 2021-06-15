let default = () => {
  let router = Next.Router.useRouter()
  let (email, setEmail) = React.useState(() => "")
  let (errorMessage, setErrorMessage) = React.useState(() => "")
  let darkMode = Hooks.usePrefersDarkMode()

  let disabledSubmit = email === ""

  let redirectToHomepage = () => Next.Router.push(router, "/")
  React.useEffect0(() => {
    if Supabase.Auth.isLoggedIn() {
      redirectToHomepage()
    }
    None
  })

  let authMethod = evt => {
    // form submission reloads the page
    ReactEvent.Form.preventDefault(evt)

    Supabase.Auth.sendPasswordResetEmail(
      Supabase.c,
      email,
      // TODO: use current full URL to make this work in prod too
      {"redirectTo": "http://localhost:3000/auth/reset-password"},
    )
    ->Utility.Promise.tap(val => {
      switch val.error->Js.Nullable.toOption {
      | None => Next.Router.push(router, "/password-reset-sent")
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
      <h3 className="text-xl mb-2 font-bold"> {"Forgot password"->React.string} </h3>
      {errorMessage !== ""
        ? <div className="px-3 py-1 bg-red-100 text-red-800"> {errorMessage->React.string} </div>
        : React.null}
      <form onSubmit=authMethod>
        {input("Email", email, setEmail, "email")}
        <button
          className={"my-3 px-3 py-2 w-full bg-blue-300"} type_="submit" disabled=disabledSubmit>
          {"Reset password"->React.string}
        </button>
      </form>
      <hr className="my-3" />
      <div className="mt-4 text-sm">
        {"Don't have an account? "->React.string}
        <Next.Link href={"/auth/signup"}>
          <a className="underline"> {"Sign up free"->React.string} </a>
        </Next.Link>
      </div>
    </div>
  </div>
}
