TMUX_PROMPT="Do you want to use terminal with tmux?"

function get_tmux_option()
{
    echo $TMUX_PROMPT
    select yn in "Yes" "No"; do
        case $yn in
            Yes)
                export WANTS_TMUX=1
                break
                ;;
            No) 
                export WANTS_TMUX=0
                break
                ;;
        esac
    done
}

function configure_osx()
{
    get_tmux_option

    # Install Homebrew if does not exist
    if ! type "$brew" > /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    if [ $WANTS_TMUX -eq 1 ]; then
        brew update
        brew install tmux
        brew link tmux
    fi
}

function configure_linux()
{
    get_tmux_option

    if [ $WANTS_TMUX -eq 1 ]; then
        sudo apt-get install tmux
    fi
}

uname_says="$(uname -s)"
case "${uname_says}" in
    Linux*)
        configure_linux
        ;;
    Darwin*)
        configure_osx
        ;;
    *)
        echo "Won't configure non-Unix machines because of my stubborness..."
        exit 1
        ;;
esac

# Copy antigen.zsh into ~/.antigen
cp ./antigen.zsh $HOME/.antigen

zsh $HOME/.antigen/antigen.zsh

if [ $WANTS_TMUX -eq 1 ]; then
    cp .zshrc .vimrc .tmux.conf $HOME
else
    cp .zshrc .vimrc $HOME
fi

