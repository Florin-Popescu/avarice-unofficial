#!/bin/bash

case $(uname -o | cut -d '/' -f2) in
        "Msys")
                #These libraries are not available pre-built under msys2
                git clone https://github.com/libusb/libusb-compat-0.1.git
                cd ./libusb-compat-0.1
                ./bootstrap.sh
                ./configure
                make -j$NUMBER_OF_PROCESSORS
                make install
                cd ..

                git clone https://github.com/libusb/libusb.git
                cd ./libusb
                ./bootstrap.sh
                ./configure
                make -j$NUMBER_OF_PROCESSORS
                make install
                cd ..

                git clone https://github.com/libusb/hidapi.git
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
