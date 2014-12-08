################################################################################
#
# xdriver_xf86-video-udlfb
#
################################################################################

XDRIVER_XF86_VIDEO_UDLFB_VERSION = 5cb3b6c9fb9b3478777631be8c0353b097cbfaf7
XDRIVER_XF86_VIDEO_UDLFB_SITE = $(call github,xranby,xf86-video-displaylink,$(XDRIVER_XF86_VIDEO_UDLFB_VERSION))
XDRIVER_XF86_VIDEO_UDLFB_LICENSE = MIT
XDRIVER_XF86_VIDEO_UDLFB_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_UDLFB_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto

$(eval $(autotools-package))
