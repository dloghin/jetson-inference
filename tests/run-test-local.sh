#/bin/bash

ARCH=`uname -m`
IMG_LIST=`ls | grep image`
MODEL_LIST="googlenet alexnet"
TESTS_DIR=`pwd`
BIN_DIR="../build/$ARCH/bin"

cd $BIN_DIR

for MODEL in $MODEL_LIST; do
	echo ""
	echo "Using $MODEL..."
	echo ""
	for IMG in $IMG_LIST; do
		cp $TESTS_DIR/$IMG .
		(time ./imagenet-console $IMG -model $MODEL) &> tmp
		cat tmp | grep "result"
		cat tmp | grep "real"
	done
done	
