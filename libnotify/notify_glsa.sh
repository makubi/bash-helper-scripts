#!/bin/bash
#
# This script
#	1. syncs the portage tree
#	2. checks all GLSA
#	3. sends a libnotify message via 'notify-send'
#		to inform the user about GLSA status
#
# You need to allow the execution of two commands using sudo
#	/usr/bin/emerge --sync --quiet
#	/usr/bin/glsa-check -t all
#
# -- e.g.
#	Cmnd_Alias	SYNC_PORTAGE = /usr/bin/nice -n $NICE_LVL /usr/bin/emerge --sync --quiet
#	Cmnd_Alias	CHECK_GLAS = /usr/bin/nice -n $NICE_LVL /usr/bin/glsa-check -t all
#	
#	myuser ALL=NOPASSWD: SYNC_PORTAGE_TREE
#	myuser ALL=NOPASSWD: CHECK_GLSAS

NICE_BIN=/usr/bin/nice
EMERGE_BIN=/usr/bin/emerge
NOTIFY_BIN=/usr/bin/notify-send
GLSA_BIN=/usr/bin/glsa-check

NICE_LVL=19
CHECK_OK_STRING="This system is not affected by any of the listed GLSAs"

# sync portage tree
sudo $NICE_BIN -n $NICE_LVL $EMERGE_BIN --sync --quiet


# check all GLSAs
GLSA_OUTPUT=`sudo $NICE_BIN -n $NICE_LVL $GLSA_BIN -t all 2>&1`

# inform user
if [ "$GLSA_OUTPUT" == "$CHECK_OK_STRING" ]
then
	$NOTIFY_BIN -u normal "GLSA check" "$GLSA_OUTPUT"
else
	$NOTIFY_BIN -u critical "GLSA check" "$GLSA_OUTPUT"
fi
