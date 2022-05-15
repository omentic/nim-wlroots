{.push dynlib: "libwlroots.so" .}

## addon

type wlr_addon_set* {.bycopy.} = object
  addons*: wl_list

discard "forward decl of wlr_addon"
type wlr_addon_interface* {.bycopy.} = object
  name*: cstring
  destroy*: proc (addon: ptr wlr_addon)

type wlr_addon* {.bycopy.} = object
  impl*: ptr wlr_addon_interface
  owner*: pointer
  link*: wl_list

proc wlr_addon_set_init*(set: ptr wlr_addon_set) {.importc: "wlr_addon_set_init".}
proc wlr_addon_set_finish*(set: ptr wlr_addon_set) {.importc: "wlr_addon_set_finish".}
proc wlr_addon_init*(addon: ptr wlr_addon; set: ptr wlr_addon_set; owner: pointer; impl: ptr wlr_addon_interface) {.importc: "wlr_addon_init".}
proc wlr_addon_finish*(addon: ptr wlr_addon) {.importc: "wlr_addon_finish".}
proc wlr_addon_find*(set: ptr wlr_addon_set; owner: pointer; impl: ptr wlr_addon_interface): ptr wlr_addon {.importc: "wlr_addon_find".}

## box

type wlr_box* {.bycopy.} = object
  x*: cint
  y*: cint
  width*: cint
  height*: cint

type wlr_fbox* {.bycopy.} = object
  x*: cdouble
  y*: cdouble
  width*: cdouble
  height*: cdouble

proc wlr_box_closest_point*(box: ptr wlr_box; x: cdouble; y: cdouble; dest_x: ptr cdouble; dest_y: ptr cdouble) {.importc: "wlr_box_closest_point".}
proc wlr_box_intersection*(dest: ptr wlr_box; box_a: ptr wlr_box; box_b: ptr wlr_box): bool {.importc: "wlr_box_intersection".}
proc wlr_box_contains_point*(box: ptr wlr_box; x: cdouble; y: cdouble): bool {.importc: "wlr_box_contains_point".}
proc wlr_box_empty*(box: ptr wlr_box): bool {.importc: "wlr_box_empty".}
proc wlr_box_transform*(dest: ptr wlr_box; box: ptr wlr_box; transform: wl_output_transform; width: cint; height: cint) {.importc: "wlr_box_transform".}
proc wlr_fbox_empty*(box: ptr wlr_fbox): bool {.importc: "wlr_fbox_empty".}
proc wlr_fbox_transform*(dest: ptr wlr_fbox; box: ptr wlr_fbox; transform: wl_output_transform; width: cdouble; height: cdouble) {.importc: "wlr_fbox_transform".}

## edges

type wlr_edges* = enum
  WLR_EDGE_NONE = 0, WLR_EDGE_TOP = 1 shl 0, WLR_EDGE_BOTTOM = 1 shl 1,
  WLR_EDGE_LEFT = 1 shl 2, WLR_EDGE_RIGHT = 1 shl 3

# TODO: log.h

{.pop.}
