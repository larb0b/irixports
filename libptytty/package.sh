#!/opt/local/bin/mksh ../.port.sh
port=libptytty
version=1.8
useconfigure=true
files="http://dist.schmorp.de/libptytty/libptytty-1.8.tar.gz libptytty-1.8.tar.gz f20959a80b8ec6b951b07beddccaf045c8a932f0"
patchlevel=1
depends="libtool autoconf"

configure() {
	runwd autoupdate
	runwd libtoolize --automake --force --copy
	runwd autoreconf --install
	runwd automake
	runwd ./configure --prefix="$prefix"	
}
