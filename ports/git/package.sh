#!/usr/didbs/0_1_8_n32_mips3_gcc/bin/sh ../../.port.sh
port=git
version=2.20.1
useconfigure=true
files="https://codeload.github.com/git/git/tar.gz/v2.20.1 git-2.20.1.tar.gz 7813d793e2f5ba5efb62a253b288b43d750c6471"
configopts="--with-openssl=$prefix --with-tcltk CFLAGS=-Wl,--unresolved-symbols=ignore-all"
depends="openssl"

configure(){
	runwd aclocal
	runwd autoconf
	runwd ./configure --prefix="$prefix" $configopts
}
