#!/bin/bash

if [ $# -eq 1 ]
then
	VOLUME_RELATIVE=$1
	SINK_VOLUME_OUTPUT=`pacmd dump | grep set-sink-volume`
	
	TMPFILE=`mktemp`
	
	pacmd dump | grep set-sink-volume > $TMPFILE
	
	while read SINK_VOLUME_LINE
	do
		SINK_NAME=`echo $SINK_VOLUME_LINE | awk '{ print $2 }'`
		SINK_VOLUME=`echo $SINK_VOLUME_LINE | awk '{ print $3 }'`
		pactl set-sink-volume "$SINK_NAME" $(( $SINK_VOLUME + $VOLUME_RELATIVE ))
	done < $TMPFILE
	
	rm $TMPFILE

	exit 0
else
	echo "Usage ./$0 VOLUME_RELATIVE"
	exit 1
fi
