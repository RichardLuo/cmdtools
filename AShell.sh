#!/bin/sh
################################################################
# file:   Ashell.sh
# author: Richard Luo
# date:   2012-08-11 21:10:41
################################################################

PORT=$1

if [ -z $PORT ];then
    PORT=/dev/ttyUSB0
fi

echo "PORT: $PORT"
~/ddbs/out/host/linux-x86/pr/sim/system/bin/ashell -p $PORT 2>&1 | tee /home/richard/ddbs/frameworks/ashell.log
