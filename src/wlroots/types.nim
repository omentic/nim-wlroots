{.push dynlib: "libwlroots.so".}

import posix
import wayland, pixman

## wlr_box

type WlrBox* = object
  x*, y*: cint
  width*, height*: cint

type WlrFbox* = object
  x*, y*: cdouble
  width*, height*: cdouble

## wlr_buffer

type WlrShmAttributes* = object
  fd*: cint
  format*: uint32
  width*, height*, stride*: cint
  offset*: Off

type WlrBuffer_impl* = object
  destroy*: proc (buffer: ptr WlrBuffer)
  get_dmabuf*: proc (buffer: ptr WlrBuffer; attribs: ptr WlrDmabufAttributes): bool
  get_shm*: proc (buffer: ptr WlrBuffer; attribs: ptr WlrShmAttributes): bool
  begin_data_ptr_access*: proc (buffer: ptr WlrBuffer; data: ptr pointer; format: ptr uint32; stride: ptr csize_t): bool
  end_data_ptr_access*: proc (buffer: ptr WlrBuffer)

type WlrBufferCap* = enum
  WLR_BUFFER_CAP_DATA_PTR = 1 shl 0,
  WLR_BUFFER_CAP_DMABUF = 1 shl 1,
  WLR_BUFFER_CAP_SHM = 1 shl 2

type WlrBuffer_events* = object
  destroy*: WlSignal
  release*: WlSignal

type WlrBuffer* = object
  impl*: ptr WlrBuffer_impl
  width*, height*: cint
  dropped*: bool
  n_locks*: csize_t
  accessing_data_ptr*: bool
  events*: WlrBuffer_events

type WlrClientBuffer* = object
  base*: WlrBuffer
  resource*: ptr WlResource
  resource_released*: bool
  texture*: ptr WlrTexture
  resource_destroy*: WlListener
  release*: WlListener

type WlrRenderer* = object

## wlr_compositor

type WlrSubcompositor* = object
  global*: ptr WlGlobal

type WlrCompositor_events* = object
  new_surface*: WlSignal
  destroy*: WlSignal

type WlrCompositor* = object
  global*: ptr WlGlobal
  renderer*: ptr WlrRenderer
  subcompositor*: WlrSubcompositor
  display_destroy*: WlListener
  events*: WlrCompositor_events

## wlr_cursor

type WlrCursorState* = object

type WlrCursor_events* = object
  motion*: WlSignal
  motion_absolute*: WlSignal
  button*: WlSignal
  axis*: WlSignal
  frame*: WlSignal
  swipe_begin*: WlSignal
  swipe_update*: WlSignal
  swipe_end*: WlSignal
  pinch_begin*: WlSignal
  pinch_update*: WlSignal
  pinch_end*: WlSignal
  touch_up*: WlSignal
  touch_down*: WlSignal
  touch_motion*: WlSignal
  touch_cancel*: WlSignal
  tablet_tool_axis*: WlSignal
  tablet_tool_proximity*: WlSignal
  tablet_tool_tip*: WlSignal
  tablet_tool_button*: WlSignal

type WlrCursor* = object
  state*: ptr WlrCursorState
  x*, y*: cdouble
  events*: WlrCursor_events
  data*: pointer

## wlr_data_control

# import wlr_seat

type WlrDataControlManager_v1_events* = object
  destroy*: WlSignal
  new_device*: WlSignal

type WlrDataControlManager_v1* = object
  global*: ptr WlGlobal
  devices*: WlList
  events*: WlrDataControlManager_v1_events
  display_destroy*: WlListener

type WlrDataControlDevice_v1* = object
  resource*: ptr WlResource
  manager*: ptr WlrDataControlManager_v1
  link*: WlList
  seat*: ptr WlrSeat
  selection_offer_resource*: ptr WlResource
  primary_selection_offer_resource*: ptr WlResource
  seat_destroy*: WlListener
  seat_set_selection*: WlListener
  seat_set_primary_selection*: WlListener

## wlr_data_device

# import wlr_seat

let wlr_data_device_pointer_drag_interface*: WlrPointerGrab_interface
let wlr_data_device_keyboard_drag_interface*: WlrKeyboardGrab_interface
let wlr_data_device_touch_drag_interface*: WlrTouchGrab_interface

type WlrDataDeviceManager_events* = object
  destroy*: WlSignal

type WlrDataDeviceManager* = object
  global*: ptr WlGlobal
  data_sources*: WlList
  display_destroy*: WlListener
  events*: WlrDataDeviceManager_events
  data*: pointer

type WlrDataOffer_type* = enum
  WLR_DATA_OFFER_SELECTION,
  WLR_DATA_OFFER_DRAG

type WlrDataOffer* = object
  resource*: ptr WlResource
  source*: ptr WlrDataSource
  `type`*: WlrDataOffer_type
  link*: WlList
  actions*: uint32
  preferred_action*: WlDataDeviceManagerDndAction
  in_ask*: bool
  source_destroy*: WlListener

type WlrDataSource_impl* = object
  send*: proc (source: ptr WlrDataSource; mime_type: cstring; fd: int32)
  accept*: proc (source: ptr WlrDataSource; serial: uint32; mime_type: cstring)
  destroy*: proc (source: ptr WlrDataSource)
  dnd_drop*: proc (source: ptr WlrDataSource)
  dnd_finish*: proc (source: ptr WlrDataSource)
  dnd_action*: proc (source: ptr WlrDataSource; action: WlDataDeviceManagerDndAction)

type WlrDataSource_events* = object
  destroy*: WlSignal

type WlrDataSource* = object
  impl*: ptr WlrDataSource_impl
  mime_types*: WlArray
  actions*: int32
  accepted*: bool
  current_dnd_action*: WlDataDeviceManagerDndAction
  compositor_action*: uint32
  events*: WlrDataSource_events

type WlrDragIcon_events* = object
  map*: WlSignal
  unmap*: WlSignal
  destroy*: WlSignal

type WlrDragIcon* = object
  drag*: ptr WlrDrag
  surface*: ptr WlrSurface
  mapped*: bool
  events*: WlrDragIcon_events
  surface_destroy*: WlListener
  data*: pointer

type WlrDragGrab_type* = enum
  WLR_DRAG_GRAB_KEYBOARD,
  WLR_DRAG_GRAB_KEYBOARD_POINTER,
  WLR_DRAG_GRAB_KEYBOARD_TOUCH

type WlrDrag_events* = object
  focus*: WlSignal
  motion*: WlSignal
  drop*: WlSignal
  destroy*: WlSignal

type WlrDrag* = object
  grab_type*: WlrDragGrab_type
  keyboard_grab*: WlrSeatKeyboardGrab
  pointer_grab*: WlrSeatPointerGrab
  touch_grab*: WlrSeatTouchGrab
  seat*: ptr WlrSeat
  seat_client*: ptr WlrSeatClient
  focus_client*: ptr WlrSeatClient
  icon*: ptr WlrDragIcon
  focus*: ptr WlrSurface
  source*: ptr WlrDataSource
  started*, dropped*, cancelling*: bool
  grab_touch_id*, touch_id*: int32
  events*: WlrDragEvents
  source_destroy*: WlListener
  seat_client_destroy*: WlListener
  icon_destroy*: WlListener
  data*: pointer

type WlrDragMotion_event* = object
  drag*: ptr WlrDrag
  time*: uint32
  sx*, sy*: cdouble

type WlrDragDrop_event* = object
  drag*: ptr WlrDrag
  time*: uint32

## wlr_export_dmabuf_v1

type WlrExportDmabufManager_v1_events* = object
  destroy*: WlSignal

type WlrExportDmabufManager_v1* = object
  global*: ptr WlGlobal
  frames*: WlList
  display_destroy*: WlListener
  events*: WlrExportDmabufManager_v1_events

type WlrExportDmabufFrame_v1* = object
  resource*: ptr WlResource
  manager*: ptr WlrExportDmabufManager_v1
  link*: WlList
  output*: ptr WlrOutput
  cursor_locked*: bool
  output_commit*: WlListener

## wlr_foreign_toplevel_management

# import wlr_output

type WlrForeignToplevelManager_v1_events* = object
  destroy*: WlSignal

type WlrForeignToplevelManager_v1* = object
  event_loop*: ptr WlEventLoop
  global*: ptr WlGlobal
  resources*: WlList
  toplevels*: WlList
  display_destroy*: WlListener
  events*: WlrForeignToplevelManager_v1_events
  data*: pointer

type WlrForeignToplevelHandle_v1_state* = enum
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MAXIMIZED = (1 shl 0),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MINIMIZED = (1 shl 1),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_ACTIVATED = (1 shl 2),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_FULLSCREEN = (1 shl 3)

type WlrForeignToplevelHandle_v1_output* = object
  link*: WlList
  output_destroy*: WlListener
  output*: ptr WlrOutput
  toplevel*: ptr WlrForeignToplevelHandle_v1

type WlrForeignToplevelHandle_v1_events* = object
  request_maximize*: WlSignal
  request_minimize*: WlSignal
  request_activate*: WlSignal
  request_fullscreen*: WlSignal
  request_close*: WlSignal
  set_rectangle*: WlSignal
  destroy*: WlSignal

type WlrForeignToplevelHandle_v1* = object
  manager*: ptr WlrForeignToplevelManager_v1
  resources*: WlList
  link*: WlList
  idle_source*: ptr WlEventSource
  title*: cstring
  app_id*: cstring
  parent*: ptr WlrForeignToplevelHandle_v1
  outputs*: WlList
  state*: uint32
  events*: WlrForeignToplevelHandle_v1_events
  data*: pointer

type WlrForeignToplevelHandle_v1_maximized_event* = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  maximized*: bool

type WlrForeignToplevelHandle_v1_minimized_event* = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  minimized*: bool

type WlrForeignToplevelHandle_v1_activated_event* = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  seat*: ptr WlrSeat

type WlrForeignToplevelHandle_v1_fullscreen_event* = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  fullscreen*: bool
  output*: ptr WlrOutput

type WlrForeignToplevelHandle_v1_set_rectangle_event* = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  surface*: ptr WlrSurface
  x*, y*, width*, height*: int32

## wlr_fullscreen_shell

# import fullscreen-shell-unstable-v1-protocol

type WlrFullscreenShell_v1_events* = object
  destroy*: WlSignal
  present_surface*: WlSignal

type WlrFullscreenShell_v1* = object
  global*: ptr WlGlobal
  events*: WlrFullscreenShell_v1_events
  display_destroy*: WlListener
  data*: pointer

type WlrFullscreenShell_v1_present_surface_event* = object
  client*: ptr WlClient
  surface*: ptr WlrSurface
  `method`*: zwp_fullscreen_shell_v1_present_method
  output*: ptr WlrOutput

## wlr_gamma_control

type WlrGammaControlManager_v1_events* = object
  destroy*: WlSignal

type WlrGammaControlManager_v1* = object
  global*: ptr WlGlobal
  controls*: WlList
  display_destroy*: WlListener
  events*: WlrGammaControlManager_v1_events
  data*: pointer

type WlrGammaControl_v1* = object
  resource*: ptr WlResource
  output*: ptr WlrOutput
  link*: WlList
  table*: ptr uint16
  ramp_size*: csize_t
  output_commit_listener*: WlListener
  output_destroy_listener*: WlListener
  data*: pointer

## wlr_idle_inhibit

type WlrIdleInhibitManager_v1_events* = object
  new_inhibitor*: WlSignal
  destroy*: WlSignal

type WlrIdleInhibitManager_v1* = object
  inhibitors*: WlList
  global*: ptr WlGlobal
  display_destroy*: WlListener
  events*: WlrIdleInhibitManager_v1_events
  data*: pointer

type WlrIdleInhibitor_v1_events* = object
  destroy*: WlSignal

type WlrIdleInhibitor_v1* = object
  surface*: ptr WlrSurface
  resource*: ptr WlResource
  surface_destroy*: WlListener
  link*: WlList
  events*: WlrIdleInhibitor_v1_events
  data*: pointer

## wlr_idle

type WlrIdle_events* = object
  activity_notify*: WlSignal
  destroy*: WlSignal

type WlrIdle* = object
  global*: ptr WlGlobal
  idle_timers*: WlList
  event_loop*: ptr WlEventLoop
  enabled*: bool
  display_destroy*: WlListener
  events*: WlrIdle_events
  data*: pointer

type WlrIdleTimeout_events* = object
  idle*: WlSignal
  resume*: WlSignal
  destroy*: WlSignal

type WlrIdleTimeout* = object
  resource*: ptr WlResource
  link*: WlList
  seat*: ptr WlrSeat
  idle_source*: ptr WlEventSource
  idle_state*: bool
  enabled*: bool
  timeout*: uint32
  events*: WlrIdleTimeout_events
  input_listener*: WlListener
  seat_destroy*: WlListener
  data*: pointer

## wlr_input_device

type WlrButtonState* = enum
  WLR_BUTTON_RELEASED, WLR_BUTTON_PRESSED

type WlrInputDevice_type* = enum
  WLR_INPUT_DEVICE_KEYBOARD,
  WLR_INPUT_DEVICE_POINTER,
  WLR_INPUT_DEVICE_TOUCH,
  WLR_INPUT_DEVICE_TABLET_TOOL,
  WLR_INPUT_DEVICE_TABLET_PAD,
  WLR_INPUT_DEVICE_SWITCH

type WlrInputDevice_impl* = object

type WlrInputDeviceAnoWlrInputDevice_1* {.union.} = object
  device*: pointer #  FIXME: _device
  keyboard*: ptr WlrKeyboard
  pointer*: ptr WlrPointer
  switch_device*: ptr WlrSwitch
  touch*: ptr WlrTouch
  tablet*: ptr WlrTablet
  tablet_pad*: ptr WlrTabletPad

type WlrInputDevice_events* = object
  destroy*: WlSignal

type WlrInputDevice* = object
  impl*: ptr WlrInputDevice_impl
  `type`*: WlrInputDevice_type
  vendor*, product*: cuint
  name*: cstring
  width_mm*, height_mm*: cdouble
  output_name*: cstring
  ano_wlr_input_device_1*: WlrInputDeviceAnoWlrInputDevice_1
  events*: WlrInputDevice_events
  data*: pointer
  link*: WlList

## wlr_input_inhibitor

type WlrInputInhibitManager_events* = object
  activate*: WlSignal
  deactivate*: WlSignal
  destroy*: WlSignal

type WlrInputInhibitManager* = object
  global*: ptr WlGlobal
  active_client*: ptr WlClient
  active_inhibitor*: ptr WlResource
  display_destroy*: WlListener
  events*: WlrInputInhibitManager_events
  data*: pointer

## wlr_input_method

type WlrInputMethod_v2_preedit_string* = object
  text*: cstring
  cursor_begin*: int32
  cursor_end*: int32

type WlrInputMethod_v2_delete_surrounding_text* = object
  before_length*: uint32
  after_length*: uint32

type WlrInputMethod_v2_state* = object
  preedit*: WlrInputMethod_v2_preedit_string
  commit_text*: cstring
  delete*: WlrInputMethod_v2_delete_surrounding_text

type WlrInputMethod_v2_events* = object
  commit*: WlSignal
  grab_keyboard*: WlSignal
  destroy*: WlSignal

type WlrInputMethod_v2* = object
  resource*: ptr WlResource
  seat*: ptr WlrSeat
  seat_client*: ptr WlrSeatClient
  pending*: WlrInputMethod_v2_state
  current*: WlrInputMethod_v2_state
  active*: bool
  client_active*: bool
  current_serial*: uint32
  keyboard_grab*: ptr WlrInputMethodKeyboardGrab_v2
  link*: WlList
  seat_client_destroy*: WlListener
  events*: WlrInputMethod_v2_events

type WlrInputMethodKeyboardGrab_v2_events* = object
  destroy*: WlSignal

type WlrInputMethodKeyboardGrab_v2* = object
  resource*: ptr WlResource
  input_method*: ptr WlrInputMethod_v2
  keyboard*: ptr WlrKeyboard
  keyboard_keymap*: WlListener
  keyboard_repeat_info*: WlListener
  keyboard_destroy*: WlListener
  events*: WlrInputMethodKeyboardGrab_v2_events

type WlrInputMethodManager_v2_events* = object
  input_method*: WlSignal
  destroy*: WlSignal

type WlrInputMethodManager_v2* = object
  global*: ptr WlGlobal
  input_methods*: WlList
  display_destroy*: WlListener
  events*: WlrInputMethodManager_v2_events

## wlr_keyboard_group

type WlrKeyboardGroup_events* = object
  enter*: WlSignal
  leave*: WlSignal

type WlrKeyboardGroup* = object
  keyboard*: WlrKeyboard
  input_device*: ptr WlrInputDevice
  devices*: WlList
  keys*: WlList
  events*: WlrKeyboardGroup_events
  data*: pointer

## wlr_keyboard

const WLR_LED_COUNT* = 3

type WlrKeyboardLed* = enum
  WLR_LED_NUM_LOCK = 1 shl 0,
  WLR_LED_CAPS_LOCK = 1 shl 1,
  WLR_LED_SCROLL_LOCK = 1 shl 2

const WLR_MODIFIER_COUNT* = 8

type WlrKeyboardModifier* = enum
  WLR_MODIFIER_SHIFT = 1 shl 0,
  WLR_MODIFIER_CAPS = 1 shl 1,
  WLR_MODIFIER_CTRL = 1 shl 2,
  WLR_MODIFIER_ALT = 1 shl 3,
  WLR_MODIFIER_MOD2 = 1 shl 4,
  WLR_MODIFIER_MOD3 = 1 shl 5,
  WLR_MODIFIER_LOGO = 1 shl 6,
  WLR_MODIFIER_MOD5 = 1 shl 7

const WLR_KEYBOARD_KEYS_CAP* = 32

type WlrKeyboard_impl* = object

type WlrKeyboardModifiers* = object
  depressed*: xkb_mod_mask_t
  latched*: xkb_mod_mask_t
  locked*: xkb_mod_mask_t
  group*: xkb_mod_mask_t

type WlrKeyboardRepeatInfo* = object
  rate*: int32
  delay*: int32

type WlrKeyboard_events* = object
  key*: WlSignal
  modifiers*: WlSignal
  keymap*: WlSignal
  repeat_info*: WlSignal
  destroy*: WlSignal

type WlrKeyboard* = object
  impl*: ptr WlrKeyboard_impl
  group*: ptr WlrKeyboardGroup
  keymap_string*: cstring
  keymap_size*: csize_t
  keymap*: ptr xkb_keymap
  xkb_state*: ptr xkb_state
  led_indexes*: array[WLR_LED_COUNT, xkb_led_index_t]
  mod_indexes*: array[WLR_MODIFIER_COUNT, xkb_mod_index_t]
  keycodes*: array[WLR_KEYBOARD_KEYS_CAP, uint32]
  num_keycodes*: csize_t
  modifiers*: WlrKeyboardModifiers
  repeat_info*: WlrKeyboardRepeatInfo
  events*: WlrKeyboard_events
  data*: pointer

type WlrEventKeyboardKey* = object
  time_msec*: uint32
  keycode*: uint32
  update_state*: bool
  state*: WlKeyboardKeyState

## wlr_keyboard_shortcuts_inhibit_v1

type WlrKeyboardShortcutsInhibitManager_v1_events* = object
  new_inhibitor*: WlSignal
  destroy*: WlSignal

type WlrKeyboardShortcutsInhibitManager_v1* = object
  inhibitors*: WlList
  global*: ptr WlGlobal
  display_destroy*: WlListener
  events*: WlrKeyboardShortcutsInhibitManager_v1_events
  data*: pointer

type WlrKeyboardShortcutsInhibitor_v1_events* = object
  destroy*: WlSignal

type WlrKeyboardShortcutsInhibitor_v1* = object
  surface*: ptr WlrSurface
  seat*: ptr WlrSeat
  active*: bool
  resource*: ptr WlResource
  surface_destroy*: WlListener
  seat_destroy*: WlListener
  link*: WlList
  events*: WlrKeyboardShortcutsInhibitor_v1_events
  data*: pointer

## wlr_layer_shell

# import wlr-layer-shell-unstable-v1-protocol

type WlrLayerShell_v1_events* = object
  new_surface*: WlSignal
  destroy*: WlSignal

type WlrLayerShell_v1* = object
  global*: ptr WlGlobal
  display_destroy*: WlListener
  events*: WlrLayerShell_v1_events
  data*: pointer

type WlrLayerSurface_v1_state_margin* = object
  top*, right*, bottom*, left*: uint32

type WlrLayerSurface_v1_state* = object
  anchor*: uint32
  exclusive_zone*: int32
  margin*: WlrLayerSurface_v1_state_margin
  keyboard_interactive*: zwlr_layer_surface_v1_keyboard_interactivity
  desired_width*, desired_height*: uint32
  actual_width*, actual_height*: uint32
  layer*: zwlr_layer_shell_v1_layer

type WlrLayerSurface_v1_configure* = object
  link*: WlList
  serial*: uint32
  state*: WlrLayerSurface_v1_state

type WlrLayerSurface_v1_events* = object
  destroy*: WlSignal
  map*: WlSignal
  unmap*: WlSignal
  new_popup*: WlSignal

type WlrLayerSurface_v1* = object
  surface*: ptr WlrSurface
  output*: ptr WlrOutput
  resource*: ptr WlResource
  shell*: ptr WlrLayerShell_v1
  popups*: WlList
  namespace*: cstring
  added*, configured*, mapped*, closed*: bool
  configure_serial*: uint32
  configure_next_serial*: uint32
  configure_list*: WlList
  acked_configure*: ptr WlrLayerSurface_v1_configure
  client_pending*: WlrLayerSurface_v1_state
  server_pending*: WlrLayerSurface_v1_state
  current*: WlrLayerSurface_v1_state
  surface_destroy*: WlListener
  events*: WlrLayerSurface_v1_events
  data*: pointer

## wlr_linux_dmabuf_v1

type WlrDmabuf_v1_buffer* = object
  base*: WlrBuffer
  resource*: ptr WlResource
  attributes*: WlrDmabufAttributes
  release*: WlListener

type WlrLinuxBufferParams_v1* = object
  resource*: ptr WlResource
  linux_dmabuf*: ptr WlrLinuxDmabuf_v1
  attributes*: WlrDmabufAttributes
  has_modifier*: bool

type WlrLinuxDmabuf_v1_events* = object
  destroy*: WlSignal

type WlrLinuxDmabuf_v1* = object
  global*: ptr WlGlobal
  renderer*: ptr WlrRenderer
  events*: WlrLinuxDmabuf_v1_events
  display_destroy*: WlListener
  renderer_destroy*: WlListener

## wlr_list

type WlrList* = object
  capacity*: csize_t
  length*: csize_t
  items*: ptr pointer

## wlr_matrix

## wlr_output_damage

# import wlr_box, wlr_output

const WLR_OUTPUT_DAMAGE_PREVIOUS_LEN* = 2

type WlrOutputDamage_events* = object
  frame*: WlSignal
  destroy*: WlSignal

type WlrOutputDamage* = object
  output*: ptr WlrOutput
  max_rects*: cint
  current*: PixmanRegion32
  previous*: array[WLR_OUTPUT_DAMAGE_PREVIOUS_LEN, PixmanRegion32]
  previous_idx*: csize_t
  pending_buffer_type*: WlrOutputStateBuffer_type
  events*: WlrOutputDamage_events
  output_destroy*: WlListener
  output_mode*: WlListener
  output_needs_frame*: WlListener
  output_damage*: WlListener
  output_frame*: WlListener
  output_precommit*: WlListener
  output_commit*: WlListener

## wlr_output_layout

type WlrOutputLayout_state* = object

type WlrOutputLayout_events* = object
  add*: WlSignal
  change*: WlSignal
  destroy*: WlSignal

type WlrOutputLayout* = object
  outputs*: WlList
  state*: ptr WlrOutputLayoutState
  events*: WlrOutputLayout_events
  data*: pointer

type WlrOutputLayoutOutput_state* = object

type WlrOutputLayoutOutput_events* = object
  destroy*: WlSignal

type WlrOutputLayout_output* = object
  output*: ptr WlrOutput
  x*, y*: cint
  link*: WlList
  state*: ptr WlrOutputLayoutOutput_state
  events*: WlrOutputLayoutOutput_events

type WlrDirection* = enum
  WLR_DIRECTION_UP = 1 shl 0,
  WLR_DIRECTION_DOWN = 1 shl 1,
  WLR_DIRECTION_LEFT = 1 shl 2,
  WLR_DIRECTION_RIGHT = 1 shl 3

## wlr_output_management

type WlrOutputManager_v1_events* = object
  apply*: WlSignal
  test*: WlSignal
  destroy*: WlSignal

type WlrOutputManager_v1* = object
  display*: ptr WlDisplay
  global*: ptr WlGlobal
  resources*: WlList
  heads*: WlList
  serial*: uint32
  current_configuration_dirty*: bool
  events*: WlrOutputManager_v1_events
  display_destroy*: WlListener
  data*: pointer

type WlrOutputHead_v1_state_events* = object
  width*, height*: int32
  refresh*: int32

type WlrOutputHead_v1_state* = object
  output*: ptr WlrOutput
  enabled*: bool
  mode*: ptr WlrOutputMode
  custom_mode*: WlrOutputHead_v1_state_events
  x*, y*: int32
  transform*: WlOutputTransform
  scale*: cfloat

type WlrOutputHead_v1* = object
  state*: WlrOutputHead_v1_state
  manager*: ptr WlrOutputManager_v1
  link*: WlList
  resources*: WlList
  mode_resources*: WlList
  output_destroy*: WlListener

type WlrOutputConfiguration_v1* = object
  heads*: WlList

  manager*: ptr WlrOutputManager_v1
  serial*: uint32
  finalized*: bool
  finished*: bool
  resource*: ptr WlResource

type WlrOutput_configuration_head_v1* = object
  state*: WlrOutputHead_v1_state
  config*: ptr WlrOutputConfiguration_v1
  link*: WlList
  resource*: ptr WlResource
  output_destroy*: WlListener

## wlr_output

type WlrOutput_mode* = object
  width*, height*: int32
  refresh*: int32
  preferred*: bool
  link*: WlList

type WlrOutputCursor_events* = object
  destroy*: WlSignal

type WlrOutputCursor* = object
  output*: ptr WlrOutput
  x*, y*: cdouble
  enabled*: bool
  visible*: bool
  width*, height*: uint32
  hotspot_x*, hotspot_y*: int32
  link*: WlList
  texture*: ptr WlrTexture
  surface*: ptr WlrSurface
  surface_commit*: WlListener
  surface_destroy*: WlListener
  events*: WlrOutputCursor_events

type WlrOutputAdaptiveSyncStatus* = enum
  WLR_OUTPUT_ADAPTIVE_SYNC_DISABLED,
  WLR_OUTPUT_ADAPTIVE_SYNC_ENABLED,
  WLR_OUTPUT_ADAPTIVE_SYNC_UNKNOWN

type WlrOutputStateField* = enum
  WLR_OUTPUT_STATE_BUFFER = 1 shl 0,
  WLR_OUTPUT_STATE_DAMAGE = 1 shl 1,
  WLR_OUTPUT_STATE_MODE = 1 shl 2,
  WLR_OUTPUT_STATE_ENABLED = 1 shl 3,
  WLR_OUTPUT_STATE_SCALE = 1 shl 4,
  WLR_OUTPUT_STATE_TRANSFORM = 1 shl 5,
  WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED = 1 shl 6,
  WLR_OUTPUT_STATE_GAMMA_LUT = 1 shl 7

type WlrOutputStateBuffer_type* = enum
  WLR_OUTPUT_STATE_BUFFER_RENDER,
  WLR_OUTPUT_STATE_BUFFER_SCANOUT

type WlrOutputStateMode_type* = enum
  WLR_OUTPUT_STATE_MODE_FIXED,
  WLR_OUTPUT_STATE_MODE_CUSTOM

type WlrOutputStateCustomMode* = object
  width*, height*: int32
  refresh*: int32

type WlrOutputState* = object
  committed*: uint32
  damage*: PixmanRegion32
  enabled*: bool
  scale*: cfloat
  transform*: WlOutputTransform
  adaptive_sync_enabled*: bool
  buffer_type*: WlrOutputStateBuffer_type
  buffer*: ptr WlrBuffer
  mode_type*: WlrOutputStateMode_type
  mode*: ptr WlrOutputMode
  custom_mode*: WlrOutputStateCustomMode
  gamma_lut*: ptr uint16
  gamma_lut_size*: csize_t

type WlrOutput_impl* = object

type WlrOutput_events* = object
  frame*: WlSignal
  damage*: WlSignal
  needs_frame*: WlSignal
  precommit*: WlSignal
  commit*: WlSignal
  present*: WlSignal
  `bind`*: WlSignal
  enable*: WlSignal
  mode*: WlSignal
  description*: WlSignal
  destroy*: WlSignal

type WlrOutput* = object
  impl*: ptr WlrOutput_impl
  backend*: ptr WlrBackend
  display*: ptr WlDisplay
  global*: ptr WlGlobal
  resources*: WlList
  name*: array[24, char]
  description*: cstring
  make*: array[56, char]
  model*: array[16, char]
  serial*: array[16, char]
  phys_width*, phys_height*: int32
  modes*: WlList
  current_mode*: ptr WlrOutputMode
  width*, height*: int32
  refresh*: int32
  enabled*: bool
  scale*: cfloat
  subpixel*: WlOutputSubpixel
  transform*: WlOutputTransform
  adaptive_sync_status*: WlrOutputAdaptiveSyncStatus
  needs_frame*: bool
  frame_pending*: bool
  transform_matrix*: array[9, cfloat]
  pending*: WlrOutputState
  commit_seq*: uint32
  events*: WlrOutput_events
  idle_frame*: ptr WlEventSource
  idle_done*: ptr WlEventSource
  attach_render_locks*: cint
  cursors*: WlList
  hardware_cursor*: ptr WlrOutputCursor
  cursor_swapchain*: ptr WlrSwapchain
  cursor_front_buffer*: ptr WlrBuffer
  software_cursor_locks*: cint
  swapchain*: ptr WlrSwapchain
  back_buffer*: ptr WlrBuffer
  display_destroy*: WlListener
  data*: pointer

type WlrOutputEventDamage* = object
  output*: ptr WlrOutput
  damage*: ptr PixmanRegion32

type WlrOutputEventPrecommit* = object
  output*: ptr WlrOutput
  `when`*: ptr Timespec

type WlrOutputEventCommit* = object
  output*: ptr WlrOutput
  committed*: uint32
  `when`*: ptr Timespec

type WlrOutputPresentFlag* = enum
  WLR_OUTPUT_PRESENT_VSYNC = 0x1,
  WLR_OUTPUT_PRESENT_HW_CLOCK = 0x2,
  WLR_OUTPUT_PRESENT_HW_COMPLETION = 0x4,
  WLR_OUTPUT_PRESENT_ZERO_COPY = 0x8

type WlrOutputEventPresent* = object
  output*: ptr WlrOutput
  commit_seq*: uint32
  `when`*: ptr Timespec
  seq*: cuint
  refresh*: cint
  flags*: uint32

type WlrOutputEventBind* = object
  output*: ptr WlrOutput
  resource*: ptr WlResource

## wlr_output_power_management_v1

# import wlr-output-power-management-unstable-v1-protocol

type WlrOutputPowerManager_v1_events* = object
  set_mode*: WlSignal
  destroy*: WlSignal

type WlrOutputPowerManager_v1* = object
  global*: ptr WlGlobal
  output_powers*: WlList
  display_destroy*: WlListener
  events*: WlrOutputPowerManager_v1_events
  data*: pointer

type WlrOutputPower_v1* = object
  resource*: ptr WlResource
  output*: ptr WlrOutput
  manager*: ptr WlrOutputPowerManager_v1
  link*: WlList
  output_destroy_listener*: WlListener
  output_commit_listener*: WlListener
  data*: pointer

type WlrOutputPower_v1_set_mode_event* = object
  output*: ptr WlrOutput
  mode*: WlrOutputPower_v1_mode

## wlr_pointer_constraints_v1

# import pointer-constraints-unstable-v1-protocol

type WlrPointerConstraint_v1_type* = enum
  WLR_POINTER_CONSTRAINT_V1_LOCKED,
  WLR_POINTER_CONSTRAINT_V1_CONFINED

type WlrPointerConstraint_v1_state_field* = enum
  WLR_POINTER_CONSTRAINT_V1_STATE_REGION = 1 shl 0,
  WLR_POINTER_CONSTRAINT_V1_STATE_CURSOR_HINT = 1 shl 1

type WlrPointerConstraint_v1_state_cursor_hint* = object
  x*, y*: cdouble

type WlrPointerConstraint_v1_state* = object
  committed*: uint32
  region*: PixmanRegion32
  cursor_hint*: WlrPointerConstraint_v1_state_cursor_hint

type WlrPointerConstraint_v1_events* = object
  set_region*: WlSignal
  destroy*: WlSignal

type WlrPointerConstraint_v1* = object
  pointer_constraints*: ptr WlrPointerConstraints_v1
  resource*: ptr WlResource
  surface*: ptr WlrSurface
  seat*: ptr WlrSeat
  lifetime*: zwp_pointer_constraints_v1_lifetime
  `type`*: WlrPointerConstraint_v1_type
  region*: PixmanRegion32
  current*: WlrPointerConstraint_v1_state
  pending*: WlrPointerConstraint_v1_state
  surface_commit*: WlListener
  surface_destroy*: WlListener
  seat_destroy*: WlListener
  link*: WlList
  events*: WlrPointerConstraint_v1_events
  data*: pointer

type WlrPointerConstraints_v1_events* = object
  new_constraint*: WlSignal

type WlrPointerConstraints_v1* = object
  global*: ptr WlGlobal
  constraints*: WlList
  events*: WlrPointerConstraints_v1_events
  display_destroy*: WlListener
  data*: pointer

## wlr_pointer_gestures_v1

type WlrPointerGestures_v1_events* = object
  destroy*: WlSignal

type WlrPointerGestures_v1* = object
  global*: ptr WlGlobal
  swipes*: WlList
  pinches*: WlList
  display_destroy*: WlListener
  events*: WlrPointerGestures_v1_events
  data*: pointer

## wlr_pointer

type WlrPointer_impl* = object

type WlrPointer_events* = object
  motion*: WlSignal
  motion_absolute*: WlSignal
  button*: WlSignal
  axis*: WlSignal
  frame*: WlSignal
  swipe_begin*: WlSignal
  swipe_update*: WlSignal
  swipe_end*: WlSignal
  pinch_begin*: WlSignal
  pinch_update*: WlSignal
  pinch_end*: WlSignal

type WlrPointer* = object
  impl*: ptr WlrPointer_impl
  events*: WlrPointer_events
  data*: pointer

type WlrEventPointerMotion* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  delta_x*, delta_y*: cdouble
  unaccel_dx*, unaccel_dy*: cdouble

type WlrEventPointerMotionAbsolute* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  x*, y*: cdouble

type WlrEventPointerButton* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  button*: uint32
  state*: WlrButtonState

type WlrAxisSource* = enum
  WLR_AXIS_SOURCE_WHEEL,
  WLR_AXIS_SOURCE_FINGER,
  WLR_AXIS_SOURCE_CONTINUOUS,
  WLR_AXIS_SOURCE_WHEEL_TILT

type WlrAxisOrientation* = enum
  WLR_AXIS_ORIENTATION_VERTICAL,
  WLR_AXIS_ORIENTATION_HORIZONTAL

type WlrEventPointerAxis* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  source*: WlrAxisSource
  orientation*: WlrAxisOrientation
  delta*: cdouble
  delta_discrete*: int32

type WlrEventPointerSwipeBegin* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  fingers*: uint32

type WlrEventPointerSwipeUpdate* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  fingers*: uint32
  dx*, dy*: cdouble

type WlrEventPointerSwipeEnd* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  cancelled*: bool

type WlrEventPointerPinchBegin* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  fingers*: uint32

type WlrEventPointerPinchUpdate* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  fingers*: uint32
  dx*, dy*: cdouble
  scale*: cdouble
  rotation*: cdouble

type WlrEventPointerPinchEnd* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  cancelled*: bool

## wlr_presentation_time

type WlrPresentation_events* = object
  destroy*: WlSignal

type WlrPresentation* = object
  global*: ptr WlGlobal
  feedbacks*: WlList
  clock*: ClockId
  events*: WlrPresentation_events
  display_destroy*: WlListener

type WlrPresentationFeedback* = object
  presentation*: ptr WlrPresentation
  surface*: ptr WlrSurface
  link*: WlList
  resources*: WlList
  committed*: bool
  sampled*: bool
  presented*: bool
  output*: ptr WlrOutput
  output_committed*: bool
  output_commit_seq*: uint32
  surface_commit*: WlListener
  surface_destroy*: WlListener
  output_commit*: WlListener
  output_present*: WlListener
  output_destroy*: WlListener

type WlrPresentation_event* = object
  output*: ptr WlrOutput
  tv_sec*: uint64
  tv_nsec*: uint32
  refresh*: uint32
  seq*: uint64
  flags*: uint32

type WlrBackend* = object

## wlr_primary_selection

type WlrPrimarySelectionSource_impl* = object
  send*: proc (source: ptr WlrPrimarySelectionSource; mime_type: cstring; fd: cint)
  destroy*: proc (source: ptr WlrPrimarySelectionSource)

type WlrPrimarySelectionSource_events* = object
  destroy*: WlSignal

type WlrPrimarySelectionSource* = object
  impl*: ptr WlrPrimarySelectionSource_impl
  mime_types*: WlArray
  events*: WlrPrimarySelectionSource_events
  data*: pointer

## wlr_primary_selection_v1

type WlrPrimarySelection_v1_device_manager_events* = object
  destroy*: WlSignal

type WlrPrimarySelection_v1_device_manager* = object
  global*: ptr WlGlobal
  devices*: WlList
  display_destroy*: WlListener
  events*: WlrPrimarySelection_v1_device_manager_events
  data*: pointer

type WlrPrimarySelection_v1_device* = object
  manager*: ptr WlrPrimarySelection_v1_device_manager
  seat*: ptr WlrSeat
  link*: WlList
  resources*: WlList
  offers*: WlList
  seat_destroy*: WlListener
  seat_focus_change*: WlListener
  seat_set_primary_selection*: WlListener
  data*: pointer

## wlr_region

## wlr_relative_pointer

type WlrRelativePointerManager_v1_events* = object
  destroy*: WlSignal
  new_relative_pointer*: WlSignal

type WlrRelativePointerManager_v1* = object
  global*: ptr WlGlobal
  relative_pointers*: WlList
  events*: WlrRelativePointerManager_v1_events
  display_destroy_listener*: WlListener
  data*: pointer

type WlrRelativePointer_v1_events* = object
  destroy*: WlSignal

type WlrRelativePointer_v1* = object
  resource*: ptr WlResource
  pointer_resource*: ptr WlResource
  seat*: ptr WlrSeat
  link*: WlList
  events*: WlrRelativePointer_v1_events
  seat_destroy*: WlListener
  pointer_destroy*: WlListener

  data*: pointer

## wlr_screencopy_v1

type WlrScreencopyManager_v1_events* = object
  destroy*: WlSignal

type WlrScreencopyManager_v1* = object
  global*: ptr WlGlobal
  frames*: WlList
  display_destroy*: WlListener
  events*: WlrScreencopyManager_v1_events
  data*: pointer

type WlrScreencopy_v1_client* = object
  `ref`*: cint
  manager*: ptr WlrScreencopyManager_v1
  damages*: WlList

type WlrScreencopyFrame_v1* = object
  resource*: ptr WlResource
  client*: ptr WlrScreencopy_v1_client
  link*: WlList
  format*: WlShmFormat
  fourcc*: uint32
  box*: WlrBox
  stride*: cint
  overlay_cursor*: bool
  cursor_locked*: bool
  with_damage*: bool
  shm_buffer*: ptr WlShmBuffer
  dma_buffer*: ptr WlrDmabuf_v1_buffer
  buffer_destroy*: WlListener
  output*: ptr WlrOutput
  output_precommit*: WlListener
  output_commit*: WlListener
  output_destroy*: WlListener
  output_enable*: WlListener
  data*: pointer

## wlr_seat

const WLR_SERIAL_RINGSET_SIZE* = 128

type WlrSerialRange* = object
  min_incl*: uint32
  max_incl*: uint32

type WlrSerialRingset* = object
  data*: array[WLR_SERIAL_RINGSET_SIZE, WlrSerialRange]
  `end`*: cint
  count*: cint

type WlrSeatClients_events* = object
  destroy*: WlSignal

type WlrSeatClient* = object
  client*: ptr WlClient
  seat*: ptr WlrSeat
  link*: WlList
  resources*: WlList
  pointers*: WlList
  keyboards*: WlList
  touches*: WlList
  data_devices*: WlList
  events*: WlrSeatClients_events
  serials*: WlrSerialRingset

type WlrTouchPoint_events* = object
  destroy*: WlSignal

type WlrTouchPoint* = object
  touch_id*: int32
  surface*: ptr WlrSurface
  client*: ptr WlrSeatClient
  focus_surface*: ptr WlrSurface
  focus_client*: ptr WlrSeatClient
  sx*, sy*: cdouble
  surface_destroy*: WlListener
  focus_surface_destroy*: WlListener
  client_destroy*: WlListener
  events*: WlrTouchPoint_events
  link*: WlList

type WlrPointerGrab_interface* = object
  enter*: proc (grab: ptr WlrSeatPointerGrab; surface: ptr WlrSurface; sx, sy: cdouble)
  clear_focus*: proc (grab: ptr WlrSeatPointerGrab)
  motion*: proc (grab: ptr WlrSeatPointerGrab; time_msec: uint32; sx, sy: cdouble)
  button*: proc (grab: ptr WlrSeatPointerGrab; time_msec: uint32; button: uint32; state: WlrButtonState): uint32
  axis*: proc (grab: ptr WlrSeatPointerGrab; time_msec: uint32; orientation: WlrAxisOrientation; value: cdouble; value_discrete: int32; source: WlrAxisSource)
  frame*: proc (grab: ptr WlrSeatPointerGrab)
  cancel*: proc (grab: ptr WlrSeatPointerGrab)

type WlrKeyboardGrab_interface* = object
  enter*: proc (grab: ptr WlrSeatKeyboardGrab; surface: ptr WlrSurface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr WlrKeyboardModifiers)
  clear_focus*: proc (grab: ptr WlrSeatKeyboardGrab)
  key*: proc (grab: ptr WlrSeatKeyboardGrab; time_msec: uint32; key: uint32; state: uint32)
  modifiers*: proc (grab: ptr WlrSeatKeyboardGrab; modifiers: ptr WlrKeyboardModifiers)
  cancel*: proc (grab: ptr WlrSeatKeyboardGrab)

type WlrTouchGrab_interface* = object
  down*: proc (grab: ptr WlrSeatTouchGrab; time_msec: uint32; point: ptr WlrTouchPoint): uint32
  up*: proc (grab: ptr WlrSeatTouchGrab; time_msec: uint32; point: ptr WlrTouchPoint)
  motion*: proc (grab: ptr WlrSeatTouchGrab; time_msec: uint32; point: ptr WlrTouchPoint)
  enter*: proc (grab: ptr WlrSeatTouchGrab; time_msec: uint32; point: ptr WlrTouchPoint)
  cancel*: proc (grab: ptr WlrSeatTouchGrab)

type WlrSeatTouchGrab* = object
  `interface`*: ptr WlrTouchGrab_interface
  seat*: ptr WlrSeat
  data*: pointer

type WlrSeatKeyboardGrab* = object
  `interface`*: ptr WlrKeyboardGrab_interface
  seat*: ptr WlrSeat
  data*: pointer

type WlrSeatPointerGrab* = object
  `interface`*: ptr WlrPointerGrab_interface
  seat*: ptr WlrSeat
  data*: pointer

const WLR_POINTER_BUTTONS_CAP* = 16

type WlrSeatPointerState_events* = object
  focus_change*: WlSignal

type WlrSeatPointerState* = object
  seat*: ptr WlrSeat
  focused_client*: ptr WlrSeatClient
  focused_surface*: ptr WlrSurface
  sx*, sy*: cdouble
  grab*: ptr WlrSeatPointerGrab
  default_grab*: ptr WlrSeatPointerGrab
  buttons*: array[WLR_POINTER_BUTTONS_CAP, uint32]
  button_count*: csize_t
  grab_button*: uint32
  grab_serial*: uint32
  grab_time*: uint32
  surface_destroy*: WlListener
  events*: WlrSeatPointerState_events

type WlrSeatKeyboardState_events* = object
  focus_change*: WlSignal

type WlrSeatKeyboardState* = object
  seat*: ptr WlrSeat
  keyboard*: ptr WlrKeyboard
  focused_client*: ptr WlrSeatClient
  focused_surface*: ptr WlrSurface
  keyboard_destroy*: WlListener
  keyboard_keymap*: WlListener
  keyboard_repeat_info*: WlListener
  surface_destroy*: WlListener
  grab*: ptr WlrSeatKeyboardGrab
  default_grab*: ptr WlrSeatKeyboardGrab
  events*: WlrSeatKeyboardState_events

type WlrSeatTouchState* = object
  seat*: ptr WlrSeat
  touch_points*: WlList
  grab_serial*: uint32
  grab_id*: uint32
  grab*: ptr WlrSeatTouchGrab
  default_grab*: ptr WlrSeatTouchGrab

type WlrSeat_events* = object
  pointer_grab_begin*: WlSignal
  pointer_grab_end*: WlSignal
  keyboard_grab_begin*: WlSignal
  keyboard_grab_end*: WlSignal
  touch_grab_begin*: WlSignal
  touch_grab_end*: WlSignal
  request_set_cursor*: WlSignal
  request_set_selection*: WlSignal
  set_selection*: WlSignal
  request_set_primary_selection*: WlSignal
  set_primary_selection*: WlSignal
  request_start_drag*: WlSignal
  start_drag*: WlSignal
  destroy*: WlSignal

type WlrSeat* = object
  global*: ptr WlGlobal
  display*: ptr WlDisplay
  clients*: WlList
  name*: cstring
  capabilities*: uint32
  accumulated_capabilities*: uint32
  last_event*: Timespec
  selection_source*: ptr WlrDataSource
  selection_serial*: uint32
  selection_offers*: WlList
  primary_selection_source*: ptr WlrPrimarySelectionSource
  primary_selection_serial*: uint32
  drag*: ptr WlrDrag
  drag_source*: ptr WlrDataSource
  drag_serial*: uint32
  drag_offers*: WlList
  pointer_state*: WlrSeatPointerState
  keyboard_state*: WlrSeatKeyboardState
  touch_state*: WlrSeatTouchState
  display_destroy*: WlListener
  selection_source_destroy*: WlListener
  primary_selection_source_destroy*: WlListener
  drag_source_destroy*: WlListener
  events*: WlrSeat_events
  data*: pointer

type WlrSeatPointerRequestSetCursor_event* = object
  seat_client*: ptr WlrSeatClient
  surface*: ptr WlrSurface
  serial*: uint32
  hotspot_x*, hotspot_y*: int32

type WlrSeatRequestSetSelection_event* = object
  source*: ptr WlrDataSource
  serial*: uint32

type WlrSeatRequestSetPrimarySelection_event* = object
  source*: ptr WlrPrimarySelectionSource
  serial*: uint32

type WlrSeatRequestStartDrag_event* = object
  drag*: ptr WlrDrag
  origin*: ptr WlrSurface
  serial*: uint32

type WlrSeatPointerFocusChange_event* = object
  seat*: ptr WlrSeat
  old_surface*, new_surface*: ptr WlrSurface
  sx*, sy*: cdouble

type WlrSeatKeyboardFocusChange_event* = object
  seat*: ptr WlrSeat
  old_surface*, new_surface*: ptr WlrSurface

## wlr_server_decoration

type WlrServerDecorationManager_mode* = enum
  WLR_SERVER_DECORATION_MANAGER_MODE_NONE = 0,
  WLR_SERVER_DECORATION_MANAGER_MODE_CLIENT = 1,
  WLR_SERVER_DECORATION_MANAGER_MODE_SERVER = 2

type WlrServerDecorationManager_events* = object
  new_decoration*: WlSignal
  destroy*: WlSignal

type WlrServerDecorationManager* = object
  global*: ptr WlGlobal
  resources*: WlList
  decorations*: WlList
  default_mode*: uint32
  display_destroy*: WlListener
  events*: WlrServerDecorationManager_events
  data*: pointer

type WlrServerDecoration_events* = object
  destroy*: WlSignal
  mode*: WlSignal

type WlrServerDecoration* = object
  resource*: ptr WlResource
  surface*: ptr WlrSurface
  link*: WlList
  mode*: uint32
  events*: WlrServerDecoration_events
  surface_destroy_listener*: WlListener
  data*: pointer

## wlr_surface

type WlrSurfaceState_field* = enum
  WLR_SURFACE_STATE_BUFFER = 1 shl 0,
  WLR_SURFACE_STATE_SURFACE_DAMAGE = 1 shl 1,
  WLR_SURFACE_STATE_BUFFER_DAMAGE = 1 shl 2,
  WLR_SURFACE_STATE_OPAQUE_REGION = 1 shl 3,
  WLR_SURFACE_STATE_INPUT_REGION = 1 shl 4,
  WLR_SURFACE_STATE_TRANSFORM = 1 shl 5,
  WLR_SURFACE_STATE_SCALE = 1 shl 6,
  WLR_SURFACE_STATE_FRAME_CALLBACK_LIST = 1 shl 7,
  WLR_SURFACE_STATE_VIEWPORT = 1 shl 8

type WlrSurfaceState_viewport* = object
  has_src*, has_dst*: bool
  src*: WlrFbox
  dst_width*, dst_height*: cint

type WlrSurfaceState* = object
  committed*: uint32
  seq*: uint32
  buffer_resource*: ptr WlResource
  dx*, dy*: int32
  surface_damage*,  buffer_damage*: PixmanRegion32
  opaque*, input*: PixmanRegion32
  transform*: WlOutputTransform
  scale*: int32
  frame_callback_list*: WlList
  width*, height*: cint
  buffer_width*, buffer_height*: cint
  viewport*: WlrSurfaceState_viewport
  buffer_destroy*: WlListener
  cached_state_locks*: csize_t
  cached_state_link*: WlList

type WlrSurfaceRole* = object
  name*: cstring
  commit*: proc (surface: ptr WlrSurface)
  precommit*: proc (surface: ptr WlrSurface)

type WlrSurfaceOutput* = object
  surface*: ptr WlrSurface
  output*: ptr WlrOutput
  link*: WlList
  `bind`*: WlListener
  destroy*: WlListener

type WlrSurface_events* = object
  commit*: WlSignal
  new_subsurface*: WlSignal
  destroy*: WlSignal

type WlrSurface* = object
  resource*: ptr WlResource
  renderer*: ptr WlrRenderer
  buffer*: ptr WlrClientBuffer
  sx*, sy*: cint
  buffer_damage*: PixmanRegion32
  opaque_region*: PixmanRegion32
  input_region*: PixmanRegion32
  current*, pending*, previous*: WlrSurfaceState
  cached*: WlList
  role*: ptr WlrSurface_role
  role_data*: pointer
  events*: WlrSurface_events
  subsurfaces_below*: WlList
  subsurfaces_above*: WlList
  subsurfaces_pending_below*: WlList
  subsurfaces_pending_above*: WlList
  current_outputs*: WlList
  renderer_destroy*: WlListener
  data*: pointer

type WlrSubsurface_state* = object
  x*, y*: int32

type WlrSubsurface_events* = object
  destroy*: WlSignal
  map*: WlSignal
  unmap*: WlSignal

type WlrSubsurface* = object
  resource*: ptr WlResource
  surface*: ptr WlrSurface
  parent*: ptr WlrSurface
  current*, pending*: WlrSubsurfaceState
  cached_seq*: uint32
  has_cache*: bool
  synchronized*: bool
  reordered*: bool
  mapped*: bool
  parent_link*: WlList
  parent_pending_link*: WlList
  surface_destroy*: WlListener
  parent_destroy*: WlListener
  events*: WlrSubsurface_events
  data*: pointer

type WlrSurfaceIteratorFunc_t* = proc (surface: ptr WlrSurface; sx, sy: cint; data: pointer)

## wlr_switch

type WlrSwitch_impl* = object

type WlrSwitch_events* = object
  toggle*: WlSignal

type WlrSwitch* = object
  impl*: ptr WlrSwitch_impl
  events*: WlrSwitch_events
  data*: pointer

type WlrSwitch_type* = enum
  WLR_SWITCH_TYPE_LID = 1,
  WLR_SWITCH_TYPE_TABLET_MODE

type WlrSwitch_state* = enum
  WLR_SWITCH_STATE_OFF = 0,
  WLR_SWITCH_STATE_ON,
  WLR_SWITCH_STATE_TOGGLE

type WlrEventSwitchToggle* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  switch_type*: WlrSwitch_type
  switch_state*: WlrSwitch_state

## wlr_tablet_pad

type WlrTabletPad_impl* = object

type WlrTabletPad_events* = object
  button*: WlSignal
  ring*: WlSignal
  strip*: WlSignal
  attach_tablet*: WlSignal

type WlrTabletPad* = object
  impl*: ptr WlrTabletPad_impl

  events*: WlrTabletPad_events
  button_count*: csize_t
  ring_count*: csize_t
  strip_count*: csize_t
  groups*: WlList
  paths*: WlrList
  data*: pointer

type WlrTabletPadGroup* = object
  link*: WlList
  button_count*: csize_t
  buttons*: ptr cuint
  strip_count*: csize_t
  strips*: ptr cuint
  ring_count*: csize_t
  rings*: ptr cuint
  mode_count*: cuint

type WlrEventTabletPadButton* = object
  time_msec*: uint32
  button*: uint32
  state*: WlrButtonState
  mode*: cuint
  group*: cuint

type WlrTabletPadRingSource* = enum
  WLR_TABLET_PAD_RING_SOURCE_UNKNOWN,
  WLR_TABLET_PAD_RING_SOURCE_FINGER

type WlrEventTabletPadRing* = object
  time_msec*: uint32
  source*: WlrTabletPadRingSource
  ring*: uint32
  position*: cdouble
  mode*: cuint

type WlrTabletPadStripSource* = enum
  WLR_TABLET_PAD_STRIP_SOURCE_UNKNOWN,
  WLR_TABLET_PAD_STRIP_SOURCE_FINGER

type WlrEventTabletPadStrip* = object
  time_msec*: uint32
  source*: WlrTabletPadStripSource
  strip*: uint32
  position*: cdouble
  mode*: cuint

## wlr_tablet_tool

type WlrTabletTool_type* = enum
  WLR_TABLET_TOOL_TYPE_PEN = 1,
  WLR_TABLET_TOOL_TYPE_ERASER,
  WLR_TABLET_TOOL_TYPE_BRUSH,
  WLR_TABLET_TOOL_TYPE_PENCIL,
  WLR_TABLET_TOOL_TYPE_AIRBRUSH,
  WLR_TABLET_TOOL_TYPE_MOUSE,
  WLR_TABLET_TOOL_TYPE_LENS,
  WLR_TABLET_TOOL_TYPE_TOTEM

type WlrTabletTool_events* = object
  destroy*: WlSignal

type WlrTabletTool* = object
  `type`*: WlrTabletTool_type
  hardware_serial*: uint64
  hardware_wacom*: uint64
  tilt*: bool
  pressure*: bool
  distance*: bool
  rotation*: bool
  slider*: bool
  wheel*: bool
  events*: WlrTabletTool_events
  data*: pointer

type WlrTablet_impl* = object

type WlrTablet_events* = object
  axis*: WlSignal
  proximity*: WlSignal
  tip*: WlSignal
  button*: WlSignal

type WlrTablet* = object
  impl*: ptr WlrTablet_impl
  events*: WlrTablet_events
  name*: cstring
  paths*: WlrList
  data*: pointer

type WlrTabletToolAxes* = enum
  WLR_TABLET_TOOL_AXIS_X = 1 shl 0,
  WLR_TABLET_TOOL_AXIS_Y = 1 shl 1,
  WLR_TABLET_TOOL_AXIS_DISTANCE = 1 shl 2,
  WLR_TABLET_TOOL_AXIS_PRESSURE = 1 shl 3,
  WLR_TABLET_TOOL_AXIS_TILT_X = 1 shl 4,
  WLR_TABLET_TOOL_AXIS_TILT_Y = 1 shl 5,
  WLR_TABLET_TOOL_AXIS_ROTATION = 1 shl 6,
  WLR_TABLET_TOOL_AXIS_SLIDER = 1 shl 7,
  WLR_TABLET_TOOL_AXIS_WHEEL = 1 shl 8

type WlrEventTabletToolAxis* = object
  device*: ptr WlrInputDevice
  tool*: ptr WlrTabletTool
  time_msec*: uint32
  updated_axes*: uint32
  x*, y*: cdouble
  dx*, dy*: cdouble
  pressure*, distance*: cdouble
  tilt_x*, tilt_y*: cdouble
  rotation*: cdouble
  slider*: cdouble
  wheel_delta*: cdouble

type WlrTabletToolProximityState* = enum
  WLR_TABLET_TOOL_PROXIMITY_OUT,
  WLR_TABLET_TOOL_PROXIMITY_IN

type WlrEventTabletToolProximity* = object
  device*: ptr WlrInputDevice
  tool*: ptr WlrTabletTool
  time_msec*: uint32
  x*, y*: cdouble
  state*: WlrTabletToolProximityState

type WlrTabletToolTip_state* = enum
  WLR_TABLET_TOOL_TIP_UP,
  WLR_TABLET_TOOL_TIP_DOWN

type WlrEventTabletToolTip* = object
  device*: ptr WlrInputDevice
  tool*: ptr WlrTabletTool
  time_msec*: uint32
  x*, y*: cdouble
  state*: WlrTabletToolTip_state

type WlrEventTabletToolButton* = object
  device*: ptr WlrInputDevice
  tool*: ptr WlrTabletTool
  time_msec*: uint32
  button*: uint32
  state*: WlrButtonState

## wlr_tablet_v2

# import tablet-unstable-v2-protocol

const WLR_TABLET_V2_TOOL_BUTTONS_CAP* = 16

type WlrTabletPad_v2_grab_interface* = object

type WlrTabletPad_v2_grab* = object
  `interface`*: ptr WlrTabletPad_v2_grab_interface
  pad*: ptr WlrTablet_v2_tablet_pad
  data*: pointer

type WlrTabletTool_v2_grab_interface* = object

type WlrTabletTool_v2_grab* = object
  `interface`*: ptr WlrTabletTool_v2_grab_interface
  tool*: ptr WlrTablet_v2_tablet_tool
  data*: pointer

type WlrTabletClient_v2* = object
type WlrTabletToolClient_v2* = object
type WlrTabletPadClient_v2* = object

type WlrTabletManager_v2_events* = object
  destroy*: WlSignal

type WlrTabletManager_v2* = object
  wl_global*: ptr WlGlobal
  clients*: WlList
  seats*: WlList
  display_destroy*: WlListener
  events*: WlrTabletManager_v2_events
  data*: pointer

type WlrTablet_v2_tablet* = object
  link*: WlList
  wlr_tablet*: ptr WlrTablet
  wlr_device*: ptr WlrInputDevice
  clients*: WlList
  tool_destroy*: WlListener
  current_client*: ptr WlrTabletClient_v2

type WlrTablet_v2_tablet_tool_events* = object
  set_cursor*: WlSignal

type WlrTablet_v2_tablet_tool* = object
  link*: WlList
  wlr_tool*: ptr WlrTabletTool
  clients*: WlList
  tool_destroy*: WlListener
  current_client*: ptr WlrTabletToolClient_v2
  focused_surface*: ptr WlrSurface
  surface_destroy*: WlListener
  grab*: ptr WlrTabletTool_v2_grab
  default_grab*: WlrTabletTool_v2_grab
  proximity_serial*: uint32
  is_down*: bool
  down_serial*: uint32
  num_buttons*: csize_t
  pressed_buttons*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32]
  pressed_serials*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32]
  events*: WlrTablet_v2_tablet_tool_events

type WlrTablet_v2_tablet_pad_events* = object
  button_feedback*: WlSignal
  strip_feedback*: WlSignal
  ring_feedback*: WlSignal

type WlrTablet_v2_tablet_pad* = object
  link*: WlList
  wlr_pad*: ptr WlrTabletPad
  wlr_device*: ptr WlrInputDevice
  clients*: WlList
  group_count*: csize_t
  groups*: ptr uint32
  pad_destroy*: WlListener
  current_client*: ptr WlrTabletPadClient_v2
  grab*: ptr WlrTabletPad_v2_grab
  default_grab*: WlrTabletPad_v2_grab
  events*: WlrTablet_v2_tablet_pad_events

type WlrTablet_v2_event_cursor* = object
  surface*: ptr WlrSurface
  serial*: uint32
  hotspot_x*, hotspot_y*: int32
  seat_client*: ptr WlrSeatClient

type WlrTablet_v2_event_feedback* = object
  description*: cstring
  index*: csize_t
  serial*: uint32

type WlrTabletTool_v2_grab_interface* = object
  proximity_in*: proc (grab: ptr WlrTabletTool_v2_grab; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface)
  down*: proc (grab: ptr WlrTabletTool_v2_grab)
  up*: proc (grab: ptr WlrTabletTool_v2_grab)
  motion*: proc (grab: ptr WlrTabletTool_v2_grab; x, y: cdouble)
  pressure*: proc (grab: ptr WlrTabletTool_v2_grab; pressure: cdouble)
  distance*: proc (grab: ptr WlrTabletTool_v2_grab; distance: cdouble)
  tilt*: proc (grab: ptr WlrTabletTool_v2_grab; x, y: cdouble)
  rotation*: proc (grab: ptr WlrTabletTool_v2_grab; degrees: cdouble)
  slider*: proc (grab: ptr WlrTabletTool_v2_grab; position: cdouble)
  wheel*: proc (grab: ptr WlrTabletTool_v2_grab; degrees: cdouble; clicks: int32)
  proximity_out*: proc (grab: ptr WlrTabletTool_v2_grab)
  button*: proc (grab: ptr WlrTabletTool_v2_grab; button: uint32; state: zwp_tablet_pad_v2_button_state)
  cancel*: proc (grab: ptr WlrTabletTool_v2_grab)

type WlrTabletPad_v2_grab_interface* = object
  enter*: proc (grab: ptr WlrTabletPad_v2_grab; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface): uint32
  button*: proc (grab: ptr WlrTabletPad_v2_grab; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state)
  strip*: proc (grab: ptr WlrTabletPad_v2_grab; strip: uint32; position: cdouble; finger: bool; time: uint32)
  ring*: proc (grab: ptr WlrTabletPad_v2_grab; ring: uint32; position: cdouble; finger: bool; time: uint32)
  leave*: proc (grab: ptr WlrTabletPad_v2_grab; surface: ptr WlrSurface): uint32
  mode*: proc (grab: ptr WlrTabletPad_v2_grab; group: csize_t; mode: uint32; time: uint32): uint32
  cancel*: proc (grab: ptr WlrTabletPad_v2_grab)

## wlr_text_input_v3

type WlrTextInput_v3_features* = enum
  WLR_TEXT_INPUT_V3_FEATURE_SURROUNDING_TEXT = 1 shl 0,
  WLR_TEXT_INPUT_V3_FEATURE_CONTENT_TYPE = 1 shl 1,
  WLR_TEXT_INPUT_V3_FEATURE_CURSOR_RECTANGLE = 1 shl 2

type WlrTextInput_v3_state_surrounding* = object
  text*: cstring
  cursor*: uint32
  anchor*: uint32

type WlrTextInput_v3_state_content_type* = object
  hint*: uint32
  purpose*: uint32

type WlrTextInput_v3_state_cursor_rectangle* = object
  x*, y*: int32
  width*, height*: int32

type WlrTextInput_v3_state* = object
  surrounding*: WlrTextInput_v3_state_surrounding
  text_change_cause*: uint32
  content_type*: WlrTextInput_v3_state_content_type
  cursor_rectangle*: WlrTextInput_v3_state_cursor_rectangle
  features*: uint32

type WlrTextInput_v3_events* = object
  enable*: WlSignal
  commit*: WlSignal
  disable*: WlSignal
  destroy*: WlSignal

type WlrTextInput_v3* = object
  seat*: ptr WlrSeat
  resource*: ptr WlResource
  focused_surface*: ptr WlrSurface
  pending*: WlrTextInput_v3_state
  current*: WlrTextInput_v3_state
  current_serial*: uint32
  pending_enabled*: bool
  current_enabled*: bool
  active_features*: uint32
  link*: WlList
  surface_destroy*: WlListener
  seat_destroy*: WlListener
  events*: WlrTextInput_v3_events

type WlrTextInputManager_v3_events* = object
  text_input*: WlSignal
  destroy*: WlSignal

type WlrTextInputManager_v3* = object
  global*: ptr WlGlobal
  text_inputs*: WlList
  display_destroy*: WlListener
  events*: WlrTextInputManager_v3_events

## wlr_touch

type WlrTouch_impl* = object

type WlrTouch_events* = object
  down*: WlSignal
  up*: WlSignal
  motion*: WlSignal
  cancel*: WlSignal

type WlrTouch* = object
  impl*: ptr WlrTouch_impl
  events*: WlrTouch_events
  data*: pointer

type WlrEventTouchDown* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  touch_id*: int32
  x*, y*: cdouble

type WlrEventTouchUp* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  touch_id*: int32

type WlrEventTouchMotion* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  touch_id*: int32
  x*, y*: cdouble

type WlrEventTouchCancel* = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  touch_id*: int32

## wlr_viewporter

type WlrViewporter_events* = object
  destroy*: WlSignal

type WlrViewporter* = object
  global*: ptr WlGlobal
  events*: WlrViewporter_events
  display_destroy*: WlListener

type WlrViewport* = object
  resource*: ptr WlResource
  surface*: ptr WlrSurface
  surface_destroy*: WlListener
  surface_commit*: WlListener

## wlr_virtual_keyboard_v1

type WlrVirtualKeyboardManager_v1_events* = object
  new_virtual_keyboard*: WlSignal
  destroy*: WlSignal

type WlrVirtualKeyboardManager_v1* = object
  global*: ptr WlGlobal
  virtual_keyboards*: WlList
  display_destroy*: WlListener
  events*: WlrVirtualKeyboardManager_v1_events

type WlrVirtualKeyboard_v1_events* = object
  destroy*: WlSignal

type WlrVirtualKeyboard_v1* = object
  input_device*: WlrInputDevice
  resource*: ptr WlResource
  seat*: ptr WlrSeat
  has_keymap*: bool
  link*: WlList
  events*: WlrVirtualKeyboard_v1_events

## wlr_virtual_pointer_v1

type WlrVirtualPointerManager_v1_events* = object
  new_virtual_pointer*: WlSignal
  destroy*: WlSignal

type WlrVirtualPointerManager_v1* = object
  global*: ptr WlGlobal
  virtual_pointers*: WlList
  display_destroy*: WlListener
  events*: WlrVirtualPointerManager_v1_events

type WlrVirtualPointer_v1_events* = object
  destroy*: WlSignal

type WlrVirtualPointer_v1* = object
  input_device*: WlrInputDevice
  resource*: ptr WlResource
  axis_event*: array[2, WlrEventPointerAxis]
  axis*: WlPointerAxis
  axis_valid*: array[2, bool]
  link*: WlList
  events*: WlrVirtualPointer_v1_events

type WlrVirtualPointer_v1_new_pointer_event* = object
  new_pointer*: ptr WlrVirtualPointer_v1
  suggested_seat*: ptr WlrSeat
  suggested_output*: ptr WlrOutput

## wlr_xcursor_manager

type WlrXcursorManager_theme* = object
  scale*: cfloat
  theme*: ptr WlrXcursorTheme
  link*: WlList

type WlrXcursorManager* = object
  name*: cstring
  size*: uint32
  scaled_themes*: WlList

## wlr_xdg_activation_v1

type WlrXdgActivationToken_v1* = object
  activation*: ptr WlrXdgActivation_v1
  surface*: ptr WlrSurface
  seat*: ptr WlrSeat
  serial*: uint32
  app_id*: cstring
  link*: WlList
  token*: cstring
  resource*: ptr WlResource
  timeout*: ptr WlEventSource
  seat_destroy*: WlListener
  surface_destroy*: WlListener

type WlrXdgActivation_v1_events* = object
  destroy*: WlSignal
  request_activate*: WlSignal

type WlrXdgActivation_v1* = object
  token_timeout_msec*: uint32
  tokens*: WlList
  events*: WlrXdgActivation_v1_events
  global*: ptr WlGlobal
  display_destroy*: WlListener

type WlrXdgActivation_v1_request_activate_event* = object
  activation*: ptr WlrXdgActivation_v1
  token*: ptr WlrXdgActivationToken_v1
  surface*: ptr WlrSurface

## wlr_xdg_decoration_v1

type WlrXdgToplevelDecoration_v1_mode* = enum
  WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_NONE = 0,
  WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_CLIENT_SIDE = 1,
  WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_SERVER_SIDE = 2

type WlrXdgDecorationManager_v1_events* = object
  new_toplevel_decoration*: WlSignal
  destroy*: WlSignal

type WlrXdgDecorationManager_v1* = object
  global*: ptr WlGlobal
  decorations*: WlList
  display_destroy*: WlListener
  events*: WlrXdgDecorationManager_v1_events
  data*: pointer

type WlrXdgToplevelDecoration_v1_configure* = object
  link*: WlList
  surface_configure*: ptr WlrXdgSurfaceConfigure
  mode*: WlrXdgToplevelDecoration_v1_mode

type WlrXdgToplevelDecoration_v1_events* = object
  destroy*: WlSignal
  request_mode*: WlSignal

type WlrXdgToplevelDecoration_v1* = object
  resource*: ptr WlResource
  surface*: ptr WlrXdgSurface
  manager*: ptr WlrXdgDecorationManager_v1
  link*: WlList
  added*: bool
  current_mode*: WlrXdgToplevelDecoration_v1_mode
  client_pending_mode*: WlrXdgToplevelDecoration_v1_mode
  server_pending_mode*: WlrXdgToplevelDecoration_v1_mode
  configure_list*: WlList
  events*: WlrXdgToplevelDecoration_v1_events
  surface_destroy*: WlListener
  surface_configure*: WlListener
  surface_ack_configure*: WlListener
  surface_commit*: WlListener
  data*: pointer

## wlr_xdg_foreign_registry

const WLR_XDG_FOREIGN_HANDLE_SIZE* = 37

type WlrXdgForeignRegistry_events* = object
  destroy*: WlSignal

type WlrXdgForeignRegistry* = object
  exported_surfaces*: WlList
  display_destroy*: WlListener
  events*: WlrXdgForeignRegistry_events

type WlrXdgForeignExported_events* = object
  destroy*: WlSignal

type WlrXdgForeignExported* = object
  link*: WlList
  registry*: ptr WlrXdgForeignRegistry
  surface*: ptr WlrSurface
  handle*: array[WLR_XDG_FOREIGN_HANDLE_SIZE, char]
  events*: WlrXdgForeignExported_events

## wlr_xdg_foreign_v1

type WlrXdgForeign_v1_ter* = object
  global*: ptr WlGlobal
  objects*: WlList

type WlrXdgForeign_v1_events* = object
  destroy*: WlSignal

type WlrXdgForeign_v1* = object
  exporter*: WlrXdgForeign_v1_ter
  importer*: WlrXdgForeign_v1_ter
  foreign_registry_destroy*: WlListener
  display_destroy*: WlListener
  registry*: ptr WlrXdgForeignRegistry
  events*: WlrXdgForeign_v1_events
  data*: pointer

type WlrXdgExported_v1* = object
  base*: WlrXdgForeignExported
  resource*: ptr WlResource
  xdg_surface_destroy*: WlListener
  link*: WlList

type WlrXdgImported_v1* = object
  exported*: ptr WlrXdgForeignExported
  exported_destroyed*: WlListener
  resource*: ptr WlResource
  link*: WlList
  children*: WlList

type WlrXdgImportedChild_v1* = object
  imported*: ptr WlrXdgImported_v1
  surface*: ptr WlrSurface
  link*: WlList
  xdg_surface_unmap*: WlListener
  xdg_toplevel_set_parent*: WlListener

## wlr_xdg_foreign_v2

type WlrXdgForeign_v2_ter* = object
  global*: ptr WlGlobal
  objects*: WlList

type WlrXdgForeign_v2_events* = object
  destroy*: WlSignal

type WlrXdgForeign_v2* = object
  exporter*: WlrXdgForeign_v2_ter
  importer*: WlrXdgForeign_v2_ter
  foreign_registry_destroy*: WlListener
  display_destroy*: WlListener
  registry*: ptr WlrXdgForeignRegistry
  events*: WlrXdgForeign_v2_events
  data*: pointer

type WlrXdgExported_v2* = object
  base*: WlrXdgForeignExported
  resource*: ptr WlResource
  xdg_surface_destroy*: WlListener
  link*: WlList

type WlrXdgImported_v2* = object
  exported*: ptr WlrXdgForeignExported
  exported_destroyed*: WlListener
  resource*: ptr WlResource
  link*: WlList
  children*: WlList

type WlrXdgImportedChild_v2* = object
  imported*: ptr WlrXdgImported_v2
  surface*: ptr WlrSurface
  link*: WlList
  xdg_surface_unmap*: WlListener
  xdg_toplevel_set_parent*: WlListener

## wlr_xdg_output_v1

type WlrXdgOutput_v1* = object
  manager*: ptr WlrXdgOutputManager_v1
  resources*: WlList
  link*: WlList
  layout_output*: ptr WlrOutputLayoutOutput
  x*, y*: int32
  width*, height*: int32
  destroy*: WlListener
  description*: WlListener

type WlrXdgOutputManager_v1_events* = object
  destroy*: WlSignal

type WlrXdgOutputManager_v1* = object
  global*: ptr WlGlobal
  layout*: ptr WlrOutputLayout
  outputs*: WlList
  events*: WlrXdgOutputManager_v1_events
  display_destroy*: WlListener
  layout_add*: WlListener
  layout_change*: WlListener
  layout_destroy*: WlListener

## wlr_xdg_shell

# import xdg-shell-protocol

type WlrXdgShell_events* = object
  new_surface*: WlSignal
  destroy*: WlSignal

type WlrXdgShell* = object
  global*: ptr WlGlobal
  clients*: WlList
  popup_grabs*: WlList
  ping_timeout*: uint32
  display_destroy*: WlListener
  events*: WlrXdgShell_events
  data*: pointer

type WlrXdgClient* = object
  shell*: ptr WlrXdgShell
  resource*: ptr WlResource
  client*: ptr WlClient
  surfaces*: WlList
  link*: WlList
  ping_serial*: uint32
  ping_timer*: ptr WlEventSource

type WlrXdgPositioner_size* = object
  width*, height*: int32

type WlrXdgPositioner_offset* = object
  x*, y*: int32

type WlrXdgPositioner* = object
  anchor_rect*: WlrBox
  anchor*: xdg_positioner_anchor
  gravity*: xdg_positioner_gravity
  constraint_adjustment*: xdg_positioner_constraint_adjustment
  size*: WlrXdgPositioner_size
  offset*: WlrXdgPositioner_offset

type WlrXdgPopup* = object
  base*: ptr WlrXdgSurface
  link*: WlList
  resource*: ptr WlResource
  committed*: bool
  parent*: ptr WlrSurface
  seat*: ptr WlrSeat
  geometry*: WlrBox
  positioner*: WlrXdgPositioner
  grab_link*: WlList

type WlrXdgPopupGrab* = object
  client*: ptr WlClient
  pointer_grab*: WlrSeatPointerGrab
  keyboard_grab*: WlrSeatKeyboardGrab
  touch_grab*: WlrSeatTouchGrab
  seat*: ptr WlrSeat
  popups*: WlList
  link*: WlList
  seat_destroy*: WlListener

type WlrXdgSurfaceRole* = enum
  WLR_XDG_SURFACE_ROLE_NONE,
  WLR_XDG_SURFACE_ROLE_TOPLEVEL,
  WLR_XDG_SURFACE_ROLE_POPUP

type WlrXdgToplevelState* = object
  maximized*, fullscreen*, resizing*, activated*: bool
  tiled*: uint32
  width*, height*: uint32
  max_width*, max_height*: uint32
  min_width*, min_height*: uint32
  fullscreen_output*: ptr WlrOutput
  fullscreen_output_destroy*: WlListener

type WlrXdgToplevel_events* = object
  request_maximize*: WlSignal
  request_fullscreen*: WlSignal
  request_minimize*: WlSignal
  request_move*: WlSignal
  request_resize*: WlSignal
  request_show_window_menu*: WlSignal
  set_parent*: WlSignal
  set_title*: WlSignal
  set_app_id*: WlSignal

type WlrXdgToplevel* = object
  resource*: ptr WlResource
  base*: ptr WlrXdgSurface
  added*: bool
  parent*: ptr WlrXdgSurface
  parent_unmap*: WlListener
  client_pending*: WlrXdgToplevelState
  server_pending*: WlrXdgToplevelState
  last_acked*: WlrXdgToplevelState
  current*: WlrXdgToplevelState
  title*: cstring
  app_id*: cstring
  events*: WlrXdgToplevel_events

type WlrXdgSurfaceConfigure* = object
  surface*: ptr WlrXdgSurface
  link*: WlList
  serial*: uint32
  toplevel_state*: ptr WlrXdgToplevel_state

type WlrXdgSurfaceAno* {.union.} = object
  toplevel*: ptr WlrXdgToplevel
  popup*: ptr WlrXdgPopup

type WlrXdgSurface_events* = object
  destroy*: WlSignal
  ping_timeout*: WlSignal
  new_popup*: WlSignal
  map*: WlSignal
  unmap*: WlSignal
  configure*: WlSignal
  ack_configure*: WlSignal

type WlrXdgSurface* = object
  client*: ptr WlrXdgClient
  resource*: ptr WlResource
  surface*: ptr WlrSurface
  link*: WlList
  role*: WlrXdgSurfaceRole
  ano_wlr_xdg_shell_5*: WlrXdgSurfaceAno
  popups*: WlList
  added*, configured*, mapped*: bool
  configure_serial*: uint32
  configure_idle*: ptr WlEventSource
  configure_next_serial*: uint32
  configure_list*: WlList
  has_next_geometry*: bool
  next_geometry*: WlrBox
  geometry*: WlrBox
  surface_destroy*: WlListener
  surface_commit*: WlListener
  events*: WlrXdgSurface_events
  data*: pointer

type WlrXdgToplevelMove_event* = object
  surface*: ptr WlrXdgSurface
  seat*: ptr WlrSeatClient
  serial*: uint32

type WlrXdgToplevelResize_event* = object
  surface*: ptr WlrXdgSurface
  seat*: ptr WlrSeatClient
  serial*: uint32
  edges*: uint32

type WlrXdgToplevelSetFullscreen_event* = object
  surface*: ptr WlrXdgSurface
  fullscreen*: bool
  output*: ptr WlrOutput

type WlrXdgToplevelShowWindowMenu_event* = object
  surface*: ptr WlrXdgSurface
  seat*: ptr WlrSeatClient
  serial*: uint32
  x*, y*: uint32

{.pop.}
