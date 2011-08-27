#!/bin/sh
################################################################
# file: android.common.sh
# author: Richard Luo
# date: 2011/01/15 06:36:01
################################################################


function copy_busybox()
{
    local bbox=system/bin/busybox

    if [ ! -x $bbox ]; then
        cp /tc/busybox $bbox
    fi
    
    if [ ! -x $bbox ]; then
        echo "no busybox"
        exit 100
    fi
}


# $1: command name like: sh, ls etc.
function link_busybox_shell()
{
    local sysdir=./system
    local bbox=$sysdir/bin/busybox
#    local bbox=$sysdir/bin/toolbox
    local cmd=$sysdir/bin/$1

    if [ ! -x $bbox ]; then
        echo "there is no busybox:$bbox!"
        exit 100
    fi

    if [ ! -x $cmd ]; then
        if [ ! -h $cmd ]; then
            echo "can not find file: $cmd"
        else
            echo "symlink already exists!"
            ls -l $cmd
            rm -f $cmd
        fi
    else
        mv $cmd $cmd.org
    fi

    # backup
    if cd $sysdir/bin && ln -fs busybox $1 && cd -; then
        echo "symlink busybox to $1 is ok!"
        ls -l $cmd $bbox
        return 0
    fi

    echo "failed to do symlink"
    exit 100
}


