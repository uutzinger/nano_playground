##############################################################
#
# Intel Realsense Camera Support
#
# References:
# https://www.jetsonhacks.com/2019/05/07/jetson-nano-realsense-tracking-camera/
# https://github.com/IntelRealSense/librealsense/
# Isaac robotics link: https://docs.nvidia.com/isaac/isaac/doc/setup.html
#
# Issues:
# Could not open input file 
#   CMakeFiles/realsense2.dir/src/proc/
#     temporal-filter.cpp.o
#     disparity-transfrom.cpp.o
#     hole-filling-filter.cpp.o
#   They were 0 bytes
#   fixed by deleting by hand and recompiling
#
# Requirement:
# Make sure the kernel is patched before building these packages.
#
# Urs Utzinger, Summer 2019
##############################################################

cd ~
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
git checkout v2.23.0
patch -p1 -i ~/nano_playground/librealsense/patches/model-views.patch
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger
mkdir build 
cd build
# Make sure cmake can find nvcc
export CUDACXX=/usr/local/cuda-10.0/bin/nvcc
export PATH=${PATH}:/usr/local/cuda/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64

# sudo nano /etc/environment
# Add following to end of file
# CUDACXX=CUDACXX=/usr/local/cuda/bin/nvcc
#
~/CMake/bin/cmake-gui ..
# BUILD_EXAMPLES=true 
# BUILD_WITH_CUDA=true 
# CMAKE_BUILD_TYPE=release
make -j4 
# Compiles with tons of warnings:
#  - object pointer to function pointer conversion, 
#  - _BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE
#  - ISO C++ forbids zero-size array 
# Takes 1 hr
sudo make install
##########################
