#!/bin/bash
################################################################
# file:   Kermit.sh
# author: Richard Luo
# date:   2012-05-17 13:27:53
################################################################

# kerm_cfg=$HOME/.kermrc
# for d in 0 1 2 3 4 5 6 7 8 9; do
#     if [ -c /dev/ttyUSB$d ]; then
#         perl -p -i -e "s/^set line .dev.ttyUSB.*/set line \/dev\/ttyUSB${d}/" $kerm_cfg
#         exec kermit
#         # cat $kerm_cfg
#     fi
# done

kermit 2>&1 | tee km.log
