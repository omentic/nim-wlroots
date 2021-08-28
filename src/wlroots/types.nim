{.push dynlib: "libwlroots.so".}

## wlr_box

type wlr_box* = object
  x*, y*: cint
  width*, height*: cint

type wlr_fbox* = object
  x*, y*: cdouble
  width*, height*: cdouble

## wlr_buffer

type wlr_shm_attributes* = object
  fd*: cint
  format*: uint32
  width*, height*, stride*: cint
  offset*: off_t

type wlr_buffer_impl* = object
  destroy*: proc (buffer: ptr wlr_buffer)
  get_dmabuf*: proc (buffer: ptr wlr_buffer; attribs: ptr wlr_dmabuf_attributes): bool
  get_shm*: proc (buffer: ptr wlr_buffer; attribs: ptr wlr_shm_attributes): bool
  begin_data_ptr_access*: proc (buffer: ptr wlr_buffer; data: ptr pointer; format: ptr uint32; stride: ptr csize_t): bool
  end_data_ptr_access*: proc (buffer: ptr wlr_buffer)

type wlr_buffer_cap* = enum
  WLR_BUFFER_CAP_DATA_PTR = 1 shl 0,
  WLR_BUFFER_CAP_DMABUF = 1 shl 1,
  WLR_BUFFER_CAP_SHM = 1 shl 2

type wlr_buffer_events* = object
  destroy*: wl_signal
  release*: wl_signal

type wlr_buffer* = object
  impl*: ptr wlr_buffer_impl
  width*, height*: cint
  dropped*: bool
  n_locks*: csize_t
  accessing_data_ptr*: bool
  events*: wlr_buffer_events

type wlr_client_buffer* = object
  base*: wlr_buffer
  resource*: ptr wl_resource
  resource_released*: bool
  texture*: ptr wlr_texture
  resource_destroy*: wl_listener
  release*: wl_listener

type wlr_renderer* = object

## wlr_compositor

type wlr_subcompositor* = object
  global*: ptr wl_global

type wlr_compositor_events* = object
  new_surface*: wl_signal
  destroy*: wl_signal

type wlr_compositor* = object
  global*: ptr wl_global
  renderer*: ptr wlr_renderer
  subcompositor*: wlr_subcompositor
  display_destroy*: wl_listener
  events*: wlr_compositor_events

## wlr_cursor

type wlr_cursor_state* = object

type wlr_cursor_events* = object
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
  touch_up*: wl_signal
  touch_down*: wl_signal
  touch_motion*: wl_signal
  touch_cancel*: wl_signal
  tablet_tool_axis*: wl_signal
  tablet_tool_proximity*: wl_signal
  tablet_tool_tip*: wl_signal
  tablet_tool_button*: wl_signal

type wlr_cursor* = object
  state*: ptr wlr_cursor_state
  x*, y*: cdouble
  events*: wlr_cursor_events
  data*: pointer

## wlr_data_control

# import wlr_seat

type wlr_data_control_manager_v1_events* = object
  destroy*: wl_signal
  new_device*: wl_signal

type wlr_data_control_manager_v1* = object
  global*: ptr wl_global
  devices*: wl_list
  events*: wlr_data_control_manager_v1_events
  display_destroy*: wl_listener

type wlr_data_control_device_v1* = object
  resource*: ptr wl_resource
  manager*: ptr wlr_data_control_manager_v1
  link*: wl_list
  seat*: ptr wlr_seat
  selection_offer_resource*: ptr wl_resource
  primary_selection_offer_resource*: ptr wl_resource
  seat_destroy*: wl_listener
  seat_set_selection*: wl_listener
  seat_set_primary_selection*: wl_listener

## wlr_data_device

# import wlr_seat

let wlr_data_device_pointer_drag_interface*: wlr_pointer_grab_interface
let wlr_data_device_keyboard_drag_interface*: wlr_keyboard_grab_interface
let wlr_data_device_touch_drag_interface*: wlr_touch_grab_interface

type wlr_data_device_manager_events* = object
  destroy*: wl_signal

type wlr_data_device_manager* = object
  global*: ptr wl_global
  data_sources*: wl_list
  display_destroy*: wl_listener
  events*: wlr_data_device_manager_events
  data*: pointer

type wlr_data_offer_type* = enum
  WLR_DATA_OFFER_SELECTION,
  WLR_DATA_OFFER_DRAG

type wlr_data_offer* = object
  resource*: ptr wl_resource
  source*: ptr wlr_data_source
  `type`*: wlr_data_offer_type
  link*: wl_list
  actions*: uint32
  preferred_action*: wl_data_device_manager_dnd_action
  in_ask*: bool
  source_destroy*: wl_listener

type wlr_data_source_impl* = object
  send*: proc (source: ptr wlr_data_source; mime_type: cstring; fd: int32)
  accept*: proc (source: ptr wlr_data_source; serial: uint32; mime_type: cstring)
  destroy*: proc (source: ptr wlr_data_source)
  dnd_drop*: proc (source: ptr wlr_data_source)
  dnd_finish*: proc (source: ptr wlr_data_source)
  dnd_action*: proc (source: ptr wlr_data_source; action: wl_data_device_manager_dnd_action)

type wlr_data_source_events* = object
  destroy*: wl_signal

type wlr_data_source* = object
  impl*: ptr wlr_data_source_impl
  mime_types*: wl_array
  actions*: int32
  accepted*: bool
  current_dnd_action*: wl_data_device_manager_dnd_action
  compositor_action*: uint32
  events*: wlr_data_source_events

type wlr_drag* = object

type wlr_drag_icon_events* = object
  map*: wl_signal
  unmap*: wl_signal
  destroy*: wl_signal

type wlr_drag_icon* = object
  drag*: ptr wlr_drag
  surface*: ptr wlr_surface
  mapped*: bool
  events*: wlr_drag_icon_events
  surface_destroy*: wl_listener
  data*: pointer

type wlr_drag_grab_type* = enum
  WLR_DRAG_GRAB_KEYBOARD,
  WLR_DRAG_GRAB_KEYBOARD_POINTER,
  WLR_DRAG_GRAB_KEYBOARD_TOUCH

type wlr_drag_events* = object
  focus*: wl_signal
  motion*: wl_signal
  drop*: wl_signal
  destroy*: wl_signal

type wlr_drag* = object
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
  started*, dropped*, cancelling*: bool
  grab_touch_id*, touch_id*: int32
  events*: wlr_drag_events
  source_destroy*: wl_listener
  seat_client_destroy*: wl_listener
  icon_destroy*: wl_listener
  data*: pointer

type wlr_drag_motion_event* = object
  drag*: ptr wlr_drag
  time*: uint32
  sx*, sy*: cdouble

type wlr_drag_drop_event* = object
  drag*: ptr wlr_drag
  time*: uint32

## wlr_export_dmabuf_v1

type wlr_export_dmabuf_manager_v1_events* = object
  destroy*: wl_signal

type wlr_export_dmabuf_manager_v1* = object
  global*: ptr wl_global
  frames*: wl_list
  display_destroy*: wl_listener
  events*: wlr_export_dmabuf_manager_v1_events

type wlr_export_dmabuf_frame_v1* = object
  resource*: ptr wl_resource
  manager*: ptr wlr_export_dmabuf_manager_v1
  link*: wl_list
  output*: ptr wlr_output
  cursor_locked*: bool
  output_commit*: wl_listener

## wlr_foreign_toplevel_management

# import wlr_output

type wlr_foreign_toplevel_manager_v1_events* = object
  destroy*: wl_signal

type wlr_foreign_toplevel_manager_v1* = object
  event_loop*: ptr wl_event_loop
  global*: ptr wl_global
  resources*: wl_list
  toplevels*: wl_list
  display_destroy*: wl_listener
  events*: wlr_foreign_toplevel_manager_v1_events
  data*: pointer

type wlr_foreign_toplevel_handle_v1_state* = enum
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MAXIMIZED = (1 shl 0),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MINIMIZED = (1 shl 1),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_ACTIVATED = (1 shl 2),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_FULLSCREEN = (1 shl 3)

type wlr_foreign_toplevel_handle_v1_output* = object
  link*: wl_list
  output_destroy*: wl_listener
  output*: ptr wlr_output
  toplevel*: ptr wlr_foreign_toplevel_handle_v1

type wlr_foreign_toplevel_handle_v1_events* = object
  request_maximize*: wl_signal
  request_minimize*: wl_signal
  request_activate*: wl_signal
  request_fullscreen*: wl_signal
  request_close*: wl_signal
  set_rectangle*: wl_signal
  destroy*: wl_signal

type wlr_foreign_toplevel_handle_v1* = object
  manager*: ptr wlr_foreign_toplevel_manager_v1
  resources*: wl_list
  link*: wl_list
  idle_source*: ptr wl_event_source
  title*: cstring
  app_id*: cstring
  parent*: ptr wlr_foreign_toplevel_handle_v1
  outputs*: wl_list
  state*: uint32
  events*: wlr_foreign_toplevel_handle_v1_events
  data*: pointer

type wlr_foreign_toplevel_handle_v1_maximized_event* = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  maximized*: bool

type wlr_foreign_toplevel_handle_v1_minimized_event* = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  minimized*: bool

type wlr_foreign_toplevel_handle_v1_activated_event* = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  seat*: ptr wlr_seat

type wlr_foreign_toplevel_handle_v1_fullscreen_event* = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  fullscreen*: bool
  output*: ptr wlr_output

type wlr_foreign_toplevel_handle_v1_set_rectangle_event* = object
  toplevel*: ptr wlr_foreign_toplevel_handle_v1
  surface*: ptr wlr_surface
  x*, y*, width*, height*: int32

## wlr_fullscreen_shell

# import fullscreen-shell-unstable-v1-protocol

type wlr_fullscreen_shell_v1_events* = object
  destroy*: wl_signal
  present_surface*: wl_signal

type wlr_fullscreen_shell_v1* = object
  global*: ptr wl_global
  events*: wlr_fullscreen_shell_v1_events
  display_destroy*: wl_listener
  data*: pointer

type wlr_fullscreen_shell_v1_present_surface_event* = object
  client*: ptr wl_client
  surface*: ptr wlr_surface
  `method`*: zwp_fullscreen_shell_v1_present_method
  output*: ptr wlr_output

## wlr_gamma_control

type wlr_gamma_control_manager_v1_events* = object
  destroy*: wl_signal

type wlr_gamma_control_manager_v1* = object
  global*: ptr wl_global
  controls*: wl_list
  display_destroy*: wl_listener
  events*: wlr_gamma_control_manager_v1_events
  data*: pointer

type wlr_gamma_control_v1* = object
  resource*: ptr wl_resource
  output*: ptr wlr_output
  link*: wl_list
  table*: ptr uint16
  ramp_size*: csize_t
  output_commit_listener*: wl_listener
  output_destroy_listener*: wl_listener
  data*: pointer

## wlr_idle_inhibit

type wlr_idle_inhibit_manager_v1_events* = object
  new_inhibitor*: wl_signal
  destroy*: wl_signal

type wlr_idle_inhibit_manager_v1* = object
  inhibitors*: wl_list
  global*: ptr wl_global
  display_destroy*: wl_listener
  events*: wlr_idle_inhibit_manager_v1_events
  data*: pointer

type wlr_idle_inhibitor_v1_events* = object
  destroy*: wl_signal

type wlr_idle_inhibitor_v1* = object
  surface*: ptr wlr_surface
  resource*: ptr wl_resource
  surface_destroy*: wl_listener
  link*: wl_list
  events*: wlr_idle_inhibitor_v1_events
  data*: pointer

## wlr_idle

type wlr_idle_events* = object
  activity_notify*: wl_signal
  destroy*: wl_signal

type wlr_idle* = object
  global*: ptr wl_global
  idle_timers*: wl_list
  event_loop*: ptr wl_event_loop
  enabled*: bool
  display_destroy*: wl_listener
  events*: wlr_idle_events
  data*: pointer

type wlr_idle_timeout_events* = object
  idle*: wl_signal
  resume*: wl_signal
  destroy*: wl_signal

type wlr_idle_timeout* = object
  resource*: ptr wl_resource
  link*: wl_list
  seat*: ptr wlr_seat
  idle_source*: ptr wl_event_source
  idle_state*: bool
  enabled*: bool
  timeout*: uint32
  events*: wlr_idle_timeout_events
  input_listener*: wl_listener
  seat_destroy*: wl_listener
  data*: pointer

## wlr_input_device

type wlr_button_state* = enum
  WLR_BUTTON_RELEASED, WLR_BUTTON_PRESSED

type wlr_input_device_type* = enum
  WLR_INPUT_DEVICE_KEYBOARD,
  WLR_INPUT_DEVICE_POINTER,
  WLR_INPUT_DEVICE_TOUCH,
  WLR_INPUT_DEVICE_TABLET_TOOL,
  WLR_INPUT_DEVICE_TABLET_PAD,
  WLR_INPUT_DEVICE_SWITCH

type wlr_input_device_impl* = object

type wlr_input_device_ano_wlr_input_device_1* {.union.} = object
  device*: pointer #  FIXME: _device
  keyboard*: ptr wlr_keyboard
  pointer*: ptr wlr_pointer
  switch_device*: ptr wlr_switch
  touch*: ptr wlr_touch
  tablet*: ptr wlr_tablet
  tablet_pad*: ptr wlr_tablet_pad

type wlr_input_device_events* = object
  destroy*: wl_signal

type wlr_input_device* = object
  impl*: ptr wlr_input_device_impl
  `type`*: wlr_input_device_type
  vendor*, product*: cuint
  name*: cstring
  width_mm*, height_mm*: cdouble
  output_name*: cstring
  ano_wlr_input_device_1*: wlr_input_device_ano_wlr_input_device_1
  events*: wlr_input_device_events
  data*: pointer
  link*: wl_list

## wlr_input_inhibitor

type wlr_input_inhibit_manager_events* = object
  activate*: wl_signal
  deactivate*: wl_signal
  destroy*: wl_signal

type wlr_input_inhibit_manager* = object
  global*: ptr wl_global
  active_client*: ptr wl_client
  active_inhibitor*: ptr wl_resource
  display_destroy*: wl_listener
  events*: wlr_input_inhibit_manager_events
  data*: pointer

## wlr_input_method

type wlr_input_method_v2_preedit_string* = object
  text*: cstring
  cursor_begin*: int32
  cursor_end*: int32

type wlr_input_method_v2_delete_surrounding_text* = object
  before_length*: uint32
  after_length*: uint32

type wlr_input_method_v2_state* = object
  preedit*: wlr_input_method_v2_preedit_string
  commit_text*: cstring
  delete*: wlr_input_method_v2_delete_surrounding_text

type wlr_input_method_v2_events* = object
  commit*: wl_signal
  grab_keyboard*: wl_signal
  destroy*: wl_signal

type wlr_input_method_v2* = object
  resource*: ptr wl_resource
  seat*: ptr wlr_seat
  seat_client*: ptr wlr_seat_client
  pending*: wlr_input_method_v2_state
  current*: wlr_input_method_v2_state
  active*: bool
  client_active*: bool
  current_serial*: uint32
  keyboard_grab*: ptr wlr_input_method_keyboard_grab_v2
  link*: wl_list
  seat_client_destroy*: wl_listener
  events*: wlr_input_method_v2_events

type wlr_input_method_keyboard_grab_v2_events* = object
  destroy*: wl_signal

type wlr_input_method_keyboard_grab_v2* = object
  resource*: ptr wl_resource
  input_method*: ptr wlr_input_method_v2
  keyboard*: ptr wlr_keyboard
  keyboard_keymap*: wl_listener
  keyboard_repeat_info*: wl_listener
  keyboard_destroy*: wl_listener
  events*: wlr_input_method_keyboard_grab_v2_events

type wlr_input_method_manager_v2_events* = object
  input_method*: wl_signal
  destroy*: wl_signal

type wlr_input_method_manager_v2* = object
  global*: ptr wl_global
  input_methods*: wl_list
  display_destroy*: wl_listener
  events*: wlr_input_method_manager_v2_events

## wlr_keyboard_group

type wlr_keyboard_group_events* = object
  enter*: wl_signal
  leave*: wl_signal

type wlr_keyboard_group* = object
  keyboard*: wlr_keyboard
  input_device*: ptr wlr_input_device
  devices*: wl_list
  keys*: wl_list
  events*: wlr_keyboard_group_events
  data*: pointer

## wlr_keyboard

const WLR_LED_COUNT* = 3

type wlr_keyboard_led* = enum
  WLR_LED_NUM_LOCK = 1 shl 0,
  WLR_LED_CAPS_LOCK = 1 shl 1,
  WLR_LED_SCROLL_LOCK = 1 shl 2

const WLR_MODIFIER_COUNT* = 8

type wlr_keyboard_modifier* = enum
  WLR_MODIFIER_SHIFT = 1 shl 0,
  WLR_MODIFIER_CAPS = 1 shl 1,
  WLR_MODIFIER_CTRL = 1 shl 2,
  WLR_MODIFIER_ALT = 1 shl 3,
  WLR_MODIFIER_MOD2 = 1 shl 4,
  WLR_MODIFIER_MOD3 = 1 shl 5,
  WLR_MODIFIER_LOGO = 1 shl 6,
  WLR_MODIFIER_MOD5 = 1 shl 7

const WLR_KEYBOARD_KEYS_CAP* = 32

type wlr_keyboard_impl* = object

type wlr_keyboard_modifiers* = object
  depressed*: xkb_mod_mask_t
  latched*: xkb_mod_mask_t
  locked*: xkb_mod_mask_t
  group*: xkb_mod_mask_t

type wlr_keyboard_repeat_info* = object
  rate*: int32
  delay*: int32

type wlr_keyboard_events* = object
  key*: wl_signal
  modifiers*: wl_signal
  keymap*: wl_signal
  repeat_info*: wl_signal
  destroy*: wl_signal

type wlr_keyboard* = object
  impl*: ptr wlr_keyboard_impl
  group*: ptr wlr_keyboard_group
  keymap_string*: cstring
  keymap_size*: csize_t
  keymap*: ptr xkb_keymap
  xkb_state*: ptr xkb_state
  led_indexes*: array[WLR_LED_COUNT, xkb_led_index_t]
  mod_indexes*: array[WLR_MODIFIER_COUNT, xkb_mod_index_t]
  keycodes*: array[WLR_KEYBOARD_KEYS_CAP, uint32]
  num_keycodes*: csize_t
  modifiers*: wlr_keyboard_modifiers
  repeat_info*: wlr_keyboard_repeat_info
  events*: wlr_keyboard_events
  data*: pointer

type wlr_event_keyboard_key* = object
  time_msec*: uint32
  keycode*: uint32
  update_state*: bool
  state*: wl_keyboard_key_state

## wlr_keyboard_shortcuts_inhibit_v1

type wlr_keyboard_shortcuts_inhibit_manager_v1_events* = object
  new_inhibitor*: wl_signal
  destroy*: wl_signal

type wlr_keyboard_shortcuts_inhibit_manager_v1* = object
  inhibitors*: wl_list
  global*: ptr wl_global
  display_destroy*: wl_listener
  events*: wlr_keyboard_shortcuts_inhibit_manager_v1_events
  data*: pointer

type wlr_keyboard_shortcuts_inhibitor_v1_events* = object
  destroy*: wl_signal

type wlr_keyboard_shortcuts_inhibitor_v1* = object
  surface*: ptr wlr_surface
  seat*: ptr wlr_seat
  active*: bool
  resource*: ptr wl_resource
  surface_destroy*: wl_listener
  seat_destroy*: wl_listener
  link*: wl_list
  events*: wlr_keyboard_shortcuts_inhibitor_v1_events
  data*: pointer

## wlr_layer_shell

# import wlr-layer-shell-unstable-v1-protocol

type wlr_layer_shell_v1_events* = object
  new_surface*: wl_signal
  destroy*: wl_signal

type wlr_layer_shell_v1* = object
  global*: ptr wl_global
  display_destroy*: wl_listener
  events*: wlr_layer_shell_v1_events
  data*: pointer

type wlr_layer_surface_v1_state_margin* = object
  top*, right*, bottom*, left*: uint32

type wlr_layer_surface_v1_state* = object
  anchor*: uint32
  exclusive_zone*: int32
  margin*: wlr_layer_surface_v1_state_margin
  keyboard_interactive*: zwlr_layer_surface_v1_keyboard_interactivity
  desired_width*, desired_height*: uint32
  actual_width*, actual_height*: uint32
  layer*: zwlr_layer_shell_v1_layer

type wlr_layer_surface_v1_configure* = object
  link*: wl_list
  serial*: uint32
  state*: wlr_layer_surface_v1_state

type wlr_layer_surfae_v1_events* = object
  destroy*: wl_signal
  map*: wl_signal
  unmap*: wl_signal
  new_popup*: wl_signal

type wlr_layer_surface_v1* = object
  surface*: ptr wlr_surface
  output*: ptr wlr_output
  resource*: ptr wl_resource
  shell*: ptr wlr_layer_shell_v1
  popups*: wl_list
  namespace*: cstring
  added*, configured*, mapped*, closed*: bool
  configure_serial*: uint32
  configure_next_serial*: uint32
  configure_list*: wl_list
  acked_configure*: ptr wlr_layer_surface_v1_configure
  client_pending*: wlr_layer_surface_v1_state
  server_pending*: wlr_layer_surface_v1_state
  current*: wlr_layer_surface_v1_state
  surface_destroy*: wl_listener
  events*: wlr_layer_surfae_v1_events
  data*: pointer

## wlr_linux_dmabuf_v1

type wlr_dmabuf_v1_buffer* = object
  base*: wlr_buffer
  resource*: ptr wl_resource
  attributes*: wlr_dmabuf_attributes
  release*: wl_listener

type wlr_linux_buffer_params_v1* = object
  resource*: ptr wl_resource
  linux_dmabuf*: ptr wlr_linux_dmabuf_v1
  attributes*: wlr_dmabuf_attributes
  has_modifier*: bool

type wlr_linux_dmabuf_v1_events* = object
  destroy*: wl_signal

type wlr_linux_dmabuf_v1* = object
  global*: ptr wl_global
  renderer*: ptr wlr_renderer
  events*: wlr_linux_dmabuf_v1_events
  display_destroy*: wl_listener
  renderer_destroy*: wl_listener

## wlr_list

type wlr_list* = object
  capacity*: csize_t
  length*: csize_t
  items*: ptr pointer

## wlr_matrix

## wlr_output_damage

# import wlr_box, wlr_output

const WLR_OUTPUT_DAMAGE_PREVIOUS_LEN* = 2

type wlr_output_damage_events* = object
  frame*: wl_signal
  destroy*: wl_signal

type wlr_output_damage* = object
  output*: ptr wlr_output
  max_rects*: cint
  current*: pixman_region32_t
  previous*: array[WLR_OUTPUT_DAMAGE_PREVIOUS_LEN, pixman_region32_t]
  previous_idx*: csize_t
  pending_buffer_type*: wlr_output_state_buffer_type
  events*: wlr_output_damage_events
  output_destroy*: wl_listener
  output_mode*: wl_listener
  output_needs_frame*: wl_listener
  output_damage*: wl_listener
  output_frame*: wl_listener
  output_precommit*: wl_listener
  output_commit*: wl_listener

## wlr_output_layout

type wlr_output_layout_state* = object

type wlr_output_layout_events* = object
  add*: wl_signal
  change*: wl_signal
  destroy*: wl_signal

type wlr_output_layout* = object
  outputs*: wl_list
  state*: ptr wlr_output_layout_state
  events*: wlr_output_layout_events
  data*: pointer

type wlr_output_layout_output_state* = object

type wlr_output_layout_output_events* = object
  destroy*: wl_signal

type wlr_output_layout_output* = object
  output*: ptr wlr_output
  x*, y*: cint
  link*: wl_list
  state*: ptr wlr_output_layout_output_state
  events*: wlr_output_layout_output_events

type wlr_direction* = enum
  WLR_DIRECTION_UP = 1 shl 0,
  WLR_DIRECTION_DOWN = 1 shl 1,
  WLR_DIRECTION_LEFT = 1 shl 2,
  WLR_DIRECTION_RIGHT = 1 shl 3

## wlr_output_management

type wlr_output_manager_v1_events* = object
  apply*: wl_signal
  test*: wl_signal
  destroy*: wl_signal

type wlr_output_manager_v1* = object
  display*: ptr wl_display
  global*: ptr wl_global
  resources*: wl_list
  heads*: wl_list
  serial*: uint32
  current_configuration_dirty*: bool
  events*: wlr_output_manager_v1_events
  display_destroy*: wl_listener
  data*: pointer

type wlr_output_head_v1_state_events* = object
  width*, height*: int32
  refresh*: int32

type wlr_output_head_v1_state* = object
  output*: ptr wlr_output
  enabled*: bool
  mode*: ptr wlr_output_mode
  custom_mode*: wlr_output_head_v1_state_events
  x*, y*: int32
  transform*: wl_output_transform
  scale*: cfloat

type wlr_output_head_v1* = object
  state*: wlr_output_head_v1_state
  manager*: ptr wlr_output_manager_v1
  link*: wl_list
  resources*: wl_list
  mode_resources*: wl_list
  output_destroy*: wl_listener

type wlr_output_configuration_v1* = object
  heads*: wl_list

  manager*: ptr wlr_output_manager_v1
  serial*: uint32
  finalized*: bool
  finished*: bool
  resource*: ptr wl_resource

type wlr_output_configuration_head_v1* = object
  state*: wlr_output_head_v1_state
  config*: ptr wlr_output_configuration_v1
  link*: wl_list
  resource*: ptr wl_resource
  output_destroy*: wl_listener

## wlr_output

type wlr_output_mode* = object
  width*, height*: int32
  refresh*: int32
  preferred*: bool
  link*: wl_list

type wlr_output_cursor_events* = object
  destroy*: wl_signal

type wlr_output_cursor* = object
  output*: ptr wlr_output
  x*, y*: cdouble
  enabled*: bool
  visible*: bool
  width*, height*: uint32
  hotspot_x*, hotspot_y*: int32
  link*: wl_list
  texture*: ptr wlr_texture
  surface*: ptr wlr_surface
  surface_commit*: wl_listener
  surface_destroy*: wl_listener
  events*: wlr_output_cursor_events

type wlr_output_adaptive_sync_status* = enum
  WLR_OUTPUT_ADAPTIVE_SYNC_DISABLED,
  WLR_OUTPUT_ADAPTIVE_SYNC_ENABLED,
  WLR_OUTPUT_ADAPTIVE_SYNC_UNKNOWN

type wlr_output_state_field* = enum
  WLR_OUTPUT_STATE_BUFFER = 1 shl 0,
  WLR_OUTPUT_STATE_DAMAGE = 1 shl 1,
  WLR_OUTPUT_STATE_MODE = 1 shl 2,
  WLR_OUTPUT_STATE_ENABLED = 1 shl 3,
  WLR_OUTPUT_STATE_SCALE = 1 shl 4,
  WLR_OUTPUT_STATE_TRANSFORM = 1 shl 5,
  WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED = 1 shl 6,
  WLR_OUTPUT_STATE_GAMMA_LUT = 1 shl 7

type wlr_output_state_buffer_type* = enum
  WLR_OUTPUT_STATE_BUFFER_RENDER,
  WLR_OUTPUT_STATE_BUFFER_SCANOUT

type wlr_output_state_mode_type* = enum
  WLR_OUTPUT_STATE_MODE_FIXED,
  WLR_OUTPUT_STATE_MODE_CUSTOM

type wlr_output_state_custom_mode* = object
  width*, height*: int32
  refresh*: int32

type wlr_output_state* = object
  committed*: uint32
  damage*: pixman_region32_t
  enabled*: bool
  scale*: cfloat
  transform*: wl_output_transform
  adaptive_sync_enabled*: bool
  buffer_type*: wlr_output_state_buffer_type
  buffer*: ptr wlr_buffer
  mode_type*: wlr_output_state_mode_type
  mode*: ptr wlr_output_mode
  custom_mode*: wlr_output_state_custom_mode
  gamma_lut*: ptr uint16
  gamma_lut_size*: csize_t

type wlr_output_impl* = object

type wlr_output_events* = object
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

type wlr_output* = object
  impl*: ptr wlr_output_impl
  backend*: ptr wlr_backend
  display*: ptr wl_display
  global*: ptr wl_global
  resources*: wl_list
  name*: array[24, char]
  description*: cstring
  make*: array[56, char]
  model*: array[16, char]
  serial*: array[16, char]
  phys_width*, phys_height*: int32
  modes*: wl_list
  current_mode*: ptr wlr_output_mode
  width*, height*: int32
  refresh*: int32
  enabled*: bool
  scale*: cfloat
  subpixel*: wl_output_subpixel
  transform*: wl_output_transform
  adaptive_sync_status*: wlr_output_adaptive_sync_status
  needs_frame*: bool
  frame_pending*: bool
  transform_matrix*: array[9, cfloat]
  pending*: wlr_output_state
  commit_seq*: uint32
  events*: wlr_output_events
  idle_frame*: ptr wl_event_source
  idle_done*: ptr wl_event_source
  attach_render_locks*: cint
  cursors*: wl_list
  hardware_cursor*: ptr wlr_output_cursor
  cursor_swapchain*: ptr wlr_swapchain
  cursor_front_buffer*: ptr wlr_buffer
  software_cursor_locks*: cint
  swapchain*: ptr wlr_swapchain
  back_buffer*: ptr wlr_buffer
  display_destroy*: wl_listener
  data*: pointer

type wlr_output_event_damage* = object
  output*: ptr wlr_output
  damage*: ptr pixman_region32_t

type wlr_output_event_precommit* = object
  output*: ptr wlr_output
  `when`*: ptr timespec

type wlr_output_event_commit* = object
  output*: ptr wlr_output
  committed*: uint32
  `when`*: ptr timespec

type wlr_output_present_flag* = enum
  WLR_OUTPUT_PRESENT_VSYNC = 0x1,
  WLR_OUTPUT_PRESENT_HW_CLOCK = 0x2,
  WLR_OUTPUT_PRESENT_HW_COMPLETION = 0x4,
  WLR_OUTPUT_PRESENT_ZERO_COPY = 0x8

type wlr_output_event_present* = object
  output*: ptr wlr_output
  commit_seq*: uint32
  `when`*: ptr timespec
  seq*: cuint
  refresh*: cint
  flags*: uint32

type wlr_output_event_bind* = object
  output*: ptr wlr_output
  resource*: ptr wl_resource

type wlr_surface* = object

## wlr_output_power_management_v1

# import wlr-output-power-management-unstable-v1-protocol

type wlr_output_power_manager_v1_events* = object
  set_mode*: wl_signal
  destroy*: wl_signal

type wlr_output_power_manager_v1* = object
  global*: ptr wl_global
  output_powers*: wl_list
  display_destroy*: wl_listener
  events*: wlr_output_power_manager_v1_events
  data*: pointer

type wlr_output_power_v1* = object
  resource*: ptr wl_resource
  output*: ptr wlr_output
  manager*: ptr wlr_output_power_manager_v1
  link*: wl_list
  output_destroy_listener*: wl_listener
  output_commit_listener*: wl_listener
  data*: pointer

type wlr_output_power_v1_set_mode_event* = object
  output*: ptr wlr_output
  mode*: wlr_output_power_v1_mode

## wlr_pointer_constraints_v1

# import pointer-constraints-unstable-v1-protocol

type wlr_seat* = object

type wlr_pointer_constraint_v1_type* = enum
  WLR_POINTER_CONSTRAINT_V1_LOCKED,
  WLR_POINTER_CONSTRAINT_V1_CONFINED

type wlr_pointer_constraint_v1_state_field* = enum
  WLR_POINTER_CONSTRAINT_V1_STATE_REGION = 1 shl 0,
  WLR_POINTER_CONSTRAINT_V1_STATE_CURSOR_HINT = 1 shl 1

type wlr_pointer_constraint_v1_state_cursor_hint* = object
  x*, y*: cdouble

type wlr_pointer_constraint_v1_state* = object
  committed*: uint32
  region*: pixman_region32_t
  cursor_hint*: wlr_pointer_constraint_v1_state_cursor_hint

type wlr_pointer_constraint_v1_events* = object
  set_region*: wl_signal
  destroy*: wl_signal

type wlr_pointer_constraint_v1* = object
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
  events*: wlr_pointer_constraint_v1_events
  data*: pointer

type wlr_pointer_constraints_v1_events* = object
  new_constraint*: wl_signal

type wlr_pointer_constraints_v1* = object
  global*: ptr wl_global
  constraints*: wl_list
  events*: wlr_pointer_constraints_v1_events
  display_destroy*: wl_listener
  data*: pointer

## wlr_pointer_gestures_v1

type wlr_pointer_gestures_v1_events* = object
  destroy*: wl_signal

type wlr_pointer_gestures_v1* = object
  global*: ptr wl_global
  swipes*: wl_list
  pinches*: wl_list
  display_destroy*: wl_listener
  events*: wlr_pointer_gestures_v1_events
  data*: pointer

## wlr_pointer

type wlr_pointer_impl* = object

type wlr_pointer_events* = object
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

type wlr_pointer* = object
  impl*: ptr wlr_pointer_impl
  events*: wlr_pointer_events
  data*: pointer

type wlr_event_pointer_motion* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  delta_x*, delta_y*: cdouble
  unaccel_dx*, unaccel_dy*: cdouble

type wlr_event_pointer_motion_absolute* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  x*, y*: cdouble

type wlr_event_pointer_button* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  button*: uint32
  state*: wlr_button_state

type wlr_axis_source* = enum
  WLR_AXIS_SOURCE_WHEEL,
  WLR_AXIS_SOURCE_FINGER,
  WLR_AXIS_SOURCE_CONTINUOUS,
  WLR_AXIS_SOURCE_WHEEL_TILT

type wlr_axis_orientation* = enum
  WLR_AXIS_ORIENTATION_VERTICAL,
  WLR_AXIS_ORIENTATION_HORIZONTAL

type wlr_event_pointer_axis* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  source*: wlr_axis_source
  orientation*: wlr_axis_orientation
  delta*: cdouble
  delta_discrete*: int32

type wlr_event_pointer_swipe_begin* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  fingers*: uint32

type wlr_event_pointer_swipe_update* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  fingers*: uint32
  dx*, dy*: cdouble

type wlr_event_pointer_swipe_end* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  cancelled*: bool

type wlr_event_pointer_pinch_begin* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  fingers*: uint32

type wlr_event_pointer_pinch_update* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  fingers*: uint32
  dx*, dy*: cdouble
  scale*: cdouble
  rotation*: cdouble

type wlr_event_pointer_pinch_end* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  cancelled*: bool

## wlr_presentation_time

type wlr_output* = object

type wlr_output_event_present* = object

type wlr_presentation_events* = object
  destroy*: wl_signal

type wlr_presentation* = object
  global*: ptr wl_global
  feedbacks*: wl_list
  clock*: clockid_t
  events*: wlr_presentation_events
  display_destroy*: wl_listener

type wlr_presentation_feedback* = object
  presentation*: ptr wlr_presentation
  surface*: ptr wlr_surface
  link*: wl_list
  resources*: wl_list
  committed*: bool
  sampled*: bool
  presented*: bool
  output*: ptr wlr_output
  output_committed*: bool
  output_commit_seq*: uint32
  surface_commit*: wl_listener
  surface_destroy*: wl_listener
  output_commit*: wl_listener
  output_present*: wl_listener
  output_destroy*: wl_listener

type wlr_presentation_event* = object
  output*: ptr wlr_output
  tv_sec*: uint64
  tv_nsec*: uint32
  refresh*: uint32
  seq*: uint64
  flags*: uint32

type wlr_backend* = object

## wlr_primary_selection

type wlr_primary_selection_source* = object

type wlr_primary_selection_source_impl* = object
  send*: proc (source: ptr wlr_primary_selection_source; mime_type: cstring; fd: cint)
  destroy*: proc (source: ptr wlr_primary_selection_source)

type wlr_primary_selection_source_events* = object
  destroy*: wl_signal

type wlr_primary_selection_source* = object
  impl*: ptr wlr_primary_selection_source_impl
  mime_types*: wl_array
  events*: wlr_primary_selection_source_events
  data*: pointer

## wlr_primary_selection_v1

type wlr_primary_selection_v1_device_manager_events* = object
  destroy*: wl_signal

type wlr_primary_selection_v1_device_manager* = object
  global*: ptr wl_global
  devices*: wl_list
  display_destroy*: wl_listener
  events*: wlr_primary_selection_v1_device_manager_events
  data*: pointer

type wlr_primary_selection_v1_device* = object
  manager*: ptr wlr_primary_selection_v1_device_manager
  seat*: ptr wlr_seat
  link*: wl_list
  resources*: wl_list
  offers*: wl_list
  seat_destroy*: wl_listener
  seat_focus_change*: wl_listener
  seat_set_primary_selection*: wl_listener
  data*: pointer

## wlr_region

## wlr_relative_pointer

type wlr_relative_pointer_manager_v1_events* = object
  destroy*: wl_signal
  new_relative_pointer*: wl_signal

type wlr_relative_pointer_manager_v1* = object
  global*: ptr wl_global
  relative_pointers*: wl_list
  events*: wlr_relative_pointer_manager_v1_events
  display_destroy_listener*: wl_listener
  data*: pointer

type wlr_relative_pointer_v1_events* = object
  destroy*: wl_signal

type wlr_relative_pointer_v1* = object
  resource*: ptr wl_resource
  pointer_resource*: ptr wl_resource
  seat*: ptr wlr_seat
  link*: wl_list
  events*: wlr_relative_pointer_v1_events
  seat_destroy*: wl_listener
  pointer_destroy*: wl_listener

  data*: pointer

## wlr_screencopy_v1

type wlr_screencopy_manager_v1_events* = object
  destroy*: wl_signal

type wlr_screencopy_manager_v1* = object
  global*: ptr wl_global
  frames*: wl_list
  display_destroy*: wl_listener
  events*: wlr_screencopy_manager_v1_events
  data*: pointer

type wlr_screencopy_v1_client* = object
  `ref`*: cint
  manager*: ptr wlr_screencopy_manager_v1
  damages*: wl_list

type wlr_screencopy_frame_v1* = object
  resource*: ptr wl_resource
  client*: ptr wlr_screencopy_v1_client
  link*: wl_list
  format*: wl_shm_format
  fourcc*: uint32
  box*: wlr_box
  stride*: cint
  overlay_cursor*: bool
  cursor_locked*: bool
  with_damage*: bool
  shm_buffer*: ptr wl_shm_buffer
  dma_buffer*: ptr wlr_dmabuf_v1_buffer
  buffer_destroy*: wl_listener
  output*: ptr wlr_output
  output_precommit*: wl_listener
  output_commit*: wl_listener
  output_destroy*: wl_listener
  output_enable*: wl_listener
  data*: pointer

## wlr_seat

const WLR_SERIAL_RINGSET_SIZE* = 128

type wlr_serial_range* = object
  min_incl*: uint32
  max_incl*: uint32

type wlr_serial_ringset* = object
  data*: array[WLR_SERIAL_RINGSET_SIZE, wlr_serial_range]
  `end`*: cint
  count*: cint

type wlr_seat_clients_events* = object
  destroy*: wl_signal

type wlr_seat_client* = object
  client*: ptr wl_client
  seat*: ptr wlr_seat
  link*: wl_list
  resources*: wl_list
  pointers*: wl_list
  keyboards*: wl_list
  touches*: wl_list
  data_devices*: wl_list
  events*: wlr_seat_clients_events
  serials*: wlr_serial_ringset

type wlr_touch_point_events* = object
  destroy*: wl_signal

type wlr_touch_point* = object
  touch_id*: int32
  surface*: ptr wlr_surface
  client*: ptr wlr_seat_client
  focus_surface*: ptr wlr_surface
  focus_client*: ptr wlr_seat_client
  sx*, sy*: cdouble
  surface_destroy*: wl_listener
  focus_surface_destroy*: wl_listener
  client_destroy*: wl_listener
  events*: wlr_touch_point_events
  link*: wl_list

type wlr_seat_pointer_grab* = object

type wlr_pointer_grab_interface* = object
  enter*: proc (grab: ptr wlr_seat_pointer_grab; surface: ptr wlr_surface; sx, sy: cdouble)
  clear_focus*: proc (grab: ptr wlr_seat_pointer_grab)
  motion*: proc (grab: ptr wlr_seat_pointer_grab; time_msec: uint32; sx, sy: cdouble)
  button*: proc (grab: ptr wlr_seat_pointer_grab; time_msec: uint32; button: uint32; state: wlr_button_state): uint32
  axis*: proc (grab: ptr wlr_seat_pointer_grab; time_msec: uint32; orientation: wlr_axis_orientation; value: cdouble; value_discrete: int32; source: wlr_axis_source)
  frame*: proc (grab: ptr wlr_seat_pointer_grab)
  cancel*: proc (grab: ptr wlr_seat_pointer_grab)

type wlr_seat_keyboard_grab* = object

type wlr_keyboard_grab_interface* = object
  enter*: proc (grab: ptr wlr_seat_keyboard_grab; surface: ptr wlr_surface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr wlr_keyboard_modifiers)
  clear_focus*: proc (grab: ptr wlr_seat_keyboard_grab)
  key*: proc (grab: ptr wlr_seat_keyboard_grab; time_msec: uint32; key: uint32; state: uint32)
  modifiers*: proc (grab: ptr wlr_seat_keyboard_grab; modifiers: ptr wlr_keyboard_modifiers)
  cancel*: proc (grab: ptr wlr_seat_keyboard_grab)

type wlr_seat_touch_grab* = object

type wlr_touch_grab_interface* = object
  down*: proc (grab: ptr wlr_seat_touch_grab; time_msec: uint32; point: ptr wlr_touch_point): uint32
  up*: proc (grab: ptr wlr_seat_touch_grab; time_msec: uint32; point: ptr wlr_touch_point)
  motion*: proc (grab: ptr wlr_seat_touch_grab; time_msec: uint32; point: ptr wlr_touch_point)
  enter*: proc (grab: ptr wlr_seat_touch_grab; time_msec: uint32; point: ptr wlr_touch_point)
  cancel*: proc (grab: ptr wlr_seat_touch_grab)

type wlr_seat_touch_grab* = object
  `interface`*: ptr wlr_touch_grab_interface
  seat*: ptr wlr_seat
  data*: pointer

type wlr_seat_keyboard_grab* = object
  `interface`*: ptr wlr_keyboard_grab_interface
  seat*: ptr wlr_seat
  data*: pointer

type wlr_seat_pointer_grab* = object
  `interface`*: ptr wlr_pointer_grab_interface
  seat*: ptr wlr_seat
  data*: pointer

const WLR_POINTER_BUTTONS_CAP* = 16

type wlr_seat_pointer_state_events* = object
  focus_change*: wl_signal

type wlr_seat_pointer_state* = object
  seat*: ptr wlr_seat
  focused_client*: ptr wlr_seat_client
  focused_surface*: ptr wlr_surface
  sx*, sy*: cdouble
  grab*: ptr wlr_seat_pointer_grab
  default_grab*: ptr wlr_seat_pointer_grab
  buttons*: array[WLR_POINTER_BUTTONS_CAP, uint32]
  button_count*: csize_t
  grab_button*: uint32
  grab_serial*: uint32
  grab_time*: uint32
  surface_destroy*: wl_listener
  events*: wlr_seat_pointer_state_events

type wlr_seat_keyboard_state_events* = object
  focus_change*: wl_signal

type wlr_seat_keyboard_state* = object
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
  events*: wlr_seat_keyboard_state_events

type wlr_seat_touch_state* = object
  seat*: ptr wlr_seat
  touch_points*: wl_list
  grab_serial*: uint32
  grab_id*: uint32
  grab*: ptr wlr_seat_touch_grab
  default_grab*: ptr wlr_seat_touch_grab

type wlr_primary_selection_source* = object

type wlr_seat_events* = object
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

type wlr_seat* = object
  global*: ptr wl_global
  display*: ptr wl_display
  clients*: wl_list
  name*: cstring
  capabilities*: uint32
  accumulated_capabilities*: uint32
  last_event*: timespec
  selection_source*: ptr wlr_data_source
  selection_serial*: uint32
  selection_offers*: wl_list
  primary_selection_source*: ptr wlr_primary_selection_source
  primary_selection_serial*: uint32
  drag*: ptr wlr_drag
  drag_source*: ptr wlr_data_source
  drag_serial*: uint32
  drag_offers*: wl_list
  pointer_state*: wlr_seat_pointer_state
  keyboard_state*: wlr_seat_keyboard_state
  touch_state*: wlr_seat_touch_state
  display_destroy*: wl_listener
  selection_source_destroy*: wl_listener
  primary_selection_source_destroy*: wl_listener
  drag_source_destroy*: wl_listener
  events*: wlr_seat_events
  data*: pointer

type wlr_seat_pointer_request_set_cursor_event* = object
  seat_client*: ptr wlr_seat_client
  surface*: ptr wlr_surface
  serial*: uint32
  hotspot_x*, hotspot_y*: int32

type wlr_seat_request_set_selection_event* = object
  source*: ptr wlr_data_source
  serial*: uint32

type wlr_seat_request_set_primary_selection_event* = object
  source*: ptr wlr_primary_selection_source
  serial*: uint32

type wlr_seat_request_start_drag_event* = object
  drag*: ptr wlr_drag
  origin*: ptr wlr_surface
  serial*: uint32

type wlr_seat_pointer_focus_change_event* = object
  seat*: ptr wlr_seat
  old_surface*, new_surface*: ptr wlr_surface
  sx*, sy*: cdouble

type wlr_seat_keyboard_focus_change_event* = object
  seat*: ptr wlr_seat
  old_surface*, new_surface*: ptr wlr_surface

## wlr_server_decoration

type wlr_server_decoration_manager_mode* = enum
  WLR_SERVER_DECORATION_MANAGER_MODE_NONE = 0,
  WLR_SERVER_DECORATION_MANAGER_MODE_CLIENT = 1,
  WLR_SERVER_DECORATION_MANAGER_MODE_SERVER = 2

type wlr_server_decoration_manager_events* = object
  new_decoration*: wl_signal
  destroy*: wl_signal

type wlr_server_decoration_manager* = object
  global*: ptr wl_global
  resources*: wl_list
  decorations*: wl_list
  default_mode*: uint32
  display_destroy*: wl_listener
  events*: wlr_server_decoration_manager_events
  data*: pointer

type wlr_server_decoration_events* = object
  destroy*: wl_signal
  mode*: wl_signal

type wlr_server_decoration* = object
  resource*: ptr wl_resource
  surface*: ptr wlr_surface
  link*: wl_list
  mode*: uint32
  events*: wlr_server_decoration_events
  surface_destroy_listener*: wl_listener
  data*: pointer

## wlr_surface

type wlr_surface_state_field* = enum
  WLR_SURFACE_STATE_BUFFER = 1 shl 0,
  WLR_SURFACE_STATE_SURFACE_DAMAGE = 1 shl 1,
  WLR_SURFACE_STATE_BUFFER_DAMAGE = 1 shl 2,
  WLR_SURFACE_STATE_OPAQUE_REGION = 1 shl 3,
  WLR_SURFACE_STATE_INPUT_REGION = 1 shl 4,
  WLR_SURFACE_STATE_TRANSFORM = 1 shl 5,
  WLR_SURFACE_STATE_SCALE = 1 shl 6,
  WLR_SURFACE_STATE_FRAME_CALLBACK_LIST = 1 shl 7,
  WLR_SURFACE_STATE_VIEWPORT = 1 shl 8

type wlr_surface_state_viewport* = object
  has_src*, has_dst*: bool
  src*: wlr_fbox
  dst_width*, dst_height*: cint

type wlr_surface_state* = object
  committed*: uint32
  seq*: uint32
  buffer_resource*: ptr wl_resource
  dx*, dy*: int32
  surface_damage*,  buffer_damage*: pixman_region32_t
  opaque*, input*: pixman_region32_t
  transform*: wl_output_transform
  scale*: int32
  frame_callback_list*: wl_list
  width*, height*: cint
  buffer_width*, buffer_height*: cint
  viewport*: wlr_surface_state_viewport
  buffer_destroy*: wl_listener
  cached_state_locks*: csize_t
  cached_state_link*: wl_list

type wlr_surface_role* = object
  name*: cstring
  commit*: proc (surface: ptr wlr_surface)
  precommit*: proc (surface: ptr wlr_surface)

type wlr_surface_output* = object
  surface*: ptr wlr_surface
  output*: ptr wlr_output
  link*: wl_list
  `bind`*: wl_listener
  destroy*: wl_listener

type wlr_surface_events* = object
  commit*: wl_signal
  new_subsurface*: wl_signal
  destroy*: wl_signal

type wlr_surface* = object
  resource*: ptr wl_resource
  renderer*: ptr wlr_renderer
  buffer*: ptr wlr_client_buffer
  sx*, sy*: cint
  buffer_damage*: pixman_region32_t
  opaque_region*: pixman_region32_t
  input_region*: pixman_region32_t
  current*, pending*, previous*: wlr_surface_state
  cached*: wl_list
  role*: ptr wlr_surface_role
  role_data*: pointer
  events*: wlr_surface_events
  subsurfaces_below*: wl_list
  subsurfaces_above*: wl_list
  subsurfaces_pending_below*: wl_list
  subsurfaces_pending_above*: wl_list
  current_outputs*: wl_list
  renderer_destroy*: wl_listener
  data*: pointer

type wlr_subsurface_state* = object
  x*, y*: int32

type wlr_subsurface_events* = object
  destroy*: wl_signal
  map*: wl_signal
  unmap*: wl_signal

type wlr_subsurface* = object
  resource*: ptr wl_resource
  surface*: ptr wlr_surface
  parent*: ptr wlr_surface
  current*, pending*: wlr_subsurface_state
  cached_seq*: uint32
  has_cache*: bool
  synchronized*: bool
  reordered*: bool
  mapped*: bool
  parent_link*: wl_list
  parent_pending_link*: wl_list
  surface_destroy*: wl_listener
  parent_destroy*: wl_listener
  events*: wlr_subsurface_events
  data*: pointer

type wlr_surface_iterator_func_t* = proc (surface: ptr wlr_surface; sx, sy: cint; data: pointer)

## wlr_switch

type wlr_switch_impl* = object

type wlr_switch_events* = object
  toggle*: wl_signal

type wlr_switch* = object
  impl*: ptr wlr_switch_impl
  events*: wlr_switch_events
  data*: pointer

type wlr_switch_type* = enum
  WLR_SWITCH_TYPE_LID = 1,
  WLR_SWITCH_TYPE_TABLET_MODE

type wlr_switch_state* = enum
  WLR_SWITCH_STATE_OFF = 0,
  WLR_SWITCH_STATE_ON,
  WLR_SWITCH_STATE_TOGGLE

type wlr_event_switch_toggle* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  switch_type*: wlr_switch_type
  switch_state*: wlr_switch_state

## wlr_tablet_pad

type wlr_tablet_pad_impl* = object

type wlr_tablet_pad_events* = object
  button*: wl_signal
  ring*: wl_signal
  strip*: wl_signal
  attach_tablet*: wl_signal

type wlr_tablet_pad* = object
  impl*: ptr wlr_tablet_pad_impl

  events*: wlr_tablet_pad_events
  button_count*: csize_t
  ring_count*: csize_t
  strip_count*: csize_t
  groups*: wl_list
  paths*: wlr_list
  data*: pointer

type wlr_tablet_pad_group* = object
  link*: wl_list
  button_count*: csize_t
  buttons*: ptr cuint
  strip_count*: csize_t
  strips*: ptr cuint
  ring_count*: csize_t
  rings*: ptr cuint
  mode_count*: cuint

type wlr_event_tablet_pad_button* = object
  time_msec*: uint32
  button*: uint32
  state*: wlr_button_state
  mode*: cuint
  group*: cuint

type wlr_tablet_pad_ring_source* = enum
  WLR_TABLET_PAD_RING_SOURCE_UNKNOWN,
  WLR_TABLET_PAD_RING_SOURCE_FINGER

type wlr_event_tablet_pad_ring* = object
  time_msec*: uint32
  source*: wlr_tablet_pad_ring_source
  ring*: uint32
  position*: cdouble
  mode*: cuint

type wlr_tablet_pad_strip_source* = enum
  WLR_TABLET_PAD_STRIP_SOURCE_UNKNOWN,
  WLR_TABLET_PAD_STRIP_SOURCE_FINGER

type wlr_event_tablet_pad_strip* = object
  time_msec*: uint32
  source*: wlr_tablet_pad_strip_source
  strip*: uint32
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

type wlr_tablet_tool_events* = object
  destroy*: wl_signal

type wlr_tablet_tool* = object
  `type`*: wlr_tablet_tool_type
  hardware_serial*: uint64
  hardware_wacom*: uint64
  tilt*: bool
  pressure*: bool
  distance*: bool
  rotation*: bool
  slider*: bool
  wheel*: bool
  events*: wlr_tablet_tool_events
  data*: pointer

type wlr_tablet_impl* = object

type wlr_tablet_events* = object
  axis*: wl_signal
  proximity*: wl_signal
  tip*: wl_signal
  button*: wl_signal

type wlr_tablet* = object
  impl*: ptr wlr_tablet_impl
  events*: wlr_tablet_events
  name*: cstring
  paths*: wlr_list
  data*: pointer

type wlr_tablet_tool_axes* = enum
  WLR_TABLET_TOOL_AXIS_X = 1 shl 0,
  WLR_TABLET_TOOL_AXIS_Y = 1 shl 1,
  WLR_TABLET_TOOL_AXIS_DISTANCE = 1 shl 2,
  WLR_TABLET_TOOL_AXIS_PRESSURE = 1 shl 3,
  WLR_TABLET_TOOL_AXIS_TILT_X = 1 shl 4,
  WLR_TABLET_TOOL_AXIS_TILT_Y = 1 shl 5,
  WLR_TABLET_TOOL_AXIS_ROTATION = 1 shl 6,
  WLR_TABLET_TOOL_AXIS_SLIDER = 1 shl 7,
  WLR_TABLET_TOOL_AXIS_WHEEL = 1 shl 8

type wlr_event_tablet_tool_axis* = object
  device*: ptr wlr_input_device
  tool*: ptr wlr_tablet_tool
  time_msec*: uint32
  updated_axes*: uint32
  x*, y*: cdouble
  dx*, dy*: cdouble
  pressure*, distance*: cdouble
  tilt_x*, tilt_y*: cdouble
  rotation*: cdouble
  slider*: cdouble
  wheel_delta*: cdouble

type wlr_tablet_tool_proximity_state* = enum
  WLR_TABLET_TOOL_PROXIMITY_OUT,
  WLR_TABLET_TOOL_PROXIMITY_IN

type wlr_event_tablet_tool_proximity* = object
  device*: ptr wlr_input_device
  tool*: ptr wlr_tablet_tool
  time_msec*: uint32
  x*, y*: cdouble
  state*: wlr_tablet_tool_proximity_state

type wlr_tablet_tool_tip_state* = enu
  WLR_TABLET_TOOL_TIP_UP,
  WLR_TABLET_TOOL_TIP_DOWN

type wlr_event_tablet_tool_tip* = object
  device*: ptr wlr_input_device
  tool*: ptr wlr_tablet_tool
  time_msec*: uint32
  x*, y*: cdouble
  state*: wlr_tablet_tool_tip_state

type wlr_event_tablet_tool_button* = object
  device*: ptr wlr_input_device
  tool*: ptr wlr_tablet_tool
  time_msec*: uint32
  button*: uint32
  state*: wlr_button_state

## wlr_tablet_v2

# import tablet-unstable-v2-protocol

const WLR_TABLET_V2_TOOL_BUTTONS_CAP* = 16

type wlr_tablet_pad_v2_grab_interface* = object

type wlr_tablet_pad_v2_grab* = object
  `interface`*: ptr wlr_tablet_pad_v2_grab_interface
  pad*: ptr wlr_tablet_v2_tablet_pad
  data*: pointer

type wlr_tablet_tool_v2_grab_interface* = object

type wlr_tablet_tool_v2_grab* = object
  `interface`*: ptr wlr_tablet_tool_v2_grab_interface
  tool*: ptr wlr_tablet_v2_tablet_tool
  data*: pointer

type wlr_tablet_client_v2* = object
type wlr_tablet_tool_client_v2* = object
type wlr_tablet_pad_client_v2* = object

type wlr_tablet_manager_v2_events* = object
  destroy*: wl_signal

type wlr_tablet_manager_v2* = object
  wl_global*: ptr wl_global
  clients*: wl_list
  seats*: wl_list
  display_destroy*: wl_listener
  events*: wlr_tablet_manager_v2_events
  data*: pointer

type wlr_tablet_v2_tablet* = object
  link*: wl_list
  wlr_tablet*: ptr wlr_tablet
  wlr_device*: ptr wlr_input_device
  clients*: wl_list
  tool_destroy*: wl_listener
  current_client*: ptr wlr_tablet_client_v2

type wlr_tablet_v2_tablet_tool_events* = object
  set_cursor*: wl_signal

type wlr_tablet_v2_tablet_tool* = object
  link*: wl_list
  wlr_tool*: ptr wlr_tablet_tool
  clients*: wl_list
  tool_destroy*: wl_listener
  current_client*: ptr wlr_tablet_tool_client_v2
  focused_surface*: ptr wlr_surface
  surface_destroy*: wl_listener
  grab*: ptr wlr_tablet_tool_v2_grab
  default_grab*: wlr_tablet_tool_v2_grab
  proximity_serial*: uint32
  is_down*: bool
  down_serial*: uint32
  num_buttons*: csize_t
  pressed_buttons*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32]
  pressed_serials*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32]
  events*: wlr_tablet_v2_tablet_tool_events

type wlr_tablet_v2_tablet_pad_events* = object
  button_feedback*: wl_signal
  strip_feedback*: wl_signal
  ring_feedback*: wl_signal

type wlr_tablet_v2_tablet_pad* = object
  link*: wl_list
  wlr_pad*: ptr wlr_tablet_pad
  wlr_device*: ptr wlr_input_device
  clients*: wl_list
  group_count*: csize_t
  groups*: ptr uint32
  pad_destroy*: wl_listener
  current_client*: ptr wlr_tablet_pad_client_v2
  grab*: ptr wlr_tablet_pad_v2_grab
  default_grab*: wlr_tablet_pad_v2_grab
  events*: wlr_tablet_v2_tablet_pad_events

type wlr_tablet_v2_event_cursor* = object
  surface*: ptr wlr_surface
  serial*: uint32
  hotspot_x*, hotspot_y*: int32
  seat_client*: ptr wlr_seat_client

type wlr_tablet_v2_event_feedback* = object
  description*: cstring
  index*: csize_t
  serial*: uint32

type wlr_tablet_tool_v2_grab_interface* = object
  proximity_in*: proc (grab: ptr wlr_tablet_tool_v2_grab; tablet: ptr wlr_tablet_v2_tablet; surface: ptr wlr_surface)
  down*: proc (grab: ptr wlr_tablet_tool_v2_grab)
  up*: proc (grab: ptr wlr_tablet_tool_v2_grab)
  motion*: proc (grab: ptr wlr_tablet_tool_v2_grab; x, y: cdouble)
  pressure*: proc (grab: ptr wlr_tablet_tool_v2_grab; pressure: cdouble)
  distance*: proc (grab: ptr wlr_tablet_tool_v2_grab; distance: cdouble)
  tilt*: proc (grab: ptr wlr_tablet_tool_v2_grab; x, y: cdouble)
  rotation*: proc (grab: ptr wlr_tablet_tool_v2_grab; degrees: cdouble)
  slider*: proc (grab: ptr wlr_tablet_tool_v2_grab; position: cdouble)
  wheel*: proc (grab: ptr wlr_tablet_tool_v2_grab; degrees: cdouble; clicks: int32)
  proximity_out*: proc (grab: ptr wlr_tablet_tool_v2_grab)
  button*: proc (grab: ptr wlr_tablet_tool_v2_grab; button: uint32; state: zwp_tablet_pad_v2_button_state)
  cancel*: proc (grab: ptr wlr_tablet_tool_v2_grab)

type wlr_tablet_pad_v2_grab_interface* = object
  enter*: proc (grab: ptr wlr_tablet_pad_v2_grab; tablet: ptr wlr_tablet_v2_tablet; surface: ptr wlr_surface): uint32
  button*: proc (grab: ptr wlr_tablet_pad_v2_grab; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state)
  strip*: proc (grab: ptr wlr_tablet_pad_v2_grab; strip: uint32; position: cdouble; finger: bool; time: uint32)
  ring*: proc (grab: ptr wlr_tablet_pad_v2_grab; ring: uint32; position: cdouble; finger: bool; time: uint32)
  leave*: proc (grab: ptr wlr_tablet_pad_v2_grab; surface: ptr wlr_surface): uint32
  mode*: proc (grab: ptr wlr_tablet_pad_v2_grab; group: csize_t; mode: uint32; time: uint32): uint32
  cancel*: proc (grab: ptr wlr_tablet_pad_v2_grab)

## wlr_text_input_v3

type wlr_text_input_v3_features* = enum
  WLR_TEXT_INPUT_V3_FEATURE_SURROUNDING_TEXT = 1 shl 0,
  WLR_TEXT_INPUT_V3_FEATURE_CONTENT_TYPE = 1 shl 1,
  WLR_TEXT_INPUT_V3_FEATURE_CURSOR_RECTANGLE = 1 shl 2

type wlr_text_input_v3_state_surrounding* = object
  text*: cstring
  cursor*: uint32
  anchor*: uint32

type wlr_text_input_v3_state_content_type* = object
  hint*: uint32
  purpose*: uint32

type wlr_text_input_v3_state_cursor_rectangle* = object
  x*, y*: int32
  width*, height*: int32

type wlr_text_input_v3_state* = object
  surrounding*: wlr_text_input_v3_state_surrounding
  text_change_cause*: uint32
  content_type*: wlr_text_input_v3_state_content_type
  cursor_rectangle*: wlr_text_input_v3_state_cursor_rectangle
  features*: uint32

type wlr_text_input_v3_events* = object
  enable*: wl_signal
  commit*: wl_signal
  disable*: wl_signal
  destroy*: wl_signal

type wlr_text_input_v3* = object
  seat*: ptr wlr_seat
  resource*: ptr wl_resource
  focused_surface*: ptr wlr_surface
  pending*: wlr_text_input_v3_state
  current*: wlr_text_input_v3_state
  current_serial*: uint32
  pending_enabled*: bool
  current_enabled*: bool
  active_features*: uint32
  link*: wl_list
  surface_destroy*: wl_listener
  seat_destroy*: wl_listener
  events*: wlr_text_input_v3_events

type wlr_text_input_manager_v3_events* = object
  text_input*: wl_signal
  destroy*: wl_signal

type wlr_text_input_manager_v3* = object
  global*: ptr wl_global
  text_inputs*: wl_list
  display_destroy*: wl_listener
  events*: wlr_text_input_manager_v3_events

## wlr_touch

type wlr_touch_impl* = object

type wlr_touch_events* = object
  down*: wl_signal
  up*: wl_signal
  motion*: wl_signal
  cancel*: wl_signal

type wlr_touch* = object
  impl*: ptr wlr_touch_impl
  events*: wlr_touch_events
  data*: pointer

type wlr_event_touch_down* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  touch_id*: int32
  x*, y*: cdouble

type wlr_event_touch_up* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  touch_id*: int32

type wlr_event_touch_motion* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  touch_id*: int32
  x*, y*: cdouble

type wlr_event_touch_cancel* = object
  device*: ptr wlr_input_device
  time_msec*: uint32
  touch_id*: int32

## wlr_viewporter

type wlr_viewporter_events* = object
  destroy*: wl_signal

type wlr_viewporter* = object
  global*: ptr wl_global
  events*: wlr_viewporter_events
  display_destroy*: wl_listener

type wlr_viewport* = object
  resource*: ptr wl_resource
  surface*: ptr wlr_surface
  surface_destroy*: wl_listener
  surface_commit*: wl_listener

## wlr_virtual_keyboard_v1

type wlr_virtual_keyboard_manager_v1_events* = object
  new_virtual_keyboard*: wl_signal
  destroy*: wl_signal

type wlr_virtual_keyboard_manager_v1* = object
  global*: ptr wl_global
  virtual_keyboards*: wl_list
  display_destroy*: wl_listener
  events*: wlr_virtual_keyboard_manager_v1_events

type wlr_virtual_keyboard_v1_events* = object
  destroy*: wl_signal

type wlr_virtual_keyboard_v1* = object
  input_device*: wlr_input_device
  resource*: ptr wl_resource
  seat*: ptr wlr_seat
  has_keymap*: bool
  link*: wl_list
  events*: wlr_virtual_keyboard_v1_events

## wlr_virtual_pointer_v1

type wlr_virtual_pointer_manager_v1_events* = object
  new_virtual_pointer*: wl_signal
  destroy*: wl_signal

type wlr_virtual_pointer_manager_v1* = object
  global*: ptr wl_global
  virtual_pointers*: wl_list
  display_destroy*: wl_listener
  events*: wlr_virtual_pointer_manager_v1_events

type wlr_virtual_pointer_v1_events* = object
  destroy*: wl_signal

type wlr_virtual_pointer_v1* = object
  input_device*: wlr_input_device
  resource*: ptr wl_resource
  axis_event*: array[2, wlr_event_pointer_axis]
  axis*: wl_pointer_axis
  axis_valid*: array[2, bool]
  link*: wl_list
  events*: wlr_virtual_pointer_v1_events

type wlr_virtual_pointer_v1_new_pointer_event* = object
  new_pointer*: ptr wlr_virtual_pointer_v1
  suggested_seat*: ptr wlr_seat
  suggested_output*: ptr wlr_output

## wlr_xcursor_manager

type wlr_xcursor_manager_theme* = object
  scale*: cfloat
  theme*: ptr wlr_xcursor_theme
  link*: wl_list

type wlr_xcursor_manager* = object
  name*: cstring
  size*: uint32
  scaled_themes*: wl_list

## wlr_xdg_activation_v1

type wlr_xdg_activation_token_v1* = object
  activation*: ptr wlr_xdg_activation_v1
  surface*: ptr wlr_surface
  seat*: ptr wlr_seat
  serial*: uint32
  app_id*: cstring
  link*: wl_list
  token*: cstring
  resource*: ptr wl_resource
  timeout*: ptr wl_event_source
  seat_destroy*: wl_listener
  surface_destroy*: wl_listener

type wlr_xdg_activation_v1_events* = object
  destroy*: wl_signal
  request_activate*: wl_signal

type wlr_xdg_activation_v1* = object
  token_timeout_msec*: uint32
  tokens*: wl_list
  events*: wlr_xdg_activation_v1_events
  global*: ptr wl_global
  display_destroy*: wl_listener

type wlr_xdg_activation_v1_request_activate_event* = object
  activation*: ptr wlr_xdg_activation_v1
  token*: ptr wlr_xdg_activation_token_v1
  surface*: ptr wlr_surface

## wlr_xdg_decoration_v1

type wlr_xdg_toplevel_decoration_v1_mode* = enum
  WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_NONE = 0,
  WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_CLIENT_SIDE = 1,
  WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_SERVER_SIDE = 2

type wlr_xdg_decoration_manager_v1_events* = object
  new_toplevel_decoration*: wl_signal
  destroy*: wl_signal

type wlr_xdg_decoration_manager_v1* = object
  global*: ptr wl_global
  decorations*: wl_list
  display_destroy*: wl_listener
  events*: wlr_xdg_decoration_manager_v1_events
  data*: pointer

type wlr_xdg_toplevel_decoration_v1_configure* = object
  link*: wl_list
  surface_configure*: ptr wlr_xdg_surface_configure
  mode*: wlr_xdg_toplevel_decoration_v1_mode

type wlr_xdg_toplevel_decoration_v1_events* = object
  destroy*: wl_signal
  request_mode*: wl_signal

type wlr_xdg_toplevel_decoration_v1* = object
  resource*: ptr wl_resource
  surface*: ptr wlr_xdg_surface
  manager*: ptr wlr_xdg_decoration_manager_v1
  link*: wl_list
  added*: bool
  current_mode*: wlr_xdg_toplevel_decoration_v1_mode
  client_pending_mode*: wlr_xdg_toplevel_decoration_v1_mode
  server_pending_mode*: wlr_xdg_toplevel_decoration_v1_mode
  configure_list*: wl_list
  events*: wlr_xdg_toplevel_decoration_v1_events
  surface_destroy*: wl_listener
  surface_configure*: wl_listener
  surface_ack_configure*: wl_listener
  surface_commit*: wl_listener
  data*: pointer

## wlr_xdg_foreign_registry

const WLR_XDG_FOREIGN_HANDLE_SIZE* = 37

type wlr_xdg_foreign_registry_events* = object
  destroy*: wl_signal

type wlr_xdg_foreign_registry* = object
  exported_surfaces*: wl_list
  display_destroy*: wl_listener
  events*: wlr_xdg_foreign_registry_events

type wlr_xdg_foreign_exported_events* = object
  destroy*: wl_signal

type wlr_xdg_foreign_exported* = object
  link*: wl_list
  registry*: ptr wlr_xdg_foreign_registry
  surface*: ptr wlr_surface
  handle*: array[WLR_XDG_FOREIGN_HANDLE_SIZE, char]
  events*: wlr_xdg_foreign_exported_events

## wlr_xdg_foreign_v1

type wlr_xdg_foreign_v1_ter* = object
  global*: ptr wl_global
  objects*: wl_list

type wlr_xdg_foreign_v1_events* = object
  destroy*: wl_signal

type wlr_xdg_foreign_v1* = object
  exporter*: wlr_xdg_foreign_v1_ter
  importer*: wlr_xdg_foreign_v1_ter
  foreign_registry_destroy*: wl_listener
  display_destroy*: wl_listener
  registry*: ptr wlr_xdg_foreign_registry
  events*: wlr_xdg_foreign_v1_events
  data*: pointer

type wlr_xdg_exported_v1* = object
  base*: wlr_xdg_foreign_exported
  resource*: ptr wl_resource
  xdg_surface_destroy*: wl_listener
  link*: wl_list

type wlr_xdg_imported_v1* = object
  exported*: ptr wlr_xdg_foreign_exported
  exported_destroyed*: wl_listener
  resource*: ptr wl_resource
  link*: wl_list
  children*: wl_list

type wlr_xdg_imported_child_v1* = object
  imported*: ptr wlr_xdg_imported_v1
  surface*: ptr wlr_surface
  link*: wl_list
  xdg_surface_unmap*: wl_listener
  xdg_toplevel_set_parent*: wl_listener

## wlr_xdg_foreign_v2

type wlr_xdg_foreign_v2_ter* = object
  global*: ptr wl_global
  objects*: wl_list

type wlr_xdg_foreign_v2_events* = object
  destroy*: wl_signal

type wlr_xdg_foreign_v2* = object
  exporter*: wlr_xdg_foreign_v2_ter
  importer*: wlr_xdg_foreign_v2_ter
  foreign_registry_destroy*: wl_listener
  display_destroy*: wl_listener
  registry*: ptr wlr_xdg_foreign_registry
  events*: wlr_xdg_foreign_v2_events
  data*: pointer

type wlr_xdg_exported_v2* = object
  base*: wlr_xdg_foreign_exported
  resource*: ptr wl_resource
  xdg_surface_destroy*: wl_listener
  link*: wl_list

type wlr_xdg_imported_v2* = object
  exported*: ptr wlr_xdg_foreign_exported
  exported_destroyed*: wl_listener
  resource*: ptr wl_resource
  link*: wl_list
  children*: wl_list

type wlr_xdg_imported_child_v2* = object
  imported*: ptr wlr_xdg_imported_v2
  surface*: ptr wlr_surface
  link*: wl_list
  xdg_surface_unmap*: wl_listener
  xdg_toplevel_set_parent*: wl_listener

## wlr_xdg_output_v1

type wlr_xdg_output_v1* = object
  manager*: ptr wlr_xdg_output_manager_v1
  resources*: wl_list
  link*: wl_list
  layout_output*: ptr wlr_output_layout_output
  x*, y*: int32
  width*, height*: int32
  destroy*: wl_listener
  description*: wl_listener

type wlr_xdg_output_manager_v1_events* = object
  destroy*: wl_signal

type wlr_xdg_output_manager_v1* = object
  global*: ptr wl_global
  layout*: ptr wlr_output_layout
  outputs*: wl_list
  events*: wlr_xdg_output_manager_v1_events
  display_destroy*: wl_listener
  layout_add*: wl_listener
  layout_change*: wl_listener
  layout_destroy*: wl_listener

## wlr_xdg_shell

# import xdg-shell-protocol

type wlr_xdg_shell_events* = object
  new_surface*: wl_signal
  destroy*: wl_signal

type wlr_xdg_shell* = object
  global*: ptr wl_global
  clients*: wl_list
  popup_grabs*: wl_list
  ping_timeout*: uint32
  display_destroy*: wl_listener
  events*: wlr_xdg_shell_events
  data*: pointer

type wlr_xdg_client* = object
  shell*: ptr wlr_xdg_shell
  resource*: ptr wl_resource
  client*: ptr wl_client
  surfaces*: wl_list
  link*: wl_list
  ping_serial*: uint32
  ping_timer*: ptr wl_event_source

type wlr_xdg_positioner_size* = object
  width*, height*: int32

type wlr_xdg_positioner_offset* = object
  x*, y*: int32

type wlr_xdg_positioner* = object
  anchor_rect*: wlr_box
  anchor*: xdg_positioner_anchor
  gravity*: xdg_positioner_gravity
  constraint_adjustment*: xdg_positioner_constraint_adjustment
  size*: wlr_xdg_positioner_size
  offset*: wlr_xdg_positioner_offset

type wlr_xdg_popup* = object
  base*: ptr wlr_xdg_surface
  link*: wl_list
  resource*: ptr wl_resource
  committed*: bool
  parent*: ptr wlr_surface
  seat*: ptr wlr_seat
  geometry*: wlr_box
  positioner*: wlr_xdg_positioner
  grab_link*: wl_list

type wlr_xdg_popup_grab* = object
  client*: ptr wl_client
  pointer_grab*: wlr_seat_pointer_grab
  keyboard_grab*: wlr_seat_keyboard_grab
  touch_grab*: wlr_seat_touch_grab
  seat*: ptr wlr_seat
  popups*: wl_list
  link*: wl_list
  seat_destroy*: wl_listener

type wlr_xdg_surface_role* = enum
  WLR_XDG_SURFACE_ROLE_NONE,
  WLR_XDG_SURFACE_ROLE_TOPLEVEL,
  WLR_XDG_SURFACE_ROLE_POPUP

type wlr_xdg_toplevel_state* = object
  maximized*, fullscreen*, resizing*, activated*: bool
  tiled*: uint32
  width*, height*: uint32
  max_width*, max_height*: uint32
  min_width*, min_height*: uint32
  fullscreen_output*: ptr wlr_output
  fullscreen_output_destroy*: wl_listener

type wlr_xdg_toplevel_events* = object
  request_maximize*: wl_signal
  request_fullscreen*: wl_signal
  request_minimize*: wl_signal
  request_move*: wl_signal
  request_resize*: wl_signal
  request_show_window_menu*: wl_signal
  set_parent*: wl_signal
  set_title*: wl_signal
  set_app_id*: wl_signal

type wlr_xdg_toplevel* = object
  resource*: ptr wl_resource
  base*: ptr wlr_xdg_surface
  added*: bool
  parent*: ptr wlr_xdg_surface
  parent_unmap*: wl_listener
  client_pending*: wlr_xdg_toplevel_state
  server_pending*: wlr_xdg_toplevel_state
  last_acked*: wlr_xdg_toplevel_state
  current*: wlr_xdg_toplevel_state
  title*: cstring
  app_id*: cstring
  events*: wlr_xdg_toplevel_events

type wlr_xdg_surface_configure* = object
  surface*: ptr wlr_xdg_surface
  link*: wl_list
  serial*: uint32
  toplevel_state*: ptr wlr_xdg_toplevel_state

type wlr_xdg_surface_ano* {.union.} = object
  toplevel*: ptr wlr_xdg_toplevel
  popup*: ptr wlr_xdg_popup

type wlr_xdg_surface_events* = object
  destroy*: wl_signal
  ping_timeout*: wl_signal
  new_popup*: wl_signal
  map*: wl_signal
  unmap*: wl_signal
  configure*: wl_signal
  ack_configure*: wl_signal

type wlr_xdg_surface* = object
  client*: ptr wlr_xdg_client
  resource*: ptr wl_resource
  surface*: ptr wlr_surface
  link*: wl_list
  role*: wlr_xdg_surface_role
  ano_wlr_xdg_shell_5*: wlr_xdg_surface_ano
  popups*: wl_list
  added*, configured*, mapped*: bool
  configure_serial*: uint32
  configure_idle*: ptr wl_event_source
  configure_next_serial*: uint32
  configure_list*: wl_list
  has_next_geometry*: bool
  next_geometry*: wlr_box
  geometry*: wlr_box
  surface_destroy*: wl_listener
  surface_commit*: wl_listener
  events*: wlr_xdg_surface_events
  data*: pointer

type wlr_xdg_toplevel_move_event* = object
  surface*: ptr wlr_xdg_surface
  seat*: ptr wlr_seat_client
  serial*: uint32

type wlr_xdg_toplevel_resize_event* = object
  surface*: ptr wlr_xdg_surface
  seat*: ptr wlr_seat_client
  serial*: uint32
  edges*: uint32

type wlr_xdg_toplevel_set_fullscreen_event* = object
  surface*: ptr wlr_xdg_surface
  fullscreen*: bool
  output*: ptr wlr_output

type wlr_xdg_toplevel_show_window_menu_event* = object
  surface*: ptr wlr_xdg_surface
  seat*: ptr wlr_seat_client
  serial*: uint32
  x*, y*: uint32

{.pop.}
