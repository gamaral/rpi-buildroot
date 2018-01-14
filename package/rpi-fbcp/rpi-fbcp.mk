################################################################################
#
# rpi-fbcp
#
################################################################################

RPI_FBCP_VERSION = 8087a71d0330a078d91aa78656684ab5313616c6
RPI_FBCP_SITE = $(call github,tasanakorn,rpi-fbcp,$(RPI_FBCP_VERSION))
RPI_FBCP_DEPENDENCIES = rpi-userland

$(eval $(cmake-package))
