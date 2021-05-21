#!/bin/bash

chmod +x ./Bootstrap
./Bootstrap

chmod +x ./configure
./configure

make all -j$(nproc)
make install
