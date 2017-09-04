#/bin/bash

FEXT="done"
FDONELOCAL="daemon.end"
FDONEREMOTE="done.end"
FRESULTS="results.txt"
WDIR="mtests"
BDIR="../../build/$ARCH/bin"
MODEL="googlenet"

mkdir -p $WDIR
cd $WDIR

rm -f $FDONELOCAL
echo "" > $FRESULTS

while 1; do
	FILE=`ls | grep jpg | head -n 1`
	if [ -f $FILE ] && [ -f $FILE.$FEXT ]; then
		$BDIR/imagenet-console $FILE -model $MODEL &>> $FRESULTS
	fi
	rm $FILE
	rm $FILE.$FEXT
	if [ -f $FDONE ]; then
                break
        fi
	sleep 0.1
done
touch $FDONELOCAL 
echo "Daemon exit..."
exit
