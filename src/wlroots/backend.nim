{.push dynlib: "libwlroots.so".}

import std/posix
import wayland

## drm

type WlrDrmLease_events* {.bycopy.} = object
  destroy*: WlSignal

type WlrDrmLease* {.bycopy.} = object
  fd*: cint
  lessee_id*: uint32
  backend*: ptr WlrDrmBackend
  events*: WlrDrmLease_events
  data*: pointer

proc createDrmBackend*(display: ptr WlDisplay; session: ptr WlrSession; dev: ptr WlrDevice; parent: ptr WlrBackend): ptr WlrBackend {.importc: "wlr_drm_backend_create".}

proc isDrm*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_drm".}
proc isDrm*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_drm".}

proc getId*(output: ptr WlrOutput): uint32 {.importc: "wlr_drm_connector_get_id".}

proc getNonMasterFd*(backend: ptr WlrBackend): cint {.importc: "wlr_drm_backend_get_non_master_fd".}
proc createWlrDrmlease*(outputs: ptr ptr WlrOutput; n_outputs: csize_t; lease_fd: ptr cint): ptr WlrDrmLease {.importc: "wlr_drm_create_lease".}
proc terminate*(lease: ptr WlrDrmLease) {.importc: "wlr_drm_lease_terminate".}

type drmModeModeInfo* = _drmModeModeInfo

proc addMode*(output: ptr WlrOutput; mode: ptr drmModeModeInfo): ptr WlrOutputMode {.importc: "wlr_drm_connector_add_mode".}
proc getPanelOrientation*(output: ptr WlrOutput): WlOutputTransform {.importc: "wlr_drm_connector_get_panel_orientation".}

## headless

proc createHeadlessBackend*(display: ptr WlDisplay): ptr WlrBackend {.importc: "wlr_headless_backend_create".}
proc addHeadlessOutput*(backend: ptr WlrBackend; width: cuint; height: cuint): ptr WlrOutput {.importc: "wlr_headless_add_output".}
proc addHeadlessInputDevice*(backend: ptr WlrBackend; `type`: WlrInputDeviceType): ptr WlrInputDevice {.importc: "wlr_headless_add_input_device".}

proc isHeadless*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_headless".}
proc isHeadless*(device: ptr WlrInputDevice): bool {.importc: "wlr_input_device_is_headless".}
proc isHeadless*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_headless".}

## interface

type WlrBackend_impl* {.bycopy.} = object
  start*: proc (backend: ptr WlrBackend): bool
  destroy*: proc (backend: ptr WlrBackend)
  get_session*: proc (backend: ptr WlrBackend): ptr WlrSession
  get_presentation_clock*: proc (backend: ptr WlrBackend): ClockId
  get_drm_fd*: proc (backend: ptr WlrBackend): cint
  get_buffer_caps*: proc (backend: ptr WlrBackend): uint32

proc init*(backend: ptr WlrBackend; impl: ptr WlrBackend_impl) {.importc: "wlr_backend_init".}
proc finish*(backend: ptr WlrBackend) {.importc: "wlr_backend_finish".}

## libinput

proc createLibinputBackend*(display: ptr WlDisplay; session: ptr WlrSession): ptr WlrBackend {.importc: "wlr_libinput_backend_create".}
proc getLibinputDeviceHandle*(dev: ptr WlrInputDevice): ptr libinput_device {.importc: "wlr_libinput_get_device_handle".}

proc isLibinput*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_libinput".}
proc isLibinput*(device: ptr WlrInputDevice): bool {.importc: "wlr_input_device_is_libinput".}

## multi

proc createMultiBackend*(display: ptr WlDisplay): ptr WlrBackend {.importc: "wlr_multi_backend_create".}

proc add*(multi: ptr WlrBackend; backend: ptr WlrBackend): bool {.importc: "wlr_multi_backend_add".}
proc remove*(multi: ptr WlrBackend; backend: ptr WlrBackend) {.importc: "wlr_multi_backend_remove".}

proc isMulti*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_multi".}
proc isEmpty*(backend: ptr WlrBackend): bool {.importc: "wlr_multi_is_empty".}

proc forEach*(backend: ptr WlrBackend; callback: proc (backend: ptr WlrBackend; data: pointer); data: pointer) {.importc: "wlr_multi_for_each_backend".}discard "forward decl of libseat"

## session

type WlrDevice_events* {.bycopy.} = object
  change*: WlSignal
  remove*: WlSignal

type WlrDevice* {.bycopy.} = object
  fd*: cint
  device_id*: cint
  dev*: Dev
  link*: WlList
  events*: WlrDeviceevents

type WlrSession_events* {.bycopy.} = object
  active*: WlSignal
  add_drm_card*: WlSignal
  destroy*: WlSignal

type WlrSession* {.bycopy.} = object
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

type WlrSessionAddEvent* {.bycopy.} = object
  path*: cstring

type WlrDeviceChangeType* = enum
  WLR_DEVICE_HOTPLUG = 1, WLR_DEVICE_LEASE

type WlrDeviceHotplugEvent* {.bycopy.} = object
  connector_id*: uint32
  prop_id*: uint32

type WlrDeviceChangeEvent_ano* {.bycopy, union.} = object
  hotplug*: WlrDeviceHotplugEvent

type WlrDeviceChangeEvent* {.bycopy.} = object
  `type`*: WlrDeviceChangeType
  ano_session_74*: WlrDeviceChangeEvent_ano

proc createWlrSession*(disp: ptr WlDisplay): ptr WlrSession {.importc: "wlr_session_create".}
proc destroy*(session: ptr WlrSession) {.importc: "wlr_session_destroy".}

proc openFile*(session: ptr WlrSession; path: cstring): ptr WlrDevice {.importc: "wlr_session_open_file".}
proc closeFile*(session: ptr WlrSession; device: ptr WlrDevice) {.importc: "wlr_session_close_file".}

proc changeVT*(session: ptr WlrSession; vt: cuint): bool {.importc: "wlr_session_change_vt".}

proc findGPUs*(session: ptr WlrSession; ret_len: csize_t; ret: ptr ptr WlrDevice): ssize_t {.importc: "wlr_session_find_gpus".}

## wayland

proc createWaylandBackend*(display: ptr WlDisplay; remote: cstring): ptr WlrBackend {.importc: "wlr_wl_backend_create".}
proc getRemoteDisplay*(backend: ptr WlrBackend): ptr WlDisplay {.importc: "wlr_wl_backend_get_remote_display".}
proc createWaylandOutput*(backend: ptr WlrBackend): ptr WlrOutput {.importc: "wlr_wl_output_create".}

proc isWL*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_wl".}
proc isWL*(device: ptr WlrInputDevice): bool {.importc: "wlr_input_device_is_wl".}
proc isWL*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_wl".}

proc setWaylandTitle*(output: ptr WlrOutput; title: cstring) {.importc: "wlr_wl_output_set_title".}

proc getSurface*(output: ptr WlrOutput): ptr WlSurface {.importc: "wlr_wl_output_get_surface".}
proc getSeat*(dev: ptr WlrInputDevice): ptr WlSeat {.importc: "wlr_wl_input_device_get_seat".}

## x11

proc createX11Backend*(display: ptr WlDisplay; x11_display: cstring): ptr WlrBackend {.importc: "wlr_x11_backend_create".}
proc createX11Output*(backend: ptr WlrBackend): ptr WlrOutput {.importc: "wlr_x11_output_create".}

proc isX11*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_x11".}
proc isX11*(device: ptr WlrInputDevice): bool {.importc: "wlr_input_device_is_x11".}
proc isX11*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_x11".}

proc setX11Title*(output: ptr WlrOutput; title: cstring) {.importc: "wlr_x11_output_set_title".}

{.pop.}
