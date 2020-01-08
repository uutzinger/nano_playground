configs = {
    ##############################################
    # Camera Settings
    ##############################################
    'camera_res'      : (640, 480),     # camera width & height                                      CAP_PROP_FRAME_WIDTH, CAP_PROP_FRAME_HEIGHT
                                        # ELP: 320x240
                                        # Laptop: 1280x720, 640x480, 320x240, 320x160, 160x120 
    'exposure'        : -4.0,           # CSI camera: 1=100micro seconds, max=frame interval,        CAP_PROP_EXPOSURE
                                        # ELP camera in seconds max: 1/fps
                                        # Laptop -4
    'fps'             : 30,             # CSI: 1/10, 15, 30, 40, 90, 120 overlocked, 180?
                                        # ELP: 6, 9, 21, 31, 30, 60, 100, 120?                       CAP_PROP_FPS
                                        # Laptop: 0
    'fourcc'          : -1,             # MJPG, YUY2, for ELP camera https://www.fourcc.org/         CAP_PROP_FOURCC 
                                        # Laptop Windows -1
    'buffersize'      : -1,             # default is 4 for V4L2, max 10,                             CAP_PROP_BUFFERSIZE 
                                        # Laptop: -1
    'autoexposure'    : 0,              # CSI: 0=auto, 1=manual, 2=shutter priority, 3=aperture priority, CAP_PROP_AUTO_EXPOSURE
                                        # ELP: 0.25 manual 0.75 auto
                                        # Laptop: -1
    'autowhite'       : 0,              # CSI: 0, 1 bool                                             CAP_PROP_AUTO_WB 
    'whitetemp'       : 57343,          # CSI min=800 max=6500 step=1 default=57343                  CAP_PROP_WB_TEMPERATURE 
    'autofocus'       : 0,              # CSI: 0 or 1 bool                                           CAP_PROP_AUTOFOCUS
    ##############################################
    # Target Recognition
    ##############################################
    'fov'             : 77,             # camera lens field of view in degress
    ##############################################
    # Target Display
    ##############################################
    'output_res'      : (320, 240),     # Output resolution 
    'serverfps'       : 16,             # frame rate for display server
}

##################################################
# Capture Options for Sony IX219 CSI camera
##################################################
# 4VL2-ctl
