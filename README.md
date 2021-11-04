# dotfiles

Reasonable dotfiles for a quick setup

## Install

To quickly configure the scripts run (you must have `make` installed)

### Arch Linux

```shell
make arch
```

### OS X

```bash
make osx
```

## Customize your configurations

### zsh

Add custom `PATH` extensions and extra initialization code inside `~/.zshrcextra`. This file will be sourced at the bottom of `~/.zshrc`.

### tmux

Modify the plugin list and the keybindings in `~/.tmux.conf`.

### vim

Modify any vim configuration in `~/.vimrc` and the plugin list in `~/.vim/plugins.vim`.

