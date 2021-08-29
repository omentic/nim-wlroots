{.push dynlib: "libwlroots.so".}

import wayland

## wlr_input_device

type WlrInputDeviceImpl* = object
  destroy*: proc (wlr_device: ptr WlrInputDevice)

proc init*(wlr_device: ptr WlrInputDevice; `type`: WlrInputDevice_type; impl: ptr WlrInputDevice_impl; name: cstring; vendor: cint; product: cint) {.importc: "wlr_input_device_init".}
proc destroy*(dev: ptr WlrInputDevice) {.importc: "wlr_input_device_destroy".}

## wlr_keyboard

type WlrKeyboard_impl* = object
  destroy*: proc (keyboard: ptr WlrKeyboard)
  led_update*: proc (keyboard: ptr WlrKeyboard; leds: uint32)

proc init*(keyboard: ptr WlrKeyboard; impl: ptr WlrKeyboard_impl) {.importc: "wlr_keyboard_init".}
proc destroy*(keyboard: ptr WlrKeyboard) {.importc: "wlr_keyboard_destroy".}
proc notify_key*(keyboard: ptr WlrKeyboard; event: ptr WlrEventKeyboardKey) {.importc: "wlr_keyboard_notify_key".}
proc notify_modifiers*(keyboard: ptr WlrKeyboard; mods_depressed, mods_latched, mods_locked: uint32; group: uint32) {.importc: "wlr_keyboard_notify_modifiers".}

## wlr_output

# const WLR_OUTPUT_STATE_BACKEND_OPTIONAL* = (WLR_OUTPUT_STATE_DAMAGE or WLR_OUTPUT_STATE_SCALE or WLR_OUTPUT_STATE_TRANSFORM or WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED)

type WlrOutputImpl* = object
  set_cursor*: proc (output: ptr WlrOutput; buffer: ptr WlrBuffer; hotspot_x, hotspot_y: cint): bool
  move_cursor*: proc (output: ptr WlrOutput; x, y: cint): bool
  destroy*: proc (output: ptr WlrOutput)
  attach_render*: proc (output: ptr WlrOutput; buffer_age: ptr cint): bool
  rollback_render*: proc (output: ptr WlrOutput)
  test*: proc (output: ptr WlrOutput): bool
  commit*: proc (output: ptr WlrOutput): bool
  get_gamma_size*: proc (output: ptr WlrOutput): csize_t
  export_dmabuf*: proc (output: ptr WlrOutput; attribs: ptr WlrDmabufAttributes): bool
  get_cursor_formats*: proc (output: ptr WlrOutput; buffer_caps: uint32): ptr WlrDrmFormatSet
  get_cursor_size*: proc (output: ptr WlrOutput; width, height: ptr cint)
  get_primary_formats*: proc (output: ptr WlrOutput; buffer_caps: uint32): ptr WlrDrmFormatSet

proc init*(output: ptr WlrOutput; backend: ptr WlrBackend; impl: ptr WlrOutput_impl; display: ptr WlDisplay) {.importc: "wlr_output_init".}

proc update_mode*(output: ptr WlrOutput; mode: ptr WlrOutputMode) {.importc: "wlr_output_update_mode".}
proc update_custom_mode*(output: ptr WlrOutput; width, height: int32; refresh: int32) {.importc: "wlr_output_update_custom_mode".}
proc update_enabled*(output: ptr WlrOutput; enabled: bool) {.importc: "wlr_output_update_enabled".}
proc update_needs_frame*(output: ptr WlrOutput) {.importc: "wlr_output_update_needs_frame".}

proc damage_whole*(output: ptr WlrOutput) {.importc: "wlr_output_damage_whole".}
proc send_frame*(output: ptr WlrOutput) {.importc: "wlr_output_send_frame".}
proc send_present*(output: ptr WlrOutput; event: ptr WlrOutputEventPresent) {.importc: "wlr_output_send_present".}

##  wlr_pointer

type WlrPointerImpl* = object
  destroy*: proc (pointer: ptr WlrPointer)

proc init*(pointer: ptr WlrPointer; impl: ptr WlrPointerImpl) {.importc: "wlr_pointer_init".}
proc destroy*(pointer: ptr WlrPointer) {.importc: "wlr_pointer_destroy".}

## wlr_switch

type WlrSwitchImpl* = object
  destroy*: proc (switch_device: ptr WlrSwitch)

proc init*(switch_device: ptr WlrSwitch; impl: ptr WlrSwitchImpl) {.importc: "wlr_switch_init".}
proc destroy*(switch_device: ptr WlrSwitch) {.importc: "wlr_switch_destroy".}

## wlr_tablet_pad

type WlrTabletPadImpl* = object
  destroy*: proc (pad: ptr WlrTabletPad)

proc init*(pad: ptr WlrTabletPad; impl: ptr WlrTabletPadImpl) {.importc: "wlr_tablet_pad_init".}
proc destroy*(pad: ptr WlrTabletPad) {.importc: "wlr_tablet_pad_destroy".}

## wlr_tablet_tool

type WlrTabletImpl* = object
  destroy*: proc (tablet: ptr WlrTablet)

proc init*(tablet: ptr WlrTablet; impl: ptr WlrTabletImpl) {.importc: "wlr_tablet_init".}
proc destroy*(tablet: ptr WlrTablet) {.importc: "wlr_tablet_destroy".}

## wlr_touch

type WlrTouchImpl* = object
  destroy*: proc (touch: ptr WlrTouch)

proc init*(touch: ptr WlrTouch; impl: ptr WlrTouchImpl) {.importc: "wlr_touch_init".}
proc destroy*(touch: ptr WlrTouch) {.importc: "wlr_touch_destroy".}

{.pop.}
