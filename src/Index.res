module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>
}

let default = () =>
  <div>
    <h1 className="text-3xl font-semibold"> {"Your passages"->React.string} </h1>
    <P> {React.string(`Example paragraph about passages`)} </P>
  </div>
