#! /bin/bash



valgrind --max-stackframe=2104916 --show-reachable=yes --tool=memcheck --leak-check=yes --log-file=$1.leak $1

