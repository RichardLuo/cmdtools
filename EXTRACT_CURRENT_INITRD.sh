#!/bin/sh
################################################################
# file: extract_my_initrd.sh
# author: Richard Luo
# date: 2010/12/08 15:17:55
################################################################

################################################################
# brief:
# extract the current initrd image files to the current directory
# usage:
# EXTRACT_MY_INITRD.sh <image-name> 
################

# $1 is the dir name for this initrd image

if [ -z $1 ]; then
    image_file="/boot/initrd.img-`uname -r`"
    echo "using the default initramfs file: $image_file"
fi

if [ ! -f $image_file ]; then
    echo "could not find the file: $image_file"
    exit 100
fi

if gunzip<$image_file | cpio -i --make-directories; then
    find -type f 
    echo "extract the $image_file ok"
else
    echo "extract the $image_file failed"
    exit 100
fi
