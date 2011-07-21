#!/bin/bash

sudo emerge --sync 2&>1 /dev/null

NOTIFY_BIN="/usr/bin/notify-send"
GLSA_OUTPUT=`sudo glsa-check -t all 2>&1`
CHECK_OK_STRING="This system is not affected by any of the listed GLSAs"

if [ "$GLSA_OUTPUT" == "$CHECK_OK_STRING" ]
then
	$NOTIFY_BIN -u normal "GLSA check" "$GLSA_OUTPUT"
else
	$NOTIFY_BIN -u critical "GLSA check" "$GLSA_OUTPUT"
fi
