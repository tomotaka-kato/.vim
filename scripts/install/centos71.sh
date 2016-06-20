#!/bin/bash

# uninstall vim
sudo yum -y remove vim-enhanced

# install require tools
sudo yum -y install mercurial ncurses-devel lua lua-devel

# get vim source
cd /usr/local/src/
git clone https://github.com/vim/vim.git
cd vim/

# edit configure
sudo \
	./configure \
	--with-features=huge \
	--enable-multibyte \
	--enable-luainterp=dynamic \
	--enable-gpm \
	--enable-cscope \
	--enable-fontset

# make and install
sudo make
sudo make install
