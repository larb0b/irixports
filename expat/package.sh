#!/opt/local/bin/mksh ../.port.sh
port=expat
version=2.2.7
workdir=libexpat-R_2_2_7/expat
useconfigure=true
files="https://codeload.github.com/libexpat/libexpat/tar.gz/R_2_2_7 libexpat-2.2.7.tar.gz fedb0c4c822374fc4e03fbd1ca996f3ac8aa2781"
depends="libtool"

configure(){
	runwd ./buildconf.sh
	runwd ./configure --prefix="$prefix" $configopts
}
