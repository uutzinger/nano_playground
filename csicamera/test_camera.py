import cv2
import time

# 3264 x 2464 FR = 21.0000
# 3264 x 1848 FR = 28.000001
# 1920 x 1080 FR = 29.999999
# 1280 x 720  FR = 120.000005
# 1280 x 720  FR = 59.999999

def gstreamer_pipeline(
    capture_width=1280, capture_height=720,
    display_width=1280, display_height=720,
    framerate=60, exposure_time= 5, # ms
    flip_method=0):

    exposure_time = exposure_time * 1000000 #ms to ns
    exp_time_str = '"' + str(exposure_time) + ' ' + str(exposure_time) + '"'

    return (
        'nvarguscamerasrc '
        'name="NanoCam" '
        'do-timestamp=true '
        'sensor-mode=-1 '                          # -1..255, IX279 0(3264x2464,21fps),1 (3264x1848,28),2(1080p.30),3(720p,60),4(=720p,120)
        'tnr-strength=-1 '                         # -1..1
        'tnr-mode=1 '                              # 0,1,2
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

cap = cv2.VideoCapture(gstreamer_pipeline(), cv2.CAP_GSTREAMER)

if not (cap.isOpened()):
    print("Could not open video device")
else:                                                 # elp                     ,IX299 v4l, gstreamer
    if False:
	    print(cap.get(cv2.CAP_PROP_POS_MSEC))             # 0          ,-1          ,0.0    	,626.595495
	    print(cap.get(cv2.CAP_PROP_POS_FRAMES))           # NA ELP     ,-1          ,NA     	,0.0
	    print(cap.get(cv2.CAP_PROP_POS_AVI_RATIO))        # NA ELP     ,-1          ,NA     	,-1e-06
	    print(cap.get(cv2.CAP_PROP_FRAME_WIDTH))          # 320        ,640         ,3264   	,1280
	    print(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))         # 240        ,480         ,2464   	,720
	    print(cap.get(cv2.CAP_PROP_FPS))                  # 120        ,0           ,NA     	,30
	    print(cap.get(cv2.CAP_PROP_FOURCC))               # MJPG       ,844715353   ,1448695129.0   ,NA
	    print(cap.get(cv2.CAP_PROP_FRAME_COUNT))          # NA ELP     ,-1          ,NA     	,-1.0
	    print(cap.get(cv2.CAP_PROP_FORMAT))               # 16         ,-1          ,16     	,NA
	    print(cap.get(cv2.CAP_PROP_MODE))                 # MJPG       ,-1          ,0      	,NA
	    print(cap.get(cv2.CAP_PROP_BRIGHTNESS))           # 0.5        ,0           ,NA     	,0.0
	    print(cap.get(cv2.CAP_PROP_CONTRAST))             # 0.5        ,0           ,NA     	,0.0
	    print(cap.get(cv2.CAP_PROP_SATURATION))           # 0.46875    ,64          ,NA     	,0.0
	    print(cap.get(cv2.CAP_PROP_HUE))                  # 0.5        ,0           ,NA     	,0.0
	    print(cap.get(cv2.CAP_PROP_GAIN))                 # 0.0        ,-1.0        ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_EXPOSURE))             # 1.0        ,-4.0        ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_CONVERT_RGB))          # 1.0        ,1.0         ,1.0    	,NA
	    print(cap.get(cv2.CAP_PROP_WHITE_BALANCE_BLUE_U)) # NA ELP     ,4600.0      ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_RECTIFICATION))        # NA ELP     ,-1.0        ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_MONOCHROME))           # NA ELP     ,-1.0        ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_SHARPNESS))            # 2.0        ,2.0         ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_AUTO_EXPOSURE))        # 0.25 or 0.75(auto) ,-1.0 ,NA    	,NA
	    print(cap.get(cv2.CAP_PROP_GAMMA))                # 100.0      ,100.0       ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_TEMPERATURE))          # 6500       ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_TRIGGER))              # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_TRIGGER_DELAY))        # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_WHITE_BALANCE_RED_V))  # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_ZOOM))                 # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_FOCUS))                # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_GUID))                 # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_ISO_SPEED))            # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_BACKLIGHT))            # 1.0        ,3.0         ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_PAN))                  # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_TILT))                 # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_ROLL))                 # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_IRIS))                 # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_SETTINGS))             # NA ELP     ,0,          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_BUFFERSIZE))           # 4.0        ,-1          ,4.0    	,NA
	    print(cap.get(cv2.CAP_PROP_AUTOFOCUS))            # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_SAR_NUM))              # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_SAR_DEN))              # NA ELP     ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_BACKEND))              # 200        ,700         ,200    	,1800
	    print(cap.get(cv2.CAP_PROP_CHANNEL))              # -1         ,0           ,-1.0   	,NA
	    print(cap.get(cv2.CAP_PROP_AUTO_WB))              # 1.0        ,-1          ,NA     	,NA
	    print(cap.get(cv2.CAP_PROP_WB_TEMPERATURE))       # 6500       ,-1          ,NA     	,NA

window_handle = cv2.namedWindow("CSI Camera", cv2.WINDOW_AUTOSIZE)
last_fps_time = time.time()
num_frames = 0
while(cv2.getWindowProperty("CSI Camera", 0) >= 0):
    ret, frame = cap.read()
    if frame is not None:
        cv2.imshow('CSI Camera',frame)
        num_frames += 1
        current_time = time.time()
        if (current_time - last_fps_time) >= 5.0: # update frame rate every 5 secs
            print("CaptureFPS: ", num_frames/5.0)
            num_frames = 0
            last_fps_time = current_time
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
cap.release()
cv2.destroyAllWindows()
