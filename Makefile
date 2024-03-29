### OS X ###

powerline_fonts_osx:
	git clone https://github.com/powerline/fonts.git --depth=1
	./fonts/install.sh
	rm -rf fonts

homebrew_osx:
	if ! type "brew" &> /dev/null; then /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"; fi

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

java_osx:
	brew tap adoptopenjdk/openjdk
	brew install --cask adoptopenjdk8

cmake_osx:
	brew install cmake

macvim_osx:
	brew install macvim

go_osx:
	brew install go
	echo "" >> ${HOME}/.zshrc
	echo "export PATH=\$${HOME}/go/bin:\$${PATH}" >> ${HOME}/.zshrc

rust_osx:
	brew install rust

pyenv_install_osx:
	curl -L "https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer" | /bin/bash

pyenv_setup_osx:
	echo "" >> ${HOME}/.zshrc
	echo "export PATH=\$${HOME}/.pyenv/shims:\$${PATH}" >> ${HOME}/.zshrc
	echo "export PATH=\$${HOME}/.pyenv/bin:\$${PATH}" >> ${HOME}/.zshrc
	echo 'eval "$$(pyenv init -)"' >> ${HOME}/.zshrc

pyenv_osx: pyenv_install_osx pyenv_setup_osx

rbenv_install_osx:
	brew install rbenv

rbenv_setup_osx:
	echo "" >> ${HOME}/.zshrc
	echo "export PATH=\$${HOME}/.rbenv/shims:\$${PATH}" >> ${HOME}/.zshrc
	echo 'eval "$$(rbenv init -)"' >> ${HOME}/.zshrc

rbenv_osx: rbenv_install_osx rbenv_setup_osx

antigen_osx:
	mkdir -p ${HOME}/.antigen
	cp ./antigen.zsh ${HOME}/.antigen/antigen.zsh
	zsh ${HOME}/.antigen/antigen.zsh

notedown_osx:
	pip install notedown

vim_config_osx: macvim_osx cmake_osx
	curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	cp .vimrc ${HOME}
	mkdir -p ${HOME}/.vim
	cp plugins.vim ${HOME}/.vim/
	vim -c "PlugInstall" -c "qa!"
	python3 ${HOME}/.vim/plugged/YouCompleteMe/install.py --all

zsh_config_osx: antigen_osx
	cp .zshrc ${HOME}

tmux_config_osx: tmux_osx
	git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
	cp .tmux.conf ${HOME}

snippets_osx:
	mkdir -p ${HOME}/.vim/UltiSnips
	cp -Rf snippets ~${HOME}/.vim/UltiSnips

osx: brew_osx powerline_fonts_osx fzf_osx the_silver_searcher_osx tmux_osx node_osx python_osx go_osx rust_osx java_osx zsh_config_osx vim_config_osx tmux_config_osx pyenv_osx rbenv_osx snippets_osx

### Arch ###

update_pacman_arch:
	sudo pacman -Syu --noconfirm

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

cmake_arch:
	sudo pacman -S --noconfirm cmake

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
	sudo pacman -S --noconfirm nodejs

npm_arch:
	sudo pacman -S --noconfirm npm

python_arch:
	sudo pacman -S --noconfirm python python-pip

go_arch:
	sudo pacman -S --noconfirm go

rust_arch:
	sudo pacman -S --noconfirm rust

pyenv_install_arch:
	yay -S --noconfirm pyenv

pyenv_setup_arch:
	echo "export PATH=\$${HOME}/.pyenv/shims/:\$${PATH}" >> ${HOME}/.zshrc
	echo 'eval "\$${pyenv init -}"' >> ${HOME}/.zshrc

pyenv_arch: pyenv_install_arch pyenv_setup_arch

ruby_arch:
	sudo pacman -S --noconfirm ruby

rbenv_install_arch: ruby_arch
	yay -S --noconfirm rbenv

rbenv_setup_arch:
	echo "export PATH=\$${HOME}/.rbenv/shims/\$${PATH}" >> ${HOME}/.zshrc
	echo 'eval "\$$(rbenv init -)"' >> ${HOME}/.zshrc

rbenv_arch: rbenv_install_arch rbenv_setup_arch

antigen_arch: zsh_arch
	mkdir -p ${HOME}/.antigen
	cp ./antigen.zsh ${HOME}/.antigen/antigen.zsh
	zsh ${HOME}/.antigen/antigen.zsh

notedown_arch:
	pip install notedown

vim_config_arch: cmake_arch notedown_arch
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

snippets_arch:
	mkdir -p ${HOME}/.vim/UltiSnips
	cp -Rf snippets ~${HOME}/.vim/UltiSnips

arch: update_pacman_arch zsh_arch powerline_fonts_arch fzf_arch the_silver_searcher_arch node_arch npm_arch python_arch go_arch rust_arch zsh_config_arch vim_config_arch tmux_config_arch pyenv_arch rbenv_arch snippets_arch

### Debian ###

install_dev_libs_debian:
	sudo apt-get install -y make build-essentials libssl-dev zliblg-dev libbz-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev

update_apt_debian:
	sudo apt-get update -y

zsh_debian:
	sudo apt-get install -y zsh

cmake_debian:
	sudo apt-get install -y cmake

powerline_fonts_debian:
	git clone https://github.com/powerline/fonts.git --depth=1
	./fonts/install.sh
	rm -rf fonts

fzf_debian:
	sudo apt-get install -y fzf

the_silver_searcher_debian:
	sudo apt-get install -y silversearcher-ag

tmux_debian:
	sudo apt-get install -y tmux

node_debian:
	sudo apt-get install -y nodejs

npm_debian:
	sudo apt-get install -y npm

go_debian:
	sudo apt-get install -y golang

rust_debian:
	sudo apt-get install -y rustc

pyenv_install_debian:
	curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

pyenv_setup_debian:
	echo "export PATH=\$${HOME}/.pyenv/shims/:\$${PATH}" >> ${HOME}/.zshrc
	echo 'eval "\$${pyenv init -}"' >> ${HOME}/.zshrc

pyenv_debian: pyenv_install_debian pyenv_setup_debian

antigen_debian: zsh_debian
	mkdir -p ${HOME}/.antigen
	cp ./antigen.zsh ${HOME}/.antigen/antigen.zsh
	zsh ${HOME}/.antigen/antigen.zsh

notedown_debian:
	pip install notedown

vim_config_debian: cmake_debian notedown_debian
	curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	cp .vimrc ${HOME}
	mkdir -p ${HOME}/.vim
	cp plugins.vim ${HOME}/.vim/
	vim -c "PlugInstall" -c "qa!"
	python3 ${HOME}/.vim/plugged/YouCompleteMe/install.py --all

zsh_config_debian: antigen_debian
	cp .zshrc ${HOME}

tmux_config_debian: tmux_debian
	cp .tmux.conf ${HOME}

snippets_debian:
	mkdir -p ${HOME}/.vim/UltiSnips
	cp -Rf snippets ~${HOME}/.vim/UltiSnips

debian: update_apt_debian zsh_debian powerline_fonts_debian fzf_debian the_silver_searcher_debian node_debian npm_debian go_debian rust_debian zsh_config_debian vim_config_debian tmux_config_debian pyenv_debian snippets_debian
