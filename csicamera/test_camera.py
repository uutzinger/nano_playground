import cv2
import time

def gstreamer_pipeline(
    capture_width=1280,
    capture_height=720,
    display_width=1280,
    display_height=720,
    framerate=120,
    flip_method=0,
):
    return (
        "nvarguscamerasrc ! "
        "video/x-raw(memory:NVMM), "
        "width=(int)%d, height=(int)%d, "
        "format=(string)NV12, framerate=(fraction)%d/1 ! "
        "nvvidconv flip-method=%d ! "
        "video/x-raw, width=(int)%d, height=(int)%d, format=(string)BGRx ! "
        "videoconvert ! "
        "video/x-raw, format=(string)BGR ! appsink"
        % (
            capture_width,
            capture_height,
            framerate,
            flip_method,
            display_width,
            display_height,
        )
    )

cap = cv2.VideoCapture(gstreamer_pipeline(), cv2.CAP_GSTREAMER)
#cap = cv2.VideoCapture(0, apiPreference=cv2.CAP_V4L2)
#cap = cv2.VideoCapture(0, apiPreference=cv2.CAP_FFMPEG)

if not (cap.isOpened()):
    print("Could not open video device")
else:                                                 # elp                     ,IX299 v4l, gstreamer
    print(cap.get(cv2.CAP_PROP_POS_MSEC))             # 0          ,-1          ,0.0    ,626.595495
    print(cap.get(cv2.CAP_PROP_POS_FRAMES))           # NA ELP     ,-1          ,NA     ,0.0
    print(cap.get(cv2.CAP_PROP_POS_AVI_RATIO))        # NA ELP     ,-1          ,NA     ,-1e-06
    print(cap.get(cv2.CAP_PROP_FRAME_WIDTH))          # 320        ,640         ,3264   ,1280
    print(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))         # 240        ,480         ,2464   ,720
    print(cap.get(cv2.CAP_PROP_FPS))                  # 120        ,0           ,NA     ,120
    print(cap.get(cv2.CAP_PROP_FOURCC))               # MJPG       ,844715353   ,1448695129.0   ,NA
    print(cap.get(cv2.CAP_PROP_FRAME_COUNT))          # NA ELP     ,-1          ,NA     ,-1.0
    print(cap.get(cv2.CAP_PROP_FORMAT))               # 16         ,-1          ,16     ,NA
    print(cap.get(cv2.CAP_PROP_MODE))                 # MJPG       ,-1          ,0      ,NA
    print(cap.get(cv2.CAP_PROP_BRIGHTNESS))           # 0.5        ,0           ,NA     ,0.0
    print(cap.get(cv2.CAP_PROP_CONTRAST))             # 0.5        ,0           ,NA     ,0.0
    print(cap.get(cv2.CAP_PROP_SATURATION))           # 0.46875    ,64          ,NA     ,0.0
    print(cap.get(cv2.CAP_PROP_HUE))                  # 0.5        ,0           ,NA     ,0.0
    print(cap.get(cv2.CAP_PROP_GAIN))                 # 0.0        ,-1.0        ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_EXPOSURE))             # 1.0        ,-4.0        ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_CONVERT_RGB))          # 1.0        ,1.0         ,1.0    ,NA
    print(cap.get(cv2.CAP_PROP_WHITE_BALANCE_BLUE_U)) # NA ELP     ,4600.0      ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_RECTIFICATION))        # NA ELP     ,-1.0        ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_MONOCHROME))           # NA ELP     ,-1.0        ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_SHARPNESS))            # 2.0        ,2.0         ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_AUTO_EXPOSURE))        # 0.25 or 0.75(auto) ,-1.0 ,NA    ,NA
    print(cap.get(cv2.CAP_PROP_GAMMA))                # 100.0      ,100.0       ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_TEMPERATURE))          # 6500       ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_TRIGGER))              # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_TRIGGER_DELAY))        # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_WHITE_BALANCE_RED_V))  # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_ZOOM))                 # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_FOCUS))                # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_GUID))                 # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_ISO_SPEED))            # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_BACKLIGHT))            # 1.0        ,3.0         ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_PAN))                  # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_TILT))                 # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_ROLL))                 # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_IRIS))                 # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_SETTINGS))             # NA ELP     ,0,          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_BUFFERSIZE))           # 4.0        ,-1          ,4.0    ,NA
    print(cap.get(cv2.CAP_PROP_AUTOFOCUS))            # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_SAR_NUM))              # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_SAR_DEN))              # NA ELP     ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_BACKEND))              # 200        ,700         ,200    ,1800
    print(cap.get(cv2.CAP_PROP_CHANNEL))              # -1         ,0           ,-1.0   ,NA
    print(cap.get(cv2.CAP_PROP_AUTO_WB))              # 1.0        ,-1          ,NA     ,NA
    print(cap.get(cv2.CAP_PROP_WB_TEMPERATURE))       # 6500       ,-1          ,NA     ,NA

# cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1080)
# cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
window_handle = cv2.namedWindow("CSI Camera", cv2.WINDOW_AUTOSIZE)
last_fps_time = time.time()
num_frames = 0
while(cv2.getWindowProperty("CSI Camera", 0) >= 0):
    ret, frame = cap.read()
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
