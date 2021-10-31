### OS X ###

powerline_fonts_osx:
	git clone https://github.com/powerline/fonts.git --depth=1
	./fonts/install.sh
	rm -rf fonts

homebrew_osx:
	if ! type "brew" > /dev/null; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi

brew_update_osx:
	brew update

brew_osx: homebrew_osx brew_update_osx

fzf_osx:
	brew install fzf

fzf_update_brew_osx: brew_osx install_fzf_osx

the_silver_searcher_osx:
	brew install the_silver_searcher

tmux_osx:
	brew install tmux
	brew link tmux

tmux_update_brew_osx: brew_osx tmux_osx

node_osx:
	brew install node

python_osx:
	brew install python

macvim_osx:
	brew install macvim

go_osx:
	brew install go

rust_osx:
	brew install rust

pyenv_install_osx:
	curl -L "https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer" | /bin/bash

pyenv_setup_osx:
	echo "export PATH=\${HOME}/.pyenv/shims/:\${PATH}" >> ${HOME}/.zshrc
	echo 'eval "\$(pyenv init -)"' >> ${HOME}/.zshrc

pyenv_osx: pyenv_install_osx

rbenv_install_osx:
	brew install rbenv

rbenv_setup_osx:
	echo "export PATH=\${HOME}/.rbenv/shims/:\${PATH}" >> ${HOME}/.zshrc
	echo 'eval "\$(tbenv init -)"' >> ${HOME}/.zshrc

rbenv_osx: rbenv_install_osx rbenv_setup_osx

antigen_osx:
	mkdir -p ${HOME}/.antigen
	cp ./antigen.zsh ${HOME}/.antigen/antigen.zsh
	zsh ${HOME}/.antigen/antigen.zsh
	sudo chmod -R 755 /usr/local/share/zsh
	sudo chmod -R root:staff /usr/local/share/zsh

vim_config_osx: macvim_osx
	curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	cp .vimrc ${HOME}
	mkdir -p ${HOME}/.vim
	cp plugins.vim ${HOME}/.vim/
	vim -c "PlugInstall" -c "qa!"
	python3 ${HOME}/.vim/plugged/YouCompleteMe/install.py --all

zsh_config_osx: antigen_osx
	cp .zshrc ${HOME}

tmux_config_osx: tmux_osx
	cp .tmux.conf ${HOME}

osx: brew_osx powerline_fonts_osx fzf_osx the_silver_searcher_osx tmux_osx node_osx python_osx go_osx rust_osx zsh_config_osx vim_config_osx tmux_config_osx pyenv_osx rbenv_osx

### Arch ###

yay_arch:
	if ! type "yay" > /dev/null; then
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si --noconfirm
		cd ..
		rm -rf yay
	fi

zsh_arch:
	sudo pacman -S --noconfirm zsh

powerline_fonts_arch:
	git clone https://github.com/powerline/fonts.git --depth=1
	./fonts/install.sh
	rm -rf fonts

fzf_arch:
	sudo pacman -S --noconfirm fzf

the_silver_searcher_arch:
	sudo pacman -S --noconfirm the_silver_searcher

tmux_arch:
	sudo pacman -S --noconfirm tmux

node_arch:
	sudo pacman -S --noconfirm node

python_arch:
	sudo pacman -S --noconfirm python

go_arch:
	sudo pacman -S --noconfirm go

rust_arch:
	sudo pacman -S --noconfirm rust

pyenv_install_arch:
	yay -S --noconfirm pyenv

pyenv_setup_arch:
	echo "export PATH=\${HOME}/.pyenv/shims/:\${PATH}" >> ${HOME}/.zshrc
	echo 'eval "\${pyenv init -}"' >> ${HOME}/.zshrc

pyenv_arch: pyenv_install_arch pyenv_setup_arch

ruby_arch:
	sudo pacman -S --noconfirm ruby

rbenv_install_arch: ruby_arch
	yay -S --noconfirm rbenv

rbenv_setup_arch:
	echo "export PATH=\${HOME}/.rbenv/shims/\${PATH}" >> ${HOME}/.zshrc
	echo 'eval "\$(rbenv init -)"' >> ${HOME}/.zshrc

rbenv_arch: rbenv_install_arch rbenv_setup_arch

antigen_arch: zsh_arch
	mkdir -p ${HOME}/.antigen
	cp ./antigen.zsh ${HOME}/.antigen/antigen.zsh
	zsh ${HOME}/.antigen/antigen.zsh

vim_config_arch:
	curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	cp .vimrc ${HOME}
	mkdir -p ${HOME}/.vim
	cp plugins.vim ${HOME}/.vim/
	vim -c "PlugInstall" -c "qa!"
	python3 ${HOME}/.vim/plugged/YouCompleteMe/install.py --all

zsh_config_arch: antigen_arch
	cp .zshrc ${HOME}

tmux_config_arch: tmux_arch
	cp .tmux.conf ${HOME}

arch: zsh_arch powerline_fonts_arch fzf_arch the_silver_searcher_arch node_arch python_arch go_arch rust_arch zsh_config_arch vim_config_arch tmux_config_arch pyenv_arch rbenv_arch
