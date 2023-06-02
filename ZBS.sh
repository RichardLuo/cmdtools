#!/bin/sh
################################################################
# file:   EEE.sh
# author: Richard Luo
# date:   2016-07-14 17:49:34
################################################################

usage() { 
    echo "Usage: $0 [-s] [-p <number>]" 1>&2; 
    echo "                          -d" 1>&2; 
    echo "                          -r: connect to the remote socat" 1>&2; 
    echo "                          -s: run as a zigbee service simulator" 1>&2; 
    echo "                          -p <number>: it uses the /dev/ttyUSB<number> as the uart port" 1>&2; 
    exit 1; 
}

REMOTE="false"
DAEMON="false"
SIMULATOR="false"
PORT="/dev/ttyUSB0"

while getopts "dhrsp:" o; do
    case "${o}" in
        s)
            SIMULATOR="true"
            ;;
        r)
            REMOTE="true"
            ;;
        d)
            DAEMON="true"
            echo "DAEMON IS TRUE"
            ;;
        p)
            p=${OPTARG}
            ((0 <= p && p <= 10)) || usage
            PORT="/dev/ttyUSB$p"
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

# export ANDROID_PRINTF_LOG="time"
export ANDROID_PRINTF_LOG="thread"

set -ix

if [ $SIMULATOR = "true" ]; then
    logfile=zbs-simulator-$(date +%Y%m%d-%H%S).log
    linkfile=zbs-simulator.log
    touch /home/richard/ddbs/frameworks/logs/$logfile 
    ln -fs /home/richard/ddbs/frameworks/logs/$logfile /home/richard/ddbs/frameworks/$linkfile
    # ~/ddbs/out/host/linux-x86/pr/sim/system/bin/zbs -P "@simul" -s 2>&1 | tee /home/richard/ddbs/frameworks/logs/$logfile
    ~/ddbs/out/host/linux-x86/pr/sim/system/bin/zbs -s 2>&1 | tee /home/richard/ddbs/frameworks/logs/$logfile
elif [ $REMOTE = "true" ]; then
    logfile=zbs$(date +%Y%m%d-%H%S).log
    linkfile=zbs-remote.log
    touch /home/richard/ddbs/frameworks/logs/$logfile 
    ln -fs /home/richard/ddbs/frameworks/logs/$logfile /home/richard/ddbs/frameworks/$linkfile
    ~/ddbs/out/host/linux-x86/pr/sim/system/bin/zbs -p /dev/pts/13 2>&1 | tee /home/richard/ddbs/frameworks/logs/$logfile
elif [ -c $PORT ]; then
    logfile=zbs$(date +%Y%m%d-%H%S).log
    linkfile=zbs.log
    touch /home/richard/ddbs/frameworks/logs/$logfile 
    ln -fs /home/richard/ddbs/frameworks/logs/$logfile /home/richard/ddbs/frameworks/$linkfile
    if [ $DAEMON = "true" ]; then
        ~/ddbs/out/host/linux-x86/pr/sim/system/bin/zbs -p $PORT -d 2>&1 | tee /home/richard/ddbs/frameworks/logs/$logfile
    else
        valgrind --log-file=$logfile.valgrind --tool=memcheck --leak-check=full \
                 ~/ddbs/out/host/linux-x86/pr/sim/system/bin/zbs -p $PORT 2>&1 | tee /home/richard/ddbs/frameworks/logs/$logfile
    fi
else
    echo "ERROR: [$PORT] is not a device file"
    usage
fi

