#!/bin/bash

# Check if the lockscreen is already active
LOCKED=$(qdbus6 org.freedesktop.ScreenSaver /ScreenSaver org.freedesktop.ScreenSaver.GetActive 2>/dev/null)

if [ "$LOCKED" = "true" ]; then
    exit 0
fi

/home/alex/.local/bin/check-presence.py
EXIT_CODE=$?

# If face is missing (Exit 1), lock and drop display into DPMS sleep
if [ $EXIT_CODE -ne 0 ]; then
    loginctl lock-session
    sleep 1
    kscreen-doctor --dpms off
fi
