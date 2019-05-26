#####################################################################################
# 
# Install Basics
#
# For 16Gb SD card there is not enough space to build new Kernel and Modules after
# executing this script even with purge of liberoffice.
# 
#####################################################################################

#####################################################################################
# Install Dev Basics
#####################################################################################
sudo apt-get -y install apt-utils
sudo apt-get -y install pkg-config 


# PIP
wget https://bootstrap.pypa.io/get-pip.py
sudo -H python3 get-pip.py
sudo -H python2 get-pip.py
rm get-pip.py

sudo apt-get -y install nano # light weight editor
sudo apt-get -y install build-essential cmake cmake-curses-gui cmake-gui

# Python Development
sudo apt-get -y install python3-dev python3-tk python-dev python-tk
sudo apt-get -y install python3-pil python3-lxml python-pil python-lxml

#####################################################################################
# Install pre-requs for many desired packages
#####################################################################################

# QT
sudo apt-get -y install qtcreator                # QT
sudo apt-get -y install qt5x11extras5-dev        # VTK

# System
sudo apt-get -y guake iftop synergy # guake terminal, frequently used network connection, share keyboard and mouse between multiple computers

#
sudo apt-get -y install libssl-dev libusb-1.0-0-dev 
sudo apt-get -y install libgtk-3-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev

# ITK and VTK
sudo apt-get -y install libpng-dev libtiff-dev   # ITK, VTK, OpenCV
sudo apt-get -y install uuid-dev                 # VTK
sudo apt-get -y install libtclap-dev             # VTK
sudo apt-get -y install python-vtk               # VTK

sudo apt-get install protobuf-compiler
sudo apt-get install libxml2-dev libxslt-dev 
sudo snap install libxslt


# NumPy
sudo -H pip3 install numpy
#sudo -H pip install numpy

# SciPy
sudo -H pip3 install scipy
#sudo -H pip install scipy

#Matplot lib
sudo -H pip3 install matplotlib
#sudo -H pip install matplotlib

### Modify matplotlibrc (line #41) as 'backend      : TkAgg'
#sudo sed -i 's/backend      : gtk3agg/backend      : TkAgg/' /usr/local/lib/python3.5/dist-packages/matplotlib/mpl-data/matplotlibrc
#sudo sed -i 's/backend      : gtk3agg/backend      : TkAgg/' /usr/local/lib/python2.7/dist-packages/matplotlib/mpl-data/matplotlibrc

sudo -H pip3 install -U grpcio absl-py py-cpuinfo psutil portpicker grpcio six mock requests gast h5py astor termcolor

sudo -H pip3 install Cython 
sudo -H pip3 install contextlib2 
sudo -H pip3 install pillow 
sudo -H pip3 install pycocotools
sudo -H pip3 install lxml 

