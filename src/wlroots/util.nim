{.push dynlib: "libwlroots.so" .}

import wayland

## edges

type WlrEdges* = enum
  WLR_EDGE_NONE = 0,
  WLR_EDGE_TOP = 1 shl 0,
  WLR_EDGE_BOTTOM = 1 shl 1,
  WLR_EDGE_LEFT = 1 shl 2,
  WLR_EDGE_RIGHT = 1 shl 3

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

# XXX: where'd region go?

## log

#[

#ifndef WLR_UTIL_LOG_H
#define WLR_UTIL_LOG_H

#include <stdbool.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>

type WlrLogImportance* = enum
  WLR_SILENT = 0,
  WLR_ERROR = 1,
  WLR_INFO = 2,
  WLR_DEBUG = 3,
  WLR_LOG_IMPORTANCE_LAST

type WlrLogFunc* =
  proc (importance: WlrLogImportance; fmt: cstring; args: varargs[string])

proc WlrLogInit*(verbosity: WlrLogImportance; callback: WlrLogFunc) {.importc: "wlr_log_init".}
proc WlrLogGetVerbosity*(): WlrLogImportance {.importc: "wlr_log_get_verbosity".}

when defined(__GNUC__):
  const _WLR_ATTRIB_PRINTF(start, end) = __attribute__((format(printf, start, end)))
else:
  const _WLR_ATTRIB_PRINTF(start, end)

void _wlr_log(enum wlr_log_importance verbosity, const char *format, ...) _WLR_ATTRIB_PRINTF(2, 3);
void _wlr_vlog(enum wlr_log_importance verbosity, const char *format, va_list args) _WLR_ATTRIB_PRINTF(2, 0);

when defined(WLR_REL_SRC_DIR):
  const _WLR_FILENAME* = (cast[cstring](__FILE__) + sizeof((WLR_REL_SRC_DIR)) - 1)
else:
  const _WLR_FILENAME* = __FILE__

template wlr_log(verb, fmt, ...): untyped =
  _wlr_log(verb, "[%s:%d] ", fmt, __FILE__, __LINE__, __VA_ARGS__)

template wlr_vlog*(verb, fmt, args: untyped): untyped =
  _wlr_vlog(verb, "[%s:%d] ", fmt, __FILE__, __LINE__, args)

template wlr_log_errno*(verb, fmt, ...): untyped =
  wlr_log(verb, fmt, ": %s", __VA_ARGS__, strerror(errno))

#endif

]#

{.pop.}
