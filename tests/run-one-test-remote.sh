#/bin/bash

if [ $# -lt 5 ]; then
	echo "Usage: $0 <user> <host> <working_path> <image> <model> [<key>]"
	exit 1
fi

USER=$1
HOST=$2
WDIR=$3
IMG=$4
MODEL=$5
if [ $# -gt 5 ]; then
KEY=$6
# we have a key
scp -i "$KEY" $IMG $USER'@'$HOST':'$WDIR
ssh -i "$KEY" $USER'@'$HOST << EOF
 cd $WDIR
 ./imagenet-console $IMG -model $MODEL &> tmp
EOF
scp -i "$KEY" $USER'@'$HOST':'$WDIR/tmp .
else
scp $IMG $USER'@'$HOST':'$WDIR
ssh $USER'@'$HOST << EOF
 cd $WDIR
 ./imagenet-console $IMG -model $MODEL &> tmp
EOF
scp $USER'@'$HOST':'$WDIR/tmp . 
fi	
