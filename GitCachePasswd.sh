#!/bin/bash
################################################################
# file:   GitCachePasswd.sh
# author: Richard Luo
# date:   2015-03-16 22:35:34
################################################################

git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'

