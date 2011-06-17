#!/bin/sh
################################################################
# file: DebugDroidCrashSymbol.sh
# author: Richard Luo
# date: 2011/01/21 08:39:29
################################################################

set -ix

crash_input=crash.log

# if [ -f $1 ]; then
#     crash_input=$1
# fi

if [ ! -f $crash_input ]; then
    echo "crash_input: $crash_input, doesn't exist!"
    exit 100
fi

tmp_bash=/tmp/logcat.agdb.symbol.sh

echo "cat $crash_input |perl -p -e 's/.*pc\s+(\w+)\s+\/system\/\w+\/(.*)/agdb.py -C -r \1 -e \2/'>$tmp_bash"
cat $crash_input |perl -p -e 's/.*pc\s+(\w+)\s+\/system\/\w+\/(.*)/agdb.py -C -r \1 -e \2/'>$tmp_bash

bash $tmp_bash
