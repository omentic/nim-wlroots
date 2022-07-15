{.push dynlib: "libwlroots.so".}

import std/posix
import wayland, xcb, wlroots/types

## shim TODO
type
  Xwm = object
  XwaylandCursor = object

type XwaylandServer_options* {.bycopy.} = object
  lazy*: bool
  enable_wm*: bool
  no_touch_pointer_emulation*: bool

type XwaylandServer_events* {.bycopy.} = object
  ready*: WlSignal
  destroy*: WlSignal

type XwaylandServer* {.bycopy.} = object
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
  options*: XwaylandServer_options
  wl_display*: ptr WlDisplay
  events*: XwaylandServer_events
  client_destroy*: WlListener
  display_destroy*: WlListener
  data*: pointer

type XwaylandServerReadyEvent* {.bycopy.} = object
  server*: ptr XwaylandServer
  wm_fd*: cint

type Xwayland_events* {.bycopy.} = object
  ready*: WlSignal
  new_surface*: WlSignal
  remove_startup_info*: WlSignal

type Xwayland* {.bycopy.} = object
  server*: ptr XwaylandServer
  xwm*: ptr Xwm
  cursor*: ptr XwaylandCursor
  display_name*: cstring
  wl_display*: ptr WlDisplay
  compositor*: ptr Compositor
  seat*: ptr Seat
  events*: Xwayland_events
  user_event_handler*: proc (xwm: ptr Xwm; event: ptr XcbGenericEvent): cint
  server_ready*: WlListener
  server_destroy*: WlListener
  seat_destroy*: WlListener
  data*: pointer

type XwaylandSurfaceDecorations* {.pure.} = enum
  ALL = 0,
  NO_BORDER = 1,
  NO_TITLE = 2

type XwaylandSurfaceHints* {.bycopy.} = object
  flags*: uint32
  input*: uint32
  initial_state*: int32
  icon_pixmap*: XcbPixmap
  icon_window*: XcbWindow
  icon_x*: int32
  icon_y*: int32
  icon_mask*: XcbPixmap
  window_group*: XcbWindow

type XwaylandSurfaceSizeHints* {.bycopy.} = object
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

type XwaylandIcccmInputModel* {.pure.} = enum
  NONE = 0,
  PASSIVE = 1,
  LOCAL = 2,
  GLOBAL = 3

type XwaylandSurface_events* {.bycopy.} = object
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

type XwaylandSurface* {.bycopy.} = object
  window_id*: XcbWindow
  xwm*: ptr Xwm
  surface_id*: uint32
  link*: WlList
  stack_link*: WlList
  unpaired_link*: WlList
  surface*: ptr Surface
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
  parent*: ptr XwaylandSurface
  parent_link*: WlList
  window_type*: ptr XcbAtom
  window_type_len*: csize_t
  protocols*: ptr XcbAtom
  protocols_len*: csize_t
  decorations*: uint32
  hints*: ptr XwaylandSurfaceHints
  hints_urgency*: uint32
  size_hints*: ptr XwaylandSurfaceSizeHints
  pinging*: bool
  ping_timer*: ptr WlEventSource
  modal*: bool
  fullscreen*: bool
  maximized_vert*: bool
  maximized_horz*: bool
  minimized*: bool
  has_alpha*: bool
  events*: XwaylandSurface_events
  surface_destroy*: WlListener
  data*: pointer

type XwaylandSurfaceConfigureEvent* {.bycopy.} = object
  surface*: ptr XwaylandSurface
  x*, y*: int16
  width*, height*: uint16
  mask*: uint16

type XwaylandMoveEvent* {.bycopy.} = object
  surface*: ptr XwaylandSurface

type XwaylandRemoveStartupInfoEvent* {.bycopy.} = object
  id*: cstring
  window*: XcbWindow

type XwaylandResizeEvent* {.bycopy.} = object
  surface*: ptr XwaylandSurface
  edges*: uint32

type XwaylandMinimizeEvent* {.bycopy.} = object
  surface*: ptr XwaylandSurface
  minimize*: bool

proc createXwaylandServer*(display: ptr WlDisplay; options: ptr XwaylandServer_options): ptr XwaylandServer {.importc: "wlr_xwayland_server_create".}
proc destroy*(server: ptr XwaylandServer) {.importc: "wlr_xwayland_server_destroy".}

proc createXwayland*(wl_display: ptr WlDisplay; compositor: ptr Compositor; lazy: bool): ptr Xwayland {.importc: "wlr_xwayland_create".}
proc destroy*(wlr_xwayland: ptr Xwayland) {.importc: "wlr_xwayland_destroy".}

proc setCursor*(wlr_xwayland: ptr Xwayland; pixels: ptr uint8; stride: uint32; width: uint32; height: uint32; hotspot_x: int32; hotspot_y: int32) {.importc: "wlr_xwayland_set_cursor".}
proc activate*(surface: ptr XwaylandSurface; activated: bool) {.importc: "wlr_xwayland_surface_activate".}
proc restack*(surface: ptr XwaylandSurface; sibling: ptr XwaylandSurface; mode: XcbStackMode) {.importc: "wlr_xwayland_surface_restack".}
proc configure*(surface: ptr XwaylandSurface; x: int16; y: int16; width: uint16; height: uint16) {.importc: "wlr_xwayland_surface_configure".}
proc close*(surface: ptr XwaylandSurface) {.importc: "wlr_xwayland_surface_close".}

proc setMinimized*(surface: ptr XwaylandSurface; minimized: bool) {.importc: "wlr_xwayland_surface_set_minimized".}
proc setMaximized*(surface: ptr XwaylandSurface; maximized: bool) {.importc: "wlr_xwayland_surface_set_maximized".}
proc setFullscreen*(surface: ptr XwaylandSurface; fullscreen: bool) {.importc: "wlr_xwayland_surface_set_fullscreen".}
proc setSeat*(xwayland: ptr Xwayland; seat: ptr Seat) {.importc: "wlr_xwayland_set_seat".}

proc isXwaylandSurface*(surface: ptr Surface): bool {.importc: "wlr_surface_is_xwayland_surface".}
proc xwaylandSurfaceFromSurface*(surface: ptr Surface): ptr XwaylandSurface {.importc: "wlr_xwayland_surface_from_wlr_surface".} # XXX: bad name lol
proc ping*(surface: ptr XwaylandSurface) {.importc: "wlr_xwayland_surface_ping".}
proc wantsFocus*(xsurface: ptr XwaylandSurface): bool {.importc: "wlr_xwayland_or_surface_wants_focus".}
proc xwaylandIcccmInputModel*(xsurface: ptr XwaylandSurface): XwaylandIcccmInputModel {.importc: "wlr_xwayland_icccm_input_model".}

{.pop.}
