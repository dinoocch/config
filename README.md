# First time setup

## Install Nix

```zsh
sh <(curl -L https://nixos.org/nix/install)
```

## Enable Flakes

```zsh
nix-env -iA nixpkgs.nixFlakes
```

Add the following to `/etc/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

## Install home-manager


First add the channel:

```zsh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

On single-user linux I had to export a variable:

```zsh
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
```

For darwin, I had to add:

```zsh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
nix-channel --update

export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
```

Then install home-manager:

```zsh
nix-shell '<home-manager>' -A install
```

