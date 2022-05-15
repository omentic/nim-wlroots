{.push dynlib: "libwlroots.so" .}

import wayland

## addon

type
  WlrAddon* {.bycopy.} = object
    impl*: ptr WlrAddonInterface
    owner*: pointer
    link*: WlList

  WlrAddonInterface* {.bycopy.} = object
    name*: cstring
    destroy*: proc (addon: ptr WlrAddon)

type WlrAddonSet* {.bycopy.} = object
  addons*: WlList

proc init*(set: ptr WlrAddonSet) {.importc: "wlr_addon_set_init".}
proc finish*(set: ptr WlrAddonSet) {.importc: "wlr_addon_set_finish".}
proc init*(addon: ptr WlrAddon; set: ptr WlrAddonSet; owner: pointer; impl: ptr WlrAddonInterface) {.importc: "wlr_addon_init".}
proc finish*(addon: ptr WlrAddon) {.importc: "wlr_addon_finish".}
proc findWlrAddon*(set: ptr WlrAddonSet; owner: pointer; impl: ptr WlrAddonInterface): ptr WlrAddon {.importc: "wlr_addon_find".}

## box

type WlrBox* {.bycopy.} = object
  x*, y*: cint
  width*, height*: cint

type WlrFbox* {.bycopy.} = object
  x*, y*: cdouble
  width*, height*: cdouble

proc closestPoint*(box: ptr WlrBox; x: cdouble; y: cdouble; dest_x: ptr cdouble; dest_y: ptr cdouble) {.importc: "wlr_box_closest_point".}
proc intersection*(dest: ptr WlrBox; box_a: ptr WlrBox; box_b: ptr WlrBox): bool {.importc: "wlr_box_intersection".}
proc containsPoint*(box: ptr WlrBox; x: cdouble; y: cdouble): bool {.importc: "wlr_box_contains_point".}

proc empty*(box: ptr WlrBox): bool {.importc: "wlr_box_empty".}
proc transform*(dest: ptr WlrBox; box: ptr WlrBox; transform: WlOutputTransform; width: cint; height: cint) {.importc: "wlr_box_transform".}

proc empty*(box: ptr WlrFbox): bool {.importc: "wlr_fbox_empty".}
proc transform*(dest: ptr WlrFbox; box: ptr WlrFbox; transform: WlOutputTransform; width: cdouble; height: cdouble) {.importc: "wlr_fbox_transform".}

## edges

type wlr_edges* = enum
  WLR_EDGE_NONE = 0,
  WLR_EDGE_TOP = 1 shl 0,
  WLR_EDGE_BOTTOM = 1 shl 1,
  WLR_EDGE_LEFT = 1 shl 2,
  WLR_EDGE_RIGHT = 1 shl 3

# TODO: log.h
# XXX: where'd region go?

{.pop.}
