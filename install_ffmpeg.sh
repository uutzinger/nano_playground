# https://github.com/jocover/jetson-ffmpeg

git clone https://github.com/jocover/jetson-ffmpeg.git
cd jetson-ffmpeg
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig

git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.2 --depth=1
cd ffmpeg
wget https://github.com/jocover/jetson-ffmpeg/raw/master/ffmpeg_nvmpi.patch
git apply ffmpeg_nvmpi.patch
./configure --enable-nvmpi
make
sudo make install

# test on network camera
ffplay -max_delay 500000 -rtsp_transport udp rtsp://192.168.8.52:8554/unicast
# core dump dbus