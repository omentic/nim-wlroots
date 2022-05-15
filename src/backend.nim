{.push dynlib: "libwlroots.so".}

type INNER_C_STRUCT_backend_22* {.bycopy.} = object
  destroy*: wl_signal
  new_input*: wl_signal
  new_output*: wl_signal

type wlr_backend* {.bycopy.} = object
  impl*: ptr wlr_backend_impl
  events*: INNER_C_STRUCT_backend_22

proc wlr_backend_autocreate*(display: ptr wl_display): ptr wlr_backend {.importc: "wlr_backend_autocreate".}
proc wlr_backend_start*(backend: ptr wlr_backend): bool {.importc: "wlr_backend_start".}
proc wlr_backend_destroy*(backend: ptr wlr_backend) {.importc: "wlr_backend_destroy".}
proc wlr_backend_get_session*(backend: ptr wlr_backend): ptr wlr_session {.importc: "wlr_backend_get_session".}
proc wlr_backend_get_presentation_clock*(backend: ptr wlr_backend): clockid_t {.importc: "wlr_backend_get_presentation_clock".}
proc wlr_backend_get_drm_fd*(backend: ptr wlr_backend): cint {.importc: "wlr_backend_get_drm_fd".}

{.pop.}
