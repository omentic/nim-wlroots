{.push dynlib: "libwlroots.so".}

## drm

discard "forward decl of wlr_drm_backend"
type INNER_C_STRUCT_drm_25* {.bycopy.} = object
  destroy*: wl_signal

type wlr_drm_lease* {.bycopy.} = object
  fd*: cint
  lessee_id*: uint32_t
  backend*: ptr wlr_drm_backend
  events*: INNER_C_STRUCT_drm_25
  data*: pointer

proc wlr_drm_backend_create*(display: ptr wl_display; session: ptr wlr_session; dev: ptr wlr_device; parent: ptr wlr_backend): ptr wlr_backend {.importc: "wlr_drm_backend_create".}
proc wlr_backend_is_drm*(backend: ptr wlr_backend): bool {.importc: "wlr_backend_is_drm".}
proc wlr_output_is_drm*(output: ptr wlr_output): bool {.importc: "wlr_output_is_drm".}
proc wlr_drm_connector_get_id*(output: ptr wlr_output): uint32_t {.importc: "wlr_drm_connector_get_id".}
proc wlr_drm_backend_get_non_master_fd*(backend: ptr wlr_backend): cint {.importc: "wlr_drm_backend_get_non_master_fd".}
proc wlr_drm_create_lease*(outputs: ptr ptr wlr_output; n_outputs: csize_t; lease_fd: ptr cint): ptr wlr_drm_lease {.importc: "wlr_drm_create_lease".}
proc wlr_drm_lease_terminate*(lease: ptr wlr_drm_lease) {.importc: "wlr_drm_lease_terminate".}

type drmModeModeInfo* = _drmModeModeInfo

proc wlr_drm_connector_add_mode*(output: ptr wlr_output; mode: ptr drmModeModeInfo): ptr wlr_output_mode {.importc: "wlr_drm_connector_add_mode".}
proc wlr_drm_connector_get_panel_orientation*(output: ptr wlr_output): wl_output_transform {.importc: "wlr_drm_connector_get_panel_orientation".}

## headless

proc wlr_headless_backend_create*(display: ptr wl_display): ptr wlr_backend {.importc: "wlr_headless_backend_create".}
proc wlr_headless_add_output*(backend: ptr wlr_backend; width: cuint; height: cuint): ptr wlr_output {.importc: "wlr_headless_add_output".}
proc wlr_headless_add_input_device*(backend: ptr wlr_backend; `type`: wlr_input_device_type): ptr wlr_input_device {.importc: "wlr_headless_add_input_device".}
proc wlr_backend_is_headless*(backend: ptr wlr_backend): bool {.importc: "wlr_backend_is_headless".}
proc wlr_input_device_is_headless*(device: ptr wlr_input_device): bool {.importc: "wlr_input_device_is_headless".}
proc wlr_output_is_headless*(output: ptr wlr_output): bool {.importc: "wlr_output_is_headless".}

## interface

type wlr_backend_impl* {.bycopy.} = object
  start*: proc (backend: ptr wlr_backend): bool
  destroy*: proc (backend: ptr wlr_backend)
  get_session*: proc (backend: ptr wlr_backend): ptr wlr_session
  get_presentation_clock*: proc (backend: ptr wlr_backend): clockid_t
  get_drm_fd*: proc (backend: ptr wlr_backend): cint
  get_buffer_caps*: proc (backend: ptr wlr_backend): uint32_t

proc wlr_backend_init*(backend: ptr wlr_backend; impl: ptr wlr_backend_impl) {.importc: "wlr_backend_init".}
proc wlr_backend_finish*(backend: ptr wlr_backend) {.importc: "wlr_backend_finish".}

## libinput

proc wlr_libinput_backend_create*(display: ptr wl_display; session: ptr wlr_session): ptr wlr_backend {.importc: "wlr_libinput_backend_create".}

proc wlr_libinput_get_device_handle*(dev: ptr wlr_input_device): ptr libinput_device {.importc: "wlr_libinput_get_device_handle".}
proc wlr_backend_is_libinput*(backend: ptr wlr_backend): bool {.importc: "wlr_backend_is_libinput".}
proc wlr_input_device_is_libinput*(device: ptr wlr_input_device): bool {.importc: "wlr_input_device_is_libinput".}

## multi

proc wlr_multi_backend_create*(display: ptr wl_display): ptr wlr_backend {.importc: "wlr_multi_backend_create".}
proc wlr_multi_backend_add*(multi: ptr wlr_backend; backend: ptr wlr_backend): bool {.importc: "wlr_multi_backend_add".}
proc wlr_multi_backend_remove*(multi: ptr wlr_backend; backend: ptr wlr_backend) {.importc: "wlr_multi_backend_remove".}
proc wlr_backend_is_multi*(backend: ptr wlr_backend): bool {.importc: "wlr_backend_is_multi".}
proc wlr_multi_is_empty*(backend: ptr wlr_backend): bool {.importc: "wlr_multi_is_empty".}
proc wlr_multi_for_each_backend*(backend: ptr wlr_backend; callback: proc ( backend: ptr wlr_backend; data: pointer); data: pointer) {.importc: "wlr_multi_for_each_backend".}discard "forward decl of libseat"

type INNER_C_STRUCT_session_18* {.bycopy.} = object
  change*: wl_signal
  remove*: wl_signal

type wlr_device* {.bycopy.} = object
  fd*: cint
  device_id*: cint
  dev*: dev_t
  link*: wl_list
  events*: INNER_C_STRUCT_session_18

type INNER_C_STRUCT_session_50* {.bycopy.} = object
  active*: wl_signal
  add_drm_card*: wl_signal
  destroy*: wl_signal

type wlr_session* {.bycopy.} = object
  active*: bool
  vtnr*: cuint
  seat*: array[256, char]
  udev*: ptr udev
  mon*: ptr udev_monitor
  udev_event*: ptr wl_event_source
  seat_handle*: ptr libseat
  libseat_event*: ptr wl_event_source
  devices*: wl_list
  display*: ptr wl_display
  display_destroy*: wl_listener
  events*: INNER_C_STRUCT_session_50

type wlr_session_add_event* {.bycopy.} = object
  path*: cstring

type wlr_device_change_type* = enum
  WLR_DEVICE_HOTPLUG = 1, WLR_DEVICE_LEASE

type wlr_device_hotplug_event* {.bycopy.} = object
  connector_id*: uint32_t
  prop_id*: uint32_t

type INNER_C_UNION_session_73* {.bycopy, union.} = object
  hotplug*: wlr_device_hotplug_event

type wlr_device_change_event* {.bycopy.} = object
  `type`*: wlr_device_change_type
  ano_session_74*: INNER_C_UNION_session_73

proc wlr_session_create*(disp: ptr wl_display): ptr wlr_session {.importc: "wlr_session_create".}
proc wlr_session_destroy*(session: ptr wlr_session) {.importc: "wlr_session_destroy".}
proc wlr_session_open_file*(session: ptr wlr_session; path: cstring): ptr wlr_device {.importc: "wlr_session_open_file".}
proc wlr_session_close_file*(session: ptr wlr_session; device: ptr wlr_device) {.importc: "wlr_session_close_file".}
proc wlr_session_change_vt*(session: ptr wlr_session; vt: cuint): bool {.importc: "wlr_session_change_vt".}
proc wlr_session_find_gpus*(session: ptr wlr_session; ret_len: csize_t; ret: ptr ptr wlr_device): ssize_t {.importc: "wlr_session_find_gpus".}
proc wlr_wl_backend_create*(display: ptr wl_display; remote: cstring): ptr wlr_backend {.importc: "wlr_wl_backend_create".}
proc wlr_wl_backend_get_remote_display*(backend: ptr wlr_backend): ptr wl_display {.importc: "wlr_wl_backend_get_remote_display".}
proc wlr_wl_output_create*(backend: ptr wlr_backend): ptr wlr_output {.importc: "wlr_wl_output_create".}
proc wlr_backend_is_wl*(backend: ptr wlr_backend): bool {.importc: "wlr_backend_is_wl".}
proc wlr_input_device_is_wl*(device: ptr wlr_input_device): bool {.importc: "wlr_input_device_is_wl".}
proc wlr_output_is_wl*(output: ptr wlr_output): bool {.importc: "wlr_output_is_wl".}
proc wlr_wl_output_set_title*(output: ptr wlr_output; title: cstring) {.importc: "wlr_wl_output_set_title".}
proc wlr_wl_output_get_surface*(output: ptr wlr_output): ptr wl_surface {.importc: "wlr_wl_output_get_surface".}
proc wlr_wl_input_device_get_seat*(dev: ptr wlr_input_device): ptr wl_seat {.importc: "wlr_wl_input_device_get_seat".}
proc wlr_x11_backend_create*(display: ptr wl_display; x11_display: cstring): ptr wlr_backend {.importc: "wlr_x11_backend_create".}
proc wlr_x11_output_create*(backend: ptr wlr_backend): ptr wlr_output {.importc: "wlr_x11_output_create".}
proc wlr_backend_is_x11*(backend: ptr wlr_backend): bool {.importc: "wlr_backend_is_x11".}
proc wlr_input_device_is_x11*(device: ptr wlr_input_device): bool {.importc: "wlr_input_device_is_x11".}
proc wlr_output_is_x11*(output: ptr wlr_output): bool {.importc: "wlr_output_is_x11".}
proc wlr_x11_output_set_title*(output: ptr wlr_output; title: cstring) {.importc: "wlr_x11_output_set_title".}
