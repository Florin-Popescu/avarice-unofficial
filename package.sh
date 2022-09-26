#!/bin/bash

TOOL=avarice
ARCH=$(uname -m)
OS=$(uname -o | cut -d '/' -f2 | tr '[:upper:]' '[:lower:]')
UPSTREAM_VERSION=2.14

if [ -x "$(command -v dpkg-deb)" ]; then
	DISTRO=deb
elif [ -x "$(command -v makepkg)" ]; then
	DISTRO=arch
fi

PACKAGE="$TOOL"_"$OS"_"$DISTRO"_"$ARCH"
DESTDIR=./"$PACKAGE"


if [ $DISTRO == deb ]; then
mkdir $DESTDIR
	make install
	dpkg-deb --build --root-owner-group $PACKAGE
elif [ $DISTRO == arch ]; then
	tar --create --gzip --file="$PACKAGE"/"$TOOL"-"$UPSTREAM_VERSION".tar.gz .
	cd $PACKAGE
	makepkg
fi
