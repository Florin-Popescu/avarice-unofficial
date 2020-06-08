INSTALL_DIR=/home/avarice

./Bootstrap

./configure \
--prefix=$INSTALL_DIR

make all -j $NUMBER_OF_PROCESSORS
make install
