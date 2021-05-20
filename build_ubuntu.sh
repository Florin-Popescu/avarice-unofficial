#!/bin/bash

./Bootstrap

./configure

make all -j$(nproc)
make install
