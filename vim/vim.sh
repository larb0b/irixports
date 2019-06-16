#!/bin/ksh
port=vim
version=8.1
workdir=vim81/src
sha1sum=cbca219d11990d866976da309d7ce5b76be48b96

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
