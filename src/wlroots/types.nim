{.push dynlib: "libwlroots.so".}

## XXX: wlr_box?

## wlr_buffer

discard "forward decl of wlr_buffer"
discard "forward decl of wlr_renderer"
type wlr_shm_attributes* {.bycopy.} = object
  fd*: cint
  format*: uint32_t
  width*: cint
  height*: cint
  stride*: cint
  offset*: off_t

type wlr_buffer_impl* {.bycopy.} = object
  destroy*: proc (buffer: ptr wlr_buffer)
  get_dmabuf*: proc (buffer: ptr wlr_buffer; attribs: ptr wlr_dmabuf_attributes): bool
  get_shm*: proc (buffer: ptr wlr_buffer; attribs: ptr wlr_shm_attributes): bool
  begin_data_ptr_access*: proc (buffer: ptr wlr_buffer; flags: uint32_t; data: ptr pointer; format: ptr uint32_t; stride: ptr csize_t): bool
  end_data_ptr_access*: proc (buffer: ptr wlr_buffer)

type wlr_buffer_cap* = enum
  WLR_BUFFER_CAP_DATA_PTR = 1 shl 0, WLR_BUFFER_CAP_DMABUF = 1 shl 1,
  WLR_BUFFER_CAP_SHM = 1 shl 2

type INNER_C_STRUCT_wlr_buffer_68* {.bycopy.} = object
  destroy*: wl_signal
  release*: wl_signal

type wlr_buffer* {.bycopy.} = object
  impl*: ptr wlr_buffer_impl
  width*: cint
  height*: cint
  dropped*: bool
  n_locks*: csize_t
  accessing_data_ptr*: bool
  events*: INNER_C_STRUCT_wlr_buffer_68
  addons*: wlr_addon_set

type wlr_buffer_resource_interface* {.bycopy.} = object
  name*: cstring
  is_instance*: proc (resource: ptr wl_resource): bool
  from_resource*: proc (resource: ptr wl_resource): ptr wlr_buffer

proc wlr_buffer_init*(buffer: ptr wlr_buffer; impl: ptr wlr_buffer_impl; width: cint; height: cint) {.importc: "wlr_buffer_init".}
proc wlr_buffer_drop*(buffer: ptr wlr_buffer) {.importc: "wlr_buffer_drop".}
proc wlr_buffer_lock*(buffer: ptr wlr_buffer): ptr wlr_buffer {.importc: "wlr_buffer_lock".}
proc wlr_buffer_unlock*(buffer: ptr wlr_buffer) {.importc: "wlr_buffer_unlock".}
proc wlr_buffer_get_dmabuf*(buffer: ptr wlr_buffer; attribs: ptr wlr_dmabuf_attributes): bool {.importc: "wlr_buffer_get_dmabuf".}
proc wlr_buffer_get_shm*(buffer: ptr wlr_buffer; attribs: ptr wlr_shm_attributes): bool {.importc: "wlr_buffer_get_shm".}
proc wlr_buffer_register_resource_interface*(iface: ptr wlr_buffer_resource_interface) {.importc: "wlr_buffer_register_resource_interface".}
proc wlr_buffer_from_resource*(resource: ptr wl_resource): ptr wlr_buffer {.importc: "wlr_buffer_from_resource".}

type wlr_buffer_data_ptr_access_flag* = enum
  WLR_BUFFER_DATA_PTR_ACCESS_READ = 1 shl 0,
  WLR_BUFFER_DATA_PTR_ACCESS_WRITE = 1 shl 1

proc wlr_buffer_begin_data_ptr_access*(buffer: ptr wlr_buffer; flags: uint32_t; data: ptr pointer; format: ptr uint32_t; stride: ptr csize_t): bool {.importc: "wlr_buffer_begin_data_ptr_access".}
proc wlr_buffer_end_data_ptr_access*(buffer: ptr wlr_buffer) {.importc: "wlr_buffer_end_data_ptr_access".}

type wlr_client_buffer* {.bycopy.} = object
  base*: wlr_buffer
  texture*: ptr wlr_texture
  source*: ptr wlr_buffer
  source_destroy*: wl_listener
  shm_source_format*: uint32_t

proc wlr_client_buffer_create*(buffer: ptr wlr_buffer; renderer: ptr wlr_renderer): ptr wlr_client_buffer {.importc: "wlr_client_buffer_create".}
proc wlr_client_buffer_get*(buffer: ptr wlr_buffer): ptr wlr_client_buffer {.importc: "wlr_client_buffer_get".}
proc wlr_resource_is_buffer*(resource: ptr wl_resource): bool {.importc: "wlr_resource_is_buffer".}
proc wlr_client_buffer_apply_damage*(client_buffer: ptr wlr_client_buffer; next: ptr wlr_buffer; damage: ptr pixman_region32_t): bool {.importc: "wlr_client_buffer_apply_damage".}

## wlr_compositor

discard "forward decl of wlr_surface"
type wlr_subcompositor* {.bycopy.} = object
  global*: ptr wl_global

type INNER_C_STRUCT_wlr_compositor_30* {.bycopy.} = object
  new_surface*: wl_signal
  destroy*: wl_signal

type wlr_compositor* {.bycopy.} = object
  global*: ptr wl_global
  renderer*: ptr wlr_renderer
  subcompositor*: wlr_subcompositor
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_compositor_30

proc wlr_compositor_create*(display: ptr wl_display; renderer: ptr wlr_renderer): ptr wlr_compositor {.importc: "wlr_compositor_create".}
proc wlr_surface_is_subsurface*(surface: ptr wlr_surface): bool {.importc: "wlr_surface_is_subsurface".}
proc wlr_subsurface_from_wlr_surface*(surface: ptr wlr_surface): ptr wlr_subsurface {.importc: "wlr_subsurface_from_wlr_surface".}

## wlr_cursor

discard "forward decl of wlr_box"
discard "forward decl of wlr_cursor_state"
type INNER_C_STRUCT_wlr_cursor_50* {.bycopy.} = object
  motion*: wl_signal
  motion_absolute*: wl_signal
  button*: wl_signal
  axis*: wl_signal
  frame*: wl_signal
  swipe_begin*: wl_signal
  swipe_update*: wl_signal
  swipe_end*: wl_signal
  pinch_begin*: wl_signal
  pinch_update*: wl_signal
  pinch_end*: wl_signal
  hold_begin*: wl_signal
  hold_end*: wl_signal
  touch_up*: wl_signal
  touch_down*: wl_signal
  touch_motion*: wl_signal
  touch_cancel*: wl_signal
  touch_frame*: wl_signal
  tablet_tool_axis*: wl_signal
  tablet_tool_proximity*: wl_signal
  tablet_tool_tip*: wl_signal
  tablet_tool_button*: wl_signal

type wlr_cursor* {.bycopy.} = object
  state*: ptr wlr_cursor_state
  x*: cdouble
  y*: cdouble
  events*: INNER_C_STRUCT_wlr_cursor_50
  data*: pointer

proc wlr_cursor_create*(): ptr wlr_cursor {.importc: "wlr_cursor_create".}
proc wlr_cursor_destroy*(cur: ptr wlr_cursor) {.importc: "wlr_cursor_destroy".}
proc wlr_cursor_warp*(cur: ptr wlr_cursor; dev: ptr wlr_input_device; lx: cdouble; ly: cdouble): bool {.importc: "wlr_cursor_warp".}
proc wlr_cursor_absolute_to_layout_coords*(cur: ptr wlr_cursor; dev: ptr wlr_input_device; x: cdouble; y: cdouble; lx: ptr cdouble; ly: ptr cdouble) {.importc: "wlr_cursor_absolute_to_layout_coords".}
proc wlr_cursor_warp_closest*(cur: ptr wlr_cursor; dev: ptr wlr_input_device; x: cdouble; y: cdouble) {.importc: "wlr_cursor_warp_closest".}
proc wlr_cursor_warp_absolute*(cur: ptr wlr_cursor; dev: ptr wlr_input_device; x: cdouble; y: cdouble) {.importc: "wlr_cursor_warp_absolute".}
proc wlr_cursor_move*(cur: ptr wlr_cursor; dev: ptr wlr_input_device; delta_x: cdouble; delta_y: cdouble) {.importc: "wlr_cursor_move".}
proc wlr_cursor_set_image*(cur: ptr wlr_cursor; pixels: ptr uint8_t; stride: int32_t; width: uint32_t; height: uint32_t; hotspot_x: int32_t; hotspot_y: int32_t; scale: cfloat) {.importc: "wlr_cursor_set_image".}
proc wlr_cursor_set_surface*(cur: ptr wlr_cursor; surface: ptr wlr_surface; hotspot_x: int32_t; hotspot_y: int32_t) {.importc: "wlr_cursor_set_surface".}
proc wlr_cursor_attach_input_device*(cur: ptr wlr_cursor; dev: ptr wlr_input_device) {.importc: "wlr_cursor_attach_input_device".}
proc wlr_cursor_detach_input_device*(cur: ptr wlr_cursor; dev: ptr wlr_input_device) {.importc: "wlr_cursor_detach_input_device".}
proc wlr_cursor_attach_output_layout*(cur: ptr wlr_cursor; l: ptr wlr_output_layout) {.importc: "wlr_cursor_attach_output_layout".}
proc wlr_cursor_map_to_output*(cur: ptr wlr_cursor; output: ptr wlr_output) {.importc: "wlr_cursor_map_to_output".}
proc wlr_cursor_map_input_to_output*(cur: ptr wlr_cursor; dev: ptr wlr_input_device; output: ptr wlr_output) {.importc: "wlr_cursor_map_input_to_output".}
proc wlr_cursor_map_to_region*(cur: ptr wlr_cursor; box: ptr wlr_box) {.importc: "wlr_cursor_map_to_region".}
proc wlr_cursor_map_input_to_region*(cur: ptr wlr_cursor; dev: ptr wlr_input_device; box: ptr wlr_box) {.importc: "wlr_cursor_map_input_to_region".}

## wlr_data_control_v1

type INNER_C_STRUCT_wlr_data_control_v1_20* {.bycopy.} = object
  destroy*: wl_signal
  new_device*: wl_signal

type wlr_data_control_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  devices*: wl_list
  events*: INNER_C_STRUCT_wlr_data_control_v1_20
  display_destroy*: wl_listener

type wlr_data_control_device_v1* {.bycopy.} = object
  resource*: ptr wl_resource
  manager*: ptr wlr_data_control_manager_v1
  link*: wl_list
  seat*: ptr wlr_seat
  selection_offer_resource*: ptr wl_resource
  primary_selection_offer_resource*: ptr wl_resource
  seat_destroy*: wl_listener
  seat_set_selection*: wl_listener
  seat_set_primary_selection*: wl_listener

proc wlr_data_control_manager_v1_create*(display: ptr wl_display): ptr wlr_data_control_manager_v1 {.importc: "wlr_data_control_manager_v1_create".}
proc wlr_data_control_device_v1_destroy*(device: ptr wlr_data_control_device_v1) {.importc: "wlr_data_control_device_v1_destroy".}

## wlr_data_device

var wlr_data_device_pointer_drag_interface*: wlr_pointer_grab_interface
var wlr_data_device_keyboard_drag_interface*: wlr_keyboard_grab_interface
var wlr_data_device_touch_drag_interface*: wlr_touch_grab_interface

type INNER_C_STRUCT_wlr_data_device_31* {.bycopy.} = object
  destroy*: wl_signal

type wlr_data_device_manager* {.bycopy.} = object
  global*: ptr wl_global
  data_sources*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_data_device_31
  data*: pointer

type wlr_data_offer_type* = enum
  WLR_DATA_OFFER_SELECTION, WLR_DATA_OFFER_DRAG

type wlr_data_offer* {.bycopy.} = object
  resource*: ptr wl_resource
  source*: ptr wlr_data_source
  `type`*: wlr_data_offer_type
  link*: wl_list
  actions*: uint32_t
  preferred_action*: wl_data_device_manager_dnd_action
  in_ask*: bool
  source_destroy*: wl_listener

type wlr_data_source_impl* {.bycopy.} = object
  send*: proc (source: ptr wlr_data_source; mime_type: cstring; fd: int32_t)
  accept*: proc (source: ptr wlr_data_source; serial: uint32_t; mime_type: cstring)
  destroy*: proc (source: ptr wlr_data_source)
  dnd_drop*: proc (source: ptr wlr_data_source)
  dnd_finish*: proc (source: ptr wlr_data_source)
  dnd_action*: proc (source: ptr wlr_data_source; action: wl_data_device_manager_dnd_action)

type INNER_C_STRUCT_wlr_data_device_87* {.bycopy.} = object
  destroy*: wl_signal

type wlr_data_source* {.bycopy.} = object
  impl*: ptr wlr_data_source_impl
  mime_types*: wl_array
  actions*: int32_t
  accepted*: bool
  current_dnd_action*: wl_data_device_manager_dnd_action
  compositor_action*: uint32_t
  events*: INNER_C_STRUCT_wlr_data_device_87

discard "forward decl of wlr_drag"
type INNER_C_STRUCT_wlr_data_device_99* {.bycopy.} = object
  map*: wl_signal
  unmap*: wl_signal
  destroy*: wl_signal

type wlr_drag_icon* {.bycopy.} = object
  drag*: ptr wlr_drag
  surface*: ptr wlr_surface
  mapped*: bool
  events*: INNER_C_STRUCT_wlr_data_device_99
  surface_destroy*: wl_listener
  data*: pointer

type wlr_drag_grab_type* = enum
  WLR_DRAG_GRAB_KEYBOARD, WLR_DRAG_GRAB_KEYBOARD_POINTER,
  WLR_DRAG_GRAB_KEYBOARD_TOUCH

type INNER_C_STRUCT_wlr_data_device_133* {.bycopy.} = object
  focus*: wl_signal
  motion*: wl_signal
  drop*: wl_signal
  destroy*: wl_signal

type wlr_drag* {.bycopy.} = object
  grab_type*: wlr_drag_grab_type
  keyboard_grab*: wlr_seat_keyboard_grab
  pointer_grab*: wlr_seat_pointer_grab
  touch_grab*: wlr_seat_touch_grab
  seat*: ptr wlr_seat
  seat_client*: ptr wlr_seat_client
  focus_client*: ptr wlr_seat_client
  icon*: ptr wlr_drag_icon
  focus*: ptr wlr_surface
  source*: ptr wlr_data_source
  started*: bool
  dropped*: bool
  cancelling*: bool
  grab_touch_id*: int32_t
  touch_id*: int32_t
  events*: INNER_C_STRUCT_wlr_data_device_133
  source_destroy*: wl_listener
  seat_client_destroy*: wl_listener
  icon_destroy*: wl_listener
  data*: pointer

type wlr_drag_motion_event* {.bycopy.} = object
  drag*: ptr wlr_drag
  time*: uint32_t
  sx*: cdouble
  sy*: cdouble

type wlr_drag_drop_event* {.bycopy.} = object
  drag*: ptr wlr_drag
  time*: uint32_t

proc wlr_data_device_manager_create*(display: ptr wl_display): ptr wlr_data_device_manager {.importc: "wlr_data_device_manager_create".}
proc wlr_seat_request_set_selection*(seat: ptr wlr_seat; client: ptr wlr_seat_client; source: ptr wlr_data_source; serial: uint32_t) {.importc: "wlr_seat_request_set_selection".}
proc wlr_seat_set_selection*(seat: ptr wlr_seat; source: ptr wlr_data_source; serial: uint32_t) {.importc: "wlr_seat_set_selection".}
proc wlr_drag_create*(seat_client: ptr wlr_seat_client; source: ptr wlr_data_source; icon_surface: ptr wlr_surface): ptr wlr_drag {.importc: "wlr_drag_create".}
proc wlr_seat_request_start_drag*(seat: ptr wlr_seat; drag: ptr wlr_drag; origin: ptr wlr_surface; serial: uint32_t) {.importc: "wlr_seat_request_start_drag".}
proc wlr_seat_start_drag*(seat: ptr wlr_seat; drag: ptr wlr_drag; serial: uint32_t) {.importc: "wlr_seat_start_drag".}
proc wlr_seat_start_pointer_drag*(seat: ptr wlr_seat; drag: ptr wlr_drag; serial: uint32_t) {.importc: "wlr_seat_start_pointer_drag".}
proc wlr_seat_start_touch_drag*(seat: ptr wlr_seat; drag: ptr wlr_drag; serial: uint32_t; point: ptr wlr_touch_point) {.importc: "wlr_seat_start_touch_drag".}
proc wlr_data_source_init*(source: ptr wlr_data_source; impl: ptr wlr_data_source_impl) {.importc: "wlr_data_source_init".}
proc wlr_data_source_send*(source: ptr wlr_data_source; mime_type: cstring; fd: int32_t) {.importc: "wlr_data_source_send".}
proc wlr_data_source_accept*(source: ptr wlr_data_source; serial: uint32_t; mime_type: cstring) {.importc: "wlr_data_source_accept".}
proc wlr_data_source_destroy*(source: ptr wlr_data_source) {.importc: "wlr_data_source_destroy".}
proc wlr_data_source_dnd_drop*(source: ptr wlr_data_source) {.importc: "wlr_data_source_dnd_drop".}
proc wlr_data_source_dnd_finish*(source: ptr wlr_data_source) {.importc: "wlr_data_source_dnd_finish".}
proc wlr_data_source_dnd_action*(source: ptr wlr_data_source; action: wl_data_device_manager_dnd_action) {.importc: "wlr_data_source_dnd_action".}

## wlr_drm_lease_v1

discard "forward decl of wlr_backend"
discard "forward decl of wlr_output"
type INNER_C_STRUCT_wlr_drm_lease_v1_30* {.bycopy.} = object
  request*: wl_signal

type wlr_drm_lease_v1_manager* {.bycopy.} = object
  devices*: wl_list
  display*: ptr wl_display
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_drm_lease_v1_30

type wlr_drm_lease_device_v1* {.bycopy.} = object
  resources*: wl_list
  global*: ptr wl_global
  manager*: ptr wlr_drm_lease_v1_manager
  backend*: ptr wlr_backend
  connectors*: wl_list
  leases*: wl_list
  requests*: wl_list
  link*: wl_list
  backend_destroy*: wl_listener
  data*: pointer

discard "forward decl of wlr_drm_lease_v1"
type wlr_drm_lease_connector_v1* {.bycopy.} = object
  resources*: wl_list
  output*: ptr wlr_output
  device*: ptr wlr_drm_lease_device_v1
  active_lease*: ptr wlr_drm_lease_v1
  destroy*: wl_listener
  link*: wl_list

type wlr_drm_lease_request_v1* {.bycopy.} = object
  resource*: ptr wl_resource
  device*: ptr wlr_drm_lease_device_v1
  connectors*: ptr ptr wlr_drm_lease_connector_v1
  n_connectors*: csize_t
  lease*: ptr wlr_drm_lease_v1
  invalid*: bool
  link*: wl_list

type wlr_drm_lease_v1* {.bycopy.} = object
  resource*: ptr wl_resource
  drm_lease*: ptr wlr_drm_lease
  device*: ptr wlr_drm_lease_device_v1
  connectors*: ptr ptr wlr_drm_lease_connector_v1
  n_connectors*: csize_t
  link*: wl_list
  destroy*: wl_listener
  data*: pointer

proc wlr_drm_lease_v1_manager_create*(display: ptr wl_display; backend: ptr wlr_backend): ptr wlr_drm_lease_v1_manager {.importc: "wlr_drm_lease_v1_manager_create".}
proc wlr_drm_lease_v1_manager_offer_output*(manager: ptr wlr_drm_lease_v1_manager; output: ptr wlr_output): bool {.importc: "wlr_drm_lease_v1_manager_offer_output".}
proc wlr_drm_lease_v1_manager_withdraw_output*(manager: ptr wlr_drm_lease_v1_manager; output: ptr wlr_output) {.importc: "wlr_drm_lease_v1_manager_withdraw_output".}
proc wlr_drm_lease_request_v1_grant*(request: ptr wlr_drm_lease_request_v1): ptr wlr_drm_lease_v1 {.importc: "wlr_drm_lease_request_v1_grant".}
proc wlr_drm_lease_request_v1_reject*(request: ptr wlr_drm_lease_request_v1) {.importc: "wlr_drm_lease_request_v1_reject".}
proc wlr_drm_lease_v1_revoke*(lease: ptr wlr_drm_lease_v1) {.importc: "wlr_drm_lease_v1_revoke".}

## wlr_drm

discard "forward decl of wlr_renderer"
type wlr_drm_buffer* {.bycopy.} = object
  base*: wlr_buffer
  resource*: ptr wl_resource
  dmabuf*: wlr_dmabuf_attributes
  release*: wl_listener

type INNER_C_STRUCT_wlr_drm_37* {.bycopy.} = object
  destroy*: wl_signal

type wlr_drm* {.bycopy.} = object
  global*: ptr wl_global
  renderer*: ptr wlr_renderer
  node_name*: cstring
  events*: INNER_C_STRUCT_wlr_drm_37
  display_destroy*: wl_listener
  renderer_destroy*: wl_listener

proc wlr_drm_buffer_is_resource*(resource: ptr wl_resource): bool {.importc: "wlr_drm_buffer_is_resource".}
proc wlr_drm_buffer_from_resource*(resource: ptr wl_resource): ptr wlr_drm_buffer {.importc: "wlr_drm_buffer_from_resource".}
proc wlr_drm_create*(display: ptr wl_display; renderer: ptr wlr_renderer): ptr wlr_drm {.importc: "wlr_drm_create".}

## wlr_export_dmabuf_v1

type INNER_C_STRUCT_wlr_export_dmabuf_v1_23* {.bycopy.} = object
  destroy*: wl_signal

type wlr_export_dmabuf_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  frames*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_export_dmabuf_v1_23

type wlr_export_dmabuf_frame_v1* {.bycopy.} = object
  resource*: ptr wl_resource
  manager*: ptr wlr_export_dmabuf_manager_v1
  link*: wl_list
  output*: ptr wlr_output
  cursor_locked*: bool
  output_commit*: wl_listener

proc wlr_export_dmabuf_manager_v1_create*(display: ptr wl_display): ptr wlr_export_dmabuf_manager_v1 {.importc: "wlr_export_dmabuf_manager_v1_create".}

## wlr_foreign_toplevel_manager

type INNER_C_STRUCT_wlr_foreign_toplevel_management_v1_24* {.bycopy.} = object
  destroy*: wl_signal

type wlr_foreign_toplevel_manager_v1* {.bycopy.} = object
  event_loop*: ptr wl_event_loop
  global*: ptr wl_global
  resources*: wl_list
  toplevels*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_foreign_toplevel_management_v1_24
  data*: pointer

type wlr_foreign_toplevel_handle_v1_state* = enum
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MAXIMIZED = (1 shl 0),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MINIMIZED = (1 shl 1),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_ACTIVATED = (1 shl 2),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_FULLSCREEN = (1 shl 3)

type wlr_foreign_toplevel_handle_v1_output* {.bycopy.} = object
  link*: wl_list
  output*: ptr wlr_output
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  output_bind*: wl_listener
  output_destroy*: wl_listener

type INNER_C_STRUCT_wlr_foreign_toplevel_management_v1_62* {.bycopy.} = object
  request_maximize*: wl_signal
  request_minimize*: wl_signal
  request_activate*: wl_signal
  request_fullscreen*: wl_signal
  request_close*: wl_signal
  set_rectangle*: wl_signal
  destroy*: wl_signal

type wlr_foreign_toplevel_handle_v1* {.bycopy.} = object
  manager*: ptr wlr_foreign_toplevel_manager_v1
  resources*: wl_list
  link*: wl_list
  idle_source*: ptr wl_event_source
  title*: cstring
  app_id*: cstring
  parent*: ptr wlr_foreign_toplevel_handle_v1
  outputs*: wl_list
  state*: uint32_t
  events*: INNER_C_STRUCT_wlr_foreign_toplevel_management_v1_62
  data*: pointer

type wlr_foreign_toplevel_handle_v1_maximized_event* {.bycopy.} = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  maximized*: bool

type wlr_foreign_toplevel_handle_v1_minimized_event* {.bycopy.} = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  minimized*: bool

type wlr_foreign_toplevel_handle_v1_activated_event* {.bycopy.} = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  seat*: ptr wlr_seat

type wlr_foreign_toplevel_handle_v1_fullscreen_event* {.bycopy.} = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  fullscreen*: bool
  output*: ptr wlr_output

type wlr_foreign_toplevel_handle_v1_set_rectangle_event* {.bycopy.} = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  surface*: ptr wlr_surface
  x*: int32_t
  y*: int32_t
  width*: int32_t
  height*: int32_t

proc wlr_foreign_toplevel_manager_v1_create*(display: ptr wl_display): ptr wlr_foreign_toplevel_manager_v1 {.importc: "wlr_foreign_toplevel_manager_v1_create".}
proc wlr_foreign_toplevel_handle_v1_create*(manager: ptr wlr_foreign_toplevel_manager_v1): ptr wlr_foreign_toplevel_handle_v1 {.importc: "wlr_foreign_toplevel_handle_v1_create".}

proc wlr_foreign_toplevel_handle_v1_destroy*(toplevel: ptr wlr_foreign_toplevel_handle_v1) {.importc: "wlr_foreign_toplevel_handle_v1_destroy".}
proc wlr_foreign_toplevel_handle_v1_set_title*(toplevel: ptr wlr_foreign_toplevel_handle_v1; title: cstring) {.importc: "wlr_foreign_toplevel_handle_v1_set_title".}
proc wlr_foreign_toplevel_handle_v1_set_app_id*(toplevel: ptr wlr_foreign_toplevel_handle_v1; app_id: cstring) {.importc: "wlr_foreign_toplevel_handle_v1_set_app_id".}
proc wlr_foreign_toplevel_handle_v1_output_enter*(toplevel: ptr wlr_foreign_toplevel_handle_v1; output: ptr wlr_output) {.importc: "wlr_foreign_toplevel_handle_v1_output_enter".}
proc wlr_foreign_toplevel_handle_v1_output_leave*(toplevel: ptr wlr_foreign_toplevel_handle_v1; output: ptr wlr_output) {.importc: "wlr_foreign_toplevel_handle_v1_output_leave".}
proc wlr_foreign_toplevel_handle_v1_set_maximized*(toplevel: ptr wlr_foreign_toplevel_handle_v1; maximized: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_maximized".}
proc wlr_foreign_toplevel_handle_v1_set_minimized*(toplevel: ptr wlr_foreign_toplevel_handle_v1; minimized: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_minimized".}
proc wlr_foreign_toplevel_handle_v1_set_activated*(toplevel: ptr wlr_foreign_toplevel_handle_v1; activated: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_activated".}
proc wlr_foreign_toplevel_handle_v1_set_fullscreen*(toplevel: ptr wlr_foreign_toplevel_handle_v1; fullscreen: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_fullscreen".}

proc wlr_foreign_toplevel_handle_v1_set_parent*(toplevel: ptr wlr_foreign_toplevel_handle_v1; parent: ptr wlr_foreign_toplevel_handle_v1) {.importc: "wlr_foreign_toplevel_handle_v1_set_parent".}

## wlr_fullscreen_shell_v1

import fullscreen-shell-unstable-v1-protocol

type INNER_C_STRUCT_wlr_fullscreen_shell_v1_19* {.bycopy.} = object
  destroy*: wl_signal
  present_surface*: wl_signal

type wlr_fullscreen_shell_v1* {.bycopy.} = object
  global*: ptr wl_global
  events*: INNER_C_STRUCT_wlr_fullscreen_shell_v1_19
  display_destroy*: wl_listener
  data*: pointer

type wlr_fullscreen_shell_v1_present_surface_event* {.bycopy.} = object
  client*: ptr wl_client
  surface*: ptr wlr_surface
  `method`*: zwp_fullscreen_shell_v1_present_method
  output*: ptr wlr_output

proc wlr_fullscreen_shell_v1_create*(display: ptr wl_display): ptr wlr_fullscreen_shell_v1 {.importc: "wlr_fullscreen_shell_v1_create".}

type INNER_C_STRUCT_wlr_gamma_control_v1_13* {.bycopy.} = object
  destroy*: wl_signal

type wlr_gamma_control_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  controls*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_gamma_control_v1_13
  data*: pointer

type wlr_gamma_control_v1* {.bycopy.} = object
  resource*: ptr wl_resource
  output*: ptr wlr_output
  link*: wl_list
  table*: ptr uint16_t
  ramp_size*: csize_t
  output_commit_listener*: wl_listener
  output_destroy_listener*: wl_listener
  data*: pointer

proc wlr_gamma_control_manager_v1_create*(display: ptr wl_display): ptr wlr_gamma_control_manager_v1 {.importc: "wlr_gamma_control_manager_v1_create".}

## wlr_idle_inhibit_v1

type INNER_C_STRUCT_wlr_idle_inhibit_v1_33* {.bycopy.} = object
  new_inhibitor*: wl_signal
  destroy*: wl_signal

type wlr_idle_inhibit_manager_v1* {.bycopy.} = object
  inhibitors*: wl_list
  global*: ptr wl_global
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_idle_inhibit_v1_33
  data*: pointer

type INNER_C_STRUCT_wlr_idle_inhibit_v1_48* {.bycopy.} = object
  destroy*: wl_signal

type wlr_idle_inhibitor_v1* {.bycopy.} = object
  surface*: ptr wlr_surface
  resource*: ptr wl_resource
  surface_destroy*: wl_listener
  link*: wl_list
  events*: INNER_C_STRUCT_wlr_idle_inhibit_v1_48
  data*: pointer

proc wlr_idle_inhibit_v1_create*(display: ptr wl_display): ptr wlr_idle_inhibit_manager_v1 {.importc: "wlr_idle_inhibit_v1_create".}

## wlr_idle

type INNER_C_STRUCT_wlr_idle_32* {.bycopy.} = object
  activity_notify*: wl_signal
  destroy*: wl_signal

type wlr_idle* {.bycopy.} = object
  global*: ptr wl_global
  idle_timers*: wl_list
  event_loop*: ptr wl_event_loop
  enabled*: bool
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_idle_32
  data*: pointer

type INNER_C_STRUCT_wlr_idle_50* {.bycopy.} = object
  idle*: wl_signal
  resume*: wl_signal
  destroy*: wl_signal

type wlr_idle_timeout* {.bycopy.} = object
  resource*: ptr wl_resource
  link*: wl_list
  seat*: ptr wlr_seat
  idle_source*: ptr wl_event_source
  idle_state*: bool
  enabled*: bool
  timeout*: uint32_t
  events*: INNER_C_STRUCT_wlr_idle_50
  input_listener*: wl_listener
  seat_destroy*: wl_listener
  data*: pointer

proc wlr_idle_create*(display: ptr wl_display): ptr wlr_idle {.importc: "wlr_idle_create".}
proc wlr_idle_notify_activity*(idle: ptr wlr_idle; seat: ptr wlr_seat) {.importc: "wlr_idle_notify_activity".}
proc wlr_idle_set_enabled*(idle: ptr wlr_idle; seat: ptr wlr_seat; enabled: bool) {.importc: "wlr_idle_set_enabled".}
proc wlr_idle_timeout_create*(idle: ptr wlr_idle; seat: ptr wlr_seat; timeout: uint32_t): ptr wlr_idle_timeout {.importc: "wlr_idle_timeout_create".}
proc wlr_idle_timeout_destroy*(timeout: ptr wlr_idle_timeout) {.importc: "wlr_idle_timeout_destroy".}

## wlr_input_device

type wlr_button_state* = enum
  WLR_BUTTON_RELEASED, WLR_BUTTON_PRESSED

type wlr_input_device_type* = enum
  WLR_INPUT_DEVICE_KEYBOARD, WLR_INPUT_DEVICE_POINTER, WLR_INPUT_DEVICE_TOUCH,
  WLR_INPUT_DEVICE_TABLET_TOOL, WLR_INPUT_DEVICE_TABLET_PAD,
  WLR_INPUT_DEVICE_SWITCH

discard "forward decl of wlr_input_device_impl"
type INNER_C_UNION_wlr_input_device_42* {.bycopy, union.} = object
  _device*: pointer
  keyboard*: ptr wlr_keyboard
  pointer*: ptr wlr_pointer
  switch_device*: ptr wlr_switch
  touch*: ptr wlr_touch
  tablet*: ptr wlr_tablet
  tablet_pad*: ptr wlr_tablet_pad

type INNER_C_STRUCT_wlr_input_device_52* {.bycopy.} = object
  destroy*: wl_signal

type wlr_input_device* {.bycopy.} = object
  impl*: ptr wlr_input_device_impl
  `type`*: wlr_input_device_type
  vendor*: cuint
  product*: cuint
  name*: cstring
  width_mm*: cdouble
  height_mm*: cdouble
  output_name*: cstring
  ano_wlr_input_device_49*: INNER_C_UNION_wlr_input_device_42
  events*: INNER_C_STRUCT_wlr_input_device_52
  data*: pointer

## wlr_input_inhibitor

type INNER_C_STRUCT_wlr_input_inhibitor_21* {.bycopy.} = object
  activate*: wl_signal
  deactivate*: wl_signal
  destroy*: wl_signal

type wlr_input_inhibit_manager* {.bycopy.} = object
  global*: ptr wl_global
  active_client*: ptr wl_client
  active_inhibitor*: ptr wl_resource
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_input_inhibitor_21
  data*: pointer

proc wlr_input_inhibit_manager_create*(display: ptr wl_display): ptr wlr_input_inhibit_manager {.importc: "wlr_input_inhibit_manager_create".}

## wlr_input_method_v2

type wlr_input_method_v2_preedit_string* {.bycopy.} = object
  text*: cstring
  cursor_begin*: int32_t
  cursor_end*: int32_t

type wlr_input_method_v2_delete_surrounding_text* {.bycopy.} = object
  before_length*: uint32_t
  after_length*: uint32_t

type wlr_input_method_v2_state* {.bycopy.} = object
  preedit*: wlr_input_method_v2_preedit_string
  commit_text*: cstring
  delete*: wlr_input_method_v2_delete_surrounding_text

type INNER_C_STRUCT_wlr_input_method_v2_54* {.bycopy.} = object
  commit*: wl_signal
  new_popup_surface*: wl_signal
  grab_keyboard*: wl_signal
  destroy*: wl_signal

type wlr_input_method_v2* {.bycopy.} = object
  resource*: ptr wl_resource
  seat*: ptr wlr_seat
  seat_client*: ptr wlr_seat_client
  pending*: wlr_input_method_v2_state
  current*: wlr_input_method_v2_state
  active*: bool
  client_active*: bool
  current_serial*: uint32_t
  popup_surfaces*: wl_list
  keyboard_grab*: ptr wlr_input_method_keyboard_grab_v2
  link*: wl_list
  seat_client_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_input_method_v2_54

type INNER_C_STRUCT_wlr_input_method_v2_72* {.bycopy.} = object
  map*: wl_signal
  unmap*: wl_signal
  destroy*: wl_signal

type wlr_input_popup_surface_v2* {.bycopy.} = object
  resource*: ptr wl_resource
  input_method*: ptr wlr_input_method_v2
  link*: wl_list
  mapped*: bool
  surface*: ptr wlr_surface
  surface_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_input_method_v2_72
  data*: pointer

type INNER_C_STRUCT_wlr_input_method_v2_90* {.bycopy.} = object
  destroy*: wl_signal

type wlr_input_method_keyboard_grab_v2* {.bycopy.} = object
  resource*: ptr wl_resource
  input_method*: ptr wlr_input_method_v2
  keyboard*: ptr wlr_keyboard
  keyboard_keymap*: wl_listener
  keyboard_repeat_info*: wl_listener
  keyboard_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_input_method_v2_90

type INNER_C_STRUCT_wlr_input_method_v2_101* {.bycopy.} = object
  input_method*: wl_signal
  destroy*: wl_signal

type wlr_input_method_manager_v2* {.bycopy.} = object
  global*: ptr wl_global
  input_methods*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_input_method_v2_101

proc wlr_input_method_manager_v2_create*(display: ptr wl_display): ptr wlr_input_method_manager_v2 {.importc: "wlr_input_method_manager_v2_create".}
proc wlr_input_method_v2_send_activate*(input_method: ptr wlr_input_method_v2) {.importc: "wlr_input_method_v2_send_activate".}
proc wlr_input_method_v2_send_deactivate*(input_method: ptr wlr_input_method_v2) {.importc: "wlr_input_method_v2_send_deactivate".}
proc wlr_input_method_v2_send_surrounding_text*(input_method: ptr wlr_input_method_v2; text: cstring; cursor: uint32_t; anchor: uint32_t) {.importc: "wlr_input_method_v2_send_surrounding_text".}
proc wlr_input_method_v2_send_content_type*(input_method: ptr wlr_input_method_v2; hint: uint32_t; purpose: uint32_t) {.importc: "wlr_input_method_v2_send_content_type".}
proc wlr_input_method_v2_send_text_change_cause*(input_method: ptr wlr_input_method_v2; cause: uint32_t) {.importc: "wlr_input_method_v2_send_text_change_cause".}
proc wlr_input_method_v2_send_done*(input_method: ptr wlr_input_method_v2) {.importc: "wlr_input_method_v2_send_done".}
proc wlr_input_method_v2_send_unavailable*(input_method: ptr wlr_input_method_v2) {.importc: "wlr_input_method_v2_send_unavailable".}
proc wlr_surface_is_input_popup_surface_v2*(surface: ptr wlr_surface): bool {.importc: "wlr_surface_is_input_popup_surface_v2".}
proc wlr_input_popup_surface_v2_from_wlr_surface*(surface: ptr wlr_surface): ptr wlr_input_popup_surface_v2 {.importc: "wlr_input_popup_surface_v2_from_wlr_surface".}
proc wlr_input_popup_surface_v2_send_text_input_rectangle*(popup_surface: ptr wlr_input_popup_surface_v2; sbox: ptr wlr_box) {.importc: "wlr_input_popup_surface_v2_send_text_input_rectangle".}
proc wlr_input_method_keyboard_grab_v2_send_key*(keyboard_grab: ptr wlr_input_method_keyboard_grab_v2; time: uint32_t; key: uint32_t; state: uint32_t) {.importc: "wlr_input_method_keyboard_grab_v2_send_key".}
proc wlr_input_method_keyboard_grab_v2_send_modifiers*(keyboard_grab: ptr wlr_input_method_keyboard_grab_v2; modifiers: ptr wlr_keyboard_modifiers) {.importc: "wlr_input_method_keyboard_grab_v2_send_modifiers".}
proc wlr_input_method_keyboard_grab_v2_set_keyboard*(keyboard_grab: ptr wlr_input_method_keyboard_grab_v2; keyboard: ptr wlr_keyboard) {.importc: "wlr_input_method_keyboard_grab_v2_set_keyboard".}
proc wlr_input_method_keyboard_grab_v2_destroy*(keyboard_grab: ptr wlr_input_method_keyboard_grab_v2) {.importc: "wlr_input_method_keyboard_grab_v2_destroy".}

## wlr_keyboard_group

type INNER_C_STRUCT_wlr_keyboard_group_31* {.bycopy.} = object
  enter*: wl_signal
  leave*: wl_signal

type wlr_keyboard_group* {.bycopy.} = object
  keyboard*: wlr_keyboard
  input_device*: ptr wlr_input_device
  devices*: wl_list
  keys*: wl_list
  events*: INNER_C_STRUCT_wlr_keyboard_group_31
  data*: pointer

proc wlr_keyboard_group_create*(): ptr wlr_keyboard_group {.importc: "wlr_keyboard_group_create".}
proc wlr_keyboard_group_from_wlr_keyboard*(keyboard: ptr wlr_keyboard): ptr wlr_keyboard_group {.importc: "wlr_keyboard_group_from_wlr_keyboard".}
proc wlr_keyboard_group_add_keyboard*(group: ptr wlr_keyboard_group; keyboard: ptr wlr_keyboard): bool {.importc: "wlr_keyboard_group_add_keyboard".}
proc wlr_keyboard_group_remove_keyboard*(group: ptr wlr_keyboard_group; keyboard: ptr wlr_keyboard) {.importc: "wlr_keyboard_group_remove_keyboard".}
proc wlr_keyboard_group_destroy*(group: ptr wlr_keyboard_group) {.importc: "wlr_keyboard_group_destroy".}

## wlr_keyboard

const WLR_LED_COUNT* = 3

type wlr_keyboard_led* = enum
  WLR_LED_NUM_LOCK = 1 shl 0, WLR_LED_CAPS_LOCK = 1 shl 1, WLR_LED_SCROLL_LOCK = 1 shl 2

const WLR_MODIFIER_COUNT* = 8

type wlr_keyboard_modifier* = enum
  WLR_MODIFIER_SHIFT = 1 shl 0, WLR_MODIFIER_CAPS = 1 shl 1,
  WLR_MODIFIER_CTRL = 1 shl 2, WLR_MODIFIER_ALT = 1 shl 3, WLR_MODIFIER_MOD2 = 1 shl 4,
  WLR_MODIFIER_MOD3 = 1 shl 5, WLR_MODIFIER_LOGO = 1 shl 6, WLR_MODIFIER_MOD5 = 1 shl 7

const WLR_KEYBOARD_KEYS_CAP* = 32

discard "forward decl of wlr_keyboard_impl"
type wlr_keyboard_modifiers* {.bycopy.} = object
  depressed*: xkb_mod_mask_t
  latched*: xkb_mod_mask_t
  locked*: xkb_mod_mask_t
  group*: xkb_mod_mask_t

type INNER_C_STRUCT_wlr_keyboard_67* {.bycopy.} = object
  rate*: int32_t
  delay*: int32_t

type INNER_C_STRUCT_wlr_keyboard_78* {.bycopy.} = object
  key*: wl_signal
  modifiers*: wl_signal
  keymap*: wl_signal
  repeat_info*: wl_signal
  destroy*: wl_signal

type wlr_keyboard* {.bycopy.} = object
  impl*: ptr wlr_keyboard_impl
  group*: ptr wlr_keyboard_group
  keymap_string*: cstring
  keymap_size*: csize_t
  keymap_fd*: cint
  keymap*: ptr xkb_keymap
  xkb_state*: ptr xkb_state
  led_indexes*: array[WLR_LED_COUNT, xkb_led_index_t]
  mod_indexes*: array[WLR_MODIFIER_COUNT, xkb_mod_index_t]
  keycodes*: array[WLR_KEYBOARD_KEYS_CAP, uint32_t]
  num_keycodes*: csize_t
  modifiers*: wlr_keyboard_modifiers
  repeat_info*: INNER_C_STRUCT_wlr_keyboard_67
  events*: INNER_C_STRUCT_wlr_keyboard_78
  data*: pointer

type wlr_event_keyboard_key* {.bycopy.} = object
  time_msec*: uint32_t
  keycode*: uint32_t
  update_state*: bool
  state*: wl_keyboard_key_state

proc wlr_keyboard_set_keymap*(kb: ptr wlr_keyboard; keymap: ptr xkb_keymap): bool {.importc: "wlr_keyboard_set_keymap".}
proc wlr_keyboard_keymaps_match*(km1: ptr xkb_keymap; km2: ptr xkb_keymap): bool {.importc: "wlr_keyboard_keymaps_match".}

proc wlr_keyboard_set_repeat_info*(kb: ptr wlr_keyboard; rate: int32_t; delay: int32_t) {.importc: "wlr_keyboard_set_repeat_info".}
proc wlr_keyboard_led_update*(keyboard: ptr wlr_keyboard; leds: uint32_t) {.importc: "wlr_keyboard_led_update".}
proc wlr_keyboard_get_modifiers*(keyboard: ptr wlr_keyboard): uint32_t {.importc: "wlr_keyboard_get_modifiers".}

## wlr_keyboard_shortcuts_inhibit_v1

type INNER_C_STRUCT_wlr_keyboard_shortcuts_inhibit_v1_33* {.bycopy.} = object
  new_inhibitor*: wl_signal
  destroy*: wl_signal

type wlr_keyboard_shortcuts_inhibit_manager_v1* {.bycopy.} = object
  inhibitors*: wl_list
  global*: ptr wl_global
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_keyboard_shortcuts_inhibit_v1_33
  data*: pointer

type INNER_C_STRUCT_wlr_keyboard_shortcuts_inhibit_v1_53* {.bycopy.} = object
  destroy*: wl_signal

type wlr_keyboard_shortcuts_inhibitor_v1* {.bycopy.} = object
  surface*: ptr wlr_surface
  seat*: ptr wlr_seat
  active*: bool
  resource*: ptr wl_resource
  surface_destroy*: wl_listener
  seat_destroy*: wl_listener
  link*: wl_list
  events*: INNER_C_STRUCT_wlr_keyboard_shortcuts_inhibit_v1_53
  data*: pointer

proc wlr_keyboard_shortcuts_inhibit_v1_create*(display: ptr wl_display): ptr wlr_keyboard_shortcuts_inhibit_manager_v1 {.importc: "wlr_keyboard_shortcuts_inhibit_v1_create".}
proc wlr_keyboard_shortcuts_inhibitor_v1_activate*(inhibitor: ptr wlr_keyboard_shortcuts_inhibitor_v1) {.importc: "wlr_keyboard_shortcuts_inhibitor_v1_activate".}
proc wlr_keyboard_shortcuts_inhibitor_v1_deactivate*(inhibitor: ptr wlr_keyboard_shortcuts_inhibitor_v1) {.importc: "wlr_keyboard_shortcuts_inhibitor_v1_deactivate".}

## wlr_layer_shell_v1

import wlr-layer-shell-unstable-v1-protocol

type INNER_C_STRUCT_wlr_layer_shell_v1_39* {.bycopy.} = object
  new_surface*: wl_signal
  destroy*: wl_signal

type wlr_layer_shell_v1* {.bycopy.} = object
  global*: ptr wl_global
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_layer_shell_v1_39
  data*: pointer

type wlr_layer_surface_v1_state_field* = enum
  WLR_LAYER_SURFACE_V1_STATE_DESIRED_SIZE = 1 shl 0,
  WLR_LAYER_SURFACE_V1_STATE_ANCHOR = 1 shl 1,
  WLR_LAYER_SURFACE_V1_STATE_EXCLUSIVE_ZONE = 1 shl 2,
  WLR_LAYER_SURFACE_V1_STATE_MARGIN = 1 shl 3,
  WLR_LAYER_SURFACE_V1_STATE_KEYBOARD_INTERACTIVITY = 1 shl 4,
  WLR_LAYER_SURFACE_V1_STATE_LAYER = 1 shl 5

type INNER_C_STRUCT_wlr_layer_shell_v1_61* {.bycopy.} = object
  top*: uint32_t
  right*: uint32_t
  bottom*: uint32_t
  left*: uint32_t

type wlr_layer_surface_v1_state* {.bycopy.} = object
  committed*: uint32_t
  anchor*: uint32_t
  exclusive_zone*: int32_t
  margin*: INNER_C_STRUCT_wlr_layer_shell_v1_61
  keyboard_interactive*: zwlr_layer_surface_v1_keyboard_interactivity
  desired_width*: uint32_t
  desired_height*: uint32_t
  layer*: zwlr_layer_shell_v1_layer
  configure_serial*: uint32_t
  actual_width*: uint32_t
  actual_height*: uint32_t

type wlr_layer_surface_v1_configure* {.bycopy.} = object
  link*: wl_list
  serial*: uint32_t
  width*: uint32_t
  height*: uint32_t

type INNER_C_STRUCT_wlr_layer_shell_v1_100* {.bycopy.} = object
  destroy*: wl_signal
  map*: wl_signal
  unmap*: wl_signal
  new_popup*: wl_signal

type wlr_layer_surface_v1* {.bycopy.} = object
  surface*: ptr wlr_surface
  output*: ptr wlr_output
  resource*: ptr wl_resource
  shell*: ptr wlr_layer_shell_v1
  popups*: wl_list
  namespace*: cstring
  added*: bool
  configured*: bool
  mapped*: bool
  configure_list*: wl_list
  current*: wlr_layer_surface_v1_state
  pending*: wlr_layer_surface_v1_state
  surface_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_layer_shell_v1_100
  data*: pointer

proc wlr_layer_shell_v1_create*(display: ptr wl_display): ptr wlr_layer_shell_v1 {.importc: "wlr_layer_shell_v1_create".}
proc wlr_layer_surface_v1_configure*(surface: ptr wlr_layer_surface_v1;width: uint32_t; height: uint32_t): uint32_t {.importc: "wlr_layer_surface_v1_configure".}
proc wlr_layer_surface_v1_destroy*(surface: ptr wlr_layer_surface_v1) {.importc: "wlr_layer_surface_v1_destroy".}
proc wlr_surface_is_layer_surface*(surface: ptr wlr_surface): bool {.importc: "wlr_surface_is_layer_surface".}
proc wlr_layer_surface_v1_from_wlr_surface*(surface: ptr wlr_surface): ptr wlr_layer_surface_v1 {.importc: "wlr_layer_surface_v1_from_wlr_surface".}
proc wlr_layer_surface_v1_for_each_surface*(surface: ptr wlr_layer_surface_v1; `iterator`: wlr_surface_iterator_func_t; user_data: pointer) {.importc: "wlr_layer_surface_v1_for_each_surface".}
proc wlr_layer_surface_v1_for_each_popup_surface*(surface: ptr wlr_layer_surface_v1; `iterator`: wlr_surface_iterator_func_t; user_data: pointer) {.importc: "wlr_layer_surface_v1_for_each_popup_surface".}

proc wlr_layer_surface_v1_surface_at*(surface: ptr wlr_layer_surface_v1; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr wlr_surface {.importc: "wlr_layer_surface_v1_surface_at".}

proc wlr_layer_surface_v1_popup_surface_at*(surface: ptr wlr_layer_surface_v1; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr wlr_surface {.importc: "wlr_layer_surface_v1_popup_surface_at".}

## wlr_linux_dmabuf_v1

discard "forward decl of wlr_surface"
type wlr_dmabuf_v1_buffer* {.bycopy.} = object
  base*: wlr_buffer
  resource*: ptr wl_resource
  attributes*: wlr_dmabuf_attributes
  release*: wl_listener

proc wlr_dmabuf_v1_resource_is_buffer*(buffer_resource: ptr wl_resource): bool {.importc: "wlr_dmabuf_v1_resource_is_buffer".}
proc wlr_dmabuf_v1_buffer_from_buffer_resource*(buffer_resource: ptr wl_resource): ptr wlr_dmabuf_v1_buffer {.importc: "wlr_dmabuf_v1_buffer_from_buffer_resource".}

type wlr_linux_dmabuf_feedback_v1* {.bycopy.} = object
  main_device*: dev_t
  tranches_len*: csize_t
  tranches*: ptr wlr_linux_dmabuf_feedback_v1_tranche

type wlr_linux_dmabuf_feedback_v1_tranche* {.bycopy.} = object
  target_device*: dev_t
  flags*: uint32_t
  formats*: ptr wlr_drm_format_set

type INNER_C_STRUCT_wlr_linux_dmabuf_v1_62* {.bycopy.} = object
  destroy*: wl_signal

type wlr_linux_dmabuf_v1* {.bycopy.} = object
  global*: ptr wl_global
  renderer*: ptr wlr_renderer
  events*: INNER_C_STRUCT_wlr_linux_dmabuf_v1_62
  default_feedback*: ptr wlr_linux_dmabuf_feedback_v1_compiled
  surfaces*: wl_list
  display_destroy*: wl_listener
  renderer_destroy*: wl_listener

proc wlr_linux_dmabuf_v1_create*(display: ptr wl_display; renderer: ptr wlr_renderer): ptr wlr_linux_dmabuf_v1 {.importc: "wlr_linux_dmabuf_v1_create".}

proc wlr_linux_dmabuf_v1_set_surface_feedback*(linux_dmabuf: ptr wlr_linux_dmabuf_v1; surface: ptr wlr_surface; feedback: ptr wlr_linux_dmabuf_feedback_v1): bool {.importc: "wlr_linux_dmabuf_v1_set_surface_feedback".}

## wlr_matrix

discard "forward decl of wlr_box"
# NOTE: float mat[static 9]
proc wlr_matrix_identity*(mat: array[9, cfloat]) {.importc: "wlr_matrix_identity".}
# NOTE: float mat[static 9], const float a[static 9], const float b[static 9]
proc wlr_matrix_multiply*(mat: array[9, cfloat]; a: array[9, cfloat]; b: array[9, cfloat]) {.importc: "wlr_matrix_multiply".}
# NOTE: float mat[static 9], const float a[static 9]
proc wlr_matrix_transpose*(mat: array[9, cfloat]; a: array[9, cfloat]) {.importc: "wlr_matrix_transpose".}
# NOTE: float mat[static 9]
proc wlr_matrix_translate*(mat: array[9, cfloat]; x: cfloat; y: cfloat) {.importc: "wlr_matrix_translate".}
# NOTE: float mat[static 9]
proc wlr_matrix_scale*(mat: array[9, cfloat]; x: cfloat; y: cfloat) {.importc: "wlr_matrix_scale".}
# NOTE: float mat[static 9]
proc wlr_matrix_rotate*(mat: array[9, cfloat]; rad: cfloat) {.importc: "wlr_matrix_rotate".}
# NOTE: float mat[static 9]
proc wlr_matrix_transform*(mat: array[9, cfloat]; transform: wl_output_transform) {.importc: "wlr_matrix_transform".}
# NOTE: float mat[static 9]
proc wlr_matrix_projection*(mat: array[9, cfloat]; width: cint; height: cint; transform: wl_output_transform) {.importc: "wlr_matrix_projection".}
# NOTE: float mat[static 9], const float projection[static 9]
proc wlr_matrix_project_box*(mat: array[9, cfloat]; box: ptr wlr_box; transform: wl_output_transform; rotation: cfloat; projection: array[9, cfloat]) {.importc: "wlr_matrix_project_box".}

## wlr_output_damage

const WLR_OUTPUT_DAMAGE_PREVIOUS_LEN* = 2

discard "forward decl of wlr_box"
type INNER_C_STRUCT_wlr_output_damage_49* {.bycopy.} = object
  frame*: wl_signal
  destroy*: wl_signal

type wlr_output_damage* {.bycopy.} = object
  output*: ptr wlr_output
  max_rects*: cint
  current*: pixman_region32_t
  previous*: array[WLR_OUTPUT_DAMAGE_PREVIOUS_LEN, pixman_region32_t]
  previous_idx*: csize_t
  pending_attach_render*: bool
  events*: INNER_C_STRUCT_wlr_output_damage_49
  output_destroy*: wl_listener
  output_mode*: wl_listener
  output_needs_frame*: wl_listener
  output_damage*: wl_listener
  output_frame*: wl_listener
  output_precommit*: wl_listener
  output_commit*: wl_listener

proc wlr_output_damage_create*(output: ptr wlr_output): ptr wlr_output_damage {.importc: "wlr_output_damage_create".}
proc wlr_output_damage_destroy*(output_damage: ptr wlr_output_damage) {.importc: "wlr_output_damage_destroy".}
proc wlr_output_damage_attach_render*(output_damage: ptr wlr_output_damage; needs_frame: ptr bool; buffer_damage: ptr pixman_region32_t): bool {.importc: "wlr_output_damage_attach_render".}
proc wlr_output_damage_add*(output_damage: ptr wlr_output_damage; damage: ptr pixman_region32_t) {.importc: "wlr_output_damage_add".}
proc wlr_output_damage_add_whole*(output_damage: ptr wlr_output_damage) {.importc: "wlr_output_damage_add_whole".}
proc wlr_output_damage_add_box*(output_damage: ptr wlr_output_damage; box: ptr wlr_box) {.importc: "wlr_output_damage_add_box".}

## wlr_output_layout

discard "forward decl of wlr_box"
discard "forward decl of wlr_output_layout_state"
type INNER_C_STRUCT_wlr_output_layout_33* {.bycopy.} = object
  add*: wl_signal
  change*: wl_signal
  destroy*: wl_signal

type wlr_output_layout* {.bycopy.} = object
  outputs*: wl_list
  state*: ptr wlr_output_layout_state
  events*: INNER_C_STRUCT_wlr_output_layout_33
  data*: pointer

discard "forward decl of wlr_output_layout_output_state"
type INNER_C_STRUCT_wlr_output_layout_51* {.bycopy.} = object
  destroy*: wl_signal

type wlr_output_layout_output* {.bycopy.} = object
  output*: ptr wlr_output
  x*: cint
  y*: cint
  link*: wl_list
  state*: ptr wlr_output_layout_output_state
  addon*: wlr_addon
  events*: INNER_C_STRUCT_wlr_output_layout_51

proc wlr_output_layout_create*(): ptr wlr_output_layout {.importc: "wlr_output_layout_create".}
proc wlr_output_layout_destroy*(layout: ptr wlr_output_layout) {.importc: "wlr_output_layout_destroy".}
proc wlr_output_layout_get*(layout: ptr wlr_output_layout; reference: ptr wlr_output): ptr wlr_output_layout_output {.importc: "wlr_output_layout_get".}
proc wlr_output_layout_output_at*(layout: ptr wlr_output_layout; lx: cdouble; ly: cdouble): ptr wlr_output {.importc: "wlr_output_layout_output_at".}
proc wlr_output_layout_add*(layout: ptr wlr_output_layout; output: ptr wlr_output; lx: cint; ly: cint) {.importc: "wlr_output_layout_add".}
proc wlr_output_layout_move*(layout: ptr wlr_output_layout; output: ptr wlr_output; lx: cint; ly: cint) {.importc: "wlr_output_layout_move".}
proc wlr_output_layout_remove*(layout: ptr wlr_output_layout; output: ptr wlr_output) {.importc: "wlr_output_layout_remove".}
proc wlr_output_layout_output_coords*(layout: ptr wlr_output_layout; reference: ptr wlr_output; lx: ptr cdouble; ly: ptr cdouble) {.importc: "wlr_output_layout_output_coords".}
proc wlr_output_layout_contains_point*(layout: ptr wlr_output_layout; reference: ptr wlr_output; lx: cint; ly: cint): bool {.importc: "wlr_output_layout_contains_point".}
proc wlr_output_layout_intersects*(layout: ptr wlr_output_layout; reference: ptr wlr_output; target_lbox: ptr wlr_box): bool {.importc: "wlr_output_layout_intersects".}
proc wlr_output_layout_closest_point*(layout: ptr wlr_output_layout; reference: ptr wlr_output; lx: cdouble; ly: cdouble; dest_lx: ptr cdouble; dest_ly: ptr cdouble) {.importc: "wlr_output_layout_closest_point".}
proc wlr_output_layout_get_box*(layout: ptr wlr_output_layout; reference: ptr wlr_output): ptr wlr_box {.importc: "wlr_output_layout_get_box".}
proc wlr_output_layout_add_auto*(layout: ptr wlr_output_layout; output: ptr wlr_output) {.importc: "wlr_output_layout_add_auto".}
proc wlr_output_layout_get_center_output*(layout: ptr wlr_output_layout): ptr wlr_output {.importc: "wlr_output_layout_get_center_output".}

type wlr_direction* = enum
  WLR_DIRECTION_UP = 1 shl 0, WLR_DIRECTION_DOWN = 1 shl 1,
  WLR_DIRECTION_LEFT = 1 shl 2, WLR_DIRECTION_RIGHT = 1 shl 3

proc wlr_output_layout_adjacent_output*(layout: ptr wlr_output_layout; direction: wlr_direction; reference: ptr wlr_output; ref_lx: cdouble; ref_ly: cdouble): ptr wlr_output {.importc: "wlr_output_layout_adjacent_output".}
proc wlr_output_layout_farthest_output*(layout: ptr wlr_output_layout; direction: wlr_direction; reference: ptr wlr_output; ref_lx: cdouble; ref_ly: cdouble): ptr wlr_output {.importc: "wlr_output_layout_farthest_output".}

## wlr_output_power_management

type INNER_C_STRUCT_wlr_output_management_v1_36* {.bycopy.} = object
  apply*: wl_signal

  test*: wl_signal
  destroy*: wl_signal

type wlr_output_manager_v1* {.bycopy.} = object
  display*: ptr wl_display
  global*: ptr wl_global
  resources*: wl_list
  heads*: wl_list
  serial*: uint32_t
  current_configuration_dirty*: bool
  events*: INNER_C_STRUCT_wlr_output_management_v1_36
  display_destroy*: wl_listener
  data*: pointer

type INNER_C_STRUCT_wlr_output_management_v1_53* {.bycopy.} = object
  width*: int32_t
  height*: int32_t
  refresh*: int32_t

type wlr_output_head_v1_state* {.bycopy.} = object
  output*: ptr wlr_output
  enabled*: bool
  mode*: ptr wlr_output_mode
  custom_mode*: INNER_C_STRUCT_wlr_output_management_v1_53
  x*: int32_t
  y*: int32_t
  transform*: wl_output_transform
  scale*: cfloat

type wlr_output_head_v1* {.bycopy.} = object
  state*: wlr_output_head_v1_state
  manager*: ptr wlr_output_manager_v1
  link*: wl_list
  resources*: wl_list
  mode_resources*: wl_list
  output_destroy*: wl_listener

type wlr_output_configuration_v1* {.bycopy.} = object
  heads*: wl_list

  manager*: ptr wlr_output_manager_v1
  serial*: uint32_t
  finalized*: bool
  finished*: bool
  resource*: ptr wl_resource

type wlr_output_configuration_head_v1* {.bycopy.} = object
  state*: wlr_output_head_v1_state
  config*: ptr wlr_output_configuration_v1
  link*: wl_list

  resource*: ptr wl_resource
  output_destroy*: wl_listener

proc wlr_output_manager_v1_create*(display: ptr wl_display): ptr wlr_output_manager_v1 {.importc: "wlr_output_manager_v1_create".}
proc wlr_output_manager_v1_set_configuration*(manager: ptr wlr_output_manager_v1; config: ptr wlr_output_configuration_v1) {.importc: "wlr_output_manager_v1_set_configuration".}
proc wlr_output_configuration_v1_create*(): ptr wlr_output_configuration_v1 {.importc: "wlr_output_configuration_v1_create".}
proc wlr_output_configuration_v1_destroy*(config: ptr wlr_output_configuration_v1) {.importc: "wlr_output_configuration_v1_destroy".}
proc wlr_output_configuration_v1_send_succeeded*(config: ptr wlr_output_configuration_v1) {.importc: "wlr_output_configuration_v1_send_succeeded".}
proc wlr_output_configuration_v1_send_failed*(config: ptr wlr_output_configuration_v1) {.importc: "wlr_output_configuration_v1_send_failed".}
proc wlr_output_configuration_head_v1_create*(config: ptr wlr_output_configuration_v1; output: ptr wlr_output): ptr wlr_output_configuration_head_v1 {.importc: "wlr_output_configuration_head_v1_create".}

## wlr_output

type wlr_output_mode* {.bycopy.} = object
  width*: int32_t
  height*: int32_t
  refresh*: int32_t
  preferred*: bool
  link*: wl_list

type INNER_C_STRUCT_wlr_output_45* {.bycopy.} = object
  destroy*: wl_signal

type wlr_output_cursor* {.bycopy.} = object
  output*: ptr wlr_output
  x*: cdouble
  y*: cdouble
  enabled*: bool
  visible*: bool
  width*: uint32_t
  height*: uint32_t
  hotspot_x*: int32_t
  hotspot_y*: int32_t
  link*: wl_list
  texture*: ptr wlr_texture
  surface*: ptr wlr_surface
  surface_commit*: wl_listener
  surface_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_output_45

type wlr_output_adaptive_sync_status* = enum
  WLR_OUTPUT_ADAPTIVE_SYNC_DISABLED, WLR_OUTPUT_ADAPTIVE_SYNC_ENABLED, WLR_OUTPUT_ADAPTIVE_SYNC_UNKNOWN

type wlr_output_state_field* = enum
  WLR_OUTPUT_STATE_BUFFER = 1 shl 0, WLR_OUTPUT_STATE_DAMAGE = 1 shl 1,
  WLR_OUTPUT_STATE_MODE = 1 shl 2, WLR_OUTPUT_STATE_ENABLED = 1 shl 3,
  WLR_OUTPUT_STATE_SCALE = 1 shl 4, WLR_OUTPUT_STATE_TRANSFORM = 1 shl 5,
  WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED = 1 shl 6,
  WLR_OUTPUT_STATE_GAMMA_LUT = 1 shl 7, WLR_OUTPUT_STATE_RENDER_FORMAT = 1 shl 8

type wlr_output_state_mode_type* = enum
  WLR_OUTPUT_STATE_MODE_FIXED, WLR_OUTPUT_STATE_MODE_CUSTOM

type INNER_C_STRUCT_wlr_output_91* {.bycopy.} = object
  width*: int32_t
  height*: int32_t
  refresh*: int32_t

type wlr_output_state* {.bycopy.} = object
  committed*: uint32_t
  damage*: pixman_region32_t
  enabled*: bool
  scale*: cfloat
  transform*: wl_output_transform
  adaptive_sync_enabled*: bool
  render_format*: uint32_t
  buffer*: ptr wlr_buffer
  mode_type*: wlr_output_state_mode_type
  mode*: ptr wlr_output_mode
  custom_mode*: INNER_C_STRUCT_wlr_output_91
  gamma_lut*: ptr uint16_t
  gamma_lut_size*: csize_t

discard "forward decl of wlr_output_impl"
type INNER_C_STRUCT_wlr_output_156* {.bycopy.} = object
  frame*: wl_signal

  damage*: wl_signal

  needs_frame*: wl_signal
  precommit*: wl_signal

  commit*: wl_signal

  present*: wl_signal

  `bind`*: wl_signal
  enable*: wl_signal
  mode*: wl_signal
  description*: wl_signal
  destroy*: wl_signal

type wlr_output* {.bycopy.} = object
  impl*: ptr wlr_output_impl
  backend*: ptr wlr_backend
  display*: ptr wl_display
  global*: ptr wl_global
  resources*: wl_list
  name*: cstring
  description*: cstring
  make*: array[56, char]
  model*: array[16, char]
  serial*: array[16, char]
  phys_width*: int32_t
  phys_height*: int32_t

  modes*: wl_list
  current_mode*: ptr wlr_output_mode
  width*: int32_t
  height*: int32_t
  refresh*: int32_t
  enabled*: bool
  scale*: cfloat
  subpixel*: wl_output_subpixel
  transform*: wl_output_transform
  adaptive_sync_status*: wlr_output_adaptive_sync_status
  render_format*: uint32_t
  needs_frame*: bool
  frame_pending*: bool
  transform_matrix*: array[9, cfloat]
  non_desktop*: bool
  pending*: wlr_output_state
  commit_seq*: uint32_t
  events*: INNER_C_STRUCT_wlr_output_156
  idle_frame*: ptr wl_event_source
  idle_done*: ptr wl_event_source
  attach_render_locks*: cint
  cursors*: wl_list
  hardware_cursor*: ptr wlr_output_cursor
  cursor_swapchain*: ptr wlr_swapchain
  cursor_front_buffer*: ptr wlr_buffer
  software_cursor_locks*: cint
  allocator*: ptr wlr_allocator
  renderer*: ptr wlr_renderer
  swapchain*: ptr wlr_swapchain
  back_buffer*: ptr wlr_buffer
  display_destroy*: wl_listener
  addons*: wlr_addon_set
  data*: pointer

type wlr_output_event_damage* {.bycopy.} = object
  output*: ptr wlr_output
  damage*: ptr pixman_region32_t

type wlr_output_event_precommit* {.bycopy.} = object
  output*: ptr wlr_output
  `when`*: ptr timespec

type wlr_output_event_commit* {.bycopy.} = object
  output*: ptr wlr_output
  committed*: uint32_t
  `when`*: ptr timespec
  buffer*: ptr wlr_buffer

type wlr_output_present_flag* = enum
  WLR_OUTPUT_PRESENT_VSYNC = 0x1,
  WLR_OUTPUT_PRESENT_HW_CLOCK = 0x2,
  WLR_OUTPUT_PRESENT_HW_COMPLETION = 0x4,
  WLR_OUTPUT_PRESENT_ZERO_COPY = 0x8

type wlr_output_event_present* {.bycopy.} = object
  output*: ptr wlr_output

  commit_seq*: uint32_t
  presented*: bool
  `when`*: ptr timespec
  seq*: cuint

  refresh*: cint
  flags*: uint32_t

type wlr_output_event_bind* {.bycopy.} = object
  output*: ptr wlr_output
  resource*: ptr wl_resource

discard "forward decl of wlr_surface"
proc wlr_output_enable*(output: ptr wlr_output; enable: bool) {.importc: "wlr_output_enable".}
proc wlr_output_create_global*(output: ptr wlr_output) {.importc: "wlr_output_create_global".}
proc wlr_output_destroy_global*(output: ptr wlr_output) {.importc: "wlr_output_destroy_global".}
proc wlr_output_init_render*(output: ptr wlr_output; allocator: ptr wlr_allocator; renderer: ptr wlr_renderer): bool {.importc: "wlr_output_init_render".}
proc wlr_output_preferred_mode*(output: ptr wlr_output): ptr wlr_output_mode {.importc: "wlr_output_preferred_mode".}
proc wlr_output_set_mode*(output: ptr wlr_output; mode: ptr wlr_output_mode) {.importc: "wlr_output_set_mode".}
proc wlr_output_set_custom_mode*(output: ptr wlr_output; width: int32_t; height: int32_t; refresh: int32_t) {.importc: "wlr_output_set_custom_mode".}
proc wlr_output_set_transform*(output: ptr wlr_output; transform: wl_output_transform) {.importc: "wlr_output_set_transform".}
proc wlr_output_enable_adaptive_sync*(output: ptr wlr_output; enabled: bool) {.importc: "wlr_output_enable_adaptive_sync".}
proc wlr_output_set_render_format*(output: ptr wlr_output; format: uint32_t) {.importc: "wlr_output_set_render_format".}
proc wlr_output_set_scale*(output: ptr wlr_output; scale: cfloat) {.importc: "wlr_output_set_scale".}
proc wlr_output_set_subpixel*(output: ptr wlr_output; subpixel: wl_output_subpixel) {.importc: "wlr_output_set_subpixel".}
proc wlr_output_set_name*(output: ptr wlr_output; name: cstring) {.importc: "wlr_output_set_name".}
proc wlr_output_set_description*(output: ptr wlr_output; desc: cstring) {.importc: "wlr_output_set_description".}
proc wlr_output_schedule_done*(output: ptr wlr_output) {.importc: "wlr_output_schedule_done".}
proc wlr_output_destroy*(output: ptr wlr_output) {.importc: "wlr_output_destroy".}
proc wlr_output_transformed_resolution*(output: ptr wlr_output; width: ptr cint; height: ptr cint) {.importc: "wlr_output_transformed_resolution".}
proc wlr_output_effective_resolution*(output: ptr wlr_output; width: ptr cint; height: ptr cint) {.importc: "wlr_output_effective_resolution".}
proc wlr_output_attach_render*(output: ptr wlr_output; buffer_age: ptr cint): bool {.importc: "wlr_output_attach_render".}
proc wlr_output_attach_buffer*(output: ptr wlr_output; buffer: ptr wlr_buffer) {.importc: "wlr_output_attach_buffer".}
proc wlr_output_preferred_read_format*(output: ptr wlr_output): uint32_t {.importc: "wlr_output_preferred_read_format".}
proc wlr_output_set_damage*(output: ptr wlr_output; damage: ptr pixman_region32_t) {.importc: "wlr_output_set_damage".}
proc wlr_output_test*(output: ptr wlr_output): bool {.importc: "wlr_output_test".}
proc wlr_output_commit*(output: ptr wlr_output): bool {.importc: "wlr_output_commit".}
proc wlr_output_rollback*(output: ptr wlr_output) {.importc: "wlr_output_rollback".}
proc wlr_output_schedule_frame*(output: ptr wlr_output) {.importc: "wlr_output_schedule_frame".}
proc wlr_output_get_gamma_size*(output: ptr wlr_output): csize_t {.importc: "wlr_output_get_gamma_size".}
proc wlr_output_set_gamma*(output: ptr wlr_output; size: csize_t; r: ptr uint16_t; g: ptr uint16_t; b: ptr uint16_t) {.importc: "wlr_output_set_gamma".}
proc wlr_output_from_resource*(resource: ptr wl_resource): ptr wlr_output {.importc: "wlr_output_from_resource".}
proc wlr_output_lock_attach_render*(output: ptr wlr_output; lock: bool) {.importc: "wlr_output_lock_attach_render".}
proc wlr_output_lock_software_cursors*(output: ptr wlr_output; lock: bool) {.importc: "wlr_output_lock_software_cursors".}
proc wlr_output_render_software_cursors*(output: ptr wlr_output; damage: ptr pixman_region32_t) {.importc: "wlr_output_render_software_cursors".}
proc wlr_output_get_primary_formats*(output: ptr wlr_output; buffer_caps: uint32_t): ptr wlr_drm_format_set {.importc: "wlr_output_get_primary_formats".}
proc wlr_output_cursor_create*(output: ptr wlr_output): ptr wlr_output_cursor {.importc: "wlr_output_cursor_create".}
proc wlr_output_cursor_set_image*(cursor: ptr wlr_output_cursor; pixels: ptr uint8_t; stride: int32_t; width: uint32_t; height: uint32_t; hotspot_x: int32_t; hotspot_y: int32_t): bool {.importc: "wlr_output_cursor_set_image".}
proc wlr_output_cursor_set_surface*(cursor: ptr wlr_output_cursor; surface: ptr wlr_surface; hotspot_x: int32_t; hotspot_y: int32_t) {.importc: "wlr_output_cursor_set_surface".}
proc wlr_output_cursor_move*(cursor: ptr wlr_output_cursor; x: cdouble; y: cdouble): bool {.importc: "wlr_output_cursor_move".}
proc wlr_output_cursor_destroy*(cursor: ptr wlr_output_cursor) {.importc: "wlr_output_cursor_destroy".}
proc wlr_output_transform_invert*(tr: wl_output_transform): wl_output_transform {.importc: "wlr_output_transform_invert".}
proc wlr_output_transform_compose*(tr_a: wl_output_transform; tr_b: wl_output_transform): wl_output_transform {.importc: "wlr_output_transform_compose".}

import wlr-output-power-management-unstable-v1-protocol

type INNER_C_STRUCT_wlr_output_power_management_v1_14* {.bycopy.} = object
  set_mode*: wl_signal
  destroy*: wl_signal

type wlr_output_power_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  output_powers*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_output_power_management_v1_14
  data*: pointer

type wlr_output_power_v1* {.bycopy.} = object
  resource*: ptr wl_resource
  output*: ptr wlr_output
  manager*: ptr wlr_output_power_manager_v1
  link*: wl_list
  output_destroy_listener*: wl_listener
  output_commit_listener*: wl_listener
  data*: pointer

type wlr_output_power_v1_set_mode_event* {.bycopy.} = object
  output*: ptr wlr_output
  mode*: zwlr_output_power_v1_mode

proc wlr_output_power_manager_v1_create*(display: ptr wl_display): ptr wlr_output_power_manager_v1 {.importc: "wlr_output_power_manager_v1_create".}

## wlr_pointer_constraints_v1

import pointer-constraints-unstable-v1-protocol

discard "forward decl of wlr_seat"
type wlr_pointer_constraint_v1_type* = enum
  WLR_POINTER_CONSTRAINT_V1_LOCKED, WLR_POINTER_CONSTRAINT_V1_CONFINED

type wlr_pointer_constraint_v1_state_field* = enum
  WLR_POINTER_CONSTRAINT_V1_STATE_REGION = 1 shl 0,
  WLR_POINTER_CONSTRAINT_V1_STATE_CURSOR_HINT = 1 shl 1

type INNER_C_STRUCT_wlr_pointer_constraints_v1_36* {.bycopy.} = object
  x*: cdouble
  y*: cdouble

type wlr_pointer_constraint_v1_state* {.bycopy.} = object
  committed*: uint32_t
  region*: pixman_region32_t
  cursor_hint*: INNER_C_STRUCT_wlr_pointer_constraints_v1_36

type INNER_C_STRUCT_wlr_pointer_constraints_v1_63* {.bycopy.} = object
  set_region*: wl_signal
  destroy*: wl_signal

type wlr_pointer_constraint_v1* {.bycopy.} = object
  pointer_constraints*: ptr wlr_pointer_constraints_v1
  resource*: ptr wl_resource
  surface*: ptr wlr_surface
  seat*: ptr wlr_seat
  lifetime*: zwp_pointer_constraints_v1_lifetime
  `type`*: wlr_pointer_constraint_v1_type
  region*: pixman_region32_t
  current*: wlr_pointer_constraint_v1_state
  pending*: wlr_pointer_constraint_v1_state
  surface_commit*: wl_listener
  surface_destroy*: wl_listener
  seat_destroy*: wl_listener
  link*: wl_list
  events*: INNER_C_STRUCT_wlr_pointer_constraints_v1_63
  data*: pointer

type INNER_C_STRUCT_wlr_pointer_constraints_v1_80* {.bycopy.} = object
  new_constraint*: wl_signal

type wlr_pointer_constraints_v1* {.bycopy.} = object
  global*: ptr wl_global
  constraints*: wl_list
  events*: INNER_C_STRUCT_wlr_pointer_constraints_v1_80
  display_destroy*: wl_listener
  data*: pointer

proc wlr_pointer_constraints_v1_create*(display: ptr wl_display): ptr wlr_pointer_constraints_v1 {.importc: "wlr_pointer_constraints_v1_create".}
proc wlr_pointer_constraints_v1_constraint_for_surface*(pointer_constraints: ptr wlr_pointer_constraints_v1; surface: ptr wlr_surface; seat: ptr wlr_seat): ptr wlr_pointer_constraint_v1 {.importc: "wlr_pointer_constraints_v1_constraint_for_surface".}
proc wlr_pointer_constraint_v1_send_activated*(constraint: ptr wlr_pointer_constraint_v1) {.importc: "wlr_pointer_constraint_v1_send_activated".}
proc wlr_pointer_constraint_v1_send_deactivated*(constraint: ptr wlr_pointer_constraint_v1) {.importc: "wlr_pointer_constraint_v1_send_deactivated".}

## wlr_pointer_gestures_v1

type INNER_C_STRUCT_wlr_pointer_gestures_v1_25* {.bycopy.} = object
  destroy*: wl_signal

type wlr_pointer_gestures_v1* {.bycopy.} = object
  global*: ptr wl_global
  swipes*: wl_list
  pinches*: wl_list
  holds*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_pointer_gestures_v1_25
  data*: pointer

proc wlr_pointer_gestures_v1_create*(display: ptr wl_display): ptr wlr_pointer_gestures_v1 {.importc: "wlr_pointer_gestures_v1_create".}
proc wlr_pointer_gestures_v1_send_swipe_begin*(gestures: ptr wlr_pointer_gestures_v1; seat: ptr wlr_seat; time_msec: uint32_t; fingers: uint32_t) {.importc: "wlr_pointer_gestures_v1_send_swipe_begin".}
proc wlr_pointer_gestures_v1_send_swipe_update*(gestures: ptr wlr_pointer_gestures_v1; seat: ptr wlr_seat; time_msec: uint32_t; dx: cdouble; dy: cdouble) {.importc: "wlr_pointer_gestures_v1_send_swipe_update".}
proc wlr_pointer_gestures_v1_send_swipe_end*(gestures: ptr wlr_pointer_gestures_v1; seat: ptr wlr_seat; time_msec: uint32_t; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_swipe_end".}
proc wlr_pointer_gestures_v1_send_pinch_begin*(gestures: ptr wlr_pointer_gestures_v1; seat: ptr wlr_seat; time_msec: uint32_t; fingers: uint32_t) {.importc: "wlr_pointer_gestures_v1_send_pinch_begin".}
proc wlr_pointer_gestures_v1_send_pinch_update*(gestures: ptr wlr_pointer_gestures_v1; seat: ptr wlr_seat; time_msec: uint32_t; dx: cdouble; dy: cdouble; scale: cdouble; rotation: cdouble) {.importc: "wlr_pointer_gestures_v1_send_pinch_update".}
proc wlr_pointer_gestures_v1_send_pinch_end*(gestures: ptr wlr_pointer_gestures_v1; seat: ptr wlr_seat; time_msec: uint32_t; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_pinch_end".}
proc wlr_pointer_gestures_v1_send_hold_begin*(gestures: ptr wlr_pointer_gestures_v1; seat: ptr wlr_seat; time_msec: uint32_t; fingers: uint32_t) {.importc: "wlr_pointer_gestures_v1_send_hold_begin".}
proc wlr_pointer_gestures_v1_send_hold_end*(gestures: ptr wlr_pointer_gestures_v1; seat: ptr wlr_seat; time_msec: uint32_t; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_hold_end".}

## wlr_pointer

discard "forward decl of wlr_pointer_impl"
type INNER_C_STRUCT_wlr_pointer_23* {.bycopy.} = object
  motion*: wl_signal
  motion_absolute*: wl_signal
  button*: wl_signal
  axis*: wl_signal
  frame*: wl_signal
  swipe_begin*: wl_signal
  swipe_update*: wl_signal
  swipe_end*: wl_signal
  pinch_begin*: wl_signal
  pinch_update*: wl_signal
  pinch_end*: wl_signal
  hold_begin*: wl_signal
  hold_end*: wl_signal

type wlr_pointer* {.bycopy.} = object
  impl*: ptr wlr_pointer_impl
  events*: INNER_C_STRUCT_wlr_pointer_23
  data*: pointer

type wlr_event_pointer_motion* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  delta_x*: cdouble
  delta_y*: cdouble
  unaccel_dx*: cdouble
  unaccel_dy*: cdouble

type wlr_event_pointer_motion_absolute* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  x*: cdouble
  y*: cdouble

type wlr_event_pointer_button* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  button*: uint32_t
  state*: wlr_button_state

type wlr_axis_source* = enum
  WLR_AXIS_SOURCE_WHEEL, WLR_AXIS_SOURCE_FINGER, WLR_AXIS_SOURCE_CONTINUOUS,
  WLR_AXIS_SOURCE_WHEEL_TILT

type wlr_axis_orientation* = enum
  WLR_AXIS_ORIENTATION_VERTICAL, WLR_AXIS_ORIENTATION_HORIZONTAL

type wlr_event_pointer_axis* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  source*: wlr_axis_source
  orientation*: wlr_axis_orientation
  delta*: cdouble
  delta_discrete*: int32_t

type wlr_event_pointer_swipe_begin* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  fingers*: uint32_t

type wlr_event_pointer_swipe_update* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  fingers*: uint32_t
  dx*: cdouble
  dy*: cdouble

type wlr_event_pointer_swipe_end* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  cancelled*: bool

type wlr_event_pointer_pinch_begin* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  fingers*: uint32_t

type wlr_event_pointer_pinch_update* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  fingers*: uint32_t

  dx*: cdouble
  dy*: cdouble
  scale*: cdouble
  rotation*: cdouble

type wlr_event_pointer_pinch_end* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  cancelled*: bool

type wlr_event_pointer_hold_begin* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  fingers*: uint32_t

type wlr_event_pointer_hold_end* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  cancelled*: bool

## wlr_presentation_time

discard "forward decl of wlr_surface"
discard "forward decl of wlr_output"
discard "forward decl of wlr_output_event_present"
type INNER_C_STRUCT_wlr_presentation_time_27* {.bycopy.} = object
  destroy*: wl_signal

type wlr_presentation* {.bycopy.} = object
  global*: ptr wl_global
  clock*: clockid_t
  events*: INNER_C_STRUCT_wlr_presentation_time_27
  display_destroy*: wl_listener

type wlr_presentation_feedback* {.bycopy.} = object
  resources*: wl_list
  output*: ptr wlr_output
  output_committed*: bool
  output_commit_seq*: uint32_t
  output_commit*: wl_listener
  output_present*: wl_listener
  output_destroy*: wl_listener

type wlr_presentation_event* {.bycopy.} = object
  output*: ptr wlr_output
  tv_sec*: uint64_t
  tv_nsec*: uint32_t
  refresh*: uint32_t
  seq*: uint64_t
  flags*: uint32_t

discard "forward decl of wlr_backend"
proc wlr_presentation_create*(display: ptr wl_display; backend: ptr wlr_backend): ptr wlr_presentation {.importc: "wlr_presentation_create".}
proc wlr_presentation_surface_sampled*(presentation: ptr wlr_presentation; surface: ptr wlr_surface): ptr wlr_presentation_feedback {.importc: "wlr_presentation_surface_sampled".}
proc wlr_presentation_feedback_send_presented*(feedback: ptr wlr_presentation_feedback; event: ptr wlr_presentation_event) {.importc: "wlr_presentation_feedback_send_presented".}
proc wlr_presentation_feedback_destroy*(feedback: ptr wlr_presentation_feedback) {.importc: "wlr_presentation_feedback_destroy".}
proc wlr_presentation_event_from_output*(event: ptr wlr_presentation_event; output_event: ptr wlr_output_event_present) {.importc: "wlr_presentation_event_from_output".}
proc wlr_presentation_surface_sampled_on_output*(presentation: ptr wlr_presentation; surface: ptr wlr_surface; output: ptr wlr_output) {.importc: "wlr_presentation_surface_sampled_on_output".}

## wlr_primary_selection

discard "forward decl of wlr_primary_selection_source"
type wlr_primary_selection_source_impl* {.bycopy.} = object
  send*: proc (source: ptr wlr_primary_selection_source; mime_type: cstring; fd: cint)
  destroy*: proc (source: ptr wlr_primary_selection_source)

type INNER_C_STRUCT_wlr_primary_selection_36* {.bycopy.} = object
  destroy*: wl_signal

type wlr_primary_selection_source* {.bycopy.} = object
  impl*: ptr wlr_primary_selection_source_impl
  mime_types*: wl_array
  events*: INNER_C_STRUCT_wlr_primary_selection_36
  data*: pointer

proc wlr_primary_selection_source_init*(source: ptr wlr_primary_selection_source; impl: ptr wlr_primary_selection_source_impl) {.importc: "wlr_primary_selection_source_init".}
proc wlr_primary_selection_source_destroy*(source: ptr wlr_primary_selection_source) {.importc: "wlr_primary_selection_source_destroy".}
proc wlr_primary_selection_source_send*(source: ptr wlr_primary_selection_source; mime_type: cstring; fd: cint) {.importc: "wlr_primary_selection_source_send".}
proc wlr_seat_request_set_primary_selection*(seat: ptr wlr_seat; client: ptr wlr_seat_client; source: ptr wlr_primary_selection_source; serial: uint32_t) {.importc: "wlr_seat_request_set_primary_selection".}
proc wlr_seat_set_primary_selection*(seat: ptr wlr_seat; source: ptr wlr_primary_selection_source; serial: uint32_t) {.importc: "wlr_seat_set_primary_selection".}

## wlr_primary_selection_v1

type INNER_C_STRUCT_wlr_primary_selection_v1_22* {.bycopy.} = object
  destroy*: wl_signal

type wlr_primary_selection_v1_device_manager* {.bycopy.} = object
  global*: ptr wl_global
  devices*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_primary_selection_v1_22
  data*: pointer

type wlr_primary_selection_v1_device* {.bycopy.} = object
  manager*: ptr wlr_primary_selection_v1_device_manager
  seat*: ptr wlr_seat
  link*: wl_list
  resources*: wl_list
  offers*: wl_list
  seat_destroy*: wl_listener
  seat_focus_change*: wl_listener
  seat_set_primary_selection*: wl_listener
  data*: pointer

proc wlr_primary_selection_v1_device_manager_create*(display: ptr wl_display): ptr wlr_primary_selection_v1_device_manager {.importc: "wlr_primary_selection_v1_device_manager_create".}

discard "forward decl of wl_resource"
proc wlr_region_from_resource*(resource: ptr wl_resource): ptr pixman_region32_t {.importc: "wlr_region_from_resource".}

## XXX: wlr_region??

## wlr_relative_pointer

type INNER_C_STRUCT_wlr_relative_pointer_v1_29* {.bycopy.} = object
  destroy*: wl_signal
  new_relative_pointer*: wl_signal

type wlr_relative_pointer_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  relative_pointers*: wl_list
  events*: INNER_C_STRUCT_wlr_relative_pointer_v1_29
  display_destroy_listener*: wl_listener
  data*: pointer

type INNER_C_STRUCT_wlr_relative_pointer_v1_51* {.bycopy.} = object
  destroy*: wl_signal

type wlr_relative_pointer_v1* {.bycopy.} = object
  resource*: ptr wl_resource
  pointer_resource*: ptr wl_resource
  seat*: ptr wlr_seat
  link*: wl_list
  events*: INNER_C_STRUCT_wlr_relative_pointer_v1_51
  seat_destroy*: wl_listener
  pointer_destroy*: wl_listener
  data*: pointer

proc wlr_relative_pointer_manager_v1_create*(display: ptr wl_display): ptr wlr_relative_pointer_manager_v1 {.importc: "wlr_relative_pointer_manager_v1_create".}
proc wlr_relative_pointer_manager_v1_send_relative_motion*(manager: ptr wlr_relative_pointer_manager_v1; seat: ptr wlr_seat; time_usec: uint64_t; dx: cdouble; dy: cdouble; dx_unaccel: cdouble; dy_unaccel: cdouble) {.importc: "wlr_relative_pointer_manager_v1_send_relative_motion".}
proc wlr_relative_pointer_v1_from_resource*(resource: ptr wl_resource): ptr wlr_relative_pointer_v1 {.importc: "wlr_relative_pointer_v1_from_resource".}

## wlr_scene

discard "forward decl of wlr_output"
discard "forward decl of wlr_output_layout"
discard "forward decl of wlr_xdg_surface"
type wlr_scene_node_type* = enum
  WLR_SCENE_NODE_ROOT, WLR_SCENE_NODE_TREE, WLR_SCENE_NODE_SURFACE,
  WLR_SCENE_NODE_RECT, WLR_SCENE_NODE_BUFFER

type wlr_scene_node_state* {.bycopy.} = object
  link*: wl_list
  children*: wl_list
  enabled*: bool
  x*: cint
  y*: cint

type INNER_C_STRUCT_types_wlr_scene_54* {.bycopy.} = object
  destroy*: wl_signal

type wlr_scene_node* {.bycopy.} = object
  `type`*: wlr_scene_node_type
  parent*: ptr wlr_scene_node
  state*: wlr_scene_node_state
  events*: INNER_C_STRUCT_types_wlr_scene_54
  data*: pointer

type wlr_scene* {.bycopy.} = object
  node*: wlr_scene_node
  outputs*: wl_list
  presentation*: ptr wlr_presentation
  presentation_destroy*: wl_listener
  pending_buffers*: wl_list

type wlr_scene_tree* {.bycopy.} = object
  node*: wlr_scene_node

type wlr_scene_surface* {.bycopy.} = object
  node*: wlr_scene_node
  surface*: ptr wlr_surface
  primary_output*: ptr wlr_output
  prev_width*: cint
  prev_height*: cint
  surface_destroy*: wl_listener
  surface_commit*: wl_listener

type wlr_scene_rect* {.bycopy.} = object
  node*: wlr_scene_node
  width*: cint
  height*: cint
  color*: array[4, cfloat]

type wlr_scene_buffer* {.bycopy.} = object
  node*: wlr_scene_node
  buffer*: ptr wlr_buffer
  texture*: ptr wlr_texture
  src_box*: wlr_fbox
  dst_width*: cint
  dst_height*: cint
  transform*: wl_output_transform
  pending_link*: wl_list

type wlr_scene_output* {.bycopy.} = object
  output*: ptr wlr_output
  link*: wl_list
  scene*: ptr wlr_scene
  addon*: wlr_addon
  damage*: ptr wlr_output_damage
  x*: cint
  y*: cint
  prev_scanout*: bool

type wlr_scene_node_iterator_func_t* = proc (node: ptr wlr_scene_node; sx: cint; sy: cint; data: pointer)

proc wlr_scene_node_destroy*(node: ptr wlr_scene_node) {.importc: "wlr_scene_node_destroy".}
proc wlr_scene_node_set_enabled*(node: ptr wlr_scene_node; enabled: bool) {.importc: "wlr_scene_node_set_enabled".}
proc wlr_scene_node_set_position*(node: ptr wlr_scene_node; x: cint; y: cint) {.importc: "wlr_scene_node_set_position".}
proc wlr_scene_node_place_above*(node: ptr wlr_scene_node; sibling: ptr wlr_scene_node) {.importc: "wlr_scene_node_place_above".}
proc wlr_scene_node_place_below*(node: ptr wlr_scene_node; sibling: ptr wlr_scene_node) {.importc: "wlr_scene_node_place_below".}
proc wlr_scene_node_raise_to_top*(node: ptr wlr_scene_node) {.importc: "wlr_scene_node_raise_to_top".}
proc wlr_scene_node_lower_to_bottom*(node: ptr wlr_scene_node) {.importc: "wlr_scene_node_lower_to_bottom".}
proc wlr_scene_node_reparent*(node: ptr wlr_scene_node; new_parent: ptr wlr_scene_node) {.importc: "wlr_scene_node_reparent".}
proc wlr_scene_node_coords*(node: ptr wlr_scene_node; lx: ptr cint; ly: ptr cint): bool {.importc: "wlr_scene_node_coords".}
proc wlr_scene_node_for_each_surface*(node: ptr wlr_scene_node; `iterator`: wlr_surface_iterator_func_t; user_data: pointer) {.importc: "wlr_scene_node_for_each_surface".}
proc wlr_scene_node_at*(node: ptr wlr_scene_node; lx: cdouble; ly: cdouble; nx: ptr cdouble; ny: ptr cdouble): ptr wlr_scene_node {.importc: "wlr_scene_node_at".}
proc wlr_scene_create*(): ptr wlr_scene {.importc: "wlr_scene_create".}
proc wlr_scene_render_output*(scene: ptr wlr_scene; output: ptr wlr_output; lx: cint; ly: cint; damage: ptr pixman_region32_t) {.importc: "wlr_scene_render_output".}
proc wlr_scene_set_presentation*(scene: ptr wlr_scene; presentation: ptr wlr_presentation) {.importc: "wlr_scene_set_presentation".}
proc wlr_scene_tree_create*(parent: ptr wlr_scene_node): ptr wlr_scene_tree {.importc: "wlr_scene_tree_create".}
proc wlr_scene_surface_create*(parent: ptr wlr_scene_node; surface: ptr wlr_surface): ptr wlr_scene_surface {.importc: "wlr_scene_surface_create".}
proc wlr_scene_surface_from_node*(node: ptr wlr_scene_node): ptr wlr_scene_surface {.importc: "wlr_scene_surface_from_node".}
# NOTE: const float color[static 4]
proc wlr_scene_rect_create*(parent: ptr wlr_scene_node; width: cint; height: cint; color: array[4, cfloat]): ptr wlr_scene_rect {.importc: "wlr_scene_rect_create".}
proc wlr_scene_rect_set_size*(rect: ptr wlr_scene_rect; width: cint; height: cint) {.importc: "wlr_scene_rect_set_size".}
# NOTE: const float color[static 4]
proc wlr_scene_rect_set_color*(rect: ptr wlr_scene_rect; color: array[4, cfloat]) {.importc: "wlr_scene_rect_set_color".}
proc wlr_scene_buffer_create*(parent: ptr wlr_scene_node; buffer: ptr wlr_buffer): ptr wlr_scene_buffer {.importc: "wlr_scene_buffer_create".}
proc wlr_scene_buffer_set_source_box*(scene_buffer: ptr wlr_scene_buffer; box: ptr wlr_fbox) {.importc: "wlr_scene_buffer_set_source_box".}
proc wlr_scene_buffer_set_dest_size*(scene_buffer: ptr wlr_scene_buffer; width: cint; height: cint) {.importc: "wlr_scene_buffer_set_dest_size".}
proc wlr_scene_buffer_set_transform*(scene_buffer: ptr wlr_scene_buffer; transform: wl_output_transform) {.importc: "wlr_scene_buffer_set_transform".}
proc wlr_scene_output_create*(scene: ptr wlr_scene; output: ptr wlr_output): ptr wlr_scene_output {.importc: "wlr_scene_output_create".}
proc wlr_scene_output_destroy*(scene_output: ptr wlr_scene_output) {.importc: "wlr_scene_output_destroy".}
proc wlr_scene_output_set_position*(scene_output: ptr wlr_scene_output; lx: cint; ly: cint) {.importc: "wlr_scene_output_set_position".}
proc wlr_scene_output_commit*(scene_output: ptr wlr_scene_output): bool {.importc: "wlr_scene_output_commit".}
proc wlr_scene_output_send_frame_done*(scene_output: ptr wlr_scene_output; now: ptr timespec) {.importc: "wlr_scene_output_send_frame_done".}
proc wlr_scene_output_for_each_surface*(scene_output: ptr wlr_scene_output; `iterator`: wlr_surface_iterator_func_t; user_data: pointer) {.importc: "wlr_scene_output_for_each_surface".}
proc wlr_scene_get_scene_output*(scene: ptr wlr_scene; output: ptr wlr_output): ptr wlr_scene_output {.importc: "wlr_scene_get_scene_output".}
proc wlr_scene_attach_output_layout*(scene: ptr wlr_scene; output_layout: ptr wlr_output_layout): bool {.importc: "wlr_scene_attach_output_layout".}
proc wlr_scene_subsurface_tree_create*(parent: ptr wlr_scene_node; surface: ptr wlr_surface): ptr wlr_scene_node {.importc: "wlr_scene_subsurface_tree_create".}
proc wlr_scene_xdg_surface_create*(parent: ptr wlr_scene_node; xdg_surface: ptr wlr_xdg_surface): ptr wlr_scene_node {.importc: "wlr_scene_xdg_surface_create".}

## wlr_screencopy_v1

type INNER_C_STRUCT_wlr_screencopy_v1_23* {.bycopy.} = object
  destroy*: wl_signal

type wlr_screencopy_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  frames*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_screencopy_v1_23
  data*: pointer

type wlr_screencopy_v1_client* {.bycopy.} = object
  `ref`*: cint
  manager*: ptr wlr_screencopy_manager_v1
  damages*: wl_list

type wlr_screencopy_frame_v1* {.bycopy.} = object
  resource*: ptr wl_resource
  client*: ptr wlr_screencopy_v1_client
  link*: wl_list
  format*: wl_shm_format
  fourcc*: uint32_t
  box*: wlr_box
  stride*: cint
  overlay_cursor*: bool
  cursor_locked*: bool
  with_damage*: bool
  shm_buffer*: ptr wl_shm_buffer
  dma_buffer*: ptr wlr_dmabuf_v1_buffer
  buffer_destroy*: wl_listener
  output*: ptr wlr_output
  output_commit*: wl_listener
  output_destroy*: wl_listener
  output_enable*: wl_listener
  data*: pointer

proc wlr_screencopy_manager_v1_create*(display: ptr wl_display): ptr wlr_screencopy_manager_v1 {.importc: "wlr_screencopy_manager_v1_create".}

## wlr_seat

const WLR_SERIAL_RINGSET_SIZE* = 128

type wlr_serial_range* {.bycopy.} = object
  min_incl*: uint32_t
  max_incl*: uint32_t

type wlr_serial_ringset* {.bycopy.} = object
  data*: array[WLR_SERIAL_RINGSET_SIZE, wlr_serial_range]
  `end`*: cint
  count*: cint

type INNER_C_STRUCT_wlr_seat_49* {.bycopy.} = object
  destroy*: wl_signal

type wlr_seat_client* {.bycopy.} = object
  client*: ptr wl_client
  seat*: ptr wlr_seat
  link*: wl_list
  resources*: wl_list
  pointers*: wl_list
  keyboards*: wl_list
  touches*: wl_list
  data_devices*: wl_list
  events*: INNER_C_STRUCT_wlr_seat_49
  serials*: wlr_serial_ringset
  needs_touch_frame*: bool

type INNER_C_STRUCT_wlr_seat_72* {.bycopy.} = object
  destroy*: wl_signal

type wlr_touch_point* {.bycopy.} = object
  touch_id*: int32_t
  surface*: ptr wlr_surface
  client*: ptr wlr_seat_client
  focus_surface*: ptr wlr_surface
  focus_client*: ptr wlr_seat_client
  sx*: cdouble
  sy*: cdouble
  surface_destroy*: wl_listener
  focus_surface_destroy*: wl_listener
  client_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_seat_72
  link*: wl_list

discard "forward decl of wlr_seat_pointer_grab"
type wlr_pointer_grab_interface* {.bycopy.} = object
  enter*: proc (grab: ptr wlr_seat_pointer_grab; surface: ptr wlr_surface; sx: cdouble; sy: cdouble)
  clear_focus*: proc (grab: ptr wlr_seat_pointer_grab)
  motion*: proc (grab: ptr wlr_seat_pointer_grab; time_msec: uint32_t; sx: cdouble; sy: cdouble)
  button*: proc (grab: ptr wlr_seat_pointer_grab; time_msec: uint32_t; button: uint32_t; state: wlr_button_state): uint32_t
  axis*: proc (grab: ptr wlr_seat_pointer_grab; time_msec: uint32_t; orientation: wlr_axis_orientation; value: cdouble; value_discrete: int32_t; source: wlr_axis_source)
  frame*: proc (grab: ptr wlr_seat_pointer_grab)
  cancel*: proc (grab: ptr wlr_seat_pointer_grab)

discard "forward decl of wlr_seat_keyboard_grab"
type wlr_keyboard_grab_interface* {.bycopy.} = object
  enter*: proc (grab: ptr wlr_seat_keyboard_grab; surface: ptr wlr_surface; keycodes: ptr uint32_t; num_keycodes: csize_t; modifiers: ptr wlr_keyboard_modifiers)
  clear_focus*: proc (grab: ptr wlr_seat_keyboard_grab)
  key*: proc (grab: ptr wlr_seat_keyboard_grab; time_msec: uint32_t; key: uint32_t; state: uint32_t)
  modifiers*: proc (grab: ptr wlr_seat_keyboard_grab; modifiers: ptr wlr_keyboard_modifiers)
  cancel*: proc (grab: ptr wlr_seat_keyboard_grab)

discard "forward decl of wlr_seat_touch_grab"
type wlr_touch_grab_interface* {.bycopy.} = object
  down*: proc (grab: ptr wlr_seat_touch_grab; time_msec: uint32_t; point: ptr wlr_touch_point): uint32_t
  up*: proc (grab: ptr wlr_seat_touch_grab; time_msec: uint32_t; point: ptr wlr_touch_point)
  motion*: proc (grab: ptr wlr_seat_touch_grab; time_msec: uint32_t; point: ptr wlr_touch_point)
  enter*: proc (grab: ptr wlr_seat_touch_grab; time_msec: uint32_t; point: ptr wlr_touch_point)
  frame*: proc (grab: ptr wlr_seat_touch_grab)
  cancel*: proc (grab: ptr wlr_seat_touch_grab)

type wlr_seat_touch_grab* {.bycopy.} = object
  `interface`*: ptr wlr_touch_grab_interface
  seat*: ptr wlr_seat
  data*: pointer

type wlr_seat_keyboard_grab* {.bycopy.} = object
  `interface`*: ptr wlr_keyboard_grab_interface
  seat*: ptr wlr_seat
  data*: pointer

type wlr_seat_pointer_grab* {.bycopy.} = object
  `interface`*: ptr wlr_pointer_grab_interface
  seat*: ptr wlr_seat
  data*: pointer

const WLR_POINTER_BUTTONS_CAP* = 16

type INNER_C_STRUCT_wlr_seat_179* {.bycopy.} = object
  focus_change*: wl_signal

type wlr_seat_pointer_state* {.bycopy.} = object
  seat*: ptr wlr_seat
  focused_client*: ptr wlr_seat_client
  focused_surface*: ptr wlr_surface
  sx*: cdouble
  sy*: cdouble
  grab*: ptr wlr_seat_pointer_grab
  default_grab*: ptr wlr_seat_pointer_grab
  sent_axis_source*: bool
  cached_axis_source*: wlr_axis_source
  buttons*: array[WLR_POINTER_BUTTONS_CAP, uint32_t]
  button_count*: csize_t
  grab_button*: uint32_t
  grab_serial*: uint32_t
  grab_time*: uint32_t
  surface_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_seat_179

type INNER_C_STRUCT_wlr_seat_201* {.bycopy.} = object
  focus_change*: wl_signal

type wlr_seat_keyboard_state* {.bycopy.} = object
  seat*: ptr wlr_seat
  keyboard*: ptr wlr_keyboard
  focused_client*: ptr wlr_seat_client
  focused_surface*: ptr wlr_surface
  keyboard_destroy*: wl_listener
  keyboard_keymap*: wl_listener
  keyboard_repeat_info*: wl_listener
  surface_destroy*: wl_listener
  grab*: ptr wlr_seat_keyboard_grab
  default_grab*: ptr wlr_seat_keyboard_grab
  events*: INNER_C_STRUCT_wlr_seat_201

type wlr_seat_touch_state* {.bycopy.} = object
  seat*: ptr wlr_seat
  touch_points*: wl_list
  grab_serial*: uint32_t
  grab_id*: uint32_t
  grab*: ptr wlr_seat_touch_grab
  default_grab*: ptr wlr_seat_touch_grab

discard "forward decl of wlr_primary_selection_source"
type INNER_C_STRUCT_wlr_seat_251* {.bycopy.} = object
  pointer_grab_begin*: wl_signal
  pointer_grab_end*: wl_signal
  keyboard_grab_begin*: wl_signal
  keyboard_grab_end*: wl_signal
  touch_grab_begin*: wl_signal
  touch_grab_end*: wl_signal
  request_set_cursor*: wl_signal
  request_set_selection*: wl_signal
  set_selection*: wl_signal
  request_set_primary_selection*: wl_signal
  set_primary_selection*: wl_signal
  request_start_drag*: wl_signal
  start_drag*: wl_signal
  destroy*: wl_signal

type wlr_seat* {.bycopy.} = object
  global*: ptr wl_global
  display*: ptr wl_display
  clients*: wl_list
  name*: cstring
  capabilities*: uint32_t
  accumulated_capabilities*: uint32_t
  last_event*: timespec
  selection_source*: ptr wlr_data_source
  selection_serial*: uint32_t
  selection_offers*: wl_list
  primary_selection_source*: ptr wlr_primary_selection_source
  primary_selection_serial*: uint32_t
  drag*: ptr wlr_drag
  drag_source*: ptr wlr_data_source
  drag_serial*: uint32_t
  drag_offers*: wl_list
  pointer_state*: wlr_seat_pointer_state
  keyboard_state*: wlr_seat_keyboard_state
  touch_state*: wlr_seat_touch_state
  display_destroy*: wl_listener
  selection_source_destroy*: wl_listener
  primary_selection_source_destroy*: wl_listener
  drag_source_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_seat_251
  data*: pointer

type wlr_seat_pointer_request_set_cursor_event* {.bycopy.} = object
  seat_client*: ptr wlr_seat_client
  surface*: ptr wlr_surface
  serial*: uint32_t
  hotspot_x*: int32_t
  hotspot_y*: int32_t

type wlr_seat_request_set_selection_event* {.bycopy.} = object
  source*: ptr wlr_data_source
  serial*: uint32_t

type wlr_seat_request_set_primary_selection_event* {.bycopy.} = object
  source*: ptr wlr_primary_selection_source
  serial*: uint32_t

type wlr_seat_request_start_drag_event* {.bycopy.} = object
  drag*: ptr wlr_drag
  origin*: ptr wlr_surface
  serial*: uint32_t

type wlr_seat_pointer_focus_change_event* {.bycopy.} = object
  seat*: ptr wlr_seat
  old_surface*: ptr wlr_surface
  new_surface*: ptr wlr_surface
  sx*: cdouble
  sy*: cdouble

type wlr_seat_keyboard_focus_change_event* {.bycopy.} = object
  seat*: ptr wlr_seat
  old_surface*: ptr wlr_surface
  new_surface*: ptr wlr_surface

proc wlr_seat_create*(display: ptr wl_display; name: cstring): ptr wlr_seat {.importc: "wlr_seat_create".}
proc wlr_seat_destroy*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_destroy".}
proc wlr_seat_client_for_wl_client*(wlr_seat: ptr wlr_seat; wl_client: ptr wl_client): ptr wlr_seat_client {.importc: "wlr_seat_client_for_wl_client".}
proc wlr_seat_set_capabilities*(wlr_seat: ptr wlr_seat; capabilities: uint32_t) {.importc: "wlr_seat_set_capabilities".}
proc wlr_seat_set_name*(wlr_seat: ptr wlr_seat; name: cstring) {.importc: "wlr_seat_set_name".}
proc wlr_seat_pointer_surface_has_focus*(wlr_seat: ptr wlr_seat; surface: ptr wlr_surface): bool {.importc: "wlr_seat_pointer_surface_has_focus".}
proc wlr_seat_pointer_enter*(wlr_seat: ptr wlr_seat; surface: ptr wlr_surface; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_enter".}
proc wlr_seat_pointer_clear_focus*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_pointer_clear_focus".}
proc wlr_seat_pointer_send_motion*(wlr_seat: ptr wlr_seat; time_msec: uint32_t; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_send_motion".}
proc wlr_seat_pointer_send_button*(wlr_seat: ptr wlr_seat; time_msec: uint32_t; button: uint32_t; state: wlr_button_state): uint32_t {.importc: "wlr_seat_pointer_send_button".}
proc wlr_seat_pointer_send_axis*(wlr_seat: ptr wlr_seat; time_msec: uint32_t; orientation: wlr_axis_orientation; value: cdouble; value_discrete: int32_t; source: wlr_axis_source) {.importc: "wlr_seat_pointer_send_axis".}
proc wlr_seat_pointer_send_frame*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_pointer_send_frame".}
proc wlr_seat_pointer_notify_enter*(wlr_seat: ptr wlr_seat; surface: ptr wlr_surface; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_notify_enter".}
proc wlr_seat_pointer_notify_clear_focus*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_pointer_notify_clear_focus".}
proc wlr_seat_pointer_warp*(wlr_seat: ptr wlr_seat; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_warp".}
proc wlr_seat_pointer_notify_motion*(wlr_seat: ptr wlr_seat; time_msec: uint32_t; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_notify_motion".}
proc wlr_seat_pointer_notify_button*(wlr_seat: ptr wlr_seat; time_msec: uint32_t; button: uint32_t; state: wlr_button_state): uint32_t {.importc: "wlr_seat_pointer_notify_button".}
proc wlr_seat_pointer_notify_axis*(wlr_seat: ptr wlr_seat; time_msec: uint32_t; orientation: wlr_axis_orientation; value: cdouble; value_discrete: int32_t; source: wlr_axis_source) {.importc: "wlr_seat_pointer_notify_axis".}
proc wlr_seat_pointer_notify_frame*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_pointer_notify_frame".}
proc wlr_seat_pointer_start_grab*(wlr_seat: ptr wlr_seat; grab: ptr wlr_seat_pointer_grab) {.importc: "wlr_seat_pointer_start_grab".}
proc wlr_seat_pointer_end_grab*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_pointer_end_grab".}
proc wlr_seat_pointer_has_grab*(seat: ptr wlr_seat): bool {.importc: "wlr_seat_pointer_has_grab".}
proc wlr_seat_set_keyboard*(seat: ptr wlr_seat; dev: ptr wlr_input_device) {.importc: "wlr_seat_set_keyboard".}
proc wlr_seat_get_keyboard*(seat: ptr wlr_seat): ptr wlr_keyboard {.importc: "wlr_seat_get_keyboard".}
proc wlr_seat_keyboard_send_key*(seat: ptr wlr_seat; time_msec: uint32_t; key: uint32_t; state: uint32_t) {.importc: "wlr_seat_keyboard_send_key".}
proc wlr_seat_keyboard_send_modifiers*(seat: ptr wlr_seat; modifiers: ptr wlr_keyboard_modifiers) {.importc: "wlr_seat_keyboard_send_modifiers".}
proc wlr_seat_keyboard_enter*(seat: ptr wlr_seat; surface: ptr wlr_surface; keycodes: ptr uint32_t; num_keycodes: csize_t; modifiers: ptr wlr_keyboard_modifiers) {.importc: "wlr_seat_keyboard_enter".}
proc wlr_seat_keyboard_clear_focus*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_keyboard_clear_focus".}
proc wlr_seat_keyboard_notify_key*(seat: ptr wlr_seat; time_msec: uint32_t; key: uint32_t; state: uint32_t) {.importc: "wlr_seat_keyboard_notify_key".}
proc wlr_seat_keyboard_notify_modifiers*(seat: ptr wlr_seat; modifiers: ptr wlr_keyboard_modifiers) {.importc: "wlr_seat_keyboard_notify_modifiers".}
proc wlr_seat_keyboard_notify_enter*(seat: ptr wlr_seat; surface: ptr wlr_surface; keycodes: ptr uint32_t; num_keycodes: csize_t; modifiers: ptr wlr_keyboard_modifiers) {.importc: "wlr_seat_keyboard_notify_enter".}
proc wlr_seat_keyboard_notify_clear_focus*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_keyboard_notify_clear_focus".}
proc wlr_seat_keyboard_start_grab*(wlr_seat: ptr wlr_seat; grab: ptr wlr_seat_keyboard_grab) {.importc: "wlr_seat_keyboard_start_grab".}
proc wlr_seat_keyboard_end_grab*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_keyboard_end_grab".}
proc wlr_seat_keyboard_has_grab*(seat: ptr wlr_seat): bool {.importc: "wlr_seat_keyboard_has_grab".}
proc wlr_seat_touch_get_point*(seat: ptr wlr_seat; touch_id: int32_t): ptr wlr_touch_point {.importc: "wlr_seat_touch_get_point".}
proc wlr_seat_touch_point_focus*(seat: ptr wlr_seat; surface: ptr wlr_surface; time_msec: uint32_t; touch_id: int32_t; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_touch_point_focus".}
proc wlr_seat_touch_point_clear_focus*(seat: ptr wlr_seat; time_msec: uint32_t; touch_id: int32_t) {.importc: "wlr_seat_touch_point_clear_focus".}
proc wlr_seat_touch_send_down*(seat: ptr wlr_seat; surface: ptr wlr_surface; time_msec: uint32_t; touch_id: int32_t; sx: cdouble; sy: cdouble): uint32_t {.importc: "wlr_seat_touch_send_down".}
proc wlr_seat_touch_send_up*(seat: ptr wlr_seat; time_msec: uint32_t; touch_id: int32_t) {.importc: "wlr_seat_touch_send_up".}
proc wlr_seat_touch_send_motion*(seat: ptr wlr_seat; time_msec: uint32_t; touch_id: int32_t; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_touch_send_motion".}
proc wlr_seat_touch_send_frame*(seat: ptr wlr_seat) {.importc: "wlr_seat_touch_send_frame".}
proc wlr_seat_touch_notify_down*(seat: ptr wlr_seat; surface: ptr wlr_surface; time_msec: uint32_t; touch_id: int32_t; sx: cdouble; sy: cdouble): uint32_t {.importc: "wlr_seat_touch_notify_down".}
proc wlr_seat_touch_notify_up*(seat: ptr wlr_seat; time_msec: uint32_t; touch_id: int32_t) {.importc: "wlr_seat_touch_notify_up".}
proc wlr_seat_touch_notify_motion*(seat: ptr wlr_seat; time_msec: uint32_t; touch_id: int32_t; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_touch_notify_motion".}
proc wlr_seat_touch_notify_frame*(seat: ptr wlr_seat) {.importc: "wlr_seat_touch_notify_frame".}
proc wlr_seat_touch_num_points*(seat: ptr wlr_seat): cint {.importc: "wlr_seat_touch_num_points".}
proc wlr_seat_touch_start_grab*(wlr_seat: ptr wlr_seat; grab: ptr wlr_seat_touch_grab) {.importc: "wlr_seat_touch_start_grab".}
proc wlr_seat_touch_end_grab*(wlr_seat: ptr wlr_seat) {.importc: "wlr_seat_touch_end_grab".}
proc wlr_seat_touch_has_grab*(seat: ptr wlr_seat): bool {.importc: "wlr_seat_touch_has_grab".}
proc wlr_seat_validate_grab_serial*(seat: ptr wlr_seat; serial: uint32_t): bool {.importc: "wlr_seat_validate_grab_serial".}
proc wlr_seat_validate_pointer_grab_serial*(seat: ptr wlr_seat; origin: ptr wlr_surface; serial: uint32_t): bool {.importc: "wlr_seat_validate_pointer_grab_serial".}
proc wlr_seat_validate_touch_grab_serial*(seat: ptr wlr_seat; origin: ptr wlr_surface; serial: uint32_t; point_ptr: ptr ptr wlr_touch_point): bool {.importc: "wlr_seat_validate_touch_grab_serial".}
proc wlr_seat_client_next_serial*(client: ptr wlr_seat_client): uint32_t {.importc: "wlr_seat_client_next_serial".}
proc wlr_seat_client_validate_event_serial*(client: ptr wlr_seat_client; serial: uint32_t): bool {.importc: "wlr_seat_client_validate_event_serial".}
proc wlr_seat_client_from_resource*(resource: ptr wl_resource): ptr wlr_seat_client {.importc: "wlr_seat_client_from_resource".}
proc wlr_seat_client_from_pointer_resource*(resource: ptr wl_resource): ptr wlr_seat_client {.importc: "wlr_seat_client_from_pointer_resource".}
proc wlr_surface_accepts_touch*(wlr_seat: ptr wlr_seat; surface: ptr wlr_surface): bool {.importc: "wlr_surface_accepts_touch".}

## wlr_server_decoration

type wlr_server_decoration_manager_mode* = enum
  WLR_SERVER_DECORATION_MANAGER_MODE_NONE = 0,
  WLR_SERVER_DECORATION_MANAGER_MODE_CLIENT = 1,
  WLR_SERVER_DECORATION_MANAGER_MODE_SERVER = 2

type INNER_C_STRUCT_wlr_server_decoration_55* {.bycopy.} = object
  new_decoration*: wl_signal
  destroy*: wl_signal

type wlr_server_decoration_manager* {.bycopy.} = object
  global*: ptr wl_global
  resources*: wl_list
  decorations*: wl_list
  default_mode*: uint32_t
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_server_decoration_55
  data*: pointer

type INNER_C_STRUCT_wlr_server_decoration_70* {.bycopy.} = object
  destroy*: wl_signal
  mode*: wl_signal

type wlr_server_decoration* {.bycopy.} = object
  resource*: ptr wl_resource
  surface*: ptr wlr_surface
  link*: wl_list
  mode*: uint32_t
  events*: INNER_C_STRUCT_wlr_server_decoration_70
  surface_destroy_listener*: wl_listener
  data*: pointer

proc wlr_server_decoration_manager_create*(display: ptr wl_display): ptr wlr_server_decoration_manager {.importc: "wlr_server_decoration_manager_create".}
proc wlr_server_decoration_manager_set_default_mode*(manager: ptr wlr_server_decoration_manager; default_mode: uint32_t) {.importc: "wlr_server_decoration_manager_set_default_mode".}

## wlr_surface

type wlr_surface_state_field* = enum
  WLR_SURFACE_STATE_BUFFER = 1 shl 0, WLR_SURFACE_STATE_SURFACE_DAMAGE = 1 shl 1,
  WLR_SURFACE_STATE_BUFFER_DAMAGE = 1 shl 2,
  WLR_SURFACE_STATE_OPAQUE_REGION = 1 shl 3,
  WLR_SURFACE_STATE_INPUT_REGION = 1 shl 4, WLR_SURFACE_STATE_TRANSFORM = 1 shl 5,
  WLR_SURFACE_STATE_SCALE = 1 shl 6,
  WLR_SURFACE_STATE_FRAME_CALLBACK_LIST = 1 shl 7,
  WLR_SURFACE_STATE_VIEWPORT = 1 shl 8

type INNER_C_STRUCT_wlr_surface_61* {.bycopy.} = object
  has_src*: bool
  has_dst*: bool
  src*: wlr_fbox
  dst_width*: cint
  dst_height*: cint

type wlr_surface_state* {.bycopy.} = object
  committed*: uint32_t
  seq*: uint32_t
  buffer*: ptr wlr_buffer
  dx*: int32_t
  dy*: int32_t
  surface_damage*: pixman_region32_t
  buffer_damage*: pixman_region32_t
  opaque*: pixman_region32_t
  input*: pixman_region32_t
  transform*: wl_output_transform
  scale*: int32_t
  frame_callback_list*: wl_list
  width*: cint
  height*: cint
  buffer_width*: cint
  buffer_height*: cint
  subsurfaces_below*: wl_list
  subsurfaces_above*: wl_list
  viewport*: INNER_C_STRUCT_wlr_surface_61
  cached_state_locks*: csize_t
  cached_state_link*: wl_list

type wlr_surface_role* {.bycopy.} = object
  name*: cstring
  commit*: proc (surface: ptr wlr_surface)
  precommit*: proc (surface: ptr wlr_surface)

type wlr_surface_output* {.bycopy.} = object
  surface*: ptr wlr_surface
  output*: ptr wlr_output
  link*: wl_list
  `bind`*: wl_listener
  destroy*: wl_listener

type INNER_C_STRUCT_wlr_surface_143* {.bycopy.} = object
  commit*: wl_signal
  new_subsurface*: wl_signal
  destroy*: wl_signal

type INNER_C_STRUCT_wlr_surface_158* {.bycopy.} = object
  scale*: int32_t
  transform*: wl_output_transform
  width*: cint
  height*: cint
  buffer_width*: cint
  buffer_height*: cint

type wlr_surface* {.bycopy.} = object
  resource*: ptr wl_resource
  renderer*: ptr wlr_renderer
  buffer*: ptr wlr_client_buffer
  sx*: cint
  sy*: cint
  buffer_damage*: pixman_region32_t
  external_damage*: pixman_region32_t
  opaque_region*: pixman_region32_t
  input_region*: pixman_region32_t
  current*: wlr_surface_state
  pending*: wlr_surface_state
  cached*: wl_list
  role*: ptr wlr_surface_role
  role_data*: pointer
  events*: INNER_C_STRUCT_wlr_surface_143
  current_outputs*: wl_list
  addons*: wlr_addon_set
  data*: pointer
  renderer_destroy*: wl_listener
  previous*: INNER_C_STRUCT_wlr_surface_158

type wlr_subsurface_parent_state* {.bycopy.} = object
  x*: int32_t
  y*: int32_t
  link*: wl_list

type INNER_C_STRUCT_wlr_surface_194* {.bycopy.} = object
  destroy*: wl_signal
  map*: wl_signal
  unmap*: wl_signal

type wlr_subsurface* {.bycopy.} = object
  resource*: ptr wl_resource
  surface*: ptr wlr_surface
  parent*: ptr wlr_surface
  current*: wlr_subsurface_parent_state
  pending*: wlr_subsurface_parent_state
  cached_seq*: uint32_t
  has_cache*: bool
  synchronized*: bool
  reordered*: bool
  mapped*: bool
  added*: bool
  surface_destroy*: wl_listener
  parent_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_surface_194
  data*: pointer

type wlr_surface_iterator_func_t* = proc (surface: ptr wlr_surface; sx: cint; sy: cint; data: pointer)

proc wlr_surface_set_role*(surface: ptr wlr_surface; role: ptr wlr_surface_role; role_data: pointer; error_resource: ptr wl_resource; error_code: uint32_t): bool {.importc: "wlr_surface_set_role".}
proc wlr_surface_has_buffer*(surface: ptr wlr_surface): bool {.importc: "wlr_surface_has_buffer".}
proc wlr_surface_get_texture*(surface: ptr wlr_surface): ptr wlr_texture {.importc: "wlr_surface_get_texture".}
proc wlr_surface_get_root_surface*(surface: ptr wlr_surface): ptr wlr_surface {.importc: "wlr_surface_get_root_surface".}
proc wlr_surface_point_accepts_input*(surface: ptr wlr_surface; sx: cdouble; sy: cdouble): bool {.importc: "wlr_surface_point_accepts_input".}
proc wlr_surface_surface_at*(surface: ptr wlr_surface; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr wlr_surface {.importc: "wlr_surface_surface_at".}
proc wlr_surface_send_enter*(surface: ptr wlr_surface; output: ptr wlr_output) {.importc: "wlr_surface_send_enter".}
proc wlr_surface_send_leave*(surface: ptr wlr_surface; output: ptr wlr_output) {.importc: "wlr_surface_send_leave".}
proc wlr_surface_send_frame_done*(surface: ptr wlr_surface; `when`: ptr timespec) {.importc: "wlr_surface_send_frame_done".}
proc wlr_surface_get_extends*(surface: ptr wlr_surface; box: ptr wlr_box) {.importc: "wlr_surface_get_extends".}
proc wlr_surface_from_resource*(resource: ptr wl_resource): ptr wlr_surface {.importc: "wlr_surface_from_resource".}
proc wlr_surface_for_each_surface*(surface: ptr wlr_surface; `iterator`: wlr_surface_iterator_func_t; user_data: pointer) {.importc: "wlr_surface_for_each_surface".}
proc wlr_surface_get_effective_damage*(surface: ptr wlr_surface; damage: ptr pixman_region32_t) {.importc: "wlr_surface_get_effective_damage".}
proc wlr_surface_get_buffer_source_box*(surface: ptr wlr_surface; box: ptr wlr_fbox) {.importc: "wlr_surface_get_buffer_source_box".}
proc wlr_surface_lock_pending*(surface: ptr wlr_surface): uint32_t {.importc: "wlr_surface_lock_pending".}
proc wlr_surface_unlock_cached*(surface: ptr wlr_surface; seq: uint32_t) {.importc: "wlr_surface_unlock_cached".}

## wlr_switch

discard "forward decl of wlr_switch_impl"
type INNER_C_STRUCT_wlr_switch_22* {.bycopy.} = object
  toggle*: wl_signal

type wlr_switch* {.bycopy.} = object
  impl*: ptr wlr_switch_impl
  events*: INNER_C_STRUCT_wlr_switch_22
  data*: pointer

type wlr_switch_type* = enum
  WLR_SWITCH_TYPE_LID = 1, WLR_SWITCH_TYPE_TABLET_MODE

type wlr_switch_state* = enum
  WLR_SWITCH_STATE_OFF = 0, WLR_SWITCH_STATE_ON, WLR_SWITCH_STATE_TOGGLE

type wlr_event_switch_toggle* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  switch_type*: wlr_switch_type
  switch_state*: wlr_switch_state

## wlr_tablet_pad

discard "forward decl of wlr_tablet_pad_impl"
type INNER_C_STRUCT_wlr_tablet_pad_28* {.bycopy.} = object
  button*: wl_signal
  ring*: wl_signal
  strip*: wl_signal
  attach_tablet*: wl_signal

type wlr_tablet_pad* {.bycopy.} = object
  impl*: ptr wlr_tablet_pad_impl
  events*: INNER_C_STRUCT_wlr_tablet_pad_28
  button_count*: csize_t
  ring_count*: csize_t
  strip_count*: csize_t
  groups*: wl_list
  paths*: wl_array
  data*: pointer

type wlr_tablet_pad_group* {.bycopy.} = object
  link*: wl_list
  button_count*: csize_t
  buttons*: ptr cuint
  strip_count*: csize_t
  strips*: ptr cuint
  ring_count*: csize_t
  rings*: ptr cuint
  mode_count*: cuint

type wlr_event_tablet_pad_button* {.bycopy.} = object
  time_msec*: uint32_t
  button*: uint32_t
  state*: wlr_button_state
  mode*: cuint
  group*: cuint

type wlr_tablet_pad_ring_source* = enum
  WLR_TABLET_PAD_RING_SOURCE_UNKNOWN, WLR_TABLET_PAD_RING_SOURCE_FINGER

type wlr_event_tablet_pad_ring* {.bycopy.} = object
  time_msec*: uint32_t
  source*: wlr_tablet_pad_ring_source
  ring*: uint32_t
  position*: cdouble
  mode*: cuint

type wlr_tablet_pad_strip_source* = enum
  WLR_TABLET_PAD_STRIP_SOURCE_UNKNOWN, WLR_TABLET_PAD_STRIP_SOURCE_FINGER

type wlr_event_tablet_pad_strip* {.bycopy.} = object
  time_msec*: uint32_t
  source*: wlr_tablet_pad_strip_source
  strip*: uint32_t
  position*: cdouble
  mode*: cuint

## wlr_tablet_tool

type wlr_tablet_tool_type* = enum
  WLR_TABLET_TOOL_TYPE_PEN = 1,
  WLR_TABLET_TOOL_TYPE_ERASER,
  WLR_TABLET_TOOL_TYPE_BRUSH,
  WLR_TABLET_TOOL_TYPE_PENCIL,
  WLR_TABLET_TOOL_TYPE_AIRBRUSH,
  WLR_TABLET_TOOL_TYPE_MOUSE,
  WLR_TABLET_TOOL_TYPE_LENS,
  WLR_TABLET_TOOL_TYPE_TOTEM

type INNER_C_STRUCT_wlr_tablet_tool_54* {.bycopy.} = object
  destroy*: wl_signal

type wlr_tablet_tool* {.bycopy.} = object
  `type`*: wlr_tablet_tool_type
  hardware_serial*: uint64_t
  hardware_wacom*: uint64_t
  tilt*: bool
  pressure*: bool
  distance*: bool
  rotation*: bool
  slider*: bool
  wheel*: bool
  events*: INNER_C_STRUCT_wlr_tablet_tool_54
  data*: pointer

discard "forward decl of wlr_tablet_impl"
type INNER_C_STRUCT_wlr_tablet_tool_66* {.bycopy.} = object
  axis*: wl_signal
  proximity*: wl_signal
  tip*: wl_signal
  button*: wl_signal

type wlr_tablet* {.bycopy.} = object
  impl*: ptr wlr_tablet_impl
  events*: INNER_C_STRUCT_wlr_tablet_tool_66
  name*: cstring
  paths*: wl_array
  data*: pointer

type wlr_tablet_tool_axes* = enum
  WLR_TABLET_TOOL_AXIS_X = 1 shl 0, WLR_TABLET_TOOL_AXIS_Y = 1 shl 1,
  WLR_TABLET_TOOL_AXIS_DISTANCE = 1 shl 2, WLR_TABLET_TOOL_AXIS_PRESSURE = 1 shl 3,
  WLR_TABLET_TOOL_AXIS_TILT_X = 1 shl 4, WLR_TABLET_TOOL_AXIS_TILT_Y = 1 shl 5,
  WLR_TABLET_TOOL_AXIS_ROTATION = 1 shl 6, WLR_TABLET_TOOL_AXIS_SLIDER = 1 shl 7,
  WLR_TABLET_TOOL_AXIS_WHEEL = 1 shl 8

type wlr_event_tablet_tool_axis* {.bycopy.} = object
  device*: ptr wlr_input_device
  tool*: ptr wlr_tablet_tool
  time_msec*: uint32_t
  updated_axes*: uint32_t
  x*: cdouble
  y*: cdouble
  dx*: cdouble
  dy*: cdouble
  pressure*: cdouble
  distance*: cdouble
  tilt_x*: cdouble
  tilt_y*: cdouble
  rotation*: cdouble
  slider*: cdouble
  wheel_delta*: cdouble

type wlr_tablet_tool_proximity_state* = enum
  WLR_TABLET_TOOL_PROXIMITY_OUT, WLR_TABLET_TOOL_PROXIMITY_IN

type wlr_event_tablet_tool_proximity* {.bycopy.} = object
  device*: ptr wlr_input_device
  tool*: ptr wlr_tablet_tool
  time_msec*: uint32_t
  x*: cdouble
  y*: cdouble
  state*: wlr_tablet_tool_proximity_state

type wlr_tablet_tool_tip_state* = enum
  WLR_TABLET_TOOL_TIP_UP, WLR_TABLET_TOOL_TIP_DOWN

type wlr_event_tablet_tool_tip* {.bycopy.} = object
  device*: ptr wlr_input_device
  tool*: ptr wlr_tablet_tool
  time_msec*: uint32_t
  x*: cdouble
  y*: cdouble
  state*: wlr_tablet_tool_tip_state

type wlr_event_tablet_tool_button* {.bycopy.} = object
  device*: ptr wlr_input_device
  tool*: ptr wlr_tablet_tool
  time_msec*: uint32_t
  button*: uint32_t
  state*: wlr_button_state

## wlr_tablet_v2

import tablet-unstable-v2-protocol

const WLR_TABLET_V2_TOOL_BUTTONS_CAP* = 16

discard "forward decl of wlr_tablet_pad_v2_grab_interface"
type wlr_tablet_pad_v2_grab* {.bycopy.} = object
  `interface`*: ptr wlr_tablet_pad_v2_grab_interface
  pad*: ptr wlr_tablet_v2_tablet_pad
  data*: pointer

discard "forward decl of wlr_tablet_tool_v2_grab_interface"
type wlr_tablet_tool_v2_grab* {.bycopy.} = object
  `interface`*: ptr wlr_tablet_tool_v2_grab_interface
  tool*: ptr wlr_tablet_v2_tablet_tool
  data*: pointer

discard "forward decl of wlr_tablet_client_v2"
discard "forward decl of wlr_tablet_tool_client_v2"
discard "forward decl of wlr_tablet_pad_client_v2"
type INNER_C_STRUCT_wlr_tablet_v2_49* {.bycopy.} = object
  destroy*: wl_signal

type wlr_tablet_manager_v2* {.bycopy.} = object
  wl_global*: ptr wl_global
  clients*: wl_list
  seats*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_tablet_v2_49
  data*: pointer

type wlr_tablet_v2_tablet* {.bycopy.} = object
  link*: wl_list
  wlr_tablet*: ptr wlr_tablet
  wlr_device*: ptr wlr_input_device
  clients*: wl_list
  tool_destroy*: wl_listener
  current_client*: ptr wlr_tablet_client_v2

type INNER_C_STRUCT_wlr_tablet_v2_88* {.bycopy.} = object
  set_cursor*: wl_signal

type wlr_tablet_v2_tablet_tool* {.bycopy.} = object
  link*: wl_list
  wlr_tool*: ptr wlr_tablet_tool
  clients*: wl_list
  tool_destroy*: wl_listener
  current_client*: ptr wlr_tablet_tool_client_v2
  focused_surface*: ptr wlr_surface
  surface_destroy*: wl_listener
  grab*: ptr wlr_tablet_tool_v2_grab
  default_grab*: wlr_tablet_tool_v2_grab
  proximity_serial*: uint32_t
  is_down*: bool
  down_serial*: uint32_t
  num_buttons*: csize_t
  pressed_buttons*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32_t]
  pressed_serials*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32_t]
  events*: INNER_C_STRUCT_wlr_tablet_v2_88

type INNER_C_STRUCT_wlr_tablet_v2_108* {.bycopy.} = object
  button_feedback*: wl_signal
  strip_feedback*: wl_signal
  ring_feedback*: wl_signal

type wlr_tablet_v2_tablet_pad* {.bycopy.} = object
  link*: wl_list
  wlr_pad*: ptr wlr_tablet_pad
  wlr_device*: ptr wlr_input_device
  clients*: wl_list
  group_count*: csize_t
  groups*: ptr uint32_t
  pad_destroy*: wl_listener
  current_client*: ptr wlr_tablet_pad_client_v2
  grab*: ptr wlr_tablet_pad_v2_grab
  default_grab*: wlr_tablet_pad_v2_grab
  events*: INNER_C_STRUCT_wlr_tablet_v2_108

type wlr_tablet_v2_event_cursor* {.bycopy.} = object
  surface*: ptr wlr_surface
  serial*: uint32_t
  hotspot_x*: int32_t
  hotspot_y*: int32_t
  seat_client*: ptr wlr_seat_client

type wlr_tablet_v2_event_feedback* {.bycopy.} = object
  description*: cstring
  index*: csize_t
  serial*: uint32_t

proc wlr_tablet_create*(manager: ptr wlr_tablet_manager_v2; wlr_seat: ptr wlr_seat; wlr_device: ptr wlr_input_device): ptr wlr_tablet_v2_tablet {.importc: "wlr_tablet_create".}
proc wlr_tablet_pad_create*(manager: ptr wlr_tablet_manager_v2; wlr_seat: ptr wlr_seat; wlr_device: ptr wlr_input_device): ptr wlr_tablet_v2_tablet_pad {.importc: "wlr_tablet_pad_create".}
proc wlr_tablet_tool_create*(manager: ptr wlr_tablet_manager_v2; wlr_seat: ptr wlr_seat; wlr_tool: ptr wlr_tablet_tool): ptr wlr_tablet_v2_tablet_tool {.importc: "wlr_tablet_tool_create".}
proc wlr_tablet_v2_create*(display: ptr wl_display): ptr wlr_tablet_manager_v2 {.importc: "wlr_tablet_v2_create".}
proc wlr_send_tablet_v2_tablet_tool_proximity_in*(tool: ptr wlr_tablet_v2_tablet_tool; tablet: ptr wlr_tablet_v2_tablet; surface: ptr wlr_surface) {.importc: "wlr_send_tablet_v2_tablet_tool_proximity_in".}
proc wlr_send_tablet_v2_tablet_tool_down*(tool: ptr wlr_tablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_down".}
proc wlr_send_tablet_v2_tablet_tool_up*(tool: ptr wlr_tablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_up".}
proc wlr_send_tablet_v2_tablet_tool_motion*(tool: ptr wlr_tablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_motion".}
proc wlr_send_tablet_v2_tablet_tool_pressure*(tool: ptr wlr_tablet_v2_tablet_tool; pressure: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_pressure".}
proc wlr_send_tablet_v2_tablet_tool_distance*(tool: ptr wlr_tablet_v2_tablet_tool; distance: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_distance".}
proc wlr_send_tablet_v2_tablet_tool_tilt*(tool: ptr wlr_tablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_tilt".}
proc wlr_send_tablet_v2_tablet_tool_rotation*(tool: ptr wlr_tablet_v2_tablet_tool; degrees: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_rotation".}
proc wlr_send_tablet_v2_tablet_tool_slider*(tool: ptr wlr_tablet_v2_tablet_tool; position: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_slider".}
proc wlr_send_tablet_v2_tablet_tool_wheel*(tool: ptr wlr_tablet_v2_tablet_tool; degrees: cdouble; clicks: int32_t) {.importc: "wlr_send_tablet_v2_tablet_tool_wheel".}
proc wlr_send_tablet_v2_tablet_tool_proximity_out*(tool: ptr wlr_tablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_proximity_out".}
proc wlr_send_tablet_v2_tablet_tool_button*(tool: ptr wlr_tablet_v2_tablet_tool; button: uint32_t; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_send_tablet_v2_tablet_tool_button".}
proc wlr_tablet_v2_tablet_tool_notify_proximity_in*(tool: ptr wlr_tablet_v2_tablet_tool; tablet: ptr wlr_tablet_v2_tablet; surface: ptr wlr_surface) {.importc: "wlr_tablet_v2_tablet_tool_notify_proximity_in".}
proc wlr_tablet_v2_tablet_tool_notify_down*(tool: ptr wlr_tablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_down".}
proc wlr_tablet_v2_tablet_tool_notify_up*(tool: ptr wlr_tablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_up".}
proc wlr_tablet_v2_tablet_tool_notify_motion*(tool: ptr wlr_tablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_motion".}
proc wlr_tablet_v2_tablet_tool_notify_pressure*(tool: ptr wlr_tablet_v2_tablet_tool; pressure: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_pressure".}
proc wlr_tablet_v2_tablet_tool_notify_distance*(tool: ptr wlr_tablet_v2_tablet_tool; distance: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_distance".}
proc wlr_tablet_v2_tablet_tool_notify_tilt*(tool: ptr wlr_tablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_tilt".}
proc wlr_tablet_v2_tablet_tool_notify_rotation*(tool: ptr wlr_tablet_v2_tablet_tool; degrees: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_rotation".}
proc wlr_tablet_v2_tablet_tool_notify_slider*(tool: ptr wlr_tablet_v2_tablet_tool; position: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_slider".}
proc wlr_tablet_v2_tablet_tool_notify_wheel*(tool: ptr wlr_tablet_v2_tablet_tool; degrees: cdouble; clicks: int32_t) {.importc: "wlr_tablet_v2_tablet_tool_notify_wheel".}
proc wlr_tablet_v2_tablet_tool_notify_proximity_out*(tool: ptr wlr_tablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_proximity_out".}
proc wlr_tablet_v2_tablet_tool_notify_button*(tool: ptr wlr_tablet_v2_tablet_tool; button: uint32_t; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_tablet_v2_tablet_tool_notify_button".}

type wlr_tablet_tool_v2_grab_interface* {.bycopy.} = object
  proximity_in*: proc (grab: ptr wlr_tablet_tool_v2_grab; tablet: ptr wlr_tablet_v2_tablet; surface: ptr wlr_surface)
  down*: proc (grab: ptr wlr_tablet_tool_v2_grab)
  up*: proc (grab: ptr wlr_tablet_tool_v2_grab)
  motion*: proc (grab: ptr wlr_tablet_tool_v2_grab; x: cdouble; y: cdouble)
  pressure*: proc (grab: ptr wlr_tablet_tool_v2_grab; pressure: cdouble)
  distance*: proc (grab: ptr wlr_tablet_tool_v2_grab; distance: cdouble)
  tilt*: proc (grab: ptr wlr_tablet_tool_v2_grab; x: cdouble; y: cdouble)
  rotation*: proc (grab: ptr wlr_tablet_tool_v2_grab; degrees: cdouble)
  slider*: proc (grab: ptr wlr_tablet_tool_v2_grab; position: cdouble)
  wheel*: proc (grab: ptr wlr_tablet_tool_v2_grab; degrees: cdouble; clicks: int32_t)
  proximity_out*: proc (grab: ptr wlr_tablet_tool_v2_grab)
  button*: proc (grab: ptr wlr_tablet_tool_v2_grab; button: uint32_t; state: zwp_tablet_pad_v2_button_state)
  cancel*: proc (grab: ptr wlr_tablet_tool_v2_grab)

proc wlr_tablet_tool_v2_start_grab*(tool: ptr wlr_tablet_v2_tablet_tool; grab: ptr wlr_tablet_tool_v2_grab) {.importc: "wlr_tablet_tool_v2_start_grab".}
proc wlr_tablet_tool_v2_end_grab*(tool: ptr wlr_tablet_v2_tablet_tool) {.importc: "wlr_tablet_tool_v2_end_grab".}
proc wlr_tablet_tool_v2_start_implicit_grab*(tool: ptr wlr_tablet_v2_tablet_tool) {.importc: "wlr_tablet_tool_v2_start_implicit_grab".}
proc wlr_tablet_tool_v2_has_implicit_grab*(tool: ptr wlr_tablet_v2_tablet_tool): bool {.importc: "wlr_tablet_tool_v2_has_implicit_grab".}
proc wlr_send_tablet_v2_tablet_pad_enter*(pad: ptr wlr_tablet_v2_tablet_pad; tablet: ptr wlr_tablet_v2_tablet; surface: ptr wlr_surface): uint32_t {.importc: "wlr_send_tablet_v2_tablet_pad_enter".}
proc wlr_send_tablet_v2_tablet_pad_button*(pad: ptr wlr_tablet_v2_tablet_pad; button: csize_t; time: uint32_t; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_send_tablet_v2_tablet_pad_button".}
proc wlr_send_tablet_v2_tablet_pad_strip*(pad: ptr wlr_tablet_v2_tablet_pad; strip: uint32_t; position: cdouble; finger: bool; time: uint32_t) {.importc: "wlr_send_tablet_v2_tablet_pad_strip".}
proc wlr_send_tablet_v2_tablet_pad_ring*(pad: ptr wlr_tablet_v2_tablet_pad; ring: uint32_t; position: cdouble; finger: bool; time: uint32_t) {.importc: "wlr_send_tablet_v2_tablet_pad_ring".}
proc wlr_send_tablet_v2_tablet_pad_leave*(pad: ptr wlr_tablet_v2_tablet_pad; surface: ptr wlr_surface): uint32_t {.importc: "wlr_send_tablet_v2_tablet_pad_leave".}
proc wlr_send_tablet_v2_tablet_pad_mode*(pad: ptr wlr_tablet_v2_tablet_pad; group: csize_t; mode: uint32_t; time: uint32_t): uint32_t {.importc: "wlr_send_tablet_v2_tablet_pad_mode".}
proc wlr_tablet_v2_tablet_pad_notify_enter*(pad: ptr wlr_tablet_v2_tablet_pad; tablet: ptr wlr_tablet_v2_tablet; surface: ptr wlr_surface): uint32_t {.importc: "wlr_tablet_v2_tablet_pad_notify_enter".}
proc wlr_tablet_v2_tablet_pad_notify_button*(pad: ptr wlr_tablet_v2_tablet_pad; button: csize_t; time: uint32_t; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_tablet_v2_tablet_pad_notify_button".}
proc wlr_tablet_v2_tablet_pad_notify_strip*(pad: ptr wlr_tablet_v2_tablet_pad; strip: uint32_t; position: cdouble; finger: bool; time: uint32_t) {.importc: "wlr_tablet_v2_tablet_pad_notify_strip".}
proc wlr_tablet_v2_tablet_pad_notify_ring*(pad: ptr wlr_tablet_v2_tablet_pad; ring: uint32_t; position: cdouble; finger: bool; time: uint32_t) {.importc: "wlr_tablet_v2_tablet_pad_notify_ring".}
proc wlr_tablet_v2_tablet_pad_notify_leave*(pad: ptr wlr_tablet_v2_tablet_pad; surface: ptr wlr_surface): uint32_t {.importc: "wlr_tablet_v2_tablet_pad_notify_leave".}
proc wlr_tablet_v2_tablet_pad_notify_mode*(pad: ptr wlr_tablet_v2_tablet_pad; group: csize_t; mode: uint32_t; time: uint32_t): uint32_t {.importc: "wlr_tablet_v2_tablet_pad_notify_mode".}

type wlr_tablet_pad_v2_grab_interface* {.bycopy.} = object
  enter*: proc (grab: ptr wlr_tablet_pad_v2_grab; tablet: ptr wlr_tablet_v2_tablet; surface: ptr wlr_surface): uint32_t
  button*: proc (grab: ptr wlr_tablet_pad_v2_grab; button: csize_t; time: uint32_t; state: zwp_tablet_pad_v2_button_state)
  strip*: proc (grab: ptr wlr_tablet_pad_v2_grab; strip: uint32_t; position: cdouble; finger: bool; time: uint32_t)
  ring*: proc (grab: ptr wlr_tablet_pad_v2_grab; ring: uint32_t; position: cdouble; finger: bool; time: uint32_t)
  leave*: proc (grab: ptr wlr_tablet_pad_v2_grab; surface: ptr wlr_surface): uint32_t
  mode*: proc (grab: ptr wlr_tablet_pad_v2_grab; group: csize_t; mode: uint32_t; time: uint32_t): uint32_t
  cancel*: proc (grab: ptr wlr_tablet_pad_v2_grab)

proc wlr_tablet_v2_end_grab*(pad: ptr wlr_tablet_v2_tablet_pad) {.importc: "wlr_tablet_v2_end_grab".}
proc wlr_tablet_v2_start_grab*(pad: ptr wlr_tablet_v2_tablet_pad; grab: ptr wlr_tablet_pad_v2_grab) {.importc: "wlr_tablet_v2_start_grab".}
proc wlr_surface_accepts_tablet_v2*(tablet: ptr wlr_tablet_v2_tablet; surface: ptr wlr_surface): bool {.importc: "wlr_surface_accepts_tablet_v2".}

## wlr_text_input_v3

type wlr_text_input_v3_features* = enum
  WLR_TEXT_INPUT_V3_FEATURE_SURROUNDING_TEXT = 1 shl 0,
  WLR_TEXT_INPUT_V3_FEATURE_CONTENT_TYPE = 1 shl 1,
  WLR_TEXT_INPUT_V3_FEATURE_CURSOR_RECTANGLE = 1 shl 2

type INNER_C_STRUCT_wlr_text_input_v3_25* {.bycopy.} = object
  text*: cstring
  cursor*: uint32_t
  anchor*: uint32_t

type INNER_C_STRUCT_wlr_text_input_v3_33* {.bycopy.} = object
  hint*: uint32_t
  purpose*: uint32_t

type wlr_text_input_v3_state* {.bycopy.} = object
  surrounding*: INNER_C_STRUCT_wlr_text_input_v3_25
  text_change_cause*: uint32_t
  content_type*: INNER_C_STRUCT_wlr_text_input_v3_33
  cursor_rectangle*: wlr_box
  features*: uint32_t

type INNER_C_STRUCT_wlr_text_input_v3_62* {.bycopy.} = object
  enable*: wl_signal
  commit*: wl_signal
  disable*: wl_signal
  destroy*: wl_signal

type wlr_text_input_v3* {.bycopy.} = object
  seat*: ptr wlr_seat
  resource*: ptr wl_resource
  focused_surface*: ptr wlr_surface
  pending*: wlr_text_input_v3_state
  current*: wlr_text_input_v3_state
  current_serial*: uint32_t
  pending_enabled*: bool
  current_enabled*: bool
  active_features*: uint32_t
  link*: wl_list
  surface_destroy*: wl_listener
  seat_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_text_input_v3_62

type INNER_C_STRUCT_wlr_text_input_v3_76* {.bycopy.} = object
  text_input*: wl_signal
  destroy*: wl_signal

type wlr_text_input_manager_v3* {.bycopy.} = object
  global*: ptr wl_global
  text_inputs*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_text_input_v3_76

proc wlr_text_input_manager_v3_create*(wl_display: ptr wl_display): ptr wlr_text_input_manager_v3 {.importc: "wlr_text_input_manager_v3_create".}
proc wlr_text_input_v3_send_enter*(text_input: ptr wlr_text_input_v3; wlr_surface: ptr wlr_surface) {.importc: "wlr_text_input_v3_send_enter".}
proc wlr_text_input_v3_send_leave*(text_input: ptr wlr_text_input_v3) {.importc: "wlr_text_input_v3_send_leave".}
proc wlr_text_input_v3_send_preedit_string*(text_input: ptr wlr_text_input_v3; text: cstring; cursor_begin: int32_t; cursor_end: int32_t) {.importc: "wlr_text_input_v3_send_preedit_string".}
proc wlr_text_input_v3_send_commit_string*(text_input: ptr wlr_text_input_v3; text: cstring) {.importc: "wlr_text_input_v3_send_commit_string".}
proc wlr_text_input_v3_send_delete_surrounding_text*(text_input: ptr wlr_text_input_v3; before_length: uint32_t; after_length: uint32_t) {.importc: "wlr_text_input_v3_send_delete_surrounding_text".}
proc wlr_text_input_v3_send_done*(text_input: ptr wlr_text_input_v3) {.importc: "wlr_text_input_v3_send_done".}

## wlr_touch

discard "forward decl of wlr_touch_impl"
type INNER_C_STRUCT_wlr_touch_21* {.bycopy.} = object
  down*: wl_signal
  up*: wl_signal
  motion*: wl_signal
  cancel*: wl_signal
  frame*: wl_signal

type wlr_touch* {.bycopy.} = object
  impl*: ptr wlr_touch_impl
  events*: INNER_C_STRUCT_wlr_touch_21
  data*: pointer

type wlr_event_touch_down* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  touch_id*: int32_t
  x*: cdouble
  y*: cdouble

type wlr_event_touch_up* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  touch_id*: int32_t

type wlr_event_touch_motion* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  touch_id*: int32_t
  x*: cdouble
  y*: cdouble

type wlr_event_touch_cancel* {.bycopy.} = object
  device*: ptr wlr_input_device
  time_msec*: uint32_t
  touch_id*: int32_t

## wlr_viewporter

type INNER_C_STRUCT_wlr_viewporter_29* {.bycopy.} = object
  destroy*: wl_signal

type wlr_viewporter* {.bycopy.} = object
  global*: ptr wl_global
  events*: INNER_C_STRUCT_wlr_viewporter_29
  display_destroy*: wl_listener

proc wlr_viewporter_create*(display: ptr wl_display): ptr wlr_viewporter {.importc: "wlr_viewporter_create".}

## wlr_virtual_keyboard_v1

type INNER_C_STRUCT_wlr_virtual_keyboard_v1_23* {.bycopy.} = object
  new_virtual_keyboard*: wl_signal
  destroy*: wl_signal

type wlr_virtual_keyboard_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  virtual_keyboards*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_virtual_keyboard_v1_23

type INNER_C_STRUCT_wlr_virtual_keyboard_v1_37* {.bycopy.} = object
  destroy*: wl_signal

type wlr_virtual_keyboard_v1* {.bycopy.} = object
  input_device*: wlr_input_device
  resource*: ptr wl_resource
  seat*: ptr wlr_seat
  has_keymap*: bool
  link*: wl_list
  events*: INNER_C_STRUCT_wlr_virtual_keyboard_v1_37

proc wlr_virtual_keyboard_manager_v1_create*(display: ptr wl_display): ptr wlr_virtual_keyboard_manager_v1 {.importc: "wlr_virtual_keyboard_manager_v1_create".}
proc wlr_input_device_get_virtual_keyboard*(wlr_dev: ptr wlr_input_device): ptr wlr_virtual_keyboard_v1 {.importc: "wlr_input_device_get_virtual_keyboard".}

## wlr_virtual_pointer_v1

type INNER_C_STRUCT_wlr_virtual_pointer_v1_25* {.bycopy.} = object
  new_virtual_pointer*: wl_signal
  destroy*: wl_signal

type wlr_virtual_pointer_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  virtual_pointers*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_virtual_pointer_v1_25

type INNER_C_STRUCT_wlr_virtual_pointer_v1_41* {.bycopy.} = object
  destroy*: wl_signal

type wlr_virtual_pointer_v1* {.bycopy.} = object
  input_device*: wlr_input_device
  resource*: ptr wl_resource
  axis_event*: array[2, wlr_event_pointer_axis]
  axis*: wl_pointer_axis
  axis_valid*: array[2, bool]
  link*: wl_list
  events*: INNER_C_STRUCT_wlr_virtual_pointer_v1_41

type wlr_virtual_pointer_v1_new_pointer_event* {.bycopy.} = object
  new_pointer*: ptr wlr_virtual_pointer_v1
  suggested_seat*: ptr wlr_seat
  suggested_output*: ptr wlr_output

proc wlr_virtual_pointer_manager_v1_create*(display: ptr wl_display): ptr wlr_virtual_pointer_manager_v1 {.importc: "wlr_virtual_pointer_manager_v1_create".}

## wlr_xcursor_manager

type wlr_xcursor_manager_theme* {.bycopy.} = object
  scale*: cfloat
  theme*: ptr wlr_xcursor_theme
  link*: wl_list

type wlr_xcursor_manager* {.bycopy.} = object
  name*: cstring
  size*: uint32_t
  scaled_themes*: wl_list

proc wlr_xcursor_manager_create*(name: cstring; size: uint32_t): ptr wlr_xcursor_manager {.importc: "wlr_xcursor_manager_create".}
proc wlr_xcursor_manager_destroy*(manager: ptr wlr_xcursor_manager) {.importc: "wlr_xcursor_manager_destroy".}
proc wlr_xcursor_manager_load*(manager: ptr wlr_xcursor_manager; scale: cfloat): bool {.importc: "wlr_xcursor_manager_load".}
proc wlr_xcursor_manager_get_xcursor*(manager: ptr wlr_xcursor_manager; name: cstring; scale: cfloat): ptr wlr_xcursor {.importc: "wlr_xcursor_manager_get_xcursor".}
proc wlr_xcursor_manager_set_cursor_image*(manager: ptr wlr_xcursor_manager; name: cstring; cursor: ptr wlr_cursor) {.importc: "wlr_xcursor_manager_set_cursor_image".}

## wlr_xdg_activation_v1

type INNER_C_STRUCT_wlr_xdg_activation_v1_28* {.bycopy.} = object
  destroy*: wl_signal

type wlr_xdg_activation_token_v1* {.bycopy.} = object
  activation*: ptr wlr_xdg_activation_v1
  surface*: ptr wlr_surface
  seat*: ptr wlr_seat
  serial*: uint32_t
  app_id*: cstring
  link*: wl_list
  data*: pointer
  events*: INNER_C_STRUCT_wlr_xdg_activation_v1_28
  token*: cstring
  resource*: ptr wl_resource
  timeout*: ptr wl_event_source
  seat_destroy*: wl_listener
  surface_destroy*: wl_listener

type INNER_C_STRUCT_wlr_xdg_activation_v1_47* {.bycopy.} = object
  destroy*: wl_signal
  request_activate*: wl_signal

type wlr_xdg_activation_v1* {.bycopy.} = object
  token_timeout_msec*: uint32_t
  tokens*: wl_list
  events*: INNER_C_STRUCT_wlr_xdg_activation_v1_47
  display*: ptr wl_display
  global*: ptr wl_global
  display_destroy*: wl_listener

type wlr_xdg_activation_v1_request_activate_event* {.bycopy.} = object
  activation*: ptr wlr_xdg_activation_v1
  token*: ptr wlr_xdg_activation_token_v1
  surface*: ptr wlr_surface

proc wlr_xdg_activation_v1_create*(display: ptr wl_display): ptr wlr_xdg_activation_v1 {.importc: "wlr_xdg_activation_v1_create".}
proc wlr_xdg_activation_token_v1_create*(activation: ptr wlr_xdg_activation_v1): ptr wlr_xdg_activation_token_v1 {.importc: "wlr_xdg_activation_token_v1_create".}
proc wlr_xdg_activation_token_v1_destroy*(token: ptr wlr_xdg_activation_token_v1) {.importc: "wlr_xdg_activation_token_v1_destroy".}
proc wlr_xdg_activation_v1_find_token*(activation: ptr wlr_xdg_activation_v1; token_str: cstring): ptr wlr_xdg_activation_token_v1 {.importc: "wlr_xdg_activation_v1_find_token".}
proc wlr_xdg_activation_token_v1_get_name*(token: ptr wlr_xdg_activation_token_v1): cstring {.importc: "wlr_xdg_activation_token_v1_get_name".}
proc wlr_xdg_activation_v1_add_token*(activation: ptr wlr_xdg_activation_v1; token_str: cstring): ptr wlr_xdg_activation_token_v1 {.importc: "wlr_xdg_activation_v1_add_token".}

## wlr_xdg_decoration_v1

type wlr_xdg_toplevel_decoration_v1_mode* = enum
  WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_NONE = 0,
  WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_CLIENT_SIDE = 1,
  WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_SERVER_SIDE = 2

type INNER_C_STRUCT_wlr_xdg_decoration_v1_20* {.bycopy.} = object
  new_toplevel_decoration*: wl_signal
  destroy*: wl_signal

type wlr_xdg_decoration_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  decorations*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_xdg_decoration_v1_20
  data*: pointer

type wlr_xdg_toplevel_decoration_v1_configure* {.bycopy.} = object
  link*: wl_list
  surface_configure*: ptr wlr_xdg_surface_configure
  mode*: wlr_xdg_toplevel_decoration_v1_mode

type wlr_xdg_toplevel_decoration_v1_state* {.bycopy.} = object
  mode*: wlr_xdg_toplevel_decoration_v1_mode

type INNER_C_STRUCT_wlr_xdg_decoration_v1_53* {.bycopy.} = object
  destroy*: wl_signal
  request_mode*: wl_signal

type wlr_xdg_toplevel_decoration_v1* {.bycopy.} = object
  resource*: ptr wl_resource
  surface*: ptr wlr_xdg_surface
  manager*: ptr wlr_xdg_decoration_manager_v1
  link*: wl_list
  current*: wlr_xdg_toplevel_decoration_v1_state
  pending*: wlr_xdg_toplevel_decoration_v1_state
  scheduled_mode*: wlr_xdg_toplevel_decoration_v1_mode
  requested_mode*: wlr_xdg_toplevel_decoration_v1_mode
  added*: bool
  configure_list*: wl_list
  events*: INNER_C_STRUCT_wlr_xdg_decoration_v1_53
  surface_destroy*: wl_listener
  surface_configure*: wl_listener
  surface_ack_configure*: wl_listener
  surface_commit*: wl_listener
  data*: pointer

proc wlr_xdg_decoration_manager_v1_create*(display: ptr wl_display): ptr wlr_xdg_decoration_manager_v1 {.importc: "wlr_xdg_decoration_manager_v1_create".}
proc wlr_xdg_toplevel_decoration_v1_set_mode*(decoration: ptr wlr_xdg_toplevel_decoration_v1; mode: wlr_xdg_toplevel_decoration_v1_mode): uint32_t {.importc: "wlr_xdg_toplevel_decoration_v1_set_mode".}

## wlr_xdg_foreign_registry

const WLR_XDG_FOREIGN_HANDLE_SIZE* = 37

type INNER_C_STRUCT_wlr_xdg_foreign_registry_28* {.bycopy.} = object
  destroy*: wl_signal

type wlr_xdg_foreign_registry* {.bycopy.} = object
  exported_surfaces*: wl_list
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_xdg_foreign_registry_28

type INNER_C_STRUCT_wlr_xdg_foreign_registry_41* {.bycopy.} = object
  destroy*: wl_signal

type wlr_xdg_foreign_exported* {.bycopy.} = object
  link*: wl_list
  registry*: ptr wlr_xdg_foreign_registry
  surface*: ptr wlr_surface
  handle*: array[WLR_XDG_FOREIGN_HANDLE_SIZE, char]
  events*: INNER_C_STRUCT_wlr_xdg_foreign_registry_41

proc wlr_xdg_foreign_registry_create*(display: ptr wl_display): ptr wlr_xdg_foreign_registry {.importc: "wlr_xdg_foreign_registry_create".}
proc wlr_xdg_foreign_exported_init*(surface: ptr wlr_xdg_foreign_exported; registry: ptr wlr_xdg_foreign_registry): bool {.importc: "wlr_xdg_foreign_exported_init".}
proc wlr_xdg_foreign_registry_find_by_handle*(registry: ptr wlr_xdg_foreign_registry; handle: cstring): ptr wlr_xdg_foreign_exported {.importc: "wlr_xdg_foreign_registry_find_by_handle".}
proc wlr_xdg_foreign_exported_finish*(surface: ptr wlr_xdg_foreign_exported) {.importc: "wlr_xdg_foreign_exported_finish".}

## wlr_xdg_foreign_v1

type INNER_C_STRUCT_wlr_xdg_foreign_v1_17* {.bycopy.} = object
  global*: ptr wl_global
  objects*: wl_list

type INNER_C_STRUCT_wlr_xdg_foreign_v1_27* {.bycopy.} = object
  destroy*: wl_signal

type wlr_xdg_foreign_v1* {.bycopy.} = object
  exporter*: INNER_C_STRUCT_wlr_xdg_foreign_v1_17
  importer*: INNER_C_STRUCT_wlr_xdg_foreign_v1_17
  foreign_registry_destroy*: wl_listener
  display_destroy*: wl_listener
  registry*: ptr wlr_xdg_foreign_registry
  events*: INNER_C_STRUCT_wlr_xdg_foreign_v1_27
  data*: pointer

type wlr_xdg_exported_v1* {.bycopy.} = object
  base*: wlr_xdg_foreign_exported
  resource*: ptr wl_resource
  xdg_surface_destroy*: wl_listener
  link*: wl_list

type wlr_xdg_imported_v1* {.bycopy.} = object
  exported*: ptr wlr_xdg_foreign_exported
  exported_destroyed*: wl_listener
  resource*: ptr wl_resource
  link*: wl_list
  children*: wl_list

type wlr_xdg_imported_child_v1* {.bycopy.} = object
  imported*: ptr wlr_xdg_imported_v1
  surface*: ptr wlr_surface
  link*: wl_list
  xdg_surface_unmap*: wl_listener
  xdg_toplevel_set_parent*: wl_listener

proc wlr_xdg_foreign_v1_create*(display: ptr wl_display; registry: ptr wlr_xdg_foreign_registry): ptr wlr_xdg_foreign_v1 {.importc: "wlr_xdg_foreign_v1_create".}

## wlr_xdg_foreign_v2

type INNER_C_STRUCT_wlr_xdg_foreign_v2_17* {.bycopy.} = object
  global*: ptr wl_global
  objects*: wl_list

type INNER_C_STRUCT_wlr_xdg_foreign_v2_27* {.bycopy.} = object
  destroy*: wl_signal

type wlr_xdg_foreign_v2* {.bycopy.} = object
  exporter*: INNER_C_STRUCT_wlr_xdg_foreign_v2_17
  importer*: INNER_C_STRUCT_wlr_xdg_foreign_v2_17
  foreign_registry_destroy*: wl_listener
  display_destroy*: wl_listener
  registry*: ptr wlr_xdg_foreign_registry
  events*: INNER_C_STRUCT_wlr_xdg_foreign_v2_27
  data*: pointer

type wlr_xdg_exported_v2* {.bycopy.} = object
  base*: wlr_xdg_foreign_exported
  resource*: ptr wl_resource
  xdg_surface_destroy*: wl_listener
  link*: wl_list

type wlr_xdg_imported_v2* {.bycopy.} = object
  exported*: ptr wlr_xdg_foreign_exported
  exported_destroyed*: wl_listener
  resource*: ptr wl_resource
  link*: wl_list
  children*: wl_list

type wlr_xdg_imported_child_v2* {.bycopy.} = object
  imported*: ptr wlr_xdg_imported_v2
  surface*: ptr wlr_surface
  link*: wl_list
  xdg_surface_unmap*: wl_listener
  xdg_toplevel_set_parent*: wl_listener

proc wlr_xdg_foreign_v2_create*(display: ptr wl_display; registry: ptr wlr_xdg_foreign_registry): ptr wlr_xdg_foreign_v2 {.importc: "wlr_xdg_foreign_v2_create".}

## wlr_xdg_output

type wlr_xdg_output_v1* {.bycopy.} = object
  manager*: ptr wlr_xdg_output_manager_v1
  resources*: wl_list
  link*: wl_list
  layout_output*: ptr wlr_output_layout_output
  x*: int32_t
  y*: int32_t
  width*: int32_t
  height*: int32_t
  destroy*: wl_listener
  description*: wl_listener

type INNER_C_STRUCT_wlr_xdg_output_v1_35* {.bycopy.} = object
  destroy*: wl_signal

type wlr_xdg_output_manager_v1* {.bycopy.} = object
  global*: ptr wl_global
  layout*: ptr wlr_output_layout
  outputs*: wl_list
  events*: INNER_C_STRUCT_wlr_xdg_output_v1_35
  display_destroy*: wl_listener
  layout_add*: wl_listener
  layout_change*: wl_listener
  layout_destroy*: wl_listener

proc wlr_xdg_output_manager_v1_create*(display: ptr wl_display; layout: ptr wlr_output_layout): ptr wlr_xdg_output_manager_v1 {.importc: "wlr_xdg_output_manager_v1_create".}

## wlr_xdg_shell

import
  xdg-shell-protocol

type INNER_C_STRUCT_wlr_xdg_shell_32* {.bycopy.} = object
  new_surface*: wl_signal

  destroy*: wl_signal

type wlr_xdg_shell* {.bycopy.} = object
  global*: ptr wl_global
  clients*: wl_list
  popup_grabs*: wl_list
  ping_timeout*: uint32_t
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_wlr_xdg_shell_32
  data*: pointer

type wlr_xdg_client* {.bycopy.} = object
  shell*: ptr wlr_xdg_shell
  resource*: ptr wl_resource
  client*: ptr wl_client
  surfaces*: wl_list
  link*: wl_list
  ping_serial*: uint32_t
  ping_timer*: ptr wl_event_source

type INNER_C_STRUCT_wlr_xdg_shell_58* {.bycopy.} = object
  width*: int32_t
  height*: int32_t

type INNER_C_STRUCT_wlr_xdg_shell_62* {.bycopy.} = object
  x*: int32_t
  y*: int32_t

type wlr_xdg_positioner* {.bycopy.} = object
  anchor_rect*: wlr_box
  anchor*: xdg_positioner_anchor
  gravity*: xdg_positioner_gravity
  constraint_adjustment*: xdg_positioner_constraint_adjustment
  size*: INNER_C_STRUCT_wlr_xdg_shell_58
  offset*: INNER_C_STRUCT_wlr_xdg_shell_62

type wlr_xdg_popup* {.bycopy.} = object
  base*: ptr wlr_xdg_surface
  link*: wl_list
  resource*: ptr wl_resource
  committed*: bool
  parent*: ptr wlr_surface
  seat*: ptr wlr_seat

  geometry*: wlr_box
  positioner*: wlr_xdg_positioner
  grab_link*: wl_list

type wlr_xdg_popup_grab* {.bycopy.} = object
  client*: ptr wl_client
  pointer_grab*: wlr_seat_pointer_grab
  keyboard_grab*: wlr_seat_keyboard_grab
  touch_grab*: wlr_seat_touch_grab
  seat*: ptr wlr_seat
  popups*: wl_list
  link*: wl_list
  seat_destroy*: wl_listener

type wlr_xdg_surface_role* = enum
  WLR_XDG_SURFACE_ROLE_NONE, WLR_XDG_SURFACE_ROLE_TOPLEVEL,
  WLR_XDG_SURFACE_ROLE_POPUP

type wlr_xdg_toplevel_state* {.bycopy.} = object
  maximized*: bool
  fullscreen*: bool
  resizing*: bool
  activated*: bool
  tiled*: uint32_t
  width*: uint32_t
  height*: uint32_t
  max_width*: uint32_t
  max_height*: uint32_t
  min_width*: uint32_t
  min_height*: uint32_t

type wlr_xdg_toplevel_configure* {.bycopy.} = object
  maximized*: bool
  fullscreen*: bool
  resizing*: bool
  activated*: bool
  tiled*: uint32_t
  width*: uint32_t
  height*: uint32_t

type wlr_xdg_toplevel_requested* {.bycopy.} = object
  maximized*: bool
  minimized*: bool
  fullscreen*: bool
  fullscreen_output*: ptr wlr_output
  fullscreen_output_destroy*: wl_listener

type INNER_C_STRUCT_wlr_xdg_shell_144* {.bycopy.} = object
  request_maximize*: wl_signal
  request_fullscreen*: wl_signal
  request_minimize*: wl_signal
  request_move*: wl_signal
  request_resize*: wl_signal
  request_show_window_menu*: wl_signal
  set_parent*: wl_signal
  set_title*: wl_signal
  set_app_id*: wl_signal

type wlr_xdg_toplevel* {.bycopy.} = object
  resource*: ptr wl_resource
  base*: ptr wlr_xdg_surface
  added*: bool
  parent*: ptr wlr_xdg_surface
  parent_unmap*: wl_listener
  current*: wlr_xdg_toplevel_state
  pending*: wlr_xdg_toplevel_state
  scheduled*: wlr_xdg_toplevel_configure

  requested*: wlr_xdg_toplevel_requested
  title*: cstring
  app_id*: cstring
  events*: INNER_C_STRUCT_wlr_xdg_shell_144

type wlr_xdg_surface_configure* {.bycopy.} = object
  surface*: ptr wlr_xdg_surface
  link*: wl_list
  serial*: uint32_t
  toplevel_configure*: ptr wlr_xdg_toplevel_configure

type wlr_xdg_surface_state* {.bycopy.} = object
  configure_serial*: uint32_t
  geometry*: wlr_box

type INNER_C_UNION_wlr_xdg_shell_187* {.bycopy, union.} = object
  toplevel*: ptr wlr_xdg_toplevel
  popup*: ptr wlr_xdg_popup

type INNER_C_STRUCT_wlr_xdg_shell_204* {.bycopy.} = object
  destroy*: wl_signal
  ping_timeout*: wl_signal
  new_popup*: wl_signal

  map*: wl_signal

  unmap*: wl_signal
  configure*: wl_signal
  ack_configure*: wl_signal

type wlr_xdg_surface* {.bycopy.} = object
  client*: ptr wlr_xdg_client
  resource*: ptr wl_resource
  surface*: ptr wlr_surface
  link*: wl_list
  role*: wlr_xdg_surface_role
  ano_wlr_xdg_shell_189*: INNER_C_UNION_wlr_xdg_shell_187
  popups*: wl_list
  added*: bool
  configured*: bool
  mapped*: bool
  configure_idle*: ptr wl_event_source
  scheduled_serial*: uint32_t
  configure_list*: wl_list
  current*: wlr_xdg_surface_state
  pending*: wlr_xdg_surface_state
  surface_destroy*: wl_listener
  surface_commit*: wl_listener
  events*: INNER_C_STRUCT_wlr_xdg_shell_204
  data*: pointer

type wlr_xdg_toplevel_move_event* {.bycopy.} = object
  surface*: ptr wlr_xdg_surface
  seat*: ptr wlr_seat_client
  serial*: uint32_t

type wlr_xdg_toplevel_resize_event* {.bycopy.} = object
  surface*: ptr wlr_xdg_surface
  seat*: ptr wlr_seat_client
  serial*: uint32_t
  edges*: uint32_t

type wlr_xdg_toplevel_set_fullscreen_event* {.bycopy.} = object
  surface*: ptr wlr_xdg_surface
  fullscreen*: bool
  output*: ptr wlr_output

type wlr_xdg_toplevel_show_window_menu_event* {.bycopy.} = object
  surface*: ptr wlr_xdg_surface
  seat*: ptr wlr_seat_client
  serial*: uint32_t
  x*: uint32_t
  y*: uint32_t

proc wlr_xdg_shell_create*(display: ptr wl_display): ptr wlr_xdg_shell {.importc: "wlr_xdg_shell_create".}
proc wlr_xdg_surface_from_resource*(resource: ptr wl_resource): ptr wlr_xdg_surface {.importc: "wlr_xdg_surface_from_resource".}
proc wlr_xdg_surface_from_popup_resource*(resource: ptr wl_resource): ptr wlr_xdg_surface {.importc: "wlr_xdg_surface_from_popup_resource".}
proc wlr_xdg_surface_from_toplevel_resource*(resource: ptr wl_resource): ptr wlr_xdg_surface {.importc: "wlr_xdg_surface_from_toplevel_resource".}
proc wlr_xdg_surface_ping*(surface: ptr wlr_xdg_surface) {.importc: "wlr_xdg_surface_ping".}
proc wlr_xdg_toplevel_set_size*(surface: ptr wlr_xdg_surface; width: uint32_t; height: uint32_t): uint32_t {.importc: "wlr_xdg_toplevel_set_size".}
proc wlr_xdg_toplevel_set_activated*(surface: ptr wlr_xdg_surface; activated: bool): uint32_t {.importc: "wlr_xdg_toplevel_set_activated".}
proc wlr_xdg_toplevel_set_maximized*(surface: ptr wlr_xdg_surface; maximized: bool): uint32_t {.importc: "wlr_xdg_toplevel_set_maximized".}
proc wlr_xdg_toplevel_set_fullscreen*(surface: ptr wlr_xdg_surface; fullscreen: bool): uint32_t {.importc: "wlr_xdg_toplevel_set_fullscreen".}
proc wlr_xdg_toplevel_set_resizing*(surface: ptr wlr_xdg_surface; resizing: bool): uint32_t {.importc: "wlr_xdg_toplevel_set_resizing".}
proc wlr_xdg_toplevel_set_tiled*(surface: ptr wlr_xdg_surface; tiled_edges: uint32_t): uint32_t {.importc: "wlr_xdg_toplevel_set_tiled".}
proc wlr_xdg_toplevel_send_close*(surface: ptr wlr_xdg_surface) {.importc: "wlr_xdg_toplevel_send_close".}
proc wlr_xdg_toplevel_set_parent*(surface: ptr wlr_xdg_surface; parent: ptr wlr_xdg_surface) {.importc: "wlr_xdg_toplevel_set_parent".}
proc wlr_xdg_popup_destroy*(surface: ptr wlr_xdg_surface) {.importc: "wlr_xdg_popup_destroy".}
proc wlr_xdg_popup_get_position*(popup: ptr wlr_xdg_popup; popup_sx: ptr cdouble; popup_sy: ptr cdouble) {.importc: "wlr_xdg_popup_get_position".}
proc wlr_xdg_positioner_get_geometry*(positioner: ptr wlr_xdg_positioner): wlr_box {.importc: "wlr_xdg_positioner_get_geometry".}
proc wlr_xdg_popup_get_anchor_point*(popup: ptr wlr_xdg_popup; toplevel_sx: ptr cint; toplevel_sy: ptr cint) {.importc: "wlr_xdg_popup_get_anchor_point".}
proc wlr_xdg_popup_get_toplevel_coords*(popup: ptr wlr_xdg_popup; popup_sx: cint; popup_sy: cint; toplevel_sx: ptr cint; toplevel_sy: ptr cint) {.importc: "wlr_xdg_popup_get_toplevel_coords".}
proc wlr_xdg_popup_unconstrain_from_box*(popup: ptr wlr_xdg_popup; toplevel_sx_box: ptr wlr_box) {.importc: "wlr_xdg_popup_unconstrain_from_box".}
proc wlr_positioner_invert_x*(positioner: ptr wlr_xdg_positioner) {.importc: "wlr_positioner_invert_x".}
proc wlr_positioner_invert_y*(positioner: ptr wlr_xdg_positioner) {.importc: "wlr_positioner_invert_y".}
proc wlr_xdg_surface_surface_at*(surface: ptr wlr_xdg_surface; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr wlr_surface {.importc: "wlr_xdg_surface_surface_at".}
proc wlr_xdg_surface_popup_surface_at*(surface: ptr wlr_xdg_surface; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr wlr_surface {.importc: "wlr_xdg_surface_popup_surface_at".}
proc wlr_surface_is_xdg_surface*(surface: ptr wlr_surface): bool {.importc: "wlr_surface_is_xdg_surface".}
proc wlr_xdg_surface_from_wlr_surface*(surface: ptr wlr_surface): ptr wlr_xdg_surface {.importc: "wlr_xdg_surface_from_wlr_surface".}
proc wlr_xdg_surface_get_geometry*(surface: ptr wlr_xdg_surface; box: ptr wlr_box) {.importc: "wlr_xdg_surface_get_geometry".}
proc wlr_xdg_surface_for_each_surface*(surface: ptr wlr_xdg_surface; `iterator`: wlr_surface_iterator_func_t; user_data: pointer) {.importc: "wlr_xdg_surface_for_each_surface".}
proc wlr_xdg_surface_for_each_popup_surface*(surface: ptr wlr_xdg_surface; `iterator`: wlr_surface_iterator_func_t; user_data: pointer) {.importc: "wlr_xdg_surface_for_each_popup_surface".}
proc wlr_xdg_surface_schedule_configure*(surface: ptr wlr_xdg_surface): uint32_t {.importc: "wlr_xdg_surface_schedule_configure".}

{.pop.}
