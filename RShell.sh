#!/bin/bash
################################################################
# file:   ZShell.sh
# author: Richard Luo
# date:   2012-08-11 21:10:41
################################################################

# ~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell $1 $2 $3 $4 $5 $6 $7 2>&1 | tee rshell.log

export ANDROID_PRINTF_LOG="time"

if [ $1"X" = "X" ]; then
    echo "please specify the type : 'box' or 'cli'"
    exit 0
fi

# BOX_ACC=box-a0-f6-fd-6c-a9-fd
BOX_ACC=box-00-00-00-00-00-00
PASSWORD=1234567

set -ix
if [ $1 = "box" ]; then
    # run -u box-00-00-00-00-00-00 -P 1234567 -s xiaoyan.io -p 5222 -t tl
    ~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell -u ${BOX_ACC} -P ${PASSWORD}  -s xiaoyan.io  -p 5222  -t -l 2>&1 | tee rshell-box.log
fi

if [ $1 = "cli" ]; then
    # run  -u box_richard_x86 -P 5555  -s xiaoyan.io  -p 5222  -t -c
    # ~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell -u ray -P 123456  -s xiaoyan.io  -p 5222  -t -c 2>&1 | tee rshell-cli.log
    ~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell -u richard -P 123456  -s xiaoyan.io  -p 5222  -t -c 2>&1 | tee rshell-cli.log
    # ~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell -u alisa -P 1234  -s xiaoyan.io  -p 5222  -t -c 2>&1 | tee rshell-cli.log
    # ~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell -u asdfg -P 1234  -s xiaoyan.io  -p 5222  -t -c 2>&1 | tee rshell-cli.log
fi

# rshell -u box_richard_x86 -P 5555  -s xiaoyan.io  -p 5222  -t -l
# rshell -u richard -P 5555  -s liveliy.com  -p 5222  -t -l
