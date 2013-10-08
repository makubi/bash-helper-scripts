#!/bin/bash
#
# /boot/grub/grub.conf
# --------------------
#
# title Gentoo Linux current
# root (hd0,0)
# kernel /boot/kernel-gentoo-current root=/dev/sda1
# savedefault
# 
# title Gentoo Linux current (rescue)
# root (hd0,0)
# kernel /boot/kernel-gentoo-current root=/dev/sda1 init=/bin/bb
#
# title Gentoo Linux previous
# root (hd0,0)
# kernel /boot/kernel-gentoo-previous root=/dev/sda1
# savedefault
#
# title Gentoo Linux previous (rescue)
# root (hd0,0)
# kernel /boot/kernel-gentoo-previous root=/dev/sda1 init=/bin/bb


KERNEL_DIR="/boot"

CURRENT_KERNEL_LINK="${KERNEL_DIR}/kernel-gentoo-current"
PREVIOUS_KERNEL_LINK="${KERNEL_DIR}/kernel-gentoo-previous"

NEW_KERNEL_PATH="${KERNEL_DIR}/$1"

if [ $# -ne 1 ]
then
	echo
	echo "Error: You must provide one of the following kernels as argument:"
	echo
	find $KERNEL_DIR -maxdepth 1 -type f -name 'kernel-*' -printf "%f\n" | sort
	exit 1
fi

if [ ! -f "$NEW_KERNEL_PATH" ]
then
	NEW_KERNEL_PATH="${KERNEL_DIR}/kernel-$1"
fi

echo "trying $NEW_KERNEL_PATH"

if [ ! -f "$NEW_KERNEL_PATH" ]
then
	NEW_KERNEL_PATH="${NEW_KERNEL_PATH}-gentoo"
fi

echo "trying $NEW_KERNEL_PATH"

if [ ! -f "$NEW_KERNEL_PATH" ]
then
	echo
	echo "Error: You must provide one of the following kernels as argument:"
	echo
	find $KERNEL_DIR -maxdepth 1 -type f -name 'kernel-*' -printf "%f\n" | sort
	exit 1
fi

echo "Setting $PREVIOUS_KERNEL_LINK to "`readlink $CURRENT_KERNEL_LINK`"..."
ln -sf `readlink $CURRENT_KERNEL_LINK` $PREVIOUS_KERNEL_LINK

echo "Setting $CURRENT_KERNEL_LINK to $NEW_KERNEL_PATH..."
ln -sf "$NEW_KERNEL_PATH" $CURRENT_KERNEL_LINK
