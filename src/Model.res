type verse = {
  id: int,
  number: int,
  text: string,
}

type passage = {
  id: int,
  language: string,
  version: string,
  book: string,
  chapter: int,
  start_verse: int,
  end_verse: int,
  verses: array<verse>,
}
