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
KEY="dumi_aws_1.pem"
if ! [ -z "$KEY" ]; then
	SSHCMD="ssh -i "$KEY" $USER@$HOST"
	SCPCMD="scp -i "$KEY""
else
	SSHCMD="ssh $USER@$HOST"
	SCPCMD="scp"
fi
ARCH=`$SSHCMD "uname -m"`
BDIR="jetson-inference/build/$ARCH/bin"
SDIR="jetson-inference/tests"
TDIR="$BDIR/mtests"
IMG_LIST=`ls | grep image`
MODEL_LIST="googlenet alexnet"
FEXT="done"
FDONELOCAL="done.end"
FDONEREMOTE="daemon.end"
FRESULTS="results.txt"

echo "Remote arch: $ARCH"

# set -x

# rm old file
rm -f $FDONELOCAL
rm -f $FDONEREMOTE
rm -r $FRESULTS

# start daemon
$SSHCMD "$SDIR/daemon.sh" &

t0=`date +%s`
# copy images one by one
for IMG in $IMG_LIST; do
	$SCPCMD $IMG $USER@$HOST:$TDIR
	touch $IMG.$FEXT
	$SCPCMD $IMG.$FEXT $USER@$HOST:$TDIR
	rm $IMG.$FEXT
done
# signal done
touch $FDONELOCAL
$SCPCMD $FDONELOCAL $USER@$HOST:$TDIR
rm $FDONELOCAL
# wait for results
while true; do
	$SCPCMD "$USER@$HOST:$TDIR/$FDONEREMOTE" .
	if [ -f $FDONEREMOTE ]; then
		$SCPCMD "$USER@$HOST:$TDIR/$FRESULTS" .
		break
	fi
	sleep 0.1
done
t1=`date +%s`
cat $FRESULTS | grep "result"
cat $FRESULTS | grep "real"
echo "Time: $(($t1-$t0))"
wait
