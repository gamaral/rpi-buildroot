#!/bin/sh

TARGET="${1}"

# move kernel
cp ${TARGET}/../build/linux-custom/System.map ${TARGET}/boot/System.map
cp ${TARGET}/../build/linux-custom/System.map ${TARGET}/System.map
mv ${TARGET}/boot/zImage ${TARGET}/boot/kernel.img 2> /dev/null

exit 0

