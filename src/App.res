// This type is based on the getInitialProps return value.
// If you are using getServerSideProps or getStaticProps, you probably will never need this
// See https://nextjs.org/docs/advanced-features/custom-app

type pageProps

module PageComponent = {
  type t = React.component<pageProps>
}

type props = {
  @as("Component")
  component: PageComponent.t,
  pageProps: pageProps,
}

// We are not using `@react.component` since we will never use <App/> within our ReScript code.
// It's only used within `pages/_app.js`

let default = (props: props): React.element => {
  // immediately redirect to login page if not logged in
  let router = Next.Router.useRouter()
  React.useEffect0(() => {
    let isAuthRoute = router.route->Js.String2.startsWith("/auth/")
    if !Supabase.Auth.isLoggedIn() && !isAuthRoute {
      Next.Router.push(router, "/auth/login")
    }
    None
  })

  let {component, pageProps} = props
  let content = React.createElement(component, pageProps)

  <MainLayout> <Recoil.RecoilRoot> content </Recoil.RecoilRoot> </MainLayout>
}
