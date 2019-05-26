#!/bin/bash
#
# Copyright (c) 2018, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA Corporation and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA Corporation is strictly prohibited.
#

#################################
# AND
#################################

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

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <Install Folder>"
    exit
fi
folder="$1"
user=""
passwd=""

#################################################################
sudo apt-get update -y
sudo apt purge libopencv* -y
sudo apt autoremove -y
sudo apt-get update -y
sudo apt full-upgrade -y

# Open GL
sudo apt-get install -y libgl1 libglvnd-dev
# Update GCC
sudo apt-get install -y g++ 
# Dependencies
sudo apt-get install -y build-essential make cmake cmake-curses-gui git pkg-config curl apt-utils
# GTK
sudo apt-get install -y libgtk2.0-dev libglew-dev libgtk2.0-dev
sudo apt-get install -y qt5-default
# AV
sudo apt-get install -y libavformat-dev libavutil-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt-get install -y libdc1394-22-dev libxine2-dev
sudo apt-get install -y libv4l-dev v4l-utils qv4l2 v4l2ucp
sudo apt-get install -y libhdf5-serial-dev hdf5-tools
sudo apt-get install -y libjpeg-turbo8-dev libxvidcore-dev libx264-dev libgtk-3-dev
sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev libjasper-dev
# Python
sudo apt-get install -y libswscale-dev libeigen3-dev
sudo apt-get install -y python2-dev python3-dev python-dev python-numpy python3-numpy
# Intel TBB, Fortran, blas, atlas
sudo apt-get install -y libtbb2 libtbb-dev
sudo apt-get install -y libopenblas-dev libatlas-base-dev gfortran
#
sudo apt-get install libopenblas-dev
#
sudo apt-get update


#################################################################
# Patching
#

# https://devtalk.nvidia.com/default/topic/1007290/jetson-tx2/building-opencv-with-opengl-support-/post/5141945/#5141945
#https://www.thegeekstuff.com/2014/12/patch-command-examples

# sudo patch -p0 -N --dry-run --silent /usr/local/cuda/include/cuda_gl_interop.h patch/opencv/cuda_gl_interop.patch 2>/dev/null
#if [ $? -eq 0 ];
#then
#    #apply the patch
#    tput setaf 6
#    tput sgr0
#    sudo patch -N /usr/local/cuda/include/cuda_gl_interop.h patch/opencv/cuda_gl_interop.patch
#else
#    tput setaf 3
#    tput sgr0
#fi

# If exist the tegra file
# https://devtalk.nvidia.com/default/topic/946136/
#if [ -f /usr/lib/aarch64-linux-gnu/tegra/libGL.so ]; then
#    # Local folder
#    local LOCAL_FOLDER=$(pwd)
# 
#    ### Fix the symbolic link of libGL.so
#    tput setaf 6
#    echo "Fix the symbolic link of libGL.so"
#    tput sgr0
#    cd /usr/lib/aarch64-linux-gnu/   
#        
#    sudo ln -sf tegra/libGL.so libGL.so
#        
#    # Restore previuous folder
#    cd $LOCAL_FOLDER
#fi

#################################################################
# Download
cd $folder
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

# Build
cd opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
  -D CUDA_ARCH_BIN="5.3" \
  -D CUDA_ARCH_PTX="" \
  -D CUDA_NVCC_FLAGS=--expt-relaxed-constexpr \
  -D CUDA_FAST_MATH=ON \
  -D WITH_TBB=ON \
  -D WITH_CUDA=ON \
  -D WITH_GSTREAMER=ON \
  -D WITH_GSTREAMER_0_10=OFF \
  -D WITH_LIBV4L=ON \
  -D WITH_CUBLAS=ON \
  -D WITH_QT=ON \
  -D WITH_OPENGL=ON \
  -D ENABLE_NEON=ON \
  -D ENABLE_FAST_MATH=ON \
  -D OPENCV_ENABLE_NONFREE=ON \
  -D BUILD_opencv_python2=ON \
  -D BUILD_opencv_python3=ON \
  -D BUILD_TESTS=OFF \
  -D BUILD_PERF_TESTS=OFF \
  -D BUILD_EXAMPLES=ON \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D INSTALL_TESTS=OFF \
  -D OPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
  -D CMAKE_INSTALL_PREFIX=/usr/local ..

make -j2
sudo make install
# check if needed ln -s /usr/local/lib/python3.6/site-packages/cv2/python-3.6/cv2.so cv2.so
sudo apt-get install -y python-opencv python3-opencv
sudo ldconfig

# libvisionworks
sudo apt install -y libvisionworks-samples* libvisionworks-sfm-dev* libvisionworks-tracking-dev*


