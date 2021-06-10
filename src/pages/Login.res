let default = () => {
  let router = Next.Router.useRouter()
  let (email, setEmail) = React.useState(() => "")
  let (password, setPassword) = React.useState(() => "")
  let (errorMessage, setErrorMessage) = React.useState(() => "")

  // TODO: on page load, check if already logged in and redirect to homepage immediately if so
  let redirectToHomepage = () => Next.Router.push(router, "/")

  let login = _evt => {
    let res = Supabase.Auth.signIn(
      Supabase.c,
      {
        "email": email,
        "password": password,
      },
    )

    // TODO: utility to map over promise
    // TODO: utility to trace output for promise (and return `val` again)

    // Note that we have to specify the type because this is data-last style
    Js.Promise.then_((val: Supabase.Auth.auth_response) => {
      switch val.error->Js.Nullable.toOption {
      | None => redirectToHomepage()
      | Some(err) => setErrorMessage(_prev => err.message)
      }
      Js.Promise.resolve(1)
    }, res)->ignore
  }

  // TODO: pull in either reform or formality to make this way cleaner
  let input = (label, val, handler, kind) =>
    <label className="mt-2 block">
      <h3> {label->React.string} </h3>
      <input
        className="bg-gray-100 w-full p-1"
        value=val
        onChange={evt => {
          ReactEvent.Form.preventDefault(evt)
          let val = ReactEvent.Form.target(evt)["value"]
          handler(_prev => val)
        }}
        type_=kind
      />
    </label>

  <div className="flex bg-gray-100 h-full justify-center items-center">
    <div className="bg-white p-10 max-w-full w-80">
      <h3 className="text-xl mb-2 font-bold"> {"Log in"->React.string} </h3>
      {errorMessage !== ""
        ? <div className="px-3 py-1 bg-red-100 text-red-800"> {errorMessage->React.string} </div>
        : React.null}
      {input("Email", email, setEmail, "email")}
      {input("Password", password, setPassword, "password")}
      <Next.Link href={"/auth/forgot-password"}>
        <a className="text-sm text-gray-500 text-right underline w-full block pl-1 pb-1">
          {"Forgot password?"->React.string}
        </a>
      </Next.Link>
      // TODO: submit on enter
      <button className="my-3 px-3 py-2 bg-blue-300 w-full" onClick=login>
        {"Log in"->React.string}
      </button>
      <hr className="my-3" />
      <div className="mt-4 text-sm">
        {"Don't have an account? "->React.string}
        <Next.Link href={"/auth/sign-up"}>
          <a className="underline"> {"Sign up free"->React.string} </a>
        </Next.Link>
      </div>
    </div>
  </div>
}
