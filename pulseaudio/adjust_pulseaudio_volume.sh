#!/bin/bash
#
# Adjusts the volume using 'pacmd' and 'pactl' (Pulseaudio).

MAX_VOLUME="0x10000"

if [ $# -eq 1 ]
then
	VOLUME_RELATIVE=$1

	# get current volumes
	SINK_VOLUME_OUTPUT=`pacmd dump | grep set-sink-volume`
	
	TMPFILE=`mktemp`
	
	pacmd dump | grep set-sink-volume > $TMPFILE
	
	while read SINK_VOLUME_LINE
	do
		SINK_NAME=`echo $SINK_VOLUME_LINE | awk '{ print $2 }'`
		SINK_VOLUME=`echo $SINK_VOLUME_LINE | awk '{ print $3 }'`
		NEW_VOLUME_SUM=$(( $SINK_VOLUME + $VOLUME_RELATIVE ))
		MAX_VOLUME_RELATIVE=$(( $MAX_VOLUME - $NEW_VOLUME_SUM ))

		 # sets new volume
		if [ $MAX_VOLUME_RELATIVE -ge 0 ]
		then
			pactl set-sink-volume "$SINK_NAME" $NEW_VOLUME_SUM
		else
			pactl set-sink-volume "$SINK_NAME" $MAX_VOLUME
		fi
	done < $TMPFILE
	
	rm $TMPFILE

	exit 0
else
	echo "Usage $0 VOLUME_RELATIVE"
	exit 1
fi
