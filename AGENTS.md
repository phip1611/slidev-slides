# Project Agent Instructions

## Project Shape

- This repository contains independent Slidev decks, one directory per talk.
- There is no root `package.json`; run `pnpm` commands inside the deck you are
  changing.
- Root Nix files build all decks and individual `talk-<slug>` packages.
- Keep changes scoped to the affected talk unless updating shared root build
  wiring.

## Common Commands

- Enter the dev shell when tooling is missing: `nix develop`.
- Install dependencies for one deck: `cd <talk> && pnpm install`.
- Install dependencies for all decks: `nix run .#installAllPnpmDeps`.
- Develop one deck: `cd <talk> && pnpm run dev`.
- Build one deck with Slidev: `cd <talk> && pnpm run build`.
- Build all static deployments: `nix build .#combined`.
- Build one static deployment: `nix build .#talk-<slug>`.
- Run the same broad checks as CI when practical: `nix flake check -L`,
  `nix flake show -L`, `nix build -L .#combined`, and `typos .`.

## Deck Conventions

- Main deck metadata and slide inclusion live in `<talk>/slides.md`.
- Larger decks split content into `<talk>/pages/*.md`; keep file and slide
  numbering consistent.
- Components, styles, and assets are deck-local by default.
- Treat each deck as standalone in theme, style, and content.
- It is okay to copy useful content from other talks, such as images or
  recurring information about me.
- Prefer existing Slidev layouts, components, and CSS patterns from the deck.
- Keep presentation text concise and scannable. Avoid speaker-note style prose
  on slides unless the existing deck already uses it.
- Prefer bullet points inside `<v-clicks depth="2">` for typical reveal lists.

## Dependencies and Nix

- Each deck owns its own `package.json`, `pnpm-lock.yaml`, and dependency
  versions.
- If dependencies or lockfiles change, update the deck's `depHash` in
  `flake.nix` and verify the matching Nix package builds.
- When adding a new deck, add it to `projectDefs` in `flake.nix` with a stable
  deployment `slug` and talk `title`.
- Do not commit generated `dist/`, `result*`, `.pnpm-store`, or `.direnv`
  output.

## Style

- Follow `.editorconfig`: UTF-8, LF endings, final newline, spaces with
  2-space indentation, and 80-column text where reasonable.
- Use plain apostrophes and hyphens in Markdown and code comments.
- Keep comments sparse; prefer clear slide text, component names, and CSS class
  names over explanatory comments.
