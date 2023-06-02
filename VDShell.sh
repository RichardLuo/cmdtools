#!/bin/bash
################################################################
# file:   VDShell.sh
# author: Richard Luo
# date:   2013-08-14 19:43:26
################################################################

~/ddbs/out/host/linux-x86/pr/sim/system/bin/vdshell $PORT 2>&1 | tee vdshell.log
