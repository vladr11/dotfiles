# dotfiles

Reasonable dotfiles for a quick setup

## Install

To quickly configure the scripts run (you must have `zsh` installed)

```zsh
./configure.zsh
```

Here, you will be asked if you want to use `tmux`. If so, tmux will be installed and set as entrypoint when you start zsh. Otherwise the `tmux`'s installation will be skipped.

### If you do not have zsh installed

#### Linux

```bash
sudo apt-get install zsh
```

#### OS X

```bash
brew install zsh
```

## Customize your configurations

### zsh

Add custom `PATH` extensions and extra initialization code inside `~/.zshrcextra`. This file will be sourced at the bottom of `~/.zshrc`.

### tmux

Modify the plugin list and the keybindings in `~/.tmux.conf`.

### vim

Modify any vim configuration in `~/.vimrc` and the plugin list in `~/.vim/plugins.vim`.

