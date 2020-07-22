source ~/Documents/tools/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle tmux
antigen bundle tmuxinator
antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle pod

antigen bundle docker

antigen bundle ssh-agent

antigen bundle pip
antigen bundle python
antigen bundle virtualenv

antigen bundle kubectl

antigen bundle extract
antigen bundle history
antigen bundle jsontools
antigen bundle sublime
antigen bundle sudo


if [[ $CURRENT_OS == 'OS X' ]]; then
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle gem
    antigen bundle osx
fi

antigen apply

function battery_level()
{
    ioreg -n AppleSmartBattery -r | awk '$1~/Capacity/{c[$1]=$3} END{OFMT="%.2f%%"; max=c["\"MaxCapacity\""]; print (max>0? 100*c["\"CurrentCapacity\""]/max: "?")}'
}

function charging()
{
    ioreg -n AppleSmartBattery -r | awk '$1~/ExternalConnected/{gsub("Yes", "y");gsub("No", "n"); print substr($0, length, 1)}'
}

autoload -Uz vcs_info
autoload -U colors
setopt prompt_subst
precmd() { vcs_info }

zstyle ':vcs_info:git*' formats 'on branch %F{magenta}%b%f'

PROMPT=$'\n''%F{yellow}$(whoami)@$(hostname -s)%f in %F{cyan}%~%f ${vcs_info_msg_0_} %(?..%F{red}%?%f)'$'\n''%(?.%F{green}✔.%F{red}✘)%f  '

function cd_ls()
{
    cd $1
    ls
}

alias cd=cd_ls

function mkdir_cd()
{
    mkdir $1
    cd $1
}

alias mkdir=mkdir_cd

compose-remake()
{
    docker-compose stop $1
    docker-compose build $1
    docker-compose start $1
}

if test -e .zshrcextra; then
    . ./.zshrcextra
fi

PATH=$PATH:$HOME/Documents/tools/jenkins

export GOPATH=$HOME/go

