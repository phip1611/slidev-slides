# My Slidev slides

Common repository for my slides/presentations/talks using
<https://sli.dev/>.

## Open (Live Dev Server) or Build (HTML Deployment)

- `$ cd <talk>`
- `$ npm run dev` to serve slides locally
- `$ npm run build` to build a static HTML deployment

### Nix: Static HTML Build

The project is also packaged in Nix (`flake.nix`). You can either
`$ nix build .` to get all slides or `$ nix build .#talk-<name>` to only build
a specific talk.

## Deployed Slides (Viewable Web App)

All talks defined here should appear as `<talk>.slides.phip1611.dev`.
For example:

- EuroRust 2025 Talk: <https://eurorust-2025.slides.phip1611.dev/>

Hosting information: <https://github.com/phip1611/nixos-configs/pull/264>
