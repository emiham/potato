pkgname=potato
pkgver=6
pkgrel=1
pkgdesc="A pomodoro timer for the shell"
arch=('any')
url="https://github.com/emiham/potato"
license=('MIT')
depends=('alsa-utils')
source=('potato.sh'
        'notification.wav'
        'LICENSE')
md5sums=('ff1d5a88f0f86d07433cac195f3535d9'
         'b01bacb54937c9bdd831f4d4ffd2e31c'
         '1ddcbd2862764b43d75fb1e484bf8912')
package() {
	install -D $srcdir/potato.sh $pkgdir/usr/bin/$pkgname
	install -D -m644 $srcdir/LICENSE $pkgdir/usr/share/licenses/$pkgname/LICENSE
	install -D $srcdir/notification.wav $pkgdir/usr/lib/$pkgname/notification.wav
}
