#!/opt/local/bin/mksh ../../.port.sh
port=git
version=2.20.1
useconfigure=true
files="https://codeload.github.com/git/git/tar.gz/v2.20.1 git-2.20.1.tar.gz 7813d793e2f5ba5efb62a253b288b43d750c6471"
configopts="--with-openssl=/opt/local/openssl --with-tcltk"

configure(){
	runwd aclocal
	runwd autoconf
	#runwd automake
	runwd ./configure --prefix="$prefix" $configopts
}
