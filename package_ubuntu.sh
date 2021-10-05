export DESTDIR="$(pwd)/avarice_ubuntu_$1" && make install
dpkg-deb --build --root-owner-group avarice_ubuntu_$1
