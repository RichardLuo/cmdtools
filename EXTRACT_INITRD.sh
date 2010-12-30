#!/bin/sh
################################################################
# file: extract_my_initrd.sh
# author: Richard Luo
# date: 2010/12/08 15:17:55
################################################################

################################################################
# brief:
# extract the specified initrd image file to the specified directory
# usage:
# EXTRACT_INITRD.sh <path-to-initrd-img> <dirname> 
################

# $1 is the dir name for this initrd image

function check_image_file()
{
    if file $1 | grep "gzip compressed data"; then
        return 0
    fi
    return 1
}


if [ -z $1 ]; then
    image_file="/boot/initrd.img-`uname -r`"
    echo "using the default initramfs file: $image_file"
else
    image_file=$1
fi


if ! check_image_file $image_file; then
    echo "invalid input image file: $image_file"
    exit 100
fi

if gunzip<$image_file | cpio -i --make-directories; then
    find -type f 
    echo "extract the $image_file ok"
else
    echo "extract the $image_file failed"
    exit 100
fi
