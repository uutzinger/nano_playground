###############################################################################
# CSi video capture on Jetson Nano
# Urs Utzinger
# 2019
###############################################################################

###############################################################################
# Imports
###############################################################################

# Multi Threading
from threading import Thread
from threading import Lock
from threading import Event

#
import logging
import time

# Open Computer Vision
import cv2

# Camera    

# Bucket Vision
from configs       import configs

###############################################################################
# Video Capture
###############################################################################

class CSICapture(Thread):
    """
    This thread continually captures frames from a CSI camera
    """

    # Initialize the Camera Thread
    # Opens Capture Device and Sets Capture Properties
    def __init__(self, camera_num int = 0, res: Resolution = None, 
                 exposure: float = None):
        # initilize
        self.logger = logging.getLogger("CSICapture{}".format(camera_num))

        # populate desired settings from configuration file or function call
        self.camera_num = camera_num
        if exposure is not None: self._exposure   = exposure
        else:                    self._exposure   = configs['exposure']
        if res is not None:      self._camera_res = res
        else:                    self._camera_res = (configs['camera_res'])

        # Threading Locks, Events
        self.capture_lock = Lock()
        self.frame_lock   = Lock()
        self.stopped         = True
        self.new_frame_event = Event()

        # open up the camera
        self._open_capture()

        # Init Frame and Thread
        self.frame     = None
        self.new_frame = False
        self.stopped   = False

        Thread.__init__(self)
        

    def _open_capture(self):
        """Open up the camera so we can begin capturing frames"""

        # PiCamera
        self.capture      = PiCamera(self.camera_num)
        self.capture_open = not self.capture.closed

        if self.capture_open:
            # Appply Settings to camera
            self.resolution = self._camera_res
            self.rawCapture = PiRGBArray(self.capture, size=self.resolution)
            self.exposure   = self._exposure
            self.fps = configs['fps']
            # Turn Off Auto Features
            self.awb_mode     = 'off'            # No auto white balance
            self.awb_gains    = (1,1)            # Gains for red and blue are 1
            self.brightness   = 50               # No change in brightness
            self.contrast     = 0                # No change in contrast
            self.drc_strength = 'off'            # Dynamic Range Compression off
            self.clock_mode   = 'raw'            # Frame numbers since opened camera
            self.color_effects= None             # No change in color
            self.fash_mode    = 'off'            # No flash
            self.image_denoise= False            # In vidoe mode
            self.image_effect = 'none'           # No image effects
            self.sharpness    = 0                # No changes in sharpness
            self.video_stabilization = False     # No image stablization
            self.iso          = 100              # Use ISO 100 setting, smallest analog and digital gains
            self.exposure_mode= 'off'            # No automatic exposure control
            self.exposure_compensation = 0       # No automatic expsoure controls compensation
        else: 
            Table.writeValue("Camera{}Status".format(camera_num), 
                             "Failed to open camera {}!".format(camera_num),
                             logger=self.logger, net_table = self.net_table,
                             level=logging.CRITICAL)

    #
    # Thread routines #################################################
    # Start Stop and Update Thread

    def stop(self): 
        """stop the thread"""
        self.stopped = True

    def start(self):
        """ set the thread start conditions """
        try:
            self.stream = self.capture.capture_continuous(self.rawCapture, 
                                                          format="bgr", use_video_port=True)
        except:
            Table.writeValue("Camera{}Status".format(self.camera_num), 
                             "Failed to create camera stream {}!".format(self.camera_num), 
                             logger=self.logger, net_table = self.net_table,
                             level=logging.CRITICAL)

        T = Thread(target=self.update, args=())
        T.daemon = True # run in background
        T.start()

    # After Stating of the Thread, this runs continously
    def update(self):
        """ run the thread """
        last_fps_time = time.time()
        last_exposure_time = last_fps_time
        num_frames = 0
        for f in self.stream: 
            current_time = time.time()
            # FPS calculation
            if (current_time -  last_fps_time) >= 5.0:
                Table.writeValue("CaptureFPS", num_frames/5.0, net_table = self.net_table, logger=self.logger)
                num_frames = 0
                last_fps_time = current_time
            # Adjust exposure if requested via network tables
            if (current_time - last_exposure_time) >= 1: #no more than once per second
                last_exposure_time = current_time
                try:
                    if self._exposure != self.net_table.getEntry("Exposure").value: 
                        self.exposure = self.net_table.getEntry("Exposure").value
                except: pass
            # Get latest img
            with self.capture_lock:
                img = f.array
                self.rawCapture.truncate(0)
            # set the frame var to the img we just captured
            self.frame = img
            # tell any threads waiting for a new frame that we have one
            self.new_frame_event.set()
            self.new_frame_event.clear()
            num_frames += 1

            if self.stopped:
                self.stream.close()
                self.rawCapture.close()
                self.capture.close()        

    #
    # Frame routines ##################################################
    # Each camera stores frames locally

    @property
    def frame(self):
        """ returns most recent frame """
        self._new_frame = False
        return self._frame

    @frame.setter
    def frame(self, img):
        """ set new frame content """
        with self.frame_lock:
            self._frame = img
            self._new_frame = True

    @property
    def new_frame(self):
        """ check if new frame available """
        out = self._new_frame
        return out

    @new_frame.setter
    def new_frame(self, val):
        """ override wether new frame is available """
        self._new_frame = val
    
    #
    # Camera Routines ################################################
    #
    
    # SONY IMX219
    # Mode	Resolution	Aspect	Framerate	    FoV	    Binning
    #                   Ratio
    # 1	    1920x1080	16:9	1/10 - 30	    Partial	None
    # 2	    3280x2464	4:3	    1/10 - 15	    Full	None
    # 3	    3280x2464	4:3	    1/10 - 15	    Full	None
    # 4	    1640x1232	4:3	    1/10 - 40	    Full	2x2
    # 5	    1640x922	16:9	1/10 - 40	    Full	2x2
    # 6	    1280x720	16:9	40 - 90 (120*)	Partial	2x2
    # 7	    640x480	    4:3	    40 - 90 (120*)	Partial	2x2
    #
    # Omnivision OV5647
    # Mode	Resolution	Aspect 
    #                   Ratio	Framerate	    FoV	    Binning
    # 1	    1920x1080	16:9	1 - 30	        Partial	None
    # 2	    2592x1944	4:3	    1 - 15	        Full	None
    # 3	    2592x1944	4:3	    1/6 - 1	        Full	None
    # 4	    1296x972	4:3	    1 - 42	        Full	2x2
    # 5	    1296x730	16:9	1 - 49	        Full	2x2
    # 6	    640x480	    4:3	    42 - 60	        Full	4x4
    # 7	    640x480	    4:3	    60 - 90	        Full	4x4

    # write shutter_speed  sets exposure in microseconds
    # read  exposure_speed gives actual exposure 
    # shutter_speed = 0 then auto exposure
    # framerate determines maximum exposure

    # Read properties

    @property
    def resolution(self):            
        if self.capture_open: 
            return self.capture.resolution                            
        else: return float("NaN")

    @property
    def width(self):                 
        if self.capture_open: 
            return self.capture.resolution[0]
        else: return float("NaN")

    @property
    def height(self):                
        if self.capture_open: 
            return self.capture.resolution[1]                         
        else: return float("NaN")

    @property
    def fps(self):             
        if self.capture_open: 
            return self.capture.framerate+self.capture.framerate_delta 
        else: return float("NaN")

    @property
    def exposure(self):              
        if self.capture_open: 
            return self.capture.exposure_speed                        
        else: return float("NaN")

    # Write

    @resolution.setter
    def resolution(self, val):
        if val is None: return
        if self.capture_open:
            if len(val) > 1:
                with self.capture_lock: self.capture.resolution = val
                Table.writeValue("Width",  val[0], net_table = self.net_table, logger=self.logger)
                Table.writeValue("Height", val[1], net_table = self.net_table, logger=self.logger)
                self._resolution = val
            else:
                with self.capture_lock: self.capture.resolution = (val, val)
                Table.writeValue("Width",  val, net_table = self.net_table, logger=self.logger)
                Table.writeValue("Height", val, net_table = self.net_table, logger=self.logger)
                self._resolution = (val, val)                    
        else:
            Table.writeValue("Camera{}Status".format(self.camera_num), 
                             "Failed to set Resolution to {}!".format(val), 
                             logger=self.logger, net_table = self.net_table,
                             level=logging.CRITICAL)

    @width.setter
    def width(self, val):
        if val is None: return
        val = int(val)
        if self.capture_open:
            with self.capture_lock:
                self.capture.resolution = (val, self.capture.resolution[1])
            Table.writeValue("Width", val, net_table = self.net_table, logger=self.logger)
        else:
            Table.writeValue("Camera{}Status".format(self.camera_num),
                             "Failed to set Width to {}!".format(val), 
                             logger=self.logger, net_table = self.net_table,
                             level=logging.CRITICAL)

    @height.setter
    def height(self, val):
        if val is None: return
        val = int(val)
        if self.capture_open:
            with self.capture_lock:
                self.capture.resolution = (self.capture.resolution[0], val)
            Table.writeValue("Height", val, net_table = self.net_table, logger=self.logger)
        else:
            Table.writeValue("Camera{}Status".format(self.camera_num),
                             "Failed to set Height to {}!".format(val), 
                             logger=self.logger, net_table = self.net_table,
                             level=logging.CRITICAL)

    @fps.setter
    def fps(self, val):
        if val is None: return
        val = float(val)
        if self.capture_open:
            with self.capture_lock: self.capture.framerate = val
            Table.writeValue("FPS", val, net_table = self.net_table, logger=self.logger)
        else:
            Table.writeValue("Camera{}Status".format(self.camera_num), 
                             "Failed to set Framerate to {}!".format(val), 
                             logger=self.logger, net_table = self.net_table,
                             level=logging.CRITICAL)

    @exposure.setter
    def exposure(self, val):
        if val is None: return
        if self.capture_open:
            with self.capture_lock: self.capture.shutter_speed  = val
            Table.writeValue("Exposure", val, net_table = self.net_table, logger=self.logger,)
            self._exposure = self.exposure
        else:
            Table.writeValue("Camera{}Status".format(self.camera_num),
                             "Failed to set Exposure to {}!".format(val),
                             logger=self.logger, net_table = self.net_table,
                             level=logging.CRITICAL)

    #
    # Color Balancing ##################################################
    #
    # Cannot set digital and analog gains, set ISO then read the gains.
    # awb_mode: can be off, auto, sunLight, cloudy, share, tungsten, fluorescent, flash, horizon, default is auto
    # analog gain: retreives the analog gain prior to digitization
    # digital gain: applied after conversion, a fraction
    # awb_gains: 0..8 for red,blue, typical values 0.9..1.9 if awb mode is set to "off:

    # Read
    @property
    def awb_mode(self):              
        if self.capture_open: 
            return self.capture.awb_mode               
        else: return float('NaN')

    @property
    def awb_gains(self):             
        if self.capture_open: 
            return self.capture.awb_gains              
        else: return float('NaN')

    @property
    def analog_gain(self):           
        if self.capture_open: 
            return self.capture.analog_gain           
        else: return float("NaN")

    @property
    def digital_gain(self):          
        if self.capture_open: 
            return self.capture.digital_gain           
        else: return float("NaN")

    # Write

    @awb_mode.setter
    def awb_mode(self, val):
        if val is None: return
        if self.capture_open:
            with self.capture_lock: self.capture.awb_mode  = val
            Table.writeValue("AWB Mode", val, net_table = self.net_table, logger=self.logger)
        else:
            Table.writeValue("Camera{}Status".format(self.camera_num),
                             "Failed to set AWB Mode to {}!".format(val),
                             logger=self.logger, net_table = self.net_table,
                             level=logging.CRITICAL)
 
    @awb_gains.setter
    def awb_gains(self, val):
        if val is None: return
        if self.capture_open:
            if len(val) > 1:
                with self.capture_lock: self.capture.awb_gains  = val
                Table.writeValue("AWB Gains", val, net_table = self.net_table, logger=self.logger)
            else:
                with self.capture_lock: self.capture.awb_gains = (val, val)
                Table.writeValue("AWB Gains", (val, val), net_table = self.net_table, logger=self.logger,)
        else:
            Table.writeValue("Camera{}Status".format(self.camera_num),
                             "Failed to set AWB Gains to {}!".format(val), 
                             logger=self.logger, net_table = self.net_table,
                             level=logging.CRITICAL)

    # Can not set analog and digital gains, needs special code
    #@analog_gain.setter
    #@digital_gain.setter

    #
    # Intensity and Contrast ###########################################
    #
    # brightness 0..100 default 50
    # contrast -100..100 default is 0
    # drc_strength is dynamic range compression strength; off, low, medium, high, default off
    # iso 0=auto, 100, 200, 320, 400, 500, 640, 800, on some cameras iso100 is gain of 1 and iso200 is gain for 2
    # exposure mode can be off, auto, night, nightpreview, backight, spotlight, sports, snow, beach, verylong, fixedfps, antishake, fireworks, default is auto, off fixes the analog and digital gains
    # exposure compensation -25..25, larger value gives brighter images, default is 0
    # meter_mode'average', 'spot', 'backlit', 'matrix'

    # Read
    @property
    def brightness(self):            
        if self.capture_open: 
            return self.capture.brightness             
        else: return float('NaN')

    @property
    def iso(self):                   
        if self.capture_open: 
            return self.capture.iso                    
        else: return float("NaN")

    @property
    def exposure_mode(self):         
        if self.capture_open: 
            return self.capture.exposure_mode          
        else: return float("NaN")

    @property
    def exposure_compensation(self): 
        if self.capture_open: 
            return self.capture.exposure_compensation  
        else: return float("NaN")

    @property
    def drc_strength(self):          
        if self.capture_open: 
            return self.capture.drc_strength           
        else: return float('NaN')

    @property
    def contrast(self):              
        if self.capture_open: 
            return self.capture.contrast               
        else: return float('NaN')

    # Write

    @brightness.setter
    def brightness(self, val):
        if val is None:  return
        val = int(val)
        if self.capture_open:
            with self.capture_lock:
                self.capture.brightness = val
            Table.writeValue("Brightness", val, net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Brightness to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @iso.setter
    def iso(self, val):
        if val is None: return
        val = int(val)
        if self.capture_open:
            with self.capture_lock:
                self.capture.iso = val
            Table.writeValue("ISO", val, net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set ISO to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @exposure_mode.setter
    def exposure_mode(self, val):
        if val is None: return
        if self.capture_open:
            with self.capture_lock:
                self.capture.exposure_mode = val
            Table.writeValue("Exposure Mode", val, logger=self.logger,)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Exposure Mode to {}!".format(val),
                               logger=self.logger,
                               level=logging.CRITICAL)

    @exposure_compensation.setter
    def exposure_compensation(self, val):
        if val is None: return
        val = int(val)
        if self.capture_open:
            with self.capture_lock:
                self.capture.exposure_compensation = val
            Table.writeValue("Exposure Compensation", int(val), net_table = self.net_table, logger=self.logger,)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Exposure Compensation to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @drc_strength.setter
    def drc_strength(self, val):
        if val is None: return
        if self.capture_open:
            with self.capture_lock:
                self.capture.drc_strength = val
            Table.writeValue("DRC Strength", val, net_table = self.net_table, logger=self.logger,)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set DRC Strength to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @contrast.setter
    def contrast(self, val):
        if val is None: return
        val = int(val)
        if self.capture_open:
            with self.capture_lock:
                self.capture.contrast = val
            Table.writeValue("Contrast", val, net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Contrast to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    #
    # Other Effects ####################################################
    #
    # flash_mode
    # clock mode "reset", is relative to start of recording, "raw" is relative to start of camera
    # color_effects, "None" or (u,v) where u and v are 0..255 e.g. (128,128) gives black and white image
    # flash_mode 'off', 'auto', 'on', 'redeye', 'fillin', 'torch' defaults is off
    # image_denoise, True or False, activates the denosing of the image
    # video_denoise, True or False, activates the denosing of the video recording
    # image_effect, can be negative, solarize, sketch, denoise, emboss, oilpaint, hatch, gpen, pastel, watercolor, film, blur, saturation, colorswap, washedout, colorpoint, posterise, colorbalance, cartoon, deinterlace1, deinterlace2, default is 'none'
    # image_effect_params, setting the parameters for the image effects see https://picamera.readthedocs.io/en/release-1.13/api_camera.html
    # sharpness -100..100 default 0
    # video_stabilization default is False

    # Read
    @property
    def flash_mode(self):            
        if self.capture_open: 
            return self.capture.flash_mode             
        else: return float('NaN')

    @property
    def clock_mode(self):            
        if self.capture_open: 
            return self.capture.clock_mode             
        else: return float('NaN')

    @property
    def sharpness(self):             
        if self.capture_open: 
            return self.capture.sharpness              
        else: return float('NaN')

    @property
    def color_effects(self):         
        if self.capture_open: 
            return self.capture.color_effects           
        else: return float('NaN')

    @property
    def image_effect(self):          
        if self.capture_open: 
            return self.capture.image_effect           
        else: return float('NaN')

    @property
    def image_denoise(self):         
        if self.capture_open: 
            return self.capture.image_denoise          
        else: return float('NaN')

    @property
    def video_denoise(self):         
        if self.capture_open: 
            return self.capture.video_denoise          
        else: return float('NaN')

    @property
    def video_stabilization(self):   
        if self.capture_open: 
            return self.capture.video_stabilization    
        else: return float('NaN')

    # Write

    @flash_mode.setter
    def flash_mode(self, val):
        if val is None:  return
        if self.capture_open:
            with self.capture_lock:
                self.capture.flash_mode = val
            Table.writeValue("Flash Mode", val), net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Flash Mode to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @clock_mode.setter
    def clock_mode(self, val):
        if val is None:  return
        if self.capture_open:
            with self.capture_lock:
                self.capture.clock_mode = val
            Table.writeValue("Clock Mode", val, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Clock Mode to {}!".format(val),
                               logger=self.logger,
                               level=logging.CRITICAL)

    @sharpness.setter
    def sharpness(self, val):
        if val is None:  return
        if self.capture_open:
            with self.capture_lock:
                self.capture.sharpness = val
            Table.writeValue("Sharpness", val, net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Sharpness to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @color_effects.setter
    def color_effects(self, val):
        if val is None:  return
        if self.capture_open:
            with self.capture_lock:
                self.capture.color_effects = val
            Table.writeValue("Color Effects", val, net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Color Effects to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @image_effect.setter
    def image_effect(self, val):
        if val is None:  return
        if self.capture_open:
            with self.capture_lock:
                self.capture.image_effect = val
            Table.writeValue("Image Effect", val, net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Image Effect to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @image_denoise.setter
    def image_denoise(self, val):
        if val is None:  return
        if self.capture_open:
            with self.capture_lock:
                self.capture.image_denoise = val
            Table.writeValue("Image Denoise", val, net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Image Denoise to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @video_denoise.setter
    def video_denoise(self, val):
        if val is None:  return
        if self.capture_open:
            with self.capture_lock:
                self.capture.video_denoise = val
            Table.writeValue("Video Denoise", val, net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Video Denoise to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

    @video_stabilization.setter
    def video_stabilization(self, val):
        if val is None:  return
        if self.capture_open:
            with self.capture_lock:
                self.capture.video_stabilization = val
            Table.writeValue("Video Stablilization", val, net_table = self.net_table, logger=self.logger)
        else: Table.writeValue("Camera{}Status".format(self.camera_num),
                               "Failed to set Video Stabilization to {}!".format(val),
                               logger=self.logger, net_table = self.net_table,
                               level=logging.CRITICAL)

###############################################################################
# Testing
###############################################################################

if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)

    print("Starting Capture")
    camera = CSICapture(network_table=FrontCameraTable)
    camera.start()

    print("Getting Frames")
    while True:
        if capture.new_frame:
            cv2.imshow('my picam', camera.frame)
            #temp = capture.frame
        if cv2.waitKey(1) == 27:
            break  # esc to quit
    camera.stop()
