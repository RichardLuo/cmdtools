#!/bin/bash
################################################################
# homeip.sh
# Richard Luo
# 2009-09-05
################################################################

sudo myeth0.sh
sudo dhclient eth0
sudo route del default gw 159.99.249.1
ping google.cn
