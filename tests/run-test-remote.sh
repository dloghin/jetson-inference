#/bin/bash
#
# Run tests remotely on a given host
#
# Added by Dumi Loghin - 2017
#
if [ $# -lt 2 ]; then
	echo "Usage: $0 <user> <host> [<key>]"
	exit 1
fi

USER=$1
HOST=$2
if [ $# -eq 3 ]; then
	KEY=$3
else
	KEY=""
fi
if ! [ -z "$KEY" ]; then
	SSHCMD="ssh -i "$KEY" $USER@$HOST"
else
	SSHCMD="ssh $USER@$HOST"
fi
ARCH=`$SSHCMD "uname -m"`
WDIR="jetson-inference/build/$ARCH/bin"
IMG_LIST=`ls | grep image`
# MODEL_LIST="googlenet alexnet"
MODEL_LIST="googlenet"

echo "Remote arch: $ARCH"

t0=`date +%s`
for MODEL in $MODEL_LIST; do
	echo ""
	echo "Using $MODEL..."
	echo ""
	for IMG in $IMG_LIST; do
		(time ./run-one-test-remote.sh $USER $HOST $WDIR $IMG $MODEL $KEY) &> tmpt 
		cat tmp | grep "result"
		cat tmpt | grep "real"
	done
done
t1=`date +%s`
echo "Time: $(($t1-$t0))"
