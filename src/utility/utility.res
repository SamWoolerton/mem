let getChunks = str => {
  open Js.Array2
  let nonEmpty = s => s != ""

  str
  ->Js.String2.splitByRe(%re("/[\.,!;:]/"))
  ->map(Js.Option.getWithDefault(""))
  ->map(String.trim)
  ->filter(nonEmpty)
}
