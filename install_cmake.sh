##############
# Build CMake
##############
# update version to latest stable release by checking github site
wget https://github.com/Kitware/CMake/archive/v3.15.5.zip
unzip v3.15.5.zip
mv CMake-3.15.5 CMake
rm v3.15.5.zip
cd CMake
# ./bootstrap # takes a few minutes
./bootstrap -- -DCMAKE_BUILD_TYPE:STRING=Release --qt-gui
# configure new cmake with existing cmake
# cmake-gui .
# build cmake
make -j4
sudo make install
sudo apt remove cmake-qt-gui
sudo cp bin/cmake-gui /usr/bin

