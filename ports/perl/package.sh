#!/usr/didbs/0_1_8_n32_mips3_gcc/bin/sh ../../.port.sh
port=perl
version=5.30.0
useconfigure=true
files="https://www.cpan.org/src/5.0/perl-5.30.0.tar.gz perl-5.30.0.tar.gz aa5620fb5a4ca125257ae3f8a7e5d05269388856" 
compiler=mipspro

configure() {
	PATH=/usr/sbin:/usr/bsd:/sbin:/usr/bin:/etc:/usr/etc:/usr/bin/X11:/opt/local/bin runwd ./Configure -des -Dprefix="$prefix" -Dman1dir="$prefix/share/man/man1" -Dman3dir="$prefix/share/man/man3" -Dcc='cc -n32'
}
