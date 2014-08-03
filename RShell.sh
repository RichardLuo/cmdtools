#!/bin/sh
################################################################
# file:   ZShell.sh
# author: Richard Luo
# date:   2012-08-11 21:10:41
################################################################

~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell $1 $2 $3 $4 $5 $6 $7 2>&1 | tee rshell.log
