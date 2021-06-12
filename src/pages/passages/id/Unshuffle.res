open Js.Array2

type chunkPositions = array<(int, int)>

type chunk = {
  text: string,
  positions: chunkPositions,
}

let mergeChunks = (first: chunk, second: chunk, positions: chunkPositions) => {
  {text: first.text ++ second.text, positions: positions}
}

// iterate through both arrays at the same time, which runs in O(N)
// TODO: probably a nicer way to structure this; recursion instead of the mutable refs
let checkMergeChunks = (first: chunk, second: chunk) => {
  open Belt

  let firstCursor = ref(0)
  let secondCursor = ref(0)
  let matches = ref([])
  let break = ref(false)

  while !break.contents {
    switch first.positions[firstCursor.contents] {
    | None => break := true
    | Some(firstStart, firstEnd) =>
      switch second.positions[secondCursor.contents] {
      | None => break := true
      | Some(secondStart, secondEnd) =>
        // both cursors are valid, so check for a match
        if firstEnd + 1 === secondStart {
          // add position to list of matches and increment both cursors
          matches := Array.concat(matches.contents, [(firstStart, secondEnd)])
          firstCursor := firstCursor.contents + 1
          secondCursor := secondCursor.contents + 1
        } else if firstEnd < secondStart {
          // increment smaller cursor
          firstCursor := firstCursor.contents + 1
        } else {
          secondCursor := secondCursor.contents + 1
        }
      }
    }
  }

  if Array.length(matches.contents) > 0 {
    Some(matches.contents)
  } else {
    None
  }
}

let handlePairMerge = (
  arr: array<chunk>,
  firstIndex: int,
  first: option<chunk>,
  second: option<chunk>,
) => {
  open Belt

  switch (first, second) {
  | (None, _) => arr
  | (_, None) => arr
  | (Some(f), Some(s)) =>
    switch checkMergeChunks(f, s) {
    | None => arr
    | Some(positions) => {
        let newChunk = mergeChunks(f, s, positions)
        Utility.Array.replaceAtIndex(arr, firstIndex, 2, [newChunk])
      }
    }
  }
}

let handleMerge = (arr: array<chunk>, index: int) => {
  open Belt

  let before = arr[index - 1]
  let at = arr[index]
  let after = arr[index + 1]

  arr->handlePairMerge(index - 1, before, at)->handlePairMerge(index, at, after)
}

let default = () => {
  let passage = Hooks.usePassage()
  let router = Next.Router.useRouter()

  switch passage {
  | Loading => <div> {"Loading..."->React.string} </div>
  | None => {
      Next.Router.push(router, "/passages")
      <div> {"Passage not found"->React.string} </div>
    }
  | Some(p) => {
      let chunks = Utility.getChunksFromPassage(p)

      // original indices for each chunk
      let indices = chunks->reducei((acc, next_chunk, next_index) => {
        open Belt.Map.String
        let current = Js.Option.getWithDefault([], get(acc, next_chunk))
        set(acc, next_chunk, append(current, next_index))
      }, Belt.Map.String.empty)

      // state with shuffled chunks
      // let shuffled = chunks->Belt.Array.shuffle->map(c => (c, indices->Belt.Map.String.getExn(c)))

      // TODO: drag and drop (re-dnd), which reorders the shuffled array
      // TODO: at the start, check for any shuffled chunks to merge immediately
      // TODO: check completion (list length 1?)

      let backlink = contents =>
        <Next.Link href={`/passages/${p.id->Belt.Int.toString}`}> <a> contents </a> </Next.Link>
      // let doneButton = if counter >= length(chunks) {
      //   backlink("Return to passage"->React.string)
      // } else {
      //   React.null
      // }

      <div className="h-full">
        <div className="mt-2"> {backlink(<div> {"Back"->React.string} </div>)} </div>
        <h1 className="text-3xl font-semibold mt-1"> {"Unshuffle passage"->React.string} </h1>
        <div className="mt-4">
          {mapi(chunks, (chunk, i) =>
            <div key={`${i->Belt.Int.toString}-${chunk}}`} className="my-1 py-1 px-2 bg-foreground">
              {React.string(`${chunk} `)}
            </div>
          )->React.array}
        </div>
        // doneButton
      </div>
    }
  }
}
