#!/bin/bash
################################################################
# file:   ZShell.sh
# author: Richard Luo
# date:   2012-08-11 21:10:41
################################################################

# ~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell $1 $2 $3 $4 $5 $6 $7 2>&1 | tee rshell.log

if [ $1"X" = "X" ]; then
    echo "please specify the type : 'box' or 'cli'"
    exit 0
fi

if [ $1 = "box" ]; then
    ~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell -u richard -P 555  -s liveliy.com  -p 5222  -t -l 2>&1 | tee rshell-box.log
fi

if [ $1 = "cli" ]; then
    # run  -u richard -P 5555  -s liveliy.com  -p 5222  -t -c
    ~/ddbs/out/host/linux-x86/pr/sim/system/bin/rshell -u richard -P 555  -s liveliy.com  -p 5222  -t -c 2>&1 | tee rshell-cli.log
fi




# rshell -u richard -P 5555  -s liveliy.com  -p 5222  -t -l
