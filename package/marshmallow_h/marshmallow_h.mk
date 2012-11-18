#############################################################
#
# marshmallow_h - Marshmallow Game Engine
#
#############################################################
MARSHMALLOW_H_VERSION = 20121126
MARSHMALLOW_H_SOURCE = marshmallow_h-$(MARSHMALLOW_H_VERSION)-src.tar.xz
MARSHMALLOW_H_SITE = https://github.com/downloads/gamaral/marshmallow_h
MARSHMALLOW_H_INSTALL_STAGING = YES
MARSHMALLOW_H_INSTALL_TARGET = YES
MARSHMALLOW_H_CONF_OPT = -C"$(@D)/cmake/Cache-raspberrypi.cmake" -DCMAKE_BUILD_TYPE=Release
MARSHMALLOW_H_DEPENDENCIES = rpi-userland

ifeq ($(BR2_PACKAGE_MARSHMALLOW_H_DEMOS),y)
MARSHMALLOW_H_CONF_OPT += -DMARSHMALLOW_DEMO=ON -DMARSHMALLOW_DEMO_CWD_OVERRIDE=OFF
MARSHMALLOW_H_DEMOS = true
MARSHMALLOW_H_DEPLOYMENT = true
else
MARSHMALLOW_H_CONF_OPT += -DMARSHMALLOW_DEMO=OFF
MARSHMALLOW_H_DEMOS = false
MARSHMALLOW_H_DEPLOYMENT = false
endif

define MARSHMALLOW_H_INSTALL_TARGET_CMDS
	$(HOST_DIR)/usr/bin/cmake -DCMAKE_INSTALL_PREFIX=$(TARGET_DIR)/usr -DCOMPONENT=runtime -P "$(@D)/cmake_install.cmake"
	mv $(@D)/install_manifest_runtime.txt $(@D)/install_manifest_runtime_target.txt

	if [ $(MARSHMALLOW_H_DEPLOYMENT) ]; then \
		$(HOST_DIR)/usr/bin/cmake -DCMAKE_INSTALL_PREFIX=$(TARGET_DIR)/usr/games/marshmallow_h -DCOMPONENT=deployment -P "$(@D)/cmake_install.cmake"; \
		mv $(@D)/install_manifest_deployment.txt $(@D)/install_manifest_deployment_target.txt; \
	fi

	if [ $(MARSHMALLOW_H_DEMOS) ]; then \
		$(HOST_DIR)/usr/bin/cmake -DCMAKE_INSTALL_PREFIX=$(TARGET_DIR)/usr/games/marshmallow_h -DCOMPONENT=demos -P "$(@D)/cmake_install.cmake"; \
		mv $(@D)/install_manifest_demos.txt $(@D)/install_manifest_demos_target.txt; \
	fi
endef

define MARSHMALLOW_H_INSTALL_STAGING_CMDS
	$(HOST_DIR)/usr/bin/cmake -DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/usr -DCOMPONENT=development -P "$(@D)/cmake_install.cmake"
	mv $(@D)/install_manifest_development.txt $(@D)/install_manifest_development_staging.txt

	$(HOST_DIR)/usr/bin/cmake -DCMAKE_INSTALL_PREFIX=$(STAGING_DIR)/usr -DCOMPONENT=runtime -P "$(@D)/cmake_install.cmake"
	mv $(@D)/install_manifest_runtime.txt $(@D)/install_manifest_runtime_staging.txt
endef

ifeq ($(MARSHMALLOW_H_DEPLOYMENT),true)
define MARSHMALLOW_H_INSTALL_INIT_SYSV
	if [ ! -f $(TARGET_DIR)/etc/init.d/S30marshmallow_h ]; then \
		$(INSTALL) -m 755 -D package/marshmallow_h/marshmallow_h.init \
			$(TARGET_DIR)/etc/init.d/S30marshmallow_h; \
	fi
endef
endif

define MARSHMALLOW_H_UNINSTALL_TARGET_CMDS
	xargs rm -f < $(@D)/install_manifest_runtime_target.txt

	if [ $(MARSHMALLOW_H_DEMOS) ]; then \
		xargs rm -f < $(@D)/install_manifest_demos_target.txt; \
	fi

	if [ $(MARSHMALLOW_H_DEPLOYMENT) ]; then \
		xargs rm < $(@D)/install_manifest_deployment_target.txt; \
		rm -f $(TARGET_DIR)/etc/init.d/S30marshmallow_h; \
		rm -rf $(TARGET_DIR)/usr/games/marshmallow_h; \
		rmdir $(TARGET_DIR)/usr/games | true; \
	fi
endef

define MARSHMALLOW_H_UNINSTALL_STAGING_CMDS
	xargs rm -f < $(@D)/install_manifest_development_staging.txt
	xargs rm -f < $(@D)/install_manifest_runtime_staging.txt
endef

$(eval $(cmake-package))
