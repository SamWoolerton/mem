// https://github.com/jhchen/fast-diff

type diff =
  | Remove(string)
  | Add(string)
  | Keep(string)

@module external raw: (string, string) => array<(int, string)> = "fast-diff"

let diff = (a: string, b: string) => {
  let r = raw(a, b)

  r->Js.Array2.map(pair => {
    switch pair {
    | (-1, s) => Remove(s)
    | (1, s) => Add(s)
    // will always be 0
    | (_, s) => Keep(s)
    }
  })
}
