{.push dynlib: "libwlroots.so" .}

import wayland, pixman

type WlrEdges* = enum
  WLR_EDGE_NONE = 0,
  WLR_EDGE_TOP = 1 shl 0,
  WLR_EDGE_BOTTOM = 1 shl 1,
  WLR_EDGE_LEFT = 1 shl 2,
  WLR_EDGE_RIGHT = 1 shl 3

proc scale*(dst, src: ptr PixmanRegion32; scale: cfloat) {.importc: "wlr_region_scale".}
proc scale_xy*(dst, src: ptr PixmanRegion32; scale_x, scale_y: cfloat) {.importc: "wlr_region_scale_xy".}
proc transform*(dst, src: ptr PixmanRegion32; transform: WlOutputTransform; width, height: cint) {.importc: "wlr_region_transform".}
proc expand*(dst, src: ptr PixmanRegion32; distance: cint) {.importc: "wlr_region_expand".}
proc rotated_bounds*(dst: ptr PixmanRegion32; src: ptr PixmanRegion32; rotation: cfloat; ox, oy: cint) {.importc: "wlr_region_rotated_bounds".}
proc confine*(region: ptr PixmanRegion32; x1, y1: cdouble; x2, y2: cdouble; x2_out, y2_out: ptr cdouble): bool {.importc: "wlr_region_confine".}

{.pop.}
