import "styles/main.css"

// Note: just renaming $$default to ResApp alone doesn't help FastRefresh to detect the React component, since an alias isn't attached to the original React component function name.
import ResApp from "src/App.mjs"
import HeadMeta from "../src/utility/HeadMeta"

// Per https://dev.to/apkoponen/how-to-disable-server-side-rendering-ssr-in-next-js-1563
// Entire app is behind a login so no SEO benefits
// Rrequired to make routing work easily in components (otherwise first render will be undefined)
const SafeHydrate = ({ children }) => (
  <div suppressHydrationWarning>
    {typeof window === "undefined" ? null : children}
  </div>
)

// Note: we need to wrap the make call with a Fast-Refresh conform function name, (in this case, uppercased first letter)
// If you don't do this, your Fast-Refresh will not work!
export default function App(props) {
  return (
    <div>
      <HeadMeta />
      <SafeHydrate>
        <ResApp {...props} />
      </SafeHydrate>
    </div>
  )
}
