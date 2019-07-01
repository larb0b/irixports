#!/opt/local/bin/mksh ../.port.sh
# TODO: Emacs 24.4 is the last version that supports IRIX. Let's patch support back in at some point!
port=emacs
version=24.4
useconfigure=true
configopts="--with-xpm=no --with-jpeg=no --with-gif=no --with-tiff=no"
files="http://ftp.gnu.org/gnu/emacs/emacs-24.4.tar.gz emacs-24.4.tar.gz df540d889a685a3ccaae94682b3ff131968e2706"
