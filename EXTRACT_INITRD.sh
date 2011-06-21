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

################################################################
# brief: to extract the contents of image file $1 to the output dir
# specified by $2
# $1: input gzipped cpio image
# $2: optional output directory
################################################################
function extract_gzip_cpio_image_to_dir()
{
    local image_file=""
    if [ "X"$1 = "X" ]; then
        image_file="/boot/initrd.img-`uname -r`"
        echo "using the default initramfs file: $image_file"
    else
        image_file=`readlink -f $1`
    fi
    

    if ! check_image_file $image_file; then
        echo "invalid input image file: $image_file"
        exit 100
    fi

    local output_dir=$2
    if [ "X"$2 = "X" ]; then
        output_dir=/tmp/extract_image/
        printf "use the default output dir:$output_dir \n"
    fi

    rm -rf ${output_dir} && mkdir ${output_dir}

    if (cd ${output_dir} && gunzip<$image_file | cpio -i --make-directories); then
        find -type f 
        echo "================================================================"
        echo "extract the $image_file to ${output_dir} ok"
        echo "================================================================"
    else
        echo "extract the $image_file failed"
        exit 100
    fi
}

extract_gzip_cpio_image_to_dir $1 $2