#!/opt/local/bin/mksh ../../.port.sh
# Note: Curl will expect cacert.pem in $prefix/etc.
# TODO: Stop using --unresolved-symbols=ignore-all!
port=curl
version=7.65.1
useconfigure=true
configopts="--with-ssl=$prefix --without-libpsl --disable-threaded-resolver --with-ca-bundle=$prefix/etc/cacert.pem CFLAGS=-Wl,--unresolved-symbols=ignore-all"
files="https://curl.haxx.se/download/curl-7.65.1.tar.gz curl-7.65.1.tar.gz 9564c29955966976e63475e02c888b9e23d1df55"
depends="openssl"

# TODO: Avoid using this ugly hack.
configure() {
	runwd ./configure --prefix="$prefix" $configopts
	sed 's/#define HAVE_MACH_ABSOLUTE_TIME 1/\/* #undef HAVE_MACH_ABSOLUTE_TIME *\//g' $workdir/lib/curl_config.h > $workdir/fixed_curl_config.h
	mv $workdir/fixed_curl_config.h $workdir/lib/curl_config.h
	sed 's/-Werror-implicit-function-declaration//g' $workdir/src/Makefile > $workdir/fixed_Makefile
	mv $workdir/fixed_Makefile $workdir/src/Makefile
}
