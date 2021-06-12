type status<'a> =
  | Loading
  | Stored('a)

let default_passages: status<array<Model.passage>> = Stored([
  {
    id: 1,
    book: "Genesis",
    chapter: 1,
    // TODO: update query so this is the verse number, not verse ID
    start_verse: 1,
    end_verse: 10,
    verses: [
      {
        id: 1,
        text: `In the beginning God created the heaven and the earth.`,
      },
      {
        id: 2,
        text: `And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.`,
      },
      {
        id: 3,
        text: `And God said, "Let there be light": and there was light.`,
      },
      {
        id: 4,
        text: `And God saw the light, that it was good: and God divided the light from the darkness.`,
      },
      {
        id: 5,
        text: `And God called the light Day, and the darkness he called Night. And the evening and the morning were the first day.`,
      },
      {
        id: 6,
        text: `And God said, Let there be a firmament in the midst of the waters, and let it divide the waters from the waters.`,
      },
      {
        id: 7,
        text: `And God made the firmament, and divided the waters which were under the firmament from the waters which were above the firmament: and it was so.`,
      },
      {
        id: 8,
        text: `And God called the firmament Heaven. And the evening and the morning were the second day.`,
      },
      {
        id: 9,
        text: `And God said, Let the waters under the heaven be gathered together unto one place, and let the dry land appear: and it was so.`,
      },
      {
        id: 10,
        text: `And God called the dry land Earth; and the gathering together of the waters called he Seas: and God saw that it was good.`,
      },
      {
        id: 11,
        text: `And God said, "Let the earth bring forth grass, the herb yielding seed, and the fruit tree yielding fruit after his kind, whose seed is in itself, upon the earth": and it was so.`,
      },
    ],
  },
])

let passages = Recoil.atom({
  key: "passages",
  default: default_passages,
})
