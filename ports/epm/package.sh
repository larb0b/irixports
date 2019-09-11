#!/opt/local/bin/mksh ../../.port.sh
port=epm
version=4.4
useconfigure=true
files="https://codeload.github.com/michaelrsweet/epm/tar.gz/v4.4 epm-4.4.tar.gz 73341ea72566e53fb4df8a2e75bc807404878ce9"

configure(){
        runwd aclocal
        runwd autoconf
        runwd ./configure --prefix="$prefix" $configopts
}
