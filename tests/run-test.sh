#/bin/bash

ARCH=`uname -m`
IMG_LIST=`ls | grep image`
TESTS_DIR=`pwd`
BIN_DIR="../build/$ARCH/bin"

cd $BIN_DIR

echo "Using googlenet..."
for IMG in $IMG_LIST; do
	cp $TESTS_DIR/$IMG .
	time ./imagenet-console $IMG -model googlenet 2&> tmp
	cat tmp | grep "result"
done
echo "Using alexnet..."
for IMG in $IMG_LIST; do
        cp $TESTS_DIR/$IMG .
        time ./imagenet-console $IMG -model alexnet 2&> tmp
        cat tmp | grep "result"
done
	
