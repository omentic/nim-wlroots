{.push dynlib: "libwlroots.so".} # 0.15.1

import wayland

## wlr_input_device

type WlrInputDevice_impl* {.bycopy.} = object
  destroy*: proc (wlr_device: ptr WlrInputDevice)

proc init*(wlr_device: ptr WlrInputDevice; `type`: WlrInputDevice_type; impl: ptr WlrInputDevice_impl; name: cstring; vendor: cint; product: cint) {.importc: "wlr_input_device_init".}
proc destroy*(dev: ptr WlrInputDevice) {.importc: "wlr_input_device_destroy".}

## wlr_keyboard

type WlrKeyboard_impl* {.bycopy.} = object
  destroy*: proc (keyboard: ptr WlrKeyboard)
  led_update*: proc (keyboard: ptr WlrKeyboard; leds: uint32)

proc init*(keyboard: ptr WlrKeyboard; impl: ptr WlrKeyboard_impl) {.importc: "wlr_keyboard_init".}
proc destroy*(keyboard: ptr WlrKeyboard) {.importc: "wlr_keyboard_destroy".}
proc notifyKey*(keyboard: ptr WlrKeyboard; event: ptr WlrEventKeyboardKey) {.importc: "wlr_keyboard_notify_key".}
proc notifyModifiers*(keyboard: ptr WlrKeyboard; mods_depressed: uint32; mods_latched: uint32; mods_locked: uint32; group: uint32) {.importc: "wlr_keyboard_notify_modifiers".}

## wlr_output

const WLR_OUTPUT_STATE_BACKEND_OPTIONAL* = (WLR_OUTPUT_STATE_DAMAGE or WLR_OUTPUT_STATE_SCALE or WLR_OUTPUT_STATE_TRANSFORM or WLR_OUTPUT_STATE_RENDER_FORMAT or WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED)

type WlrOutput_impl* {.bycopy.} = object
  set_cursor*: proc (output: ptr WlrOutput; buffer: ptr wlr_buffer; hotspot_x: cint; hotspot_y: cint): bool
  move_cursor*: proc (output: ptr WlrOutput; x: cint; y: cint): bool
  destroy*: proc (output: ptr WlrOutput)
  test*: proc (output: ptr WlrOutput): bool
  commit*: proc (output: ptr WlrOutput): bool
  get_gamma_size*: proc (output: ptr WlrOutput): csize_t
  get_cursor_formats*: proc (output: ptr WlrOutput; buffer_caps: uint32): ptr WlrDrmFormatSet
  get_cursor_size*: proc (output: ptr WlrOutput; width: ptr cint; height: ptr cint)
  get_primary_formats*: proc (output: ptr WlrOutput; buffer_caps: uint32): ptr WlrDrmFormatSet

proc init*(output: ptr WlrOutput; backend: ptr WlrBackend; impl: ptr WlrOutput_impl; display: ptr WlDisplay) {.importc: "wlr_output_init".}

proc updateMode*(output: ptr WlrOutput; mode: ptr WlrOutputMode) {.importc: "wlr_output_update_mode".}
proc updateCustomMode*(output: ptr WlrOutput; width: int32; height: int32; refresh: int32) {.importc: "wlr_output_update_custom_mode".}
proc updateEnabled*(output: ptr WlrOutput; enabled: bool) {.importc: "wlr_output_update_enabled".}
proc updateNeedsFrame*(output: ptr WlrOutput) {.importc: "wlr_output_update_needs_frame".}

proc damageWhole*(output: ptr WlrOutput) {.importc: "wlr_output_damage_whole".}
proc sendFrame*(output: ptr WlrOutput) {.importc: "wlr_output_send_frame".}
proc sendPresent*(output: ptr WlrOutput; event: ptr WlrOutputEventPresent) {.importc: "wlr_output_send_present".}

## wlr_pointer

type WlrPointer_impl* {.bycopy.} = object
  destroy*: proc (pointer: ptr WlrPointer)

proc init*(pointer: ptr WlrPointer; impl: ptr WlrPointer_impl) {.importc: "wlr_pointer_init".}
proc destroy*(pointer: ptr WlrPointer) {.importc: "wlr_pointer_destroy".}

## wlr_switch

type WlrSwitch_impl* {.bycopy.} = object
  destroy*: proc (switch_device: ptr WlrSwitch)

proc init*(switch_device: ptr WlrSwitch; impl: ptr WlrSwitch_impl) {.importc: "wlr_switch_init".}
proc destroy*(switch_device: ptr WlrSwitch) {.importc: "wlr_switch_destroy".}

## wlr_tablet_pad

type WlrTabletPad_impl* {.bycopy.} = object
  destroy*: proc (pad: ptr WlrTabletPad)

proc init*(pad: ptr WlrTabletPad; impl: ptr WlrTabletPad_impl) {.importc: "wlr_tablet_pad_init".}
proc destroy*(pad: ptr WlrTabletPad) {.importc: "wlr_tablet_pad_destroy".}

## wlr_tablet_tool

type WlrTablet_impl* {.bycopy.} = object
  destroy*: proc (tablet: ptr WlrTablet)

proc init*(tablet: ptr WlrTablet; impl: ptr WlrTablet_impl) {.importc: "wlr_tablet_init".}
proc destroy*(tablet: ptr WlrTablet) {.importc: "wlr_tablet_destroy".}

## wlr_touch

type WlrTouch_impl* {.bycopy.} = object
  destroy*: proc (touch: ptr WlrTouch)

proc init*(touch: ptr WlrTouch; impl: ptr WlrTouch_impl) {.importc: "wlr_touch_init".}
proc destroy*(touch: ptr WlrTouch) {.importc: "wlr_touch_destroy".}

{.pop.}
