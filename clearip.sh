#!/bin/sh
################################################################
# clearip.sh
# Richard Luo
# 2009-04-23
################################################################

ip -4 addr flush label eth0
ip -4 addr flush label eth0:1
ip -4 addr flush label eth0:2
ip -4 addr flush label eth0:3
ip -4 addr flush label eth0:4


# ifconfig eth0 192.1.1.224 netmask 255.255.255.0
ifconfig eth0 172.22.0.224 netmask 255.255.0.0


