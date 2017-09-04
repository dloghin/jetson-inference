#/bin/bash

if [ $# -lt 2 ]; then
	echo "Usage: $0 <user> <host>"
	exit 1
fi

USER=$1
HOST=$2
ARCH="x86_64"
WDIR="jetson-inference/build/$ARCH/bin"
SDIR="jetson-inference/tests"
TDIR="$SDIR/mtests"
IMG_LIST=`ls | grep image`
MODEL_LIST="googlenet alexnet"
FEXT="done"
FDONELOCAL="done.end"
FDONEREMOTE="daemon.end"
FRESULTS="results.txt"

# start daemon
ssh $USER@$HOST '$SDIR/daemon.sh &'

t0=`date +%s`
# copy images one by one
for IMG in $IMG_LIST; do
	scp $IMG $USER@$HOST:$TDIR/
	touch $IMG.$EXT
	scp $IMG.$EXT $TDIR
	rm $IMG.$EXT
done
# signal done
touch $FDONELOCAL
scp $FDONELOCAL $USER@$HOST:$TDIR/
rm $FDONELOCAL
# wait for results
while 1; do
	scp "$USER@$HOST:$TDIR/$FDONEREMOTE" .
	if [ -f $FDONEREMOTE ]; then
		scp "$USER@$HOST:$TDIR/$FRESULTS" .
		break;
	fi
done
t1=`date +%s`
cat $FRESULTS | grep "result"
echo "Time: $(($t1-$t0))"
