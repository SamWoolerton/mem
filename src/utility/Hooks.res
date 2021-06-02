let usePassage = () => {
  let router = Next.Router.useRouter()
  let passages = Recoil.useRecoilValue(State.passages)
  let passage = Utility.getPassageForPage(router, passages)

  passage
}
