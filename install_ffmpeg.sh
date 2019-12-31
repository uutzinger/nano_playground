# https://github.com/jocover/jetson-ffmpeg

git clone https://github.com/jocover/jetson-ffmpeg.git
cd jetson-ffmpeg
mkdir build
cd build
cmake ..
# cmake-gui ..
# MAKE_CXX_FLAGS -fPIC
# MAKE_C_FLAGS -fPIC
make
sudo make install
sudo ldconfig

# dependencies
apt install libsdl2-dev # for ffplay

git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.2 --depth=1
cd ffmpeg
wget https://github.com/jocover/jetson-ffmpeg/raw/master/ffmpeg_nvmpi.patch
git apply ffmpeg_nvmpi.patch
./configure --enable-nvmpi --enable-nonfree --enable-shared --enable-ffplay
make -j4
sudo make install

export RTSP_PATH=rtsp://192.168.11.202:8554/unicast
gst-launch-1.0 rtspsrc location="$RTSP_PATH" latency=100 ! rtph264depay ! h264parse ! omxh264dec ! nvoverlaysink overlay-x=0 overlay-y=20 overlay-w=960 overlay-h=540 overlay=2

# test on network camera
ffplay -max_delay 500000 -rtsp_transport udp "$RTSP_PATH"
# core dump dbus

gst-launch-1.0 videotestsrc is-live=true ! video/x-raw, width=1920, height=1080  ! nvoverlaysink
