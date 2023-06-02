#!/bin/bash
################################################################
# file:   FileReplaceRegex.sh
# author: Richard Luo
# date:   2016-06-25 11:27:26
################################################################
if [ "X$1" = "X" ]; then
    echo "please specify the file name!"
    exit 10
fi

FILE=$1

if [ ! -f $FILE ]; then 
    echo "$FILE doesn't exist!"
    exit 10
fi

set -ix
perl -p -i -e 's/\bint8u\b/uint8_t/g'   $FILE
perl -p -i -e 's/\bint16u\b/uint16_t/g' $FILE
perl -p -i -e 's/\bint32u\b/uint32_t/g' $FILE

perl -p -i -e 's/\bint8s\b/int8_t/g'   $FILE
perl -p -i -e 's/\bint16s\b/int16_t/g' $FILE
perl -p -i -e 's/\bint32s\b/int32_t/g' $FILE

perl -p -i -e 's/\bboolean\b/bool/g' $FILE
perl -p -i -e 's/\bTRUE\b/true/g' $FILE
perl -p -i -e 's/\bFALSE\b/false/g' $FILE

perl -p -i -e 's/\bemberAfPluginKeypressEffectRegisterMultiPress\b/emberAfPluginKeypressEffectRegister/g' $FILE




