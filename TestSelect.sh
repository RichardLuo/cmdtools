#!/bin/bash
################################################################
# kk.sh
# Richard Luo
# 2009-02-13
################################################################
$?

OPTIONS="Hello Quit"
select opt in $OPTIONS; do
if [ "$opt" = "Quit" ]; then
    echo done
    exit
elif [ "$opt" = "Hello" ]; then
    echo Hello World
else
    clear
    echo bad option
fi
done 
