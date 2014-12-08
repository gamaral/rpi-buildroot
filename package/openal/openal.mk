################################################################################
#
# openal
#
################################################################################

OPENAL_VERSION = 1.16.0
OPENAL_SOURCE = openal-soft-$(OPENAL_VERSION).tar.bz2
OPENAL_SITE = http://kcat.strangesoft.net/openal-releases/
OPENAL_INSTALL_STAGING = YES
OPENAL_LICENSE = LGPL
OPENAL_LICENSE_FILES = COPYING

$(eval $(cmake-package))
