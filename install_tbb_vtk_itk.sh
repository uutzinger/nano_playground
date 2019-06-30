#########################################################################
# Installation of itk and vtk 
#########################################################################
#
# Build VTK first (passes)
# then ITK and ITK-snap (does not pass)
#
# Urs Utzinger, Summer 2019
#########################################################################

sudo nano /etc/environment
CUDACXX=CUDACXX=/usr/local/cuda/bin/nvcc

export CUDACXX=/usr/local/cuda-10.0/bin/nvcc
export PATH=${PATH}:/usr/local/cuda/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64

#########################################################################
# TBB 2019U8
# Completed
#########################################################################
# https://stackoverflow.com/questions/10726537/how-to-install-tbb-from-source-on-linux-and-make-it-work
# /tbb/build/index.html
git clone https://github.com/intel/tbb
cd tbb
make -j4
# make -j4 all
nano ~/.bashrc
# add, make sure TBB_INSTALL matches the download directory from git above
export TBB_INSTALL_DIR=$HOME/tbb
export TBB_INCLUDE=$TBB_INSTALL_DIR/include
export TBB_LIBRARY_RELEASE=$TBB_INSTALL_DIR/build/linux_aarch64_gcc_cc7.4.0_lib$
export TBB_LIBRARY_DEBUG=$TBB_INSTALL_DIR/build/linux_aarch64_gcc_cc7.4.0_libc2$
# might need also
# TBBROOT $HOME/tbb
# tbb_bin "/home/uutzinger/tbb/build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_release"
# CPATH "${TBBROOT}/include"
# LIBRARY_PATH "${tbb_bin}"
# LD_LIBRARY_PATH "${tbb_bin}:$LD_LIBRARY_PATH" #
#
cd ~/tbb/cmake
# libraries are here:
# /home/utzinger/tbb/build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_release/libtbb.so.2
# therefore relative lib path is "build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_release"
# and relative include path is "include"
cmake -DINSTALL_DIR=/home/uutzinger/tbb -DSYSTEM_NAME=Linux -DTBB_VERSION_FILE=/home/uutzinger/tbb/include/tbb/tbb_stddef.h  -DINC_REL_PATH= include -DLIB_REL_PATH=build/linux_aarch64_gcc_cc7.4.0_libc2.27_kernel4.9.140_release -P tbb_config_installer.cmake

#########################################################################
# VTK 8.9
# Completed
#########################################################################
# https://itk.org/CourseWare/Training/GettingStarted-II.pdf
# https://vtk.org/Wiki/VTK/Configure_and_Build#Configure_VTK_with_CMake
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
# cmake with GUI , needs cmake-3.10
~/CMake/bin/cmake-gui -D CUDACXX=/usr/local/cuda/bin/nvcc ..
#
# MAKE_BUILD_TYPE Release
# VTK_USE_LARGE_DATA
# VTK_USE_CUDA ON
# VTK_USE_MPI ON
# VTK_WRAP_PYTHON ON
# VTK_PYTHON_VERSION 	3
# VTK_SMP_IMPLEMENTATION_TYPE 	TBB
# VTK_MPI_NUMPROCS 	4
# MPIEXEC_MAX_NUMPROC 	4
# USE_EXTERNAL_VTK_png 	ON, this might require to edit CMakeCache.txt and remove png_LIB_DEPENDS
#
# Edit TBB sections and set all the folders and files to match 
#  the ~/tbb/include and ~/tbb/build folders where you built tbb
#
# Configure
# until no more errors
#
# Generate
# This might take a while, generate is active when button switched to "Stop"
# but there might be no progress bar or changes to it for a while.
#
make -j4
sudo make install

#######################################################
# VXL, https://github.com/InsightSoftwareConsortium/vxl
# Completed
#######################################################
git clone http://git.code.sf.net/p/vxl/git vxl
cd vxl
git pull
# ./scripts/setup-for-development.bash
~/CMake/bin/cmake-gui
# Configure
# Generate
make -j4 # takes 15 -20 minutes
sudo make install

#######################################################
# OpenJPEG
# Completed
#######################################################
git clone https://github.com/uclouvain/openjpeg
mkdir build
cd build
~/CMake/bin/cmake-gui .. -DCMAKE_BUILD_TYPE=Release
make -j4
sudo make install

#######################################################
# OpenSlide
# Completed
#######################################################
git clone https://github.com/openslide/openslide
# Pre Requisites
sudo apt-get install autoconf automake libtool pkg-config 
sudo apt-get install libopenjp2-7 libopenjp2-7-dev
sudo apt-get install zlib1g zlib1g-dev
sudo apt-get install libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-common libgdk-pixbuf2.0-dev
sudo apt-get install libxml2 libxml2-dev
sudo apt-get install sqlite
sudo apt-get install libjpeg8 libjpeg-dev
sudo apt-get install libtiff5 libtiff5-dev
sudo apt-get install libglib2.0-dev
sudo apt-get install libglib2.0-dev-bin
sudo apt-get install libcairo2 libcairo2-dev
#install
autoreconf -i
./configure
make -j4
make install
sudo -H pip install openslide-python
sudo -H pip3 install openslide-python

#########################################################################
# ITK
# still working on it
#########################################################################
# https://itk.org/Wiki/ITK/Getting_Started/Build/Linux
git clone https://github.com/InsightSoftwareConsortium/ITK
#wget https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.0.0/InsightData-5.0.0.tar.gz
# Unpack InsightData-5.0.0.tar.gz and move .ExternalData to ITK/.ExternalData folder
cd ITK
mkdir build
cd build
#########################################################################
~/CMake/bin/cmake-gui ..         # This will take along time
# Configure,  until there are no more errors / no red fields ...
# Generate, which might take a while (Generate button switches to Stop)
# First USE DEFAULT FEATURES
#########################################################################
make -j4
sudo make install

#########################################################################
# Now play with extra modules
# 
# ITK_BUILD_DEFAULT_MODULES	ON
# ITK_USE_GPU 			OFF, OpenCL not available for jetson nano 
# ITK_USE_KWSTYLE               ON, might need to be turned off
# ITK_WRAP_PYTHON		ON

#   Module_SphinxExamples	OFF, does not configure
#   Module_PhaseSymmetry	OFF, does not configure
#   Module_RTK			OFF, can not find Eigen and some modules already defined errors
#   RTK_BUILD_APPLICATIONS      OFF, does not configure
#   Module_SkullStrip_BUILD_EXA OFF, does not configure
#   Module_VariationRegistrat   OFF, does not configure
#   Module_WikiExamples         OFF, does not configure
#   Module_LesionSizingToolkit  OFF, does not configure
#   Module_ITKIODCMTK		OFF, does not compile
#   Module_IOTransformDCMTK     OFF, does not complile

#
# ITKIOImageBaseCastXML does not compile
# ITKDCMTK_ExtProject
# ITKIOImageBaseBase
#

# Modules on GITHUB ITK consortium
#  Module_AnisotropicDiffusionLBR ON
#  Module_AnalyzeObjectMap 	ON
#  Module_BioCell		ON
#  Module_BoneMorphometry	ON
#  ITK_WRAP_PYTHON		ON
#  Module_BridgeNumPy		ON
#  Module_Cuberille		ON
#  Module_FixedPointInverseDisplacementField ON
#  Module_GenericLabelInterpolator ON
#  Module_HigherOrderAccurateGradient ON
#  Module_ITKVIdeoBridgeOpenCV	OFF, compilation fails, FOURCC and other issues
#  Module_ITKVideoBridgeVXL     ON
#    ITK_USE_SYSTEM_VXL		ON
#  Module_ITKThickness3D	OFF
#     cd ${itk_src}/Modules/External
#     git clone https://github.com/InsightSoftwareConsortium/ITKThickness3D
#  Module_ITKDCMTK		ON
#  Module_ITKIODCMTK		ON
#  Module_IOTransformDCMTK	ON
#  Module_IOMeshSTL		ON
#  Module_IOTransform 		ON
#  Module_IsotropicWavelets     ON
#  Module_ITKVtkGlue		ON
#  Module_IOFDF                 ON
#  Module_IOOpenSlide           ON 
#  Module_LabelErodeDilate      ON
#  LesionSizingTookit           OFF
#  Module_LesionSizingToolkit	ON
#  LSTK_USE_VTK 		ON
#  Module_MinimalPathExtraction ON
#  Module_NeuralNetworks        ON
#  Module_ParabolicMorphology   ON
#  Module_PerformanceBenchmarking ON
#  Module_PrincipalComponentAnalysis ON
#  Module_PolarTransform	ON
#  Module_RobustPredicate 	ON
#  Module_SCIFIO 		ON
#  Module_SkullStrip		ON
#  Module_SmoothingRecursiveYvvGaussianFilter ON
#  Module_SplitComponents	ON
#  Module_SubdivisioQuadEdgeMeshFilter ON
#  Module_TextureFeatures	ON
#  Module_TotalVariation	ON
#  Module_TwoProjectionRegistration ON
#  Module_VariationalRegistration OFF
#  Module_WikiExamples		OFF
#  Module_ITKTBB		OFF
#   TBB_DIR                        /home/utzinger/tbb
#   TBB_INCLUDE                    /home/utzinger/tbb/include
#   TBB_LIBRARY_DEBUG              /home/utzinger/tbb/build/... libtbb_debug.so
#   TBB_LIBRARY_RELEASE            /home/utzinger/tbb/build/... libtbb.so
#   TBB_MALLOC_INCLUDE_DIR         /home/utzinger/tbb/include
#   TBB_MALLOC_LIBRARY_DEBUG       /home/utzinger/tbb/build/... libtbb_malloc_debug.so
#   TBB_MALLOC_LIBRARY_RELEASE     /home/utzinger/tbb/build/... libtbb_malloc.so
#   TBB_MALLOC_PROXY_INCLUDE_DIR   /home/utzinger/tbb/include
#   TBB_MALLOC_PROXY_LIBRARY_DEBUG /home/utzinger/tbb/build/... libtbb_malloc_proxy_debug.so
#   TBB_MALLOC_PROXY_LIBRARY_RELEASE /home/utzinger/tbb/build/... libtbb_malloc/proxy.so
#
#########################################################################
# Fixing issues:
#
# Because of
#
#
#   CMake Error at /usr/local/lib/cmake/opencv4/OpenCVConfig.cmake:108 (message):
#     OpenCV static library was compiled with CUDA 10.0 support.  Please, use the
#     same version or rebuild OpenCV with CUDA
#
# Add manual entry in cmake-gui: CUDA_VERSION_STRING and set it to 10.0
#
#   CMake Error at Modules/Remote/LesionSizingToolkit/CMakeLists.txt:20 (include):
#     include called with wrong number of arguments.  include() only takes one
#     file.
#  include(${VTK_USE_FILE}), issue is that VTK_USE_FILE is empty/not defined
# Tried manual download and manual build but does not complete
# 	sudo python3 -m pip install scikit-build
#	 python3 setup.py build
# ALso tried
# 	python -m pip install itk-lesionsizingtoolkit
# Module_Lesion... OFF
#
# Targets not yet defined:
# Eigen;itkvcl;itknetlib;itkv3p_netlib;itkvnl;itkvnl_algo;itktestlib
# Module_RTK OFF
#
# Call Stack (most recent call first):
#  Modules/Remote/WikiExamples/itk-module-init.cmake:8 (find_package)
#  CMake/ITKModuleEnablement.cmake:318 (include)
#  CMakeLists.txt:433 (include)
# Module_WikiExamples OFF
#
# CMake Error at Wrapping/TypedefMacros.cmake:730 (message):
#  Wrapping itk::VariationalRegistrationCurvatureRegularizer: No image type
#  for '2+' pixels is known.
# Module_Variational... OFF
#
# CMake Error in Wrapping/Generators/Python/PyUtils/CMakeLists.txt:
#  Imported target "TBB::tbb" includes non-existent path
#
#    "/home/uutzinger/tbb/../../../include"
# Module TBB OFF
#
# CMakeFiles/ITKData.dir/build.make:16575: recipe for target 'ExternalData/Modules/Remote/Thickness3D/test/Baseline/medial_thickness.tiff-hash-stamp' failed
#Module_Thickness3D OFF

########################################################################

# Generate

sudo make -j4      # This will take a very long time (4-6 hours)
sudo make install  #

#########################################################################
#########################################################################
# ITKMeshToPolyData --------------
git clone https://github.com/InsightSoftwareConsortium/ITKMeshToPolyData/
python3 ./setup.py

# ITKNDreg ----------------------
cd ~/ITK/Modules/ManualBuild
git clone https://github.com/InsightSoftwareConsortium/ITKNDReg
mkdir ITKNDReg-build
cd ITKNDReg-build
cmake -DITK_DIR=~/ITK/build ../ITKNDReg
cmake --build .
# ITKHigherOrderAccurateGradient
cd ~/ITK/Modules/ManualBuild
git clone https://github.com/InsightSoftwareConsortium/ITKHigherOrderAccurateGradient
mkdir ITKHigherOrderAccurateGradient-build
cd ITKHigherOrderAccurateGradient-build
cmake -DITK_DIR=~/ITK/build ../ITKHigherOrderAccurateGradient
cmake --build .
# SimpleITK
# https://github.com/InsightSoftwareConsortium/SimpleITK
# ...

# Individual Modules on TIK Github but not included in cmake-gui
#
# ITKBSplineGradient
# ITKVoronoiQuadEdgeMeshFilter
# ITKRingArtifcat
#   python -m pip install itk-ringartifact
# ITKArrayFire
# TBBImageToImageFilter
# itkMGHImageIO
# ITKMeshNoise; Module to perturb objects
# ITKPythonPackage; Builds Python Wheels
# ITKModuleTemplate; Starting Point for New Modules
# ITK-OpenCV-Bridge-Tutorial; How to use ITK from OpenCV
#########################################################################
#########################################################################

#########################################################################
# Python
python  -m pip  install --upgrade pip
python3 -m pip3 install --upgrade pip3
python  -m pip  install itk
python3 -m pip3 install itk

#########################################################################
#ITKMontage
#########################################################################
git clone https://github.com/InsightSoftwareConsortium/ITKMontage

#########################################################################
#ITK Performance Benchmarking
#########################################################################
git clone https://github.com/InsightSoftwareConsortium/ITKPerformanceVisualization.git
cd ITKPerformanceVisualization
yarn install
yarn start


#########################################################################
# ITKTestImageFormats
#########################################################################
https://github.com/InsightSoftwareConsortium/ITKTestImageFormats

#########################################################################
# ITK snap
#
# ITK is at 5.0/5.1
# VTK is at 8.90
# CMake is at 3.14.1
# Much newer than ITK snap requires.
#########################################################################
sudo apt-get install qt5dxcb-plugin
git clone git://git.code.sf.net/p/itk-snap/src itksnap
cd itksnap
git submodule init
git submodule update
cd build
~/CMake/bin/cmake-gui ..

#BUILD_GUI
#SNAP_USE_QT4    On
#CMAKE_PREFIX_PATH Filepath to  C:/Qt/5.4/msvc2013_x64/lib/cmake
#ITK_DIR         was found automatically
#VTK_DIR         was foudn automatically

  INCLUDE called with wrong number of arguments.  include() only takes one
  file.

  CMake Error at CMakeLists.txt:1486 (get_property):
  get_property could not find TARGET Qt5::QXcbIntegrationPlugin.  Perhaps it
  has not yet been created.


