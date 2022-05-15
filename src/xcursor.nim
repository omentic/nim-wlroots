{.push dynlib: "libwlroots.so".}

type wlr_xcursor_image* {.bycopy.} = object
  width*: uint32_t
  height*: uint32_t
  hotspot_x*: uint32_t
  hotspot_y*: uint32_t
  delay*: uint32_t
  buffer*: ptr uint8_t

type wlr_xcursor* {.bycopy.} = object
  image_count*: cuint
  images*: ptr ptr wlr_xcursor_image
  name*: cstring
  total_delay*: uint32_t

type wlr_xcursor_theme* {.bycopy.} = object
  cursor_count*: cuint
  cursors*: ptr ptr wlr_xcursor
  name*: cstring
  size*: cint

proc wlr_xcursor_theme_load*(name: cstring; size: cint): ptr wlr_xcursor_theme {.importc: "wlr_xcursor_theme_load".}
proc wlr_xcursor_theme_destroy*(theme: ptr wlr_xcursor_theme) {.importc: "wlr_xcursor_theme_destroy".}
proc wlr_xcursor_theme_get_cursor*(theme: ptr wlr_xcursor_theme; name: cstring): ptr wlr_xcursor {.importc: "wlr_xcursor_theme_get_cursor".}
proc wlr_xcursor_frame*(cursor: ptr wlr_xcursor; time: uint32_t): cint {.importc: "wlr_xcursor_frame".}
proc wlr_xcursor_get_resize_name*(edges: wlr_edges): cstring {.importc: "wlr_xcursor_get_resize_name".}

{.pop.}
