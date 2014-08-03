#!/bin/sh
################################################################
# file:   AndroidCreateProject.sh
# author: Richard Luo
# date:   2014-02-13 23:14:52
################################################################

if [ "X$1" = "X" ]; then
    echo "please specify the project name!"
    return 0
fi

name=$1

android create project -n $name -t 11  -p ./$name -k com.xlive.examp -a $name
