function machine_name()
{
    uname_says="$(uname -s)"
    case "${uname_says}" in
        Linux*)     machine=Linux;;
        Darwin*)    machine=Mac;;
        CYGWIN*)    machine=Cygwin;;
        MINGW*)     machine=MinGW;;
        *)          machine="UNKNOWN:${uname_says}"
    esac
    echo ${machine}
}

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec tmux
fi

source ~/.antigen/antigen.zsh

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


function mkdir_cd()
{
    mkdir $1
    cd $1
}


compose-remake()
{
    docker-compose stop $1
    docker-compose build $1
    docker-compose start $1
}

alias fstree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

if test -e $HOME/.zshrcextra; then
    . $HOME/.zshrcextra
fi

[ -f "/Users/linnify/.ghcup/env" ] && source "/Users/linnify/.ghcup/env" # ghcup-env

fd() {
	local dir
	dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}

fh() {
	eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//' )
}
