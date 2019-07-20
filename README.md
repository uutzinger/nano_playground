# nano_playground
Collection of Scripts and Instructions to Setup Jetson Nano.
Some of the scripts can not be run as a whole but guide the user through the process step but step.
Sources for these scripts were https://github.com/rbonghi/jetson_easy as well as https://www.jetsonhacks.com/2019/04/25/jetson-nano-run-on-usb-drive/ which itself is based on https://syonyk.blogspot.com/2019/04/nvidia-jetson-nano-desktop-use-kernel-builds.html.

CAUTION: You will need at least 32Gbyte SD card to build kernel or OpenCV.

Urs Utzinger, 2019

## purge.sh

This script removes unity-lens and unity-scope components.
It also removes libre office.
This script is based on jetson_easy.

## buildKernelAndModule.sh

This script downloads the kernel sources and gives the ability to setup additional
kernel features such as booting from USB SSD, zswap, intelrealsense.
This script requires execution in stages and does not run on its own.

## biuld_qt.sh

Qt5 does not compile on jetson nano and needs cross compiling. I wanted to build it for ITK-snap which has issues with
Qt integration.

## install_RealVNCalternative.sh

Suggested approach to install and build OpenVPN home server to connect
to devices. I have been using NoMachine server/client to access a remote desktop.

## install_basics.sh

This script prepares the operating system for software development environment with QT and Python.

## install_blinka.sh

Adafruit python bindings.

## install_caffe.sh

Build caffe.

## install_CMake.sh

Donwload and build latest version of CMake.

## install_jetsonGPIO.sh

Update latest version of jetson-gpio.

## install_leveldb.sh

Google's leveldb.

## install_librealsense.sh

Building librealsense for intelRealsense cameras.

## install_networktables.sh

Network tables for FIRST robotics.

## install_tensorflow_keras.sh

This script installs common AI tools and is based on jetson_easy.

## install_tbb_itk_vtk.sh

This script install vtk and itk. ITK snap does not yet compile.

## install_opencv.sh

This script downloads lates OpenC and compiles it with optimized nano settings.

## install_vscode.sh

This script installs Visual Studio Code. Its is based on jetson_easy.

## install_protobuf.sh

Google's protobuf.

## install_ros.sh

Get Robot OS running.

