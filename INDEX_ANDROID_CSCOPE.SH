#!/bin/sh
################################################################
# file: IndexAndroid.sh
# author: Richard Luo
# date: 2010/12/18 14:07:32
################################################################

set -ix

dirs=bionic bootable build cts dalvik development frameworks hardware libcore ndk packages system vendor GstNDK

for d in $dirs; do
    if [ -d $d ]; then
        $valid_dirs="$d $valid_dirs"
    else
        echo "ignroed $d because it doesn' exit!"
    fi
done

Mcscope-indexer $valid_dirs
