#!/bin/bash
################################################################
# file:   Ezshell.sh
# author: Richard Luo
# date:   2012-08-11 21:10:41
################################################################

export ANDROID_PRINTF_LOG="time"

PORT=$1

if [ -z $PORT ];then
    PORT=/dev/ttyUSB0
fi

echo "PORT: $PORT"
# cp /home/richard/ezshell_sample_history /home/richard/.ezshell_history
# ~/ddbs/out/host/linux-x86/pr/sim/system/bin/zncs -c 192.168.2.217 2>&1 | tee /home/richard/ddbs/frameworks/zncs.log
~/ddbs/out/host/linux-x86/pr/sim/system/bin/zncs 2>&1 | tee /home/richard/ddbs/frameworks/zncs.log
# ~/ddbs/out/host/linux-x86/pr/sim/system/bin/ezshell -s 2>&1 | tee /home/richard/ddbs/frameworks/ezshell.log
