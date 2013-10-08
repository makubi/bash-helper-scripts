#!/bin/bash

KERNEL_DIR="/boot"

CURRENT_KERNEL_LINK="${KERNEL_DIR}/kernel-gentoo-current"
PREVIOUS_KERNEL_LINK="${KERNEL_DIR}/kernel-gentoo-previous"
if [ $# -ne 1 ] || [ ! -f "${KERNEL_DIR}/$1" ]
then
	echo
	echo "Error: You must provide one of the following kernels as argument:"
	echo
	find $KERNEL_DIR -maxdepth 1 -type f -name 'kernel-*' -printf "%f\n" | sort
	exit 1
fi

echo "Setting $PREVIOUS_KERNEL_LINK to "`readlink $CURRENT_KERNEL_LINK`"..."
ln -sf `readlink $CURRENT_KERNEL_LINK` $PREVIOUS_KERNEL_LINK

echo "Setting $CURRENT_KERNEL_LINK to ${KERNEL_DIR}/$1..."
ln -sf "${KERNEL_DIR}/$1" $CURRENT_KERNEL_LINK
