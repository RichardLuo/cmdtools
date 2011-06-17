#!/bin/sh
################################################################
# file: ANDROID_LIBS_DIFF.sh
# author: Richard Luo
# date: 2011/01/18 07:13:36
################################################################

if [ ! -d system ]; then
    echo "echo current dir is not sysdir"
    exit 100
fi

board_libs=/tmp/libs.of.device.txt
sysdir_libs=/tmp/libs.of.sysdir.txt

if ! adb shell ls --color=never /system/lib -lt| awk  '{print $9}'|perl -pe 's/(^lib*.so)/\1/g' |sort>$board_libs
    then
    echo "could get the libs info from the board"
    exit 100
fi

if ! ls --color=never -l system/lib/| awk '{print $8}'| sort |perl -pe 's/(^lib*.so)/\1/g' > $sysdir_libs
    then
    echo "failed to list the system/lib/ dir"
    exit 100
fi

diff -w -B -N -C 4  $board_libs $sysdir_libs
