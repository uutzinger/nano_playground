################################################
#
# Update the jetson GPIO library for python
#
# Urs Utzinger, Summer 2019
################################################
git clone https://github.com/NVIDIA/jetson-gpio
sudo cp -r jetson-gpio/* /opt/nvidia/jetson-gpio
cd /opt/nvidia/jetson-gpio
sudo python3 setup.py install
sudo groupadd -f -r gpio
sudo usermod -a -G gpio uutzinger
sudo cp /opt/nvidia/jetson-gpio/etc/99-gpio.rules /etc/udev/rules.d/
udo udevadm control --reload-rules && sudo udevadm trigger

