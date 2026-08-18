# JO3T marketing site

Static one-page site for the JO3T app. Plain HTML, CSS and JavaScript — no build
step, no framework, no runtime network requests. Every asset is served from this
directory; the only external URLs in the page are `<a href>` links to the GitHub
repository.

```
website/
├── index.html
├── styles/main.css
├── scripts/ui.js
├── assets/jo3t-icon.svg
├── assets/screens/{onboarding,feed,search,place,profile,signin}.png
├── vercel.json
└── README.md
```

## Run locally

```bash
cd website
python3 -m http.server 8099
```

Then open <http://localhost:8099>. Any static file server works — there is
nothing to compile or install.

## Deploy to Vercel

### From the dashboard

1. **Add New → Project**, import the repository.
2. **Root Directory**: `website`.
3. **Framework Preset**: `Other`.
4. **Build Command**: leave empty (toggle the override off).
5. **Output Directory**: leave empty — `vercel.json` already sets it to `.`.
6. **Install Command**: leave empty.
7. **Deploy**.

### From the CLI

```bash
npm i -g vercel
cd website
vercel            # preview deployment
vercel --prod     # production deployment
```

When the CLI asks for the project settings, accept "Other" as the framework and
leave the build and install commands blank.

### What `vercel.json` does

- Pins the framework to none and the output directory to this folder, so Vercel
  serves the files as-is.
- `cleanUrls` drops the `.html` extension.
- Caches `/assets/*` for a week and sets `X-Content-Type-Options`,
  `Referrer-Policy` and `X-Frame-Options` on every response.

## Editing notes

- **Colours** are all CSS custom properties on `:root` in `styles/main.css`.
  Light values live on `:root`; dark values are duplicated in two places — a
  `prefers-color-scheme: dark` block (used before JavaScript runs and when
  JavaScript is disabled) and `:root[data-theme="dark"]` (used once the visitor
  has picked a theme).
- **Screenshots** live in `assets/screens/` at 1206×2622. Replacing one only
  requires overwriting the file — the CSS phone frame uses
  `aspect-ratio: 1206 / 2622`, so update that ratio if the source size changes.
  Update the `alt` text in `index.html` to match the new screen.
- **`scripts/ui.js`** is progressive enhancement only: theme toggle, the hero
  radar canvas, and scroll reveal. With JavaScript disabled the page still
  renders, reads and navigates correctly, and follows the OS colour scheme.
- The hero radar is hand-written Canvas 2D — no library. It stops and draws a
  single static frame when `prefers-reduced-motion: reduce` is set, and pauses
  when the tab is hidden or the canvas scrolls out of view.
