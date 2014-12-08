################################################################################
#
# libepoxy
#
################################################################################

LIBEPOXY_VERSION = b2ae054b3aa0d6796b6936c7a89b8cce7cefe7ba
LIBEPOXY_SITE = $(call github,anholt,libepoxy,$(LIBEPOXY_VERSION))
LIBEPOXY_LICENSE = MIT
LIBEPOXY_LICENSE_FILES = COPYING
LIBEPOXY_INSTALL_STAGING = YES
LIBEPOXY_INSTALL_TARGET = YES

# The standard <pkg>_AUTORECONF = YES invocation doesn't work for this
# package, because it does not use automake in a normal way.
define LIBEPOXY_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
LIBEPOXY_PRE_CONFIGURE_HOOKS += LIBEPOXY_RUN_AUTOGEN

$(eval $(autotools-package))
