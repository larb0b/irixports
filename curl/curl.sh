#!/bin/ksh ../.port.sh
port=curl
version=7.65.1
useconfigure=true
configopts="--with-ssl=$prefix"
sha1sum=9564c29955966976e63475e02c888b9e23d1df55
url="https://curl.haxx.se/download/curl-7.65.1.tar.gz"
depends="openssl"
