#!/bin/sh

find -name "*.cpp" -or -name "*.hpp" -or -name "*.[ch]"|etags -
