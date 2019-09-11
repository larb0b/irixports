#!/opt/local/bin/mksh ../../.port.sh
# TODO: Stop using --unresolved-symbols=ignore-all!
port=openssl
version=1.0.2s
useconfigure=true
configscript=Configure
files="https://www.openssl.org/source/openssl-1.0.2s.tar.gz openssl-1.0.2s.tar.gz cf43d57a21e4baf420b3628677ebf1723ed53bc1"
configopts="irix-mips3-gcc -Wl,--unresolved-symbols=ignore-all"
