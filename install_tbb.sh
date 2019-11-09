#########################################################################
# TBB 2019U8
# Completed
#########################################################################
git clone https://github.com/wjakob/tbb.git
cd tbb/build
cmake ..
make -j4
sudo make install

# Above is easier
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

