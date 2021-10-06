#!/bin/bash

TOOL=avarice
ARCH=$(uname -m)
OS=$(uname -o | cut -d '/' -f2 | tr '[:upper:]' '[:lower:]')
PACKAGE="$TOOL"_"$OS"_"$ARCH"
export DESTDIR="$(pwd)/""$PACKAGE"

mkdir $DESTDIR
make install

case $(uname -o | cut -d '/' -f2) in
	"Msys")
		cd $DESTDIR
		zip -r ../$PACKAGE.zip *
		;;
	"Linux")
		dpkg-deb --build --root-owner-group $PACKAGE
		;;
esac
