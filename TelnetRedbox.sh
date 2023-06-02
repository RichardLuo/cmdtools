# !/usr/bin/bash
# set -ix

if [ "X$1" = "X" ]; then
    echo "missed ip address"
else
    IP=$1
    LOGFILE=red-box-$IP-$(date +%Y%m%d-%H%S).log
    LINKFILE=red-box.log
    touch /home/richard/ddbs/frameworks/logs/$LOGFILE 
    rm -f /home/richard/$LINKFILE
    ln -fs /home/richard/ddbs/frameworks/logs/$LOGFILE /home/richard/$LINKFILE
    telnet $IP 4900 | ts 2>&1 | tee /home/richard/ddbs/frameworks/logs/$LOGFILE
fi

