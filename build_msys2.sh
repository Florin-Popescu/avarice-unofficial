#!/bin/bash

INSTALL_DIR=/c/avr

./Bootstrap

./configure \
--prefix=$INSTALL_DIR

make all -j $NUMBER_OF_PROCESSORS
make install
