pkgname=patata
pkgver=7
pkgrel=1
pkgdesc="A pomodoro timer for the shell"
arch=('any')
url="https://github.com/emiham/patata"
license=('MIT')
depends=('alsa-utils')
optdepends=('notify-send')
source=('patata.sh'
        'notification.wav'
        'LICENSE')
md5sums=('73e4c7f412fa0f17f66e94eec7487894'
         'b01bacb54937c9bdd831f4d4ffd2e31c'
         '1ddcbd2862764b43d75fb1e484bf8912')
package() {
	install -D $srcdir/patata.sh $pkgdir/usr/bin/$pkgname
	install -D -m644 $srcdir/LICENSE $pkgdir/usr/share/licenses/$pkgname/LICENSE
	install -D $srcdir/notification.wav $pkgdir/usr/lib/$pkgname/notification.wav
}
