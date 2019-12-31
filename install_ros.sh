#########################################################
# Robot Operating System
#
# Reference
# http://wiki.ros.org/melodic/Installation/Ubuntu
# Meldic is LTS version
# Urs Utzinger 
# Summer 2019
#########################################################

# Update source and get keys
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# Install
sudo apt-get update
sudo apt-get -y install ros-melodic-desktop-full # This installs tons of files
# Initilize
sudo rosdep init
rosdep update
# Set environment
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc 
source ~/.bashrc

# Python 2
sudo apt-get -y install python-empy 
sudo apt-get -y install python-setuptools 
sudo apt-get -y install python-wstool 
sudo apt-get -y install python-rosinstall 
sudo apt-get -y install python-rosinstall-generator 
sudo apt-get -y install python-catkin-pkg 

# Python 3
sudo apt-get install python3-dev
sudo apt-get -y install python3-yaml
sudo apt-get -y install python3-empy 
sudo apt-get -y install python3-setuptools
sudo apt-get -y install python3-wstool 

# sudo pip3 install rospkg catkin_pkg
# OR
# ROSpkg
git clone git://github.com/ros/rospkg.git
cd rospkg
sudo python3 setup.py install
cd ~
# Catkin for python 3 support
git clone git://github.com/ros-infrastructure/catkin_pkg.git
cd catkin_pkg
sudo python3 setup.py install
cd ~
git clone git://github.com/ros/catkin.git
cd catkin
sudo python3 setup.py install

sudo apt-get -y install libgtest-dev 

# If you have ZED camera:
mkdir -p ~/catkin_ws/src 
# git clone https://github.com/stereolabs/zed-ros-wrapper.git
cd ~/catkin_ws/
rosdep install --from-paths src --ignore-src -r -y
catkin_make -DCMAKE_BUILD_TYPE=Release
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc 
source ~/.bashrc
