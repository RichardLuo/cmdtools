#!/bin/sh
################################################################
# file:   Ezshell.sh
# author: Richard Luo
# date:   2012-08-11 21:10:41
################################################################

export ANDROID_PRINTF_LOG="time"
~/ddbs/out/host/linux-x86/pr/sim/system/bin/ncp_emulator  2>&1 | tee /home/richard/ddbs/frameworks/ncp-emulator-$(date +%Y%m%d-%H%S).log

