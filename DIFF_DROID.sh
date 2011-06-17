#!/bin/sh
################################################################
# file: DIFF_DROID.sh
# author: Richard Luo
# date: 2011/01/16 10:35:57
################################################################

v210_droid=$HOME/samsung_droid/210droid
gbread=$HOME/gbread
gdroid=$HOME/gdroid

if [ ! -f $gdroid/$1 ]; then
    echo "$gdroid/$1 doesn't exist!"
    exit 100
fi

if [ ! -f $v210_droid/$1 ]; then
    echo "$v210_droid/$1 doesn't exist!"
    exit 100
fi

# echo "diff -w -B -N -C 4 -c $v210_droid/$1 $gdroid/$1"
diff -w -B -N -C 4 $v210_droid/$1 $gdroid/$1


