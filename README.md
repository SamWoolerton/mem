# Memo

An open-source Bible memory verse app, built on ReScript, NextJS and Supabase.

## Development

Run ReScript in dev mode:

```
npm run res:start
```

In another tab, run the Next dev server:

```
npm run dev
```

## Test production setup with Next

```
# Make sure to uncomment the `target` attribute in `now.json` first, before you run this:
npm run build
PORT=3001 npm start
```

## Acknowledgements

This work builds on the shoulders of giants. Particularly useful sources were:

- [ReScript/NextJS starter](https://github.com/ryyppy/rescript-nextjs-template)
- [Supabase](https://supabase.io/)
- [Bible databases repo](https://github.com/scrollmapper/bible_databases) for the KJV in CSV format
