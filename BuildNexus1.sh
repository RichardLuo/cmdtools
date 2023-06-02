#!/bin/bash
################################################################
# file: build_nexus_one.sh
# author: Richard Luo
# date: 2010/12/17 08:56:47
################################################################


export ANDROID_PRODUCT_OUT=out/target/product/htc/passion

. build/envsetup.sh

lunch full_passion-userdebug

cd device/htc/passion  &&  sh extract-files.sh

make -j4 showcommands


