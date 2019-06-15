#!/bin/ksh
set -e
if [ "$(id -u)" != "0" ]; then
	>&2 echo "This script must be run as root."
	exit 1
fi
echo "Fetching /opt/local."
perl .fetch.pl mirror.rqsall.com /misc/optlocal.tar /optlocal.tar
if [ "$(sum -r /optlocal.tar | cut -d' ' -f1)" != "27685" ]; then
	>&2 echo "Error: optlocal.tardist checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting /opt/local."
(cd / && tar xf optlocal.tar)
echo "Fetching latest cacert.pem."
/opt/local/bin/curl -o /opt/local/etc/cacert.pem https://curl.haxx.se/ca/cacert.pem
echo "Fetching GCC 4.7.4."
mkdir -p /tmp/gcc
/opt/local/bin/curl -o /tmp/gcc/gcc.tardist http://ports.sgi.sh/lang/gcc47/gcc47-4.7.4-01-irix-6.5-mips-201902070817.tardist
if [ "$(sum -r /tmp/gcc/gcc.tardist | cut -d' ' -f1)" != "60699" ]; then
	>&2 echo "Error: gcc.tardist checksum incorrect. Try running this script again."
	exit 1
fi
echo "Extracting GCC 4.7.4."
(cd /tmp/gcc && tar xf gcc.tardist && rm gcc.tardist)
echo "Installing GCC 4.7.4."
inst -A -f /tmp/gcc
echo "Done! Removing temporary files and exiting."
rm -r /tmp/gcc /optlocal.tar
