# My Talks + Slidev Slides

Common repository for my slides/presentations/talks using
<https://sli.dev/>.

## Deployed Slides (Viewable on the Web)

All talk slides defined here will appear at
`https://<talk>.slides.phip1611.dev`.

For example:

- EuroRust 2025: <https://eurorust-2025.slides.phip1611.dev/>

Hosting is done via
[my NixOS-based Linux server](https://github.com/phip1611/nixos-configs/blob/fd849e21c35b3e4b8569bce87ab9a5e82f4afda1/hosts/asking-alexandria/web-services/dev.phip1611.slides/default.nix).

## Building / Local Development

### Context

To locally build and serve the slides, you need `nodejs` and `pnpm`. They will
run the `slidev` utility. Without that, you **will not** be able to use all the
magic including live reload of the spawned dev server, the on-page editor, etc.

_Hint: The Nix shell gives you everything you need._

_Hint: `npm` would also work as replacement for `pnpm`, but in this project I
decided to use `pnpm`. `deno` might also work as `nodejs` replacement.)._

The Nix build provided by this project's Flake is only suited for static
deployments, not for local development!

### Local Development

- `$ cd <talk>`
- Optional/once: Enter the Nix shell
- Optional/once: `$ pnpm install`
- `$ pnpm run dev` to develop and serve slides locally
- `$ pnpm run build` to build a static HTML deployment

### Nix: Static HTML Build + Serve

The project is also packaged in Nix (`flake.nix`). You can either
`$ nix build .` to get all slides or `$ nix build .#talk-<name>` to only build
a specific talk. The result is a static build of HTML, CSS, JS, and specified
public resources (images, fonts).

You may locally serve that using \
`$ nix run nixpkgs#simple-http-server -- --index -- $(nix build --print-out-paths .#talk-<name>)`

