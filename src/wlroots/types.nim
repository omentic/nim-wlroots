{.push dynlib: "libwlroots.so".}

import std/posix
import wayland, pixman, xkb, xdg, wlroots/[backend, render, util, xcursor]

## XXX: wlr_box?

## shim TODO

type
  WlrSwapchain = object
  WlrOutputLayout_state = object
  WlrOutputLayoutOutput_state = object
  WlrCursorState = object
  WlrLinuxDmabufFeedback_v1_compiled = object
  WlrTabletClient_v2 = object
  WlrTabletToolClient_v2 = object
  WlrTabletPadClient_v2 = object
  zwp_tablet_pad_v2_button_state = object
  zwlr_output_power_v1_mode = object
  zwp_fullscreen_shell_v1_present_method = object
  zwlr_layer_surface_v1_keyboard_interactivity = object
  zwlr_layer_shell_v1_layer = object
  zwp_pointer_constraints_v1_lifetime = object
  rmModeModeInfo = object
  libinput_device = object

## wlr_surface

type
  WlrSurface* {.bycopy.} = object
    resource*: ptr WlResource
    renderer*: ptr WlrRenderer
    buffer*: ptr WlrClientBuffer
    sx*, sy*: cint
    buffer_damage*: PixmanRegion32
    external_damage*: PixmanRegion32
    opaque_region*: PixmanRegion32
    input_region*: PixmanRegion32
    current*: WlrSurfaceState
    pending*: WlrSurfaceState
    cached*: WlList
    role*: ptr WlrSurface_role
    role_data*: pointer
    events*: WlrSurface_events
    current_outputs*: WlList
    addons*: WlrAddonSet
    data*: pointer
    renderer_destroy*: WlListener
    previous*: WlrSurface_previous

  WlrSurfaceState* {.bycopy.} = object
    committed*: uint32
    seq*: uint32
    buffer*: ptr WlrBuffer
    dx*, dy*: int32
    surface_damage*: PixmanRegion32
    buffer_damage*: PixmanRegion32
    opaque*: PixmanRegion32
    input*: PixmanRegion32
    transform*: WlOutputTransform
    scale*: int32
    frame_callback_list*: WlList
    width*, height*: cint
    buffer_width*, buffer_height*: cint
    subsurfaces_below*: WlList
    subsurfaces_above*: WlList
    viewport*: WlrSurfaceState_viewport
    cached_state_locks*: csize_t
    cached_state_link*: WlList

  WlrSurfaceState_viewport* {.bycopy.} = object
    has_src*: bool
    has_dst*: bool
    src*: WlrFbox
    dst_width*, dst_height*: cint

  WlrSurface_role* {.bycopy.} = object
    name*: cstring
    commit*: proc (surface: ptr WlrSurface)
    precommit*: proc (surface: ptr WlrSurface)

  WlrSurface_events* {.bycopy.} = object
    commit*: WlSignal
    new_subsurface*: WlSignal
    destroy*: WlSignal

  WlrSurface_previous* {.bycopy.} = object
    scale*: int32
    transform*: WlOutputTransform
    width*, height*: cint
    buffer_width*, buffer_height*: cint

  WlrSubsurface* {.bycopy.} = object
    resource*: ptr WlResource
    surface*: ptr WlrSurface
    parent*: ptr WlrSurface
    current*: WlrSubsurfaceParentState
    pending*: WlrSubsurfaceParentState
    cached_seq*: uint32
    has_cache*: bool
    synchronized*: bool
    reordered*: bool
    mapped*: bool
    added*: bool
    surface_destroy*: WlListener
    parent_destroy*: WlListener
    events*: WlrSubsurface_events
    data*: pointer

  WlrSubsurfaceParentState* {.bycopy.} = object
    x*, y*: int32
    link*: WlList

  WlrSubsurface_events* {.bycopy.} = object
    destroy*: WlSignal
    map*: WlSignal
    unmap*: WlSignal

type WlrSurfaceStateField* = enum
  WLR_SURFACE_STATE_BUFFER = 1 shl 0,
  WLR_SURFACE_STATE_SURFACE_DAMAGE = 1 shl 1,
  WLR_SURFACE_STATE_BUFFER_DAMAGE = 1 shl 2,
  WLR_SURFACE_STATE_OPAQUE_REGION = 1 shl 3,
  WLR_SURFACE_STATE_INPUT_REGION = 1 shl 4,
  WLR_SURFACE_STATE_TRANSFORM = 1 shl 5,
  WLR_SURFACE_STATE_SCALE = 1 shl 6,
  WLR_SURFACE_STATE_FRAME_CALLBACK_LIST = 1 shl 7,
  WLR_SURFACE_STATE_VIEWPORT_FIXME = 1 shl 8

type WlrSurfaceIteratorFunc_t* = proc (surface: ptr WlrSurface; sx: cint; sy: cint; data: pointer)

## wlr_output

type
  WlrOutput* {.bycopy.} = object
    impl*: ptr WlrOutput_impl
    backend*: ptr WlrBackend
    display*: ptr WlDisplay
    global*: ptr WlGlobal
    resources*: WlList
    name*: cstring
    description*: cstring
    make*: array[56, char]
    model*: array[16, char]
    serial*: array[16, char]
    phys_width*, phys_height*: int32
    modes*: WlList
    current_mode*: ptr WlrOutput_mode
    width*, height*: int32
    refresh*: int32
    enabled*: bool
    scale*: cfloat
    subpixel*: WlOutputSubpixel
    transform*: WlOutputTransform
    adaptive_sync_status*: WlrOutputAdaptiveSyncStatus
    render_format*: uint32
    needs_frame*: bool
    frame_pending*: bool
    transform_matrix*: array[9, cfloat]
    non_desktop*: bool
    pending*: WlrOutputState
    commit_seq*: uint32
    events*: WlrOutput_events
    idle_frame*: ptr WlEventSource
    idle_done*: ptr WlEventSource
    attach_render_locks*: cint
    cursors*: WlList
    hardware_cursor*: ptr WlrOutputCursor
    cursor_swapchain*: ptr WlrSwapchain
    cursor_front_buffer*: ptr WlrBuffer
    software_cursor_locks*: cint
    allocator*: ptr WlrAllocator
    renderer*: ptr WlrRenderer
    swapchain*: ptr WlrSwapchain
    back_buffer*: ptr WlrBuffer
    display_destroy*: WlListener
    addons*: WlrAddonSet
    data*: pointer

  WlrOutput_impl* {.bycopy.} = object
    set_cursor*: proc (output: ptr WlrOutput; buffer: ptr WlrBuffer; hotspot_x: cint; hotspot_y: cint): bool
    move_cursor*: proc (output: ptr WlrOutput; x: cint; y: cint): bool
    destroy*: proc (output: ptr WlrOutput)
    test*: proc (output: ptr WlrOutput): bool
    commit*: proc (output: ptr WlrOutput): bool
    get_gamma_size*: proc (output: ptr WlrOutput): csize_t
    get_cursor_formats*: proc (output: ptr WlrOutput; buffer_caps: uint32): ptr WlrDrmFormatSet
    get_cursor_size*: proc (output: ptr WlrOutput; width: ptr cint; height: ptr cint)
    get_primary_formats*: proc (output: ptr WlrOutput; buffer_caps: uint32): ptr WlrDrmFormatSet

  WlrOutputMode* {.bycopy.} = object
    width*, height*: int32
    refresh*: int32
    preferred*: bool
    link*: WlList

  WlrOutputAdaptiveSyncStatus* = enum
    WLR_OUTPUT_ADAPTIVE_SYNC_DISABLED,
    WLR_OUTPUT_ADAPTIVE_SYNC_ENABLED,
    WLR_OUTPUT_ADAPTIVE_SYNC_UNKNOWN

  WlrOutputState* {.bycopy.} = object
    committed*: uint32
    damage*: PixmanRegion32
    enabled*: bool
    scale*: cfloat
    transform*: WlOutputTransform
    adaptive_sync_enabled*: bool
    render_format*: uint32
    buffer*: ptr WlrBuffer
    mode_type*: WlrOutputStateModeType
    mode*: ptr WlrOutput_mode
    custom_mode*: WlrOutputState_custom_mode
    gamma_lut*: ptr uint16
    gamma_lut_size*: csize_t

  WlrOutputStateModeType* = enum
    WLR_OUTPUT_STATE_MODE_FIXED,
    WLR_OUTPUT_STATE_MODE_CUSTOM

  WlrOutputState_custom_mode* {.bycopy.} = object
    width*, height*: int32
    refresh*: int32

  WlrOutputCursor* {.bycopy.} = object
    output*: ptr WlrOutput
    x*, y*: cdouble
    enabled*: bool
    visible*: bool
    width*, height*: uint32
    hotspot_x*, hotspot_y*: int32
    link*: WlList
    texture*: ptr WlrTexture
    surface*: ptr WlrSurface
    surface_commit*: WlListener
    surface_destroy*: WlListener
    events*: WlrOutputCursor_events

  WlrOutputCursor_events* {.bycopy.} = object
    destroy*: WlSignal

  WlrOutput_events* {.bycopy.} = object
    frame*: WlSignal
    damage*: WlSignal
    needs_frame*: WlSignal
    precommit*: WlSignal
    commit*: WlSignal
    present*: WlSignal
    `bind`*: WlSignal
    enable*: WlSignal
    mode*: WlSignal
    description*: WlSignal
    destroy*: WlSignal

type WlrOutputStateField* = enum
  WLR_OUTPUT_STATE_BUFFER = 1 shl 0,
  WLR_OUTPUT_STATE_DAMAGE = 1 shl 1,
  WLR_OUTPUT_STATE_MODE = 1 shl 2,
  WLR_OUTPUT_STATE_ENABLED = 1 shl 3,
  WLR_OUTPUT_STATE_SCALE = 1 shl 4,
  WLR_OUTPUT_STATE_TRANSFORM = 1 shl 5,
  WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED = 1 shl 6,
  WLR_OUTPUT_STATE_GAMMA_LUT = 1 shl 7,
  WLR_OUTPUT_STATE_RENDER_FORMAT = 1 shl 8

# const WLR_OUTPUT_STATE_BACKEND_OPTIONAL*: WlrOutputStateField =
#   WLR_OUTPUT_STATE_DAMAGE or
#   WLR_OUTPUT_STATE_SCALE or
#   WLR_OUTPUT_STATE_TRANSFORM or
#   WLR_OUTPUT_STATE_RENDER_FORMAT or
#   WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED

type WlrOutputEventDamage* {.bycopy.} = object
  output*: ptr WlrOutput
  damage*: ptr PixmanRegion32

type WlrOutputEventPrecommit* {.bycopy.} = object
  output*: ptr WlrOutput
  `when`*: ptr Timespec

type WlrOutputEventCommit* {.bycopy.} = object
  output*: ptr WlrOutput
  committed*: uint32
  `when`*: ptr Timespec
  buffer*: ptr WlrBuffer

type WlrOutputPresentFlag* = enum
  WLR_OUTPUT_PRESENT_VSYNC = 0x1,
  WLR_OUTPUT_PRESENT_HW_CLOCK = 0x2,
  WLR_OUTPUT_PRESENT_HW_COMPLETION = 0x4,
  WLR_OUTPUT_PRESENT_ZERO_COPY = 0x8

type WlrOutputEventPresent* {.bycopy.} = object
  output*: ptr WlrOutput
  commit_seq*: uint32
  presented*: bool
  `when`*: ptr Timespec
  seq*: cuint
  refresh*: cint
  flags*: uint32

type WlrOutputEventBind* {.bycopy.} = object
  output*: ptr WlrOutput
  resource*: ptr WlResource

proc init*(output: ptr WlrOutput; backend: ptr WlrBackend; impl: ptr WlrOutput_impl; display: ptr WlDisplay) {.importc: "wlr_output_init".}

proc updateMode*(output: ptr WlrOutput; mode: ptr WlrOutputMode) {.importc: "wlr_output_update_mode".}
proc updateCustomMode*(output: ptr WlrOutput; width: int32; height: int32; refresh: int32) {.importc: "wlr_output_update_custom_mode".}
proc updateEnabled*(output: ptr WlrOutput; enabled: bool) {.importc: "wlr_output_update_enabled".}
proc updateNeedsFrame*(output: ptr WlrOutput) {.importc: "wlr_output_update_needs_frame".}

proc damageWhole*(output: ptr WlrOutput) {.importc: "wlr_output_damage_whole".}
proc sendFrame*(output: ptr WlrOutput) {.importc: "wlr_output_send_frame".}
proc sendPresent*(output: ptr WlrOutput; event: ptr WlrOutputEventPresent) {.importc: "wlr_output_send_present".}

proc enable*(output: ptr WlrOutput; enable: bool) {.importc: "wlr_output_enable".}
proc createGlobal*(output: ptr WlrOutput) {.importc: "wlr_output_create_global".}
proc destroyGlobal*(output: ptr WlrOutput) {.importc: "wlr_output_destroy_global".}
# TODO proc initRender*(output: ptr WlrOutput; allocator: ptr WlrAllocater; renderer: ptr WlrRenderer): bool {.importc: "wlr_output_init_render".}
proc preferredMode*(output: ptr WlrOutput): ptr WlrOutput_mode {.importc: "wlr_output_preferred_mode".}
proc setMode*(output: ptr WlrOutput; mode: ptr WlrOutput_mode) {.importc: "wlr_output_set_mode".}
proc setCustomMode*(output: ptr WlrOutput; width: int32; height: int32; refresh: int32) {.importc: "wlr_output_set_custom_mode".}
proc setTransform*(output: ptr WlrOutput; transform: WlOutputTransform) {.importc: "wlr_output_set_transform".}
proc enableAdaptiveSync*(output: ptr WlrOutput; enabled: bool) {.importc: "wlr_output_enable_adaptive_sync".}

proc setRenderFormat*(output: ptr WlrOutput; format: uint32) {.importc: "wlr_output_set_render_format".}
proc setScale*(output: ptr WlrOutput; scale: cfloat) {.importc: "wlr_output_set_scale".}
proc setSubpixel*(output: ptr WlrOutput; subpixel: WlOutputSubpixel) {.importc: "wlr_output_set_subpixel".}
proc setName*(output: ptr WlrOutput; name: cstring) {.importc: "wlr_output_set_name".}
proc setDescription*(output: ptr WlrOutput; desc: cstring) {.importc: "wlr_output_set_description".}

proc scheduleDone*(output: ptr WlrOutput) {.importc: "wlr_output_schedule_done".}
proc destroy*(output: ptr WlrOutput) {.importc: "wlr_output_destroy".}
proc transformedResolution*(output: ptr WlrOutput; width: ptr cint; height: ptr cint) {.importc: "wlr_output_transformed_resolution".}
proc effectiveResolution*(output: ptr WlrOutput; width: ptr cint; height: ptr cint) {.importc: "wlr_output_effective_resolution".}
proc attachRender*(output: ptr WlrOutput; buffer_age: ptr cint): bool {.importc: "wlr_output_attach_render".}
proc attachBuffer*(output: ptr WlrOutput; buffer: ptr WlrBuffer) {.importc: "wlr_output_attach_buffer".}
proc preferredReadFormat*(output: ptr WlrOutput): uint32 {.importc: "wlr_output_preferred_read_format".}
proc setDamage*(output: ptr WlrOutput; damage: ptr PixmanRegion32) {.importc: "wlr_output_set_damage".}
proc test*(output: ptr WlrOutput): bool {.importc: "wlr_output_test".}
proc commit*(output: ptr WlrOutput): bool {.importc: "wlr_output_commit".}
proc rollback*(output: ptr WlrOutput) {.importc: "wlr_output_rollback".}
proc scheduleFrame*(output: ptr WlrOutput) {.importc: "wlr_output_schedule_frame".}
proc getGammaSize*(output: ptr WlrOutput): csize_t {.importc: "wlr_output_get_gamma_size".}
proc setGamma*(output: ptr WlrOutput; size: csize_t; r: ptr uint16; g: ptr uint16; b: ptr uint16) {.importc: "wlr_output_set_gamma".}
proc wlrOutput*(resource: ptr WlResource): ptr WlrOutput {.importc: "wlr_output_from_resource".}
proc lockAttachRender*(output: ptr WlrOutput; lock: bool) {.importc: "wlr_output_lock_attach_render".}
proc lockSoftwareCursors*(output: ptr WlrOutput; lock: bool) {.importc: "wlr_output_lock_software_cursors".}
proc renderSoftwareCursors*(output: ptr WlrOutput; damage: ptr PixmanRegion32) {.importc: "wlr_output_render_software_cursors".}
proc getPrimaryFormats*(output: ptr WlrOutput; buffer_caps: uint32): ptr WlrDrmFormatSet {.importc: "wlr_output_get_primary_formats".}
proc createWlrOutputCursor*(output: ptr WlrOutput): ptr WlrOutputCursor {.importc: "wlr_output_cursor_create".}

proc setImage*(cursor: ptr WlrOutputCursor; pixels: ptr uint8; stride: int32; width: uint32; height: uint32; hotspot_x: int32; hotspot_y: int32): bool {.importc: "wlr_output_cursor_set_image".}
proc setSurface*(cursor: ptr WlrOutputCursor; surface: ptr WlrSurface; hotspot_x: int32; hotspot_y: int32) {.importc: "wlr_output_cursor_set_surface".}
proc move*(cursor: ptr WlrOutputCursor; x: cdouble; y: cdouble): bool {.importc: "wlr_output_cursor_move".}
proc destroy*(cursor: ptr WlrOutputCursor) {.importc: "wlr_output_cursor_destroy".}

proc invert*(tr: WlOutputTransform): WlOutputTransform {.importc: "wlr_output_transform_invert".}
proc compose*(tr_a: WlOutputTransform; tr_b: WlOutputTransform): WlOutputTransform {.importc: "wlr_output_transform_compose".}

# import wlr-output-power-management-unstable-v1-protocol

type
  WlrOutputPowerManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    output_powers*: WlList
    display_destroy*: WlListener
    events*: WlrOutputPowerManager_v1_events
    data*: pointer

  WlrOutputPowerManager_v1_events* {.bycopy.} = object
    set_mode*: WlSignal
    destroy*: WlSignal

type WlrOutputPower_v1* {.bycopy.} = object
  resource*: ptr WlResource
  output*: ptr WlrOutput
  manager*: ptr WlrOutputPowerManager_v1
  link*: WlList
  output_destroy_listener*: WlListener
  output_commit_listener*: WlListener
  data*: pointer

type WlrOutputPower_v1_set_mode_event* {.bycopy.} = object
  output*: ptr WlrOutput
  mode*: zwlr_output_power_v1_mode

proc createWlrOutputPowerManager_v1*(display: ptr WlDisplay): ptr WlrOutputPowerManager_v1 {.importc: "wlr_output_power_manager_v1_create".}

## wlr_surface

type WlrSurfaceOutput* {.bycopy.} = object
  surface*: ptr WlrSurface
  output*: ptr WlrOutput
  link*: WlList
  `bind`*: WlListener
  destroy*: WlListener

proc setRole*(surface: ptr WlrSurface; role: ptr WlrSurface_role; role_data: pointer; error_resource: ptr WlResource; error_code: uint32): bool {.importc: "wlr_surface_set_role".}
proc hasBuffer*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_has_buffer".}
proc getTexture*(surface: ptr WlrSurface): ptr WlrTexture {.importc: "wlr_surface_get_texture".}
proc getRootSurface*(surface: ptr WlrSurface): ptr WlrSurface {.importc: "wlr_surface_get_root_surface".}
proc pointAcceptsInput*(surface: ptr WlrSurface; sx: cdouble; sy: cdouble): bool {.importc: "wlr_surface_point_accepts_input".}
proc surfaceAat*(surface: ptr WlrSurface; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_surface_surface_at".}
proc sendEnter*(surface: ptr WlrSurface; output: ptr WlrOutput) {.importc: "wlr_surface_send_enter".}
proc sendLeave*(surface: ptr WlrSurface; output: ptr WlrOutput) {.importc: "wlr_surface_send_leave".}
proc sendFrameDone*(surface: ptr WlrSurface; `when`: ptr Timespec) {.importc: "wlr_surface_send_frame_done".}
proc getExtends*(surface: ptr WlrSurface; box: ptr WlrBox) {.importc: "wlr_surface_get_extends".}
proc fromResource*(resource: ptr WlResource): ptr WlrSurface {.importc: "wlr_surface_from_resource".}
proc forEach*(surface: ptr WlrSurface; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_surface_for_each_surface".}
proc getEffectiveDamage*(surface: ptr WlrSurface; damage: ptr PixmanRegion32) {.importc: "wlr_surface_get_effective_damage".}
proc getBufferSourceBox*(surface: ptr WlrSurface; box: ptr WlrFbox) {.importc: "wlr_surface_get_buffer_source_box".}
proc lockPending*(surface: ptr WlrSurface): uint32 {.importc: "wlr_surface_lock_pending".}
proc unlockCached*(surface: ptr WlrSurface; seq: uint32) {.importc: "wlr_surface_unlock_cached".}

## wlr_compositor

type WlrSubcompositor* {.bycopy.} = object
  global*: ptr WlGlobal

type
  WlrCompositor* {.bycopy.} = object
    global*: ptr WlGlobal
    renderer*: ptr WlrRenderer
    subcompositor*: WlrSubcompositor
    display_destroy*: WlListener
    events*: WlrCompositor_events

  WlrCompositor_events* {.bycopy.} = object
    new_surface*: WlSignal
    destroy*: WlSignal

proc createWlrCompositor*(display: ptr WlDisplay; renderer: ptr WlrRenderer): ptr WlrCompositor {.importc: "wlr_compositor_create".}
proc isSubsurface*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_is_subsurface".}
proc wlrSubsurface*(surface: ptr WlrSurface): ptr WlrSubsurface {.importc: "wlr_subsurface_from_wlr_surface".}

## wlr_switch

type
  WlrSwitch* {.bycopy.} = object
    impl*: ptr WlrSwitch_impl
    events*: WlrSwitch_events
    data*: pointer

  WlrSwitch_impl* {.bycopy.} = object
    destroy*: proc (switch_device: ptr WlrSwitch)

  WlrSwitch_events* {.bycopy.} = object
    toggle*: WlSignal

proc init*(switch_device: ptr WlrSwitch; impl: ptr WlrSwitch_impl) {.importc: "wlr_switch_init".}
proc destroy*(switch_device: ptr WlrSwitch) {.importc: "wlr_switch_destroy".}

type WlrSwitchType* = enum
  WLR_SWITCH_TYPE_LID = 1,
  WLR_SWITCH_TYPE_TABLET_MODE

type WlrSwitchState* = enum
  WLR_SWITCH_STATE_OFF = 0,
  WLR_SWITCH_STATE_ON,
  WLR_SWITCH_STATE_TOGGLE

## wlr_touch

type
  WlrTouch* {.bycopy.} = object
    `impl`: ptr WlrTouch_impl
    events*: WlrTouch_events
    data*: pointer

  WlrTouch_impl* {.bycopy.} = object
    destroy*: proc (touch: ptr WlrTouch)

  WlrTouch_events* {.bycopy.} = object
    down*: WlSignal
    up*: WlSignal
    motion*: WlSignal
    cancel*: WlSignal
    frame*: WlSignal

proc init*(touch: ptr WlrTouch; impl: ptr WlrTouch_impl) {.importc: "wlr_touch_init".}
proc destroy*(touch: ptr WlrTouch) {.importc: "wlr_touch_destroy".}

## wlr_tablet_tool

type WlrTabletToolType* = enum
  WLR_TABLET_TOOL_TYPE_PEN = 1,
  WLR_TABLET_TOOL_TYPE_ERASER,
  WLR_TABLET_TOOL_TYPE_BRUSH,
  WLR_TABLET_TOOL_TYPE_PENCIL,
  WLR_TABLET_TOOL_TYPE_AIRBRUSH,
  WLR_TABLET_TOOL_TYPE_MOUSE,
  WLR_TABLET_TOOL_TYPE_LENS,
  WLR_TABLET_TOOL_TYPE_TOTEM

type
  WlrTabletTool* {.bycopy.} = object
    `type`*: WlrTabletToolType
    hardware_serial*: uint64
    hardware_wacom*: uint64
    tilt*: bool
    pressure*: bool
    distance*: bool
    rotation*: bool
    slider*: bool
    wheel*: bool
    events*: WlrTabletTool_events
    data*: pointer

  WlrTabletTool_events* {.bycopy.} = object
    destroy*: WlSignal

type
  WlrTablet* {.bycopy.} = object
    impl*: ptr WlrTablet_impl
    events*: WlrTablet_events
    name*: cstring
    paths*: WlArray
    data*: pointer

  WlrTablet_impl* {.bycopy.} = object
    destroy*: proc (tablet: ptr WlrTablet)

  WlrTablet_events* {.bycopy.} = object
    axis*: WlSignal
    proximity*: WlSignal
    tip*: WlSignal
    button*: WlSignal

proc init*(tablet: ptr WlrTablet; impl: ptr WlrTablet_impl) {.importc: "wlr_tablet_init".}
proc destroy*(tablet: ptr WlrTablet) {.importc: "wlr_tablet_destroy".}

type WlrTabletToolAxes* = enum
  WLR_TABLET_TOOL_AXIS_X = 1 shl 0,
  WLR_TABLET_TOOL_AXIS_Y = 1 shl 1,
  WLR_TABLET_TOOL_AXIS_DISTANCE = 1 shl 2,
  WLR_TABLET_TOOL_AXIS_PRESSURE = 1 shl 3,
  WLR_TABLET_TOOL_AXIS_TILT_X = 1 shl 4,
  WLR_TABLET_TOOL_AXIS_TILT_Y = 1 shl 5,
  WLR_TABLET_TOOL_AXIS_ROTATION = 1 shl 6,
  WLR_TABLET_TOOL_AXIS_SLIDER = 1 shl 7,
  WLR_TABLET_TOOL_AXIS_WHEEL = 1 shl 8

## wlr_tablet_pad

type
  WlrTabletPad* {.bycopy.} = object
    impl*: ptr WlrTabletPad_impl
    events*: WlrTabletPad_events
    button_count*: csize_t
    ring_count*: csize_t
    strip_count*: csize_t
    groups*: WlList
    paths*: WlArray
    data*: pointer

  WlrTabletPad_impl* {.bycopy.} = object
    destroy*: proc (pad: ptr WlrTabletPad)

  WlrTabletPad_events* {.bycopy.} = object
    button*: WlSignal
    ring*: WlSignal
    strip*: WlSignal
    attach_tablet*: WlSignal

proc init*(pad: ptr WlrTabletPad; impl: ptr WlrTabletPad_impl) {.importc: "wlr_tablet_pad_init".}
proc destroy*(pad: ptr WlrTabletPad) {.importc: "wlr_tablet_pad_destroy".}

type WlrTabletPadGroup* {.bycopy.} = object
  link*: WlList
  button_count*: csize_t
  buttons*: ptr cuint
  strip_count*: csize_t
  strips*: ptr cuint
  ring_count*: csize_t
  rings*: ptr cuint
  mode_count*: cuint

type WlrTabletPadRingSource* = enum
  WLR_TABLET_PAD_RING_SOURCE_UNKNOWN,
  WLR_TABLET_PAD_RING_SOURCE_FINGER

type WlrEventTabletPadRing* {.bycopy.} = object
  time_msec*: uint32
  source*: WlrTabletPadRingSource
  ring*: uint32
  position*: cdouble
  mode*: cuint

type WlrTabletPadStripSource* = enum
  WLR_TABLET_PAD_STRIP_SOURCE_UNKNOWN,
  WLR_TABLET_PAD_STRIP_SOURCE_FINGER

type WlrEventTabletPadStrip* {.bycopy.} = object
  time_msec*: uint32
  source*: WlrTabletPadStripSource
  strip*: uint32
  position*: cdouble
  mode*: cuint

## wlr_keyboard

const WLR_LED_COUNT* = 3

type WlrKeyboardLed* = enum
  WLR_LED_NUM_LOCK = 1 shl 0,
  WLR_LED_CAPS_LOCK = 1 shl 1,
  WLR_LED_SCROLL_LOCK = 1 shl 2

const WLR_MODIFIER_COUNT* = 8

type WlrKeyboardModifier* = enum
  WLR_MODIFIER_SHIFT = 1 shl 0,
  WLR_MODIFIER_CAPS = 1 shl 1,
  WLR_MODIFIER_CTRL = 1 shl 2,
  WLR_MODIFIER_ALT = 1 shl 3,
  WLR_MODIFIER_MOD2 = 1 shl 4,
  WLR_MODIFIER_MOD3 = 1 shl 5,
  WLR_MODIFIER_LOGO = 1 shl 6,
  WLR_MODIFIER_MOD5 = 1 shl 7

const WLR_KEYBOARD_KEYS_CAP* = 32

type
  WlrKeyboard* {.bycopy.} = object
    impl*: ptr WlrKeyboard_impl
    group*: ptr WlrKeyboardGroup
    keymap_string*: cstring
    keymap_size*: csize_t
    keymap_fd*: cint
    keymap*: ptr XkbKeymap
    xkb_state*: ptr XkbState
    led_indexes*: array[WLR_LED_COUNT, XkbLedIndex]
    mod_indexes*: array[WLR_MODIFIER_COUNT, XkbModIndex]
    keycodes*: array[WLR_KEYBOARD_KEYS_CAP, uint32]
    num_keycodes*: csize_t
    modifiers*: WlrKeyboard_modifiers
    repeat_info*: WlrKeyboard_repeat_info
    events*: WlrKeyboard_events
    data*: pointer

  WlrKeyboard_impl* {.bycopy.} = object
    destroy*: proc (keyboard: ptr WlrKeyboard)
    led_update*: proc (keyboard: ptr WlrKeyboard; leds: uint32)

  WlrKeyboardGroup* {.bycopy.} = object
    keyboard*: WlrKeyboard
    input_device*: ptr WlrInputDevice
    devices*: WlList
    keys*: WlList
    events*: WlrKeyboardGroup_events
    data*: pointer

  WlrKeyboardGroup_events* {.bycopy.} = object
    enter*: WlSignal
    leave*: WlSignal
  WlrKeyboard_modifiers* {.bycopy.} = object
    depressed*: XkbModMask
    latched*: XkbModMask
    locked*: XkbModMask
    group*: XkbModMask

  WlrKeyboard_repeat_info* {.bycopy.} = object
    rate*: int32
    delay*: int32

  WlrKeyboard_events* {.bycopy.} = object
    key*: WlSignal
    modifiers*: WlSignal
    keymap*: WlSignal
    repeat_info*: WlSignal
    destroy*: WlSignal

  WlrPointer* {.bycopy.} = object
    impl*: ptr WlrPointer_impl
    events*: WlrPointer_events
    data*: pointer

  WlrPointer_impl* {.bycopy.} = object
    destroy*: proc (pointer: ptr WlrPointer)

  WlrPointer_events* {.bycopy.} = object
    motion*: WlSignal
    motion_absolute*: WlSignal
    button*: WlSignal
    axis*: WlSignal
    frame*: WlSignal
    swipe_begin*: WlSignal
    swipe_update*: WlSignal
    swipe_end*: WlSignal
    pinch_begin*: WlSignal
    pinch_update*: WlSignal
    pinch_end*: WlSignal
    hold_begin*: WlSignal
    hold_end*: WlSignal

  WlrEventSwitchToggle* {.bycopy.} = object
    device*: ptr WlrInputDevice
    time_msec*: uint32
    switch_type*: WlrSwitchType
    switch_state*: WlrSwitchState

  WlrEventTouchDown* {.bycopy.} = object
    device*: ptr WlrInputDevice
    time_msec*: uint32
    touch_id*: int32
    x*, y*: cdouble

  WlrEventTouchUp* {.bycopy.} = object
    device*: ptr WlrInputDevice
    time_msec*: uint32
    touch_id*: int32

  WlrEventTouchMotion* {.bycopy.} = object
    device*: ptr WlrInputDevice
    time_msec*: uint32
    touch_id*: int32
    x*, y*: cdouble

  WlrEventTouchCancel* {.bycopy.} = object
    device*: ptr WlrInputDevice
    time_msec*: uint32
    touch_id*: int32

  WlrEventTabletToolAxis* {.bycopy.} = object
    device*: ptr WlrInputDevice
    tool*: ptr WlrTabletTool
    time_msec*: uint32
    updated_axes*: uint32
    x*, y*: cdouble
    dx*, dy*: cdouble
    pressure*: cdouble
    distance*: cdouble
    tilt_x*, tilt_y*: cdouble
    rotation*: cdouble
    slider*: cdouble
    wheel_delta*: cdouble

  WlrEventTabletToolProximity* {.bycopy.} = object
    device*: ptr WlrInputDevice
    tool*: ptr WlrTabletTool
    time_msec*: uint32
    x*, y*: cdouble
    state*: WlrTabletToolProximityState

  WlrTabletToolProximityState* = enum
    WLR_TABLET_TOOL_PROXIMITY_OUT,
    WLR_TABLET_TOOL_PROXIMITY_IN

  WlrEventTabletToolTip* {.bycopy.} = object
    device*: ptr WlrInputDevice
    tool*: ptr WlrTabletTool
    time_msec*: uint32
    x*, y*: cdouble
    state*: WlrTabletToolTipState

  WlrTabletToolTipState* = enum
    WLR_TABLET_TOOL_TIP_UP,
    WLR_TABLET_TOOL_TIP_DOWN

  WlrEventTabletToolButton* {.bycopy.} = object
    device*: ptr WlrInputDevice
    tool*: ptr WlrTabletTool
    time_msec*: uint32
    button*: uint32
    state*: WlrButtonState

  WlrEventTabletPadButton* {.bycopy.} = object
    time_msec*: uint32
    button*: uint32
    state*: WlrButtonState
    mode*: cuint
    group*: cuint

  WlrEventPointerButton* {.bycopy.} = object
    device*: ptr WlrInputDevice
    time_msec*: uint32
    button*: uint32
    state*: WlrButtonState

  WlrButtonState* = enum
    WLR_BUTTON_RELEASED, WLR_BUTTON_PRESSED

  WlrInputDevice* {.bycopy.} = object
    impl*: ptr WlrInputDevice_impl
    `type`*: WlrInputDeviceType
    vendor*: cuint
    product*: cuint
    name*: cstring
    width_mm*: cdouble
    height_mm*: cdouble
    output_name*: cstring
    ano_wlr_input_device_49*: WlrInputDevice_ano
    events*: WlrInputDevice_events
    data*: pointer

  WlrInputDevice_impl* {.bycopy.} = object
    destroy*: proc (wlr_device: ptr WlrInputDevice)

  WlrInputDeviceType* = enum
    WLR_INPUT_DEVICE_KEYBOARD,
    WLR_INPUT_DEVICE_POINTER,
    WLR_INPUT_DEVICE_TOUCH,
    WLR_INPUT_DEVICE_TABLET_TOOL,
    WLR_INPUT_DEVICE_TABLET_PAD,
    WLR_INPUT_DEVICE_SWITCH

  WlrInputDevice_ano* {.bycopy, union.} = object
    device*: pointer # NOTE: _device
    keyboard*: ptr WlrKeyboard
    pointer*: ptr WlrPointer
    switch_device*: ptr WlrSwitch
    touch*: ptr WlrTouch
    tablet*: ptr WlrTablet
    tablet_pad*: ptr WlrTabletPad

  WlrInputDevice_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrEventKeyboardKey* {.bycopy.} = object
  time_msec*: uint32
  keycode*: uint32
  update_state*: bool
  state*: WlKeyboardKeyState

proc init*(keyboard: ptr WlrKeyboard; impl: ptr WlrKeyboard_impl) {.importc: "wlr_keyboard_init".}
proc destroy*(keyboard: ptr WlrKeyboard) {.importc: "wlr_keyboard_destroy".}
proc notifyKey*(keyboard: ptr WlrKeyboard; event: ptr WlrEventKeyboardKey) {.importc: "wlr_keyboard_notify_key".}
proc notifyModifiers*(keyboard: ptr WlrKeyboard; mods_depressed: uint32; mods_latched: uint32; mods_locked: uint32; group: uint32) {.importc: "wlr_keyboard_notify_modifiers".}

proc setKeymap*(kb: ptr WlrKeyboard; keymap: ptr XkbKeymap): bool {.importc: "wlr_keyboard_set_keymap".}
proc keymapsMatch*(km1: ptr XkbKeymap; km2: ptr XkbKeymap): bool {.importc: "wlr_keyboard_keymaps_match".}

proc setRepeatInfo*(kb: ptr WlrKeyboard; rate: int32; delay: int32) {.importc: "wlr_keyboard_set_repeat_info".}
proc ledUpdate*(keyboard: ptr WlrKeyboard; leds: uint32) {.importc: "wlr_keyboard_led_update".}
proc getModifiers*(keyboard: ptr WlrKeyboard): uint32 {.importc: "wlr_keyboard_get_modifiers".}

## wlr_keyboard_group

proc createWlrKeyboardGroup*(): ptr WlrKeyboardGroup {.importc: "wlr_keyboard_group_create".}
proc wlrKeyboardGroup*(keyboard: ptr WlrKeyboard): ptr WlrKeyboardGroup {.importc: "wlr_keyboard_group_from_wlr_keyboard".}
proc addKeyboard*(group: ptr WlrKeyboardGroup; keyboard: ptr WlrKeyboard): bool {.importc: "wlr_keyboard_group_add_keyboard".}
proc removeKeyboard*(group: ptr WlrKeyboardGroup; keyboard: ptr WlrKeyboard) {.importc: "wlr_keyboard_group_remove_keyboard".}
proc destroy*(group: ptr WlrKeyboardGroup) {.importc: "wlr_keyboard_group_destroy".}

## wlr_input_device

proc init*(wlr_device: ptr WlrInputDevice; `type`: WlrInputDevice_type; impl: ptr WlrInputDevice_impl; name: cstring; vendor: cint; product: cint) {.importc: "wlr_input_device_init".}
proc destroy*(dev: ptr WlrInputDevice) {.importc: "wlr_input_device_destroy".}

## drm

proc createDrmBackend*(display: ptr WlDisplay; session: ptr WlrSession; dev: ptr WlrDevice; parent: ptr WlrBackend): ptr WlrBackend {.importc: "wlr_drm_backend_create".}

proc isDrm*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_drm".}
proc isDrm*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_drm".}

proc getId*(output: ptr WlrOutput): uint32 {.importc: "wlr_drm_connector_get_id".}

proc getNonMasterFd*(backend: ptr WlrBackend): cint {.importc: "wlr_drm_backend_get_non_master_fd".}
proc createWlrDrmlease*(outputs: ptr ptr WlrOutput; n_outputs: csize_t; lease_fd: ptr cint): ptr WlrDrmLease {.importc: "wlr_drm_create_lease".}
proc terminate*(lease: ptr WlrDrmLease) {.importc: "wlr_drm_lease_terminate".}

type drmModeModeInfo* = rmModeModeInfo # TODO: _drmModeModeInfo

proc addMode*(output: ptr WlrOutput; mode: ptr drmModeModeInfo): ptr WlrOutputMode {.importc: "wlr_drm_connector_add_mode".}
proc getPanelOrientation*(output: ptr WlrOutput): WlOutputTransform {.importc: "wlr_drm_connector_get_panel_orientation".}

## headless

proc createHeadlessBackend*(display: ptr WlDisplay): ptr WlrBackend {.importc: "wlr_headless_backend_create".}
proc addHeadlessOutput*(backend: ptr WlrBackend; width: cuint; height: cuint): ptr WlrOutput {.importc: "wlr_headless_add_output".}
proc addHeadlessInputDevice*(backend: ptr WlrBackend; `type`: WlrInputDeviceType): ptr WlrInputDevice {.importc: "wlr_headless_add_input_device".}

proc isHeadless*(backend: ptr WlrBackend): bool {.importc: "wlr_backend_is_headless".}
proc isHeadless*(device: ptr WlrInputDevice): bool {.importc: "wlr_input_device_is_headless".}
proc isHeadless*(output: ptr WlrOutput): bool {.importc: "wlr_output_is_headless".}

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

proc forEach*(backend: ptr WlrBackend; callback: proc (backend: ptr WlrBackend; data: pointer); data: pointer) {.importc: "wlr_multi_for_each_backend".}

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

## wlr_pointer

proc init*(pointer: ptr WlrPointer; impl: ptr WlrPointer_impl) {.importc: "wlr_pointer_init".}
proc destroy*(pointer: ptr WlrPointer) {.importc: "wlr_pointer_destroy".}

type WlrEventPointerMotion* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  delta_x*, delta_y*: cdouble
  unaccel_dx*, unaccel_dy*: cdouble

type WlrEventPointerMotionAbsolute* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  x*, y*: cdouble

type WlrAxisSource* = enum
  WLR_AXIS_SOURCE_WHEEL,
  WLR_AXIS_SOURCE_FINGER,
  WLR_AXIS_SOURCE_CONTINUOUS,
  WLR_AXIS_SOURCE_WHEEL_TILT

type WlrAxisOrientation* = enum
  WLR_AXIS_ORIENTATION_VERTICAL,
  WLR_AXIS_ORIENTATION_HORIZONTAL

type WlrEventPointerAxis* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  source*: WlrAxisSource
  orientation*: WlrAxisOrientation
  delta*: cdouble
  delta_discrete*: int32

type WlrEventPointerSwipeBegin* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  fingers*: uint32

type WlrEventPointerSwipeUpdate* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  fingers*: uint32
  dx*, dy*: cdouble

type WlrEventPointerSwipeEnd* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  cancelled*: bool

type WlrEventPointerPinchBegin* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  fingers*: uint32

type WlrEventPointerPinchUpdate* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  fingers*: uint32
  dx*, dy*: cdouble
  scale*: cdouble
  rotation*: cdouble

type WlrEventPointerPinchEnd* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  cancelled*: bool

type WlrEventPointerHoldBegin* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  fingers*: uint32

type WlrEventPointerHoldEnd* {.bycopy.} = object
  device*: ptr WlrInputDevice
  time_msec*: uint32
  cancelled*: bool

## wlr_output_layout

type
  WlrOutputLayout* {.bycopy.} = object
    outputs*: WlList
    state*: ptr WlrOutputLayout_state
    events*: WlrOutputLayout_events
    data*: pointer

  WlrOutputLayout_events* {.bycopy.} = object
    add*: WlSignal
    change*: WlSignal
    destroy*: WlSignal

type
  WlrOutputLayoutOutput* {.bycopy.} = object
    output*: ptr WlrOutput
    x*, y*: cint
    link*: WlList
    state*: ptr WlrOutputLayoutOutput_state
    addon*: WlrAddon
    events*: WlrOutputLayoutOutput_events

  WlrOutputLayoutOutput_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrOutputLayout*(): ptr WlrOutputLayout {.importc: "wlr_output_layout_create".}
proc destroy*(layout: ptr WlrOutputLayout) {.importc: "wlr_output_layout_destroy".}
proc get*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput): ptr WlrOutputLayoutOutput {.importc: "wlr_output_layout_get".}
proc outputAt*(layout: ptr WlrOutputLayout; lx: cdouble; ly: cdouble): ptr WlrOutput {.importc: "wlr_output_layout_output_at".}
proc add*(layout: ptr WlrOutputLayout; output: ptr WlrOutput; lx: cint; ly: cint) {.importc: "wlr_output_layout_add".}
proc move*(layout: ptr WlrOutputLayout; output: ptr WlrOutput; lx: cint; ly: cint) {.importc: "wlr_output_layout_move".}
proc remove*(layout: ptr WlrOutputLayout; output: ptr WlrOutput) {.importc: "wlr_output_layout_remove".}
proc outputCoords*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput; lx: ptr cdouble; ly: ptr cdouble) {.importc: "wlr_output_layout_output_coords".}
proc containsPoint*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput; lx: cint; ly: cint): bool {.importc: "wlr_output_layout_contains_point".}
proc intersects*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput; target_lbox: ptr WlrBox): bool {.importc: "wlr_output_layout_intersects".}
proc closestPoint*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput; lx: cdouble; ly: cdouble; dest_lx: ptr cdouble; dest_ly: ptr cdouble) {.importc: "wlr_output_layout_closest_point".}
proc getBox*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput): ptr WlrBox {.importc: "wlr_output_layout_get_box".}
proc addAuto*(layout: ptr WlrOutputLayout; output: ptr WlrOutput) {.importc: "wlr_output_layout_add_auto".}
proc getCenterOutput*(layout: ptr WlrOutputLayout): ptr WlrOutput {.importc: "wlr_output_layout_get_center_output".}

type WlrDirection* = enum
  WLR_DIRECTION_UP = 1 shl 0,
  WLR_DIRECTION_DOWN = 1 shl 1,
  WLR_DIRECTION_LEFT = 1 shl 2,
  WLR_DIRECTION_RIGHT = 1 shl 3

proc adjacentOutput*(layout: ptr WlrOutputLayout; direction: WlrDirection; reference: ptr WlrOutput; ref_lx: cdouble; ref_ly: cdouble): ptr WlrOutput {.importc: "wlr_output_layout_adjacent_output".}
proc farthestOutput*(layout: ptr WlrOutputLayout; direction: WlrDirection; reference: ptr WlrOutput; ref_lx: cdouble; ref_ly: cdouble): ptr WlrOutput {.importc: "wlr_output_layout_farthest_output".}

## wlr_cursor

type
  WlrCursor* {.bycopy.} = object
    state*: ptr WlrCursorState
    x*, y*: cdouble
    events*: WlrCursor_events
    data*: pointer

  WlrCursor_events* {.bycopy.} = object
    motion*: WlSignal
    motion_absolute*: WlSignal
    button*: WlSignal
    axis*: WlSignal
    frame*: WlSignal
    swipe_begin*: WlSignal
    swipe_update*: WlSignal
    swipe_end*: WlSignal
    pinch_begin*: WlSignal
    pinch_update*: WlSignal
    pinch_end*: WlSignal
    hold_begin*: WlSignal
    hold_end*: WlSignal
    touch_up*: WlSignal
    touch_down*: WlSignal
    touch_motion*: WlSignal
    touch_cancel*: WlSignal
    touch_frame*: WlSignal
    tablet_tool_axis*: WlSignal
    tablet_tool_proximity*: WlSignal
    tablet_tool_tip*: WlSignal
    tablet_tool_button*: WlSignal

proc createWlrCursor*(): ptr WlrCursor {.importc: "wlr_cursor_create".}
proc destroy*(cur: ptr WlrCursor) {.importc: "wlr_cursor_destroy".}
proc warp*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; lx: cdouble; ly: cdouble): bool {.importc: "wlr_cursor_warp".}
proc absoluteToLayoutCoords*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; x: cdouble; y: cdouble; lx: ptr cdouble; ly: ptr cdouble) {.importc: "wlr_cursor_absolute_to_layout_coords".}
proc warpClosest*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; x: cdouble; y: cdouble) {.importc: "wlr_cursor_warp_closest".}
proc warpAbsolute*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; x: cdouble; y: cdouble) {.importc: "wlr_cursor_warp_absolute".}
proc move*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; delta_x: cdouble; delta_y: cdouble) {.importc: "wlr_cursor_move".}
proc setImage*(cur: ptr WlrCursor; pixels: ptr uint8; stride: int32; width: uint32; height: uint32; hotspot_x: int32; hotspot_y: int32; scale: cfloat) {.importc: "wlr_cursor_set_image".}
proc setSurface*(cur: ptr WlrCursor; surface: ptr WlrSurface; hotspot_x: int32; hotspot_y: int32) {.importc: "wlr_cursor_set_surface".}
proc attachInputDevice*(cur: ptr WlrCursor; dev: ptr WlrInputDevice) {.importc: "wlr_cursor_attach_input_device".}
proc detachInputDevice*(cur: ptr WlrCursor; dev: ptr WlrInputDevice) {.importc: "wlr_cursor_detach_input_device".}
proc attachOutputLayout*(cur: ptr WlrCursor; l: ptr WlrOutputLayout) {.importc: "wlr_cursor_attach_output_layout".}
proc mapToOutput*(cur: ptr WlrCursor; output: ptr WlrOutput) {.importc: "wlr_cursor_map_to_output".}
proc mapInputToOutput*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; output: ptr WlrOutput) {.importc: "wlr_cursor_map_input_to_output".}
proc mapToRegion*(cur: ptr WlrCursor; box: ptr WlrBox) {.importc: "wlr_cursor_map_to_region".}
proc mapInputToRegion*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; box: ptr WlrBox) {.importc: "wlr_cursor_map_input_to_region".}

## wlr_primary_selection

type
  WlrPrimarySelectionSource* {.bycopy.} = object
    impl*: ptr WlrPrimarySelectionSource_impl
    mime_types*: WlArray
    events*: WlrPrimarySelectionSource_events
    data*: pointer

  WlrPrimarySelectionSource_impl* {.bycopy.} = object
    send*: proc (source: ptr WlrPrimarySelectionSource; mime_type: cstring; fd: cint)
    destroy*: proc (source: ptr WlrPrimarySelectionSource)

  WlrPrimarySelectionSource_events* {.bycopy.} = object
    destroy*: WlSignal

## wlr_seat

const WLR_SERIAL_RINGSET_SIZE* = 128

type WlrSerialRange* {.bycopy.} = object
  min_incl*: uint32
  max_incl*: uint32

type WlrSerialRingset* {.bycopy.} = object
  data*: array[WLR_SERIAL_RINGSET_SIZE, WlrSerialRange]
  `end`*: cint
  count*: cint

const WLR_POINTER_BUTTONS_CAP* = 16

type
  WlrSeat* {.bycopy.} = object
    global*: ptr WlGlobal
    display*: ptr WlDisplay
    clients*: WlList
    name*: cstring
    capabilities*: uint32
    accumulated_capabilities*: uint32
    last_event*: Timespec
    selection_source*: ptr WlrDataSource
    selection_serial*: uint32
    selection_offers*: WlList
    primary_selection_source*: ptr WlrPrimarySelectionSource
    primary_selection_serial*: uint32
    drag*: ptr WlrDrag
    drag_source*: ptr WlrDataSource
    drag_serial*: uint32
    drag_offers*: WlList
    pointer_state*: WlrSeatPointerState
    keyboard_state*: WlrSeatKeyboardState
    touch_state*: WlrSeatTouchState
    display_destroy*: WlListener
    selection_source_destroy*: WlListener
    primary_selection_source_destroy*: WlListener
    drag_source_destroy*: WlListener
    events*: WlrSeat_events
    data*: pointer

  WlrSeatPointerState* {.bycopy.} = object
    seat*: ptr WlrSeat
    focused_client*: ptr WlrSeatClient
    focused_surface*: ptr WlrSurface
    sx*, sy*: cdouble
    grab*: ptr WlrSeatPointerGrab
    default_grab*: ptr WlrSeatPointerGrab
    sent_axis_source*: bool
    cached_axis_source*: WlrAxisSource
    buttons*: array[WLR_POINTER_BUTTONS_CAP, uint32]
    button_count*: csize_t
    grab_button*: uint32
    grab_serial*: uint32
    grab_time*: uint32
    surface_destroy*: WlListener
    events*: WlrSeatPointerState_events

  WlrSeatPointerState_events* {.bycopy.} = object
    focus_change*: WlSignal

  WlrSeatKeyboardState* {.bycopy.} = object
    seat*: ptr WlrSeat
    keyboard*: ptr WlrKeyboard
    focused_client*: ptr WlrSeatClient
    focused_surface*: ptr WlrSurface
    keyboard_destroy*: WlListener
    keyboard_keymap*: WlListener
    keyboard_repeat_info*: WlListener
    surface_destroy*: WlListener
    grab*: ptr WlrSeatKeyboardGrab
    default_grab*: ptr WlrSeatKeyboardGrab
    events*: WlrSeatKeyboardState_events

  WlrSeatKeyboardState_events* {.bycopy.} = object
    focus_change*: WlSignal

  WlrSeatTouchState* {.bycopy.} = object
    seat*: ptr WlrSeat
    touch_points*: WlList
    grab_serial*: uint32
    grab_id*: uint32
    grab*: ptr WlrSeatTouchGrab
    default_grab*: ptr WlrSeatTouchGrab

  WlrSeat_events* {.bycopy.} = object
    pointer_grab_begin*: WlSignal
    pointer_grab_end*: WlSignal
    keyboard_grab_begin*: WlSignal
    keyboard_grab_end*: WlSignal
    touch_grab_begin*: WlSignal
    touch_grab_end*: WlSignal
    request_set_cursor*: WlSignal
    request_set_selection*: WlSignal
    set_selection*: WlSignal
    request_set_primary_selection*: WlSignal
    set_primary_selection*: WlSignal
    request_start_drag*: WlSignal
    start_drag*: WlSignal
    destroy*: WlSignal

  WlrSeatClient* {.bycopy.} = object
    client*: ptr WlClient
    seat*: ptr WlrSeat
    link*: WlList
    resources*: WlList
    pointers*: WlList
    keyboards*: WlList
    touches*: WlList
    data_devices*: WlList
    events*: WlrSeatClient_events
    serials*: WlrSerialRingset
    needs_touch_frame*: bool

  WlrSeatClient_events* {.bycopy.} = object
    destroy*: WlSignal

  WlrTouchPoint* {.bycopy.} = object
    touch_id*: int32
    surface*: ptr WlrSurface
    client*: ptr WlrSeatClient
    focus_surface*: ptr WlrSurface
    focus_client*: ptr WlrSeatClient
    sx*, sy*: cdouble
    surface_destroy*: WlListener
    focus_surface_destroy*: WlListener
    client_destroy*: WlListener
    events*: WlrTouchPoint_events
    link*: WlList

  WlrTouchPoint_events* {.bycopy.} = object
    destroy*: WlSignal

  WlrSeatTouchGrab* {.bycopy.} = object
    `interface`*: ptr WlrTouchGrab_interface
    seat*: ptr WlrSeat
    data*: pointer

  WlrTouchGrabInterface* {.bycopy.} = object
    down*: proc (grab: ptr WlrSeatTouchGrab; time_msec: uint32; point: ptr WlrTouchPoint): uint32
    up*: proc (grab: ptr WlrSeatTouchGrab; time_msec: uint32; point: ptr WlrTouchPoint)
    motion*: proc (grab: ptr WlrSeatTouchGrab; time_msec: uint32; point: ptr WlrTouchPoint)
    enter*: proc (grab: ptr WlrSeatTouchGrab; time_msec: uint32; point: ptr WlrTouchPoint)
    frame*: proc (grab: ptr WlrSeatTouchGrab)
    cancel*: proc (grab: ptr WlrSeatTouchGrab)

  WlrSeatKeyboardGrab* {.bycopy.} = object
    `interface`*: ptr WlrKeyboardGrab_interface
    seat*: ptr WlrSeat
    data*: pointer

  WlrKeyboardGrabInterface* {.bycopy.} = object
    enter*: proc (grab: ptr WlrSeatKeyboardGrab; surface: ptr WlrSurface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr WlrKeyboard_modifiers)
    clear_focus*: proc (grab: ptr WlrSeatKeyboardGrab)
    key*: proc (grab: ptr WlrSeatKeyboardGrab; time_msec: uint32; key: uint32; state: uint32)
    modifiers*: proc (grab: ptr WlrSeatKeyboardGrab; modifiers: ptr WlrKeyboard_modifiers)
    cancel*: proc (grab: ptr WlrSeatKeyboardGrab)

  WlrSeatPointerGrab* {.bycopy.} = object
    `interface`*: ptr WlrPointerGrab_interface
    seat*: ptr WlrSeat
    data*: pointer

  WlrPointerGrabInterface* {.bycopy.} = object
    enter*: proc (grab: ptr WlrSeatPointerGrab; surface: ptr WlrSurface; sx: cdouble; sy: cdouble)
    clear_focus*: proc (grab: ptr WlrSeatPointerGrab)
    motion*: proc (grab: ptr WlrSeatPointerGrab; time_msec: uint32; sx: cdouble; sy: cdouble)
    button*: proc (grab: ptr WlrSeatPointerGrab; time_msec: uint32; button: uint32; state: WlrButtonState): uint32
    axis*: proc (grab: ptr WlrSeatPointerGrab; time_msec: uint32; orientation: WlrAxisOrientation; value: cdouble; value_discrete: int32; source: WlrAxisSource)
    frame*: proc (grab: ptr WlrSeatPointerGrab)
    cancel*: proc (grab: ptr WlrSeatPointerGrab)

  WlrDataSource* {.bycopy.} = object
    impl*: ptr WlrDataSource_impl
    mime_types*: WlArray
    actions*: int32
    accepted*: bool
    current_dnd_action*: WlDataDeviceManagerDndAction
    compositor_action*: uint32
    events*: WlrDataSource_events

  WlrDataSource_impl* {.bycopy.} = object
    send*: proc (source: ptr WlrDataSource; mime_type: cstring; fd: int32)
    accept*: proc (source: ptr WlrDataSource; serial: uint32; mime_type: cstring)
    destroy*: proc (source: ptr WlrDataSource)
    dnd_drop*: proc (source: ptr WlrDataSource)
    dnd_finish*: proc (source: ptr WlrDataSource)
    dnd_action*: proc (source: ptr WlrDataSource; action: WlDataDeviceManagerDndAction)

  WlrDataSource_events* {.bycopy.} = object
    destroy*: WlSignal

  WlrDrag* {.bycopy.} = object
    grab_type*: WlrDragGrabType
    keyboard_grab*: WlrSeatKeyboardGrab
    pointer_grab*: WlrSeatPointerGrab
    touch_grab*: WlrSeatTouchGrab
    seat*: ptr WlrSeat
    seat_client*: ptr WlrSeatClient
    focus_client*: ptr WlrSeatClient
    icon*: ptr WlrDragIcon
    focus*: ptr WlrSurface
    source*: ptr WlrDataSource
    started*: bool
    dropped*: bool
    cancelling*: bool
    grab_touch_id*: int32
    touch_id*: int32
    events*: WlrDrag_events
    source_destroy*: WlListener
    seat_client_destroy*: WlListener
    icon_destroy*: WlListener
    data*: pointer

  WlrDrag_events* {.bycopy.} = object
    focus*: WlSignal
    motion*: WlSignal
    drop*: WlSignal
    destroy*: WlSignal

  WlrDragIcon* {.bycopy.} = object
    drag*: ptr WlrDrag
    surface*: ptr WlrSurface
    mapped*: bool
    events*: WlrDragIcon_events
    surface_destroy*: WlListener
    data*: pointer

  WlrDragIcon_events* {.bycopy.} = object
    map*: WlSignal
    unmap*: WlSignal
    destroy*: WlSignal

  WlrDragGrabType* = enum
    WLR_DRAG_GRAB_KEYBOARD,
    WLR_DRAG_GRAB_KEYBOARD_POINTER,
    WLR_DRAG_GRAB_KEYBOARD_TOUCH

## wlr_primary_selection

proc init*(source: ptr WlrPrimarySelectionSource; impl: ptr WlrPrimarySelectionSource_impl) {.importc: "wlr_primary_selection_source_init".}
proc destroy*(source: ptr WlrPrimarySelectionSource) {.importc: "wlr_primary_selection_source_destroy".}
proc send*(source: ptr WlrPrimarySelectionSource; mime_type: cstring; fd: cint) {.importc: "wlr_primary_selection_source_send".}
proc requestSetPrimarySelection*(seat: ptr WlrSeat; client: ptr WlrSeatClient; source: ptr WlrPrimarySelectionSource; serial: uint32) {.importc: "wlr_seat_request_set_primary_selection".}
proc setPrimarySelection*(seat: ptr WlrSeat; source: ptr WlrPrimarySelectionSource; serial: uint32) {.importc: "wlr_seat_set_primary_selection".}

## wlr_data_device

type
  WlrDataDeviceManager* {.bycopy.} = object
    global*: ptr WlGlobal
    data_sources*: WlList
    display_destroy*: WlListener
    events*: WlrDataDeviceManager_events
    data*: pointer

  WlrDataDeviceManager_events* {.bycopy.} = object
    destroy*: WlSignal

type
  WlrDataOffer* {.bycopy.} = object
    resource*: ptr WlResource
    source*: ptr WlrDataSource
    `type`*: WlrDataOfferType
    link*: WlList
    actions*: uint32
    preferred_action*: WlDataDeviceManagerDndAction
    in_ask*: bool
    source_destroy*: WlListener

  WlrDataOfferType* = enum
    WLR_DATA_OFFER_SELECTION, WLR_DATA_OFFER_DRAG

type WlrDragMotionEvent* {.bycopy.} = object
  drag*: ptr WlrDrag
  time*: uint32
  sx*, sy*: cdouble

type WlrDragDropEvent* {.bycopy.} = object
  drag*: ptr WlrDrag
  time*: uint32

proc createWlrDataDeviceManager*(display: ptr WlDisplay): ptr WlrDataDeviceManager {.importc: "wlr_data_device_manager_create".}
proc requestSetSelection*(seat: ptr WlrSeat; client: ptr WlrSeatClient; source: ptr WlrDataSource; serial: uint32) {.importc: "wlr_seat_request_set_selection".}
proc setSelection*(seat: ptr WlrSeat; source: ptr WlrDataSource; serial: uint32) {.importc: "wlr_seat_set_selection".}

proc createWlrDrag*(seat_client: ptr WlrSeatClient; source: ptr WlrDataSource; icon_surface: ptr WlrSurface): ptr WlrDrag {.importc: "wlr_drag_create".}
proc requestStartDrag*(seat: ptr WlrSeat; drag: ptr WlrDrag; origin: ptr WlrSurface; serial: uint32) {.importc: "wlr_seat_request_start_drag".}

proc startDrag*(seat: ptr WlrSeat; drag: ptr WlrDrag; serial: uint32) {.importc: "wlr_seat_start_drag".}
proc startPointerDrag*(seat: ptr WlrSeat; drag: ptr WlrDrag; serial: uint32) {.importc: "wlr_seat_start_pointer_drag".}
proc startTouchDrag*(seat: ptr WlrSeat; drag: ptr WlrDrag; serial: uint32; point: ptr WlrTouchPoint) {.importc: "wlr_seat_start_touch_drag".}

proc init*(source: ptr WlrDataSource; impl: ptr WlrDataSource_impl) {.importc: "wlr_data_source_init".}
proc send*(source: ptr WlrDataSource; mime_type: cstring; fd: int32) {.importc: "wlr_data_source_send".}
proc accept*(source: ptr WlrDataSource; serial: uint32; mime_type: cstring) {.importc: "wlr_data_source_accept".}
proc destroy*(source: ptr WlrDataSource) {.importc: "wlr_data_source_destroy".}

proc dndDrop*(source: ptr WlrDataSource) {.importc: "wlr_data_source_dnd_drop".}
proc dndFinish*(source: ptr WlrDataSource) {.importc: "wlr_data_source_dnd_finish".}
proc dndAction*(source: ptr WlrDataSource; action: WlDataDeviceManagerDndAction) {.importc: "wlr_data_source_dnd_action".}

## wlr_data_device
var WlrDataDevicePointerDragInterface*: WlrPointerGrabInterface
var WlrDataDeviceKeyboardDragInterface*: WlrKeyboardGrabInterface
var WlrDataDeviceTouchDragInterface*: WlrTouchGrabInterface

type WlrSeatPointerRequestSetCurserEvent* {.bycopy.} = object
  seat_client*: ptr WlrSeatClient
  surface*: ptr WlrSurface
  serial*: uint32
  hotspot_x*, hotspot_y*: int32

type WlrSeatRequestSetSelectionEvent* {.bycopy.} = object
  source*: ptr WlrDataSource
  serial*: uint32

type WlrSeatRequestSetPrimarySelectionEvent* {.bycopy.} = object
  source*: ptr WlrPrimarySelectionSource
  serial*: uint32

type WlrSeatRequestStartDragEvent* {.bycopy.} = object
  drag*: ptr WlrDrag
  origin*: ptr WlrSurface
  serial*: uint32

type WlrSeatPointerFocusChangeEvent* {.bycopy.} = object
  seat*: ptr WlrSeat
  old_surface*: ptr WlrSurface
  new_surface*: ptr WlrSurface
  sx*, sy*: cdouble

type WlrSeatKeyboardFocusChangeEvent* {.bycopy.} = object
  seat*: ptr WlrSeat
  old_surface*: ptr WlrSurface
  new_surface*: ptr WlrSurface

proc createWlrSeat*(display: ptr WlDisplay; name: cstring): ptr WlrSeat {.importc: "wlr_seat_create".}
proc destroy*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_destroy".}
proc clientForWlClient*(wlr_seat: ptr WlrSeat; wl_client: ptr WlClient): ptr WlrSeatClient {.importc: "wlr_seat_client_for_wl_client".}
proc setCapabilities*(wlr_seat: ptr WlrSeat; capabilities: uint32) {.importc: "wlr_seat_set_capabilities".}
proc setName*(wlr_seat: ptr WlrSeat; name: cstring) {.importc: "wlr_seat_set_name".}

proc pointerSurfaceHasFocus*(wlr_seat: ptr WlrSeat; surface: ptr WlrSurface): bool {.importc: "wlr_seat_pointer_surface_has_focus".}
proc pointerEnter*(wlr_seat: ptr WlrSeat; surface: ptr WlrSurface; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_enter".}
proc pointerClearFocus*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_clear_focus".}
proc pointerSendMotion*(wlr_seat: ptr WlrSeat; time_msec: uint32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_send_motion".}
proc pointerSendButton*(wlr_seat: ptr WlrSeat; time_msec: uint32; button: uint32; state: WlrButtonState): uint32 {.importc: "wlr_seat_pointer_send_button".}
proc pointerSendAxis*(wlr_seat: ptr WlrSeat; time_msec: uint32; orientation: WlrAxisOrientation; value: cdouble; value_discrete: int32; source: WlrAxisSource) {.importc: "wlr_seat_pointer_send_axis".}
proc pointerSendFrame*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_send_frame".}
proc pointerNotifyEnter*(wlr_seat: ptr WlrSeat; surface: ptr WlrSurface; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_notify_enter".}
proc pointerNotifyClearFocus*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_notify_clear_focus".}
proc pointerWarp*(wlr_seat: ptr WlrSeat; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_warp".}
proc pointerNotifyMotion*(wlr_seat: ptr WlrSeat; time_msec: uint32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_notify_motion".}
proc pointerNotifyButton*(wlr_seat: ptr WlrSeat; time_msec: uint32; button: uint32; state: WlrButtonState): uint32 {.importc: "wlr_seat_pointer_notify_button".}
proc pointerNotifyAxis*(wlr_seat: ptr WlrSeat; time_msec: uint32; orientation: WlrAxisOrientation; value: cdouble; value_discrete: int32; source: WlrAxisSource) {.importc: "wlr_seat_pointer_notify_axis".}
proc pointerNotifyFrame*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_notify_frame".}
proc pointerStartGrab*(wlr_seat: ptr WlrSeat; grab: ptr WlrSeatPointerGrab) {.importc: "wlr_seat_pointer_start_grab".}
proc pointerEndGrab*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_end_grab".}
proc pointerHasGrab*(seat: ptr WlrSeat): bool {.importc: "wlr_seat_pointer_has_grab".}

proc setKeyboard*(seat: ptr WlrSeat; dev: ptr WlrInputDevice) {.importc: "wlr_seat_set_keyboard".}
proc getKeyboard*(seat: ptr WlrSeat): ptr WlrKeyboard {.importc: "wlr_seat_get_keyboard".}

proc keyboardSendKey*(seat: ptr WlrSeat; time_msec: uint32; key: uint32; state: uint32) {.importc: "wlr_seat_keyboard_send_key".}
proc keyboardSendModifiers*(seat: ptr WlrSeat; modifiers: ptr WlrKeyboard_modifiers) {.importc: "wlr_seat_keyboard_send_modifiers".}
proc keyboardEnter*(seat: ptr WlrSeat; surface: ptr WlrSurface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr WlrKeyboard_modifiers) {.importc: "wlr_seat_keyboard_enter".}
proc keyboardClearFocus*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_keyboard_clear_focus".}
proc keyboardNotifyKey*(seat: ptr WlrSeat; time_msec: uint32; key: uint32; state: uint32) {.importc: "wlr_seat_keyboard_notify_key".}
proc keyboardNotifyModifiers*(seat: ptr WlrSeat; modifiers: ptr WlrKeyboard_modifiers) {.importc: "wlr_seat_keyboard_notify_modifiers".}
proc keyboardNotifyEnter*(seat: ptr WlrSeat; surface: ptr WlrSurface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr WlrKeyboard_modifiers) {.importc: "wlr_seat_keyboard_notify_enter".}
proc keyboardNotifyClearFocus*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_keyboard_notify_clear_focus".}
proc keyboardStartGrab*(wlr_seat: ptr WlrSeat; grab: ptr WlrSeatKeyboardGrab) {.importc: "wlr_seat_keyboard_start_grab".}
proc keyboardEndGrab*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_keyboard_end_grab".}
proc keyboardHasGrab*(seat: ptr WlrSeat): bool {.importc: "wlr_seat_keyboard_has_grab".}

proc touchGetPoint*(seat: ptr WlrSeat; touch_id: int32): ptr WlrTouchPoint {.importc: "wlr_seat_touch_get_point".}
proc touchPointFocus*(seat: ptr WlrSeat; surface: ptr WlrSurface; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_touch_point_focus".}
proc touchPointClearFocus*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32) {.importc: "wlr_seat_touch_point_clear_focus".}
proc touchSendDown*(seat: ptr WlrSeat; surface: ptr WlrSurface; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble): uint32 {.importc: "wlr_seat_touch_send_down".}
proc touchSendUp*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32) {.importc: "wlr_seat_touch_send_up".}
proc touchSendMotion*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_touch_send_motion".}
proc touchSendFrame*(seat: ptr WlrSeat) {.importc: "wlr_seat_touch_send_frame".}
proc touchNotifyDown*(seat: ptr WlrSeat; surface: ptr WlrSurface; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble): uint32 {.importc: "wlr_seat_touch_notify_down".}
proc touchNotifyUp*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32) {.importc: "wlr_seat_touch_notify_up".}
proc touchNotifyMotion*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_touch_notify_motion".}
proc touchNotifyFrame*(seat: ptr WlrSeat) {.importc: "wlr_seat_touch_notify_frame".}
proc touchNumPoints*(seat: ptr WlrSeat): cint {.importc: "wlr_seat_touch_num_points".}
proc touchStartGrab*(wlr_seat: ptr WlrSeat; grab: ptr WlrSeatTouchGrab) {.importc: "wlr_seat_touch_start_grab".}
proc touchEndGrab*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_touch_end_grab".}
proc touchHasGrab*(seat: ptr WlrSeat): bool {.importc: "wlr_seat_touch_has_grab".}

proc validateGrabSerial*(seat: ptr WlrSeat; serial: uint32): bool {.importc: "wlr_seat_validate_grab_serial".}
proc validatePointerGrabSerial*(seat: ptr WlrSeat; origin: ptr WlrSurface; serial: uint32): bool {.importc: "wlr_seat_validate_pointer_grab_serial".}
proc validateTouchGrabSerial*(seat: ptr WlrSeat; origin: ptr WlrSurface; serial: uint32; point_ptr: ptr ptr WlrTouchPoint): bool {.importc: "wlr_seat_validate_touch_grab_serial".}
proc nextSerial*(client: ptr WlrSeatClient): uint32 {.importc: "wlr_seat_client_next_serial".}
proc validateEventSerial*(client: ptr WlrSeatClient; serial: uint32): bool {.importc: "wlr_seat_client_validate_event_serial".}
proc wlrSeatClient*(resource: ptr WlResource): ptr WlrSeatClient {.importc: "wlr_seat_client_from_resource".}
proc wlrSeatClientFromPointerResource*(resource: ptr WlResource): ptr WlrSeatClient {.importc: "wlr_seat_client_from_pointer_resource".}
proc acceptsTouch*(wlr_seat: ptr WlrSeat; surface: ptr WlrSurface): bool {.importc: "wlr_surface_accepts_touch".}

## wlr_data_control_v1

type
  WlrDataControlManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    devices*: WlList
    events*: WlrDataControlManager_v1_events
    display_destroy*: WlListener

  WlrDataControlManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    new_device*: WlSignal

type WlrDataControlDevice_v1* {.bycopy.} = object
  resource*: ptr WlResource
  manager*: ptr WlrDataControlManager_v1
  link*: WlList
  seat*: ptr WlrSeat
  selection_offer_resource*: ptr WlResource
  primary_selection_offer_resource*: ptr WlResource
  seat_destroy*: WlListener
  seat_set_selection*: WlListener
  seat_set_primary_selection*: WlListener

proc createWlrDataControlManager_v1*(display: ptr WlDisplay): ptr WlrDataControlManager_v1 {.importc: "wlr_data_control_manager_v1_create".}
proc destroy*(device: ptr WlrDataControlDevice_v1) {.importc: "wlr_data_control_device_v1_destroy".}

## wlr_drm_lease_v1

type
  WlrDrmLeaseDevice_v1* {.bycopy.} = object
    resources*: WlList
    global*: ptr WlGlobal
    manager*: ptr WlrDrmLease_v1_manager
    backend*: ptr WlrBackend
    connectors*: WlList
    leases*: WlList
    requests*: WlList
    link*: WlList
    backend_destroy*: WlListener
    data*: pointer

  WlrDrmLease_v1_manager* {.bycopy.} = object
    devices*: WlList
    display*: ptr WlDisplay
    display_destroy*: WlListener
    events*: WlrDrmLease_v1_manager_events

  WlrDrmLease_v1_manager_events* {.bycopy.} = object
    request*: WlSignal

type
  WlrDrmLease_v1* {.bycopy.} = object
    resource*: ptr WlResource
    drm_lease*: ptr WlrDrmLease
    device*: ptr WlrDrmLeaseDevice_v1
    connectors*: ptr ptr WlrDrmLeaseConnector_v1
    n_connectors*: csize_t
    link*: WlList
    destroy*: WlListener
    data*: pointer

  WlrDrmLeaseConnector_v1* {.bycopy.} = object
    resources*: WlList
    output*: ptr WlrOutput
    device*: ptr WlrDrmLeaseDevice_v1
    active_lease*: ptr WlrDrmLease_v1
    destroy*: WlListener
    link*: WlList

  WlrDrmLeaseRequest_v1* {.bycopy.} = object
    resource*: ptr WlResource
    device*: ptr WlrDrmLeaseDevice_v1
    connectors*: ptr ptr WlrDrmLeaseConnector_v1
    n_connectors*: csize_t
    lease*: ptr WlrDrmLease_v1
    invalid*: bool
    link*: WlList

proc createWlrDrmLease_v1_manager*(display: ptr WlDisplay; backend: ptr WlrBackend): ptr WlrDrmLease_v1_manager {.importc: "wlr_drm_lease_v1_manager_create".}

proc offerOutput*(manager: ptr WlrDrmLease_v1_manager; output: ptr WlrOutput): bool {.importc: "wlr_drm_lease_v1_manager_offer_output".}
proc withdrawOutput*(manager: ptr WlrDrmLease_v1_manager; output: ptr WlrOutput) {.importc: "wlr_drm_lease_v1_manager_withdraw_output".}

proc grant*(request: ptr WlrDrmLeaseRequest_v1): ptr WlrDrmLease_v1 {.importc: "wlr_drm_lease_request_v1_grant".}
proc reject*(request: ptr WlrDrmLeaseRequest_v1) {.importc: "wlr_drm_lease_request_v1_reject".}
proc revoke*(lease: ptr WlrDrmLease_v1) {.importc: "wlr_drm_lease_v1_revoke".}

## wlr_drm

type WlrDrmBuffer* {.bycopy.} = object
  base*: WlrBuffer
  resource*: ptr WlResource
  dmabuf*: WlrDmabufAttributes
  release*: WlListener

type
  WlrDrm* {.bycopy.} = object
    global*: ptr WlGlobal
    renderer*: ptr WlrRenderer
    node_name*: cstring
    events*: WlrDrm_events
    display_destroy*: WlListener
    renderer_destroy*: WlListener

  WlrDrm_events* {.bycopy.} = object
    destroy*: WlSignal

proc isResourceWlrDrmBuffer*(resource: ptr WlResource): bool {.importc: "wlr_drm_buffer_is_resource".}
proc fromResourceWlrDrmBuffer*(resource: ptr WlResource): ptr WlrDrmBuffer {.importc: "wlr_drm_buffer_from_resource".}
proc createWlrDrm*(display: ptr WlDisplay; renderer: ptr WlrRenderer): ptr WlrDrm {.importc: "wlr_drm_create".}

## wlr_export_dmabuf_v1

type
  WlrExportDmabufManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    frames*: WlList
    display_destroy*: WlListener
    events*: WlrExportDmabufManager_v1_events

  WlrExportDmabufManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrExportDmabufFrame_v1* {.bycopy.} = object
  resource*: ptr WlResource
  manager*: ptr WlrExportDmabufManager_v1
  link*: WlList
  output*: ptr WlrOutput
  cursor_locked*: bool
  output_commit*: WlListener

proc createWlrExportDmabufManager_v1*(display: ptr WlDisplay): ptr WlrExportDmabufManager_v1 {.importc: "wlr_export_dmabuf_manager_v1_create".}

## wlr_foreign_toplevel_manager

type
  WlrForeignToplevelManager_v1* {.bycopy.} = object
    event_loop*: ptr WlEventLoop
    global*: ptr WlGlobal
    resources*: WlList
    toplevels*: WlList
    display_destroy*: WlListener
    events*: WlrForeignToplevelManager_v1_events
    data*: pointer

  WlrForeignToplevelManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrForeignToplevelHandle_v1_state* = enum
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MAXIMIZED = (1 shl 0),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MINIMIZED = (1 shl 1),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_ACTIVATED = (1 shl 2),
  WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_FULLSCREEN = (1 shl 3)

type
  WlrForeignToplevelHandle_v1* {.bycopy.} = object
    manager*: ptr WlrForeignToplevelManager_v1
    resources*: WlList
    link*: WlList
    idle_source*: ptr WlEventSource
    title*: cstring
    app_id*: cstring
    parent*: ptr WlrForeignToplevelHandle_v1
    outputs*: WlList
    state*: uint32
    events*: WlrForeignToplevelHandle_v1_events
    data*: pointer

  WlrForeignToplevelHandle_v1_events* {.bycopy.} = object
    request_maximize*: WlSignal
    request_minimize*: WlSignal
    request_activate*: WlSignal
    request_fullscreen*: WlSignal
    request_close*: WlSignal
    set_rectangle*: WlSignal
    destroy*: WlSignal

type WlrForeignToplevelHandle_v1_output* {.bycopy.} = object
  link*: WlList
  output*: ptr WlrOutput
  toplevel*: ptr WlrForeignToplevelHandle_v1
  output_bind*: WlListener
  output_destroy*: WlListener

type WlrForeignToplevelHandle_v1_maximized_event* {.bycopy.} = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  maximized*: bool

type WlrForeignToplevelHandle_v1_minimized_event* {.bycopy.} = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  minimized*: bool

type WlrForeignToplevelHandle_v1_activated_event* {.bycopy.} = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  seat*: ptr WlrSeat

type WlrForeignToplevelHandle_v1_fullscreen_event* {.bycopy.} = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  fullscreen*: bool
  output*: ptr WlrOutput

type WlrForeignToplevelHandle_v1_set_rectangle_event* {.bycopy.} = object
  toplevel*: ptr WlrForeignToplevelHandle_v1
  surface*: ptr WlrSurface
  x*, y*: int32
  width*, height*: int32

proc createWlrForeignToplevelManager_v1*(display: ptr WlDisplay): ptr WlrForeignToplevelManager_v1 {.importc: "wlr_foreign_toplevel_manager_v1_create".}
proc createWlrForeignToplevelHandle_v1*(manager: ptr WlrForeignToplevelManager_v1): ptr WlrForeignToplevelHandle_v1 {.importc: "wlr_foreign_toplevel_handle_v1_create".}

proc destroy*(toplevel: ptr WlrForeignToplevelHandle_v1) {.importc: "wlr_foreign_toplevel_handle_v1_destroy".}
proc setTitle*(toplevel: ptr WlrForeignToplevelHandle_v1; title: cstring) {.importc: "wlr_foreign_toplevel_handle_v1_set_title".}
proc setAppId*(toplevel: ptr WlrForeignToplevelHandle_v1; app_id: cstring) {.importc: "wlr_foreign_toplevel_handle_v1_set_app_id".}
proc outputEnter*(toplevel: ptr WlrForeignToplevelHandle_v1; output: ptr WlrOutput) {.importc: "wlr_foreign_toplevel_handle_v1_output_enter".}
proc outputLeave*(toplevel: ptr WlrForeignToplevelHandle_v1; output: ptr WlrOutput) {.importc: "wlr_foreign_toplevel_handle_v1_output_leave".}
proc setMaximized*(toplevel: ptr WlrForeignToplevelHandle_v1; maximized: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_maximized".}
proc setMinimized*(toplevel: ptr WlrForeignToplevelHandle_v1; minimized: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_minimized".}
proc setActivated*(toplevel: ptr WlrForeignToplevelHandle_v1; activated: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_activated".}
proc setFullscreen*(toplevel: ptr WlrForeignToplevelHandle_v1; fullscreen: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_fullscreen".}

proc setParent*(toplevel: ptr WlrForeignToplevelHandle_v1; parent: ptr WlrForeignToplevelHandle_v1) {.importc: "wlr_foreign_toplevel_handle_v1_set_parent".}

## wlr_fullscreen_shell_v1

# import fullscreen-shell-unstable-v1-protocol

type
  WlrFullscreenShell_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    events*: WlrFullscreenShell_v1_events
    display_destroy*: WlListener
    data*: pointer

  WlrFullscreenShell_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    present_surface*: WlSignal

type WlrFullscreenShell_v1_present_surface_event* {.bycopy.} = object
  client*: ptr WlClient
  surface*: ptr WlrSurface
  `method`*: zwp_fullscreen_shell_v1_present_method
  output*: ptr WlrOutput

proc createWlrFullscreenShell_v1*(display: ptr WlDisplay): ptr WlrFullscreenShell_v1 {.importc: "wlr_fullscreen_shell_v1_create".}

type
  WlrGammaControlManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    controls*: WlList
    display_destroy*: WlListener
    events*: WlrGammaControlManager_v1_events
    data*: pointer

  WlrGammaControlManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrGammaControl_v1* {.bycopy.} = object
  resource*: ptr WlResource
  output*: ptr WlrOutput
  link*: WlList
  table*: ptr uint16
  ramp_size*: csize_t
  output_commit_listener*: WlListener
  output_destroy_listener*: WlListener
  data*: pointer

proc createWlrGammaControlManager_v1*(display: ptr WlDisplay): ptr WlrGammaControlManager_v1 {.importc: "wlr_gamma_control_manager_v1_create".}

## wlr_idle_inhibit_v1

type
  WlrIdleInhibitManager_v1* {.bycopy.} = object
    inhibitors*: WlList
    global*: ptr WlGlobal
    display_destroy*: WlListener
    events*: WllrIdleInhibitManager_v1_events
    data*: pointer

  WllrIdleInhibitManager_v1_events* {.bycopy.} = object
    new_inhibitor*: WlSignal
    destroy*: WlSignal

type
  WlrIdleInhibitor_v1* {.bycopy.} = object
    surface*: ptr WlrSurface
    resource*: ptr WlResource
    surface_destroy*: WlListener
    link*: WlList
    events*: WlrIdleInhibitor_v1_events
    data*: pointer

  WlrIdleInhibitor_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrIdleInhibit_v1*(display: ptr WlDisplay): ptr WlrIdleInhibitManager_v1 {.importc: "wlr_idle_inhibit_v1_create".}

## wlr_idle

type
  WlrIdle* {.bycopy.} = object
    global*: ptr WlGlobal
    idle_timers*: WlList
    event_loop*: ptr WlEventLoop
    enabled*: bool
    display_destroy*: WlListener
    events*: WlrIdle_events
    data*: pointer

  WlrIdle_events* {.bycopy.} = object
    activity_notify*: WlSignal
    destroy*: WlSignal

type
  WlrIdleTimeout* {.bycopy.} = object
    resource*: ptr WlResource
    link*: WlList
    seat*: ptr WlrSeat
    idle_source*: ptr WlEventSource
    idle_state*: bool
    enabled*: bool
    timeout*: uint32
    events*: WlrIdleTimeout_events
    input_listener*: WlListener
    seat_destroy*: WlListener
    data*: pointer

  WlrIdleTimeout_events* {.bycopy.} = object
    idle*: WlSignal
    resume*: WlSignal
    destroy*: WlSignal

proc createWlrIdle*(display: ptr WlDisplay): ptr WlrIdle {.importc: "wlr_idle_create".}
proc notifyActivity*(idle: ptr WlrIdle; seat: ptr WlrSeat) {.importc: "wlr_idle_notify_activity".}
proc setEnabled*(idle: ptr WlrIdle; seat: ptr WlrSeat; enabled: bool) {.importc: "wlr_idle_set_enabled".}
proc createWlrIdleTimeout*(idle: ptr WlrIdle; seat: ptr WlrSeat; timeout: uint32): ptr WlrIdleTimeout {.importc: "wlr_idle_timeout_create".}
proc destroy*(timeout: ptr WlrIdleTimeout) {.importc: "wlr_idle_timeout_destroy".}

## wlr_input_inhibitor

type
  WlrInputInhibitManager* {.bycopy.} = object
    global*: ptr WlGlobal
    active_client*: ptr WlClient
    active_inhibitor*: ptr WlResource
    display_destroy*: WlListener
    events*: WlrInputInhibitManager_events
    data*: pointer

  WlrInputInhibitManager_events* {.bycopy.} = object
    activate*: WlSignal
    deactivate*: WlSignal
    destroy*: WlSignal

proc createWlrInputInhibitManager*(display: ptr WlDisplay): ptr WlrInputInhibitManager {.importc: "wlr_input_inhibit_manager_create".}

## wlr_input_method_v2

type
  WlrInputMethod_v2* {.bycopy.} = object
    resource*: ptr WlResource
    seat*: ptr WlrSeat
    seat_client*: ptr WlrSeatClient
    pending*: WlrInputMethod_v2_state
    current*: WlrInputMethod_v2_state
    active*: bool
    client_active*: bool
    current_serial*: uint32
    popup_surfaces*: WlList
    keyboard_grab*: ptr WlrInputMethodKeyboardGrab_v2
    link*: WlList
    seat_client_destroy*: WlListener
    events*: WlrInputMethod_v2_events

  WlrInputMethod_v2_state* {.bycopy.} = object
    preedit*: WlrInputMethod_v2_preedit_string
    commit_text*: cstring
    delete*: WlrInputMethod_v2_delete_surrounding_text

  WlrInputMethod_v2_preedit_string* {.bycopy.} = object
    text*: cstring
    cursor_begin*: int32
    cursor_end*: int32

  WlrInputMethod_v2_delete_surrounding_text* {.bycopy.} = object
    before_length*: uint32
    after_length*: uint32

  WlrInputMethodKeyboardGrab_v2* {.bycopy.} = object
    resource*: ptr WlResource
    input_method*: ptr WlrInputMethod_v2
    keyboard*: ptr WlrKeyboard
    keyboard_keymap*: WlListener
    keyboard_repeat_info*: WlListener
    keyboard_destroy*: WlListener
    events*: WlrInputMethodKeyboardGrab_v2_events

  WlrInputMethodKeyboardGrab_v2_events* {.bycopy.} = object
    destroy*: WlSignal

  WlrInputMethod_v2_events* {.bycopy.} = object
    commit*: WlSignal
    new_popup_surface*: WlSignal
    grab_keyboard*: WlSignal
    destroy*: WlSignal

type
  WlrInputPopupSurface_v2* {.bycopy.} = object
    resource*: ptr WlResource
    input_method*: ptr WlrInputMethod_v2
    link*: WlList
    mapped*: bool
    surface*: ptr WlrSurface
    surface_destroy*: WlListener
    events*: WlrInputPopupSurface_v2_events
    data*: pointer

  WlrInputPopupSurface_v2_events* {.bycopy.} = object
    map*: WlSignal
    unmap*: WlSignal
    destroy*: WlSignal

type
  WlrInputMethodManager_v2* {.bycopy.} = object
    global*: ptr WlGlobal
    input_methods*: WlList
    display_destroy*: WlListener
    events*: WlrInputMethodManager_v2_events

  WlrInputMethodManager_v2_events* {.bycopy.} = object
    input_method*: WlSignal
    destroy*: WlSignal

proc createWlrInputMethodManager_v2*(display: ptr WlDisplay): ptr WlrInputMethodManager_v2 {.importc: "wlr_input_method_manager_v2_create".}
proc sendActivate*(input_method: ptr WlrInputMethod_v2) {.importc: "wlr_input_method_v2_send_activate".}
proc sendDeactivate*(input_method: ptr WlrInputMethod_v2) {.importc: "wlr_input_method_v2_send_deactivate".}
proc sendSurroundingText*(input_method: ptr WlrInputMethod_v2; text: cstring; cursor: uint32; anchor: uint32) {.importc: "wlr_input_method_v2_send_surrounding_text".}
proc sendContentType*(input_method: ptr WlrInputMethod_v2; hint: uint32; purpose: uint32) {.importc: "wlr_input_method_v2_send_content_type".}
proc sendTextChangeCause*(input_method: ptr WlrInputMethod_v2; cause: uint32) {.importc: "wlr_input_method_v2_send_text_change_cause".}
proc send_done*(input_method: ptr WlrInputMethod_v2) {.importc: "wlr_input_method_v2_send_done".}
proc sendUnavailable*(input_method: ptr WlrInputMethod_v2) {.importc: "wlr_input_method_v2_send_unavailable".}

proc isInputPopupSurface_v2*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_is_input_popup_surface_v2".}
proc wlrInputPopupSurface_v2*(surface: ptr WlrSurface): ptr WlrInputPopupSurface_v2 {.importc: "wlr_input_popup_surface_v2_from_wlr_surface".}
proc sendTextInputRectangle*(popup_surface: ptr WlrInputPopupSurface_v2; sbox: ptr WlrBox) {.importc: "wlr_input_popup_surface_v2_send_text_input_rectangle".}
proc sendKey*(keyboard_grab: ptr WlrInputMethodKeyboardGrab_v2; time: uint32; key: uint32; state: uint32) {.importc: "wlr_input_method_keyboard_grab_v2_send_key".}
proc sendModifiers*(keyboard_grab: ptr WlrInputMethodKeyboardGrab_v2; modifiers: ptr WlrKeyboardModifiers) {.importc: "wlr_input_method_keyboard_grab_v2_send_modifiers".}
proc setKeyboard*(keyboard_grab: ptr WlrInputMethodKeyboardGrab_v2; keyboard: ptr WlrKeyboard) {.importc: "wlr_input_method_keyboard_grab_v2_set_keyboard".}
proc destroy*(keyboard_grab: ptr WlrInputMethodKeyboardGrab_v2) {.importc: "wlr_input_method_keyboard_grab_v2_destroy".}

## wlr_keyboard_shortcuts_inhibit_v1

type
  WlrKeyboardShortcutsInhibitManager_v1* {.bycopy.} = object
    inhibitors*: WlList
    global*: ptr WlGlobal
    display_destroy*: WlListener
    events*: WlrKeyboardShortcutsInhibitManager_v1_events
    data*: pointer

  WlrKeyboardShortcutsInhibitManager_v1_events* {.bycopy.} = object
    new_inhibitor*: WlSignal
    destroy*: WlSignal

type
  WlrKeyboardShortcutsInhibitor_v1* {.bycopy.} = object
    surface*: ptr WlrSurface
    seat*: ptr WlrSeat
    active*: bool
    resource*: ptr WlResource
    surface_destroy*: WlListener
    seat_destroy*: WlListener
    link*: WlList
    events*: WlrKeyboardShortcutsInhibitor_v1_events
    data*: pointer

  WlrKeyboardShortcutsInhibitor_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrKeyboardShortcutsInhibit_v1*(display: ptr WlDisplay): ptr WlrKeyboardShortcutsInhibitManager_v1 {.importc: "wlr_keyboard_shortcuts_inhibit_v1_create".}
proc activate*(inhibitor: ptr WlrKeyboardShortcutsInhibitor_v1) {.importc: "wlr_keyboard_shortcuts_inhibitor_v1_activate".}
proc deactivate*(inhibitor: ptr WlrKeyboardShortcutsInhibitor_v1) {.importc: "wlr_keyboard_shortcuts_inhibitor_v1_deactivate".}

## wlr_layer_shell_v1

# import wlr-layer-shell-unstable-v1-protocol

type
  WlrLayerShell_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    display_destroy*: WlListener
    events*: WlrLayerShell_v1_events
    data*: pointer

  WlrLayerShell_v1_events* {.bycopy.} = object
    new_surface*: WlSignal
    destroy*: WlSignal

type WlrLayerSurface_v1_state_field* = enum
  WLR_LAYER_SURFACE_V1_STATE_DESIRED_SIZE = 1 shl 0,
  WLR_LAYER_SURFACE_V1_STATE_ANCHOR = 1 shl 1,
  WLR_LAYER_SURFACE_V1_STATE_EXCLUSIVE_ZONE = 1 shl 2,
  WLR_LAYER_SURFACE_V1_STATE_MARGIN_FIXME = 1 shl 3,
  WLR_LAYER_SURFACE_V1_STATE_KEYBOARD_INTERACTIVITY = 1 shl 4,
  WLR_LAYER_SURFACE_V1_STATE_LAYER = 1 shl 5

type
  WlrLayerSurface_v1* {.bycopy.} = object
    surface*: ptr WlrSurface
    output*: ptr WlrOutput
    resource*: ptr WlResource
    shell*: ptr WlrLayerShell_v1
    popups*: WlList
    namespace*: cstring
    added*: bool
    configured*: bool
    mapped*: bool
    configure_list*: WlList
    current*: WlrLayerSurface_v1_state
    pending*: WlrLayerSurface_v1_state
    surface_destroy*: WlListener
    events*: WlrLayerSurface_v1_events
    data*: pointer

  WlrLayerSurface_v1_state_margin* {.bycopy.} = object
    top*: uint32
    right*: uint32
    bottom*: uint32
    left*: uint32

  WlrLayerSurface_v1_state* {.bycopy.} = object
    committed*: uint32
    anchor*: uint32
    exclusive_zone*: int32
    margin*: WlrLayerSurface_v1_state_margin
    keyboard_interactive*: zwlr_layer_surface_v1_keyboard_interactivity
    desired_width*, desired_height*: uint32
    layer*: zwlr_layer_shell_v1_layer
    configure_serial*: uint32
    actual_width*, actual_height*: uint32

  WlrLayerSurface_v1_configure* {.bycopy.} = object
    link*: WlList
    serial*: uint32
    width*, height*: uint32

  WlrLayerSurface_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    map*: WlSignal
    unmap*: WlSignal
    new_popup*: WlSignal

proc createWlrLayerShell_v1*(display: ptr WlDisplay): ptr WlrLayerShell_v1 {.importc: "wlr_layer_shell_v1_create".}
proc configure*(surface: ptr WlrLayerSurface_v1;width: uint32; height: uint32): uint32 {.importc: "wlr_layer_surface_v1_configure".}
proc destroy*(surface: ptr WlrLayerSurface_v1) {.importc: "wlr_layer_surface_v1_destroy".}
proc isLayerSurface*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_is_layer_surface".}
proc wlrLayerSurface_v1*(surface: ptr WlrSurface): ptr WlrLayerSurface_v1 {.importc: "wlr_layer_surface_v1_from_wlr_surface".}
proc forEachSurface*(surface: ptr WlrLayerSurface_v1; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_layer_surface_v1_for_each_surface".}
proc forEachPopupSurface*(surface: ptr WlrLayerSurface_v1; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_layer_surface_v1_for_each_popup_surface".}

proc surfaceAt*(surface: ptr WlrLayerSurface_v1; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_layer_surface_v1_surface_at".}
proc popupSurfaceAt*(surface: ptr WlrLayerSurface_v1; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_layer_surface_v1_popup_surface_at".}

## wlr_linux_dmabuf_v1

type WlrDmabuf_v1_buffer* {.bycopy.} = object
  base*: WlrBuffer
  resource*: ptr WlResource
  attributes*: WlrDmabufAttributes
  release*: WlListener

proc isBuffer*(buffer_resource: ptr WlResource): bool {.importc: "wlr_dmabuf_v1_resource_is_buffer".}
proc wlrDmabuf_v1_buffer*(buffer_resource: ptr WlResource): ptr WlrDmabuf_v1_buffer {.importc: "wlr_dmabuf_v1_buffer_from_buffer_resource".}

type
  WlrLinuxDmabufFeedback_v1* {.bycopy.} = object
    main_device*: Dev
    tranches_len*: csize_t
    tranches*: ptr WlrLinuxDmabufFeedback_v1_tranche

  WlrLinuxDmabufFeedback_v1_tranche* {.bycopy.} = object
    target_device*: Dev
    flags*: uint32
    formats*: ptr WlrDrmFormatSet

type
  WlrLinuxDmabuf_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    renderer*: ptr WlrRenderer
    events*: WlrLinuxDmabuf_v1_events
    default_feedback*: ptr WlrLinuxDmabufFeedback_v1_compiled
    surfaces*: WlList
    display_destroy*: WlListener
    renderer_destroy*: WlListener

  WlrLinuxDmabuf_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrLinuxDmabuf_v1*(display: ptr WlDisplay; renderer: ptr WlrRenderer): ptr WlrLinuxDmabuf_v1 {.importc: "wlr_linux_dmabuf_v1_create".}
proc setSurfaceFeedback*(linux_dmabuf: ptr WlrLinuxDmabuf_v1; surface: ptr WlrSurface; feedback: ptr WlrLinuxDmabufFeedback_v1): bool {.importc: "wlr_linux_dmabuf_v1_set_surface_feedback".}

## wlr_matrix

# NOTE: float mat[static 9]
proc wlr_matrix_identity*(mat: array[9, cfloat]) {.importc: "wlr_matrix_identity".}
# NOTE: float mat[static 9], const float a[static 9], const float b[static 9]
proc wlr_matrix_multiply*(mat: array[9, cfloat]; a: array[9, cfloat]; b: array[9, cfloat]) {.importc: "wlr_matrix_multiply".}
# NOTE: float mat[static 9], const float a[static 9]
proc wlr_matrix_transpose*(mat: array[9, cfloat]; a: array[9, cfloat]) {.importc: "wlr_matrix_transpose".}
# NOTE: float mat[static 9]
proc wlr_matrix_translate*(mat: array[9, cfloat]; x: cfloat; y: cfloat) {.importc: "wlr_matrix_translate".}
# NOTE: float mat[static 9]
proc wlr_matrix_scale*(mat: array[9, cfloat]; x: cfloat; y: cfloat) {.importc: "wlr_matrix_scale".}
# NOTE: float mat[static 9]
proc wlr_matrix_rotate*(mat: array[9, cfloat]; rad: cfloat) {.importc: "wlr_matrix_rotate".}
# NOTE: float mat[static 9]
proc wlr_matrix_transform*(mat: array[9, cfloat]; transform: WlOutputTransform) {.importc: "wlr_matrix_transform".}
# NOTE: float mat[static 9]
proc wlr_matrix_projection*(mat: array[9, cfloat]; width: cint; height: cint; transform: WlOutputTransform) {.importc: "wlr_matrix_projection".}
# NOTE: float mat[static 9], const float projection[static 9]
proc wlr_matrix_project_box*(mat: array[9, cfloat]; box: ptr WlrBox; transform: WlOutputTransform; rotation: cfloat; projection: array[9, cfloat]) {.importc: "wlr_matrix_project_box".}

## wlr_output_damage

const WLR_OUTPUT_DAMAGE_PREVIOUS_LEN* = 2

type
  WlrOutputDamage* {.bycopy.} = object
    output*: ptr WlrOutput
    max_rects*: cint
    current*: PixmanRegion32
    previous*: array[WLR_OUTPUT_DAMAGE_PREVIOUS_LEN, PixmanRegion32]
    previous_idx*: csize_t
    pending_attach_render*: bool
    events*: WlrOutputDamage_events
    output_destroy*: WlListener
    output_mode*: WlListener
    output_needs_frame*: WlListener
    output_damage*: WlListener
    output_frame*: WlListener
    output_precommit*: WlListener
    output_commit*: WlListener

  WlrOutputDamage_events* {.bycopy.} = object
    frame*: WlSignal
    destroy*: WlSignal

proc createWlrOutputDamage*(output: ptr WlrOutput): ptr WlrOutputDamage {.importc: "wlr_output_damage_create".}
proc destroy*(output_damage: ptr WlrOutputDamage) {.importc: "wlr_output_damage_destroy".}
proc attachRender*(output_damage: ptr WlrOutputDamage; needs_frame: ptr bool; buffer_damage: ptr PixmanRegion32): bool {.importc: "wlr_output_damage_attach_render".}
proc add*(output_damage: ptr WlrOutputDamage; damage: ptr PixmanRegion32) {.importc: "wlr_output_damage_add".}
proc addWhole*(output_damage: ptr WlrOutputDamage) {.importc: "wlr_output_damage_add_whole".}
proc addBox*(output_damage: ptr WlrOutputDamage; box: ptr WlrBox) {.importc: "wlr_output_damage_add_box".}

## wlr_output_power_management

type
  WlrOutputManager_v1* {.bycopy.} = object
    display*: ptr WlDisplay
    global*: ptr WlGlobal
    resources*: WlList
    heads*: WlList
    serial*: uint32
    current_configuration_dirty*: bool
    events*: WlrOutputManager_v1_events
    display_destroy*: WlListener
    data*: pointer

  WlrOutputManager_v1_events* {.bycopy.} = object
    apply*: WlSignal
    test*: WlSignal
    destroy*: WlSignal

type
  WlrOutputHead_v1* {.bycopy.} = object
    state*: WlrOutputHead_v1_state
    manager*: ptr WlrOutputManager_v1
    link*: WlList
    resources*: WlList
    mode_resources*: WlList
    output_destroy*: WlListener

  WlrOutputHead_v1_state* {.bycopy.} = object
    output*: ptr WlrOutput
    enabled*: bool
    mode*: ptr WlrOutput_mode
    custom_mode*: WlrOutputHead_v1_state_custom_mode
    x*, y*: int32
    transform*: WlOutputTransform
    scale*: cfloat

  WlrOutputHead_v1_state_custom_mode* {.bycopy.} = object
    width*, height*: int32
    refresh*: int32

type WlrOutputConfiguration_v1* {.bycopy.} = object
  heads*: WlList
  manager*: ptr WlrOutputManager_v1
  serial*: uint32
  finalized*: bool
  finished*: bool
  resource*: ptr WlResource

type WlrOutputConfigurationHead_v1* {.bycopy.} = object
  state*: WlrOutputHead_v1_state
  config*: ptr WlrOutputConfiguration_v1
  link*: WlList
  resource*: ptr WlResource
  output_destroy*: WlListener

proc createWlrOutputManager_v1*(display: ptr WlDisplay): ptr WlrOutputManager_v1 {.importc: "wlr_output_manager_v1_create".}
proc setConfiguration*(manager: ptr WlrOutputManager_v1; config: ptr WlrOutputConfiguration_v1) {.importc: "wlr_output_manager_v1_set_configuration".}
proc createWlrOutputConfiguration_v1*(): ptr WlrOutputConfiguration_v1 {.importc: "wlr_output_configuration_v1_create".}
proc destroy*(config: ptr WlrOutputConfiguration_v1) {.importc: "wlr_output_configuration_v1_destroy".}
proc sendSucceeded*(config: ptr WlrOutputConfiguration_v1) {.importc: "wlr_output_configuration_v1_send_succeeded".}
proc sendFailed*(config: ptr WlrOutputConfiguration_v1) {.importc: "wlr_output_configuration_v1_send_failed".}
proc createWlrOutputConfigurationHead_v1*(config: ptr WlrOutputConfiguration_v1; output: ptr WlrOutput): ptr WlrOutputConfigurationHead_v1 {.importc: "wlr_output_configuration_head_v1_create".}

## wlr_pointer_constraints_v1

# import pointer-constraints-unstable-v1-protocol

type WlrPointerConstraint_v1_type* = enum
  WLR_POINTER_CONSTRAINT_V1_LOCKED,
  WLR_POINTER_CONSTRAINT_V1_CONFINED

type WlrPointerConstraint_v1_state_field* = enum
  WLR_POINTER_CONSTRAINT_V1_STATE_REGION = 1 shl 0,
  WLR_POINTER_CONSTRAINT_V1_STATE_CURSOR_HINT = 1 shl 1

type
  WlrPointerConstraint_v1* {.bycopy.} = object
    pointer_constraints*: ptr WlrPointerConstraints_v1
    resource*: ptr WlResource
    surface*: ptr WlrSurface
    seat*: ptr WlrSeat
    lifetime*: zwp_pointer_constraints_v1_lifetime
    `type`*: WlrPointerConstraint_v1_type
    region*: PixmanRegion32
    current*: WlrPointerConstraint_v1_state
    pending*: WlrPointerConstraint_v1_state
    surface_commit*: WlListener
    surface_destroy*: WlListener
    seat_destroy*: WlListener
    link*: WlList
    events*: WlrPointerConstraint_v1_events
    data*: pointer

  WlrPointerConstraint_v1_state* {.bycopy.} = object
    committed*: uint32
    region*: PixmanRegion32
    cursor_hint*: WlrPointerConstraint_v1_state_hint

  WlrPointerConstraint_v1_state_hint* {.bycopy.} = object
    x*, y*: cdouble

  WlrPointerConstraint_v1_events* {.bycopy.} = object
    set_region*: WlSignal
    destroy*: WlSignal

  WlrPointerConstraints_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    constraints*: WlList
    events*: WlrPointerConstraints_v1_events
    display_destroy*: WlListener
    data*: pointer

  WlrPointerConstraints_v1_events* {.bycopy.} = object
    new_constraint*: WlSignal

proc createWlrPointerConstraints_v1*(display: ptr WlDisplay): ptr WlrPointerConstraints_v1 {.importc: "wlr_pointer_constraints_v1_create".}
proc constraintForSurface*(pointer_constraints: ptr WlrPointerConstraints_v1; surface: ptr WlrSurface; seat: ptr WlrSeat): ptr WlrPointerConstraint_v1 {.importc: "wlr_pointer_constraints_v1_constraint_for_surface".}
proc sendActivated*(constraint: ptr WlrPointerConstraint_v1) {.importc: "wlr_pointer_constraint_v1_send_activated".}
proc sendDeactivated*(constraint: ptr WlrPointerConstraint_v1) {.importc: "wlr_pointer_constraint_v1_send_deactivated".}

## wlr_pointer_gestures_v1

type
  WlrPointerGestures_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    swipes*: WlList
    pinches*: WlList
    holds*: WlList
    display_destroy*: WlListener
    events*: WlrPointerGestures_v1_events
    data*: pointer

  WlrPointerGestures_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrPointerGestures_v1*(display: ptr WlDisplay): ptr WlrPointerGestures_v1 {.importc: "wlr_pointer_gestures_v1_create".}
proc sendSwipeBegin*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; fingers: uint32) {.importc: "wlr_pointer_gestures_v1_send_swipe_begin".}
proc sendSwipeUpdate*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; dx: cdouble; dy: cdouble) {.importc: "wlr_pointer_gestures_v1_send_swipe_update".}
proc sendSwipeEnd*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_swipe_end".}
proc sendPinchBegin*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; fingers: uint32) {.importc: "wlr_pointer_gestures_v1_send_pinch_begin".}
proc sendPinchUpdate*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; dx: cdouble; dy: cdouble; scale: cdouble; rotation: cdouble) {.importc: "wlr_pointer_gestures_v1_send_pinch_update".}
proc sendPinchEnd*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_pinch_end".}
proc sendHoldBegin*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; fingers: uint32) {.importc: "wlr_pointer_gestures_v1_send_hold_begin".}
proc sendHoldEnd*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_hold_end".}

## wlr_presentation_time

type
  WlrPresentation* {.bycopy.} = object
    global*: ptr WlGlobal
    clock*: ClockId
    events*: WlrPresentation_events
    display_destroy*: WlListener

  WlrPresentation_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrPresentationFeedback* {.bycopy.} = object
  resources*: WlList
  output*: ptr WlrOutput
  output_committed*: bool
  output_commit_seq*: uint32
  output_commit*: WlListener
  output_present*: WlListener
  output_destroy*: WlListener

type WlrPresentationEvent* {.bycopy.} = object
  output*: ptr WlrOutput
  tv_sec*: uint64
  tv_nsec*: uint32
  refresh*: uint32
  seq*: uint64
  flags*: uint32

proc createWlrPresentation*(display: ptr WlDisplay; backend: ptr WlrBackend): ptr WlrPresentation {.importc: "wlr_presentation_create".}
proc surfaceSampled*(presentation: ptr WlrPresentation; surface: ptr WlrSurface): ptr WlrPresentationFeedback {.importc: "wlr_presentation_surface_sampled".}
proc feedbackSendPresented*(feedback: ptr WlrPresentationFeedback; event: ptr WlrPresentationEvent) {.importc: "wlr_presentation_feedback_send_presented".}
proc feedbackDestroy*(feedback: ptr WlrPresentationFeedback) {.importc: "wlr_presentation_feedback_destroy".}
proc eventFromOutput*(event: ptr WlrPresentation_event; output_event: ptr WlrOutputEventPresent) {.importc: "wlr_presentation_event_from_output".}
proc surfaceSampledOnOutput*(presentation: ptr WlrPresentation; surface: ptr WlrSurface; output: ptr WlrOutput) {.importc: "wlr_presentation_surface_sampled_on_output".}

## wlr_primary_selection_v1

type
  WlrPrimarySelection_v1_device_manager* {.bycopy.} = object
    global*: ptr WlGlobal
    devices*: WlList
    display_destroy*: WlListener
    events*: WlrPrimarySelection_v1_device_manager_events
    data*: pointer

  WlrPrimarySelection_v1_device_manager_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrPrimarySelection_v1_device* {.bycopy.} = object
  manager*: ptr WlrPrimarySelection_v1_device_manager
  seat*: ptr WlrSeat
  link*: WlList
  resources*: WlList
  offers*: WlList
  seat_destroy*: WlListener
  seat_focus_change*: WlListener
  seat_set_primary_selection*: WlListener
  data*: pointer

proc createWlrPrimarySelection_v1_device_manager*(display: ptr WlDisplay): ptr WlrPrimarySelection_v1_device_manager {.importc: "wlr_primary_selection_v1_device_manager_create".}

proc wlrRegion*(resource: ptr WlResource): ptr PixmanRegion32 {.importc: "wlr_region_from_resource".}

## XXX: wlr_region??

## wlr_relative_pointer

type
  WlrRelativePointerManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    relative_pointers*: WlList
    events*: WlrRelativePointerManager_v1_events
    display_destroy_listener*: WlListener
    data*: pointer

  WlrRelativePointerManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    new_relative_pointer*: WlSignal

type
  WlrRelativePointer_v1* {.bycopy.} = object
    resource*: ptr WlResource
    pointer_resource*: ptr WlResource
    seat*: ptr WlrSeat
    link*: WlList
    events*: WlrRelativePointer_v1_events
    seat_destroy*: WlListener
    pointer_destroy*: WlListener
    data*: pointer

  WlrRelativePointer_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrRelativePointerManager_v1*(display: ptr WlDisplay): ptr WlrRelativePointerManager_v1 {.importc: "wlr_relative_pointer_manager_v1_create".}
proc sendRelativeMotion*(manager: ptr WlrRelativePointerManager_v1; seat: ptr WlrSeat; time_usec: uint64; dx: cdouble; dy: cdouble; dx_unaccel: cdouble; dy_unaccel: cdouble) {.importc: "wlr_relative_pointer_manager_v1_send_relative_motion".}
proc wlrRelativePointer_v1*(resource: ptr WlResource): ptr WlrRelativePointer_v1 {.importc: "wlr_relative_pointer_v1_from_resource".}

## wlr_xdg_shell

# import xdg-shell-protocol

type
  WlrXdgClient* {.bycopy.} = object
    shell*: ptr WlrXdgShell
    resource*: ptr WlResource
    client*: ptr WlClient
    surfaces*: WlList
    link*: WlList
    ping_serial*: uint32
    ping_timer*: ptr WlEventSource

  WlrXdgShell* {.bycopy.} = object
    global*: ptr WlGlobal
    clients*: WlList
    popup_grabs*: WlList
    ping_timeout*: uint32
    display_destroy*: WlListener
    events*: WlrXdgShell_events
    data*: pointer

  WlrXdgShell_events* {.bycopy.} = object
    new_surface*: WlSignal
    destroy*: WlSignal

type
  WlrXdgPositioner* {.bycopy.} = object
    anchor_rect*: WlrBox
    anchor*: XdgPositionerAnchor
    gravity*: XdgPositionerGravity
    constraint_adjustment*: XdgPositionerConstraintAdjustment
    size*: WlrXdgPositioner_size
    offset*: WlrXdgPositioner_offset

  WlrXdgPositioner_size* {.bycopy.} = object
    width*, height*: int32

  WlrXdgPositioner_offset* {.bycopy.} = object
    x*, y*: int32

type WlrXdgSurfaceRole* = enum
  WLR_XDG_SURFACE_ROLE_NONE,
  WLR_XDG_SURFACE_ROLE_TOPLEVEL,
  WLR_XDG_SURFACE_ROLE_POPUP

type
  WlrXdgSurface* {.bycopy.} = object
    client*: ptr WlrXdgClient
    resource*: ptr WlResource
    surface*: ptr WlrSurface
    link*: WlList
    role*: WlrXdgSurfaceRole
    ano_wlr_xdg_shell_189*: WlrXdgSurface_ano
    popups*: WlList
    added*: bool
    configured*: bool
    mapped*: bool
    configure_idle*: ptr WlEventSource
    scheduled_serial*: uint32
    configure_list*: WlList
    current*: WlrXdgSurfaceState
    pending*: WlrXdgSurfaceState
    surface_destroy*: WlListener
    surface_commit*: WlListener
    events*: WlrXdgSurface_events
    data*: pointer

  WlrXdgSurfaceConfigure* {.bycopy.} = object
    surface*: ptr WlrXdgSurface
    link*: WlList
    serial*: uint32
    toplevel_configure*: ptr WlrXdgToplevelConfigure

  WlrXdgSurfaceState* {.bycopy.} = object
    configure_serial*: uint32
    geometry*: WlrBox

  WlrXdgSurface_ano* {.bycopy, union.} = object
    toplevel*: ptr WlrXdgToplevel
    popup*: ptr WlrXdgPopup

  WlrXdgSurface_events* {.bycopy.} = object
    destroy*: WlSignal
    ping_timeout*: WlSignal
    new_popup*: WlSignal
    map*: WlSignal
    unmap*: WlSignal
    configure*: WlSignal
    ack_configure*: WlSignal

  WlrXdgPopup* {.bycopy.} = object
    base*: ptr WlrXdgSurface
    link*: WlList
    resource*: ptr WlResource
    committed*: bool
    parent*: ptr WlrSurface
    seat*: ptr WlrSeat
    geometry*: WlrBox
    positioner*: WlrXdgPositioner
    grab_link*: WlList

  WlrXdgPopupGrab* {.bycopy.} = object
    client*: ptr WlClient
    pointer_grab*: WlrSeatPointerGrab
    keyboard_grab*: WlrSeatKeyboardGrab
    touch_grab*: WlrSeatTouchGrab
    seat*: ptr WlrSeat
    popups*: WlList
    link*: WlList
    seat_destroy*: WlListener

  WlrXdgToplevel* {.bycopy.} = object
    resource*: ptr WlResource
    base*: ptr WlrXdgSurface
    added*: bool
    parent*: ptr WlrXdgSurface
    parent_unmap*: WlListener
    current*: WlrXdgToplevelState
    pending*: WlrXdgToplevelState
    scheduled*: WlrXdgToplevelConfigure
    requested*: WlrXdgToplevelRequested
    title*: cstring
    app_id*: cstring
    events*: WlrXdgToplevel_events

  WlrXdgToplevelState* {.bycopy.} = object
    maximized*: bool
    fullscreen*: bool
    resizing*: bool
    activated*: bool
    tiled*: uint32
    width*, height*: uint32
    max_width*, max_height*: uint32
    min_width*, min_height*: uint32

  WlrXdgToplevelConfigure* {.bycopy.} = object
    maximized*: bool
    fullscreen*: bool
    resizing*: bool
    activated*: bool
    tiled*: uint32
    width*, height*: uint32

  WlrXdgToplevelRequested* {.bycopy.} = object
    maximized*: bool
    minimized*: bool
    fullscreen*: bool
    fullscreen_output*: ptr WlrOutput
    fullscreen_output_destroy*: WlListener

  WlrXdgToplevel_events* {.bycopy.} = object
    request_maximize*: WlSignal
    request_fullscreen*: WlSignal
    request_minimize*: WlSignal
    request_move*: WlSignal
    request_resize*: WlSignal
    request_show_window_menu*: WlSignal
    set_parent*: WlSignal
    set_title*: WlSignal
    set_app_id*: WlSignal

type WlrXdgToplevelMoveEvent* {.bycopy.} = object
  surface*: ptr WlrXdgSurface
  seat*: ptr WlrSeatClient
  serial*: uint32

type WlrXdgToplevelResizeEvent* {.bycopy.} = object
  surface*: ptr WlrXdgSurface
  seat*: ptr WlrSeatClient
  serial*: uint32
  edges*: uint32

type WlrXdgToplevelSetFullscreenEvent* {.bycopy.} = object
  surface*: ptr WlrXdgSurface
  fullscreen*: bool
  output*: ptr WlrOutput

type WlrXdgToplevelShowWindowMenuEvent* {.bycopy.} = object
  surface*: ptr WlrXdgSurface
  seat*: ptr WlrSeatClient
  serial*: uint32
  x*, y*: uint32

proc createWlrXdgShell*(display: ptr WlDisplay): ptr WlrXdgShell {.importc: "wlr_xdg_shell_create".}
proc wlrXdgSurface*(resource: ptr WlResource): ptr WlrXdgSurface {.importc: "wlr_xdg_surface_from_resource".}
proc wlrXdgSurfaceFromPopup*(resource: ptr WlResource): ptr WlrXdgSurface {.importc: "wlr_xdg_surface_from_popup_resource".}
proc wlrXdgSurfaceFromToplevel*(resource: ptr WlResource): ptr WlrXdgSurface {.importc: "wlr_xdg_surface_from_toplevel_resource".}
proc ping*(surface: ptr WlrXdgSurface) {.importc: "wlr_xdg_surface_ping".}
proc setSizeToplevel*(surface: ptr WlrXdgSurface; width: uint32; height: uint32): uint32 {.importc: "wlr_xdg_toplevel_set_size".}
proc setActivatedToplevel*(surface: ptr WlrXdgSurface; activated: bool): uint32 {.importc: "wlr_xdg_toplevel_set_activated".}
proc setMaximizedToplevel*(surface: ptr WlrXdgSurface; maximized: bool): uint32 {.importc: "wlr_xdg_toplevel_set_maximized".}
proc setFullscreenToplevel*(surface: ptr WlrXdgSurface; fullscreen: bool): uint32 {.importc: "wlr_xdg_toplevel_set_fullscreen".}
proc setResizingToplevel*(surface: ptr WlrXdgSurface; resizing: bool): uint32 {.importc: "wlr_xdg_toplevel_set_resizing".}
proc setTiledToplevel*(surface: ptr WlrXdgSurface; tiled_edges: uint32): uint32 {.importc: "wlr_xdg_toplevel_set_tiled".}
proc sendCloseToplevel*(surface: ptr WlrXdgSurface) {.importc: "wlr_xdg_toplevel_send_close".}
proc setParentToplevel*(surface: ptr WlrXdgSurface; parent: ptr WlrXdgSurface) {.importc: "wlr_xdg_toplevel_set_parent".}
proc destroy*(surface: ptr WlrXdgSurface) {.importc: "wlr_xdg_popup_destroy".}
proc getPosition*(popup: ptr WlrXdgPopup; popup_sx: ptr cdouble; popup_sy: ptr cdouble) {.importc: "wlr_xdg_popup_get_position".}
proc getGeometry*(positioner: ptr WlrXdgPositioner): WlrBox {.importc: "wlr_xdg_positioner_get_geometry".}
proc getAnchorPoint*(popup: ptr WlrXdgPopup; toplevel_sx: ptr cint; toplevel_sy: ptr cint) {.importc: "wlr_xdg_popup_get_anchor_point".}
proc getToplevelCoords*(popup: ptr WlrXdgPopup; popup_sx: cint; popup_sy: cint; toplevel_sx: ptr cint; toplevel_sy: ptr cint) {.importc: "wlr_xdg_popup_get_toplevel_coords".}
proc unconstrainFromBox*(popup: ptr WlrXdgPopup; toplevel_sx_box: ptr WlrBox) {.importc: "wlr_xdg_popup_unconstrain_from_box".}
proc invertX*(positioner: ptr WlrXdgPositioner) {.importc: "wlr_positioner_invert_x".}
proc invertY*(positioner: ptr WlrXdgPositioner) {.importc: "wlr_positioner_invert_y".}
proc surfaceAt*(surface: ptr WlrXdgSurface; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_xdg_surface_surface_at".}
proc popupSurfaceAt*(surface: ptr WlrXdgSurface; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_xdg_surface_popup_surface_at".}
proc isXdgSurface*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_is_xdg_surface".}
proc wlrXdgSurface*(surface: ptr WlrSurface): ptr WlrXdgSurface {.importc: "wlr_xdg_surface_from_wlr_surface".}
proc getGeometry*(surface: ptr WlrXdgSurface; box: ptr WlrBox) {.importc: "wlr_xdg_surface_get_geometry".}
proc forEachSurface*(surface: ptr WlrXdgSurface; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_xdg_surface_for_each_surface".}
proc forEachPopupSurface*(surface: ptr WlrXdgSurface; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_xdg_surface_for_each_popup_surface".}
proc scheduleConfigure*(surface: ptr WlrXdgSurface): uint32 {.importc: "wlr_xdg_surface_schedule_configure".}

## wlr_scene

type WlrSceneNodeType* = enum
  WLR_SCENE_NODE_ROOT,
  WLR_SCENE_NODE_TREE,
  WLR_SCENE_NODE_SURFACE,
  WLR_SCENE_NODE_RECT,
  WLR_SCENE_NODE_BUFFER

type WlrSceneNode_state* {.bycopy.} = object
  link*: WlList
  children*: WlList
  enabled*: bool
  x*, y*: cint

type
  WlrSceneNode* {.bycopy.} = object
    `type`*: WlrSceneNodeType
    parent*: ptr WlrSceneNode
    state*: WlrSceneNode_state
    events*: WlrSceneNode_events
    data*: pointer

  WlrSceneNode_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrScene* {.bycopy.} = object
  node*: WlrSceneNode
  outputs*: WlList
  presentation*: ptr WlrPresentation
  presentation_destroy*: WlListener
  pending_buffers*: WlList

type WlrSceneTree* {.bycopy.} = object
  node*: WlrSceneNode

type WlrSceneSurface* {.bycopy.} = object
  node*: WlrSceneNode
  surface*: ptr WlrSurface
  primary_output*: ptr WlrOutput
  prev_width*, prev_height*: cint
  surface_destroy*: WlListener
  surface_commit*: WlListener

type WlrSceneRect* {.bycopy.} = object
  node*: WlrSceneNode
  width*, height*: cint
  color*: array[4, cfloat]

type WlrSceneBuffer* {.bycopy.} = object
  node*: WlrSceneNode
  buffer*: ptr WlrBuffer
  texture*: ptr WlrTexture
  src_box*: WlrFbox
  dst_width*, dst_height*: cint
  transform*: WlOutputTransform
  pending_link*: WlList

type WlrSceneOutput* {.bycopy.} = object
  output*: ptr WlrOutput
  link*: WlList
  scene*: ptr WlrScene
  addon*: WlrAddon
  damage*: ptr WlrOutputDamage
  x*, y*: cint
  prev_scanout*: bool

type WlrSceneNodeIteratorFunc_t* = proc (node: ptr WlrSceneNode; sx: cint; sy: cint; data: pointer)

proc destroy*(node: ptr WlrSceneNode) {.importc: "wlr_scene_node_destroy".}
proc setEnabled*(node: ptr WlrSceneNode; enabled: bool) {.importc: "wlr_scene_node_set_enabled".}
proc setPosition*(node: ptr WlrSceneNode; x: cint; y: cint) {.importc: "wlr_scene_node_set_position".}
proc placeAbove*(node: ptr WlrSceneNode; sibling: ptr WlrSceneNode) {.importc: "wlr_scene_node_place_above".}
proc placeBelow*(node: ptr WlrSceneNode; sibling: ptr WlrSceneNode) {.importc: "wlr_scene_node_place_below".}
proc raiseToTop*(node: ptr WlrSceneNode) {.importc: "wlr_scene_node_raise_to_top".}
proc lowerToBottom*(node: ptr WlrSceneNode) {.importc: "wlr_scene_node_lower_to_bottom".}
proc reparent*(node: ptr WlrSceneNode; new_parent: ptr WlrSceneNode) {.importc: "wlr_scene_node_reparent".}
proc coords*(node: ptr WlrSceneNode; lx: ptr cint; ly: ptr cint): bool {.importc: "wlr_scene_node_coords".}
proc forEachSurface*(node: ptr WlrSceneNode; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_scene_node_for_each_surface".}
proc at*(node: ptr WlrSceneNode; lx: cdouble; ly: cdouble; nx: ptr cdouble; ny: ptr cdouble): ptr WlrSceneNode {.importc: "wlr_scene_node_at".}
proc createWlrScene*(): ptr WlrScene {.importc: "wlr_scene_create".}
proc render_output*(scene: ptr WlrScene; output: ptr WlrOutput; lx: cint; ly: cint; damage: ptr PixmanRegion32) {.importc: "wlr_scene_render_output".}
proc set_presentation*(scene: ptr WlrScene; presentation: ptr WlrPresentation) {.importc: "wlr_scene_set_presentation".}
proc createWlrSceneTree*(parent: ptr WlrSceneNode): ptr WlrSceneTree {.importc: "wlr_scene_tree_create".}
proc createWlrSceneSurface*(parent: ptr WlrSceneNode; surface: ptr WlrSurface): ptr WlrSceneSurface {.importc: "wlr_scene_surface_create".}
proc wlrSceneSurface*(node: ptr WlrSceneNode): ptr WlrSceneSurface {.importc: "wlr_scene_surface_from_node".}
# NOTE: const float color[static 4]
proc createWlrSceneRect*(parent: ptr WlrSceneNode; width: cint; height: cint; color: array[4, cfloat]): ptr WlrSceneRect {.importc: "wlr_scene_rect_create".}
proc setSize*(rect: ptr WlrSceneRect; width: cint; height: cint) {.importc: "wlr_scene_rect_set_size".}
# NOTE: const float color[static 4]
proc setColor*(rect: ptr WlrSceneRect; color: array[4, cfloat]) {.importc: "wlr_scene_rect_set_color".}
proc createWlrSceneBuffer*(parent: ptr WlrSceneNode; buffer: ptr WlrBuffer): ptr WlrSceneBuffer {.importc: "wlr_scene_buffer_create".}
proc setSourceBox*(scene_buffer: ptr WlrSceneBuffer; box: ptr WlrFbox) {.importc: "wlr_scene_buffer_set_source_box".}
proc setDestSize*(scene_buffer: ptr WlrSceneBuffer; width: cint; height: cint) {.importc: "wlr_scene_buffer_set_dest_size".}
proc setTransform*(scene_buffer: ptr WlrSceneBuffer; transform: WlOutputTransform) {.importc: "wlr_scene_buffer_set_transform".}
proc createWlrSceneOutput*(scene: ptr WlrScene; output: ptr WlrOutput): ptr WlrSceneOutput {.importc: "wlr_scene_output_create".}
proc destroy*(scene_output: ptr WlrSceneOutput) {.importc: "wlr_scene_output_destroy".}
proc setPosition*(scene_output: ptr WlrSceneOutput; lx: cint; ly: cint) {.importc: "wlr_scene_output_set_position".}
proc commit*(scene_output: ptr WlrSceneOutput): bool {.importc: "wlr_scene_output_commit".}
proc sendFrameDone*(scene_output: ptr WlrSceneOutput; now: ptr Timespec) {.importc: "wlr_scene_output_send_frame_done".}
proc forEachSurface*(scene_output: ptr WlrSceneOutput; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_scene_output_for_each_surface".}
proc getSceneOutput*(scene: ptr WlrScene; output: ptr WlrOutput): ptr WlrSceneOutput {.importc: "wlr_scene_get_scene_output".}
proc attachOutputLayout*(scene: ptr WlrScene; output_layout: ptr WlrOutputLayout): bool {.importc: "wlr_scene_attach_output_layout".}
proc createWlrSceneSubsurfaceTree*(parent: ptr WlrSceneNode; surface: ptr WlrSurface): ptr WlrSceneNode {.importc: "wlr_scene_subsurface_tree_create".}
proc createWlrSceneXdgSurface*(parent: ptr WlrSceneNode; xdg_surface: ptr WlrXdgSurface): ptr WlrSceneNode {.importc: "wlr_scene_xdg_surface_create".}

## wlr_screencopy_v1

type
  WlrScreencopyManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    frames*: WlList
    display_destroy*: WlListener
    events*: WlrScreencopyManager_v1_events
    data*: pointer

  WlrScreencopyManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrScreencopy_v1_client* {.bycopy.} = object
  `ref`*: cint
  manager*: ptr WlrScreencopyManager_v1
  damages*: WlList

type WlrScreencopyFrame_v1* {.bycopy.} = object
  resource*: ptr WlResource
  client*: ptr WlrScreencopy_v1_client
  link*: WlList
  format*: WlShmFormat
  fourcc*: uint32
  box*: WlrBox
  stride*: cint
  overlay_cursor*: bool
  cursor_locked*: bool
  with_damage*: bool
  shm_buffer*: ptr WlShmBuffer
  dma_buffer*: ptr WlrDmabuf_v1_buffer
  buffer_destroy*: WlListener
  output*: ptr WlrOutput
  output_commit*: WlListener
  output_destroy*: WlListener
  output_enable*: WlListener
  data*: pointer

proc createWlrScreencopyManager_v1*(display: ptr WlDisplay): ptr WlrScreencopyManager_v1 {.importc: "wlr_screencopy_manager_v1_create".}

## wlr_server_decoration

type WlrServerDecorationManagerMode* = enum
  WLR_SERVER_DECORATION_MANAGER_MODE_NONE = 0,
  WLR_SERVER_DECORATION_MANAGER_MODE_CLIENT = 1,
  WLR_SERVER_DECORATION_MANAGER_MODE_SERVER = 2

type
  WlrServerDecorationManager* {.bycopy.} = object
    global*: ptr WlGlobal
    resources*: WlList
    decorations*: WlList
    default_mode*: uint32
    display_destroy*: WlListener
    events*: WlrServerDecorationManager_events
    data*: pointer

  WlrServerDecorationManager_events* {.bycopy.} = object
    new_decoration*: WlSignal
    destroy*: WlSignal

type
  WlrServerDecoration* {.bycopy.} = object
    resource*: ptr WlResource
    surface*: ptr WlrSurface
    link*: WlList
    mode*: uint32
    events*: WlrServerDecoration_events
    surface_destroy_listener*: WlListener
    data*: pointer

  WlrServerDecoration_events* {.bycopy.} = object
    destroy*: WlSignal
    mode*: WlSignal

proc createWlrServerDecoration*(display: ptr WlDisplay): ptr WlrServerDecorationManager {.importc: "wlr_server_decoration_manager_create".}
proc setDefaultMode*(manager: ptr WlrServerDecorationManager; default_mode: uint32) {.importc: "wlr_server_decoration_manager_set_default_mode".}

## wlr_tablet_v2

# import tablet-unstable-v2-protocol

const WLR_TABLET_V2_TOOL_BUTTONS_CAP* = 16

type
  WlrTabletManager_v2* {.bycopy.} = object
    wl_global*: ptr WlGlobal
    clients*: WlList
    seats*: WlList
    display_destroy*: WlListener
    events*: WlrTabletManager_v2_events
    data*: pointer

  WlrTabletManager_v2_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrTablet_v2_tablet* {.bycopy.} = object
  link*: WlList
  wlr_tablet*: ptr WlrTablet
  wlr_device*: ptr WlrInputDevice
  clients*: WlList
  tool_destroy*: WlListener
  current_client*: ptr WlrTabletClient_v2

type
  WlrTablet_v2_tablet_tool* {.bycopy.} = object
    link*: WlList
    wlr_tool*: ptr WlrTabletTool
    clients*: WlList
    tool_destroy*: WlListener
    current_client*: ptr WlrTabletToolClient_v2
    focused_surface*: ptr WlrSurface
    surface_destroy*: WlListener
    grab*: ptr WlrTabletTool_v2_grab
    default_grab*: WlrTabletTool_v2_grab
    proximity_serial*: uint32
    is_down*: bool
    down_serial*: uint32
    num_buttons*: csize_t
    pressed_buttons*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32]
    pressed_serials*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32]
    events*: WlrTablet_v2_tablet_tool_events

  WlrTabletTool_v2_grab* {.bycopy.} = object
    `interface`*: ptr WlrTabletTool_v2_grab_interface
    tool*: ptr WlrTablet_v2_tablet_tool
    data*: pointer

  WlrTabletTool_v2_grab_interface* {.bycopy.} = object
    proximityIn*: proc (grab: ptr WlrTabletTool_v2_grab; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface)
    down*: proc (grab: ptr WlrTabletTool_v2_grab)
    up*: proc (grab: ptr WlrTabletTool_v2_grab)
    motion*: proc (grab: ptr WlrTabletTool_v2_grab; x: cdouble; y: cdouble)
    pressure*: proc (grab: ptr WlrTabletTool_v2_grab; pressure: cdouble)
    distance*: proc (grab: ptr WlrTabletTool_v2_grab; distance: cdouble)
    tilt*: proc (grab: ptr WlrTabletTool_v2_grab; x: cdouble; y: cdouble)
    rotation*: proc (grab: ptr WlrTabletTool_v2_grab; degrees: cdouble)
    slider*: proc (grab: ptr WlrTabletTool_v2_grab; position: cdouble)
    wheel*: proc (grab: ptr WlrTabletTool_v2_grab; degrees: cdouble; clicks: int32)
    proximityOut*: proc (grab: ptr WlrTabletTool_v2_grab)
    button*: proc (grab: ptr WlrTabletTool_v2_grab; button: uint32; state: zwp_tablet_pad_v2_button_state)
    cancel*: proc (grab: ptr WlrTabletTool_v2_grab)

  WlrTablet_v2_tablet_tool_events* {.bycopy.} = object
    set_cursor*: WlSignal

type
  WlrTablet_v2_tablet_pad* {.bycopy.} = object
    link*: WlList
    wlr_pad*: ptr WlrTabletPad
    wlr_device*: ptr WlrInputDevice
    clients*: WlList
    group_count*: csize_t
    groups*: ptr uint32
    pad_destroy*: WlListener
    current_client*: ptr WlrTabletPadClient_v2
    grab*: ptr WlrTabletPad_v2_grab
    default_grab*: WlrTabletPad_v2_grab
    events*: WlrTablet_v2_tablet_pad_events

  WlrTabletPad_v2_grab* {.bycopy.} = object
    `interface`*: ptr WlrTabletPad_v2_grab_interface
    pad*: ptr WlrTablet_v2_tablet_pad
    data*: pointer

  WlrTabletPad_v2_grab_interface* {.bycopy.} = object
    enter*: proc (grab: ptr WlrTabletPad_v2_grab; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface): uint32
    button*: proc (grab: ptr WlrTabletPad_v2_grab; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state)
    strip*: proc (grab: ptr WlrTabletPad_v2_grab; strip: uint32; position: cdouble; finger: bool; time: uint32)
    ring*: proc (grab: ptr WlrTabletPad_v2_grab; ring: uint32; position: cdouble; finger: bool; time: uint32)
    leave*: proc (grab: ptr WlrTabletPad_v2_grab; surface: ptr WlrSurface): uint32
    mode*: proc (grab: ptr WlrTabletPad_v2_grab; group: csize_t; mode: uint32; time: uint32): uint32
    cancel*: proc (grab: ptr WlrTabletPad_v2_grab)

  WlrTablet_v2_tablet_pad_events* {.bycopy.} = object
    button_feedback*: WlSignal
    strip_feedback*: WlSignal
    ring_feedback*: WlSignal

type WlrTablet_v2_event_cursor* {.bycopy.} = object
  surface*: ptr WlrSurface
  serial*: uint32
  hotspot_x*, hotspot_y*: int32
  seat_client*: ptr WlrSeatClient

type WltTablet_v2_event_feedback* {.bycopy.} = object
  description*: cstring
  index*: csize_t
  serial*: uint32

proc createWlrTablet*(manager: ptr WlrTabletManager_v2; wlr_seat: ptr WlrSeat; wlr_device: ptr WlrInputDevice): ptr WlrTablet_v2_tablet {.importc: "wlr_tablet_create".}
proc createWlrTabletPad*(manager: ptr WlrTabletManager_v2; wlr_seat: ptr WlrSeat; wlr_device: ptr WlrInputDevice): ptr WlrTablet_v2_tablet_pad {.importc: "wlr_tablet_pad_create".}
proc createWlrTabletTool*(manager: ptr WlrTabletManager_v2; wlr_seat: ptr WlrSeat; wlr_tool: ptr WlrTabletTool): ptr WlrTablet_v2_tablet_tool {.importc: "wlr_tablet_tool_create".}
proc createWlrTablet*(display: ptr WlDisplay): ptr WlrTabletManager_v2 {.importc: "wlr_tablet_v2_create".}

proc proximityIn*(tool: ptr WlrTablet_v2_tablet_tool; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface) {.importc: "wlr_send_tablet_v2_tablet_tool_proximity_in".}
proc down*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_down".}
proc up*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_up".}
proc motion*(tool: ptr WlrTablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_motion".}
proc pressure*(tool: ptr WlrTablet_v2_tablet_tool; pressure: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_pressure".}
proc distance*(tool: ptr WlrTablet_v2_tablet_tool; distance: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_distance".}
proc tilt*(tool: ptr WlrTablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_tilt".}
proc rotation*(tool: ptr WlrTablet_v2_tablet_tool; degrees: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_rotation".}
proc slider*(tool: ptr WlrTablet_v2_tablet_tool; position: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_slider".}
proc wheel*(tool: ptr WlrTablet_v2_tablet_tool; degrees: cdouble; clicks: int32) {.importc: "wlr_send_tablet_v2_tablet_tool_wheel".}
proc proximityOut*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_proximity_out".}
proc button*(tool: ptr WlrTablet_v2_tablet_tool; button: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_send_tablet_v2_tablet_tool_button".}

proc notifyProximityIn*(tool: ptr WlrTablet_v2_tablet_tool; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface) {.importc: "wlr_tablet_v2_tablet_tool_notify_proximity_in".}
proc notifyDown*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_down".}
proc notifyUp*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_up".}
proc notifyMotion*(tool: ptr WlrTablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_motion".}
proc notifyPressure*(tool: ptr WlrTablet_v2_tablet_tool; pressure: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_pressure".}
proc notifyDistance*(tool: ptr WlrTablet_v2_tablet_tool; distance: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_distance".}
proc notifyTilt*(tool: ptr WlrTablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_tilt".}
proc notifyRotation*(tool: ptr WlrTablet_v2_tablet_tool; degrees: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_rotation".}
proc notifySlider*(tool: ptr WlrTablet_v2_tablet_tool; position: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_slider".}
proc notifyWheel*(tool: ptr WlrTablet_v2_tablet_tool; degrees: cdouble; clicks: int32) {.importc: "wlr_tablet_v2_tablet_tool_notify_wheel".}
proc notifyProximityOut*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_proximity_out".}
proc notifyButton*(tool: ptr WlrTablet_v2_tablet_tool; button: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_tablet_v2_tablet_tool_notify_button".}

proc startGrab*(tool: ptr WlrTablet_v2_tablet_tool; grab: ptr WlrTabletTool_v2_grab) {.importc: "wlr_tablet_tool_v2_start_grab".}
proc endGrab*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_tool_v2_end_grab".}
proc startImplicitGrab*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_tool_v2_start_implicit_grab".}
proc hasImplicitGrab*(tool: ptr WlrTablet_v2_tablet_tool): bool {.importc: "wlr_tablet_tool_v2_has_implicit_grab".}
proc enter*(pad: ptr WlrTablet_v2_tablet_pad; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface): uint32 {.importc: "wlr_send_tablet_v2_tablet_pad_enter".}
proc button*(pad: ptr WlrTablet_v2_tablet_pad; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_send_tablet_v2_tablet_pad_button".}
proc strip*(pad: ptr WlrTablet_v2_tablet_pad; strip: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_send_tablet_v2_tablet_pad_strip".}
proc ring*(pad: ptr WlrTablet_v2_tablet_pad; ring: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_send_tablet_v2_tablet_pad_ring".}
proc leave*(pad: ptr WlrTablet_v2_tablet_pad; surface: ptr WlrSurface): uint32 {.importc: "wlr_send_tablet_v2_tablet_pad_leave".}
proc mode*(pad: ptr WlrTablet_v2_tablet_pad; group: csize_t; mode: uint32; time: uint32): uint32 {.importc: "wlr_send_tablet_v2_tablet_pad_mode".}
proc notifyEnter*(pad: ptr WlrTablet_v2_tablet_pad; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface): uint32 {.importc: "wlr_tablet_v2_tablet_pad_notify_enter".}
proc notifyButton*(pad: ptr WlrTablet_v2_tablet_pad; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_tablet_v2_tablet_pad_notify_button".}
proc notifyStrip*(pad: ptr WlrTablet_v2_tablet_pad; strip: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_tablet_v2_tablet_pad_notify_strip".}
proc notifyRing*(pad: ptr WlrTablet_v2_tablet_pad; ring: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_tablet_v2_tablet_pad_notify_ring".}
proc notifyLeave*(pad: ptr WlrTablet_v2_tablet_pad; surface: ptr WlrSurface): uint32 {.importc: "wlr_tablet_v2_tablet_pad_notify_leave".}
proc notifyMode*(pad: ptr WlrTablet_v2_tablet_pad; group: csize_t; mode: uint32; time: uint32): uint32 {.importc: "wlr_tablet_v2_tablet_pad_notify_mode".}

proc endGrab*(pad: ptr WlrTablet_v2_tablet_pad) {.importc: "wlr_tablet_v2_end_grab".}
proc startGrab*(pad: ptr WlrTablet_v2_tablet_pad; grab: ptr WlrTabletPad_v2_grab) {.importc: "wlr_tablet_v2_start_grab".}
proc accepts*(tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface): bool {.importc: "wlr_surface_accepts_tablet_v2".}

## wlr_text_input_v3

type WlrTextInput_v3_features* = enum
  WLR_TEXT_INPUT_V3_FEATURE_SURROUNDING_TEXT = 1 shl 0,
  WLR_TEXT_INPUT_V3_FEATURE_CONTENT_TYPE = 1 shl 1,
  WLR_TEXT_INPUT_V3_FEATURE_CURSOR_RECTANGLE = 1 shl 2

type
  WlrTextInput_v3* {.bycopy.} = object
    seat*: ptr WlrSeat
    resource*: ptr WlResource
    focused_surface*: ptr WlrSurface
    pending*: WlrTextInput_v3_state
    current*: WlrTextInput_v3_state
    current_serial*: uint32
    pending_enabled*: bool
    current_enabled*: bool
    active_features*: uint32
    link*: WlList
    surface_destroy*: WlListener
    seat_destroy*: WlListener
    events*: WlrTextInput_v3_events

  WlrTextInput_v3_surrounding* {.bycopy.} = object
    text*: cstring
    cursor*: uint32
    anchor*: uint32

  WlrTextInput_v3_state_content_type* {.bycopy.} = object
    hint*: uint32
    purpose*: uint32

  WlrTextInput_v3_state* {.bycopy.} = object
    surrounding*: WlrTextInput_v3_surrounding
    text_change_cause*: uint32
    content_type*: WlrTextInput_v3_state_content_type
    cursor_rectangle*: WlrBox
    features*: uint32

  WlrTextInput_v3_events* {.bycopy.} = object
    enable*: WlSignal
    commit*: WlSignal
    disable*: WlSignal
    destroy*: WlSignal

type
  WlrTextInputManager_v3* {.bycopy.} = object
    global*: ptr WlGlobal
    text_inputs*: WlList
    display_destroy*: WlListener
    events*: WlrTextInputManager_v3_events

  WlrTextInputManager_v3_events* {.bycopy.} = object
    text_input*: WlSignal
    destroy*: WlSignal

proc createWlrTextInputManager_v3*(wl_display: ptr WlDisplay): ptr WlrTextInputManager_v3 {.importc: "wlr_text_input_manager_v3_create".}
proc sendEnter*(text_input: ptr WlrTextInput_v3; wlr_surface: ptr WlrSurface) {.importc: "wlr_text_input_v3_send_enter".}
proc sendLeave*(text_input: ptr WlrTextInput_v3) {.importc: "wlr_text_input_v3_send_leave".}
proc sendPreeditString*(text_input: ptr WlrTextInput_v3; text: cstring; cursor_begin: int32; cursor_end: int32) {.importc: "wlr_text_input_v3_send_preedit_string".}
proc sendCommitString*(text_input: ptr WlrTextInput_v3; text: cstring) {.importc: "wlr_text_input_v3_send_commit_string".}
proc sendDeleteSurroundingText*(text_input: ptr WlrTextInput_v3; before_length: uint32; after_length: uint32) {.importc: "wlr_text_input_v3_send_delete_surrounding_text".}
proc sendDone*(text_input: ptr WlrTextInput_v3) {.importc: "wlr_text_input_v3_send_done".}

## wlr_viewporter

type
  WlrViewporter* {.bycopy.} = object
    global*: ptr WlGlobal
    events*: WlrViewporter_events
    display_destroy*: WlListener

  WlrViewporter_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrViewporter*(display: ptr WlDisplay): ptr WlrViewporter {.importc: "wlr_viewporter_create".}

## wlr_virtual_keyboard_v1

type
  WlrVirtualKeyboardManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    virtual_keyboards*: WlList
    display_destroy*: WlListener
    events*: WlrVirtualKeyboardManager_v1_events

  WlrVirtualKeyboardManager_v1_events* {.bycopy.} = object
    new_virtual_keyboard*: WlSignal
    destroy*: WlSignal

type
  WlrVirtualKeyboard_v1* {.bycopy.} = object
    input_device*: WlrInputDevice
    resource*: ptr WlResource
    seat*: ptr WlrSeat
    has_keymap*: bool
    link*: WlList
    events*: WlrVirtualKeyboard_v1_events

  WlrVirtualKeyboard_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrVirtualKeyboardManager_v1*(display: ptr WlDisplay): ptr WlrVirtualKeyboardManager_v1 {.importc: "wlr_virtual_keyboard_manager_v1_create".}
proc getVirtualKeyboard*(wlr_dev: ptr WlrInputDevice): ptr WlrVirtualKeyboard_v1 {.importc: "wlr_input_device_get_virtual_keyboard".}

## wlr_virtual_pointer_v1

type
  WlrVirtualPointerManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    virtual_pointers*: WlList
    display_destroy*: WlListener
    events*: WlrVirtualPointerManager_v1_events

  WlrVirtualPointerManager_v1_events* {.bycopy.} = object
    new_virtual_pointer*: WlSignal
    destroy*: WlSignal

type
  WlrVirtualPointer_v1* {.bycopy.} = object
    input_device*: WlrInputDevice
    resource*: ptr WlResource
    axis_event*: array[2, WlrEventPointerAxis]
    axis*: WlPointerAxis
    axis_valid*: array[2, bool]
    link*: WlList
    events*: WlrVirtualPointer_v1_events

  WlrVirtualPointer_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrVirtualPointer_v1_new_pointer_event* {.bycopy.} = object
  new_pointer*: ptr WlrVirtualPointer_v1
  suggested_seat*: ptr WlrSeat
  suggested_output*: ptr WlrOutput

proc createWlrVirtualPointerManager_v1*(display: ptr WlDisplay): ptr WlrVirtualPointerManager_v1 {.importc: "wlr_virtual_pointer_manager_v1_create".}

## wlr_xcursor_manager

type WlrXcursorManagerTheme* {.bycopy.} = object
  scale*: cfloat
  theme*: ptr WlrXcursorTheme
  link*: WlList

type WlrXcursorManager* {.bycopy.} = object
  name*: cstring
  size*: uint32
  scaled_themes*: WlList

proc createWlrXcursorManager*(name: cstring; size: uint32): ptr WlrXcursorManager {.importc: "wlr_xcursor_manager_create".}
proc destroy*(manager: ptr WlrXcursorManager) {.importc: "wlr_xcursor_manager_destroy".}
proc load*(manager: ptr WlrXcursorManager; scale: cfloat): bool {.importc: "wlr_xcursor_manager_load".}
proc getXcursor*(manager: ptr WlrXcursorManager; name: cstring; scale: cfloat): ptr WlrXcursor {.importc: "wlr_xcursor_manager_get_xcursor".}
proc setCursorImage*(manager: ptr WlrXcursorManager; name: cstring; cursor: ptr WlrCursor) {.importc: "wlr_xcursor_manager_set_cursor_image".}

## wlr_xdg_activation_v1

type
  WlrXdgActivation_v1* {.bycopy.} = object
    token_timeout_msec*: uint32
    tokens*: WlList
    events*: WlrXdgActivation_v1_events
    display*: ptr WlDisplay
    global*: ptr WlGlobal
    display_destroy*: WlListener

  WlrXdgActivation_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    request_activate*: WlSignal

  WlrXdgActivationToken_v1* {.bycopy.} = object
    activation*: ptr WlrXdgActivation_v1
    surface*: ptr WlrSurface
    seat*: ptr WlrSeat
    serial*: uint32
    app_id*: cstring
    link*: WlList
    data*: pointer
    events*: WlrXdgActivationToken_v1_events
    token*: cstring
    resource*: ptr WlResource
    timeout*: ptr WlEventSource
    seat_destroy*: WlListener
    surface_destroy*: WlListener

  WlrXdgActivationToken_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrXdgActivation_v1_request_activate_event* {.bycopy.} = object
  activation*: ptr WlrXdgActivation_v1
  token*: ptr WlrXdgActivationToken_v1
  surface*: ptr WlrSurface

proc createWlrXdgActivation_v1*(display: ptr WlDisplay): ptr WlrXdgActivation_v1 {.importc: "wlr_xdg_activation_v1_create".}
proc createWlrXdgActivationToken_v1*(activation: ptr WlrXdgActivation_v1): ptr WlrXdgActivationToken_v1 {.importc: "wlr_xdg_activation_token_v1_create".}
proc destroy*(token: ptr WlrXdgActivationToken_v1) {.importc: "wlr_xdg_activation_token_v1_destroy".}
proc findToken*(activation: ptr WlrXdgActivation_v1; token_str: cstring): ptr WlrXdgActivationToken_v1 {.importc: "wlr_xdg_activation_v1_find_token".}
proc getName*(token: ptr WlrXdgActivationToken_v1): cstring {.importc: "wlr_xdg_activation_token_v1_get_name".}
proc addToken*(activation: ptr WlrXdgActivation_v1; token_str: cstring): ptr WlrXdgActivationToken_v1 {.importc: "wlr_xdg_activation_v1_add_token".}

## wlr_xdg_decoration_v1

type
  WlrXdgDecorationManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    decorations*: WlList
    display_destroy*: WlListener
    events*: WlrXdgDecorationManager_v1_events
    data*: pointer

  WlrXdgDecorationManager_v1_events* {.bycopy.} = object
    new_toplevel_decoration*: WlSignal
    destroy*: WlSignal

type
  WlrXdgToplevelDecoration_v1* {.bycopy.} = object
    resource*: ptr WlResource
    surface*: ptr WlrXdgSurface
    manager*: ptr WlrXdgDecorationManager_v1
    link*: WlList
    current*: WlrXdgToplevelDecoration_v1_state
    pending*: WlrXdgToplevelDecoration_v1_state
    scheduled_mode*: WlrXdgToplevelDecoration_v1_mode
    requested_mode*: WlrXdgToplevelDecoration_v1_mode
    added*: bool
    configure_list*: WlList
    events*: WlrXdgToplevelDecoration_v1_events
    surface_destroy*: WlListener
    surface_configure*: WlListener
    surface_ack_configure*: WlListener
    surface_commit*: WlListener
    data*: pointer

  WlrXdgToplevelDecoration_v1_mode* = enum
    WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_NONE = 0,
    WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_CLIENT_SIDE = 1,
    WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_SERVER_SIDE = 2

  WlrXdgToplevelDecoration_v1_configure* {.bycopy.} = object
    link*: WlList
    surface_configure*: ptr WlrXdgSurfaceConfigure
    mode*: WlrXdgToplevelDecoration_v1_mode

  WlrXdgToplevelDecoration_v1_state* {.bycopy.} = object
    mode*: WlrXdgToplevelDecoration_v1_mode

  WlrXdgToplevelDecoration_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    request_mode*: WlSignal

proc createWlrXdgDecorationManager_v1*(display: ptr WlDisplay): ptr WlrXdgDecorationManager_v1 {.importc: "wlr_xdg_decoration_manager_v1_create".}
proc setMode*(decoration: ptr WlrXdgToplevelDecoration_v1; mode: WlrXdgToplevelDecoration_v1_mode): uint32 {.importc: "wlr_xdg_toplevel_decoration_v1_set_mode".}

## wlr_xdg_foreign_registry

const WLR_XDG_FOREIGN_HANDLE_SIZE* = 37

type
  WlrXdgForeignRegistry* {.bycopy.} = object
    exported_surfaces*: WlList
    display_destroy*: WlListener
    events*: WlrXdgForeignRegistry_events

  WlrXdgForeignRegistry_events* {.bycopy.} = object
    destroy*: WlSignal

type
  WlrXdgForeignExported* {.bycopy.} = object
    link*: WlList
    registry*: ptr WlrXdgForeignRegistry
    surface*: ptr WlrSurface
    handle*: array[WLR_XDG_FOREIGN_HANDLE_SIZE, char]
    events*: WlrXdgForeignExported_events

  WlrXdgForeignExported_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrXdgForeignRegistry*(display: ptr WlDisplay): ptr WlrXdgForeignRegistry {.importc: "wlr_xdg_foreign_registry_create".}
proc init*(surface: ptr WlrXdgForeignExported; registry: ptr WlrXdgForeignRegistry): bool {.importc: "wlr_xdg_foreign_exported_init".}
proc findByHandle*(registry: ptr WlrXdgForeignRegistry; handle: cstring): ptr WlrXdgForeignExported {.importc: "wlr_xdg_foreign_registry_find_by_handle".}
proc finish*(surface: ptr WlrXdgForeignExported) {.importc: "wlr_xdg_foreign_exported_finish".}

## wlr_xdg_foreign_v1

type
  WlrXdgForeign_v1* {.bycopy.} = object
    exporter*: WlrXdgForeign_v1_porter
    importer*: WlrXdgForeign_v1_porter
    foreign_registry_destroy*: WlListener
    display_destroy*: WlListener
    registry*: ptr WlrXdgForeignRegistry
    events*: WlrXdgForeign_v1_events
    data*: pointer

  WlrXdgForeign_v1_porter* {.bycopy.} = object
    global*: ptr WlGlobal
    objects*: WlList

  WlrXdgForeign_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrXdgExported_v1* {.bycopy.} = object
  base*: WlrXdgForeignExported
  resource*: ptr WlResource
  xdg_surface_destroy*: WlListener
  link*: WlList

type WlrXdgImported_v1* {.bycopy.} = object
  exported*: ptr WlrXdgForeignExported
  exported_destroyed*: WlListener
  resource*: ptr WlResource
  link*: WlList
  children*: WlList

type WlrXdgImportedChild_v1* {.bycopy.} = object
  imported*: ptr WlrXdgImported_v1
  surface*: ptr WlrSurface
  link*: WlList
  xdg_surface_unmap*: WlListener
  xdg_toplevel_set_parent*: WlListener

proc createWlrXdgForeign_v1*(display: ptr WlDisplay; registry: ptr WlrXdgForeignRegistry): ptr WlrXdgForeign_v1 {.importc: "wlr_xdg_foreign_v1_create".}

## wlr_xdg_foreign_v2

type
  WlrXdgForeign_v2* {.bycopy.} = object
    exporter*: WlrXdgForeign_v2_porter
    importer*: WlrXdgForeign_v2_porter
    foreign_registry_destroy*: WlListener
    display_destroy*: WlListener
    registry*: ptr WlrXdgForeignRegistry
    events*: WlrXdgForeign_v2_events
    data*: pointer

  WlrXdgForeign_v2_porter* {.bycopy.} = object
    global*: ptr WlGlobal
    objects*: WlList

  WlrXdgForeign_v2_events* {.bycopy.} = object
    destroy*: WlSignal

type WlrXdgExported_v2* {.bycopy.} = object
  base*: WlrXdgForeignExported
  resource*: ptr WlResource
  xdg_surface_destroy*: WlListener
  link*: WlList

type WlrXdgImported_v2* {.bycopy.} = object
  exported*: ptr WlrXdgForeignExported
  exported_destroyed*: WlListener
  resource*: ptr WlResource
  link*: WlList
  children*: WlList

type WlrXdgImportedChild_v2* {.bycopy.} = object
  imported*: ptr WlrXdgImported_v2
  surface*: ptr WlrSurface
  link*: WlList
  xdg_surface_unmap*: WlListener
  xdg_toplevel_set_parent*: WlListener

proc createWlrXdgForeign_v2*(display: ptr WlDisplay; registry: ptr WlrXdgForeignRegistry): ptr WlrXdgForeign_v2 {.importc: "wlr_xdg_foreign_v2_create".}

## wlr_xdg_output

type
  WlrXdgOutput_v1* {.bycopy.} = object
    manager*: ptr WlrXdgOutputManager_v1
    resources*: WlList
    link*: WlList
    layout_output*: ptr WlrOutputLayout_output
    x*, y*: int32
    width*, height*: int32
    destroy*: WlListener
    description*: WlListener

  WlrXdgOutputManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    layout*: ptr WlrOutputLayout
    outputs*: WlList
    events*: WlrXdgOutputManager_v1_events
    display_destroy*: WlListener
    layout_add*: WlListener
    layout_change*: WlListener
    layout_destroy*: WlListener

  WlrXdgOutputManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createWlrXdgOutputManager_v1*(display: ptr WlDisplay; layout: ptr WlrOutputLayout): ptr WlrXdgOutputManager_v1 {.importc: "wlr_xdg_output_manager_v1_create".}

{.pop.}
