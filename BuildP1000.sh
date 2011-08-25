#!/bin/sh
################################################################
# file: Ebuild.sh
# author: Richard Luo
# date: 2010/04/18 11:15:55
################################################################

## set -ix
# export TARGET_PRODUCT=full_crespo
export TARGET_PRODUCT=cyanogen_galaxytab
export TARGET_BUILD_VARIANT=eng

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

# $1: the input file path
function get_push_path()
{
    if echo $1 | grep -qE "/system/";then
        echo $1 | perl -pe 's/.*(\/system\/.*)/\1/'
    fi
}

# $1: the path to AndroidManifest.xml
function get_manifest_package_name()
{
    local package=`ParseAndroidManifest.pl < $1`
    echo $package
}

function is_apk_file()
{
    local apk_file=$1
    if ! echo $apk_file | grep -qE "apk$"; then
        echo "$apk_file is not apk file!"
        return 1
    fi

    if [ ! -f $apk_file ]; then
        echo "$apk_file doesn't exist!"
        return 1
    fi
    return 0
}

# $1: input file name
function is_exe_or_so_file()
{
    local exe_so_file=$1

    if [ ! -f $exe_so_file ]; then
        echo "$exe_so_file doesn't exist!"
        return 1
    fi

    if echo $exe_so_file | grep -qE "\.so$"; then
        echo "$exe_so_file is a .so file!"
        return 0
    else
        if [ -x $exe_so_file ]; then
            echo "$exe_so_file is a executable file!"
            return 0
        fi
    fi

    echo "$exe_so_file is not a executable or so file"
    return 1
}

# $1: the file need to be installed
function install_droid_apk()
{
    local apk_file=$1
    if ! is_apk_file $apk_file; then
        exit 198
    fi

    local package=$(get_manifest_package_name ./AndroidManifest.xml)

    echo "try uninstall $package"
    adb uninstall $package

    if ! adb install $apk_file; then
        echo "failed to install $package"
        exit 198
    fi

    echo "adb install $apk_file ok!"
}

# $1: the file need to be installed
function install_droid_exe_or_so_file()
{
    local theFile=$1
    if [ "$1X" = "X" ]; then
        echo "null input file!"
        exit 99
    fi

    local dstPushPath=$(get_push_path $theFile)
    if [ "X$dstPushPath" = "X" ]; then
        if echo $theFile | grep -qE "linux-x86"; then
            echo "$theFile is belong to local host on x86"
            exit 0
        else
            echo "$theFile is not a file in system dir!"
            exit 1
        fi
    fi
    
    if ! adb remount; then
        echo "remount /system with RW failed!"
        exit 100
    fi

    if adb push $theFile $dstPushPath>/dev/null 2>&1; then
#       printf "\n\nadb push $theFile $dstPushPath\nit's ok! \n\n"
        if echo "$dstPushPath" | grep -qE '/system/bin/'; then
            local run_cmd="adb shell /system/bin/`basename $theFile`"
            echo "you want the cmd:"
            printf "\n$run_cmd\n\n"
        else
            echo ""
            echo ""
            echo "[`basename $theFile`] has been pushed ok!"
            echo ""
            echo ""
        fi
    else
        echo "Failed: adb push $theFile $dstPushPath"
        exit 123
    fi 
    return 0
}


function install_droid_module()
{
    local theFile=$1
    if [ "X$theFile" = "X" ];then
        echo "maybe it's a compile error!"
        exit 100
    fi

    theFile=$TOP_DIR/$theFile
    if [ ! -f $theFile ]; then
        echo "the file $theFile doesn't exist!!"
        exit 100
    fi

    if is_apk_file $theFile;then
        install_droid_apk $theFile;
        return 0
    fi

    if is_exe_or_so_file $theFile; then
        install_droid_exe_or_so_file $theFile
        return 0
    fi

    echo "UNKNOW file: $theFile"
    exit 89
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

        if ! mmm . showcommands|grep Install:|sed -e 's/Install: //'>/tmp/EBuild.txt; then
            echo "build error, pleas check it!"
            exit 10
        else
            while read line
            do
                install_droid_module $line
            done </tmp/EBuild.txt
        fi
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}


my_mmm