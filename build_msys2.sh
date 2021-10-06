#!/bin/bash

#These libraries must be specially built under msys2
git clone https://github.com/libusb/libusb.git
cd ./libusb
./bootstrap.sh
./configure
make -j $NUMBER_OF_PROCESSORS
make install
cd ..

git clone https://github.com/Florin-Popescu/libusb-compat-0.1.git
cd ./libusb-compat-0.1
./bootstrap.sh
./configure
make -j $NUMBER_OF_PROCESSORS
make install
cd ..

git clone git@github.com:libusb/hidapi.git
cd ./hidapi
./bootstrap
./configure
make all -j $NUMBER_OF_PROCESSORS
make install
cd ..


INSTALL_DIR=/c/avr

./Bootstrap

./configure \
--prefix=$INSTALL_DIR

make all -j $NUMBER_OF_PROCESSORS
make install
