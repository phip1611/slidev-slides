# My Slidev slides

Common repository for my slides/presentations/talks using
<https://sli.dev/>.

## Open (Live Dev Server) or Build (HTML Deployment)

- `$ cd <talk>`
- Optional/once: `$ pnpm install`
- `$ pnpm run dev` to serve slides locally
- `$ pnpm run build` to build a static HTML deployment

### Nix: Static HTML Build

The project is also packaged in Nix (`flake.nix`). You can either
`$ nix build .` to get all slides or `$ nix build .#talk-<name>` to only build
a specific talk.

## Deployed Slides (Viewable Web App)

All talks defined here should appear as `<talk>.slides.phip1611.dev`.
For example:

- EuroRust 2025 Talk: <https://eurorust-2025.slides.phip1611.dev/>

Hosting done via [my NixOS server](https://github.com/phip1611/nixos-configs/blob/fd849e21c35b3e4b8569bce87ab9a5e82f4afda1/hosts/asking-alexandria/web-services/dev.phip1611.slides/default.nix).
