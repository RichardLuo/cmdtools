#!/bin/bash
################################################################
# file:   Name.sh
# author: Richard Luo
# date:   2012-02-19 12:43:20
################################################################

perl -p -i -e 's/NAMESPACE_START\((\w+)\).*/namespace $1 \{/g' $1
perl -p -i -e 's/NAMESPACE_END\((\w+)\).*/} \/\/ end of namespace $1/g' $1
