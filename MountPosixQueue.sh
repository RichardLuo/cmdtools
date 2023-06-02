#!/bin/bash
################################################################
# MountPosixQueue.sh
# Richard Luo
# 2008-11-11
################################################################

sudo mkdir -p /dev/mqueue
sudo mount -t mqueue none /dev/mqueue

