import face_recognition
import cv2
from datetime import datetime, timedelta
import numpy as np
import platform
import pickle


# Our list of known face encodings and a matching list of metadata about each face.
known_face_encodings = []
known_face_metadata = []


def save_known_faces():
    with open("known_faces.dat", "wb") as face_data_file:
        face_data = [known_face_encodings, known_face_metadata]
        pickle.dump(face_data, face_data_file)
        print("Known faces backed up to disk.")


def load_known_faces():
    global known_face_encodings, known_face_metadata

    try:
        with open("known_faces.dat", "rb") as face_data_file:
            known_face_encodings, known_face_metadata = pickle.load(face_data_file)
            print("Known faces loaded from disk.")
    except FileNotFoundError as e:
        print("No previous face data found - starting with a blank known face list.")
        pass


def running_on_jetson_nano():
    # To make the same code work on a laptop or on a Jetson Nano, we'll detect when we are running on the Nano
    # so that we can access the camera correctly in that case.
    # On a normal Intel laptop, platform.machine() will be "x86_64" instead of "aarch64"
    return platform.machine() == "aarch64"

## On board CSI camera
##
def get_jetson_gstreamer_source(capture_width=1280, capture_height=720, display_width=1280, display_height=720, framerate=120, flip_method=0):
    """
    Return an OpenCV-compatible video source description that uses gstreamer to capture video from the camera on a Jetson Nano
    """
    return (
            f'nvarguscamerasrc ! video/x-raw(memory:NVMM), ' +
            f'width=(int){capture_width}, height=(int){capture_height}, ' +
            f'format=(string)NV12, framerate=(fraction){framerate}/1 ! ' +
            f'nvvidconv flip-method={flip_method} ! ' +
            f'video/x-raw, width=(int){display_width}, height=(int){display_height}, format=(string)BGRx ! ' +
            'videoconvert ! video/x-raw, format=(string)BGR ! appsink'
            )


# My USB Camera has following options:
#video/x-raw, format=(string)YUY2, width=(int)1920, height=(int)1080, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)6/1; 
#video/x-raw, format=(string)YUY2, width=(int)1280, height=(int)1024, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)6/1; 
#video/x-raw, format=(string)YUY2, width=(int)1280, height=(int)720,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)9/1; 
#video/x-raw, format=(string)YUY2, width=(int)1024, height=(int)768,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)6/1; 
#video/x-raw, format=(string)YUY2, width=(int)800,  height=(int)600,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)20/1; 
#video/x-raw, format=(string)YUY2, width=(int)640,  height=(int)480,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)30/1; 
#video/x-raw, format=(string)YUY2, width=(int)320,  height=(int)240,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)30/1; 
#image/jpeg, width=(int)1920, height=(int)1080, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)30/1; 
#image/jpeg, width=(int)1280, height=(int)1024, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)30/1; 
#image/jpeg, width=(int)1280, height=(int)720,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)60/1;
#image/jpeg, width=(int)1024, height=(int)768,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)30/1; 
#image/jpeg, width=(int)800,  height=(int)600,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)60/1; 
#image/jpeg, width=(int)640,  height=(int)480,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)61612/513; 
#image/jpeg, width=(int)320,  height=(int)240,  pixel-aspect-ratio=(fraction)1/1, framerate=(fraction)61612/513;

# Test capability of your camera:
# v4l2-ctl --list-formats-ext --device=0
# Change debug output of gstreamer 0..5
# export GST_DEBUG="*:0"
# gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,format=YUY2,width=320, height=240,             framerate=30/1                ! xvimagesink
# gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg,             width=320, height=240, type=video, framerate=61612/513 ! jpegdec ! xvimagesink
# gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg,             width=1280,height=720, type=video, framerate=61612/513 ! jpegdec ! videoconvert ! video/x-raw, format=BGR ! xvimagesink

#def get_jetson_gstreamer_source():
#    """
#    Return an OpenCV-compatible video source description that uses gstreamer to capture video from the camera on a Jetson Nano
#    """
#    return (
#        'v4l2src device=/dev/video0 ! image/jpeg, width=(int)1080, height=(int)720, type=video, framerate=(fraction)61612/513 ! ' + # sink
#        ' jpegdec ! ' +                                                                                                            # decode jpeg image
#        'videoconvert ! video/x-raw, format=(string)BGR ! appsink'                                                                 # convert to opencv format
#        )

def register_new_face(face_encoding, face_image):
    """
    Add a new person to our list of known faces
    """
    # Add the face encoding to the list of known faces
    known_face_encodings.append(face_encoding)
    # Add a matching dictionary entry to our metadata list.
    # We can use this to keep track of how many times a person has visited, when we last saw them, etc.
    known_face_metadata.append({
        "first_seen": datetime.now(),
        "first_seen_this_interaction": datetime.now(),
        "last_seen": datetime.now(),
        "registrations": [datetime.now()],
        "seen_count": 1,
        "seen_frames": 1,
        "face_image": face_image,
        "First": "Jane",
        "Last": "Doe",
    })


def lookup_known_face(face_encoding):
    """
    See if this is a face we already have in our face list
    """
    metadata = None

    # If our known face list is empty, just return nothing since we can't possibly have seen this face.
    if len(known_face_encodings) == 0:
        return metadata

    # Calculate the face distance between the unknown face and every face on in our known face list
    # This will return a floating point number between 0.0 and 1.0 for each known face. The smaller the number,
    # the more similar that face was to the unknown face.
    face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)

    # Get the known face that had the lowest distance (i.e. most similar) from the unknown face.
    best_match_index = np.argmin(face_distances)

    # If the face with the lowest distance had a distance under 0.6, we consider it a face match.
    # 0.6 comes from how the face recognition model was trained. It was trained to make sure pictures
    # of the same person always were less than 0.6 away from each other.
    # Here, we are loosening the threshold a little bit to 0.65 because it is unlikely that two very similar
    # people will come up to the door at the same time.
    if face_distances[best_match_index] < 0.65:
        # If we have a match, look up the metadata we've saved for it (like the first time we saw it, etc)
        metadata = known_face_metadata[best_match_index]

        # Update the metadata for the face so we can keep track of how recently we have seen this face.
        metadata["last_seen"] = datetime.now()
        metadata["seen_frames"] += 1

        # We'll also keep a total "seen count" that tracks how many times this person has come to the door.
        # But we can say that if we have seen this person within the last 5 minutes, it is still the same
        # visit, not a new visit. But if they go away for awhile and come back, that is a new visit.
        if datetime.now() - metadata["first_seen_this_interaction"] > timedelta(minutes=5):
            metadata["first_seen_this_interaction"] = datetime.now()
            metadata["seen_count"] += 1
            metadata["registrations"].append(datetime.now())

    return metadata


def main_loop():
    # Get access to the webcam. The method is different depending on if this is running on a laptop or a Jetson Nano.
    if running_on_jetson_nano():
        # Accessing the camera with OpenCV on a Jetson Nano requires gstreamer with a custom gstreamer source string
        video_capture = cv2.VideoCapture(get_jetson_gstreamer_source(), cv2.CAP_GSTREAMER)
    else:
        # Accessing the camera with OpenCV on a laptop just requires passing in the number of the webcam (usually 0)
        # Note: You can pass in a filename instead if you want to process a video file instead of a live camera stream
        video_capture = cv2.VideoCapture(0)

    # Track how long since we last saved a copy of our known faces to disk as a backup.
    number_of_faces_since_save = 0

    while True:
        # Grab a single frame of video
        ret, frame = video_capture.read()

        # Resize frame of video to 1/4 size for faster face recognition processing
        small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)

        # Convert the image from BGR color (which OpenCV uses) to RGB color (which face_recognition uses)
        rgb_small_frame = small_frame[:, :, ::-1]

        # Find all the face locations and face encodings in the current frame of video
        face_locations = face_recognition.face_locations(rgb_small_frame)
        face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations)

        # Loop through each detected face and see if it is one we have seen before
        # If so, we'll give it a label that we'll draw on top of the video.
        face_labels = []
        for face_location, face_encoding in zip(face_locations, face_encodings):
            # See if this face is in our list of known faces.
            metadata = lookup_known_face(face_encoding)

            # If we found the face, label the face with some useful information.
            if metadata is not None:
                time_at_door = datetime.now() - metadata['first_seen_this_interaction']
                face_label = f"At door {int(time_at_door.total_seconds())}s"

            # If this is a brand new face, add it to our list of known faces
            else:
                face_label = "New visitor!"

                # Grab the image of the the face from the current frame of video
                top, right, bottom, left = face_location
                face_image = small_frame[top:bottom, left:right]
                face_image = cv2.resize(face_image, (150, 150))

                # Add the new face to our known face data
                register_new_face(face_encoding, face_image)

            face_labels.append(face_label)

        # Draw a box around each face and label each face
        for (top, right, bottom, left), face_label in zip(face_locations, face_labels):
            # Scale back up face locations since the frame we detected in was scaled to 1/4 size
            top *= 4
            right *= 4
            bottom *= 4
            left *= 4

            # Draw a box around the face
            cv2.rectangle(frame, (left, top), (right, bottom), (0, 0, 255), 2)

            # Draw a label with a name below the face
            cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 0, 255), cv2.FILLED)
            cv2.putText(frame, face_label, (left + 6, bottom - 6), cv2.FONT_HERSHEY_DUPLEX, 0.8, (255, 255, 255), 1)

        # Display recent visitor images
        number_of_recent_visitors = 0
        for metadata in known_face_metadata:
            # If we have seen this person in the last minute, draw their image
            if datetime.now() - metadata["last_seen"] < timedelta(seconds=10) and metadata["seen_frames"] > 5:
                # Draw the known face image
                x_position = number_of_recent_visitors * 150
                frame[30:180, x_position:x_position + 150] = metadata["face_image"]
                number_of_recent_visitors += 1

                # Label the image with how many times they have visited
                visits = metadata['seen_count']
                visit_label = f"{visits} visits"
                if visits == 1:
                    visit_label = "First visit"
                cv2.putText(frame, visit_label, (x_position + 10, 170), cv2.FONT_HERSHEY_DUPLEX, 0.6, (255, 255, 255), 1)

        if number_of_recent_visitors > 0:
            cv2.putText(frame, "Visitors at Door", (5, 18), cv2.FONT_HERSHEY_DUPLEX, 0.8, (255, 255, 255), 1)



        # Display the final frame of video with boxes drawn around each detected fames
        cv2.imshow('Video', frame)

        # Hit 'q' on the keyboard to quit!
        if cv2.waitKey(1) & 0xFF == ord('q'):
            save_known_faces()
            break

        # We need to save our known faces back to disk every so often in case something crashes.
        if len(face_locations) > 0 and number_of_faces_since_save > 100:
            save_known_faces()
            number_of_faces_since_save = 0
        else:
            number_of_faces_since_save += 1

    # Release handle to the webcam
    video_capture.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    load_known_faces()
    main_loop()
