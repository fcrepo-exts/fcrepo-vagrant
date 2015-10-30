#!/bin/sh

# Creates objects in the repository and loads them with unique datastreams.
# The number of backups in defined in $OBJ and the size of the datastream is defined in $DSZ.

BASE=http://localhost:8080/fcrepo/rest/test
BATCH=$RANDOM

# Number of objects to load
OBJ=30
# Datastream Size
DSZ=$(( 1024 * 1024 * 1 )) # 1 MB

if [ ! -d tmp ]; then
	mkdir tmp
fi
mkdir tmp/$BATCH

# Generate Datastreams
N=0
echo `date +%T` "$BATCH: generating $OBJ datastreams"
START=`date +%s`
while [ $N -lt $OBJ ]; do
	N=$(( $N + 1 ))
	if [ ! -f tmp/$BATCH/$N ]; then
		openssl rand -base64 $DSZ > tmp/$BATCH/$N
	fi
done
END=`date +%s`
echo `date +%T` "$BATCH: done in" $(( $END - $START )) "seconds"

# Signal parent process to notify completion of generation phase
kill -USR1 $PPID

# Create objects and load generated datastreams
N=0
echo "$BATCH:" `date +%T` "creating $OBJ datastreams"
START=`date +%s`
while [ $N -lt $OBJ ]; do
	N=$(( $N + 1 ))
	if [ $(( $N % 10 )) = 0 ]; then
		echo "$BATCH: ." 
	fi
	curl -u fedoraAdmin:secret3 -s -X PUT $BASE/$BATCH/$N?mixin=fedora:object > /dev/null
	curl -u fedoraAdmin:secret3 -s -H "Content-Type: text/plain" -X PUT -T tmp/$BATCH/$N $BASE/$BATCH/$N/ds1 > /dev/null
done
echo
END=`date +%s`
echo `date +%T` "$BATCH: done in" $(( $END - $START )) "seconds"

# Remove temporary files
rm -rf tmp/$BATCH

# Delete cURL for the current batch
N=0
echo `date +%T` "$BATCH: appending curl command to delete batch: $BATCH"
file_path=`pwd`/batch-delete-commands.sh
echo "curl -u fedoraAdmin:secret3 -s -X DELETE $BASE/$BATCH" >> $file_path 
