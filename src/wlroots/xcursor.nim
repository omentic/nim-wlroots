{.push dynlib: "libwlroots.so".}

import wlroots/util

type WlrXcursorImage* {.bycopy.} = object
  width*, height*: uint32
  hotspot_x*, hotspot_y*: uint32
  delay*: uint32
  buffer*: ptr uint8

type WlrXcursor* {.bycopy.} = object
  image_count*: cuint
  images*: ptr ptr WlrXcursorImage
  name*: cstring
  total_delay*: uint32

type WlrXcursorTheme* {.bycopy.} = object
  cursor_count*: cuint
  cursors*: ptr ptr WlrXcursor
  name*: cstring
  size*: cint

proc loadWlrXcursorTheme*(name: cstring; size: cint): ptr WlrXcursorTheme {.importc: "wlr_xcursor_theme_load".}
proc destroy*(theme: ptr WlrXcursorTheme) {.importc: "wlr_xcursor_theme_destroy".}
proc getCursor*(theme: ptr WlrXcursorTheme; name: cstring): ptr WlrXcursor {.importc: "wlr_xcursor_theme_get_cursor".}
proc frame*(cursor: ptr WlrXcursor; time: uint32): cint {.importc: "wlr_xcursor_frame".}
proc getResizeNameWlrXcursor*(edges: WlrEdges): cstring {.importc: "wlr_xcursor_get_resize_name".}

{.pop.}
