#!/bin/sh
################################################################
# build-arch.sh
# Richard Luo
# 2008-11-10
################################################################

case "$1" in

    arm)

        build_dir=build-arm
        mkdir -p $build_dir
        rm -rf $build_dir/*

        (cd $build_dir && ../configure --host=arm-none-linux-gnueabi && make CROSS_COMPILE=arm-none-linux-gnueabi)

        ;;


    x86)
        build_dir=build-x86
        mkdir -p $build_dir
        rm -rf $build_dir/*

        (cd $build_dir && ../configure && make )

        ;;

    *)
	    echo "Usage: build-arch.sh <arm|x86>"
	    exit 1
	    ;;
esac

exit 0

