#!/bin/bash
#
# Install needed software on Ubuntu 16.04
#
# Added by Dumi Loghin - 14 Sep 2017
#
#########################################
# Detect OS
OS=`lsb_release -a | grep "Distributor ID" | cut -d ':' -f 2 | tr -d '\t '`
VS=`lsb_release -a | grep "Release" | cut -d ':' -f 2 | tr -d '\t '`
if [ $OS != "Ubuntu" ]; then
	echo "Only Ubuntu OS is supported!"
	exit
fi
if [ $VS != "16.04" ]; then
	echo "Only Ubuntu 16.04 is supported!"
	exit
fi
# Run as superuser
if [ $UID -ne 0 ]; then
	echo "Please run this script as root!"
	exit
fi
exit
dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
dpkg -i libcudnn7_7.0.1.13-1+cuda8.0_amd64.deb
dpkg -i libcudnn7-dev_7.0.1.13-1+cuda8.0_amd64.deb
dpkg -i nv-gie-repo-ubuntu1604-cuda8.0-trt2.1-20170614_1-1_amd64.deb
apt-get update
apt-get install cuda tensorrt-2.1.2
