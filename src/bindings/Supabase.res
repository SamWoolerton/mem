type client_auth = {currentUser: Js.Nullable.t<unit>}
type client = {auth: client_auth}
type response<'d, 'e> = {
  error: Js.Nullable.t<'e>,
  data: Js.Nullable.t<'d>,
}

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
  type auth_response = response<string, auth_error>

  @send @scope("auth")
  external signUp: (client, {"email": string, "password": string}) => Js.Promise.t<auth_response> =
    "signUp"

  @send @scope("auth")
  external signIn: (client, {"email": string, "password": string}) => Js.Promise.t<auth_response> =
    "signIn"

  type signout_response = {error: Js.Nullable.t<auth_error>}
  @send @scope("auth")
  external signOut_: client => Js.Promise.t<signout_response> = "signOut"
  let signOut = router => {
    let res = signOut_(c)
    Utility.Promise.tap(res, val => {
      switch val.error->Js.Nullable.toOption {
      | None => Next.Router.push(router, "/auth/login")
      // Just ignoring error messages for now
      | Some(_err) => ()
      }
    })
  }

  @send @scope(("auth", "api"))
  external sendPasswordResetEmail: (client, string) => Js.Promise.t<string> =
    "resetPasswordForEmail"

  @send @scope(("auth", "api"))
  external resetPassword: (client, string, {"password": string}) => Js.Promise.t<string> =
    "updateUser"

  let isLoggedIn = () => c.auth.currentUser->Js.Nullable.toOption->Js.Option.isSome
}

module Data = {
  type client_from = unit

  // can't define record types inline
  type res_verse = {id: int, number: int}
  type res_language = {native_name: string}
  type res_version = {code: string, language: res_language}
  type res_book = {name: string, version: res_version}
  type res_chapter = {number: int, book: res_book}
  type res_nested_passage = {
    id: int,
    start_verse: res_verse,
    end_verse: res_verse,
    from: res_chapter,
  }

  @send external from_: (client, string) => client_from = "from"
  @send
  external select_passages_: (
    client_from,
    string,
  ) => Js.Promise.t<response<array<res_nested_passage>, string>> = "select"

  // TODO: take Recoil atom argument
  // TODO: set loading state at start and end
  let getPassages = () => {
    c
    ->from_("Passages")
    ->select_passages_(
      // TODO: Windows breaks here and inserts exponentially icnreasing new lines; format better once that's fixed
      "id, start_verse (id, number), end_verse (id, number), from:start_verse (chapter (number, book (name, version (code, language (native_name))))))",
    )
    ->Utility.Promise.map(({data}) => {
      Js.Option.getWithDefault([], data->Js.Nullable.toOption)
    })
    // TODO: remove when done
    ->Utility.Promise.trace
    ->Utility.Promise.map(arr => {
      arr->Js.Array2.map(({
        id,
        start_verse: {number: start_verse},
        end_verse: {number: end_verse},
        from: {number: chapter, book: {name: book}},
      }): Model.passage => {
        id: id,
        book: book,
        chapter: chapter,
        start_verse: start_verse,
        end_verse: end_verse,
        // TODO: fetch verses separately
        verses: [],
      })
    })
  }
}
