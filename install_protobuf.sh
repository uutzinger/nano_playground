#######################################################
# Protobuf
#######################################################
# Based on:
# https://github.com/jkjung-avt/jetson_nano/blob/master/install_protobuf-3.6.1.sh
# and adapted to version 3.8.0
# 
# Urs Utzinger, Summer 2019
########################################################
sudo apt-get -y install gawk
#
wget https://github.com/protocolbuffers/protobuf/releases/download/v3.10.1/protobuf-python-3.10.1.zip
wget https://github.com/protocolbuffers/protobuf/releases/download/v3.10.1/protoc-3.10.1-linux-aarch_64.zip
unzip protobuf-python-3.10.1.zip
unzip protoc-3.10.1-linux-aarch_64.zip -d protoc-3.10.1
sudo cp protoc-3.10.1/bin/protoc /usr/local/bin/protoc
sudo cp -rv protoc-3.10.1/include/* /usr/local/include
cd protobuf-3.10.1/
# export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
./autogen.sh
./configure --prefix=/usr/local
make -j4                        # passed
make check -j4                  # working on it, takes 30 mins
sudo make install               #
sudo ldconfig                   #
#######################################################
# Python bindings
#######################################################
sudo pip3 uninstall -y protobuf
sudo pip  uninstall -y protobuf
cd python/
## force compilation with c++11 standard
#sed -i '205s/if v:/if True:/' setup.py
python3 setup.py build --cpp_implementation
python3 setup.py test --cpp_implementation
sudo python3 setup.py install --cpp_implementation
#
python setup.py build --cpp_implementation
python setup.py test --cpp_implementation
sudo python setup.py install --cpp_implementation
# End protobuf ############

