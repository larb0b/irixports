#!/opt/local/bin/mksh ../.port.sh
port=fontconfig
version=2.13.91
useconfigure=true
files="https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.91.tar.gz fontconfig-2.13.91.tar.gz c93cba1f67a5375ff90e8994814634f09c37baf4"

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/people/edodd/.local/lib/pkgconfig

configure(){
	runwd aclocal
	runwd autoconf
	runwd automake
	runwd ./configure --prefix="$prefix" $configopts
}
