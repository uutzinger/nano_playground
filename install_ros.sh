sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt update
sudo apt install ros-melodic-desktop
sudo rosdep init
rosdep update
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc 
source ~/.bashrc
sudo apt-get install cmake python-catkin-pkg python-empy python-nose python-setuptools libgtest-dev python-rosinstall python-rosinstall-generator python-wstool build-essential git
mkdir -p ~/catkin_ws/src 
cd ~/catkin_ws/
catkin_make
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc 
source ~/.bashrc


#cd ~/catkin_ws/src
#git clone https://github.com/stereolabs/zed-ros-wrapper.git
#cd ~/catkin_ws
#rosdep install --from-paths src --ignore-src -r -y
#catkin_make -DCMAKE_BUILD_TYPE=Release
#roslaunch zed_display_rviz display.launch
#roslaunch zed_display_rviz display_zedm.launch 

