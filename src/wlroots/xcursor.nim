{.push dynlib: "libwlroots.so".}

type WlrXcursorImage* = object
  width*: uint32           #  actual width
  height*: uint32          #  actual height
  hotspot_x*: uint32       #  hot spot x (must be inside image)
  hotspot_y*: uint32       #  hot spot y (must be inside image)
  delay*: uint32           #  animation delay to next frame (ms)
  buffer*: ptr uint8

type WlrXcursor* = object
  image_count*: cuint
  images*: ptr ptr WlrXcursorImage
  name*: cstring
  total_delay*: uint32     #  length of the animation in ms

type WlrXcursorTheme* = object
  cursor_count*: cuint
  cursors*: ptr ptr WlrXcursor
  name*: cstring
  size*: cint

proc load_wlr_xcursor_theme*(name: cstring; size: cint): ptr WlrXcursorTheme {.importc: "wlr_xcursor_theme_load".}

proc destroy*(theme: ptr WlrXcursorTheme) {.importc: "wlr_xcursor_theme_destroy".}

proc get_cursor*(theme: ptr WlrXcursorTheme; name: cstring): ptr WlrXcursor {.importc: "wlr_xcursor_theme_get_cursor".}

proc frame*(cursor: ptr WlrXcursor; time: uint32): cint {.importc: "wlr_xcursor_frame".}

proc get_resize_name_wlr_xcursor*(edges: WlrEdges): cstring {.importc: "wlr_xcursor_get_resize_name".}

{.pop.}
