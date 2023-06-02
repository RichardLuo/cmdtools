#! /bin/bash

valgrind -v --show-reachable=yes --tool=memcheck --leak-check=yes --log-file=ns4.leak $1  
