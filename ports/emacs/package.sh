#!/opt/local/bin/mksh ../../.port.sh
# TODO: Emacs 24 is the last major version that supports IRIX. Let's patch support back in at some point!
port=emacs
version=24.5.1
workdir=emacs-24.5
useconfigure=true
configopts="--with-xpm=no --with-jpeg=no --with-gif=no --with-tiff=no"
gccversion=4.7.4
files="ftp://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz emacs-24.5.1.tar.gz 806e80eefa2ca89d2f8c0917f8b61c5c87af4f2d"
