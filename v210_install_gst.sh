#!/bin/bash
################################################################
# file: install_gst_lib.sh
# author: Richard Luo
# date: 2010/12/06 13:48:56
################################################################

# gst_libs="libglib-2.0.so libgmodule-2.0.so libgobject-2.0.so libgthread-2.0.so libgstreamer-0.10.so libgstcontroller-0.10.so"


gst_libs="libglib-2.0.so libgmodule-2.0.so libgobject-2.0.so libgstapp-0.10.so libgstaudio-0.10.so libgstbase-0.10.so libgstcontroller-0.10.so libgstdataprotocol-0.10.so libgstinterfaces-0.10.so libgstnet-0.10.so libgstpbutils-0.10.so libgstreamer-0.10.so libgstriff-0.10.so libgstrtp-0.10.so libgstrtsp-0.10.so libgsttag-0.10.so libgstvideo-0.10.so libgthread-2.0.so"

gst_tools="gst-inspect-0.10 gst-launch-0.10"

for l in ${gst_libs}; do
    if adb push lib/$l /system/lib;
        then
        echo "installed lib/$l ok!"
        else
        echo "failed to intall lib/$l!"
        exit 100
    fi
done

for t in ${gst_tools}; do
    if adb push bin/$t /system/bin/;
        then
        echo "installed bin/$t ok!"
        else
        echo "failed to intall bin/$t!"
        exit 100
    fi
done

# install plugins

# if adb shell mkdir /system/plugins;
# then
#     echo "mkdir /system/plugins ok!"
# else
#     echo "mkdir /system/plugins failed!"
#     exit 100
# fi

if adb push plugins/ /system/plugins;
then
    echo "install all plugins ok"
else
    echo "failed to install all plugins"
    exit 100
fi

    



