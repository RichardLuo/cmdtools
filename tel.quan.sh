#! /bin/sh

ifconfig eth0 59.60.28.227 netmask 255.255.255.224
route add default gw 59.60.28.225

/etc/init.d/portmap restart
/etc/init.d/nfs restart

