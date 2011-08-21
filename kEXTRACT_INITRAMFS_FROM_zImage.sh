#!/bin/sh
################################################################
# file: cmd_run.sh
# author: Richard Luo
# date: 2011/08/21 15:04:53
################################################################


C_H1="\033[1;37m"        # highlight text 1
C_ERR="\033[1;31m"
C_CLEAR="\033[1;0m"

# helper functions:

printhl() 
{
	printf "${C_H1}${1}${C_CLEAR} \n"
}

printerr() 
{
	printf "${C_ERR}${1}${C_CLEAR} \n"
}


exit_print() 
{
    printerr "$@"
    exit 1
}

# $1: input zImage
# $2: output cpio image
extract_initramfs_from_zImage() 
{
    local zImage=$1
    local outCpio=$2

    #========================================================
    # find start of gziped kernel object in the zImage file:
    #========================================================
    pos=`grep -P -a -b -m 1 --only-matching $'\x1F\x8B\x08' $zImage | cut -f 1 -d :`
    echo "-I- Extracting kernel image from $zImage (start = $pos)"

    #========================================================================
    # the cpio archive might be gzipped too, so two gunzips could be needed:
    #========================================================================
    dd if=$zImage bs=1 skip=$pos | gunzip > /tmp/kernel.img
    pos=`grep -P -a -b -m 1 --only-matching $'\x1F\x8B\x08' /tmp/kernel.img | cut -f 1 -d :`
    #===========================================================================
    # find start and end of the "cpio" initramfs image inside the kernel object:
    # ASCII cpio header starts with '070701'
    # The end of the cpio archive is marked with an empty file named TRAILER!!!
    #===========================================================================
    if [ ! $pos = "" ]; then
        echo "-I- Extracting compressed cpio image from kernel image (start = $pos)"
        dd if=/tmp/kernel.img bs=1 skip=$pos | gunzip > /tmp/cpio.img
        start=`grep -a -b -m 1 --only-matching '070701' /tmp/cpio.img | head -1 | cut -f 1 -d :`
        end=`grep -a -b -m 1 --only-matching 'TRAILER!!!' /tmp/cpio.img | head -1 | cut -f 1 -d :`
        inputfile=/tmp/cpio.img
    else
        echo "-I- Already uncompressed cpio.img, not decompressing"
        start=`grep -a -b -m 1 --only-matching '070701' /tmp/kernel.img | head -1 | cut -f 1 -d :`
        end=`grep -a -b -m 1 --only-matching 'TRAILER!!!' /tmp/kernel.img | head -1 | cut -f 1 -d :`
        inputfile=/tmp/kernel.img
    fi

    # 11 bytes = length of TRAILER!!! zero terminated string, fixes premature end of file warning in CPIO
    end=$((end + 11))
    count=$((end - start))
    if (($count < 0)); then
        echo "-E- Couldn't match start/end of the initramfs image."
        exit
    fi
    echo "-I- Extracting initramfs image from $inputfile (start = $start, end = $end)"
    if dd if=$inputfile bs=1 skip=$start count=$count > $outCpio; then
        echo "output $outCpio is ok! "
        return 0
    fi

    echo "failed!"
    return 1
}


# $1: path to cpio image
# $2: path to out dir
extract_cpio_to_dir() 
{
    local cpio_img=`realpath $1`
    local root_dir=$2

    if [ $cpio_img"X" = "X" ]; then
        exit_print "please specify the cpio image"
    fi

    if [ $root_dir"X" = "X" ]; then
        exit_print "please specify the root dir"
    fi

    if [ ! -f $cpio_img ]; then
        echo "$cpio_img doesn't exist!"
        exit 1
    fi

    rm -rf $root_dir
    if ! mkdir -p $root_dir; then
        exit_print "ERR: make  $root_dir"
    fi

    # for the output:"cpio: premature end of file",
    # it's a bug of the cpio
    if ! (cd $root_dir && cpio -v -im --no-absolute-filenames < $cpio_img); then
        ls $root_dir -l
    fi
    return 0
}


print_usage() 
{
    exit_print "cmd_run.sh <path to zImage> <output root dir>"
}

# $1 the zImage file
# $2 the output root dir
function main()
{
    if [ $1"X" = "X" ] || [ $2"X" = "X" ]; then
        print_usage
    fi

    if [ ! -f $1 ]; then
        exit_print "ERR: $1 does not exist!"
    fi

    local zImage=$1
    local outRoot=$2
    if ! rm -rf $outRoot && mkdir -p $outRoot; then
        exit_print "error while create $outRoot"
    fi
    local tmpCpioImg=/tmp/tmp_cpio.img
    if extract_initramfs_from_zImage $zImage $tmpCpioImg;then
        echo "extract $zImage to $tmpCpioImg ok!"
        if extract_cpio_to_dir $tmpCpioImg $outRoot; then
            echo "generate $outRoot ok!"
            return 0
        fi
    fi
    echo "failed!!"
}

main $1 $2
