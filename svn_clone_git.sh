#!/bin/bash
################################################################
# file: svn_clone_git.sh
# author: Richard Luo
# date: 2011/06/21 07:55:20
################################################################

# $1: svn url
# $2: author files
# $3: destnation dir
function git_clone_svn()
{
    if git svn clone $1 --no-metadata -A $2 -t tags -b branches -T trunk $3; then
        echo "git svn clone $1 is ok!!"
    else
        echo "#### failed!!"
    fi
}

git_clone_svn svn://192.168.11.11/H7000 authors-transform.txt git_h7000

# git svn clone svn://192.168.11.11/H7000/trunk/bsp/kernel/C100_kernel_RTM10 \
#     --no-metadata -A  --stdlayout ~/temp


