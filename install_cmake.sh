##############
# Build CMake
##############
# update version to latest stable release by checking github site
wget https://github.com/Kitware/CMake/archive/v3.16.2.zip
unzip v3.16.2.zip
mv CMake-3.16.2 CMake
rm v3.16.2.zip
cd CMake
# ./bootstrap # takes a few minutes
# ./bootstrap -- -DCMAKE_BUILD_TYPE:STRING=Release --qt-gui
./configure --qt-gui
# configure new cmake with existing cmake
# cmake-gui .
# build cmake
make -j4
sudo make install
sudo apt remove cmake-qt-gui
sudo cp bin/cmake-gui /usr/bin
sudo cp bin/cmake /usr/bin
sudo cp bin/cpack /usr/bin
sudo cp bin/ctest /usr/bin
sudo cp bin/ctresalloc /usr/bin


