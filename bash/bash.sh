#!/bin/ksh
port=bash
version=4.4

fetch() {
	runfetch "http://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz"
	i=1
	while [ $i -le 23 ]; do
		patch="$(printf bash44-%03d $i)"
		runfetch "http://ftp.gnu.org/gnu/bash/bash-4.4-patches/$patch"
		runpatch "$patch" -p0
		i=$(( i + 1 ))
	done
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
