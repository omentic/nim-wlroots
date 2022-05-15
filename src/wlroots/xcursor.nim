{.push dynlib: "libwlroots.so".}

import wlroots/util

type XcursorImage* {.bycopy.} = object
  width*, height*: uint32
  hotspot_x*, hotspot_y*: uint32
  delay*: uint32
  buffer*: ptr uint8

type Xcursor* {.bycopy.} = object
  image_count*: cuint
  images*: ptr ptr XcursorImage
  name*: cstring
  total_delay*: uint32

type XcursorTheme* {.bycopy.} = object
  cursor_count*: cuint
  cursors*: ptr ptr Xcursor
  name*: cstring
  size*: cint

proc loadXcursorTheme*(name: cstring; size: cint): ptr XcursorTheme {.importc: "wlr_xcursor_theme_load".}
proc destroy*(theme: ptr XcursorTheme) {.importc: "wlr_xcursor_theme_destroy".}
proc getCursor*(theme: ptr XcursorTheme; name: cstring): ptr Xcursor {.importc: "wlr_xcursor_theme_get_cursor".}
proc frame*(cursor: ptr Xcursor; time: uint32): cint {.importc: "wlr_xcursor_frame".}
proc getResizeNameXcursor*(edges: Edges): cstring {.importc: "wlr_xcursor_get_resize_name".}

{.pop.}
