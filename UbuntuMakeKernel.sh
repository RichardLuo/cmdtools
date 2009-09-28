#!/bin/sh
################################################################
# UbuntuMakeKernel.sh
# Richard Luo
# 2008-12-29
################################################################

cd /usr/src/linux

make-kpkg clean
fakeroot make-kpkg --initrd --append-to-version=-lando kernel_image kernel_headers
