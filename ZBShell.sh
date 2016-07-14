#!/bin/sh
################################################################
# file:   ZShell.sh
# author: Richard Luo
# date:   2012-08-11 21:10:41
################################################################

if [ "$1X" = "X" ]; then
    VDS=0
else
    VDS=1
fi

~/ddbs/out/host/linux-x86/pr/sim/system/bin/zbshell --vds $VDS 2>&1 | tee /home/richard/ddbs/frameworks/zbshell.log
