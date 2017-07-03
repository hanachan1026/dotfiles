DOTFILES_ROOT:=$(shell pwd)
OS := $(shell uname)

all: init

init: essentials tools

essentials: brew git zsh vim

# =========================================
# homebrew
# =========================================

brew:
ifeq ($(OS),Darwin)
	# install homebrew
	./brew.sh
	# install packages
	brew tap homebrew/bundle
	brew bundle
endif

# =========================================
# vim
# =========================================

vim: .workspace markdown ag fzf
	# install vim
ifeq ($(OS),Darwin)
	brew install vim --with-python3 --with-lua
else
	cd .workspace
	sudo yum install -y gtk+-devel gtk2-devel ncurses-devel
	wget http://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
	tar xvf vim-7.4.tar.bz2
	cd vim74
	./configure --enable-gui=yes --enable-multibyte --with-features=huge --disable-selinux --prefix=/usr/local --enable-rubyinterp --enable-xim --enable-fontset|grep gui
	rm -rf vim-7.4.tar.bz2 vim74
endif
	# plugin manager
	curl -fLo $@ --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	# config
	ln -s $(DOTFILES_ROOT)/vimrc ~/.vimrc
	ln -s $(DOTFILES_ROOT)/vimrc.keymap ~/.vimrc.keymap
	ln -s $(DOTFILES_ROOT)/vim ~/.vim
	ln -s $(DOTFILES_ROOT)/ideavimrc ~/.ideavimrc
	ln -s $(DOTFILES_ROOT)/xvimrc ~/.xvimrc

ag:
ifeq ($(OS),Darwin)
	brew install 'ag'
else
	sudo rpm -ivh http://swiftsignal.com/packages/centos/6/x86_64/the-silver-searcher-0.13.1-1.el6.x86_64.rpm
endif

markdown:
ifeq ($(OS),Darwin)
	brew install grip
	brew install markdown
else
	# TODO
endif

fzf: .workspace
ifeq ($(OS),Darwin)
	brew install fzf
else
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
endif


# =========================================
# git
# =========================================

git:
ifeq ($(OS),Darwin)
	brew install git
	else
	sudo yum -y install git
endif
	ln -s $(DOTFILES_ROOT)/gitconfig ~/.gitconfig
	ln -s $(DOTFILES_ROOT)/gitignore ~/.gitignore

# =========================================
# zsh
# =========================================

zsh: peco
	# install zsh
ifeq ($(OS),Darwin)
	brew install zsh
else
	sudo yum install -y zsh
endif
	# zplug
	curl -sL https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
	zplug install
	# config
	ln -s $(DOTFILES_ROOT)/zshrc ~/.zshrc
	cp $(DOTFILES_ROOT)/zshrc.local.template ~/zshrc.local

peco: .workspace
ifeq ($(OS),Darwin)
	brew install 'peco'
else
	cd .workspace	
	wget https://github.com/peco/peco/releases/download/v0.3.3/peco_linux_amd64.tar.gz
	tar xzvf peco_linux_amd64.tar.gz
	mv peco_linux_amd64/peco ~/bin/peco
	rm -rf peco_linux_amd64.tar.gz peco_linux_amd64
endif

# =========================================
# tools
# =========================================

tools:
ifeq ($(OS),Darwin)
	# go
	brew install go
	brew install ghq
else
	sudo yum -y install go
endif

# =========================================
# optional
# =========================================

vbox-vagrant:
	brew cask install virtualbox
	brew cask install vagrant
	vagrant plugin install vagrant-vbguest

plenv:
	brew install plenv
	brew install perl-build
	ln -s $(DOTFILES_ROOT)/zshrc.module.plenv ~/.zshrc.module.plenv

rbenv:
	brew install python
	brew install pyenv
	brew install pyenv-virtualenv
	ln -s $(DOTFILES_ROOT)/zshrc.module.rbenv ~/.zshrc.module.rbenv

pyenv:
	brew install ruby
	brew install ruby-build
	brew install rbenv
	brew install rbenv-gemset
	ln -s $(DOTFILES_ROOT)/zshrc.module.pyenv ~/.zshrc.module.pyenv

docker:
	brew cask install virtualbox
	brew install docker
	brew install docker-machine
	brew install docker-compose

# =========================================
# helper
# =========================================

.workspace:
	mkdir -p .workspace

