{.push dynlib: "libwlroots.so".} # 0.15.1



## wlr_input_device

type wlr_input_device_impl* {.bycopy.} = object
  destroy*: proc (wlr_device: ptr wlr_input_device)

proc wlr_input_device_init*(wlr_device: ptr wlr_input_device; `type`: wlr_input_device_type; impl: ptr wlr_input_device_impl; name: cstring; vendor: cint; product: cint) {.importc: "wlr_input_device_init".}
proc wlr_input_device_destroy*(dev: ptr wlr_input_device) {.importc: "wlr_input_device_destroy".}

## wlr_keyboard

type wlr_keyboard_impl* {.bycopy.} = object
  destroy*: proc (keyboard: ptr wlr_keyboard)
  led_update*: proc (keyboard: ptr wlr_keyboard; leds: uint32_t)

proc wlr_keyboard_init*(keyboard: ptr wlr_keyboard; impl: ptr wlr_keyboard_impl) {.importc: "wlr_keyboard_init".}
proc wlr_keyboard_destroy*(keyboard: ptr wlr_keyboard) {.importc: "wlr_keyboard_destroy".}
proc wlr_keyboard_notify_key*(keyboard: ptr wlr_keyboard; event: ptr wlr_event_keyboard_key) {.importc: "wlr_keyboard_notify_key".}
proc wlr_keyboard_notify_modifiers*(keyboard: ptr wlr_keyboard; mods_depressed: uint32_t; mods_latched: uint32_t; mods_locked: uint32_t; group: uint32_t) {.importc: "wlr_keyboard_notify_modifiers".}

## wlr_output

const WLR_OUTPUT_STATE_BACKEND_OPTIONAL* = (WLR_OUTPUT_STATE_DAMAGE or
    WLR_OUTPUT_STATE_SCALE or WLR_OUTPUT_STATE_TRANSFORM or
    WLR_OUTPUT_STATE_RENDER_FORMAT or WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED)

type wlr_output_impl* {.bycopy.} = object
  set_cursor*: proc (output: ptr wlr_output; buffer: ptr wlr_buffer; hotspot_x: cint; hotspot_y: cint): bool
  move_cursor*: proc (output: ptr wlr_output; x: cint; y: cint): bool
  destroy*: proc (output: ptr wlr_output)
  test*: proc (output: ptr wlr_output): bool
  commit*: proc (output: ptr wlr_output): bool
  get_gamma_size*: proc (output: ptr wlr_output): csize_t
  get_cursor_formats*: proc (output: ptr wlr_output; buffer_caps: uint32_t): ptr wlr_drm_format_set
  get_cursor_size*: proc (output: ptr wlr_output; width: ptr cint; height: ptr cint)
  get_primary_formats*: proc (output: ptr wlr_output; buffer_caps: uint32_t): ptr wlr_drm_format_set

proc wlr_output_init*(output: ptr wlr_output; backend: ptr wlr_backend; impl: ptr wlr_output_impl; display: ptr wl_display) {.importc: "wlr_output_init".}
proc wlr_output_update_mode*(output: ptr wlr_output; mode: ptr wlr_output_mode) {.importc: "wlr_output_update_mode".}
proc wlr_output_update_custom_mode*(output: ptr wlr_output; width: int32_t; height: int32_t; refresh: int32_t) {.importc: "wlr_output_update_custom_mode".}
proc wlr_output_update_enabled*(output: ptr wlr_output; enabled: bool) {.importc: "wlr_output_update_enabled".}
proc wlr_output_update_needs_frame*(output: ptr wlr_output) {.importc: "wlr_output_update_needs_frame".}
proc wlr_output_damage_whole*(output: ptr wlr_output) {.importc: "wlr_output_damage_whole".}
proc wlr_output_send_frame*(output: ptr wlr_output) {.importc: "wlr_output_send_frame".}
proc wlr_output_send_present*(output: ptr wlr_output; event: ptr wlr_output_event_present) {.importc: "wlr_output_send_present".}

## wlr_pointer

type wlr_pointer_impl* {.bycopy.} = object
  destroy*: proc (pointer: ptr wlr_pointer)

proc wlr_pointer_init*(pointer: ptr wlr_pointer; impl: ptr wlr_pointer_impl) {.importc: "wlr_pointer_init".}
proc wlr_pointer_destroy*(pointer: ptr wlr_pointer) {.importc: "wlr_pointer_destroy".}

## wlr_switch

type wlr_switch_impl* {.bycopy.} = object
  destroy*: proc (switch_device: ptr wlr_switch)

proc wlr_switch_init*(switch_device: ptr wlr_switch; impl: ptr wlr_switch_impl) {.importc: "wlr_switch_init".}
proc wlr_switch_destroy*(switch_device: ptr wlr_switch) {.importc: "wlr_switch_destroy".}

## wlr_tablet_pad

type wlr_tablet_pad_impl* {.bycopy.} = object
  destroy*: proc (pad: ptr wlr_tablet_pad)

proc wlr_tablet_pad_init*(pad: ptr wlr_tablet_pad; impl: ptr wlr_tablet_pad_impl) {.importc: "wlr_tablet_pad_init".}
proc wlr_tablet_pad_destroy*(pad: ptr wlr_tablet_pad) {.importc: "wlr_tablet_pad_destroy".}

## wlr_tablet_tool

type wlr_tablet_impl* {.bycopy.} = object
  destroy*: proc (tablet: ptr wlr_tablet)

proc wlr_tablet_init*(tablet: ptr wlr_tablet; impl: ptr wlr_tablet_impl) {.importc: "wlr_tablet_init".}
proc wlr_tablet_destroy*(tablet: ptr wlr_tablet) {.importc: "wlr_tablet_destroy".}

## wlr_touch

type wlr_touch_impl* {.bycopy.} = object
  destroy*: proc (touch: ptr wlr_touch)

proc wlr_touch_init*(touch: ptr wlr_touch; impl: ptr wlr_touch_impl) {.importc: "wlr_touch_init".}
proc wlr_touch_destroy*(touch: ptr wlr_touch) {.importc: "wlr_touch_destroy".}

{.pop.}
