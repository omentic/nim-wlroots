import wlroots/[backend, render, types, util, xcursor, xwayland]

export backend, render, types, util, xcursor, xwayland

## config

const
  WLR_HAS_DRM_BACKEND* = 1
  WLR_HAS_LIBINPUT_BACKEND* = 1
  WLR_HAS_X11_BACKEND* = 1
  WLR_HAS_GLES2_RENDERER* = 1
  WLR_HAS_VULKAN_RENDERER* = 1
  WLR_HAS_XWAYLAND* = 1

## version

const
  WLR_VERSION_STR* = "0.15.1"
  WLR_VERSION_MAJOR* = 0
  WLR_VERSION_MINOR* = 15
  WLR_VERSION_MICRO* = 1
  WLR_VERSION_NUM* = ((WLR_VERSION_MAJOR shl 16) or (WLR_VERSION_MINOR shl 8) or WLR_VERSION_MICRO)
