#!/bin/ksh
set -e

makeopts="-j$(hinv | grep Processor | head -n1 | cut -d' ' -f1)"
installopts=
ldlibpath="/usr/lib32:/opt/local/gcc-4.7.4/lib32"
workdir="$port-$version"
configscript=configure
configopts=
useconfigure=false
prefix="$HOME/.local"
CC=/opt/local/gcc-4.7.4/bin/gcc
LD_LIBRARY_PATH="/usr/lib32:/opt/local/gcc-4.7.4/lib32${ldlibpath:+:$ldlibpath}"
PATH=/opt/local/bin:$PATH

. "$@"
shift

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
		echo "Error: SHA-1 sum of $filename differs from expected sum."
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

if [ -z "$1" ]; then
	echo "Fetching!"
	fetch
	if [ "$useconfigure" = "true" ]; then
		echo "Configuring!"
		configure
	fi
	echo "Building!"
	build
	echo "Installing!"
	install
	echo "Adding to database of installed packages!"
	addtodb
elif [ "$1" = "fetch" ]; then
	echo "Fetching!"
	fetch
elif [ "$1" = "configure" ]; then
	if [ "$useconfigure" = "true" ]; then
		echo "Configuring!"
		configure
	else
		echo "Error: This port does not use a configure script."
	fi
elif [ "$1" = "build" ]; then
	echo "Building!"
	build
elif [ "$1" = "install" ]; then
	echo "Installing!"
	install
	echo "Adding to database of installed packages!"
	addtodb
else
	>&2 echo "I don't understand $1! Supported arguments: fetch, configure, build, install."
	exit 1
fi
