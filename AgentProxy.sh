#!/bin/bash
################################################################
# file:   AgentProxy.sh
# author: Richard Luo
# date:   2012-08-26 12:29:30
################################################################

DEV=/dev/ttyUSB0

if [ "$1X" != "X" ]; then
    DEV=$1
fi

if [ ! -c $DEV ]; then
    echo "there is no such device $DEV"
    exit 1
fi

agent-proxy 4440^4441 0 $DEV,115200
