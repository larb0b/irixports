#!/opt/local/bin/mksh
set -eu
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
: "${depends:=}"
: "${patchlevel:=1}"
CC=/opt/local/gcc-4.7.4/bin/gcc
LD_LIBRARY_PATH="/usr/lib32:/opt/local/gcc-4.7.4/lib32${ldlibpath:+:$ldlibpath}"
PATH=$prefix/bin:/opt/local/gcc-4.7.4/bin:/opt/local/bin:/usr/sbin:/usr/bsd:/sbin:/usr/bin:/etc:/usr/etc:/usr/bin/X11

if [ -z "$port" ]; then
	echo "Must set port to the port directory."
	exit 1
fi

run() {
	echo "> $@"
	("$@")
}
runwd() {
	echo "> $@ (workdir)"
	(cd "$workdir" && "$@")
}
# Checks if a function is defined. In this case, if the function is not defined in the port's script, then we will use our defaults. This way, ports don't need to include these functions every time, but they can override our defaults if needed.
func_defined() {
	PATH= command -V "$1"  > /dev/null 2>&1
}
func_defined fetch || fetch() {
	OLDIFS=$IFS
	IFS=$'\n'
	for f in $files; do
		IFS=$OLDIFS
		read url filename hash <<< $(echo "$f")
		run curl "$url" -o "$filename"
		if [ "$(openssl sha1 "$filename" | cut -d' ' -f2)" != "$hash" ]; then
			>&2 echo "Error: SHA-1 hash of $filename differs from expected hash."
			exit 1
		fi
		case "$filename" in
			*.tar*|.tbz*|*.txz|*.tgz)
				run tar xf "$filename"
				;;
			*.gz)
				run gzcat "$filename" > "$filename.out"
				;;
			*)
				echo "Note: no case for file $filename."
				;;
		esac
	done
	if [ -d patches ]; then
		for f in patches/*; do
			runwd patch -p"$patchlevel" < "$f"
		done
	fi
}
func_defined configure || configure() {
	runwd ./"$configscript" --prefix="$prefix" $configopts
}
func_defined build || build() {
	if [ "$useconfigure" = "false" ]; then
		makeopts="PREFIX=$prefix $makeopts"
	fi
	runwd gmake $makeopts
}
func_defined install || install() {
	if [ "$useconfigure" = "false" ]; then
		installopts="PREFIX=$prefix $installopts"
	fi
	runwd gmake $installopts install
}
func_defined clean || clean() {
	rm -rf "$workdir" *.out
}
func_defined clean_dist || clean_dist() {
	OLDIFS=$IFS
	IFS=$'\n'
	for f in $files; do
		IFS=$OLDIFS
		read url filename hash <<< $(echo "$f")
		rm -f "$filename"
	done
}
func_defined clean_all || clean_all() {
	rm -rf "$workdir" *.out
	OLDIFS=$IFS
	IFS=$'\n'
	for f in $files; do
		IFS=$OLDIFS
		read url filename hash <<< $(echo "$f")
		rm -f "$filename"
	done
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
do_clean() {
	echo "Cleaning workdir and .out files in $port!"
	clean
}
do_clean_dist() {
	echo "Cleaning dist in $port!"
	clean_dist
}
do_clean_all() {
	echo "Cleaning all in $port!"
	clean_all
}

if [ -z "${1:-}" ]; then
	do_fetch
	do_configure
	do_build
	do_install
else
	case "$1" in
		fetch|configure|build|install|clean|clean_dist|clean_all)
			do_$1
			;;
		*)
			>&2 echo "I don't understand $1! Supported arguments: fetch, configure, build, install, clean, clean_dist, clean_all."
			exit 1
			;;
	esac
fi
