#!/bin/sh
################################################################
# file: MK_IMAGE.sh
# author: Richard Luo
# date: 2011/05/22 08:00:43
################################################################

if [ ! -f $1 ]; then
    echo "usage: MK_IMAGE.sh <input randisk image file>"
    exit 100
fi

#  mkimage -A arm -O linux -T ramdisk -C none -a 0x30800000 -n "ramdisk" -d ramdisk.img ramdisk-uboot.img
if mkimage -A arm -O linux -T ramdisk -C none -a 0x30800000 -n "ramdisk" -d $1 $1.img; then
    echo "mkimage ok, output the $1.img file here!"
else
    echo "mkimage failed!!!"
fi

