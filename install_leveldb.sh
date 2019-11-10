#################################################
# leveldb
#
# Caution
#  make sure you compile it with -fPIC compiler options
#  see below
#################################################
git clone https://github.com/google/leveldb
cd leveldb
mkdir -p build && cd build
cmake-gui  .. 
# CMAKE_BUILD_TYPE=Release
# CMAKE_INSTALL_PREFIX=/usr/local
# CMAKE_CXX_FLAGS=-fPIC
# CMAKE_C_FLAGS=-fPIC
cmake --build .
sudo make install
sudo ldconfig
sudo -H pip3 install plyvel
sudo -H pip2 install plyvel
