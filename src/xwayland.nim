{.push dynlib: "libwlroots.so".}

import std/posix
import wayland

type WlrXwaylandServer_options* {.bycopy.} = object
  lazy*: bool
  enable_wm*: bool
  no_touch_pointer_emulation*: bool

type WlrXwaylandServer_events* {.bycopy.} = object
  ready*: WlSignal
  destroy*: WlSignal

type WlrXwaylandServer* {.bycopy.} = object
  pid*: Pid
  client*: ptr WlClient
  pipe_source*: ptr WlEventSource
  wm_fd*: array[2, cint]
  wl_fd*: array[2, cint]
  server_start*: Time
  display*: cint
  display_name*: array[16, char]
  x_fd*: array[2, cint]
  x_fd_read_event*: array[2, ptr WlEventSource]
  options*: WlrXwaylandServer_options
  wl_display*: ptr WlDisplay
  events*: WlrXwaylandServer_events
  client_destroy*: WlListener
  display_destroy*: WlListener
  data*: pointer

type WlrXwaylandServerReadyEvent* {.bycopy.} = object
  server*: ptr WlrXwaylandServer
  wm_fd*: cint

type WlrXwayland_events* {.bycopy.} = object
  ready*: WlSignal
  new_surface*: WlSignal
  remove_startup_info*: WlSignal

type WlrXwayland* {.bycopy.} = object
  server*: ptr WlrXwaylandServer
  xwm*: ptr WlrXwm
  cursor*: ptr WlrXwaylandCursor
  display_name*: cstring
  wl_display*: ptr WlDisplay
  compositor*: ptr WlrCompositor
  seat*: ptr WlrSeat
  events*: WlrXwayland_events
  user_event_handler*: proc (xwm: ptr WlrXwm; event: ptr xcb_generic_event_t): cint
  server_ready*: WlListener
  server_destroy*: WlListener
  seat_destroy*: WlListener
  data*: pointer

type WlrXwaylandSurfaceDecorations* = enum
  WLR_XWAYLAND_SURFACE_DECORATIONS_ALL = 0,
  WLR_XWAYLAND_SURFACE_DECORATIONS_NO_BORDER = 1,
  WLR_XWAYLAND_SURFACE_DECORATIONS_NO_TITLE = 2

type WlrXwaylandSurfaceHints* {.bycopy.} = object
  flags*: uint32
  input*: uint32
  initial_state*: int32
  icon_pixmap*: xcb_pixmap_t
  icon_window*: xcb_window_t
  icon_x*: int32
  icon_y*: int32
  icon_mask*: xcb_pixmap_t
  window_group*: xcb_window_t

type WlrXwaylandSurfaceSizeHints* {.bycopy.} = object
  flags*: uint32
  x*, y*: int32
  width*,  height*: int32
  min_width*, min_height*: int32
  max_width*, max_height*: int32
  width_inc*, height_inc*: int32
  base_width*, base_height*: int32
  min_aspect_num*, min_aspect_den*: int32
  max_aspect_num*, max_aspect_den*: int32
  win_gravity*: uint32

type WlrXwaylandIcccmInputModel* = enum
  WLR_ICCCM_INPUT_MODEL_NONE = 0,
  WLR_ICCCM_INPUT_MODEL_PASSIVE = 1,
  WLR_ICCCM_INPUT_MODEL_LOCAL = 2,
  WLR_ICCCM_INPUT_MODEL_GLOBAL = 3

type WlrXwaylandSurface_events* {.bycopy.} = object
  destroy*: WlSignal
  request_configure*: WlSignal
  request_move*: WlSignal
  request_resize*: WlSignal
  request_minimize*: WlSignal
  request_maximize*: WlSignal
  request_fullscreen*: WlSignal
  request_activate*: WlSignal
  map*: WlSignal
  unmap*: WlSignal
  set_title*: WlSignal
  set_class*: WlSignal
  set_role*: WlSignal
  set_parent*: WlSignal
  set_pid*: WlSignal
  set_startup_id*: WlSignal
  set_window_type*: WlSignal
  set_hints*: WlSignal
  set_decorations*: WlSignal
  set_override_redirect*: WlSignal
  set_geometry*: WlSignal
  ping_timeout*: WlSignal

type WlrXwaylandSurface* {.bycopy.} = object
  window_id*: xcb_window_t
  xwm*: ptr WlrXwm
  surface_id*: uint32
  link*: WlList
  stack_link*: WlList
  unpaired_link*: WlList
  surface*: ptr WlrSurface
  x*, y*: int16
  width*, height*: uint16
  saved_width*, saved_height*: uint16
  override_redirect*: bool
  mapped*: bool
  title*: cstring
  class*: cstring
  instance*: cstring
  role*: cstring
  startup_id*: cstring
  pid*: Pid
  has_utf8_title*: bool
  children*: WlList
  parent*: ptr WlrXwaylandSurface
  parent_link*: WlList
  window_type*: ptr xcb_atom_t
  window_type_len*: csize_t
  protocols*: ptr xcb_atom_t
  protocols_len*: csize_t
  decorations*: uint32
  hints*: ptr WlrXwaylandSurfaceHints
  hints_urgency*: uint32
  size_hints*: ptr WlrXwaylandSurfaceSizeHints
  pinging*: bool
  ping_timer*: ptr WlEventSource
  modal*: bool
  fullscreen*: bool
  maximized_vert*: bool
  maximized_horz*: bool
  minimized*: bool
  has_alpha*: bool
  events*: WlrXwaylandSurface_events
  surface_destroy*: WlListener
  data*: pointer

type WlrXwaylandSurfaceConfigureEvent* {.bycopy.} = object
  surface*: ptr WlrXwaylandSurface
  x*, y*: int16
  width*, height*: uint16
  mask*: uint16

type WlrXwaylandMoveEvent* {.bycopy.} = object
  surface*: ptr WlrXwaylandSurface

type WlrXwaylandRemoveStartupInfoEvent* {.bycopy.} = object
  id*: cstring
  window*: xcb_window_t

type WlrXwaylandResizeEvent* {.bycopy.} = object
  surface*: ptr WlrXwaylandSurface
  edges*: uint32

type WlrXwaylandMinimizeEvent* {.bycopy.} = object
  surface*: ptr WlrXwaylandSurface
  minimize*: bool

proc createWlrXwaylandServer*(display: ptr WlDisplay; options: ptr WlrXwaylandServer_options): ptr WlrXwaylandServer {.importc: "wlr_xwayland_server_create".}
proc destroy*(server: ptr WlrXwaylandServer) {.importc: "wlr_xwayland_server_destroy".}

proc createWlrXwayland*(wl_display: ptr WlDisplay; compositor: ptr WlrCompositor; lazy: bool): ptr WlrXwayland {.importc: "wlr_xwayland_create".}
proc destroy*(wlr_xwayland: ptr WlrXwayland) {.importc: "wlr_xwayland_destroy".}

proc setCursor*(wlr_xwayland: ptr WlrXwayland; pixels: ptr uint8; stride: uint32; width: uint32; height: uint32; hotspot_x: int32; hotspot_y: int32) {.importc: "wlr_xwayland_set_cursor".}
proc activate*(surface: ptr WlrXwaylandSurface; activated: bool) {.importc: "wlr_xwayland_surface_activate".}
proc restack*(surface: ptr WlrXwaylandSurface; sibling: ptr WlrXwaylandSurface; mode: xcb_stack_mode_t) {.importc: "wlr_xwayland_surface_restack".}
proc configure*(surface: ptr WlrXwaylandSurface; x: int16; y: int16; width: uint16; height: uint16) {.importc: "wlr_xwayland_surface_configure".}
proc close*(surface: ptr WlrXwaylandSurface) {.importc: "wlr_xwayland_surface_close".}

proc setMinimized*(surface: ptr WlrXwaylandSurface; minimized: bool) {.importc: "wlr_xwayland_surface_set_minimized".}
proc setMaximized*(surface: ptr WlrXwaylandSurface; maximized: bool) {.importc: "wlr_xwayland_surface_set_maximized".}
proc setFullscreen*(surface: ptr WlrXwaylandSurface; fullscreen: bool) {.importc: "wlr_xwayland_surface_set_fullscreen".}
proc setSeat*(xwayland: ptr WlrXwayland; seat: ptr WlrSeat) {.importc: "wlr_xwayland_set_seat".}

proc isXwaylandSurface*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_is_xwayland_surface".}
proc wlrXwaylandSurfaceFromWlrSurface*(surface: ptr WlrSurface): ptr WlrXwaylandSurface {.importc: "wlr_xwayland_surface_from_wlr_surface".} # XXX: bad name lol
proc ping*(surface: ptr WlrXwaylandSurface) {.importc: "wlr_xwayland_surface_ping".}
proc wantsFocus*(xsurface: ptr WlrXwaylandSurface): bool {.importc: "wlr_xwayland_or_surface_wants_focus".}
proc wlrXwaylandIcccmInputModel*(xsurface: ptr WlrXwaylandSurface): WlrXwaylandIcccmInputModel {.importc: "wlr_xwayland_icccm_input_model".}

{.pop.}
