#!/bin/ksh
set -e

prefix="$HOME/.local"

. "$@"
shift

: "${makeopts:=-j$(hinv | grep Processor | head -n1 | cut -d' ' -f1)}"
: "${installopts:=}"
: "${ldlibpath:=/usr/lib32:/opt/local/gcc-4.7.4/lib32}"
: "${workdir:=$port-$version}"
: "${configscript:=configure}"
: "${configopts:=}"
: "${useconfigure:=false}"
CC=/opt/local/gcc-4.7.4/bin/gcc
LD_LIBRARY_PATH="/usr/lib32:/opt/local/gcc-4.7.4/lib32${ldlibpath:+:$ldlibpath}"
PATH=/opt/local/bin:$PATH

if [ -z "$port" ]; then
	echo "Must set port to the port directory."
	exit 1
fi

runcommand() {
	echo "> $@"
	("$@")
}
runcommandwd() {
	echo "> $@ (workdir)"
	(cd "$workdir" && "$@")
}
# Checks if a function is defined. In this case, if the function is not defined in the port's script, then we will use our defaults. This way, ports don't need to include fetch, configure, build, and install functions every time, but they can override our defaults if needed.
func_defined() {
	PATH= command -V "$1"  > /dev/null 2>&1
}
func_defined fetch || fetch() {
	runcommand curl -O "$url"
	filename="$(basename $url)"
	if [ "$(openssl sha1 "$filename" | cut -d' ' -f2)" != "$sha1sum" ]; then
		>&2 echo "Error: SHA-1 sum of $filename differs from expected sum."
		exit 1
	fi
	case "$filename" in
		*.tar*|.tbz*|.txz|.tgz)
			runcommand tar xf "$filename"
			;;
		*)
			echo "Note: no case for file $filename."
			;;
	esac
	if [ -d patches ]; then
		for f in patches/*; do
			runcommandwd patch < "$f"
		done
	fi
}
func_defined configure || configure() {
	runcommandwd ./"$configscript" --prefix="$prefix" $configopts
}
func_defined build || build() {
	if [ "$useconfigure" = "false" ]; then
		makeopts="PREFIX=$prefix $makeopts"
	fi
	runcommandwd gmake $makeopts
}
func_defined install || install() {
	if [ "$useconfigure" = "false" ]; then
		installopts="PREFIX=$prefix $installopts"
	fi
	runcommandwd gmake $installopts install
}
addtodb() {
	echo "$port $version" >> "$prefix"/packages.db
}
installdepends() {
	for depend in $depends; do
		if ! grep "$depend" "$prefix"/packages.db > /dev/null; then
			(cd "../$depend" && ./"$depend".sh)
		fi
	done
}
do_fetch() {
	installdepends
	echo "Fetching $port!"
	fetch
}
do_configure() {
	if [ "$useconfigure" = "true" ]; then
		echo "Configuring $port!"
		configure
	else
		echo "This port does not use a configure script. Skipping configure step."
	fi
}
do_build() {
	echo "Building $port!"
	build
}
do_install() {
	echo "Installing $port!"
	install
	echo "Adding $port to database of installed packages!"
	addtodb
}

if [ -z "$1" ]; then
	do_fetch
	do_configure
	do_build
	do_install
else
	case "$1" in
		fetch|configure|build|install)
			do_$1
			;;
		*)
			>&2 echo "I don't understand $1! Supported arguments: fetch, configure, build, install."
			exit 1
			;;
	esac
fi
