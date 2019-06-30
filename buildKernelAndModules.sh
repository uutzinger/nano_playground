######################################################################
# Build Custom Kernel and Driver Modules
#
# https://github.com/JetsonHacksNano/buildKernelAndModules
#
# This script will produce a new kernel image and kernel modules.
# 1 Download the source
# 2 Configure kernel
# 3 Patch kernel sources
# 4 Build image
# 5 Build modules
# 6 Backup and Install 
#
# There are four sections:
# - Boot from USB
# - Z swap file support
# - Industrial IO Drivers
# - Docker optimizations (not tested)
#
# The kernel patches currenlty are only needed for Intel RealSense camera
# https://github.com/JetsonHacksNano/installLibrealsense
#
# Caution
# It is not possible to build the kernel on 16Gb SD card even after
# purging libre office and other components.
#
# Issues
#  If you compile an image on an USB booted installation you will
#  need to get the image onto the SD card. For kernel modules
#  I dont have recommendation on how to find out what needs to be
#  copied onto the SD card. I recommend to update the image and modules
#  on the USB drive as well as the SD card by booting to SD card and 
#  then change back to USB drive boot. There is supposed to be a boot
#  menu but I have not figured out how to invoke it at boot.
#
# Urs Utzinger, summer 2019
######################################################################
# This is likely arelady set
#  sudo apt-add-repository universe
#  sudo apt-get update
#
#######################################################################
# Check for latest BSP sources
# Make sure to update wget command below to match the latest sources.
# The latest source can be found here:
# https://developer.nvidia.com/embedded/linux-tegra
#######################################################################
cd /usr/src
sudo wget -N https://developer.nvidia.com/embedded/dlc/l4t-sources-32-1-jetson-nano
sudo tar -xvf l4t-sources-32-1-jetson-nano
sudo tar -xvf public_sources/kernel_src.tbz2 
sudo rm -r public_sources
sudo rm  l4t-sources-32-1-jetson-nano

#######################################################################
# configure kernel based on exisiting configuration
#######################################################################
cd kernel/kernel-4.9
sudo zcat /proc/config.gz > .config         # use existing configuration
sudo cp .config kernel.config.original      # backup config file
sudo cp /boot/Image /boot/Image.original    # backup old kernel
sudo cp /lib/firmware/tegra21x_xusb_firmware ./firmware/
#######################################################################
# Patch 4.9 Kernel for zswap
sudo wget https://github.com/torvalds/linux/commit/a85f878b443f8d2b91ba76f09da21ac0af22e07f.patch
sudo patch -p1 < ./a85f878b443f8d2b91ba76f09da21ac0af22e07f.patch
#
sudo sed -i 's/memset_l(page, value, PAGE_SIZE \/ sizeof(unsigned long));/memset(page, value, PAGE_SIZE);/g' ./mm/zswap.c
sudo rm a85f878b443f8d2b91ba76f09da21ac0af22e07f.patch
#
#######################################################################
# Backup and create new configuration
cd /usr/src/kernel/kernel-4.9
sudo make menuconfig
#
# "m" module load at runtime 
# "*" built in kernel
#
# Compressed swap file support:
# https://syonyk.blogspot.com/2019/04/nvidia-jetson-nano-desktop-use-kernel-builds.html
# Kernel features ->
# Enable: Enable frontswap to cache swap pages if tmem is present
# Enable: Compressed cache for swap pages (EXPERIMENTAL) (NEW)
# Enable: Low (Up to 2x) density storage for compressed pages
#
# USB Boot:
# Device Drivers -> Generic Driver Options - External firmware blobs to build into the kernel binary," Enter: "tegra21x_xusb_firmware" in the field
# 
# Industrial IO support:
# This is set to enable Intel realsense and sensors/IMUs/pulseox I worked with.
# Invensense MPU9250, Bosch BMI161, MAX30100 pulseoximeter, 
# some A/D and D/A drivers from microchip
# humidity sensors.
# If you need more sensors add them to the configuration. Some senors have more than one
# driver option and its not adivsed to enable both. If there is general driver for a
# sensor brand, and a specific one, I recommend using the specific one.
# The enabled sensors have not been attached and tested at this time.
#
# Industrial I/O support: (is far down in Device Drivers menu)
# Enable buffer support within IIO [y]: Device Drivers - Industrial I/O support
# Common modules for all HID Sensor IIO drivers: Device Drivers - Industrial I/O support - Hid Sensor IIO Common
# Common module (trigger) for all HID Sensor IIO drivers): Device Drivers - Industrial I/O support - Hid sensor IIO Common - Common modules for all HID Sensor IIO drivers
# HID Sensors framework support: Device Drivers - HID support - HID bus support - Special HID drivers
# Battery level reporting: Device Drivers - HID support - HID bus support
# HID Accelerometers 3D (NEW): Device Drivers - Industrial I/O support - Accelerometers
# HID Gyroscope 3D (NEW): Device Drivers - Industrial I/O support - Digital gyroscope sensors
# Health Sensors [M]: MAX30100
# Inertial Measurements Invensense MPU6050 I2C
# Inertial Measurements Invensense MPU6050 SPI
# Inertial Measurements BMI161 I2C and SPI
# Light Sensors: HID ALS
# Light Sensors: HID PROX (proximity)
# Light sensors: TAOS
# Magnetometer: HID Mag
# Magnetometer: AK8975
# Magnetometer: Honeywell HMC5843
# Magnetometer: Honeywell HMC5983
# Digital Potentiometers: Michrochip MCP413X
# Digital Potentiometers: Michrochip MCP45XX
# Analog to Digital Converters: MCP3x01
# Analog to Digital Converters: MCP3421
# Digital to Analog Converters: MSP4725
# Digital to Analog Converters: MSP4902
# Humidity sensors: HTU21
# Inclinometer sensors: HID Inclinometer
# Inclinometer sensors: HID Device Rotation
# Pressure senors: HID PRESS
# Pressure senors: Bosch BMP180
# Pressure senors: MS5611
# Pressure senors: MS5637
# Tempreature sensors: MLX90614
# Tempreature sensors: TMP006
#
# Save and Exit
#
#############
# Docker optimization: 
# I have not tested these settings.
# https://blog.hypriot.com/post/nvidia-jetson-nano-build-kernel-docker-optimized/
# HugeTLB controller [y]:        General setup      - Control Group support
# Group Scheduling support [y]:  Enable the block layer - IO Schedulers - CFQ I/O scheduler
# Thin provisioning target [m]:  Device Drivers     - Multiple devices driver - Device mappr support
# Enable: IP-VLAN support [m]:   Device Drivers     - Network device support - Network core driver
# L3 Master device support [*]:  Networking support - Networking Options
# IP: ESP transformation [M]:    Networking support - Networking options - TCP/IP networking
# TCP loadbalancing [*]:         Networking support - Networking options - Networking packet filtering - IP virtual server support
# UDP loadbalancing [*]:         Networking support - Networking options - Networking packet filtering - IP virtual server support
# IPv4/IPv6 redirect support [m]:Networking support - Networking options - Network packet filtering framework - Core Netfilter Configuration 
# NF_TARGET_REDIRECT [m]:        Networking support - Networking options - Network packet filtering framework - IP: Netfiltering configuration - IP tables support - iptables NAT support 
# Redirect target support[]:     Networking support - Networking options - Network packet filtering framework - IP: Netfiltering Configuration - IP tables support - iptables NAT support
# Netfilter Xtables support [m]: Networking support - Networking options - Network packet filtering framework - Core Netfilter Configuration - Netfilter Xtables support 
# Redirect Target support [m]:   Networking support - Networking options - Network packet filtering framework - Core Netfilter Configuration - Netfilter Xtables support
# "multiport" Multiple  [m]:     Networking support - Networking options - Network packet filtering framework - Core Netfilter Configuration - Netfilter Xtables support
# "physdev" match support [m]:   Networking support - Networking options - Network packet filtering framework - Core Netfilter Configuration - Netfilter Xtables support
# "recent" match support [m]:    Networking support - Networking options - Network packet filtering framework - Core Netfilter Configuration - Netfilter Xtables support
#
# Checkout difference between original and new configuration
diff .config kernel.config.original

#######################################################################
# Apply kernel patches
# You can skip these if you want to build them later from USB drive
#######################################################################
cd /usr/src/kernel/kernel-4.9
# from jetson nano hacks librealsense patches
# Realsense-camera-formats patch
sudo patch -p1 < ~/nano_playground/librealsense/patches/realsense-camera-formats_ubuntu-bionic-Jetson-4.9.140.patch
# Realsense-metadata patch
sudo patch -p1 < ~/nano_playground/librealsense/patches/realsense-metadata-ubuntu-bionic-Jetson-4.9.140.patch
# Realsense-hid patch
sudo patch -p1 < ~/nano_playground/librealsense/patches/realsense-hid-ubuntu-bionic-Jetson-4.9.140.patch
# URBS UVC patch
sudo patch -p1 < ~/nano_playground/librealsense/patches/0001-media-uvc-restrict-urb_num-no-less-than-UVC_URBS.patch
# Powerlinefrequency-control-fix patch
sudo patch -p1 < ~/librealsense/scripts/realsense-powerlinefrequency-control-fix.patch

#######################################################################
# Create New Kernel and Modules
# Install New Kernel and Modules
#######################################################################
cd /usr/src/kernel/kernel-4.9
sudo make prepare                           # prepare the image
sudo make modules_prepare                   # prepapre build of modules
sudo make -j5 Image                         # create the new image   
sudo make -j5 modules                       # make modules   
#
# You really should do a backup of your SD card now, you can use Win32 Diskimager:
#  Take the sd card out of the nano (power off) and read it on your PC 
#  and create an image
# Once the modules are installed, you can go back
sudo make modules_install                   # install new modules
# you might need to copy this to SD Card instead of /boot
# e.g. /media/yourusername/longnumber/boot
sudo cp arch/arm64/boot/Image /boot         # install kernel
ls -alh /boot/Image*                        # we should have new kernel and backup
uname -a                                    # 4.9.140-tegra                  
reboot                                      # cross fingers
uname -a                                    # and new kernel is: 4.9.140 {no -tegra}
############################################################################3
# Create USB ssd system drive
#
# Wipe partition table on USB drive with: 
# sudo dd if=/dev/zero of=/dev/sda bs=1M count=1
# or use gparted
#
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt autoremove
sudo apt clean
# get zswap status script
cd ~
wget https://raw.githubusercontent.com/Syonyk/raspberry_pi_scripts/master/zswap.sh
#
# Create disk partitions
sudo gparted /dev/sda
# Create sda1 with ext4 file system
# Create sda2 as linux-swap
# Mount the new system drive to copy SD card content onto it
sudo mkdir /mnt/root               # 
sudo mount /dev/sda1 /mnt/root     #
sudo mkdir /mnt/root/proc          #
# copy all files
sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude=/proc / /mnt/root

############################################################################3
# Edit boot configuration on mmcblk  to boot from USB SSD instead of mmcblk
# sudo nano /boot/extlinux/extlinux.conf 
#
# !! MAKE SURE THE SDA# PARTITION IS WHERE YOUR SYSTEM IS!!
#
# It needs to look something like this:
#
#TIMEOUT 30
#DEFAULT primary
#
#MENU TITLE p3450-porg eMMC boot options
#
#LABEL ssd
#      MENU LABEL primary kernel
#      LINUX /boot/Image
#      INITRD /boot/initrd
#      APPEND ${cbootargs} rootfstype=ext4 root=/dev/sda1 rw rootwait zswap.enabled=1
#
#LABEL emmc
#      MENU LABEL primary kernel
#      LINUX /boot/Image
#      INITRD /boot/initrd
#      APPEND ${cbootargs} rootfstype=ext4 root=/dev/mmcblk0p1 rw rootwait

# Enable the swap space we created with gparted
# !! AGAIN MAKE SURE THE SDA# PARITION NUMBER MATCHES WITH WHAT GPARTED SHOWS !!
#
sudo echo "/dev/sda3            none                  swap           \
defaults                                     0 1" | sudo tee -a /etc/fstab
# you might want to copy the fstab file also to the USB drive or SD card

