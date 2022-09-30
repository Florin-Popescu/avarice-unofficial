#!/bin/bash

TOOL=avarice
ARCH=$(uname -m)

if [ -x "$(command -v dpkg-deb)" ]; then
	DISTRO=deb
elif [ -x "$(command -v makepkg)" ]; then
	DISTRO=arch
fi

PACKAGE="$TOOL"_"$ARCH"
DESTDIR=./"$PACKAGE"

if [ $DISTRO == deb ]; then
	mkdir $DESTDIR
	make install
	dpkg-deb --build --root-owner-group $PACKAGE
elif [ $DISTRO == arch ]; then
	makepkg
fi
