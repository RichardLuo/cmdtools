#!/bin/bash
################################################################
# file: mk_android_sysimg.sh
# author: Richard Luo
# date: 2010/12/28 13:43:57
################################################################

Date=`date +%Y%m%d%S`

# $1: path to rootfs directory
function make_dir_to_rootfs_image()
{
    if [ -d $1 ]; then
        if [ -f ramdisk.img ]; then
            echo "backup ramdisk.img to ramdisk.img.org.$Date"
            mv ramdisk.img ramdisk.img.org.$Date
        fi

        mkbootfs $1 | minigzip > ramdisk.img 
        mkimage -A arm -O linux -T ramdisk -C none -a 0x30800000 -n "ramdisk" -d ramdisk.img ramdisk-uboot.img

        target=ramdisk-uboot.img
        echo "make android ramdisk [$target] ok"
        ls -l $target
        return 0
    else
        echo please input the directory name!
        return 1
    fi
}

if make_dir_to_rootfs_image $1; then
    echo ok!
fi





