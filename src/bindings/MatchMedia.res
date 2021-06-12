type queryListItem = {matches: bool}
// type queryList = array<queryListItem>
type queryList = queryListItem

@val external query: string => queryList = "matchMedia"
@send external addListener: (queryList, queryList => unit) => unit = "addListener"
@send external removeListener: (queryList, queryList => unit) => unit = "removeListener"
