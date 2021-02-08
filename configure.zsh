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
        echo "No awesome configurations for non-Unix users..."
        exit 1
        ;;
esac

# Copy antigen.zsh into ~/.antigen
mkdir -p $HOME/.antigen

cp ./antigen.zsh $HOME/.antigen/antigen.zsh

zsh $HOME/.antigen/antigen.zsh

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp .zshrc .vimrc $HOME
mkdir -p $HOME/.vim
cp plugins.vim $HOME/.vim/

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

