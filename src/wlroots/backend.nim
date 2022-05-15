{.push dynlib: "libwlroots.so".}

import std/posix
import wayland

## shim TODO

type
  udev = object
  udev_monitor = object
  libseat = object
  ssize_t = object
  WlrDrmBackend = object

## session

type
  WlrSession* {.bycopy.} = object
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

  WlrSession_events* {.bycopy.} = object
    active*: WlSignal
    add_drm_card*: WlSignal
    destroy*: WlSignal

type WlrSessionAddEvent* {.bycopy.} = object
  path*: cstring

type WlrDeviceHotplugEvent* {.bycopy.} = object
  connector_id*: uint32
  prop_id*: uint32

type
  WlrDevice* {.bycopy.} = object
    fd*: cint
    device_id*: cint
    dev*: Dev
    link*: WlList
    events*: WlrDevice_events

  WlrDevice_events* {.bycopy.} = object
    change*: WlSignal
    remove*: WlSignal

type
  WlrDeviceChangeEvent* {.bycopy.} = object
    `type`*: WlrDeviceChangeType
    ano_session_74*: WlrDeviceChangeEvent_ano

  WlrDeviceChangeType* = enum
    WLR_DEVICE_HOTPLUG = 1,
    WLR_DEVICE_LEASE

  WlrDeviceChangeEvent_ano* {.bycopy, union.} = object
    hotplug*: WlrDeviceHotplugEvent

proc createWlrSession*(disp: ptr WlDisplay): ptr WlrSession {.importc: "wlr_session_create".}
proc destroy*(session: ptr WlrSession) {.importc: "wlr_session_destroy".}

proc openFile*(session: ptr WlrSession; path: cstring): ptr WlrDevice {.importc: "wlr_session_open_file".}
proc closeFile*(session: ptr WlrSession; device: ptr WlrDevice) {.importc: "wlr_session_close_file".}

proc changeVT*(session: ptr WlrSession; vt: cuint): bool {.importc: "wlr_session_change_vt".}
proc findGPUs*(session: ptr WlrSession; ret_len: csize_t; ret: ptr ptr WlrDevice): ssize_t {.importc: "wlr_session_find_gpus".}

## backend

type
  WlrBackend* {.bycopy.} = object
    impl*: ptr WlrBackend_impl
    events*: WlrBackend_events

  WlrBackend_impl* {.bycopy.} = object
    start*: proc (backend: ptr WlrBackend): bool
    destroy*: proc (backend: ptr WlrBackend)
    get_session*: proc (backend: ptr WlrBackend): ptr WlrSession
    get_presentation_clock*: proc (backend: ptr WlrBackend): ClockId
    get_drm_fd*: proc (backend: ptr WlrBackend): cint
    get_buffer_caps*: proc (backend: ptr WlrBackend): uint32

  WlrBackend_events* {.bycopy.} = object
    destroy*: WlSignal
    new_input*: WlSignal
    new_output*: WlSignal

proc init*(backend: ptr WlrBackend; impl: ptr WlrBackend_impl) {.importc: "wlr_backend_init".}
proc finish*(backend: ptr WlrBackend) {.importc: "wlr_backend_finish".}

proc autocreateWlrBackend*(display: ptr WlDisplay): ptr WlrBackend {.importc: "wlr_backend_autocreate".}
proc start*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_start".}
proc destroy*(backend: ptr WlrBackend) {.importc: "wlr_backend_destroy".}
proc getSession*(backend: ptr WlrBackend): ptr WlrSession {.importc: "wlr_backend_get_session".}
proc getPresentationClock*(backend: ptr WlrBackend): ClockId {.importc: "wlr_backend_get_presentation_clock".}
proc getDrmFd*(backend: ptr WlrBackend): cint {.importc: "wlr_backend_get_drm_fd".}

## drm

type
  WlrDrmLease* {.bycopy.} = object
    fd*: cint
    lessee_id*: uint32
    backend*: ptr WlrDrmBackend
    events*: WlrDrmLease_events
    data*: pointer

  WlrDrmLease_events* {.bycopy.} = object
    destroy*: WlSignal

{.pop.}
