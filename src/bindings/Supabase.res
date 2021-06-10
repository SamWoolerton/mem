// TODO: Replace with an abstract type?
type client = unit

// E.g. createClient('https://xyzcompany.supabase.co', 'public-anon-key')
@module("@supabase/supabase-js")
external createClient: (string, string) => client = "createClient"

module Auth = {
  @send @scope("auth")
  external signUp: (client, {"email": string, "password": string}) => Js.Promise.t<string> =
    "signUp"

  @send @scope("auth")
  external signIn: (client, {"email": string, "password": string}) => Js.Promise.t<string> =
    "signIn"

  @send @scope(("auth", "api"))
  external sendPasswordResetEmail: (client, string) => Js.Promise.t<string> =
    "resetPasswordForEmail"

  @send @scope(("auth", "api"))
  external resetPassword: (client, string, {"password": string}) => Js.Promise.t<string> =
    "updateUser"
}
