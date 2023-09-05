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

eval "$(/opt/homebrew/bin/brew shellenv)";
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

export NVM_COMPLETION=true
antigen bundle lukechilds/zsh-nvm

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

bda() {
	git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

bd() {
	if [[ ${#@} -eq 0 ]]; then
		bda
	else
		bat --diff $@
	fi
}

alias dcd="docker-compose -f dev.docker-compose.yml"

export PATH=${HOME}/.rbenv/shims:${PATH}
eval "$(rbenv init -)"

export PATH=${HOME}/.pyenv/shims:${PATH}
export PATH=${HOME}/.pyenv/bin:${PATH}
eval "$(pyenv init -)"

export PATH=${HOME}/go/bin:${PATH}

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vladrusu/Workspace/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vladrusu/Workspace/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vladrusu/Workspace/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vladrusu/Workspace/tools/google-cloud-sdk/completion.zsh.inc'; fi

source <(minikube completion zsh)
source <(kubectl completion zsh)
source <(helm completion zsh)
export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:${PATH}
export PATH=$PATH:$HOME/zig

#export NVM_DIR=~/.nvm
#source $(brew --prefix nvm)/nvm.sh

getComputeEngineExternalIP() {
	INSTANCE_NAME=$1
	ZONE=$2
	
	gcloud compute instances describe ${INSTANCE_NAME} --zone=${ZONE} --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
}

export DEFAULT_INSTANCE_NAME=workspace
export DEFAULT_ZONE=europe-west3-c

getDefaultComputeEngineExternalIP() {
	getComputeEngineExternalIP ${DEFAULT_INSTANCE_NAME} ${DEFAULT_ZONE}
}
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
