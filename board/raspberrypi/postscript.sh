#!/bin/sh

TARGET="${1}"

# move kernel
mv ${TARGET}/boot/zImage ${TARGET}/boot/kernel.img 2> /dev/null

exit 0

