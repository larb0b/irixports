#!/opt/local/bin/mksh ../.port.sh
# TODO: Figure out why authentication only works if the password is stored in the PASS environment variable and not entered into drawterm itself.
port=drawterm
version=20190309-5c953ddd29fa
workdir=drawterm-5c953ddd29fa
files="https://code.9front.org/hg/drawterm/archive/5c953ddd29fa.tar.gz drawterm-5c953ddd29fa.tar.gz f53aab743edf985cf1c8dd5966a1445d0e27944f"
makeopts="CONF=irix"

install() {
	runcommandwd cp drawterm $prefix/bin
	runcommandwd cp drawterm.1 $prefix/share/man/man1
}
