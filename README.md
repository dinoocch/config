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

# Add cachix

```zsh
nix-env -iA cachix -f https://cachix.org/api/v1/install
cahix use nix-community
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

## Making changes

First, make any changes needed to this repository.
Note: when testing changes and adding new files, nix will only include those tracked by git!
So be sure to `git add -A` first...

Then to apply changes:
```
home-manager switch --flake .
```

To install updates to packages/overlays/flake/etc:

```
nix flake update
```

## Neovim Treesitter Errors with cpp

Some cpp errors due to missing c++ and nix :/

Probably there's some nix-y way to solve this with the nixpkgs, but idk how to do that.

```
# From neovim, uninstall grammars
:TSUinstall all

# Execute a nix shell with cpp
nix-shell -p gcc

# Run nvim and install grammars again
nvim
:TSInstall all
```
