#!/bin/ksh
set -e
if [ "$(id -u)" != "0" ]; then
	>&2 echo "This script must be run as root."
	exit 1
fi
echo "Fetching didbs 0.1.8."
mkdir -p /tmp/didbs
perl .fetch.pl mirror.rqsall.com /misc/usr-didbs-0.1.8-n32m3gcc.tar.gz /tmp/didbs.tar.gz
if [ "$(openssl sha1 /tmp/didbs/didbs.tar.gz | cut -d' ' -f2)" != "" ]; then
	>&2 echo "Error: didbs.tar.gz checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting didbs."
(mkdir -p /usr/didbs && gzcat /tmp/didbs/didbs.tar.gz | tar xf - && rm -rf /tmp/didbs)
# Needs to be run in case user is on 6.5.22
echo "Running mkheaders."
(cd /usr/didbs/0_1_8_n32_mips3_gcc/libexec/gcc/mips-sgi-irix6.5/9.2.0/install-tools && ./mkheaders)
echo "Symlinking didbs make to gmake."
ln -s /usr/didbs/0_1_8_n32_mips3_gcc/bin/make /usr/didbs/0_1_8_n32_mips3_gcc/bin/gmake
echo "When working with irixports, you should make sure that LD_LIBRARYN32_PATH is set correctly. In a bourne-like shell, you can add something like this to your profile:"
echo
echo '    export LD_LIBRARYN32_PATH=/usr/didbs/0_1_8_n32_mips3_gcc/lib32:$LD_LIBRARYN32_PATH'
