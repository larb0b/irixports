#!/bin/ksh
set -e
if [ "$(id -u)" != "0" ]; then
	>&2 echo "This script must be run as root."
	exit 1
fi
echo "Fetching /opt/local."
perl .fetch.pl mirror.rqsall.com /misc/optlocal.tar /optlocal.tar || >&2 echo "Error: optlocal.tar download failed. Make sure that networking has been configured properly."
if [ "$(openssl sha1 /optlocal.tar | cut -d' ' -f2)" != "5c79c33570b8d58b7d71a3cba513ea5e2b148be4" ]; then
	>&2 echo "Error: optlocal.tardist checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting /opt/local."
(cd / && tar xf optlocal.tar)
echo "Fetching GNU toolchain (GCC 8.2.0, binutils 2.19.1, etc.)."
mkdir -p /tmp/gnuchain
/opt/local/bin/curl -o /tmp/gnuchain/gnuchain.tardist https://esp.iki.fi/gnutoolchain-0.1-01-irix-6.5-mips.tardist
if [ "$(openssl sha1 /tmp/gnuchain/gnuchain.tardist | cut -d' ' -f2)" != "2002f4f518d3e7eba5656b9a7550d05bcb6070ff" ]; then
	>&2 echo "Error: gnuchain.tardist checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting GNU toolchain."
(cd /tmp/gnuchain && tar xf gnuchain.tardist && rm gnuchain.tardist)
echo "Installing GNU toolchain."
inst -A -f /tmp/gnuchain
ln -sf /opt/local/binutils-dev/bin /opt/local/gcc-8.2.0/mips-sgi-irix6.5/bin
echo "Done! Removing temporary files."
rm -r /tmp/gnuchain /optlocal.tar
echo "When working with irixports, you should make sure that GCC's lib32 directory is in LD_LIBRARYN32_PATH. In a bourne-like shell, you can put something like export LD_LIBRARYN32_PATH=$LD_LIBRARYN32_PATH:/opt/local/gcc-4.7.4/lib32 in your profile."
