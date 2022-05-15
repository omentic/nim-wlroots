{.push dynlib: "libwlroots.so".}

discard "forward decl of wlr_xwm"
discard "forward decl of wlr_xwayland_cursor"

type wlr_xwayland_server_options* {.bycopy.} = object
  lazy*: bool
  enable_wm*: bool
  no_touch_pointer_emulation*: bool

type INNER_C_STRUCT_xwayland_47* {.bycopy.} = object
  ready*: wl_signal
  destroy*: wl_signal

type wlr_xwayland_server* {.bycopy.} = object
  pid*: pid_t
  client*: ptr wl_client
  pipe_source*: ptr wl_event_source
  wm_fd*: array[2, cint]
  wl_fd*: array[2, cint]
  server_start*: time_t
  display*: cint
  display_name*: array[16, char]
  x_fd*: array[2, cint]
  x_fd_read_event*: array[2, ptr wl_event_source]
  options*: wlr_xwayland_server_options
  wl_display*: ptr wl_display
  events*: INNER_C_STRUCT_xwayland_47
  client_destroy*: wl_listener
  display_destroy*: wl_listener
  data*: pointer

type wlr_xwayland_server_ready_event* {.bycopy.} = object
  server*: ptr wlr_xwayland_server
  wm_fd*: cint

type INNER_C_STRUCT_xwayland_74* {.bycopy.} = object
  ready*: wl_signal
  new_surface*: wl_signal
  remove_startup_info*: wl_signal

type wlr_xwayland* {.bycopy.} = object
  server*: ptr wlr_xwayland_server
  xwm*: ptr wlr_xwm
  cursor*: ptr wlr_xwayland_cursor
  display_name*: cstring
  wl_display*: ptr wl_display
  compositor*: ptr wlr_compositor
  seat*: ptr wlr_seat
  events*: INNER_C_STRUCT_xwayland_74
  user_event_handler*: proc (xwm: ptr wlr_xwm; event: ptr xcb_generic_event_t): cint
  server_ready*: wl_listener
  server_destroy*: wl_listener
  seat_destroy*: wl_listener
  data*: pointer

type wlr_xwayland_surface_decorations* = enum
  WLR_XWAYLAND_SURFACE_DECORATIONS_ALL = 0,
  WLR_XWAYLAND_SURFACE_DECORATIONS_NO_BORDER = 1,
  WLR_XWAYLAND_SURFACE_DECORATIONS_NO_TITLE = 2

type wlr_xwayland_surface_hints* {.bycopy.} = object
  flags*: uint32_t
  input*: uint32_t
  initial_state*: int32_t
  icon_pixmap*: xcb_pixmap_t
  icon_window*: xcb_window_t
  icon_x*: int32_t
  icon_y*: int32_t
  icon_mask*: xcb_pixmap_t
  window_group*: xcb_window_t

type wlr_xwayland_surface_size_hints* {.bycopy.} = object
  flags*: uint32_t
  x*: int32_t
  y*: int32_t
  width*: int32_t
  height*: int32_t
  min_width*: int32_t
  min_height*: int32_t
  max_width*: int32_t
  max_height*: int32_t
  width_inc*: int32_t
  height_inc*: int32_t
  base_width*: int32_t
  base_height*: int32_t
  min_aspect_num*: int32_t
  min_aspect_den*: int32_t
  max_aspect_num*: int32_t
  max_aspect_den*: int32_t
  win_gravity*: uint32_t

type wlr_xwayland_icccm_input_model* = enum
  WLR_ICCCM_INPUT_MODEL_NONE = 0, WLR_ICCCM_INPUT_MODEL_PASSIVE = 1,
  WLR_ICCCM_INPUT_MODEL_LOCAL = 2, WLR_ICCCM_INPUT_MODEL_GLOBAL = 3

type INNER_C_STRUCT_xwayland_195* {.bycopy.} = object
  destroy*: wl_signal
  request_configure*: wl_signal
  request_move*: wl_signal
  request_resize*: wl_signal
  request_minimize*: wl_signal
  request_maximize*: wl_signal
  request_fullscreen*: wl_signal
  request_activate*: wl_signal
  map*: wl_signal
  unmap*: wl_signal
  set_title*: wl_signal
  set_class*: wl_signal
  set_role*: wl_signal
  set_parent*: wl_signal
  set_pid*: wl_signal
  set_startup_id*: wl_signal
  set_window_type*: wl_signal
  set_hints*: wl_signal
  set_decorations*: wl_signal
  set_override_redirect*: wl_signal
  set_geometry*: wl_signal
  ping_timeout*: wl_signal

type wlr_xwayland_surface* {.bycopy.} = object
  window_id*: xcb_window_t
  xwm*: ptr wlr_xwm
  surface_id*: uint32_t
  link*: wl_list
  stack_link*: wl_list
  unpaired_link*: wl_list
  surface*: ptr wlr_surface
  x*: int16_t
  y*: int16_t
  width*: uint16_t
  height*: uint16_t
  saved_width*: uint16_t
  saved_height*: uint16_t
  override_redirect*: bool
  mapped*: bool
  title*: cstring
  class*: cstring
  instance*: cstring
  role*: cstring
  startup_id*: cstring
  pid*: pid_t
  has_utf8_title*: bool
  children*: wl_list
  parent*: ptr wlr_xwayland_surface
  parent_link*: wl_list
  window_type*: ptr xcb_atom_t
  window_type_len*: csize_t
  protocols*: ptr xcb_atom_t
  protocols_len*: csize_t
  decorations*: uint32_t
  hints*: ptr wlr_xwayland_surface_hints
  hints_urgency*: uint32_t
  size_hints*: ptr wlr_xwayland_surface_size_hints
  pinging*: bool
  ping_timer*: ptr wl_event_source
  modal*: bool
  fullscreen*: bool
  maximized_vert*: bool
  maximized_horz*: bool
  minimized*: bool
  has_alpha*: bool
  events*: INNER_C_STRUCT_xwayland_195
  surface_destroy*: wl_listener
  data*: pointer

type wlr_xwayland_surface_configure_event* {.bycopy.} = object
  surface*: ptr wlr_xwayland_surface
  x*: int16_t
  y*: int16_t
  width*: uint16_t
  height*: uint16_t
  mask*: uint16_t

type wlr_xwayland_move_event* {.bycopy.} = object
  surface*: ptr wlr_xwayland_surface

type wlr_xwayland_remove_startup_info_event* {.bycopy.} = object
  id*: cstring
  window*: xcb_window_t

type wlr_xwayland_resize_event* {.bycopy.} = object
  surface*: ptr wlr_xwayland_surface
  edges*: uint32_t

type wlr_xwayland_minimize_event* {.bycopy.} = object
  surface*: ptr wlr_xwayland_surface
  minimize*: bool

proc wlr_xwayland_server_create*(display: ptr wl_display; options: ptr wlr_xwayland_server_options): ptr wlr_xwayland_server {.importc: "wlr_xwayland_server_create".}
proc wlr_xwayland_server_destroy*(server: ptr wlr_xwayland_server) {.importc: "wlr_xwayland_server_destroy".}
proc wlr_xwayland_create*(wl_display: ptr wl_display; compositor: ptr wlr_compositor; lazy: bool): ptr wlr_xwayland {.importc: "wlr_xwayland_create".}
proc wlr_xwayland_destroy*(wlr_xwayland: ptr wlr_xwayland) {.importc: "wlr_xwayland_destroy".}
proc wlr_xwayland_set_cursor*(wlr_xwayland: ptr wlr_xwayland; pixels: ptr uint8_t; stride: uint32_t; width: uint32_t; height: uint32_t; hotspot_x: int32_t; hotspot_y: int32_t) {.importc: "wlr_xwayland_set_cursor".}
proc wlr_xwayland_surface_activate*(surface: ptr wlr_xwayland_surface; activated: bool) {.importc: "wlr_xwayland_surface_activate".}
proc wlr_xwayland_surface_restack*(surface: ptr wlr_xwayland_surface; sibling: ptr wlr_xwayland_surface; mode: xcb_stack_mode_t) {.importc: "wlr_xwayland_surface_restack".}
proc wlr_xwayland_surface_configure*(surface: ptr wlr_xwayland_surface; x: int16_t; y: int16_t; width: uint16_t; height: uint16_t) {.importc: "wlr_xwayland_surface_configure".}
proc wlr_xwayland_surface_close*(surface: ptr wlr_xwayland_surface) {.importc: "wlr_xwayland_surface_close".}
proc wlr_xwayland_surface_set_minimized*(surface: ptr wlr_xwayland_surface; minimized: bool) {.importc: "wlr_xwayland_surface_set_minimized".}
proc wlr_xwayland_surface_set_maximized*(surface: ptr wlr_xwayland_surface; maximized: bool) {.importc: "wlr_xwayland_surface_set_maximized".}
proc wlr_xwayland_surface_set_fullscreen*(surface: ptr wlr_xwayland_surface; fullscreen: bool) {.importc: "wlr_xwayland_surface_set_fullscreen".}
proc wlr_xwayland_set_seat*(xwayland: ptr wlr_xwayland; seat: ptr wlr_seat) {.importc: "wlr_xwayland_set_seat".}
proc wlr_surface_is_xwayland_surface*(surface: ptr wlr_surface): bool {.importc: "wlr_surface_is_xwayland_surface".}
proc wlr_xwayland_surface_from_wlr_surface*(surface: ptr wlr_surface): ptr wlr_xwayland_surface {.importc: "wlr_xwayland_surface_from_wlr_surface".}
proc wlr_xwayland_surface_ping*(surface: ptr wlr_xwayland_surface) {.importc: "wlr_xwayland_surface_ping".}
proc wlr_xwayland_or_surface_wants_focus*(xsurface: ptr wlr_xwayland_surface): bool {.importc: "wlr_xwayland_or_surface_wants_focus".}
proc wlr_xwayland_icccm_input_model*(xsurface: ptr wlr_xwayland_surface): wlr_xwayland_icccm_input_model {.importc: "wlr_xwayland_icccm_input_model".}

{.pop.}
