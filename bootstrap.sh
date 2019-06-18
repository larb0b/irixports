#!/bin/ksh
set -e
if [ "$(id -u)" != "0" ]; then
	>&2 echo "This script must be run as root."
	exit 1
fi
echo "Fetching /opt/local."
perl .fetch.pl mirror.rqsall.com /misc/optlocal.tar /optlocal.tar
if [ "$(openssl sha1 /optlocal.tar | cut -d' ' -f2)" != "5c79c33570b8d58b7d71a3cba513ea5e2b148be4" ]; then
	>&2 echo "Error: optlocal.tardist checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting /opt/local."
(cd / && tar xf optlocal.tar)
echo "Fetching GCC 4.7.4."
mkdir -p /tmp/gcc4
/opt/local/bin/curl -o /tmp/gcc4/gcc.tardist http://ports.sgi.sh/lang/gcc47/gcc47-4.7.4-01-irix-6.5-mips-201902070817.tardist
if [ "$(openssl sha1 /tmp/gcc4/gcc4.tardist | cut -d' ' -f2)" != "d7aeebce0a794d9dbdb4ce78d4f55010dab07923" ]; then
	>&2 echo "Error: gcc4.tardist checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting GCC 4.7.4."
(cd /tmp/gcc4 && tar xf gcc4.tardist && rm gcc4.tardist)
echo "Installing GCC 4.7.4."
inst -A -f /tmp/gcc4
echo "Fetching GCC 8.2.0."
mkdir -p /tmp/gcc8
/opt/local/bin/curl -o /tmp/gcc8/gcc8.tardist http://ports.sgi.sh/lang/gcc82/gcc-8.2.0-02-irix-6.5-mips.tardist
if [ "$(openssl sha1 /tmp/gcc8/gcc8.tardist | cut -d' ' -f2)" != "256bc626c45eef566f0bcab3e665b26bee3a0568" ]; then
	>&2 echo "Error: gcc8.tardist checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting GCC 8.2.0."
(cd /tmp/gcc8 && tar xf gcc8.tardist && rm gcc8.tardist)
echo "Installing GCC 8.2.0."
inst -A -f /tmp/gcc8
echo "Done! Removing temporary files and exiting."
rm -r /tmp/gcc4 /tmp/gcc8 /optlocal.tar
