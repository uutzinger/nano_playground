######################################################################
# Build Custom Kernel and Driver Modules
######################################################################
# It is not possible to build the kernel on 16Gb SD card even after
# purging libre office and other components.
######################################################################
sudo apt-add-repository universe
sudo apt-get update
sudo apt-get -y install pkg-config libncurses5-dev gparted
sudo apt -y install rsync          # install rsync to copy everything to new file system

#######################################################################
# Check for latest BSP sources
# Make sure to update wget below to match the latest sources
# The latest source can be found here:
# https://developer.nvidia.com/embedded/linux-tegra
#######################################################################
cd ~
mkdir -p nano-bsp-sources
cd nano-bsp-sources
wget https://developer.nvidia.com/embedded/dlc/l4t-sources-32-1-jetson-nano
tar -xvf l4t-sources-32-1-jetson-nano
tar -xvf public_sources/kernel_src.tbz2 
rm -r public_sources
rm  l4t-sources-32-1-jetson-nano

#######################################################################
# configure kernel based on exisiting configuration
# [Build kernel based on exisiting configuration, verify config]
#######################################################################
cd kernel/kernel-4.9
zcat /proc/config.gz > .config
cp .config kernel.config.original
cp /lib/firmware/tegra21x_xusb_firmware ./firmware/
#######################################################################
# Patch 4.9 Kernel for zswap
wget https://github.com/torvalds/linux/commit/a85f878b443f8d2b91ba76f09da21ac0af22e07f.patch
patch -p1 < ./a85f878b443f8d2b91ba76f09da21ac0af22e07f.patch
#
sed -i 's/memset_l(page, value, PAGE_SIZE \/ sizeof(unsigned long));/memset(page, value, PAGE_SIZE);/g' ./mm/zswap.c
rm a85f878b443f8d2b91ba76f09da21ac0af22e07f.patch
#
#######################################################################
# Backup and create new configuration
make menuconfig
#
# You want "*" not "M"
#
# IPVLAN support:
# Networking support -> Netowrking Options
# Enable: L3 Master device support
# Device Drivers -> Network device support
# Enable: IP-VLAN support 
#
# Compressed swap file support:
# https://syonyk.blogspot.com/2019/04/nvidia-jetson-nano-desktop-use-kernel-builds.html
# Kernel features ->
# Enable: Enable frontswap to cache swap pages if tmem is present
# Enable: Compressed cache for swap pages (EXPERIMENTAL) (NEW)
# Enable: Low (Up to 2x) density storage for compressed pages
#
# USB Boot:
# Device Drivers -> Generic Driver Options
# Select: External firmware blobs to build into the kernel binary," hit enter,
# Enter: "tegra21x_xusb_firmware" in the field
# 
# Save and Exit

# Checkout difference between original and new configuration
diff .config kernel.config.original
# should display similar to:
#original
#540c540
#< CONFIG_FRONTSWAP=y
#---
#> # CONFIG_FRONTSWAP is not set
#545,548c545,546
#< CONFIG_ZSWAP=y
#< CONFIG_ZPOOL=y
#< CONFIG_ZBUD=y
#< # CONFIG_Z3FOLD is not set
#---
#> # CONFIG_ZPOOL is not set
#> # CONFIG_ZBUD is not set
#1138c1136
#< CONFIG_NET_L3_MASTER_DEV=y
#---
#> # CONFIG_NET_L3_MASTER_DEV is not set
#1363,1364c1361
#< CONFIG_EXTRA_FIRMWARE="tegra21x_xusb_firmware"
#< CONFIG_EXTRA_FIRMWARE_DIR="firmware"
#---
#> CONFIG_EXTRA_FIRMWARE=""
#1881d1877
#< CONFIG_IPVLAN=y
#1894d1889
#< # CONFIG_NET_VRF is not set

#######################################################################
# Create New Kernel and Modules
# Install New Kernel and Modules
#######################################################################
cd ~/nano-bsp-sources/kernel/kernel-4.9
make -j5                                    # 
sudo make modules_install                   # install new modules
sudo cp /boot/Image /boot/Image.original    # backup old kernel
sudo cp arch/arm64/boot/Image /boot         # install kernel
ls -alh /boot/Image*                        # we should have new kernel and backup
uname -a                                    # 4.9.140-tegra                  
reboot                                      # cross fingers
uname -a                                    # and new kernel is: 4.9.140 {no -tegra}
#make prepare                                # prepare build of kernel
#make -j5 Image                              # make kernel
#make modules_prepare                        # prepapre build of modules
#make -j5 modules                            # make modules
#sudo make modules_install                   # install new modules
############################################################################3
# Create USB ssd system drive
# Wipe partition table on USB drive
#  sudo dd if=/dev/zero of=/dev/sda bs=1M count=1
#
sudo apt-get dist-upgrade
sudo apt remove
sudo apt clean
# get zswap status script
cd ~
wget https://raw.githubusercontent.com/Syonyk/raspberry_pi_scripts/master/zswap.sh
#
# Create disk partitions
sudo gparted /dev/sda
# Create sda1 with ext4 file system
# Create sda2 as linux-swap
# Mount the new system drive
sudo mkdir /mnt/root               # 
sudo mount /dev/sda1 /mnt/root     #
sudo mkdir /mnt/root/proc          #
#
sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude=/proc / /mnt/root

############################################################################3
# Edit boot configuration on mmcblk  to boot from USB SSD instead of mmcblk
# nano /boot/extlinux/extlinux.conf 
# It needs to look something like this:
#
#TIMEOUT 30
#DEFAULT primary
#
#MENU TITLE p3450-porg eMMC boot options
#
#LABEL primary
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

echo "/dev/sda3            none                  swap           \
defaults                                     0 1" | sudo tee -a /etc/fstab


