# constants.py

# ---------------- CAMERA ----------------
CAMERA_INDEX = 1
FRAME_WIDTH = 1020
FRAME_HEIGHT = 1080

# ---------------- HANDS ----------------
MAX_NUM_HANDS = 2

# MediaPipe landmarks
WRIST_LANDMARK = 0
THUMB_TIP = 4

INDEX_LANDMARK = 8
MIDDLE_LANDMARK = 12
RING_LANDMARK = 16
PINKY_LANDMARK = 20

FINGERS_LANDMARKS = [
    INDEX_LANDMARK,
    MIDDLE_LANDMARK,
    RING_LANDMARK,
    PINKY_LANDMARK,
]

FINGER_NAMES = {
    INDEX_LANDMARK: "index",
    MIDDLE_LANDMARK: "middle",
    RING_LANDMARK: "ring",
    PINKY_LANDMARK: "pinky",
}

FINGER_INDEX = {
    INDEX_LANDMARK: 0,
    MIDDLE_LANDMARK: 1,
    RING_LANDMARK: 2,
    PINKY_LANDMARK: 3,
}

# ---------------- PINCH LOGIC ----------------
# Distance is normalized (0–1)
PINCH_THRESHOLD = 0.05   # tweak between 0.035–0.05 if needed

# ---------------- COLORS (BGR) ----------------
RGB_BLUE = (255, 0, 0)
RGB_GREEN = (0, 255, 0)
RGB_ORANGE = (0, 165, 255)
RGB_RED = (0, 0, 255)
RGB_PURPLE = (255, 0, 255)

RGB_COLOR_PRESS = (0, 255, 255)

FINGER_COLORS = {
    INDEX_LANDMARK: RGB_BLUE,
    MIDDLE_LANDMARK: RGB_GREEN,
    RING_LANDMARK: RGB_ORANGE,
    PINKY_LANDMARK: RGB_RED,
}
