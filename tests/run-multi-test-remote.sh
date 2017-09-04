#/bin/bash
#
# Added by Dumi Loghin - 4 Sep 2017
#

if [ $# -lt 2 ]; then
	echo "Usage: $0 <user> <host>"
	exit 1
fi


USER=$1
HOST=$2
ARCH=`ssh $USER@$HOST "uname -m"`
BDIR="jetson-inference/build/$ARCH/bin"
SDIR="jetson-inference/tests"
TDIR="$BDIR/mtests"
IMG_LIST=`ls | grep image`
MODEL_LIST="googlenet alexnet"
FEXT="done"
FDONELOCAL="done.end"
FDONEREMOTE="daemon.end"
FRESULTS="results.txt"

# rm old file
rm -f $FDONELOCAL
rm -f $FDONEREMOTE
rm -r $FRESULTS

# start daemon
ssh $USER@$HOST "$SDIR/daemon.sh" &

t0=`date +%s`
# copy images one by one
for IMG in $IMG_LIST; do
	scp $IMG $USER@$HOST:$TDIR
	touch $IMG.$FEXT
	scp $IMG.$FEXT $USER@$HOST:$TDIR
	rm $IMG.$FEXT
done
# signal done
touch $FDONELOCAL
scp $FDONELOCAL $USER@$HOST:$TDIR
rm $FDONELOCAL
# wait for results
while true; do
	scp "$USER@$HOST:$TDIR/$FDONEREMOTE" .
	if [ -f $FDONEREMOTE ]; then
		scp "$USER@$HOST:$TDIR/$FRESULTS" .
		break
	fi
	sleep 0.1
done
t1=`date +%s`
cat $FRESULTS | grep "result"
cat $FRESULTS | grep "real"
echo "Time: $(($t1-$t0))"
wait
