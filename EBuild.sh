#!/bin/sh
################################################################
# file: Ebuild.sh
# author: Richard Luo
# date: 2010/04/18 11:15:55
################################################################

function Gettop
{
    local TOPFILE=build/core/envsetup.mk
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        echo $TOP
    else
        if [ -f $TOPFILE ] ; then
            echo $PWD
        else
            # We redirect cd to /dev/null in case it's aliased to
            # a command that prints something as a side-effect
            # (like pushd)
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                cd .. > /dev/null
                T=$PWD
            done
            cd $HERE > /dev/null
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

TOP_DIR=$(Gettop)

function Croot()
{
    if [ "$TOP_DIR" ]; then
        cd $TOP_DIR
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}

# $1: path to the file that need to be installed into the system/bin
function is_the_system_bin_file()
{
    local dir_bin=`dirname $1`
    local tmp_str=`basename $dir_bin`
    if [ ! $tmp_str = "bin" ];then
        echo "it's not a bin file!"
        return 1
    fi

    tmp_str=`dirname $dir_bin`
    tmp_str=`basename $tmp_str`
    if [ ! $tmp_str = "system" ]; then
        echo "it's not in system dir!"
        return 1
    fi
    return 0
}

function mmm_current_module_and_install()
{
    local theFile=`mmm .|grep Install:|sed -e 's/Install: //'`
    if [ "X$theFile" = "X" ];then
        echo "maybe it's a compile error!"
        exit 100
    fi

    theFile=$TOP_DIR/$theFile
    if [ ! -f $theFile ]; then
        echo "the file $theFile doesn't exist!!"
        exit 100
    fi

    if ! is_the_system_bin_file $theFile; then
        echo "$theFile is not a system bin file!"
        exit 100
    fi
        
    if ! adb shell mount -t yaffs2 -o rw,remount mtd@system /system; then
        echo "remount /system with RW failed!"
        exit 100
    fi
        
    if adb push $theFile /system/bin; then
        echo "install: $theFile to '/system/bin' is ok!"
        local run_cmd="adb shell /system/bin/`basename $theFile`"
        echo "you can run this command:"
        echo ""
        echo "$run_cmd"
        echo ""
        echo ""
    fi
}


function my_mm()
{
    if [ "$TOP_DIR" ]; then
        cd $(Gettop)/build
        source ./envsetup.sh
        cd -
        mm $1
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}

function my_mmm()
{
    T=$(Gettop)
    if [ "$TOP_DIR" ]; then
        cd $(Gettop)/build
        source ./envsetup.sh
        cd -
        mmm_current_module_and_install
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}


my_mmm