{.push dynlib: "libwlroots.so".}

import std/posix
import wayland

type WlrBackend_events* {.bycopy.} = object
  destroy*: WlSignal
  new_input*: WlSignal
  new_output*: WlSignal

type WlrBackend* {.bycopy.} = object
  impl*: ptr WlrBackend_impl
  events*: WlrBackend_events

proc autocreateWlrBackend*(display: ptr WlDisplay): ptr WlrBackend {.importc: "wlr_backend_autocreate".}
proc start*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_start".}
proc destroy*(backend: ptr WlrBackend) {.importc: "wlr_backend_destroy".}
proc getSession*(backend: ptr WlrBackend): ptr WlrSession {.importc: "wlr_backend_get_session".}
proc getPresentationClock*(backend: ptr WlrBackend): ClockId {.importc: "wlr_backend_get_presentation_clock".}
proc getDrmFd*(backend: ptr WlrBackend): cint {.importc: "wlr_backend_get_drm_fd".}

{.pop.}
