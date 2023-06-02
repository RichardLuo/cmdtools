#!/bin/bash
################################################################
# file:   Name.sh
# author: Richard Luo
# date:   2012-02-19 12:43:20
################################################################

perl -p -i -e 's/\bbyte\b/uint8_t/g'    $1
perl -p -i -e 's/\buint8\b/uint8_t/g'   $1
perl -p -i -e 's/\buint16\b/uint16_t/g' $1
perl -p -i -e 's/\buint32\b/uint32_t/g' $1


perl -p -i -e 's/\bint8\b/int8_t/g'   $1
perl -p -i -e 's/\bint16\b/int16_t/g' $1
perl -p -i -e 's/\bint32\b/int32_t/g' $1

