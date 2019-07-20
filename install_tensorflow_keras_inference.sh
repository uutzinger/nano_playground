####################################################################
#
# Machine Learning with CUDA support
#
# References 
# https://github.com/rbonghi/jetson_easy
#
# Urs Utzinger, Summer 2019
####################################################################

# Tensorflow
sudo -H pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu==1.13.1+nv19.5 --user

sudo -H pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu==1.13.1+nv19.5 --user

# pyTorch 1.1.0
#
# https://devtalk.nvidia.com/default/topic/1049071/jetson-nano/pytorch-for-jetson-nano/
wget https://nvidia.box.com/shared/static/o8teczquxgul2vjukwd4p77c6869xmri.whl -O torch-1.1.0-cp27-cp27mu-linux_aarch64.whl
sudo -H pip install torch-1.1.0-cp27-cp27mu-linux_aarch64.whl
#
wget https://nvidia.box.com/shared/static/j2dn48btaxosqp0zremqqm8pjelriyvs.whl -O torch-1.1.0-cp36-cp36m-linux_aarch64.whl
sudo -H pip3 install numpy torch-1.1.0-cp36-cp36m-linux_aarch64.whl

# pytorch vision v0.3.0
#
sudo -H pip install protobuf --upgrade 
sudo -H pip3 install protobuf --upgrade 
#
sudo -H pip install setuptools --upgrade
sudo -H pip3 install setuptools --upgrade
#
sudo -H pip install numpy --upgrade
sudo -H pip3 install numpy --upgrade
#
git clone https://github.com/pytorch/vision.git
cd vision
sudo python3 setup.py install
sudo python2 setup.py install

# Keras
sudo apt-get install graphviz
sudo apt-get install graphviz-dev
sudo apt-get install libgraphviz-dev
sudo apt-get install python-pygraphviz
sudo apt-get install python3-graphviz
sudo -H pip  install h5py
sudo -H pip3 install h5py
sudo -H pip  install pydot
sudo -H pip3 install pydot
sudo apt-get -y install python3-keras

# Jetson Inference
sudo apt-get install doxygen
git clone https://github.com/dusty-nv/jetson-inference
cd jetson-inference
git submodule update --init
mkdir build
cd build
cmake ../
make -j4
sudo make install

# Open any of the modules that have camera version and
# edit *.cpp and set camera to 0 at #define DEFAULT_CAMERA 0 //
# check that you have a camera at /dev/video0 for camera 0

###############################################################3
#
# Face Recognition Library
#
###############################################################3
wget http://dlib.net/files/dlib-19.17.tar.bz2 
tar jxvf dlib-19.17.tar.bz2
cd dlib-19.17
gedit dlib/cuda/cudnn_dlibapi.cpp
//forward_algo = forward_best_algo;
sudo python3 setup.py install
sudo pip3 install face_recognition
wget -O doorcam.py tiny.cc/doorcam
python3 doorcam.py


