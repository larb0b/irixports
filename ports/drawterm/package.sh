#!/opt/local/bin/mksh ../../.port.sh
# TODO: Figure out why authentication only works if the password is stored in the PASS environment variable and not entered into drawterm itself.
port=drawterm
version=20190619-6b68ed2b2324
workdir=drawterm-6b68ed2b2324
files="https://code.9front.org/hg/drawterm/archive/6b68ed2b2324.tar.gz drawterm-6b68ed2b2324.tar.gz 964723b9ef62181d90641d8115eef4bc8624a0a7"
makeopts="CONF=irix"

install() {
	mkdir -p $prefix/bin $prefix/share/man/man1
	runwd cp drawterm $prefix/bin
	runwd cp drawterm.1 $prefix/share/man/man1
}
