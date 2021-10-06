#!/bin/bash

TOOL=avarice
ARCH=$(uname -m)
OS=$(uname -o | tr '[:upper:]' '[:lower:]')
PACKAGE="$TOOL"_"$OS"_"$ARCH"
export DESTDIR="$(pwd)/""$PACKAGE"

mkdir $DESTDIR
make install

cd $DESTDIR
zip -r ../$PACKAGE.zip *
