const { createClient } = require("@supabase/supabase-js")

async function main() {
  const supabase = createClient(
    "https://fohzkjgbdfvwyebncwoc.supabase.co",
    // public anon key so safe to commit to Git
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyMTMxNjk4MywiZXhwIjoxOTM2ODkyOTgzfQ.iWihw5UJztoCkP7njCcaqoVcAlPxZzo606yjY9-R0N4"
  )

  const res = await supabase.from("Passages").select(`
    start_verse,
    end_verse,
    from:start_verse (
      chapter (
        number,
        book ( name )
      )
    )
  `)
  const [{ start_verse, end_verse, from }] = res.data

  const book = from.chapter.book.name
  const chapter = from.chapter.number

  const meta = {
    book,
    chapter,
    start_verse,
    end_verse,
  }

  const { data: verses } = await supabase
    .from("Verses")
    .select(
      `
        number,
        text
      `
    )
    .gte("id", start_verse)
    .lte("id", end_verse)

  const verseText = verses.map(({ text }) => text)
  const wordCount = verseText.reduce((acc, t) => acc + t.split(" ").length, 0)

  const fullText = verses.map(({ text }) => text).join(" ")
  const getChunks = str =>
    str
      .split(/[\.,!;:]/g)
      .map(c => c.trim())
      .filter(c => c !== "")
  const chunks = getChunks(fullText)

  console.log("Metadata", meta)
  // console.log("verses", verses)
  console.log("Word count", wordCount)
  console.log("Chunks", chunks)
  console.log("Full text", fullText)
}

main()
