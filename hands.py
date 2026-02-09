from pythonosc.udp_client import SimpleUDPClient

OSC_IP = "127.0.0.1"
OSC_PORT = 8000

osc = SimpleUDPClient(OSC_IP, OSC_PORT)

import cv2
import mediapipe as mp
import math
import constants

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    max_num_hands=constants.MAX_NUM_HANDS,
    min_detection_confidence=0.6,
    min_tracking_confidence=0.6
)

cap = cv2.VideoCapture(constants.CAMERA_INDEX)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, constants.FRAME_WIDTH)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, constants.FRAME_HEIGHT)

cv2.namedWindow("Hand Tracking", cv2.WINDOW_NORMAL)
cv2.resizeWindow("Hand Tracking", constants.FRAME_WIDTH, constants.FRAME_HEIGHT)
cv2.setWindowProperty(
    "Hand Tracking",
    cv2.WND_PROP_FULLSCREEN,
    cv2.WINDOW_FULLSCREEN
)

# (hand_id, finger_landmark) -> pinch state
pinch_state = {}

def distance(a, b):
    return math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame = cv2.flip(frame, 1)
    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = hands.process(rgb)

    if results.multi_hand_landmarks:
        for hand_id, hand in enumerate(results.multi_hand_landmarks):
            thumb = hand.landmark[constants.THUMB_TIP]

            for finger_lm in constants.FINGERS_LANDMARKS:
                finger = hand.landmark[finger_lm]
                d = distance(thumb, finger)
                is_pinched = d < constants.PINCH_THRESHOLD

                key = (hand_id, finger_lm)
                prev = pinch_state.get(key, False)

                if is_pinched != prev:
                    pinch_state[key] = is_pinched
                    print("distand", d)
                    osc.send_message(
                         "/pinch",
                        [
                            hand_id,
                            constants.FINGER_INDEX[finger_lm],
                            int(is_pinched),
                            finger.x,
                            finger.y,
                            d
                        ]
                    )

                h, w, _ = frame.shape
                cx, cy = int(finger.x * w), int(finger.y * h)

                base_color = constants.FINGER_COLORS[finger_lm]
                color = constants.RGB_COLOR_PRESS if is_pinched else base_color

                cv2.circle(
                    frame,
                    (cx, cy),
                    10 if is_pinched else 6,
                    color,
                    -1
                )

    cv2.imshow("Hand Tracking", frame)
    if cv2.waitKey(1) & 0xFF == 27:
        break

cap.release()
cv2.destroyAllWindows()
