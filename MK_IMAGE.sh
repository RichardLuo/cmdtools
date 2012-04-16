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

ADDRESS=0x30800000
if [ "X$2" != "X" ];then
    ADDRESS=$2
fi

## MKIMAGE_TOOL=/usr/bin/mkimage
MKIMAGE_TOOL=/home/richard/bin/mkimage

#  mkimage -A arm -O linux -T ramdisk -C none -a 0x30800000 -n "ramdisk" -d ramdisk.img ramdisk-uboot.img
if ${MKIMAGE_TOOL} -A arm -O linux -T ramdisk -C none -a ${ADDRESS} -n "ramdisk" -d $1 $1.img; then
    echo "${MKIMAGE_TOOL} ok, output the $1.img file here!"
else
    echo "${MKIMAGE_TOOL} failed!!!"
fi

