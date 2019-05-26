# nano_playground
Collection of Scripts and Instructions to Setup Jetson Nano.
Some of the scripts can not be run as a whole but guide the user through the process step but step.
Sources for these scripts were https://github.com/rbonghi/jetson_easy as well as https://www.jetsonhacks.com/2019/04/25/jetson-nano-run-on-usb-drive/ which itself is based on https://syonyk.blogspot.com/2019/04/nvidia-jetson-nano-desktop-use-kernel-builds.html.

CAUTION: You will need at least 32Gbyte SD card to build kernel or OpenCV.
CAUTION: USB bandwidth will need to be shared between all devices attached to USB. The USB drivers do not seem to be bug free. For example my wirless keyboard requires unplug/replug regularly. I had issues copying between two USB drives; while one large copy process was executed the start of a second one would render the machine unusable.

Urs Utzinger, 2019

## purge.sh

This script removes unity-lens and unity-scope components.
It also removes libre office.
This script is based on jetson_easy.

## buildKernelAndModule.sh

This script downloads the kernel sources and gives the ability to setup additional
kernel features such as booting from USB SSD, zswap and VLAN support.
This script requires execution in stages and does not run on its own.

## install_basics.sh

This script prepares the operating system for software development environment with QT and Python.

## install_tensorflow_keras.sh

This script installs common AI tools and is based on jetson_easy.

## install_itk_vtk.sh

This script has not yet completed and itk section still needs work.

## install_opencv.sh

This script downloads lates OpenCV code and compiles it with ideal nano settings.

## install_vscode.sh

This script installs Visual Studio Code. Its is based on jetson_easy.
Not yet fully polished.
