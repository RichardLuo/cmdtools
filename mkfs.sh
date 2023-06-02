#!/bin/bash

set -ix

PWD=`pwd`

echo $PWD
ROOTFS_DIR=./root/

RAMDISK_BLOCK=7000

#./addfiles.sh

umount initrd
rm -f initrd.gz initrd
dd if=/dev/zero of=initrd bs=1k count=${RAMDISK_BLOCK}

echo -n "y" > tmp_y

/sbin/mke2fs -q -m 0 -b 1024 -N 500 initrd < tmp_y
/sbin/tune2fs -m 0 -c 10000 initrd

mkdir -p mnt_tmp
mount -o loop initrd mnt_tmp
cp -a $ROOTFS_DIR/* mnt_tmp/
cp -f  ./default_config mnt_tmp/etc/

umount mnt_tmp/
imageName=vmlinuz.english.$1.bin
gzip initrd
cp -f ./initrd.gz /var/www/html/richard/initrd.$1.gz							
cp ./initrd.gz ../DH_Kernel/linux-ADM8668-2.4.20/arch/mips/ramdisk/ramdisk_el.gz

(cd ../DH_Kernel/linux-ADM8668-2.4.20;											\
	rm -f vmlin* arch/mips/ramdisk/ramdisk.o;									\
	make zImage;																\
	ls -l vmlinuz;																\
)




