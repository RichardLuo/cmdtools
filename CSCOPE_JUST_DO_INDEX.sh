#!/bin/sh
################################################################
# file: CSCOPE_JUST_DO_INDEX.sh
# author: Richard Luo
# date: 2011/01/05 09:09:31
################################################################

LIST_FILE=cscope.files
DATABASE_FILE=cscope.out

if [ ! -f $LIST_FILE ]; then
    echo "there is no list file: $LIST_FILE"
    exit 100
fi

echo "cscope -b -i $LIST_FILE -f $DATABASE_FILE"
cscope -b -i $LIST_FILE -f $DATABASE_FILE

