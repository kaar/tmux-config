# tmux-config

This repository is broken out from my [dotfiles](https://githuh.com/kaar/dotfiles).

## Install

```sh
git clone https://github.com/kaar/tmux-config $HOME/.config/tmux
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm
# Then: prefix + I to install plugins
```

## Related
- https://github.com/kaar/dotfiles
- https://github.com/kaar/nvim-config

## TODO

Add install script that does the install for me.
```sh
curl -LsSf https://......./install.sh | sh
```

__SHOULD__

- backup existing tmux config if exists.
- clone this repo to the right location.
- clone tpm to the right location.
- run tpm install command.

## Inspirations
- https://github.com/joshuadanpeterson/tmux-config
