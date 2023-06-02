#!/bin/bash
################################################################
# StartFirefox.sh
# Richard Luo
# 2009-03-13
################################################################



top_dir=/usr/lib
path_slink=$top_dir/firefox

if [ -z $1 ]; then
    version=3
else
    version=$1
fi

path_dir=$top_dir/firefox-$version.0        # default to firefox-3.0

if [ ! -d $path_dir ]; then
    echo "there is no dir: $path_dir"
    exit 100
fi

if [ -L $path_slink ]; then
    sudo rm -f  $path_slink
    sudo ln -fs $path_dir $path_slink
fi

if [ ! -L $path_slink ]; then
    echo "error!! there is no $path_slink"
    exit 100
fi

echo "ok for linking $path_slink"

if pgrep firefox; then
    pkill firefox
else
    echo "there is no running firefox? "
fi

firefox &

exit 0

