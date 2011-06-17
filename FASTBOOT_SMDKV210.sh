#!/bin/sh
################################################################
# file: flash.sh
# author: Richard Luo
# date: 2011/01/14 10:57:58
################################################################

# if [ ! -f ramdisk-uboot.img ]; then
#     mkimage -A arm -O linux -T ramdisk -C none -a 0x30800000 -n "ramdisk" -d ramdisk.img ramdisk-uboot.img
# fi

mkimage -A arm -O linux -T ramdisk -C none -a 0x30800000 -n "ramdisk" -d ramdisk.img ramdisk-uboot.img || exit 100

fastboot flash ramdisk ramdisk-uboot.img
fastboot flash system system.img

uboot=/home/richard/msrc/CC210.droid/samsung_bsp/v210_froyo_Patch1.1_uboot/u-boot.bin
kernel=/home/richard/msrc/CC210.droid/samsung_bsp/v210_froyo_patch1.1_kernel/arch/arm/boot/zImage

# uboot=u-boot.bin
# kernel=zImage

# fastboot flash bootloader ${uboot} || exit 100
# fastboot flash kernel ${kernel} || exit 100

fastboot erase userdata || exit 100
fastboot erase cache || exit 100


