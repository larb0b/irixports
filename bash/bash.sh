#!/bin/ksh
port=bash
version=4.4
sha1sum=8de012df1e4f3e91f571c3eb8ec45b43d7c747eb

fetch() {
	runfetch "http://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz"
	runpatch -p0
}
configure() {
	runconfigure
}
build() {
	runmake
}
install() {
	runmakeinstall
}

. ../.include.sh
