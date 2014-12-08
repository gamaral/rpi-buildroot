################################################################################
#
# xdotool
#
################################################################################

XDOTOOL_VERSION = 2.20110530.1
XDOTOOL_SOURCE = xdotool-$(XDOTOOL_VERSION).tar.gz
XDOTOOL_SITE = http://semicomplete.googlecode.com/files/
XDOTOOL_DEPENDENCIES = xlib_libXtst
XDOTOOL_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
XDOTOOL_LICENSE = MIT

define XDOTOOL_BUILD_CMDS
	# LD is using CC because busybox -ld do not support -Xlinker -z hence linking using -gcc instead
	make OBJCOPY=$(TARGET_OBJCOPY) STRIP=$(TARGET_STRIP) BUILD_CC=gcc BUILD_LD=gcc CPP=$(TARGET_CPP) CXX=$(TARGET_CXX) CC=$(TARGET_CC) LD=$(TARGET_CC) -C $(@D)
endef

define XDOTOOL_INSTALL_TARGET_CMDS
	cd $(@D) && PREFIX=$(TARGET_DIR) make pre-install installlib installprog
endef

XDOTOOL_BUILD_CMD = make 
$(eval $(generic-package))
