#!/bin/sh
################################################################
# file: KILL_ANDROID_PROC.sh
# author: Richard Luo
# date: 2011/01/18 09:46:49
################################################################


if [ -z $1 ]; then
    name=mediaserver
else
    name=$1
fi

pid=$(adb shell ps|grep $name| awk '{print $2}')

if [ "X$pid" = "X" ]; then
    echo "can not found the pid of process name $name"
    exit 100
fi

if adb shell kill -9 $pid; then
    echo "$name of pid:$pid has been killed"
else
    echo "error while killing $name of pid:$pid"
fi



