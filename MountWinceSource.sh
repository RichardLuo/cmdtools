#!/bin/sh
################################################################
# file: MountWinceSource.sh
# author: Richard Luo
# date: 2011/02/11 07:41:22
################################################################

host_ip=192.168.1.46

function mount_os_dir()
{
    local os_dir=proj/c100os

    mkdir -p $os_dir
    
    if sudo mount -t cifs -o username=richard //$host_ip/C100OS $os_dir; then
        echo "ok for mount_os_dir"
        return 0
    fi
    echo "failed to do: sudo mount -t cifs -o username=richard //$host_ip/C100OS $os_dir"
    exit 100
}


function mount_platform_dir()
{
    local platform_dir=wince600
    mkdir -p $platform_dir
    if sudo mount -t cifs -o username=richard //$host_ip/WINCE600 $platform_dir; then
        echo "ok for mount_platform_dir"
        return 0
    fi
    echo "failed to do: sudo mount -t cifs -o username=richard //$host_ip/WINCE600 $platform_dir"
    exit 100
}

mount_os_dir
mount_platform_dir
