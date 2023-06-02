#!/bin/bash

find -name "*.cpp" -or -name "*.hpp" -or -name "*.[ch]"|etags -
