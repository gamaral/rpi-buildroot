#!/bin/sh
#
# Marshmallow Entertainment System
# Init Cleanup
#
# Guillermo A. Amaral B. <g@maral.me>
#

TARGET="${1}"

#
# manual startup only
mv ${TARGET}/etc/init.d/S01logging ${TARGET}/etc/init.d/M01logging
mv ${TARGET}/etc/init.d/S40network ${TARGET}/etc/init.d/M40network
mv ${TARGET}/etc/init.d/S49ntp     ${TARGET}/etc/init.d/M49ntp
mv ${TARGET}/etc/init.d/S50sshd    ${TARGET}/etc/init.d/M50sshd

exit 0

