#!/usr/didbs/0_1_8_n32_mips3_gcc/bin/sh ../../.port.sh
port=nethack
version=3.6.2
useconfigure=true
files="http://www.nethack.org/download/3.6.2/nethack-362-src.tgz nethack-362-src.tgz 8f9b26265afe60c1a25c98abe2d767920df43b31"

configure() {
	sed "s|#ifndef SYSCF|#ifdef SYSCF|g" $workdir/include/config.h > $workdir/config.h_tmp
	mv $workdir/config.h_tmp $workdir/include/config.h 
	sed "s|PREFIX=/usr|PREFIX=$prefix|g" $workdir/sys/unix/hints/unix > $workdir/unix_tmp
	mv $workdir/unix_tmp $workdir/sys/unix/hints/unix
	runwd ./sys/unix/setup.sh sys/unix/hints/unix
}
