#!/bin/sh
################################################################
# file: check_install_gst_lib.sh
# author: Richard Luo
# date: 2010/12/07 05:25:55
# brief: before execute this script please cd dir of 'system'
################################################################

#set -ix

needed_libs="`objdump -x $1|grep NEED| sed -e 's/.*NEEDED *//'|xargs`"
# echo "needed_libs=[$needed_libs]"


for l in $needed_libs; do
    file=lib/$l
    if [ -f $file ]; then
        echo "to install --- $file"
        adb push $file /system/lib/
    else
        echo "there is no file:$file"
        exit 100
    fi
done
