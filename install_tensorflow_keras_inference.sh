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
#sudo -H pip2 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu==1.14.0+nv19.10 --user
sudo -H pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 tensorflow-gpu==1.14.0+nv19.10 --user

# pyTorch 1.3.0
#
# https://devtalk.nvidia.com/default/topic/1049071/jetson-nano/pytorch-for-jetson-nano/
# https://devtalk.nvidia.com/default/topic/1049071/jetson-nano/pytorch-for-jetson-nano-version-1-3-0-now-available/

wget https://nvidia.box.com/shared/static/6t52xry4x2i634h1cfqvc9oaoqfzrcnq.whl -O torch-1.3.0-cp27-cp27mu-linux_aarch64.whl
sudo -H pip2 install torch-1.3.0-cp27-cp27mu-linux_aarch64.whl
#
wget https://nvidia.box.com/shared/static/phqe92v26cbhqjohwtvxorrwnmrnfx1o.whl -O torch-1.3.0-cp36-cp36m-linux_aarch64.whl
sudo -H pip3 install numpy torch-1.3.0-cp36-cp36m-linux_aarch64.whl

# pytorch vision v0.5.0
#
#sudo -H pip2 install protobuf --upgrade 
#sudo -H pip3 install protobuf --upgrade 
#
sudo -H pip2 install setuptools --upgrade
sudo -H pip3 install setuptools --upgrade
#
sudo -H pip2 install numpy --upgrade
sudo -H pip3 install numpy --upgrade
#
sudo apt-get install libjpeg-dev zlib1g-dev
#
git clone --branch v0.5.0 https://github.com/pytorch/vision torchvision   # see below for version of torchvision to download
cd torchvision
sudo -H python3 setup.py install
sudo -H python2 setup.py install
cd ../  # attempting to load torchvision from build dir will result in import error

# Test with python shell
import torch
print(torch.__version__)
print('CUDA available: ' + str(torch.cuda.is_available()))
a = torch.cuda.FloatTensor(2).zero_()
print('Tensor a = ' + str(a))
b = torch.randn(2).cuda()
print('Tensor b = ' + str(b))
c = a + b
print('Tensor c = ' + str(c))

import torchvision
print(torchvision.__version__)

# Torch to RT
# https://github.com/NVIDIA-AI-IOT/torch2trt
git clone https://github.com/NVIDIA-AI-IOT/torch2trt
cd torch2trt
sudo python setup.py install

# Keras
sudo apt-get install graphviz
sudo apt-get install graphviz-dev
sudo apt-get install libgraphviz-dev
sudo apt-get install python-pygraphviz
sudo apt-get install python3-graphviz
sudo -H pip2 install h5py
sudo -H pip3 install h5py
sudo -H pip2 install pydot
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
wget http://dlib.net/files/dlib-19.18.tar.bz2 
tar jxvf dlib-19.18.tar.bz2
cd dlib-19.18
gedit dlib/cuda/cudnn_dlibapi.cpp
//forward_algo = forward_best_algo;
sudo python3 setup.py install
sudo -H pip3 install face_recognition
wget -O doorcam.py tiny.cc/doorcam
python3 doorcam.py


