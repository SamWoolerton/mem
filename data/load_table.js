const { createReadStream } = require("fs")
const csv = require("csv-parser")
const { createClient } = require("@supabase/supabase-js")

async function loadCSV(path) {
  const results = []
  return new Promise(resolve =>
    createReadStream(path)
      .pipe(csv())
      .on("data", data => results.push(data))
      .on("end", () => resolve(results))
  )
}

async function load() {
  //   const books_base = await loadCSV("./data/kjv/books.csv")
  // const chapters_base = await loadCSV("./data/kjv/chapters.csv")
  const verses_base = await loadCSV("./data/kjv/verses.csv")

  const supabase = createClient(
    "https://fismpnesaaiuvklctjqh.supabase.co",
    // public anon key so safe to commit to Git
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyMTIzNTMwNCwiZXhwIjoxOTM2ODExMzA0fQ.stWtUi-RZS9dDN3aRctpDgpsMQpn5kcEez2zfqkb_t8"
  )

  // const { data, error } = await supabase.from("Books").insert(books_base)
  // const { data, error } = await supabase.from("Chapters").insert(chapters_base)
  const { data, error } = await supabase.from("Verses").insert(verses_base)

  console.log("data", data)
  console.log("error", error)

  // split out chapters
  // load chapters
  // load verses
}

load()
