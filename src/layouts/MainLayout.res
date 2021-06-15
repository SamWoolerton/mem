module Link = Next.Link

module Navigation = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let darkMode = Hooks.usePrefersDarkMode()

    <nav className="p-2 h-12 text-sm bg-foreground">
      <div className="max-w-5xl lg:w-3/4 mx-auto flex justify-between items-center">
        <Link href="/">
          <a className="flex items-center w-1/3">
              className="w-5" src={`/static/meta-icons/logo-${darkMode ? "white" : "black"}.svg`}
            <span className="text-xl ml-2 align-middle font-semibold"> {React.string("Mem")} </span>
          </a>
        </Link>
        <div className="flex w-2/3 justify-end">
          <Link href="/passages"> <a className="px-3"> {React.string("Passages")} </a> </Link>
          {Supabase.Auth.isLoggedIn()
            ? <div
                className="cursor-pointer" onClick={evt => {Supabase.Auth.signOut(router)->ignore}}>
                {"Log out"->React.string}
              </div>
            : <Link href="/auth/login"> <a className="px-3"> {React.string("Log in")} </a> </Link>}
        </div>
      </div>
    </nav>
  }
}

@react.component
let make = (~children) => {
  let router = Next.Router.useRouter()
  let isAuthRoute = router.route->Js.String2.startsWith("/auth/")

  let minWidth = ReactDOM.Style.make(~minWidth="20rem", ())

  <div style=minWidth>
    <div className="w-full text-gray-900 font-base h-screen flex flex-col">
      {!isAuthRoute ? <Navigation /> : React.null}
      <main className="h-full max-w-5xl w-full lg:w-3/4 mx-auto"> children </main>
    </div>
  </div>
}
