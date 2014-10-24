################################################################################
#
# xdriver_xf86-video-udlfb
#
################################################################################

XDRIVER_XF86_VIDEO_UDLFB_SOURCE = master.tar.gz
XDRIVER_XF86_VIDEO_UDLFB_SITE = https://github.com/xranby/xf86-video-displaylink/archive
XDRIVER_XF86_VIDEO_UDLFB_LICENSE = MIT
XDRIVER_XF86_VIDEO_UDLFB_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_UDLFB_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto

$(eval $(autotools-package))
