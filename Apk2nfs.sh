#!/bin/sh
################################################################
# file: nfsinst.sh
# author: Richard Luo
# date: 2010/04/27 05:07:40
################################################################

################################################################
# am start -a android.intent.action.MAIN -n com.android.mediaframeworktest/com.android.mediaframeworktest.MediaFrameworkTest
###########################################################################################################################

ECLAIR_ROOT=${HOME}/H7000/trunk/bsp/android/eclair
ENFS_DIR=${HOME}/H7000/trunk/bsp/eclair_nfs/

install_apk()
{
    if ls ./bin/*-debug.apk; then
        APK=`ls ./bin/*-debug.apk`
        cp ${APK} ${ENFS_DIR}
        echo "install ${APK} to ${ENFS_DIR} ok"
    else
        echo "failed to install APK files"
    fi
}

# $1: src file path
# $2: dst file name
main_fun()
{
    if [ -z $1 ]; then
        install_apk
    elif [ -f $1 ]; then
        if cp $1 ${ENFS_DIR}/$2; then
            echo "install $1 to ${ENFS_DIR} ok"
        fi
    else
        echo "failed to install $1 to ${ENFS_DIR}"    
    fi
}

main_fun $1 $2