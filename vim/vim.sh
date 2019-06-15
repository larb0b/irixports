#!/bin/ksh
port=vim
version=8.1
workdir=vim81/src

fetch() {
	runfetch "http://ftp.vim.org/pub/vim/unix/vim-8.1.tar.bz2"
}
configure() {
	runconfigure --with-features=huge
}
build() {
	runmake
}
install() {
	runmakeinstall
}

. ../.include.sh
