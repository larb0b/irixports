#!/opt/local/bin/mksh ../../.port.sh
port=mksh
version=57
workdir=mksh
files="http://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R57.tgz mksh-R57.tgz 9df0ab24547f3f29191ae938caf271cb4842bcec
http://www.mirbsd.org/MirOS/cats/mir/mksh/mksh-R57.cat1.gz mksh-R57.cat1.gz f015a2989029802a0db009aa8148894d697f86a0"

build() {
	runwd sh Build.sh
}
install() {
	mkdir -p $prefix/bin
	runwd cp mksh $prefix/bin
	mkdir -p $prefix/share/man/man1
	run cp mksh-R57.cat1.gz.out $prefix/share/man/man1/mksh.1
}
