#!/bin/sh
#
# Flash Raspberry Pi SD card [buildroot]
#
# Guillermo A. Amaral B. <g@maral.me>
# Geoffrey 'Frogeye' Preud'homme <geoffrey@frogeye.fr>
#

SDCARD="${1}"

usage() {
	echo "Usage: ${0} [SDCARD]"
	echo "Where SDCARD is your SD card device node, for example: /dev/sdx"
	echo
	echo "You will require *root* privileges in order to use this script."
	echo
}

confirm() {
	echo "You are about to totally decimate the following device node: ${SDCARD}"
	echo
	echo "If you are sure you want to continue? (Please write \"YES\" in all caps)"

	read CONTUNUE

	if [ "${CONTUNUE}" != "YES" ]; then
		echo "User didn't write \"YES\"... ABORTING!"
		exit 1
	fi
}

section() {
	echo "*****************************************************************************************"
	echo "> ${*}"
	echo "*****************************************************************************************"
	sleep 1
}

# environment overrides

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
OUTPUT_PREFIX=""

# check parameters

if [ -z "${SDCARD}" ] || [ "${SDCARD}" = "-h" ] || [ "${SDCARD}" = "--help" ]; then
	usage
	exit 0
fi

# check if node is a block device

if [ ! -b "${SDCARD}" ]; then
	echo "${SDCARD} is not a block device!"
	exit 1
fi

# root privilege check

USERID=`id -u`
if [ ${USERID} -ne 0 ]; then
	echo "${0} requires root privileges in order to work."
	exit 0
fi

# dependencies

CP=`which cp`
DD=`which dd`
FDISK=`which fdisk`
GREP=`which grep`
CUT=`which cut`
SED=`which sed`
PARTED=`which parted`
RESIZE2FS=`which resize2fs`
SYNC=`which sync`

if [ -z "${CP}" ] ||
   [ -z "${DD}" ] ||
   [ -z "${FDISK}" ] ||
   [ -z "${GREP}" ] ||
   [ -z "${CUT}" ] ||
   [ -z "${SED}" ] ||
   [ -z "${PARTED}" ] ||
   [ -z "${RESIZE2FS}" ]; then
	echo "Missing dependencies:\n"
	echo "CP=${CP}"
	echo "DD=${DD}"
	echo "FDISK=${FDISK}"
	echo "GREP=${GREP}"
	echo "CUT=${CUT}"
	echo "SED=${SED}"
	echo "PARTED=${PARTED}"
	echo "RESIZE2FS=${RESIZE2FS}"
	exit 1
fi

# sanity check

if [ ! -d "images" ] || [ ! -f "images/sdcard.img" ]; then
	if [ -d "output/images" ] && [ -f "output/images/sdcard.img" ]; then
		OUTPUT_PREFIX="output/"
	else
		echo "Didn't find sdcard.img! ABORT."
		exit 1
	fi
fi

# warn user

confirm

# figure out partition pattern

SDCARDP="$(fdisk -l ${SDCARD} | grep ${SDCARD} | tail -1 | cut -d ' ' -f 1 | sed 's/[0-9]\+$//')"

# unmount eventually mounted partitions

umount ${SDCARDP}1 &> /dev/null
umount ${SDCARDP}2 &> /dev/null

# write image

section "Writing to SD card..."

${DD} status=progress if=${OUTPUT_PREFIX}images/sdcard.img of=${SDCARD}

# resize root partition

section "Resizing root partition..."

${PARTED} ${SDCARD} <<END
print
resizepart 2
100%
print
quit
END

sleep 1

# resize root filesystem

section "Resizing root filesystem..."

${RESIZE2FS} ${SDCARDP}2

${SYNC}

section "Finished!"

exit 0
