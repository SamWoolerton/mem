type verse = {
  id: int,
  text: string,
}

type passage = {
  id: int,
  book: string,
  chapter: int,
  start_verse: int,
  end_verse: int,
  verses: array<verse>,
}

type word = {
  text: string,
  visible: bool,
}