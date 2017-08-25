#/bin/bash

if [ $# -lt 2 ]; then
	echo "Usage: $0 <user> <host_ip>"
	exit 1
fi

USER=$1
HOST=$2
ARCH="x86_64"
WDIR="jetson-inference/build/$ARCH/bin"
IMG_LIST=`ls | grep image`
MODEL_LIST="googlenet alexnet"

for MODEL in $MODEL_LIST; do
	echo ""
	echo "Using $MODEL..."
	echo ""
	for IMG in $IMG_LIST; do
		(time ./run-one-test-remote.sh $USER $HOST $WDIR $IMG $MODEL) &> tmp  
		cat tmp | grep "result"
		cat tmp | grep "real"
	done
done	
