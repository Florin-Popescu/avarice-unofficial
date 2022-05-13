#!/bin/bash

case $(uname -o | cut -d '/' -f2) in
	"Msys")
		wget https://github.com/Florin-Popescu/libusb-compat-0.1/releases/download/v0.1.7/libusb-compat-0.1_msys_x86_64.zip -O libusb-compat-0.1_msys_x86_64.zip
		unzip libusb-compat-0.1_msys_x86_64.zip -o
		cp libusb-compat-0.1_msys_x86_64/* / -r

		#These libraries are not available pre-built under msys2
		git clone git@github.com:libusb/libusb.git
		cd ./libusb
		./bootstrap.sh
		./configure
		make -j$NUMBER_OF_PROCESSORS
		make install
		cd ..

		git clone git@github.com:libusb/hidapi.git
		cd ./hidapi
		./bootstrap
		./configure
		make all -j$NUMBER_OF_PROCESSORS
		make install
		cd ..

		SUDO=
		;;
	"Linux")
		NUMBER_OF_PROCESSORS=$(nproc)
		SUDO=sudo
		;;
esac

./Bootstrap
./configure

make all -j$NUMBER_OF_PROCESSORS
