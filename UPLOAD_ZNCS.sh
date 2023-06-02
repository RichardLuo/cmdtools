#!/bin/bash
################################################################
# file:   UPLOAD_ZNCS.sh
# author: Richard Luo
# date:   2016-05-14 10:53:20
################################################################

# set -ix

# path_sys=/home/richard/ddbs/out/host/linux-x86/pr/sim/system
path_sys=/home/richard/lively/out/target/product/beagleboneblack/system
path_pack=/home/richard/lively/zncs/
path_zncs=$path_sys/bin/zncs 

if [ ! -f $path_zncs ]; then
    echo "no zncs exe file $path_zncs"
    exit 1
fi

TIME_STAMP=$(date +%Y%m%d-%H%S)

ZNCS_PACKAGE_NAME=zncs-$TIME_STAMP.tgz
ZNCS_PACKAGE=$path_pack/$ZNCS_PACKAGE_NAME

# (cd $path_sys/.. && tar zcf zncs.tgz system/ && sudo cp zncs.tgz $ZNCS_PACKAGE && cd $path_pack && ln -fs $ZNCS_PACKAGE_NAME zncs.tgz && ls -l )

(cd $path_sys/.. &&                     \
     tar zcf zncs.tgz system/ &&        \
     cp zncs.tgz $ZNCS_PACKAGE &&  \
     ossclient.py --overwrite ${ZNCS_PACKAGE} io-xiaoyan-release-bucket-root/zncs/${ZNCS_PACKAGE_NAME} )



# IP=192.168.2.155:8800
# echo "wget http://$IP/zncs-$TIME_STAMP.tgz"
# echo "wget http://$IP/zncs-$TIME_STAMP.tgz"
# echo "wget http://$IP/zncs-$TIME_STAMP.tgz"
# echo "wget http://$IP/zncs-$TIME_STAMP.tgz"

