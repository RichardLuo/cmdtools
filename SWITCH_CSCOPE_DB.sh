#!/bin/sh
################################################################
# file: SWITCH_CSCOPE_DB.sh
# author: Richard Luo
# date: 2011/01/18 03:21:45
################################################################


db_dir=cscope.$1

if [ ! -d $db_dir ]; then
    echo "please specify the kind of db to switch: like: <ccc> <all>"
    exit 100
fi

if [ ! -f $db_dir/cscope.out ]; then
    echo "$db_dir/cscope.out doesn't exist!"
    exit 100
fi

rm -f cscope.out && ln -fs $db_dir/cscope.out .
echo "swiched to the: $db_dir/cscope.out"
ls -l cscope.out
