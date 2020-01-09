# MIT License
# Copyright (c) 2019 JetsonHacks
# See license
# Using a CSI camera (such as the Raspberry Pi Version 2) connected to a
# NVIDIA Jetson Nano Developer Kit using OpenCV
# Drivers for the camera and OpenCV are included in the base image

import cv2

# gstreamer_pipeline returns a GStreamer pipeline for capturing from the CSI camera
# Defaults to 1280x720 @ 60fps
# Flip the image by setting the flip_method (most common values: 0 and 2)
# display_width and display_height determine the size of the window on the screen

def gstreamer_pipeline(
    capture_width=1920, capture_height=1080,
    display_width=1280, display_height=720,
    framerate=30, exposure_time= 5, # ms
    flip_method=0):
    exposure_time = exposure_time * 1000000 #ms to ns
    exp_time_str = '"' + str(exposure_time) + ' ' + str(exposure_time) + '"'
    return (
        'nvarguscamerasrc '
        'name="NanoCam" '
        'do-timestamp=true '
        'timeout=0 '                               # 0 - 2147483647
        'blocksize=-1 '                            # block size in bytes
        'num-buffers=-1 '                          # -1..2147483647 (-1=ulimited) num buf before sending EOS
        'sensor-mode=-1 '                          # -1..255, IX279 0(3264x2464,21fps),1 (3264x1848,28),2(1080p.30),3(720p,60),4(=720p,120)
        'tnr-strength=-1 '                         # -1..1
        'tnr-mode=1 '                              # 0,1,2
#        'ee-mode=0'                               # 0,1,2
#        'ee-strength=-1 '                         # -1..1
        'aeantibanding=1 '                         # 0..3, off,auto,50,60Hz
        'bufapi-version=false '                    # new buffer api
        'maxperf=true '                            # max performance
        'silent=true '                             # verbose output
        'saturation=1 '                            # 0..2
        'wbmode=1 '                                # white balance mode, 0..9 0=off 1=auto
        'awblock=false '                           # auto white balance lock
        'aelock=true '                             # auto exposure lock
        'exposurecompensation=0 '                  # -2..2
        'exposuretimerange=%s '                    # "13000 683709000"
        'gainrange="1.0 10.625" '                  # "1.0 10.625"
        'ispdigitalgainrange="1 8" '             # "1 8"
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
            exp_time_str,
            capture_width,
            capture_height,
            framerate,
            flip_method,
            display_width,
            display_height,
        )
    )

def show_camera():
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
            keyCode = cv2.waitKey(1) & 0xFF
            # Stop the program on the ESC key
            if keyCode == 27:
                break
        cap.release()
        cv2.destroyAllWindows()
    else:
        print("Unable to open camera")


if __name__ == "__main__":
    show_camera()
