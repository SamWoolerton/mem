type client_auth = {currentUser: Js.Nullable.t<unit>}
type client = {auth: client_auth}

// E.g. createClient('https://xyzcompany.supabase.co', 'public-anon-key')
@module("@supabase/supabase-js")
external createClient: (string, string) => client = "createClient"

// TODO: Not a security risk per notes in data/test_query.js, but still need to get these from env config
let c = createClient(
  "https://fohzkjgbdfvwyebncwoc.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyMTMxNjk4MywiZXhwIjoxOTM2ODkyOTgzfQ.iWihw5UJztoCkP7njCcaqoVcAlPxZzo606yjY9-R0N4",
)

// TODO: is there a way to use the client defined below instead of having to pass it every time?
module Auth = {
  type auth_error = {message: string, status: int}
  type auth_response = {
    error: Js.Nullable.t<auth_error>,
    data: Js.Nullable.t<string>,
  }

  @send @scope("auth")
  external signUp: (client, {"email": string, "password": string}) => Js.Promise.t<auth_response> =
    "signUp"

  @send @scope("auth")
  external signIn: (client, {"email": string, "password": string}) => Js.Promise.t<auth_response> =
    "signIn"

  @send @scope(("auth", "api"))
  external sendPasswordResetEmail: (client, string) => Js.Promise.t<string> =
    "resetPasswordForEmail"

  @send @scope(("auth", "api"))
  external resetPassword: (client, string, {"password": string}) => Js.Promise.t<string> =
    "updateUser"

  let isLoggedIn = () => c.auth.currentUser->Js.Nullable.toOption->Js.Option.isSome
}
