open Js.Array2

let getChunksFromText = str => {
  let nonEmpty = s => s != ""

  str
  ->Js.String2.splitByRe(%re("/(.+?[\.,!;:])\s/"))
  ->map(Js.Option.getWithDefault(""))
  ->map(String.trim)
  ->filter(nonEmpty)
}

let getTextFromPassage = (passage: Model.passage) => {
  passage.verses->map(v => v.text)->joinWith(" ")
}

let getChunksFromPassage = (passage: Model.passage) => {
  getTextFromPassage(passage)->getChunksFromText
}

let getPassageById = (passages: array<Model.passage>, id: int) => {
  passages->find(p => p.id == id)
}

// if anything goes wrong, redirect to the passages list
let getPassageForPage = (router: Next.Router.router, passages: array<Model.passage>) => {
  open Belt

  Js.Dict.get(router.query, "id")
  ->Option.flatMap(Belt.Int.fromString)
  ->Option.flatMap(id => getPassageById(passages, id))
}
