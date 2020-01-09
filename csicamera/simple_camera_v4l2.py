# MIT License
# Copyright (c) 2019 JetsonHacks
# See license
# Using a CSI camera (such as the Raspberry Pi Version 2) connected to a
# NVIDIA Jetson Nano Developer Kit using OpenCV
# Drivers for the camera and OpenCV are included in the base image

import cv2
import v4l2

# gstreamer_pipeline returns a GStreamer pipeline for capturing from the CSI camera
# Defaults to 1280x720 @ 60fps
# Flip the image by setting the flip_method (most common values: 0 and 2)
# display_width and display_height determine the size of the window on the screen

def gstreamer_pipeline(
    capture_device=0,
    capture_width=1920, capture_height=1080,
    display_width=1280, display_height=720,
    framerate=30, exposure_time= 5, # ms
    flip_method=0):

    exposure_time = exposure_time * 1000000 #ms to ns
    exp_time_str = '"' + str(exposure_time) + ' ' + str(exposure_time) + '"'

#https://gstreamer.freedesktop.org/documentation/video4linux2/v4l2src.html?gi-language=c
# 
    return (
        'v4l2src '
        'device=/dev/video%d '
        'brightness=0 '
        'contrast=0 '
        'hue=0 '
        'saturation=0 '
        'norm=
        'io-mode=GST_V4L2_IO_AUTO
        'extra-controls=
        'force-aspect-ratio=true '
        'pixel-aspect-ratio="1/1" '
        #
        '! video/x-raw(memory:NVMM), '
        'width=(int)%d, '
        'height=(int)%d, '
        'format=(string)NV12, '
        'framerate=(fraction)%d/1 '
        #
        '! nvvidconv flip-method=%d '
        '! video/x-raw, width=(int)%d, height=(int)%d, format=(string)BGRx '
        #
        '! videoconvert '
        '! video/x-raw, format=(string)BGR '
        #
        '! appsink'
        % (
            capture+device,
            exp_time_str,
            capture_width,
            capture_height,
            framerate,
            flip_method,
            display_width,
            display_height,
        )
    )

# sesnor-mode=4 latency 200ms
# sensor-mode=3 latency 200ms
# sensor-mode=2 latency 100ms
# sensor-mode=0 latency 140ms

v4l2-ctrl --set-ctrl exposure= 13..683709
v4l2-ctrl --set-ctrl gain= 16..170
v4l2-ctrl --set-ctrl frame_rate= 2000000..120000000
v4l2-ctrl --set-ctrl low_latency_mode=True

def show_camera():
    v4l2-controls
    # To flip the image, modify the flip_method parameter (0 and 2 are the most common)
    print(gstreamer_pipeline())
    cap = cv2.VideoCapture(gstreamer_pipeline(), cv2.CAP_GSTREAMER)
    if cap.isOpened():
        window_handle = cv2.namedWindow("CSI Camera", cv2.WINDOW_AUTOSIZE)
        # Window
        while cv2.getWindowProperty("CSI Camera", 0) >= 0:
            ret_val, img = cap.read()
            cv2.imshow("CSI Camera", img)
            # This also acts as
            keyCode = cv2.waitKey(30) & 0xFF
            # Stop the program on the ESC key
            if keyCode == 27:
                break
        cap.release()
        cv2.destroyAllWindows()
    else:
        print("Unable to open camera")


if __name__ == "__main__":
    show_camera()
