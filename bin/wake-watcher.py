#!/usr/bin/env python3
import os
os.environ["OPENCV_LOG_LEVEL"] = "SILENT"
import cv2
import time
import subprocess

RGB_CAM = "/dev/v4l/by-path/pci-0000:00:14.0-usb-0:8:1.0-video-index0"
MODEL_PATH = "/usr/share/linuxcampam/models/face_detection_yunet_2023mar.onnx"

if not os.path.exists(MODEL_PATH):
    exit(1)

def is_locked():
    try:
        res = subprocess.run(["qdbus6", "org.freedesktop.ScreenSaver", "/ScreenSaver", "org.freedesktop.ScreenSaver.GetActive"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if "true" in res.stdout.lower():
            return True
    except Exception:
        pass
    return False

detector = None

while True:
    if not is_locked():
        time.sleep(2)
        continue

    cap = cv2.VideoCapture(RGB_CAM, cv2.CAP_V4L2)
    if not cap.isOpened():
        cap = cv2.VideoCapture(0, cv2.CAP_V4L2)

    if cap.isOpened():
        ret, frame = cap.read()
        cap.release()
        if ret and frame is not None:
            h, w, _ = frame.shape
            if detector is None:
                detector = cv2.FaceDetectorYN.create(
                    model=MODEL_PATH,
                    config="",
                    input_size=(w, h),
                    score_threshold=0.65,
                    nms_threshold=0.3,
                    top_k=5000
                )
            _, faces = detector.detect(frame)
            if faces is not None and len(faces) > 0:
                # Turn on display, wake screensaver, and inject synthetic mouse movement
                subprocess.run(["kscreen-doctor", "--dpms", "on"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                subprocess.run(["qdbus6", "org.freedesktop.ScreenSaver", "/ScreenSaver", "SetActive", "false"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                subprocess.run(["ydotool", "mousemove", "-x", "1", "-y", "0"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                time.sleep(5)

    time.sleep(1.5)
