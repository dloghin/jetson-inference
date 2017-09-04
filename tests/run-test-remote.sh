#/bin/bash

if [ $# -lt 2 ]; then
	echo "Usage: $0 <user> <host>"
	exit 1
fi

USER=$1
HOST=$2
ARCH=`ssh $USER@$HOST "uname -m"`
WDIR="jetson-inference/build/$ARCH/bin"
IMG_LIST=`ls | grep image`
# MODEL_LIST="googlenet alexnet"
MODEL_LIST="googlenet"

t0=`date +%s`
for MODEL in $MODEL_LIST; do
	echo ""
	echo "Using $MODEL..."
	echo ""
	for IMG in $IMG_LIST; do
		(time ./run-one-test-remote.sh $USER $HOST $WDIR $IMG $MODEL) &> tmpt 
		cat tmp | grep "result"
		cat tmpt | grep "real"
	done
done
t1=`date +%s`
echo "Time: $(($t1-$t0))"
