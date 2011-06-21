#!/bin/sh
################################################################
# file: MK_CPIO_IMG.sh
# author: Richard Luo
# date: 2011/05/22 07:55:37
################################################################

# $1: the input fs dir
# $2: optional output image file path
function make_cpio_gzip_imge()
{
    if [ "X"$1 = "X" ]; then
        cmd=`basename $0`
        printf "===============================================================\n"
        printf "usage: \n    $cmd <rootfs-directory> [output-image-file-name]\n"
        printf "===============================================================\n"
        exit 1
    fi

    local output_img=`basename $1`.cpio.gz       # default value
    if [ ! "X"$2 = "X" ];then
        output_img=$2
    fi

    local input_root_dir=$1
    if [ -d ${input_root_dir} ]; then
        (cd ${input_root_dir} && find . | cpio -o -H newc | gzip) > ${output_img}
        ls -l ${output_img}
        echo "make cpio image: ${output_img} from: ${input_root_dir} is fininshed ok!"
    else
        echo "the input root directory:${input_root_dir} doesn't exist!!!"
        exit 1
    fi
}

make_cpio_gzip_imge $1 $2