#!/bin/bash
################################################################
# Tretvalue.sh
# Richard Luo
# 2009-02-13
################################################################

set -e

# trap 'echo error' ERR       # Set ERR trap
# false                       # Non-zero exit status will be trapped
# insmod ak4_reader.ko
# (false)                     # Non-zero exit status within subshell will not be trapped
# (false) || false            # Solution: generate error yourself if subshell fails
# trap - ERR                  # Reset ERR trap

echo "$?, false: $false"

