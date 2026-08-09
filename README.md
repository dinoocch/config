<h2 align="center">:snowflake: Just another nix config repo :snowflake:</h2>

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="400" />
</p>

I have no idea what I am doing :)

## Structure

This flake follows the [dendritic pattern](https://github.com/mightyiam/dendritic):
every `.nix` file under `modules/` and `hosts/` (except paths starting with
`_`) is automatically imported as a top-level
[flake-parts](https://flake.parts) module via
[`import-tree`](https://github.com/vic/import-tree). `flake.nix` is the only
entry point.

- `modules/moduleOptions.nix` declares two merge points:
  - `nixos.modules.<name>` — named, mergeable NixOS modules
  - `homeManager.modules.<name>` — named, mergeable home-manager modules
- `modules/nixos/*.nix` and `modules/home/*.nix` each contribute to a named
  bucket: `base` (universal settings/host-specific toggles), `desktop`
  (GUI-only features, gated on `dino.gui.enable`), or `server`
  (server-only features, gated on `dino.server.enable`). Every host
  currently composes `base` + `desktop` + `server` (identical to the old
  everything-in-`base` behavior), but the split allows a host to later opt
  out of a bucket it never needs (e.g. a headless server skipping
  `desktop`). Fine-grained gating within each file is still done via the
  `dino.*` options declared in `modules/_lib/dinoOptions.nix`.
- `modules/colmena.nix` declares `colmena.hosts.<name>` and assembles
  `flake.colmena` from it.
- `modules/nixosConfigurations.nix` declares `nixos.hosts.<name>` and
  assembles `flake.nixosConfigurations` from it, centralizing the
  `_lib/nixosSystem.nix` call so host files only declare *which* modules to
  compose, not *how* to build a `nixosSystem`.
- `modules/specialArgs.nix` declares `meta.{username,userfullname,useremail,
  linuxSpecialArgs}` — flake-wide identity/specialArgs shared by every Linux
  host. This is a deliberately distinct namespace from the nested `dino.*`
  feature-toggle options (declared in `modules/_lib/dinoOptions.nix`), which
  live inside separate NixOS/home-manager evaluations.
- `hosts/<host>/default.nix` declares host-specific NixOS settings under
  `nixos.modules.<host>`, and wires up `nixos.hosts.<host>`
  and/or `colmena.hosts.<host>` from `nixos.modules.base` +
  `nixos.modules.desktop` + `nixos.modules.server` + `nixos.modules.<host>`.
- `hosts/<host>/home.nix` declares that host's home-manager overrides under
  `homeManager.modules.<host>`.
- `modules/_lib/` holds plain (non-flake-parts) helpers — `nixosSystem.nix`,
  `colmenaSystem.nix` and `dinoOptions.nix` — excluded from auto-import
  because their paths contain `_`. Files named `_hardware-configuration.nix`
  under `hosts/` are excluded the same way, since they're plain NixOS
  hardware-scan output, not features to compose.

