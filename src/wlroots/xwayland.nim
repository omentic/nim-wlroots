{.push dynlib: "libwlroots.so".}

import posix
import wayland

type WlrXwm* = object

type WlrXwaylandCursor* = object

type WlrXwaylandServer_events* = object
  ready*: WlSignal
  destroy*: WlSignal

type WlrXwaylandServer* = object
  pid*: Pid
  client*: ptr WlClient
  pipe_source*: ptr WlEventSource
  wm_fd*, wl_fd*: array[2, cint]
  server_start*: Time
  display*: cint
  display_name*: array[16, char]
  x_fd*: array[2, cint]
  x_fd_read_event*: array[2, ptr WlEventSource]
  lazy*: bool
  enable_wm*: bool
  wl_display*: ptr WlDisplay
  events*: WlrXwaylandServer_events
  client_destroy*: WlListener
  display_destroy*: WlListener
  data*: pointer

type WlrXwaylandServerOptions* = object
  lazy*: bool
  enable_wm*: bool

type WlrXwaylandServerReadyEvent* = object
  server*: ptr WlrXwaylandServer
  wm_fd*: cint

type WlrXwayland_events* = object
  ready*: WlSignal
  new_surface*: WlSignal

type WlrXwayland* = object
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

type WlrXwaylandSurfaceHints* = object
  flags*: uint32
  input*: uint32
  initial_state*: int32
  icon_pixmap*: xcb_pixmap_t
  icon_window*: xcb_window_t
  icon_x*, icon_y*: int32
  icon_mask*: xcb_pixmap_t
  window_group*: xcb_window_t

type WlrXwaylandSurfaceSizeHints* = object
  flags*: uint32
  x*, y*: int32
  width*, height*: int32
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

type WlrXwaylandSurface_events* = object
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
  set_window_type*: WlSignal
  set_hints*: WlSignal
  set_decorations*: WlSignal
  set_override_redirect*: WlSignal
  set_geometry*: WlSignal
  ping_timeout*: WlSignal

type WlrXwaylandSurface* = object
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
  ##  _NET_WM_STATE
  modal*: bool
  fullscreen*: bool
  maximized_vert*, maximized_horz*: bool
  minimized*: bool
  has_alpha*: bool
  events*: WlrXwaylandSurface_events
  surface_destroy*: WlListener
  data*: pointer

type WlrXwaylandSurfaceConfigureEvent* = object
  surface*: ptr WlrXwaylandSurface
  x*, y*: int16
  width*, height*: uint16
  mask*: uint16            #  xcb_config_window_t

##  TODO: maybe add a seat to these
type WlrXwaylandMoveEvent* = object
  surface*: ptr WlrXwaylandSurface

type WlrXwaylandResizeEvent* = object
  surface*: ptr WlrXwaylandSurface
  edges*: uint32

type WlrXwaylandMinimizeEvent* = object
  surface*: ptr WlrXwaylandSurface
  minimize*: bool

proc create_wlr_xwayland_server*(display: ptr WlDisplay; options: ptr WlrXwaylandServerOptions): ptr WlrXwaylandServer {.importc: "wlr_xwayland_server_create".}
proc destroy*(server: ptr WlrXwaylandServer) {.importc: "wlr_xwayland_server_destroy".}

proc create_wlr_xwayland*(wl_display: ptr WlDisplay; compositor: ptr WlrCompositor; lazy: bool): ptr WlrXwayland {.importc: "wlr_xwayland_create".}
proc destroy*(wlr_xwayland: ptr WlrXwayland) {.importc: "wlr_xwayland_destroy".}

proc set_cursor*(wlr_xwayland: ptr WlrXwayland; pixels: ptr uint8; stride, width, height: uint32; hotspot_x, hotspot_y: int32) {.importc: "wlr_xwayland_set_cursor".}
proc activate*(surface: ptr WlrXwaylandSurface; activated: bool) {.importc: "wlr_xwayland_surface_activate".}
proc restack*(surface: ptr WlrXwaylandSurface; sibling: ptr WlrXwaylandSurface; mode: xcb_stack_mode_t) {.importc: "wlr_xwayland_surface_restack".}
proc configure*(surface: ptr WlrXwaylandSurface; x, y: int16; width, height: uint16) {.importc: "wlr_xwayland_surface_configure".}
proc close*(surface: ptr WlrXwaylandSurface) {.importc: "wlr_xwayland_surface_close".}

proc set_minimized*(surface: ptr WlrXwaylandSurface; minimized: bool) {.importc: "wlr_xwayland_surface_set_minimized".}
proc set_maximized*(surface: ptr WlrXwaylandSurface; maximized: bool) {.importc: "wlr_xwayland_surface_set_maximized".}
proc set_fullscreen*(surface: ptr WlrXwaylandSurface; fullscreen: bool) {.importc: "wlr_xwayland_surface_set_fullscreen".}
proc set_seat*(xwayland: ptr WlrXwayland; seat: ptr WlrSeat) {.importc: "wlr_xwayland_set_seat".}

proc is_xwayland_surface*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_is_xwayland_surface".}
proc wlr_xwayland_surface_from_wlr_surface*(surface: ptr WlrSurface): ptr WlrXwaylandSurface {.importc: "wlr_xwayland_surface_from_wlr_surface".}
proc ping*(surface: ptr WlrXwaylandSurface) {.importc: "wlr_xwayland_surface_ping".}
proc or_wants_focus*(xsurface: ptr WlrXwaylandSurface): bool {.importc: "wlr_xwayland_or_surface_wants_focus".}
proc create_wlr_xwayland_icccm_input_model*(xsurface: ptr WlrXwaylandSurface): WlrXwaylandIcccmInputModel {.importc: "wlr_xwayland_icccm_input_model".}

{.pop.}
