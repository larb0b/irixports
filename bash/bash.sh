#!/bin/ksh
port=bash
version=4.4

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
