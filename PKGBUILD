pkgname=avarice
pkgver=2.14
pkgrel=7
epoch=
pkgdesc="GDB debug server for AVR microcontrollers"
arch=('x86_64')
url=""
license=('GPL')
groups=()
depends=()
makedepends=()
checkdepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=()
noextract=()
md5sums=()
validpgpkeys=()

build() {
	cd ..
	./Bootstrap
	./configure --prefix=/usr
	make all
}

package() {
	make DESTDIR="$pkgdir/" install
}
