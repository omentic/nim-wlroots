# Types found in: https://github.com/adrianperreault/nim-xcb/blob/master/src/xcb.nim

type
  XcbPixmap* = uint32
  XcbWindow* = uint32
  XcbAtom* = uint32
  XcbGenericEvent* = object
    response_type*: uint8
    pad0*: uint8
    pad*: array[7, uint32]
    full_sequence*: uint32
  XcbStackMode* {.pure.} = enum
    ABOVE = 0,
    BELOW = 1,
    TOP_IF = 2,
    BOTTOM_IF = 3,
    OPPOSITE = 4
