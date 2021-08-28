{.push dynlib: "libwlroots.so".}

import posix
import wayland

type # FIXME: These are likely all wrong
  udev = object
  udev_monitor = object

## drm

proc create_wlr_drm_backend*(display: ptr WlDisplay; session: ptr WlrSession; dev: ptr WlrDevice; parent: ptr WlrBackend): ptr WlrBackend {.importc: "wlr_drm_backend_create".}

proc isDRM*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_drm".}
proc isDRM*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_drm".}

proc getId*(output: ptr WlrOutput): uint32 {.importc: "wlr_drm_connector_get_id".}

type drmModeModeInfo* = object # FIXME: Previously _drmModeModeInfo

proc addMode*(output: ptr WlrOutput; mode: ptr drmModeModeInfo): ptr WlrOutputMode {.importc: "wlr_drm_connector_add_mode".}

## headless

proc create_wlr_headless_backend*(display: ptr WlDisplay): ptr WlrBackend {.importc: "wlr_headless_backend_create".}
proc create_with_renderer_wlr_headless_backend*(display: ptr WlDisplay; renderer: ptr WlrRenderer): ptr WlrBackend {.importc: "wlr_headless_backend_create_with_renderer".}
proc add_output_wlr_headless*(backend: ptr WlrBackend; width, height: cuint): ptr WlrOutput {.importc: "wlr_headless_add_output".}

proc add_input_device_wlr_headless*(backend: ptr WlrBackend; `type`: WlrInputDevice_type): ptr WlrInputDevice {.importc: "wlr_headless_add_input_device".}
proc isHeadless*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_headless".}
proc isHeadless*(device: ptr WlrInputDevice): bool {.importc: "wlr_input_device_is_headless".}
proc isHeadless*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_headless".}

## interface

type WlrBackend_impl* = object
  start*: proc (backend: ptr WlrBackend): bool
  destroy*: proc (backend: ptr WlrBackend)
  get_renderer*: proc (backend: ptr WlrBackend): ptr WlrRenderer
  get_session*: proc (backend: ptr WlrBackend): ptr WlrSession
  get_presentation_clock*: proc (backend: ptr WlrBackend): ClockId
  get_drm_fd*: proc (backend: ptr WlrBackend): cint
  get_buffer_caps*: proc (backend: ptr WlrBackend): uint32

proc init*(backend: ptr WlrBackend; impl: ptr WlrBackend_impl) {.importc: "wlr_backend_init".}
proc finish*(backend: ptr WlrBackend) {.importc: "wlr_backend_finish".}

## libinput

type libinput_device = object

proc create_libinput_backend*(display: ptr WlDisplay; session: ptr WlrSession): ptr WlrBackend {.importc: "wlr_libinput_backend_create".}
proc get_libinput_device_handle*(dev: ptr WlrInputDevice): ptr libinput_device {.importc: "wlr_libinput_get_device_handle".}

proc isLibinput*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_libinput".}
proc isLibinput*(device: ptr WlrInputDevice): bool {.importc: "wlr_input_device_is_libinput".}

## multi

proc create_wlr_multi_backend*(display: ptr WlDisplay): ptr WlrBackend {.importc: "wlr_multi_backend_create".}

proc add*(multi: ptr WlrBackend; backend: ptr WlrBackend): bool {.importc: "wlr_multi_backend_add".}
proc remove*(multi: ptr WlrBackend; backend: ptr WlrBackend) {.importc: "wlr_multi_backend_remove".}

proc isMulti*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_multi".}
proc isEmpty*(backend: ptr WlrBackend): bool {.importc: "wlr_multi_is_empty".}

proc for_each_backend*(backend: ptr WlrBackend; callback: proc (backend: ptr WlrBackend; data: pointer); data: pointer) {.importc: "wlr_multi_for_each_backend".}

## noop

proc create_wlr_noop_backend*(display: ptr WlDisplay): ptr WlrBackend {.importc: "wlr_noop_backend_create".}
proc addOutput*(backend: ptr WlrBackend): ptr WlrOutput {.importc: "wlr_noop_add_output".}
proc isNoop*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_noop".}
proc isNoop*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_noop".}

## session

type libseat* = object

type WlrDevice_events* = object
  change*: WlSignal
  remove*: WlSignal

type WlrDevice* = object
  fd*: cint
  device_id*: cint
  dev*: Dev
  link*: WlList
  events*: WlrDevice_events

type WlrSession_events* = object
  active*: WlSignal
  add_drm_card*: WlSignal   #  struct wlr_session_add_event
  destroy*: WlSignal

type WlrSession* = object
  active*: bool
  vtnr*: cuint
  seat*: array[256, char]
  udev*: ptr udev
  mon*: ptr udev_monitor
  udev_event*: ptr WlEventSource
  seat_handle*: ptr libseat
  libseat_event*: ptr WlEventSource
  devices*: WlList
  display*: ptr WlDisplay
  display_destroy*: WlListener
  events*: WlrSession_events

type WlrSessionAdd_event* = object
  path*: cstring

proc createWlrSession*(disp: ptr WlDisplay): ptr WlrSession {.importc: "wlr_session_create".}
proc destroy*(session: ptr WlrSession) {.importc: "wlr_session_destroy".}

proc openFile*(session: ptr WlrSession; path: cstring): ptr WlrDevice {.importc: "wlr_session_open_file".}
proc closeFile*(session: ptr WlrSession; device: ptr WlrDevice) {.importc: "wlr_session_close_file".}

proc changeVT*(session: ptr WlrSession; vt: cuint): bool {.importc: "wlr_session_change_vt".}

type ssize_t = cint

proc findGPUs*(session: ptr WlrSession; ret_len: csize_t; ret: ptr ptr WlrDevice): ssize_t {.importc: "wlr_session_find_gpus".}

## wayland

proc create_wlr_wl_backend*(display: ptr WlDisplay; remote: cstring): ptr WlrBackend {.importc: "wlr_wl_backend_create".}
proc getRemoteDisplay*(backend: ptr WlrBackend): ptr WlDisplay {.importc: "wlr_wl_backend_get_remote_display".}
proc create_wlr_wl_output*(backend: ptr WlrBackend): ptr WlrOutput {.importc: "wlr_wl_output_create".}

proc isWayland*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_wl".}
proc isWayland*(device: ptr WlrInputDevice): bool {.importc: "wlr_input_device_is_wl".}
proc isWayland*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_wl".}

proc setTitleWayland*(output: ptr WlrOutput; title: cstring) {.importc: "wlr_wl_output_set_title".}

proc getSurface*(output: ptr WlrOutput): ptr WlSurface {.importc: "wlr_wl_output_get_surface".}
proc getSeat*(dev: ptr WlrInputDevice): ptr WlSeat {.importc: "wlr_wl_input_device_get_seat".}

## x11

proc createWlrX11_backend*(display: ptr WlDisplay; x11_display: cstring): ptr WlrBackend {.importc: "wlr_x11_backend_create".}
proc createWlrX11_output*(backend: ptr WlrBackend): ptr WlrOutput {.importc: "wlr_x11_output_create".}

proc isX11*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_x11".}
proc isX11*(device: ptr WlrInputDevice): bool {.importc: "wlr_input_device_is_x11".}
proc isX11*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_x11".}

proc setTitleX11*(output: ptr WlrOutput; title: cstring) {.importc: "wlr_x11_output_set_title".}

{.pop.}
