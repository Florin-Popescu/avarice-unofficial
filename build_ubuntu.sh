#!/bin/bash

./Bootstrap
./configure

make all -j$(nproc)
sudo make install
