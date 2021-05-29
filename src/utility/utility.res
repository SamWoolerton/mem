let getChunksFromText = str => {
  open Js.Array2
  let nonEmpty = s => s != ""

  str
  ->Js.String2.splitByRe(%re("/(.+?[\.,!;:])\s/"))
  ->map(Js.Option.getWithDefault(""))
  ->map(String.trim)
  ->filter(nonEmpty)
}

let getChunksFromVerses = verses => {
  ""
}
