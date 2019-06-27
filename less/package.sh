#!/opt/local/bin/mksh ../.port.sh
port=less
version=530
useconfigure=true
files="http://ftp.gnu.org/gnu/less/less-530.tar.gz less-530.tar.gz d8ba1f43e88b706ef701f978cd3262b5b44dffd6" 

install() {
	runwd chmod +x install.sh
	runwd gmake install
}
