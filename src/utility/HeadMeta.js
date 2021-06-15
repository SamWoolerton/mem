import Head from "next/head"

export default function HeadMeta(props) {
  return (
    <Head>
      <title>Mem: Memorise Bible verses quickly and easily</title>

      {/* fonts */}
      <link rel="preconnect" href="https://fonts.gstatic.com" />
      <link
        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&display=swap"
        rel="stylesheet"
      />

      {/* metadata */}
      <meta name="application-name" content="Mem" />
      <meta name="apple-mobile-web-app-capable" content="yes" />
      <meta name="apple-mobile-web-app-status-bar-style" content="default" />
      <meta name="apple-mobile-web-app-title" content="Mem" />
      <meta
        name="description"
        content="Memorise Bible verses quickly and easily"
      />
      <meta name="format-detection" content="telephone=no" />
      <meta name="mobile-web-app-capable" content="yes" />
      <meta name="msapplication-config" content="none" />
      <meta name="msapplication-TileColor" content="#5DB9ED" />
      <meta name="msapplication-tap-highlight" content="no" />
      <meta name="theme-color" content="#5DB9ED" />

      {/* icons */}
      <link
        rel="apple-touch-icon"
        href="/static/meta-icons/touch-icon-iphone.png"
      />
      <link
        rel="apple-touch-icon"
        sizes="152x152"
        href="/static/meta-icons/touch-icon-ipad.png"
      />
      <link
        rel="apple-touch-icon"
        sizes="180x180"
        href="/static/meta-icons/touch-icon-iphone-retina.png"
      />
      <link
        rel="apple-touch-icon"
        sizes="167x167"
        href="/static/meta-icons/touch-icon-ipad-retina.png"
      />

      <link
        rel="icon"
        type="image/png"
        sizes="32x32"
        href="/static/meta-icons/32x32.png"
      />
      <link
        rel="icon"
        type="image/png"
        sizes="16x16"
        href="/static/meta-icons/16x16.png"
      />
      <link rel="manifest" href="/static/manifest.json" />
      <link
        rel="mask-icon"
        href="/static/meta-icons/safari-pinned-tab.svg"
        color="#5DB9ED"
      />
      <link rel="shortcut icon" href="/favicon.ico" />

      {/* open graph */}
      <meta
        name="twitter:card"
        content="Memorise Bible verses quickly and easily"
      />
      <meta name="twitter:url" content="https://getmem.netlify.app" />
      <meta name="twitter:title" content="Mem: memorise Bible verses" />
      <meta
        name="twitter:description"
        content="Memorise Bible verses quickly and easily"
      />
      <meta
        name="twitter:image"
        content="https://getmem.netlify.app/static/meta-icons/192x192.png"
      />

      <meta property="og:type" content="website" />
      <meta property="og:title" content="Mem: memorise Bible verses" />
      <meta
        property="og:description"
        content="Memorise Bible verses quickly and easily"
      />
      <meta property="og:site_name" content="Mem" />
      <meta property="og:url" content="https://getmem.netlify.app" />
      <meta
        property="og:image"
        content="https://getmem.netlify.app/static/meta-icons/192x192.png"
      />

      {/* manifest & PWA */}
      <link
        rel="apple-touch-startup-image"
        href="/static/images/apple_splash_2048.png"
        sizes="2048x2732"
      />
      <link
        rel="apple-touch-startup-image"
        href="/static/images/apple_splash_1668.png"
        sizes="1668x2224"
      />
      <link
        rel="apple-touch-startup-image"
        href="/static/images/apple_splash_1536.png"
        sizes="1536x2048"
      />
      <link
        rel="apple-touch-startup-image"
        href="/static/images/apple_splash_1125.png"
        sizes="1125x2436"
      />
      <link
        rel="apple-touch-startup-image"
        href="/static/images/apple_splash_1242.png"
        sizes="1242x2208"
      />
      <link
        rel="apple-touch-startup-image"
        href="/static/images/apple_splash_750.png"
        sizes="750x1334"
      />
      <link
        rel="apple-touch-startup-image"
        href="/static/images/apple_splash_640.png"
        sizes="640x1136"
      />
    </Head>
  )
}
