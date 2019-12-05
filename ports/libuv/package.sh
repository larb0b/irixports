#!/usr/didbs/0_1_8_n32_mips3_gcc/bin/sh ../../.port.sh
port=libuv
version=1.30.1
useconfigure=true
files="https://dist.libuv.org/dist/v1.30.1/libuv-v1.30.1.tar.gz libuv-v1.30.1.tar.gz 0925cfeabd6a1800156bdf23c69b791cfe3f92fb"

configure(){
	runwd ./autogen.sh
	runwd chmod +x configure
	runwd ./configure --prefix="$prefix" $configopts
}
