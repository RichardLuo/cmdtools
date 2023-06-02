#!/bin/bash
################################################################
# RecoverDeletedFile.sh
# Richard Luo
# 2008-11-17
################################################################

debugfs -f export /dev/sda6 |grep 2008|grep 'Nov 17' | awk '{print "dump <"$1"> "$1".del"}' > cmd
sleep 1
debugfs -f cmd /dev/sda6
