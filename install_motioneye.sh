#
# https://github.com/ccrisan/motioneye/wiki/Install-On-Ubuntu
#

sudo apt-get install -y motion ffmpeg v4l-utils
sudo apt-get install -y python-pip python-dev curl libssl-dev libcurl4-openssl-dev libjpeg-dev
sudo -H pip3 install motioneye
sudo mkdir -p /etc/motioneye
sudo cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
sudo mkdir -p /var/lib/motioneye
sudo   cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
systemctl daemon-reload
systemctl enable motioneye
systemctl start motioneye
# sudo -H pip3 install motioneye --upgrade
# systemctl restart motioneye

#
# Configure Cameras
#
