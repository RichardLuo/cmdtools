#!/bin/sh
################################################################
# query_dyn_lib.sh
# Richard Luo
# 2008-08-08
################################################################

objdump -x ./$1 | grep NEED
