#!/bin/bash
################################################################
# file: EmulatorGinger.sh
# author: Richard Luo
# date: 2010/12/28 12:32:09
################################################################

sysdir=/data/android-ics/out/target/product/generic
# avd=Kitty4.0
avd=ICS4
partition_size_M=256

         # -sdcard $HOME/scard.img                \


emulator -system ${sysdir}/system.img           \
         -datadir ${sysdir}                     \
         -avd ${avd}                            \
         -partition-size ${partition_size_M} &


