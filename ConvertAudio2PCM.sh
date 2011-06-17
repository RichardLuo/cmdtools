#!/bin/sh
################################################################
# file: ConvertAudio2PCM.sh
# author: Richard Luo
# date: 2011/01/16 06:04:03
################################################################

inputfile=$1

if [ ! -f $inputfile ]; then
    echo "please specify the input audio file"
    exit 100
fi

outputfile=out.pcm

if [ ! "X$2" = "X" ]; then
    outputfile=$2
fi

mplayer -ao pcm $inputfile -ao pcm:file="$outputfile"
