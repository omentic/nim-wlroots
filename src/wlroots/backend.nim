{.push dynlib: "libwlroots.so".}

import std/posix
import wayland

## shim TODO

type
  udev = object
  udev_monitor = object
  libseat = object
  ssize_t = object
  DrmBackend = object

## session

type
  Session* {.bycopy.} = object
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
    events*: SessionEvents

  SessionEvents* {.bycopy.} = object
    active*: WlSignal
    add_drm_card*: WlSignal
    destroy*: WlSignal

type SessionAddEvent* {.bycopy.} = object
  path*: cstring

type DeviceHotplugEvent* {.bycopy.} = object
  connector_id*: uint32
  prop_id*: uint32

type
  Device* {.bycopy.} = object
    fd*: cint
    device_id*: cint
    dev*: Dev
    link*: WlList
    events*: Device_events

  Device_events* {.bycopy.} = object
    change*: WlSignal
    remove*: WlSignal

type
  DeviceChangeEvent* {.bycopy.} = object
    `type`*: DeviceChangeType
    ano_session_74*: DeviceChangeEvent_ano

  DeviceChangeType* = enum
    WLR_DEVICE_HOTPLUG = 1,
    WLR_DEVICE_LEASE

  DeviceChangeEvent_ano* {.bycopy, union.} = object
    hotplug*: DeviceHotplugEvent

proc createSession*(disp: ptr WlDisplay): ptr Session {.importc: "wlr_session_create".}
proc destroy*(session: ptr Session) {.importc: "wlr_session_destroy".}

proc openFile*(session: ptr Session; path: cstring): ptr Device {.importc: "wlr_session_open_file".}
proc closeFile*(session: ptr Session; device: ptr Device) {.importc: "wlr_session_close_file".}

proc changeVT*(session: ptr Session; vt: cuint): bool {.importc: "wlr_session_change_vt".}
proc findGPUs*(session: ptr Session; ret_len: csize_t; ret: ptr ptr Device): ssize_t {.importc: "wlr_session_find_gpus".}

## backend

type
  Backend* {.bycopy.} = object
    impl*: ptr BackendImpl
    events*: Backend_events

  BackendImpl* {.bycopy.} = object
    start*: proc (backend: ptr Backend): bool
    destroy*: proc (backend: ptr Backend)
    get_session*: proc (backend: ptr Backend): ptr Session
    get_presentation_clock*: proc (backend: ptr Backend): ClockId
    get_drm_fd*: proc (backend: ptr Backend): cint
    get_buffer_caps*: proc (backend: ptr Backend): uint32

  Backend_events* {.bycopy.} = object
    destroy*: WlSignal
    new_input*: WlSignal
    new_output*: WlSignal

proc init*(backend: ptr Backend; impl: ptr BackendImpl) {.importc: "wlr_backend_init".}
proc finish*(backend: ptr Backend) {.importc: "wlr_backend_finish".}

proc autocreateBackend*(display: ptr WlDisplay): ptr Backend {.importc: "wlr_backend_autocreate".}
proc start*(backend: ptr Backend): bool {.importc: "wlr_backend_start".}
proc destroy*(backend: ptr Backend) {.importc: "wlr_backend_destroy".}
proc getSession*(backend: ptr Backend): ptr Session {.importc: "wlr_backend_get_session".}
proc getPresentationClock*(backend: ptr Backend): ClockId {.importc: "wlr_backend_get_presentation_clock".}
proc getDrmFd*(backend: ptr Backend): cint {.importc: "wlr_backend_get_drm_fd".}

## drm

type
  DrmLease* {.bycopy.} = object
    fd*: cint
    lessee_id*: uint32
    backend*: ptr DrmBackend
    events*: DrmLease_events
    data*: pointer

  DrmLease_events* {.bycopy.} = object
    destroy*: WlSignal

{.pop.}
