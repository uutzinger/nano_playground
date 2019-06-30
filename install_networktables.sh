##################################################
# Network tables
# FIRST robotics competition
# Consider using ZeroMQ instead
##################################################
mkdir ~/networktables && cd ~/networktables
wget -nc -nv -O pynetworktables.tar.gz https://github.com/robotpy/pynetworktables/archive/8a4288452be26e26dccad32980f46000e8d97928.tar.gz
tar xzf pynetworktables.tar.gz
mv pynetworktables-* pynetworktables
echo "__version__ = '2019.0.1'" > pynetworktables/ntcore/version.py
cd pynetworktables
python3 setup.py build
sudo python3 setup.py install
python3 setup.py clean

python2 setup.py build
sudo python2 setup.py install
python2 setup.py clean
