#!/bin/sh
################################################################
# file:   UPLOAD_ZNCS.sh
# author: Richard Luo
# date:   2016-05-14 10:53:20
################################################################

# set -ix

path_sys=/home/richard/ddbs/out/host/linux-x86/pr/sim/system
path_zncs=$path_sys/bin/zncs 

if [ ! -f $path_zncs ]; then
    echo "no zncs exe file $path_zncs"
    exit 1
fi

TIME_STAMP=$(date +%Y%m%d-%H%S)

(cd $path_sys/.. && tar zcf zncs.tgz system/ && sudo cp zncs.tgz /var/www/zncs-$TIME_STAMP.tgz && cd /var/www && sudo ln -fs zncs-$TIME_STAMP.tgz zncs.tgz )
ls -l /var/www/zncs-$TIME_STAMP.tgz

echo "wget http://192.168.2.130/zncs-$TIME_STAMP.tgz"
echo "wget http://192.168.2.130/zncs-$TIME_STAMP.tgz"
echo "wget http://192.168.2.130/zncs-$TIME_STAMP.tgz"
echo "wget http://192.168.2.130/zncs-$TIME_STAMP.tgz"

