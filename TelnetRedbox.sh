# !/usr/bin/bash
set -ix

if [ "X$1" = "X" ]; then
    echo "missed ip address"
fi

IP=$1
LOGFILE=red-box-$(date +%Y%m%d-%H%S).log
LINKFILE=red-box.log

touch /home/richard/ddbs/frameworks/logs/$LOGFILE 
ln -fs /home/richard/ddbs/frameworks/logs/$LOGFILE /home/richard/ddbs/frameworks/$LINKFILE
telnet $IP 4900 | ts 2>&1 | tee /home/richard/ddbs/frameworks/logs/$LOGFILE
