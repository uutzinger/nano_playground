#########################################################################
# Installation of itk and vtk 
#########################################################################
#

# cmake
# needs curses library
#cd ~
#git clone https://github.com/Kitware/CMake/
#cd cmake
#./bootstrap && make && sudo make install
#########################################################################
# For some reason CMAKE can not find CUDAXX environment and we need to specify
# /usr/local/cuda/bin/nvcc should always point to latest cuda c compiler
#########################################################################
sudo nano /etc/environment
CUDACXX=CUDACXX=/usr/local/cuda/bin/nvcc

#########################################################################
# VTK
#########################################################################
git clone https://gitlab.kitware.com/vtk/vtk
cd vtk
git fetch origin
git rebase origin/master
#########################################################################
# This needs to be done by hand:
# download VTKData.zip from https://vtk.org/download/
# and extract content of .ExternalData into vtk/.ExternalData
mkdir build
cd build
# cmake with GUI 
cmake-gui ..
# FOLLOW https://itk.org/CourseWare/Training/GettingStarted-II.pdf
# enable vtk use large data, cuda, mpi, wrap python
# choose python 3
# choose smp implementation TBB
# choose TK_MPI_NUMPROCS 4
# choose USE_EXTERNAL_VTK_png ON
# repeat configure until no more errors
# generate, might take a while
sudo make -j3
sudo make install

#########################################################################
# ITK
#########################################################################
git clone git://itk.org/ITK.git
git clone git://itk.org/ITKData.git 
cd ITK
mkdir build
cd build
#########################################################################
cmake-gui ..
# do this by hand
# until no more errors..
# then generate, might take a while
# suggested options
#BUILD_DOXYGEN                   *OFF
#BUILD_EXAMPLES                  *ON
#BUILD_TESTING                   *ON
#CMAKE_BACKWARDS_COMPATIBILITY   *2.4
#CMAKE_BUILD_TYPE                *Release
#CMAKE_INSTALL_PREFIX            */usr/local
#ITK_USE_KWSTYLE                 *OFF
TBB
OPENCV
VTK Glue


sudo make -j3
sudo make install


#########################################################################
# ITK snap
#########################################################################
git clone git://git.code.sf.net/p/itk-snap/src itk-snap-src
git submodule init
git submodule update

