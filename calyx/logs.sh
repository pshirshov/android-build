#!/bin/bash -xe

adb kill-server
ADDR="`adb shell ip addr show wlan0 | grep "inet\s" | awk '{print $2}' | awk -F'/' '{print $1}'`"
PORT=5555
adb tcpip $PORT

read -p "Disconnect USB and press enter to continue"
adb connect $ADDR:$PORT

adb logcat | tee "log-`date`.txt"
