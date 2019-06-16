#!/bin/ksh
set -e
if [ "$(id -u)" != "0" ]; then
	>&2 echo "This script must be run as root."
	exit 1
fi
echo "Fetching /opt/local."
perl .fetch.pl mirror.rqsall.com /misc/optlocal.tar /optlocal.tar
if [ "$(openssl sha1 /optlocal.tar | cut -d' ' -f2)" != "d31301e0b08d92f9b0a046805d4b66aede7ba5d9" ]; then
	>&2 echo "Error: optlocal.tardist checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting /opt/local."
(cd / && tar xf optlocal.tar)
echo "Fetching GCC 4.7.4."
mkdir -p /tmp/gcc
/opt/local/bin/curl -o /tmp/gcc/gcc.tardist http://ports.sgi.sh/lang/gcc47/gcc47-4.7.4-01-irix-6.5-mips-201902070817.tardist
if [ "$(openssl sha1 /tmp/gcc/gcc.tardist | cut -d' ' -f2)" != "d7aeebce0a794d9dbdb4ce78d4f55010dab07923" ]; then
	>&2 echo "Error: gcc.tardist checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting GCC 4.7.4."
(cd /tmp/gcc && tar xf gcc.tardist && rm gcc.tardist)
echo "Installing GCC 4.7.4."
inst -A -f /tmp/gcc
echo "Done! Removing temporary files and exiting."
rm -r /tmp/gcc /optlocal.tar
