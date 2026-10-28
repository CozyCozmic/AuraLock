#!/usr/bin/env python3
import os
os.environ["OPENCV_LOG_LEVEL"] = "SILENT"
import cv2
import sys

RGB_CAM = "/dev/v4l/by-path/pci-0000:00:14.0-usb-0:8:1.0-video-index0"
MODEL_PATH = "/usr/share/linuxcampam/models/face_detection_yunet_2023mar.onnx"

if not os.path.exists(MODEL_PATH):
    sys.exit(1)

cap = cv2.VideoCapture(RGB_CAM, cv2.CAP_V4L2)
if not cap.isOpened():
    cap = cv2.VideoCapture(0, cv2.CAP_V4L2)

if not cap.isOpened():
    sys.exit(1)

# Warm up sensor
for _ in range(4):
    cap.read()

ret, frame = cap.read()
cap.release()

if not ret or frame is None:
    sys.exit(1)

h, w, _ = frame.shape

detector = cv2.FaceDetectorYN.create(
    model=MODEL_PATH,
    config="",
    input_size=(w, h),
    score_threshold=0.6,
    nms_threshold=0.3,
    top_k=5000
)

_, faces = detector.detect(frame)

if faces is not None and len(faces) > 0:
    sys.exit(0)
else:
    sys.exit(1)
