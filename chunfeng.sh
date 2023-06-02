#!/bin/bash

lan_port=eth0
wan_port=eth1

wlan_ip=192.168.1.22
gateway=192.168.1.254

ifconfig ${lan_port} 0.0.0.0 down
ifconfig ${wan_port} 0.0.0.0 down
sleep 1
ifconfig ${wan_port} 0.0.0.0 up
iwconfig ${wan_port} mode managed
iwconfig ${wan_port} essid emacs 
iwconfig ${wan_port} key 1029384756 [1]
ifconfig ${wan_port} ${wlan_ip} netmask 255.255.255.0
route add default gw ${gateway}
rm -f /etc/resolv.conf
ln -fs /etc/resolv.conf.home /etc/resolv.conf



