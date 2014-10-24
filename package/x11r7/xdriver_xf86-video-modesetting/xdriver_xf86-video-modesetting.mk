################################################################################
#
# xdriver_xf86-video-modesetting
#
################################################################################

XDRIVER_XF86_VIDEO_MODESETTING_VERSION = 0.9.0
XDRIVER_XF86_VIDEO_MODESETTING_SOURCE = xf86-video-modesetting-$(XDRIVER_XF86_VIDEO_MODESETTING_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_MODESETTING_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_MODESETTING_LICENSE = MIT
XDRIVER_XF86_VIDEO_MODESETTING_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_MODESETTING_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto

$(eval $(autotools-package))
