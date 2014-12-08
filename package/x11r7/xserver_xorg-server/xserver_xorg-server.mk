################################################################################
#
# xserver_xorg-server
#
################################################################################

# first RC for X server 1.17
# * The modesetting driver has been merged into the server code base,
# simplifying ongoing maintenance by coupling it to the X server
# ABI/API release schedule. This now includes DRI2 support (so that GLX
# works correctly) along with Glamor support (which handles DRI3)
# http://lists.x.org/archives/xorg-announce/2014-October/002491.html
XSERVER_XORG_SERVER_VERSION = 1.16.99.901
XSERVER_XORG_SERVER_SOURCE = xorg-server-$(XSERVER_XORG_SERVER_VERSION).tar.bz2
XSERVER_XORG_SERVER_SITE = http://xorg.freedesktop.org/releases/individual/xserver
XSERVER_XORG_SERVER_LICENSE = MIT
XSERVER_XORG_SERVER_LICENSE_FILES = COPYING
XSERVER_XORG_SERVER_INSTALL_STAGING = YES
XSERVER_XORG_SERVER_DEPENDENCIES = 	\
	xutil_util-macros 		\
	xlib_libXfont 			\
	xlib_libX11 			\
	xlib_libXau 			\
	xlib_libXdmcp 			\
	xlib_libXext 			\
	xlib_libXfixes 			\
	xlib_libXi 			\
	xlib_libXrender 		\
	xlib_libXres 			\
	xlib_libXft 			\
	xlib_libXcursor 		\
	xlib_libXinerama 		\
	xlib_libXrandr 			\
	xlib_libXdamage 		\
	xlib_libXxf86vm 		\
	xlib_libxkbfile 		\
	xlib_xtrans 			\
	xdata_xbitmaps 			\
	xproto_bigreqsproto 		\
	xproto_compositeproto 		\
	xproto_damageproto 		\
	xproto_fixesproto 		\
	xproto_fontsproto 		\
	xproto_glproto 			\
	xproto_inputproto 		\
	xproto_kbproto 			\
	xproto_presentproto 		\
	xproto_randrproto 		\
	xproto_renderproto 		\
	xproto_resourceproto 		\
	xproto_videoproto 		\
	xproto_xcmiscproto 		\
	xproto_xextproto 		\
	xproto_xf86bigfontproto 	\
	xproto_xf86dgaproto 		\
	xproto_xf86vidmodeproto 	\
	xproto_xproto 			\
	xkeyboard-config		\
	pixman 				\
	mcookie 			\
	host-pkgconf

XSERVER_XORG_SERVER_CONF_OPT = --disable-config-hal \
		--disable-xnest --disable-xephyr --disable-dmx \
		--with-builder-addr=buildroot@buildroot.org \
		CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/pixman-1" \
		--with-fontrootdir=/usr/share/fonts/X11/ --localstatedir=/var \
		--$(if $(BR2_PACKAGE_XSERVER_XORG_SERVER_XVFB),en,dis)able-xvfb

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_MODULAR),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-glamor --enable-xorg
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libpciaccess
XSERVER_XORG_SERVER_DEPENDENCIES += libdrm
XSERVER_XORG_SERVER_DEPENDENCIES += libepoxy
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-xorg
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_KDRIVE),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-kdrive --enable-xfbdev \
		--disable-glx --disable-dri --disable-xsdl
define XSERVER_CREATE_X_SYMLINK
 ln -f -s Xfbdev $(TARGET_DIR)/usr/bin/X
endef
XSERVER_XORG_SERVER_POST_INSTALL_TARGET_HOOKS += XSERVER_CREATE_X_SYMLINK

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_KDRIVE_EVDEV),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-kdrive-evdev
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-kdrive-evdev
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_KDRIVE_KBD),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-kdrive-kbd
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-kdrive-kbd
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_KDRIVE_MOUSE),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-kdrive-mouse
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-kdrive-mouse
endif

else # modular
XSERVER_XORG_SERVER_CONF_OPT += --disable-kdrive --disable-xfbdev
endif

ifeq ($(BR2_PACKAGE_MESA3D_DRI_DRIVER),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-dri --enable-glx
XSERVER_XORG_SERVER_DEPENDENCIES += mesa3d xproto_xf86driproto
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-dri --disable-glx
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_NULL_CURSOR),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-null-root-cursor
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-null-root-cursor
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_AIGLX),y)
XSERVER_XORG_SERVER_CONF_OPT += --enable-aiglx
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-aiglx
endif

# Optional packages
ifeq ($(BR2_PACKAGE_TSLIB),y)
XSERVER_XORG_SERVER_DEPENDENCIES += tslib
XSERVER_XORG_SERVER_CONF_OPT += --enable-tslib LDFLAGS="-lts"
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
XSERVER_XORG_SERVER_DEPENDENCIES += udev
XSERVER_XORG_SERVER_CONF_OPT += --enable-config-udev
# udev kms support depends on libdrm
ifeq ($(BR2_PACKAGE_LIBDRM),y)
XSERVER_XORG_SERVER_DEPENDENCIES += libdrm
XSERVER_XORG_SERVER_CONF_OPT += --enable-config-udev-kms
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-config-udev-kms
endif
else
ifeq ($(BR2_PACKAGE_DBUS),y)
XSERVER_XORG_SERVER_DEPENDENCIES += dbus
XSERVER_XORG_SERVER_CONF_OPT += --enable-config-dbus
endif
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
XSERVER_XORG_SERVER_DEPENDENCIES += freetype
endif

ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
XSERVER_XORG_SERVER_DEPENDENCIES += libunwind
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-libunwind
endif

ifeq ($(BR2_PACKAGE_XPROTO_RECORDPROTO),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xproto_recordproto
XSERVER_XORG_SERVER_CONF_OPT += --enable-record
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-record
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBXVMC),y)
XSERVER_XORG_SERVER_CONF_OPT += --disable-xvmc
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
XSERVER_XORG_SERVER_CONF_OPT += --disable-composite
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_MODULAR),y)
ifeq ($(BR2_PACKAGE_XPROTO_DRI2PROTO),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xproto_dri2proto
XSERVER_XORG_SERVER_CONF_OPT += --enable-dri2
endif
ifeq ($(BR2_PACKAGE_XPROTO_DRI3PROTO),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libxshmfence xproto_dri3proto
XSERVER_XORG_SERVER_CONF_OPT += --enable-dri3
endif
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-dri2 --disable-dri3
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXSCRNSAVER),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libXScrnSaver
XSERVER_XORG_SERVER_CONF_OPT += --enable-screensaver
else
XSERVER_XORG_SERVER_CONF_OPT += --disable-screensaver
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBDMX),y)
XSERVER_XORG_SERVER_CONF_OPT += --disable-dmx
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
XSERVER_XORG_SERVER_CONF_OPT += --with-sha1=libcrypto
XSERVER_XORG_SERVER_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
XSERVER_XORG_SERVER_CONF_OPT += --with-sha1=libgcrypt
XSERVER_XORG_SERVER_DEPENDENCIES += libgcrypt
else
XSERVER_XORG_SERVER_CONF_OPT += --with-sha1=libsha1
XSERVER_XORG_SERVER_DEPENDENCIES += libsha1
endif

$(eval $(autotools-package))
