#!/opt/local/bin/mksh ../.port.sh
# TODO: Fix curl port!
port=curl
version=7.65.1
useconfigure=true
configopts="--with-ssl=$prefix"
files="https://curl.haxx.se/download/curl-7.65.1.tar.gz curl-7.65.1.tar.gz 9564c29955966976e63475e02c888b9e23d1df55"
depends="openssl"
