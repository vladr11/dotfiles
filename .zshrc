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
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle poetry

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

ZSH_AUTOSUGGEST_STRATEGY=(completion history)

autoload -Uz vcs_info
autoload -U colors
setopt prompt_subst
precmd() { vcs_info }

zstyle ':vcs_info:git*' formats 'on branch %F{magenta}%b%f'

PROMPT=$'\n''%F{yellow}$(whoami)@$(hostname -s)%f in %F{cyan}%~%f ${vcs_info_msg_0_} %(?..%F{red}%?%f)'$'\n''%(?.%F{green}✔.%F{red}✘)%f  '

compose-remake()
{
    docker-compose stop $1
    docker-compose build $1
    docker-compose start $1
}

alias fstree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

fd() {
	local dir
	dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}

fh() {
	CMD=$( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//' )
	eval $CMD
	print -sr -- "${CMD}"
}

function zshaddhistory() {
	emulate -L zsh
	if ! [[ "$1" =~ "fh" ]]; then
		print -sr -- "${1%%$'\n'}"
	else
		return 1
	fi
}

search_git_lost_found() {
	git fsck --lost-found | awk '{ split($0, a, " "); if (a[2] == "commit") print(a[3]) }' | xargs git show --shortstat
}

export PATH=${HOME}/.rbenv/shims:${PATH}
eval "$(rbenv init -)"

export PATH=${HOME}/.pyenv/shims:${PATH}
export PATH=${HOME}/.pyenv/bin:${PATH}
eval "$(pyenv init -)"

export PATH=${HOME}/go/bin:${PATH}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vladrusu/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vladrusu/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vladrusu/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vladrusu/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
export PATH=/Users/vladrusu/Downloads/google-cloud-sdk/bin:${PATH}
