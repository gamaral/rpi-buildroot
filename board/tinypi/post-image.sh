#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
DEPLOY_DIR="${BINARIES_DIR}/picopi"

if [ -f ${DEPLOY_DIR}/pico.pi ]; then
	rm -rf ${DEPLOY_DIR}
fi

mkdir -p ${DEPLOY_DIR}
cp ${BINARIES_DIR}/*.dtb ${DEPLOY_DIR}
cp ${BINARIES_DIR}/rpi-firmware/* ${DEPLOY_DIR}
cp ${BINARIES_DIR}/zImage ${DEPLOY_DIR}/pico.pi
cp ${BOARD_DIR}/cmdline.txt ${DEPLOY_DIR}
cp ${BOARD_DIR}/config.txt ${DEPLOY_DIR}
cp -a ${BOARD_DIR}/overlays ${DEPLOY_DIR}

pushd ${DEPLOY_DIR}
zip -r ${BINARIES_DIR}/picopi.zip .
popd

exit $?
