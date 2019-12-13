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
./configure --enable-nvmpi --enable-nonfree --enable-shared --enable-ffplay
make -j4
sudo make install

# test on network camera
ffplay -max_delay 500000 -rtsp_transport udp rtsp://192.168.8.52:8554/unicast
# core dump dbus

gst-launch-1.0 videotestsrc is-live=true ! video/x-raw, width=1920, height=1080  ! nvoverlaysink

I am testing rtsp cam with ffmpeg.

Initially the following worked gst-launch-1.0 rtspsrc location=rtsp://192.168.8.51:8554/unicast latency=100 ! decodebin ! nveglglessink

When building ffmpeg the fftools/ffplay is not built. What options 
or changes are needed so that ffplayh is created.
ffplay however is installed in /usr/bin/ffplay but its not part of 