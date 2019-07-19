#!/opt/local/bin/mksh ../.port.sh
port=ffmpeg
version=4.1.4
useconfigure=true
configopts="--extra-cflags=-D_XOPEN_SOURCE=2019 --disable-mipsdsp --disable-mipsdspr2 --cpu=mips3"
files="https://ffmpeg.org/releases/ffmpeg-4.1.4.tar.bz2 ffmpeg-4.1.4.tar.bz2 aa5888a50305ecd642f206c8f93a32167f578d7f"
patchlevel=1
depends="bash"
