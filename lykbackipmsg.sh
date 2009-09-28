#! /bin/sh
Date=`date +%Y%m%d%S`
tar zcvf  ./ipmsg.log.kk$Date.tgz ~/msg/ipmsg.log
mv ./ipmsg.log.kk*.tgz /other/backup

IpmsgFilter.pl ~/msg/ipmsg.log > /other/backup/key-$Date.log