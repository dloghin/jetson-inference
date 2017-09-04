#/bin/bash
#
# Added by Dumi Loghin - 4 Sep 2017
#

ARCH=`uname -m`
FEXT="done"
FDONELOCAL="daemon.end"
FDONEREMOTE="done.end"
FRESULTS="results.txt"
BDIR="jetson-inference/build/$ARCH/bin"
WDIR="mtests"
MODEL="googlenet"

cd $BDIR
mkdir -p $WDIR
rm -r $WDIR/*
echo "" > $WDIR/$FRESULTS

while true; do
	FILE=`ls $WDIR | grep jpg | head -n 1`
	if [ -f $WDIR/$FILE ] && [ -f $WDIR/$FILE.$FEXT ]; then
		(time ./imagenet-console $WDIR/$FILE -model $MODEL) &>> $WDIR/$FRESULTS
		rm $WDIR/$FILE
		rm $WDIR/$FILE.$FEXT
	elif [ -f $WDIR/$FDONEREMOTE ]; then
        	break
        fi
	#sleep 0.1
done
touch $WDIR/$FDONELOCAL 
echo "Daemon exit..."
