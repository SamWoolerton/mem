open Js.Array2

let nonEmptyString = s => s != ""

let getTextFromPassage = (passage: Model.passage) => {
  passage.verses->map(v => v.text)->joinWith(" ")
}

let getPassageById = (passages: array<Model.passage>, id: int) => {
  passages->find(p => p.id == id)
}

let getCustomSplitText = (str, regex: Js.Re.t) => {
  str
  ->Js.String2.splitByRe(regex)
  ->map(Js.Option.getWithDefault(""))
  ->map(String.trim)
  ->filter(nonEmptyString)
}

let getPassageForPage = (router: Next.Router.router, passages: array<Model.passage>) => {
  open Belt

  Js.Dict.get(router.query, "id")
  ->Option.flatMap(Belt.Int.fromString)
  ->Option.flatMap(id => getPassageById(passages, id))
}

let getChunksFromPassage = (passage: Model.passage) => {
  passage->getTextFromPassage->getCustomSplitText(%re("/(.+?[\.,!;:])\s/"))
}

module Array = {
  let replaceAtIndex = (
    arr: array<'a>,
    fromIndex: int,
    replaceNumber: int,
    toInsert: array<'a>,
  ) => {
    open Belt
    let before = arr->Array.keepWithIndex((_item, index) => index < fromIndex)
    let after = arr->Array.keepWithIndex((_item, index) => index >= fromIndex + replaceNumber)
    Array.concatMany([before, toInsert, after])
  }
}
