#!/bin/sh
################################################################
# file: EmulatorGinger.sh
# author: Richard Luo
# date: 2010/12/28 12:32:09
################################################################

sysdir=/home/richard/awareness/out/target/product/generic
## avd=Kitty03
avd=Awareness
partition_size_M=256

emulator \
    -system ${sysdir}/system.img           \
    -datadir ${sysdir}                     \
    -avd ${avd}                            \
    -kernel /home/richard/msrc/kernel/droidKernel/arch/arm/boot/zImage \
    -partition-size ${partition_size_M} &


