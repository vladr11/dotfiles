#!/usr/bin/env zsh

TMUX_PROMPT="Do you want to use terminal with tmux?"
VIM_PROMPT="Are you a vim user? Do you want vim to be a full feature editor?"

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

function get_vim_option()
{
    echo $VIM_PROMPT
    select yn in "Yes" "No"; do
        case $yn in
            Yes)
                export WANTS_VIM=1
                break
                ;;
            NO)
                export WANTS_VIM=0
                break
                ;;
        esac
    done
}

function configure_osx()
{
    get_tmux_option
    get_vim_option

    # Install Homebrew if does not exist
    if ! type "$brew" > /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    brew update
    if [ $WANTS_TMUX -eq 1 ]; then
        brew install tmux
        brew link tmux
    fi

    if [ $WANTS_VIM -eq 1 ]; then
        # Install node & npm
        echo "Installing nodejs & npm"
        brew install node

        # Installs python3
        echo "Installing python3"
        brew install python

        # Default vim is below the needed version and is not compiled with python3
        echo "Installing macvim"
        brew install macvim
		
		echo "Installing the_silver_searcher"
		brew install the_silver_searcher
    fi
}

function configure_linux()
{
    get_tmux_option

    sudo apt-get update

    if [ $WANTS_TMUX -eq 1 ]; then
        sudo apt-get install tmux
    fi

    if [ $WANTS_VIM -eq 1 ]; then
        sudo apt-get install build-essential cmake vim-nox python3-dev
        sudo apt-get install mono-complete golang nodejs npm default-jdk
		sudo apt-get install silversearcher-ag
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
        echo "No awesome configurations for non-Unix users..."
        exit 1
        ;;
esac

# Copy antigen.zsh into ~/.antigen
mkdir -p $HOME/.antigen

cp ./antigen.zsh $HOME/.antigen/antigen.zsh

zsh $HOME/.antigen/antigen.zsh

if [ $WANTS_VIM -eq 1 ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    cp .zshrc .vimrc $HOME
    mkdir -p $HOME/.vim
    cp plugins.vim $HOME/.vim/

    vim -c "PlugInstall" -c "qa!"

    echo "Installing YouCompleteMe language servers, please be patient..."
    sleep 2
    python3 $HOME/.vim/plugged/YouCompleteMe/install.py --all
fi

echo "*********************************"
echo "*** When inside vim just run: ***"
echo "*** :PlugInstall              ***"
echo "*********************************"

if [ $WANTS_TMUX -eq 1 ]; then
    cp .tmux.conf $HOME

    # Also setup tmux package manager beforehand
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    echo "*********************************"
    echo "*** For tmux, perform the     ***"
    echo "*** following key sequence    ***"
    echo "*** for plugin installation   ***"
    echo "*** Ctrl-S, I (capital i)     ***"
    echo "*** Then wait 10-20 seconds   ***"
    echo "*********************************"
fi

echo "Done"

