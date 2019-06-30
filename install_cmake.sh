##############
# Build CMake
##############
# update version to latest stable release by checking github site
wget https://github.com/Kitware/CMake/archive/v3.14.5.zip
unzip v3.14.5.zip
mv CMake-3.14.5 CMake
rm v3.14.5.zip
cd CMake
./bootstrap # takes a few minutes
# I like cmake with the graphical user interface
./configure --qt-gui
# configure new cmake with existing cmake
cmake-gui .
# build cmake
make -j4
sudo make install

