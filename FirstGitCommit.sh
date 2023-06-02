#!/bin/bash
################################################################
# file:   FirstGitCommit.sh
# author: Richard Luo
# date:   2012-04-18 10:33:48
################################################################

if [ -d .git ]; then
    echo ".git already exist, please confirm it!";
    exit 10;
fi

if git init && git add . && git commit -m'first commit' .; then
    echo "================================================================";
    echo "                setup git ok!";
    echo "================================================================";
fi


