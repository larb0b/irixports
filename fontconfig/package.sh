#!/opt/local/bin/mksh ../.port.sh
port=fontconfig
version=2.13.1
useconfigure=true
files="https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.gz fontconfig-2.13.1.tar.gz e073e1d23d9d6e83a8d2d6eafa5905a541b77975"

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/people/edodd/.local/lib/pkgconfig

configure(){
	runwd aclocal
	runwd autoconf
	runwd automake
	runwd ./configure --prefix="$prefix" $configopts
}
