let default = () => {
  // let router = Next.Router.useRouter()
  // let id = Js.Dict.unsafeGet(router.query, "id")

  let chunks = [
    "And God called the dry land Earth",
    "and the gathering together of the waters called he Seas",
    "and God saw that it was good",
    "And God said",
    "Let the earth bring forth grass",
    "the herb yielding seed",
    "and the fruit tree yielding fruit after his kind",
    "whose seed is in itself",
    "upon the earth",
    "and it was so",
  ]

  let (counter, setCounter) = React.useState(_ => 0)

  let onClick = _ => {
    setCounter(prev => prev + 1)
  }

  <div>
    <h1 className="text-3xl font-semibold"> {"Tap through passage"->React.string} </h1>
    <div> {React.string(Js.String2.make(counter))} </div>
    <button onClick> {React.string("Click me")} </button>
    <div>
      {Js.Array2.mapi(chunks, (chunk, index) =>
        <span key={chunk} className="font-semibold"> {React.string(chunk)} </span>
      )->React.array}
    </div>
  </div>
}
