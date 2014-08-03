#!/bin/sh
################################################################
# file:   ZShell.sh
# author: Richard Luo
# date:   2012-08-11 21:10:41
################################################################

~/ddbs/out/host/linux-x86/pr/sim/system/bin/zbshell $PORT 2>&1 | tee zbshell.log
