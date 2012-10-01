#!/bin/sh
################################################################
# file:   ZShell.sh
# author: Richard Luo
# date:   2012-08-11 21:10:41
################################################################

PORT=$1

if [ -z $PORT ];then
    PORT=/dev/ttyUSB0
fi

/media/linux/ddbs/out/host/linux-x86/pr/sim/system/bin/zshell $PORT
