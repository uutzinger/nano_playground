######################################################################
# Build Custom Kernel and Driver Modules
######################################################################
# It is not possible to build the kernel on 16Gb SD card even after
# purging libre office and other components.
######################################################################
sudo apt-get update
sudo apt-get -y install libncurses5-dev

#######################################################################
# Check for latest BSP sources
# Make sure to update wget below to match the latest sources
# The latest source can be found here:
# https://developer.nvidia.com/embedded/linux-tegra
#######################################################################
cd ~
mkdir -p nano-bsp-sources
cd nano-bsp-sources
wget https://developer.download.nvidia.com/embedded/L4T/r32_Release_v1.0/jetson-nano/BSP/Jetson-Nano-public_sources.tbz2
tar -xvf Jetson-Nano-public_sources.tbz2 
mv public_sources/kernel_src.tbz2 ~/nano-bsp-sources
tar -xvf kernel_src.tbz2
rm kernel_src.tbz2
rm Jetson-Nano-public_sources.tbz2 

#######################################################################
# configure kernel based on exisiting configuration
# [Build kernel based on exisiting configuration, verify config]
#######################################################################
cd ~/nano-bsp-sources/kernel/kernel-4.9
zcat /proc/config.gz > .config
zcat /proc/config.gz > kernel.config.original
cp /lib/firmware/tegra21x_xusb_firmware ~/nano-bsp-sources/kernel/kernel-4.9/firmware/
#make prepare
#make modules_prepare
#time make -j5 Image
#time make -j5 modules
#ls -alh arch/arm64/boot/Image
#uname -a
#######################################################################
# Patch 4.9 Kernel for zswap
wget https://github.com/torvalds/linux/commit/a85f878b443f8d2b91ba76f09da21ac0af22e07f.patch
patch -p1 < ./a85f878b443f8d2b91ba76f09da21ac0af22e07f.patch
#
sed -i 's/memset_l(page, value, PAGE_SIZE \/ sizeof(unsigned long));/memset(page, value, PAGE_SIZE);/g' ./mm/zswap.c
rm ~/Downloads/a85f878b443f8d2b91ba76f09da21ac0af22e07f.patch
#
#######################################################################
# Backup and create new configuration
cd ~/nano-bsp-sources/kernel/kernel-4.9
make menuconfig
#
# IPVLAN support:
# Networking support -> Netowrking OPtions
# Enable: L3 Master device support
# Device Drivers -> Network device support
# Enable: IPVLAN 
#
# Compressed swap file support:
# https://syonyk.blogspot.com/2019/04/nvidia-jetson-nano-desktop-use-kernel-builds.html
# Kernel features ->
# Enable: frontswap to cache swap pages if tmem is present
# Enable: Compressed cache for swap pages (EXPERIMENTAL) (NEW)
# Enable: Low (Up to 2x) density storage for compressed pages
#
# USB Boot:
# Device Drivers -> Generic Driver Options ->
# External firmware blobs to build into the kernel binary," hit enter, and enter "tegra21x_xusb_firmware" in the field
# 
# Checkout difference between original and new configuration
diff .config kernel.config.original

#######################################################################
# Create New Kernel and Modules
# Install New Kernel and Modules
#######################################################################
cd ~/nano-bsp-sources/kernel/kernel-4.9
make prepare                                # prepare build of kernel
make modules_prepare                        # prepapre build of modules
make -j5 Image                              # make kernel
make -j5 modules                            # make modules
sudo cp /boot/Image /boot/Image.original    # backup old kernel
make -j5                                    # ?
sudo make modules_install                   # install new modules
sudo cp arch/arm64/boot/Image /boot         # install kernel
ls -alh /boot/Image*                        # we should have new kernel and backup
uname -a                                    # 4.9.140-tegra                  
reboot                                      # cross fingers
uname -a                                    # and new kernel is: 4.9...... 

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
sudo cfdisk /dev/sda
# Make ext4 file system
sudo mkfs.ext4 /dev/sda1           # create filesystem
# if you created second partition for swap (instead of swap file)
sudo mkswap /dev/sda2              # create swap partition
# Mount the new system drive
sudo mkdir /mnt/root               # 
sudo mount /dev/sda1 /mnt/root     #
sudo mkdir /mnt/root/proc          #
sudo apt -y install rsync          # install rsync to copy everything to new file system
sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude=/proc / /mnt/root

############################################################################3
# Edit boot configuration on mmcblk  to boot from USB SSD instead of mmcblk
# nano /boot/extlinux/extlinux.conf 
# ? sudo sed -i 's/mmcblk0p1/sda1/' /boot/extlinux/extlinux.conf
# ? sudo sed -i 's/rootwait/rootwait zswap.enabled=1/' /boot/extlinux/extlinux.conf
# It needs to look something like this
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

