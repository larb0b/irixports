#!/bin/ksh
set -e

if [ -z "$port" ]; then
        echo "Must set port to the port directory."
        exit 1
fi

: "${makeopts:=-j$(hinv | grep Processor | head -n1 | cut -d' ' -f1)}"
: "${installopts:=}"
: "${ldlibpath:=/usr/lib32:/opt/local/gcc-4.7.4/lib32}"
: "${workdir:=$port-$version}"
: "${configscript:=configure}"
CC=/opt/local/gcc-4.7.4/bin/gcc
LD_LIBRARY_PATH=$ldlibpath
PATH=/opt/local/bin:$PATH

runcommand() {
	echo "> $@"
	("$@")
}
runcommandwd() {
	echo "> $@ (workdir)"
	(cd "$workdir" && "$@")
}
runfetch() {
	runcommand curl -O "$@"
	filename="$(basename $1)"
	case "$filename" in
		*.tar*|.tbz*|.txz|.tgz)
			runcommand tar xf "$filename"
			;;
		*)
			echo "Note: no case for file $filename." 
			;;
	esac
}
runpatch() {
	for f in patches/*; do
		runcommandwd patch "$1" < "$f"
	done
}
runconfigure() {
	runcommandwd ./"$configscript" --prefix="$HOME"/.local "$@"
}
runmake() {
	runcommandwd gmake $makeopts "$@"
}
runmakeinstall() {
	runcommandwd gmake $installopts install "$@"
}

if [ -z "$1" ]; then
	echo "Fetching!"
	fetch
	echo "Configuring!"
	configure
	echo "Building!"
	build
	echo "Installing!"
	install
elif [ "$1" = "fetch" ]; then
	echo "Fetching!"
	fetch
elif [ "$1" = "configure" ]; then
	echo "Configuring!"
	configure
elif [ "$1" = "build" ]; then
	echo "Building!"
	build
elif [ "$1" = "install" ]; then
	echo "Installing!"
	install
else
	>&2 echo "I don't understand $1! Supported arguments: fetch, configure, build, install."
	exit 1
fi
