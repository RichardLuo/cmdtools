#!/bin/sh
################################################################
# file: AGDBWrapper.sh
# author: Richard Luo
# date: 2011/01/22 05:37:30
################################################################


source ~/.droid

ANDROID_SRC_ROOT=$(Gettop)

if [ "X$ANDROID_SRC_ROOT" = "X" ]; then
    echo "failed to get ANDROID_SRC_ROOT"
    exit 100
fi


agdb.py "$@"

