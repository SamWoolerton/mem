open Js.Array2

let default = () => {
  let passage = Hooks.usePassage()
  let router = Next.Router.useRouter()
  let (counter, setCounter) = React.useState(_ => -1)

  switch passage {
  | Loading => <div> {"Loading..."->React.string} </div>
  | None => {
      Next.Router.push(router, "/passages")
      <div> {"Passage not found"->React.string} </div>
    }
  | Some(p) => {
      let words = Utility.getWordsFromPassage(p)
      let backlink = contents =>
        <Next.Link href={`/passages/${p.id->Belt.Int.toString}`}> <a> contents </a> </Next.Link>
      let doneButton = if true {
        backlink("Return to passage"->React.string)
      } else {
        React.null
      }

      let onKeyDown = evt => {
        let key = ReactEvent.Keyboard.key(evt)          
        let firstChar = words[counter+1]->Js.String2.charAt(0)
        //ReactEvent.Keyboard.preventDefault(evt)

        switch key == firstChar {
          | true => setCounter(prev => prev + 1)
          | false => Js.Console.log(key)
        }
      }

      <div onKeyDown tabIndex=0 className="h-full">
        <input type_="text" />
        {backlink(<div className="mt-2"> {"Back"->React.string} </div>)}
        <h1 className="text-3xl font-semibold mt-1"> {"Type out passage"->React.string} </h1>
        <div className="select-none mb-4">
          {filteri(words, (_word, index) => index <= counter)
          ->mapi((word, i) =>
            <span key={`${i->Belt.Int.toString}-${word}}`}> {React.string(`${word} `)} </span>
          )
          ->React.array}
        </div>
        doneButton
      </div>
    }
  }
}
