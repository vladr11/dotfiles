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
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ "$WARP_IS_LOCAL_SHELL_SESSION" != 1 ]; then
    exec tmux
fi

source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle tmux
antigen bundle tmuxinator
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle Aloxaf/fzf-tab
antigen bundle poetry

antigen bundle docker

antigen bundle ssh-agent

antigen bundle pip
antigen bundle python
antigen bundle virtualenv

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

get_prompt_hostname()
{
	if [ -n "$IN_NIX_SHELL" ]; then
		print "nix";
	else
		print $(hostname -s)
	fi
}

PROMPT=$'\n''%F{yellow}$(whoami)@$(get_prompt_hostname)%f in %F{cyan}%~%f ${vcs_info_msg_0_} %(?..%F{red}%?%f)'$'\n''%(?.%F{green}✔.%F{red}✘)%f  '

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

alias dcd="docker compose -f dev.docker-compose.yml"

function set_cwd_to_window() {
	local current_session_name=$(tmux display-message -p '#S')
	local current_window_index=$(tmux display-message -p '#I')

	tmux send-keys -t $current_session_name:$current_window_index 'export TMUX_CWD=$(PWD)' C-m
}

alias scwd="set_cwd_to_window"

if [[ -n "$TMUX" && -n "$TMUX_CWD" ]]; then
	cd "$TMUX_CWD"
fi

export PATH=${HOME}/go/bin:${PATH}

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:${PATH}

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export PATH=${HOME}/Workspace/tools/jwt/:${PATH}

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

if (( $+commands[fzf] )); then
	eval "$(fzf --zsh)"
fi

eval "$(zoxide init zsh)"

# tmuxifier
export PATH=$PATH:$HOME/.tmux/plugins/tmuxifier/bin
eval "$(tmuxifier init -)"
alias t="tmuxifier"

new_code_window() {
	local name=$1
	local root=$2
	ROOT=$root NAME=$name tmuxifier load-window code
}

new_wom_window() {
	new_code_window wom $HOME/Workspace/polestar/aftermarket-work-order-management
}

split_window() {
	if [[ -n "$1" ]]; then
		tmux split-window -h -c $1
	else
		tmux split-window -h -c $PWD
	fi
}

export EDITOR='nvim'

export PATH=${PATH}:${HOME}/.local/bin

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/vladrusu/.lmstudio/bin"
