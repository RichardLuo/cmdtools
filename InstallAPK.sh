#!/bin/sh
################################################################
# file: nfsinst.sh
# author: Richard Luo
# date: 2010/04/27 05:07:40
################################################################

################################################################
# am start -a android.intent.action.MAIN -n com.android.mediaframeworktest/com.android.mediaframeworktest.MediaFrameworkTest
###########################################################################################################################

InstallAPK2Device()
{
    if ls ./bin/*-debug.apk; then
        APK=`ls ./bin/*-debug.apk`
        if adb install ${APK} 2>&1 | grep INSTALL_FAILED_ALREADY_EXISTS; then
            adb reinstall ${APK}
            echo "reinstall ${APK} to device ok"
        else
            echo "seems install ${APK} is OK"
        fi
    else
        echo "there is no APK file"
    fi
}

InstallAPK2Device