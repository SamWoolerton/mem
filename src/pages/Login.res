// TODO: don't hard-code these; also don't initialise client in this file
// Not a security risk per notes in data/test_query.js, but still need to get these from env config
let client = Supabase.createClient(
  "https://fohzkjgbdfvwyebncwoc.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyMTMxNjk4MywiZXhwIjoxOTM2ODkyOTgzfQ.iWihw5UJztoCkP7njCcaqoVcAlPxZzo606yjY9-R0N4",
)

let default = () => {
  let (username, setUsername) = React.useState(() => "")
  let (password, setPassword) = React.useState(() => "")

  let login = _evt => {
    let res = Supabase.Auth.signIn(
      client,
      {
        "email": username,
        "password": password,
      },
    )
    // TODO: utility to map over promise
    // TODO: utility to trace output for promise (and return `val` again)
    // TODO: need to model the response to handle it properly. Comes through `.then` regardless, but either `error` or `data` will be null depending on success
    // TODO: if success, redirect to homepage and store user data in global staet
    // TODO: if failure, display error message
    Js.log(Js.Promise.then_(val => {
        Js.log("SUCCESS")
        Js.log(val)
        Js.Promise.resolve(1)
      }, res))
  }

  // TODO: pull in either reform or formality to make this way cleaner
  let input = (label, val, handler) =>
    <label>
      <h3> {label->React.string} </h3>
      <input
        className="bg-gray-100"
        value=val
        onChange={evt => {
          ReactEvent.Form.preventDefault(evt)
          let val = ReactEvent.Form.target(evt)["value"]
          handler(_prev => val)
        }}
      />
    </label>

  <div>
    {input("Username", username, setUsername)}
    {
      // TODO: set type to password so it hides input by default
      input("Password", password, setPassword)
    }
    <div className="mt-2">
      <button className="px-3 py-2 bg-blue-300 inline-block" onClick=login>
        {"Log in"->React.string}
      </button>
    </div>
  </div>
}
