import cv2
from datetime   import datetime, timedelta
from CSIcapture import CSICapture

logging.basicConfig(level=logging.DEBUG)

print("Starting Capture")
camera = CSICapture()
camera.start()

print("Getting Frames")

window_handle = cv2.namedWindow("CSI Camera", cv2.WINDOW_AUTOSIZE)
last_fps_time = time.time()
num_frames = 0
while(cv2.getWindowProperty("CSI Camera", 0) >= 0):
    if capture.new_frame:
        cv2.imshow('CSI Camera',frame)
        num_frames += 1
    current_time = time.time()
    if (current_time - last_fps_time) >= 5.0: # update frame rate every 5 secs
        print("CaptureFPS: ", num_frames/5.0)
        num_frames = 0
        last_fps_time = current_time
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
camera.stop()
cv2.destroyAllWindows()
