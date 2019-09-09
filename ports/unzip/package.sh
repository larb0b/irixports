#!/opt/local/bin/mksh ../../.port.sh
port=unzip
version=6.0
workdir=unzip60
compiler=gcc
files="https://gigenet.dl.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz unzip60.tgz  abf7de8a4018a983590ed6f5cbd990d4740f8a22"

build(){
	runwd gmake -f unix/Makefile irix_gcc
	runwd gmake MANDIR=$prefix/share/man/man1 -f unix/Makefile install PREFIX=$prefix $makeopts
}
