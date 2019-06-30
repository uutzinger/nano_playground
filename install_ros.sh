#########################################################
# Robot Operating System
#
# Reference
# http://wiki.ros.org/melodic/Installation/Ubuntu
#########################################################

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

sudo apt-get update
sudo apt-get -y install ros-melodic-desktop-full # This installs tons of files
#
sudo rosdep init
rosdep update
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc 
source ~/.bashrc
#
sudo apt-get -y install python-rosinstall 
sudo apt-get -y install python-rosinstall-generator 
sudo apt-get -y install python-catkin-pkg 
sudo apt-get -y install python-empy 
sudo apt-get -y install python-setuptools 
sudo apt-get -y install python-wstool 
#
# ROS  works with python 2
# ROS2 works with python 3
#sudo apt-get -y install python3-catkin-pkg 
#sudo apt-get -y install python3-rosinstall 
#sudo apt-get -y install python3-rosinstall-generator 
#sudo apt-get -y install python3-empy 
#sudo apt-get -y install python3-setuptools 
#sudo apt-get -y install python3-wstool 
#
sudo apt-get -y install libgtest-dev 

# If you have ZED camera:
mkdir -p ~/catkin_ws/src 
# git clone https://github.com/stereolabs/zed-ros-wrapper.git
cd ~/catkin_ws/
rosdep install --from-paths src --ignore-src -r -y
catkin_make -DCMAKE_BUILD_TYPE=Release
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc 
source ~/.bashrc

