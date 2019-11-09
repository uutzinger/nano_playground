#####################################################################################
# 
# Jetson Installation Basics
#
# This will install many libraries needed for VTk, ITK, OpenCV, Python as well as
# Scientific Computing.
#
# It is advised to follow this script before building a modified kernel.
#
# Caution:
# There is not enough space on a 16Gb SD card to build a new Kernel and Modules after
# executing this script, even with purge of liberoffice.
# Because ROS is using python2 and ROS2 python3 I tend to install both python2
# python3 version of python libraries.
# 
# Urs Utzinger, 2019
#####################################################################################
echo >> ~/.bashrc
echo "export PATH=/usr/local/cuda/bin:\${PATH}" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64:\${LD_LIBRARY_PATH}" >> ~/.bashrc

sudo apt-add-repository universe
sudo apt-get update                # Set the database
sudo apt-get dist-upgrade          # This will take a while
sudo apt-get autoremove            # There are quite a few leftovers on SD card image

#####################################################################################
# Install Dev Basics
#####################################################################################
sudo apt-get -y install apt-utils  #
sudo apt-get -y install pkg-config #
sudo apt-get -y install curl       #
sudo apt-get -y install git        #
sudo apt-get -y install htop       #

# PIP
wget https://bootstrap.pypa.io/get-pip.py
sudo -H python3 get-pip.py
sudo -H python2 get-pip.py
rm get-pip.py

# Building Stuff
sudo apt-get -y install g++  # update compiler
sudo apt-get -y install build-essential make cmake cmake-curses-gui cmake-qt-gui
sudo apt-get -y install gfortran

# Python Development
sudo apt-get -y install python3-dev python3-tk python-dev python-tk
sudo apt-get -y install pylint

#####################################################################################
# System
#####################################################################################
sudo apt-get -y install nano # light weight editor
sudo apt-get -y install unzip
sudo apt-get -y install sshpass

# guake terminal, 
# frequently used network connection, 
# share keyboard and mouse between multiple computers
sudo apt-get -y install guake iftop synergy
# ...
sudo apt-get -y install libssl-dev # secure socket layer
sudo apt-get -y install libusb-1.0-0-dev # user space USB programming

sudo apt-get -y install libncurses5-dev gparted
sudo apt-get -y install rsync  # install rsync, used for USB boot

#####################################################################################
# Install pre-requs for desired packages
#####################################################################################

# QT, this will pull 600MB and take some time
sudo apt-get -y install qtbase5-dev
sudo apt-get -y install qt5-default               # OpenCV
sudo apt-get -y install qtcreator                 # OpenCV 
sudo apt-get -y install libqt5x11extras5          # VTK
sudo apt-get -y install libqt5x11extras5-dev      # VTK
sudo apt-get -y install qt5ct
sudo apt-get -y install qt5-style-plugins
sudo apt-get -y install qt5-image-formats-plugins
sudo apt-get -y install qtgstreamer-plugins-qt5
sudo apt-get -y install libqt5gstreamer-dev

# GTK
sudo apt-get -y install libgtk-3-dev 
sudo apt-get -y install libgtk2.0-dev libglew-dev # OpenCV
sudo apt-get -y install libcanberra-gtk-module    # gparted
# GL
sudo apt-get -y install libglfw3-dev 
sudo apt-get -y install libgl1-mesa-dev libglu1-mesa-dev
sudo apt-get -y install libgl1 libglvnd-dev 	  # OpenCV
# ITK and VTK
sudo apt-get -y install uuid-dev                  #
sudo apt-get -y install libtclap-dev              #

#OpenCV
#######
# AV
sudo apt-get install -y libavformat-dev libavutil-dev libavcodec-dev
sudo apt-get install -y libswscale-dev            # FFMpeg library for image scaling
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 
sudo apt-get install -y libgstreamer-plugins-good1.0-dev
sudo apt-get install -y libdc1394-22-dev libxine2-dev
sudo apt-get install -y libv4l-dev v4l-utils qv4l2 v4l2ucp # video for linux
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libjpeg8-dev libjpeg-turbo8-dev libpng-dev libtiff-dev # jpeg, png, tiff
sudo apt-get install -y flake8                    # audio codec
# jasper, need manual install
# do not "sudo apt-get install jasper", this is not the jasper you need and will break your system
# Follow these links instead
# https://launchpad.net/ubuntu/xenial/arm64/libjasper-dev/
wget http://launchpadlibrarian.net/376191781/libjasper-dev_1.900.1-debian1-2.4ubuntu1.2_arm64.deb
# https://launchpad.net/ubuntu/xenial/arm64/libjasper1
wget http://launchpadlibrarian.net/376191785/libjasper1_1.900.1-debian1-2.4ubuntu1.2_arm64.deb
sudo apt-get install ./libjasper1_1.900.1-debian1-2.4ubuntu1.2_arm64.deb
sudo apt-get install ./libjasper-dev_1.900.1-debian1-2.4ubuntu1.2_arm64.deb
# glog, gflags
sudo apt-get -y install libgflags-dev             #
sudo apt-get -y install libgoogle-glog-dev        #
# Extensible Markup Lanugage
sudo apt-get -y install libxml2-dev libxslt-dev   #
sudo snap       install libxslt                   # large download

# Protobuf
# If  you build latest version dont install here
#sudo apt-get -y install libprotobuf-dev           #
#sudo apt-get -y install protobuf-compiler         #
# String keys to string values
sudo apt-get -y install libleveldb-dev
# Compressor Decompressor
sudo apt-get -y install libleveldb-dev
# Lighting Memory-Mapped Database (LMDB) developed for the OpenLDAP Project.
sudo apt-get -y install liblmdb-dev 

# Scientific Computing
######################
# Intel TBB, Fortran, blatlas
sudo apt-get -y install libtbb2 libtbb-dev        #
# NumPy, vector and matrix math
# BLAS basic linear algebra
sudo apt-get -y install libopenblas-dev           #
sudo apt-get -y install libatlas-base-dev         #
sudo apt-get -y install libopenblas-base          #
sudo apt-get -y install liblapack-dev             #
sudo apt-get -y install liblapacke-dev            #
sudo apt-get -y install libeigen3-dev             #
# Boost
sudo apt-get -y install --no-install-recommends libboost-dev libboost-all-dev # this is 180MB of stuff
# HD5 data format
sudo apt-get -y install libhdf5-dev               # hdf5 file format
sudo apt-get -y install libhdf5-serial-dev        # hdf5 file format
sudo apt-get -y install hdf5-tools                # hdf5 file format
# LAS data file format
sudo apt-get -y install libblas-dev 
# Message Passaging Interface
sudo apt-get -y install libopenmpi-dev            #

# Consider installing and compiling latest
# leveldb
# CMake
# protobuf
install_cmake.sh
install_leveldb.sh
install_protobuf.sh

#####################################################################################
# Install Python Packages
#####################################################################################
# Matrix and Vector calculations
sudo -H pip3 install -U numpy        # 1.16.4
sudo -H pip2 install -U numpy        # 1.16.4
# Plotting library
sudo -H pip3 install -U matplotlib   # 2.1.1
sudo -H pip2 install -U matplotlib   # 2.2.4
# SciPy,  mathamtics, science and engineering
sudo -H pip3 install -U scipy        # 1.3
sudo -H pip2 install -U scipy        # 1.2.2
# Data Analysis
sudo -H pip3 install -U pandas       # 0.24.2
sudo -H pip2 install -U pandas       # 0.24.2
# Symbolic math
sudo -H pip3 install -U sympy        # 1.1.1
sudo -H pip2 install -U sympy        # 1.0.0
# Message Passaging Interface
sudo -H pip3 install -U mpi4py       # 3.0.1
sudo -H pip2 install -U mpi4py       # 3.0.1
# Pillow, python imaging library
#sudo -H pip3 install pillow==5.4.1   # 5.4.1
#sudo -H pip2 install pillow==5.4.1   # 5.4.1
sudo -H pip3 install -U pillow   # 
sudo -H pip2 install -U pillow   # 
# Extensible Markup Lanugage
sudo -H pip3 install -U lxml         # 4.2.1
sudo -H pip2 install -U lxml         # 4.2.1
# python testing
sudo -H pip3 install -U nose         # 1.3.7
sudo -H pip2 install -U nose         # 1.3.7
# protocol buffer
#sudo -H pip3 install -U protobuf     # 3.8.0
#sudo -H pip2 install -U protobuf     # 3.8.0
# Jetson I/O header support
sudo -H pip3 install -U Jetson.GPIO  # 0.1.3
sudo -H pip2 install -U Jetson.GPIO  # Jetson General Purpose IO (python support for jetson header pins)
# Python to C compiler
sudo -H pip3 install -U Cython       # 0.29.10
sudo -H pip2 install -U Cython       # python to C compiler
# Misc
sudo -H pip3 install -U testresources # 2.0.1
sudo -H pip2 install -U testresources # 2.01
sudo -H pip3 install -U h5py         # 1.16.4 hdf5 datasets
sudo -H pip2 install -U h5py         # 1.16.4 hdf5 datasets
#
sudo -H pip3 install grpcio          # 1.21.1 universal RPC framework
sudo -H pip2 install grpcio          # 1.21.1 universal RPC framework
sudo -H pip3 install absl-py         # 0.7.1 building applications
sudo -H pip2 install absl-py         # building applications
sudo -H pip3 install py-cpuinfo      # 5.0.0 CPU info
sudo -H pip2 install py-cpuinfo      # CPU info
sudo -H pip3 install psutil          # 5.6.2 system monitoring
sudo -H pip2 install psutil          # system monitoring
sudo -H pip3 install portpicker      # 1.3.1 finding unused network ports
sudo -H pip2 install portpicker      # finding unused network ports
sudo -H pip3 install six             # 1.12.0 python 2 to 3 smoothing transition
sudo -H pip2 install six             # python 2 to 3 smoothing transition
sudo -H pip3 install mock            # 3.0.5 mock object library
sudo -H pip2 install mock            # mock object library
sudo -H pip3 install requests        # 2.22.0 deals with http requests
sudo -H pip2 install requests        # deals with http requests
sudo -H pip3 install gast            # abstract syntaxt tree
sudo -H pip2 install gast            # 0.2.2 abstract syntaxt tree
sudo -H pip3 install astor           # easy manipulation of python source via AST
sudo -H pip2 install astor           # 0.8.0 easy manipulation of python source via AST
sudo -H pip3 install termcolor       # 1.1.0 terminal printing in color
sudo -H pip2 install termcolor       # terminal printing in color
sudo -H pip3 install contextlib2     # 0.5.5 utility for with statement context
sudo -H pip2 install contextlib2     # utility for with statement context
sudo -H pip3 install pycocotools     # 2.0.0 tool to work with mscoco dataset
sudo -H pip2 install pycocotools     # tool to work with mscoco dataset
sudo -H pip3 install scikit-learn    # 0.21.2 takes time, 20mins
sudo -H pip2 install scikit-learn    # takes time, 20mins
sudo -H pip3 install scikit-image    # 0.15.0 20 mins
sudo -H pip2 install scikit-image    # 0.14.2 20 mins
sudo -H pip3 install ipython         # 4.2.1 Interactive Python 
sudo -H pip2 install ipython         # 1.7
#
sudo -H pip3 install networkx        # 4.4.0 complex network study
sudo -H pip2 install networkx        # 4.4.0
sudo -H pip3 install python-dateutil # 2.6.1 datetime extension
sudo -H pip2 install python-dateutil # 
sudo -H pip3 install python-gflags   # 3.1.2 command line flags processing
sudo -H pip2 install python-gflags   # 3.1.2
sudo -H pip3 install pyyaml          # 3.12 YAML is a human friendly data serialization standard for all programming languages
sudo -H pip2 install pyyaml          # 3.12

# Jetsons status, jtop lists GPU usage and system information
git clone https://github.com/rbonghi/jetson_stats.git
sudo -H pip2 install jetson-stats
sudo -H pip3 install jetson-stats

#sudo apt-get -y install pitivi frei0r-plugins    # video editor

sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y clean

#
#
# !! Now would be a good time to backup your SD card !!
#
#

