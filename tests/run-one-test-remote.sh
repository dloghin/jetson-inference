#/bin/bash

if [ $# -lt 5 ]; then
	echo "Usage: $0 <user> <host_ip> <working_path> <image> <model>"
	exit 1
fi

USER=$1
HOST=$2
WDIR=$3
IMG=$4
MODEL=$5

scp $IMG $USER'@'$HOST':'$WDIR
ssh $USER'@'$HOST << EOF
 cd $WDIR
 ./imagenet-console $IMG -model $MODEL &> tmp
 cat tmp | grep "result"
EOF 
	
