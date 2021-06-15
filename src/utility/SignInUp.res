module AuthLogo = {
  @react.component
  let make = (~darkMode) =>
    <div className="py-3 mb-4 flex justify-center items-center">
      <div className="w-16 bg-blue-400 dark:bg-blue-300 p-5 rounded-full">
        <img src={`/static/icons/logo-${darkMode ? "black" : "white"}.svg`} />
      </div>
      <div className="ml-3 text-center font-bold text-xl"> {"Mem"->React.string} </div>
    </div>
}

let comp = login => {
  let router = Next.Router.useRouter()
  let (email, setEmail) = React.useState(() => "")
  let (password, setPassword) = React.useState(() => "")
  let (errorMessage, setErrorMessage) = React.useState(() => "")
  let darkMode = Hooks.usePrefersDarkMode()

  let disabledSubmit = email === "" || password === ""

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

    let method = login ? Supabase.Auth.signIn : Supabase.Auth.signUp
    let res = method(
      Supabase.c,
      {
        "email": email,
        "password": password,
      },
    )

    Utility.Promise.tap(res, val => {
      switch val.error->Js.Nullable.toOption {
      | None => redirectToHomepage()
      | Some(err) => setErrorMessage(_prev => err.message)
      }
    })->ignore
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
      <AuthLogo darkMode />
      <h3 className="text-xl mb-2 font-bold"> {(login ? "Log in" : "Sign up")->React.string} </h3>
      {errorMessage !== ""
        ? <div className="px-3 py-1 bg-red-100 dark:bg-red-900 text-red-800 dark:text-red-100">
            {errorMessage->React.string}
          </div>
        : React.null}
      <form onSubmit=authMethod>
        {input("Email", email, setEmail, "email")}
        {input("Password", password, setPassword, "password")}
        {login
          ? <Next.Link href={"/auth/forgot-password"}>
              <a
                className="text-sm text-gray-500 dark:text-gray-400 text-right underline w-full block pl-1 pb-1">
                {"Forgot password?"->React.string}
              </a>
            </Next.Link>
          : React.null}
        <button
          className={"my-3 px-3 py-2 w-full bg-blue-300 dark:text-black"}
          type_="submit"
          disabled=disabledSubmit>
          {(login ? "Log in" : "Sign up")->React.string}
        </button>
      </form>
      <hr className="my-3" />
      <div className="mt-4 text-sm">
        {((login ? "Don't" : "Already") ++ " have an account? ")->React.string}
        <Next.Link href={login ? "/auth/signup" : "/auth/login"}>
          <a className="underline"> {(login ? "Sign up free" : "Log in here")->React.string} </a>
        </Next.Link>
      </div>
    </div>
  </div>
}
