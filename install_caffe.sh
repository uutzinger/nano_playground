#################################################################
# Install Caffe
#################################################################
# References
#  https://devtalk.nvidia.com/default/topic/1044473/jetson-agx-xavier/caffe-installation-on-xavier/post/5299458/#5299458
#  https://jkjung-avt.github.io/ssd-caffe-on-nano/
#  https://www.jetsonhacks.com/2015/01/20/nvidia-jetson-tk1-cudnn-install-caffe-example/
#
# Caution
# caffe depends on leveldb and if leveldb is built from source 
# the -fPIC compiler flag is necessary for the leveldb build
#
# Urs Utzinger, Summer 2019
#################################################################

# Create link the hdf5 libraries
cd /usr/lib/aarch64-linux-gnu
sudo ln -s libhdf5_serial.so libhdf5.so
sudo ln -s libhdf5_serial_hl.so libhdf5_hl.so

# enable deb-src in sources.list
sudo nano /etc/apt/sources.list 
#
sudo apt-get update
sudo apt build-dep caffe-cuda
# On my system this will install:
#  cpp-6 
#  cython3 
#  g++-6 
#  gcc-6 
#  gcc-6-base 
#  libasan3 
#  libgcc-6-dev 
#  libprotoc-dev
#  libstdc++-6-dev 
#  python3-gflags 
#  python3-leveldb 
#  python3-networkx
#  python3-pydotplus 
#  python3-pywt 
#  python3-skimage 
#  python3-skimage-lib


# This is arelady in installBasiscs.sh
#
#sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
#sudo apt-get install --no-install-recommends libboost-all-dev
#sudo apt-get install libatlas-base-dev 
#sudo apt-get install libopenblas-dev 
#sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev
## glog
#wget https://github.com/google/glog/archive/v0.3.3.tar.gz
#tar zxvf v0.3.3.tar.gz
#cd glog-0.3.3
# or
#git clone https://github.com/google/glog
#cd glog
#./autogen.s
#./configure
#make && make install
## gflags
#wget https://github.com/schuhschuh/gflags/archive/master.zip
#unzip master.zip
#cd gflags-master
#or
#git clone https://github.com/gflags/gflags.git
#cd gflags
#mkdir build && cd build
#export CXXFLAGS="-fPIC" && cmake .. && make VERBOSE=1
#make && make install
## lmdb
#git clone https://github.com/LMDB/lmdb
#cd lmdb/libraries/liblmdb
#make && make install

cd ~
git clone https://github.com/BVLC/caffe
cd caffe

# Modify the standard Makefile
###############################
gedit Makefile
# -LIBRARIES += glog gflags protobuf boost_system boost_filesystem m
# +LIBRARIES += glog gflags protobuf boost_system boost_filesystem m hdf5_serial_hl hdf5_serial

################################
# Modify the example config file
################################
gedit Makefile.config.example
# -# USE_CUDNN := 1
# +USE_CUDNN := 1
# 
#-# OPENCV_VERSION := 3
#+OPENCV_VERSION := 4
#
#-CUDA_ARCH := -gencode arch=compute_20,code=sm_20 \
#-               -gencode arch=compute_20,code=sm_21 \
#-               -gencode arch=compute_30,code=sm_30 \
#-               -gencode arch=compute_35,code=sm_35 \
#-               -gencode arch=compute_50,code=sm_50 \
#-               -gencode arch=compute_52,code=sm_52 \
#-               -gencode arch=compute_60,code=sm_60 \
#-               -gencode arch=compute_61,code=sm_61 \
#-               -gencode arch=compute_61,code=compute_61
#+CCUDA_ARCH := -gencode arch=compute_53,code=sm_53 \
#             -gencode arch=compute_53,code=compute_53
#
# PYTHON_LIBRARIES:= boost_python3 python3.6m
# PYTHON_INCLUDE:=/usr/include/python3.6m \
#                 /usr/lib/python3.6/dist-packages/numpy/core/include

#
#-INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include
#+INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial/

################################
#For OpenCV 4 support:
################################
#https://github.com/BVLC/caffe/pull/6638/files
# In include/caffe/common.hpp
# Add:
# // Supporting OpenCV4
# #if (CV_MAJOR_VERSION == 4)
# #define CV_LOAD_IMAGE_COLOR cv::IMREAD_COLOR
# #define CV_LOAD_IMAGE_GRAYSCALE cv::IMREAD_GRAYSCALE
# #endif
#
# before // See PR #1236

cp Makefile.config.example Makefile.config

# add 
# export PYTHONPATH=~/caffe/python/:$PYTHONPATH
# to ~/.bashrc
source ~/.bashrc
#
sudo pip3 install pytest
sudo pip2 install pytest
#
mkdir build
cd build
cmake-gui ..
# Configure
# CMAKE_CXX_FLAGS -fPIC
# CMAKE_BUILD_TYPE Release
# Generate
make all -j4
sudo make install
make runtest # needs fan and 20W power supply;-)
# Passed all tests, took an 1 hour to test.
make pycaffe
################################
