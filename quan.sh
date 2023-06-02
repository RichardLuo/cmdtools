#! /bin/bash

set -ix

ifconfig eth0 down
ifconfig eth0 59.60.28.227 netmask 255.255.255.224
route add default gw 59.60.28.225

/etc/init.d/portmap start
/etc/init.d/nfs start
