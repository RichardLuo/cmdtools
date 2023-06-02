#!/bin/bash
################################################################
# file:   FromDos.sh
# author: Richard Luo
# date:   2012-07-25 11:40:08
################################################################

find -name '*.cpp' -exec fromdos {} \;
find -name 'Makefile' -exec fromdos {} \;
find -name '*.c' -exec fromdos {} \;
find -name '*.h' -exec fromdos {} \;
