##################################################################
# 
# OpenCV installation 
#
# The following instruction will install many additional bindings
# and prepare the system for optimal OpenCV installation.
# 
# Comment 
# This got a little out of hand as many of the standard
# "How to build opencv scripts" did not complete for my configuration. 
# I worked myself trough the many "not found" and built the
# latest CMake with cmake-gui and selected the options needed 
# to successfuly compile.
# The final goal is to allow Caffe and dnn to be recognized and
# integrated. Caffe will be patched to work with OpenCV2 > 4.0.
#
# Pre-requisits
#  -run install_basics.sh before this one
#  -install vtk from VTK install script
#  -install caffe
#
# Urs Utzinger, Summer 2019
#################################################################

#################################################################
# tesseract Open Source Optical Character Recognition
#################################################################
sudo apt-get -y install tesseract-ocr      
sudo apt-get -y install tesseract-ocr-all  # takes some time
sudo apt-get -y install libtesseract-dev
sudo apt-get -y install libtesseract4
sudo apt-get -y install yagf
sudo -H pip3 install pyocr
sudo -H pip2 install pyocr

#################################################################
sudo apt-get -y update
sudo apt-get -y dist-upgrade
# sudo apt-get -y purge libopencv*
sudo apt-get -y autoremove
sudo apt-get update
#################################################################

#################################################################
# Patching
#################################################################

# https://devtalk.nvidia.com/default/topic/1007290/jetson-tx2/building-opencv-with-opengl-support-/post/5141945/#5141945
# https://www.thegeekstuff.com/2014/12/patch-command-examples
sudo nano /usr/local/cuda/include/cuda_gl_interop.h
# Change:
#
# #if defined(__arm__) || defined(__aarch64__)
# #ifndef GL_VERSION
# #error Please include the appropriate gl headers before including cuda_gl_int$
# #endif
# #else
# #include <GL/gl.h>
# #endif
#
# to:
#
# //#if defined(__arm__) || defined(__aarch64__)
# //#ifndef GL_VERSION
# //#error Please include the appropriate gl headers before including cuda_gl_int$
# //#endif
# //#else
# #include <GL/gl.h>
# //#endif

# If you get following errors:
# /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-linux-gnu/libGL.so: undefined reference to `drmMap'
# /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-linux-gnu/libGL.so: undefined reference to `drmCloseOnce'
# /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-linux-gnu/libGL.so: undefined reference to `drmUnmap'
# /usr/lib/gcc/aarch64-linux-gnu/5/../../../aarch64-linux-gnu/libGL.so: undefined reference to `drmOpenOnce'
#
# fix them with
#
#cd /usr/lib/aarch64-linux-gnu/
#sudo ln -sf tegra/libGL.so libGL.so

#################################################################
# Download
cd ~
curl -L https://github.com/opencv/opencv/archive/4.1.2.zip -o opencv-4.1.2.zip
curl -L https://github.com/opencv/opencv_contrib/archive/4.1.2.zip -o opencv_contrib-4.1.2.zip
unzip opencv-4.1.2.zip
rm  opencv-4.1.2.zip
unzip opencv_contrib-4.1.2.zip 
rm opencv_contrib-4.1.2.zip

# Build
cd opencv-4.1.2
mkdir build
cd build

#If you compiled new cmake:
cmake-gui ..
# otherwise use:
# cmake ..
################################################
# To start run Configure
# Enable Advanced
# Set flags below
# Run Configure until no more errors
# Finally Generate
# Run Generate until no more errors
################################################
# CMAKE_BUILD_TYPE=RELEASE
# PROTOBUF_UPDATE_FILES=ON
# OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-4.1.0/modules
# OPENCV_TEST_DATA_PATH=../opencv_extra/testdata
########################
# search python in cmake-gui window, then
########################
# BUILD_opencv_python2=ON 
# BUILD_opencv_python3=ON 
# PYTHON_INCLUDE_DIR=/usr/include/python3 
# OPENCV_PYTHON3_VERSION=ON
# PYTHON3_EXECUTABLE=/usr/bin/python3
# PYTHON2_NUMPY_INCLUDE_DIRS=/usr/local/lib/python2.7/dist-packages/numpy/core/include
# PYTHON3_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.6/dist-packages/numpy/core/include
########################
# search TBB in cmake-gui window, then
########################
# WITH_TBB=ON
#TBB DIR /home/uutzinger/tbb
#ENV INCLUDE /home/uutzinger/tbb
#LIBRARY ENV /home/uutzinger/tbb/build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_release/libtbb.so
#LIBRARY ENV DEBUG /home/uutzinger/tbb/build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_debug/libtbb_debug.so
#INCLUDE /home/uutzinger/tbb/include
#LIBRARY DEBUG /home/uutzinger/tbb/build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_debug/libtbb_debug.so
#LIBRARY RELEASE /home/uutzinger/tbb/build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_release/libtbb.so
#MALLOC INCLUDE /home/uutzinger/tbb/include
#MALLOC DEBUG /home/uutzinger/tbb/build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_debug/libtbbmalloc_debug.so
#MALLOC RELEASE /home/uutzinger/tbb/build/# linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_release/libtbbmalloc.so
#PROCY DEBUG /home/uutzinger/tbb/build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_debug/libtbbmalloc_proxy_debug.so
#PROCY RELEASE /home/uutzinger/tbb/build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_release/libtbbmalloc_proxy.so
#TBB_VER_FILE /usr/include/tbb/tbb_stddef.h
########################
# search for CUDA in cmake-gui window, then
#######################
# CUDA_VERSION=10.0
# CUDA_ARCH_BIN="5.3"
# CUDA_ARCH_PTX=""
# CUDA_NVCC_FLAGS=--expt-relaxed-constexpr
# CUDA_FAST_MATH=ON
# WITH_CUDA=ON
########################
# search for WITH in cmake-gui window, then
########################
# WITH_CUBLAS=ON
# WITH_GSTREAMER=ON
# WITH_OPENGL=ON
# WITH_QT=ON
# WITH_V4L=ON
# WITH_VTK=ON
# VTK_DIR=/usr/local/lib/cmake/vtk-8.90
# WITH_LIBREALSENSE=ON
########################
# search for ENABLE in cmake-gui window, then
########################
# ENABLE_NEON=ON
# OPENCV_ENABLE_NONFREE=ON
# ENABLE_PRECOMPILED_HEADERS=OFF 
########################
# search for BUILD in cmake-gui window, then
########################
# BUILD_opencv_dnn=ON, might need to be OFF for system protobuf
# BUILD_EXAMPLES=ON 
# BUILD_OPENEXR=ON
# BUILD_WEBP=ON
#
# BUILD_TESTS=OFF 
# BUILD_PERF_TESTS=OFF 
# BUILD_opencv_legacy=OFF  
# BUILD_PROTOBUF=OFF
########################
# search for INSTALL in cmake-gui window, then
########################
# INSTALL_C_EXAMPLES=OFF
# INSTALL_PYTHON_EXAMPLES=ON
# INSTALL_TESTS=OFF 
# CMAKE_INSTALL_PREFIX=/usr/local
################################################

cp ~/caffe/build/install/include/caffe/proto ~/caffe/include/caffe/proto

make -j4
sudo make install
# sudo apt-get -y install python-opencv python3-opencv
sudo ldconfig

python3 -c 'import cv2; print("python3 cv2 version: %s" % cv2.__version__)'
python2 -c 'import cv2; print("python2 cv2 version: %s" % cv2.__version__)'

#################################################################
# libvisionworks
# Completed
#################################################################
sudo apt-get -y install libvisionworks-samples* 
sudo apt-get -y install libvisionworks-sfm-dev* 
sudo apt-get -y install libvisionworks-tracking-dev*

#################################################################
# Some of this was collected from different sources and they had 
# these statements on top of the file:

# Copyright (c) 2018, NVIDIA CORPORATION.  All rights reserved.

# Copyright (C) 2018, Raffaello Bonghi <raffaello@rnext.it>
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its 
#    contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

