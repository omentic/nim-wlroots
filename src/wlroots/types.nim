{.push dynlib: "libwlroots.so".}

import std/posix
import wayland, pixman, xkb, xdg, wlroots/[backend, render, util, xcursor]

## XXX: wlr_box?

## shim TODO

type
  Swapchain = object
  OutputLayout_state = object
  OutputLayoutOutput_state = object
  CursorState = object
  LinuxDmabufFeedback_v1_compiled = object
  TabletClient_v2 = object
  TabletToolClient_v2 = object
  TabletPadClient_v2 = object
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
  Surface* {.bycopy.} = object
    resource*: ptr WlResource
    renderer*: ptr Renderer
    buffer*: ptr ClientBuffer
    sx*, sy*: cint
    buffer_damage*: PixmanRegion32
    external_damage*: PixmanRegion32
    opaque_region*: PixmanRegion32
    input_region*: PixmanRegion32
    current*: SurfaceState
    pending*: SurfaceState
    cached*: WlList
    role*: ptr Surface_role
    role_data*: pointer
    events*: Surface_events
    current_outputs*: WlList
    addons*: AddonSet
    data*: pointer
    renderer_destroy*: WlListener
    previous*: Surface_previous

  SurfaceState* {.bycopy.} = object
    committed*: uint32
    seq*: uint32
    buffer*: ptr Buffer
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
    viewport*: SurfaceState_viewport
    cached_state_locks*: csize_t
    cached_state_link*: WlList

  SurfaceState_viewport* {.bycopy.} = object
    has_src*: bool
    has_dst*: bool
    src*: Fbox
    dst_width*, dst_height*: cint

  Surface_role* {.bycopy.} = object
    name*: cstring
    commit*: proc (surface: ptr Surface)
    precommit*: proc (surface: ptr Surface)

  Surface_events* {.bycopy.} = object
    commit*: WlSignal
    new_subsurface*: WlSignal
    destroy*: WlSignal

  Surface_previous* {.bycopy.} = object
    scale*: int32
    transform*: WlOutputTransform
    width*, height*: cint
    buffer_width*, buffer_height*: cint

  Subsurface* {.bycopy.} = object
    resource*: ptr WlResource
    surface*: ptr Surface
    parent*: ptr Surface
    current*: SubsurfaceParentState
    pending*: SubsurfaceParentState
    cached_seq*: uint32
    has_cache*: bool
    synchronized*: bool
    reordered*: bool
    mapped*: bool
    added*: bool
    surface_destroy*: WlListener
    parent_destroy*: WlListener
    events*: Subsurface_events
    data*: pointer

  SubsurfaceParentState* {.bycopy.} = object
    x*, y*: int32
    link*: WlList

  Subsurface_events* {.bycopy.} = object
    destroy*: WlSignal
    map*: WlSignal
    unmap*: WlSignal

type SurfaceStateField* {.pure.} = enum
  BUFFER = 1 shl 0,
  SURFACE_DAMAGE = 1 shl 1,
  BUFFER_DAMAGE = 1 shl 2,
  OPAQUE_REGION = 1 shl 3,
  INPUT_REGION = 1 shl 4,
  TRANSFORM = 1 shl 5,
  SCALE = 1 shl 6,
  FRAME_CALLBACK_LIST = 1 shl 7,
  VIEWPORT = 1 shl 8

type SurfaceIteratorFunc_t* = proc (surface: ptr Surface; sx: cint; sy: cint; data: pointer)

## wlr_output

type
  Output* {.bycopy.} = object
    impl*: ptr Output_impl
    backend*: ptr Backend
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
    current_mode*: ptr Output_mode
    width*, height*: int32
    refresh*: int32
    enabled*: bool
    scale*: cfloat
    subpixel*: WlOutputSubpixel
    transform*: WlOutputTransform
    adaptive_sync_status*: OutputAdaptiveSyncStatus
    render_format*: uint32
    needs_frame*: bool
    frame_pending*: bool
    transform_matrix*: array[9, cfloat]
    non_desktop*: bool
    pending*: OutputState
    commit_seq*: uint32
    events*: Output_events
    idle_frame*: ptr WlEventSource
    idle_done*: ptr WlEventSource
    attach_render_locks*: cint
    cursors*: WlList
    hardware_cursor*: ptr OutputCursor
    cursor_swapchain*: ptr Swapchain
    cursor_front_buffer*: ptr Buffer
    software_cursor_locks*: cint
    allocator*: ptr Allocator
    renderer*: ptr Renderer
    swapchain*: ptr Swapchain
    back_buffer*: ptr Buffer
    display_destroy*: WlListener
    addons*: AddonSet
    data*: pointer

  Output_impl* {.bycopy.} = object
    set_cursor*: proc (output: ptr Output; buffer: ptr Buffer; hotspot_x: cint; hotspot_y: cint): bool
    move_cursor*: proc (output: ptr Output; x: cint; y: cint): bool
    destroy*: proc (output: ptr Output)
    test*: proc (output: ptr Output): bool
    commit*: proc (output: ptr Output): bool
    get_gamma_size*: proc (output: ptr Output): csize_t
    get_cursor_formats*: proc (output: ptr Output; buffer_caps: uint32): ptr DrmFormatSet
    get_cursor_size*: proc (output: ptr Output; width: ptr cint; height: ptr cint)
    get_primary_formats*: proc (output: ptr Output; buffer_caps: uint32): ptr DrmFormatSet

  OutputMode* {.bycopy.} = object
    width*, height*: int32
    refresh*: int32
    preferred*: bool
    link*: WlList

  OutputAdaptiveSyncStatus* {.pure.} = enum
    DISABLED,
    ENABLED,
    UNKNOWN

  OutputState* {.bycopy.} = object
    committed*: uint32
    damage*: PixmanRegion32
    enabled*: bool
    scale*: cfloat
    transform*: WlOutputTransform
    adaptive_sync_enabled*: bool
    render_format*: uint32
    buffer*: ptr Buffer
    mode_type*: OutputStateModeType
    mode*: ptr Output_mode
    custom_mode*: OutputState_custom_mode
    gamma_lut*: ptr uint16
    gamma_lut_size*: csize_t

  OutputStateModeType* {.pure.} = enum
    FIXED,
    CUSTOM

  OutputState_custom_mode* {.bycopy.} = object
    width*, height*: int32
    refresh*: int32

  OutputCursor* {.bycopy.} = object
    output*: ptr Output
    x*, y*: cdouble
    enabled*: bool
    visible*: bool
    width*, height*: uint32
    hotspot_x*, hotspot_y*: int32
    link*: WlList
    texture*: ptr Texture
    surface*: ptr Surface
    surface_commit*: WlListener
    surface_destroy*: WlListener
    events*: OutputCursor_events

  OutputCursor_events* {.bycopy.} = object
    destroy*: WlSignal

  Output_events* {.bycopy.} = object
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

type OutputStateField* {.pure.} = enum
  BUFFER = 1 shl 0,
  DAMAGE = 1 shl 1,
  MODE = 1 shl 2,
  ENABLED = 1 shl 3,
  SCALE = 1 shl 4,
  TRANSFORM = 1 shl 5,
  ADAPTIVE_SYNC_ENABLED = 1 shl 6,
  GAMMA_LUT = 1 shl 7,
  RENDER_FORMAT = 1 shl 8

# const WLR_OUTPUT_STATE_BACKEND_OPTIONAL*: OutputStateField =
#   WLR_OUTPUT_STATE_DAMAGE or
#   WLR_OUTPUT_STATE_SCALE or
#   WLR_OUTPUT_STATE_TRANSFORM or
#   WLR_OUTPUT_STATE_RENDER_FORMAT or
#   WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED

type OutputEventDamage* {.bycopy.} = object
  output*: ptr Output
  damage*: ptr PixmanRegion32

type OutputEventPrecommit* {.bycopy.} = object
  output*: ptr Output
  `when`*: ptr Timespec

type OutputEventCommit* {.bycopy.} = object
  output*: ptr Output
  committed*: uint32
  `when`*: ptr Timespec
  buffer*: ptr Buffer

type OutputPresentFlag* {.pure.} = enum
  VSYNC = 0x1,
  HW_CLOCK = 0x2,
  HW_COMPLETION = 0x4,
  ZERO_COPY = 0x8

type OutputEventPresent* {.bycopy.} = object
  output*: ptr Output
  commit_seq*: uint32
  presented*: bool
  `when`*: ptr Timespec
  seq*: cuint
  refresh*: cint
  flags*: uint32

type OutputEventBind* {.bycopy.} = object
  output*: ptr Output
  resource*: ptr WlResource

proc init*(output: ptr Output; backend: ptr Backend; impl: ptr Output_impl; display: ptr WlDisplay) {.importc: "wlr_output_init".}

proc updateMode*(output: ptr Output; mode: ptr OutputMode) {.importc: "wlr_output_update_mode".}
proc updateCustomMode*(output: ptr Output; width: int32; height: int32; refresh: int32) {.importc: "wlr_output_update_custom_mode".}
proc updateEnabled*(output: ptr Output; enabled: bool) {.importc: "wlr_output_update_enabled".}
proc updateNeedsFrame*(output: ptr Output) {.importc: "wlr_output_update_needs_frame".}

proc damageWhole*(output: ptr Output) {.importc: "wlr_output_damage_whole".}
proc sendFrame*(output: ptr Output) {.importc: "wlr_output_send_frame".}
proc sendPresent*(output: ptr Output; event: ptr OutputEventPresent) {.importc: "wlr_output_send_present".}

proc enable*(output: ptr Output; enable: bool) {.importc: "wlr_output_enable".}
proc createGlobal*(output: ptr Output) {.importc: "wlr_output_create_global".}
proc destroyGlobal*(output: ptr Output) {.importc: "wlr_output_destroy_global".}
# TODO proc initRender*(output: ptr Output; allocator: ptr Allocater; renderer: ptr Renderer): bool {.importc: "wlr_output_init_render".}
proc preferredMode*(output: ptr Output): ptr Output_mode {.importc: "wlr_output_preferred_mode".}
proc setMode*(output: ptr Output; mode: ptr Output_mode) {.importc: "wlr_output_set_mode".}
proc setCustomMode*(output: ptr Output; width: int32; height: int32; refresh: int32) {.importc: "wlr_output_set_custom_mode".}
proc setTransform*(output: ptr Output; transform: WlOutputTransform) {.importc: "wlr_output_set_transform".}
proc enableAdaptiveSync*(output: ptr Output; enabled: bool) {.importc: "wlr_output_enable_adaptive_sync".}

proc setRenderFormat*(output: ptr Output; format: uint32) {.importc: "wlr_output_set_render_format".}
proc setScale*(output: ptr Output; scale: cfloat) {.importc: "wlr_output_set_scale".}
proc setSubpixel*(output: ptr Output; subpixel: WlOutputSubpixel) {.importc: "wlr_output_set_subpixel".}
proc setName*(output: ptr Output; name: cstring) {.importc: "wlr_output_set_name".}
proc setDescription*(output: ptr Output; desc: cstring) {.importc: "wlr_output_set_description".}

proc scheduleDone*(output: ptr Output) {.importc: "wlr_output_schedule_done".}
proc destroy*(output: ptr Output) {.importc: "wlr_output_destroy".}
proc transformedResolution*(output: ptr Output; width: ptr cint; height: ptr cint) {.importc: "wlr_output_transformed_resolution".}
proc effectiveResolution*(output: ptr Output; width: ptr cint; height: ptr cint) {.importc: "wlr_output_effective_resolution".}
proc attachRender*(output: ptr Output; buffer_age: ptr cint): bool {.importc: "wlr_output_attach_render".}
proc attachBuffer*(output: ptr Output; buffer: ptr Buffer) {.importc: "wlr_output_attach_buffer".}
proc preferredReadFormat*(output: ptr Output): uint32 {.importc: "wlr_output_preferred_read_format".}
proc setDamage*(output: ptr Output; damage: ptr PixmanRegion32) {.importc: "wlr_output_set_damage".}
proc test*(output: ptr Output): bool {.importc: "wlr_output_test".}
proc commit*(output: ptr Output): bool {.importc: "wlr_output_commit".}
proc rollback*(output: ptr Output) {.importc: "wlr_output_rollback".}
proc scheduleFrame*(output: ptr Output) {.importc: "wlr_output_schedule_frame".}
proc getGammaSize*(output: ptr Output): csize_t {.importc: "wlr_output_get_gamma_size".}
proc setGamma*(output: ptr Output; size: csize_t; r: ptr uint16; g: ptr uint16; b: ptr uint16) {.importc: "wlr_output_set_gamma".}
proc output*(resource: ptr WlResource): ptr Output {.importc: "wlr_output_from_resource".}
proc lockAttachRender*(output: ptr Output; lock: bool) {.importc: "wlr_output_lock_attach_render".}
proc lockSoftwareCursors*(output: ptr Output; lock: bool) {.importc: "wlr_output_lock_software_cursors".}
proc renderSoftwareCursors*(output: ptr Output; damage: ptr PixmanRegion32) {.importc: "wlr_output_render_software_cursors".}
proc getPrimaryFormats*(output: ptr Output; buffer_caps: uint32): ptr DrmFormatSet {.importc: "wlr_output_get_primary_formats".}
proc createOutputCursor*(output: ptr Output): ptr OutputCursor {.importc: "wlr_output_cursor_create".}

proc setImage*(cursor: ptr OutputCursor; pixels: ptr uint8; stride: int32; width: uint32; height: uint32; hotspot_x: int32; hotspot_y: int32): bool {.importc: "wlr_output_cursor_set_image".}
proc setSurface*(cursor: ptr OutputCursor; surface: ptr Surface; hotspot_x: int32; hotspot_y: int32) {.importc: "wlr_output_cursor_set_surface".}
proc move*(cursor: ptr OutputCursor; x: cdouble; y: cdouble): bool {.importc: "wlr_output_cursor_move".}
proc destroy*(cursor: ptr OutputCursor) {.importc: "wlr_output_cursor_destroy".}

proc invert*(tr: WlOutputTransform): WlOutputTransform {.importc: "wlr_output_transform_invert".}
proc compose*(tr_a: WlOutputTransform; tr_b: WlOutputTransform): WlOutputTransform {.importc: "wlr_output_transform_compose".}

# import wlr-output-power-management-unstable-v1-protocol

type
  OutputPowerManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    output_powers*: WlList
    display_destroy*: WlListener
    events*: OutputPowerManager_v1_events
    data*: pointer

  OutputPowerManager_v1_events* {.bycopy.} = object
    set_mode*: WlSignal
    destroy*: WlSignal

type OutputPower_v1* {.bycopy.} = object
  resource*: ptr WlResource
  output*: ptr Output
  manager*: ptr OutputPowerManager_v1
  link*: WlList
  output_destroy_listener*: WlListener
  output_commit_listener*: WlListener
  data*: pointer

type OutputPower_v1_set_mode_event* {.bycopy.} = object
  output*: ptr Output
  mode*: zwlr_output_power_v1_mode

proc createOutputPowerManager_v1*(display: ptr WlDisplay): ptr OutputPowerManager_v1 {.importc: "wlr_output_power_manager_v1_create".}

## wlr_surface

type SurfaceOutput* {.bycopy.} = object
  surface*: ptr Surface
  output*: ptr Output
  link*: WlList
  `bind`*: WlListener
  destroy*: WlListener

proc setRole*(surface: ptr Surface; role: ptr Surface_role; role_data: pointer; error_resource: ptr WlResource; error_code: uint32): bool {.importc: "wlr_surface_set_role".}
proc hasBuffer*(surface: ptr Surface): bool {.importc: "wlr_surface_has_buffer".}
proc getTexture*(surface: ptr Surface): ptr Texture {.importc: "wlr_surface_get_texture".}
proc getRootSurface*(surface: ptr Surface): ptr Surface {.importc: "wlr_surface_get_root_surface".}
proc pointAcceptsInput*(surface: ptr Surface; sx: cdouble; sy: cdouble): bool {.importc: "wlr_surface_point_accepts_input".}
proc surfaceAat*(surface: ptr Surface; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr Surface {.importc: "wlr_surface_surface_at".}
proc sendEnter*(surface: ptr Surface; output: ptr Output) {.importc: "wlr_surface_send_enter".}
proc sendLeave*(surface: ptr Surface; output: ptr Output) {.importc: "wlr_surface_send_leave".}
proc sendFrameDone*(surface: ptr Surface; `when`: ptr Timespec) {.importc: "wlr_surface_send_frame_done".}
proc getExtends*(surface: ptr Surface; box: ptr Box) {.importc: "wlr_surface_get_extends".}
proc fromResource*(resource: ptr WlResource): ptr Surface {.importc: "wlr_surface_from_resource".}
proc forEach*(surface: ptr Surface; `iterator`: SurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_surface_for_each_surface".}
proc getEffectiveDamage*(surface: ptr Surface; damage: ptr PixmanRegion32) {.importc: "wlr_surface_get_effective_damage".}
proc getBufferSourceBox*(surface: ptr Surface; box: ptr Fbox) {.importc: "wlr_surface_get_buffer_source_box".}
proc lockPending*(surface: ptr Surface): uint32 {.importc: "wlr_surface_lock_pending".}
proc unlockCached*(surface: ptr Surface; seq: uint32) {.importc: "wlr_surface_unlock_cached".}

## wlr_compositor

type Subcompositor* {.bycopy.} = object
  global*: ptr WlGlobal

type
  Compositor* {.bycopy.} = object
    global*: ptr WlGlobal
    renderer*: ptr Renderer
    subcompositor*: Subcompositor
    display_destroy*: WlListener
    events*: Compositor_events

  Compositor_events* {.bycopy.} = object
    new_surface*: WlSignal
    destroy*: WlSignal

proc createCompositor*(display: ptr WlDisplay; renderer: ptr Renderer): ptr Compositor {.importc: "wlr_compositor_create".}
proc isSubsurface*(surface: ptr Surface): bool {.importc: "wlr_surface_is_subsurface".}
proc subsurface*(surface: ptr Surface): ptr Subsurface {.importc: "wlr_subsurface_from_wlr_surface".}

## wlr_switch

type
  Switch* {.bycopy.} = object
    impl*: ptr Switch_impl
    events*: Switch_events
    data*: pointer

  Switch_impl* {.bycopy.} = object
    destroy*: proc (switch_device: ptr Switch)

  Switch_events* {.bycopy.} = object
    toggle*: WlSignal

proc init*(switch_device: ptr Switch; impl: ptr Switch_impl) {.importc: "wlr_switch_init".}
proc destroy*(switch_device: ptr Switch) {.importc: "wlr_switch_destroy".}

type SwitchType* {.pure.} = enum
  LID = 1,
  TABLET_MODE

type SwitchState* {.pure.} = enum
  OFF = 0,
  ON,
  TOGGLE

## wlr_touch

type
  Touch* {.bycopy.} = object
    `impl`: ptr Touch_impl
    events*: Touch_events
    data*: pointer

  Touch_impl* {.bycopy.} = object
    destroy*: proc (touch: ptr Touch)

  Touch_events* {.bycopy.} = object
    down*: WlSignal
    up*: WlSignal
    motion*: WlSignal
    cancel*: WlSignal
    frame*: WlSignal

proc init*(touch: ptr Touch; impl: ptr Touch_impl) {.importc: "wlr_touch_init".}
proc destroy*(touch: ptr Touch) {.importc: "wlr_touch_destroy".}

## wlr_tablet_tool

type TabletToolType* {.pure.} = enum
  PEN = 1,
  ERASER,
  BRUSH,
  PENCIL,
  AIRBRUSH,
  MOUSE,
  LENS,
  TOTEM

type
  TabletTool* {.bycopy.} = object
    `type`*: TabletToolType
    hardware_serial*: uint64
    hardware_wacom*: uint64
    tilt*: bool
    pressure*: bool
    distance*: bool
    rotation*: bool
    slider*: bool
    wheel*: bool
    events*: TabletTool_events
    data*: pointer

  TabletTool_events* {.bycopy.} = object
    destroy*: WlSignal

type
  Tablet* {.bycopy.} = object
    impl*: ptr Tablet_impl
    events*: Tablet_events
    name*: cstring
    paths*: WlArray
    data*: pointer

  Tablet_impl* {.bycopy.} = object
    destroy*: proc (tablet: ptr Tablet)

  Tablet_events* {.bycopy.} = object
    axis*: WlSignal
    proximity*: WlSignal
    tip*: WlSignal
    button*: WlSignal

proc init*(tablet: ptr Tablet; impl: ptr Tablet_impl) {.importc: "wlr_tablet_init".}
proc destroy*(tablet: ptr Tablet) {.importc: "wlr_tablet_destroy".}

type TabletToolAxes* {.pure.} = enum
  X = 1 shl 0,
  Y = 1 shl 1,
  DISTANCE = 1 shl 2,
  PRESSURE = 1 shl 3,
  TILT_X = 1 shl 4,
  TILT_Y = 1 shl 5,
  ROTATION = 1 shl 6,
  SLIDER = 1 shl 7,
  WHEEL = 1 shl 8

## wlr_tablet_pad

type
  TabletPad* {.bycopy.} = object
    impl*: ptr TabletPad_impl
    events*: TabletPad_events
    button_count*: csize_t
    ring_count*: csize_t
    strip_count*: csize_t
    groups*: WlList
    paths*: WlArray
    data*: pointer

  TabletPad_impl* {.bycopy.} = object
    destroy*: proc (pad: ptr TabletPad)

  TabletPad_events* {.bycopy.} = object
    button*: WlSignal
    ring*: WlSignal
    strip*: WlSignal
    attach_tablet*: WlSignal

proc init*(pad: ptr TabletPad; impl: ptr TabletPad_impl) {.importc: "wlr_tablet_pad_init".}
proc destroy*(pad: ptr TabletPad) {.importc: "wlr_tablet_pad_destroy".}

type TabletPadGroup* {.bycopy.} = object
  link*: WlList
  button_count*: csize_t
  buttons*: ptr cuint
  strip_count*: csize_t
  strips*: ptr cuint
  ring_count*: csize_t
  rings*: ptr cuint
  mode_count*: cuint

type TabletPadRingSource* {.pure.} = enum
  UNKNOWN,
  FINGER

type EventTabletPadRing* {.bycopy.} = object
  time_msec*: uint32
  source*: TabletPadRingSource
  ring*: uint32
  position*: cdouble
  mode*: cuint

type TabletPadStripSource* {.pure.} = enum
  UNKNOWN,
  FINGER

type EventTabletPadStrip* {.bycopy.} = object
  time_msec*: uint32
  source*: TabletPadStripSource
  strip*: uint32
  position*: cdouble
  mode*: cuint

## wlr_keyboard

const WLR_LED_COUNT* = 3

type KeyboardLed* {.pure.} = enum
  NUM_LOCK = 1 shl 0,
  CAPS_LOCK = 1 shl 1,
  SCROLL_LOCK = 1 shl 2

const WLR_MODIFIER_COUNT* = 8

type KeyboardModifier* {.pure.} = enum
  SHIFT = 1 shl 0,
  CAPS = 1 shl 1,
  CTRL = 1 shl 2,
  ALT = 1 shl 3,
  MOD2 = 1 shl 4,
  MOD3 = 1 shl 5,
  LOGO = 1 shl 6,
  MOD5 = 1 shl 7

const WLR_KEYBOARD_KEYS_CAP* = 32

type
  Keyboard* {.bycopy.} = object
    impl*: ptr Keyboard_impl
    group*: ptr KeyboardGroup
    keymap_string*: cstring
    keymap_size*: csize_t
    keymap_fd*: cint
    keymap*: ptr XkbKeymap
    xkb_state*: ptr XkbState
    led_indexes*: array[WLR_LED_COUNT, XkbLedIndex]
    mod_indexes*: array[WLR_MODIFIER_COUNT, XkbModIndex]
    keycodes*: array[WLR_KEYBOARD_KEYS_CAP, uint32]
    num_keycodes*: csize_t
    modifiers*: Keyboard_modifiers
    repeat_info*: Keyboard_repeat_info
    events*: Keyboard_events
    data*: pointer

  Keyboard_impl* {.bycopy.} = object
    destroy*: proc (keyboard: ptr Keyboard)
    led_update*: proc (keyboard: ptr Keyboard; leds: uint32)

  KeyboardGroup* {.bycopy.} = object
    keyboard*: Keyboard
    input_device*: ptr InputDevice
    devices*: WlList
    keys*: WlList
    events*: KeyboardGroup_events
    data*: pointer

  KeyboardGroup_events* {.bycopy.} = object
    enter*: WlSignal
    leave*: WlSignal
  Keyboard_modifiers* {.bycopy.} = object
    depressed*: XkbModMask
    latched*: XkbModMask
    locked*: XkbModMask
    group*: XkbModMask

  Keyboard_repeat_info* {.bycopy.} = object
    rate*: int32
    delay*: int32

  Keyboard_events* {.bycopy.} = object
    key*: WlSignal
    modifiers*: WlSignal
    keymap*: WlSignal
    repeat_info*: WlSignal
    destroy*: WlSignal

  Pointer* {.bycopy.} = object
    impl*: ptr Pointer_impl
    events*: Pointer_events
    data*: pointer

  Pointer_impl* {.bycopy.} = object
    destroy*: proc (pointer: ptr Pointer)

  Pointer_events* {.bycopy.} = object
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

  EventSwitchToggle* {.bycopy.} = object
    device*: ptr InputDevice
    time_msec*: uint32
    switch_type*: SwitchType
    switch_state*: SwitchState

  EventTouchDown* {.bycopy.} = object
    device*: ptr InputDevice
    time_msec*: uint32
    touch_id*: int32
    x*, y*: cdouble

  EventTouchUp* {.bycopy.} = object
    device*: ptr InputDevice
    time_msec*: uint32
    touch_id*: int32

  EventTouchMotion* {.bycopy.} = object
    device*: ptr InputDevice
    time_msec*: uint32
    touch_id*: int32
    x*, y*: cdouble

  EventTouchCancel* {.bycopy.} = object
    device*: ptr InputDevice
    time_msec*: uint32
    touch_id*: int32

  EventTabletToolAxis* {.bycopy.} = object
    device*: ptr InputDevice
    tool*: ptr TabletTool
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

  EventTabletToolProximity* {.bycopy.} = object
    device*: ptr InputDevice
    tool*: ptr TabletTool
    time_msec*: uint32
    x*, y*: cdouble
    state*: TabletToolProximityState

  TabletToolProximityState* {.pure.} = enum
    OUT,
    IN

  EventTabletToolTip* {.bycopy.} = object
    device*: ptr InputDevice
    tool*: ptr TabletTool
    time_msec*: uint32
    x*, y*: cdouble
    state*: TabletToolTipState

  TabletToolTipState* {.pure.} = enum
    TIP_UP,
    TIP_DOWN

  EventTabletToolButton* {.bycopy.} = object
    device*: ptr InputDevice
    tool*: ptr TabletTool
    time_msec*: uint32
    button*: uint32
    state*: ButtonState

  EventTabletPadButton* {.bycopy.} = object
    time_msec*: uint32
    button*: uint32
    state*: ButtonState
    mode*: cuint
    group*: cuint

  EventPointerButton* {.bycopy.} = object
    device*: ptr InputDevice
    time_msec*: uint32
    button*: uint32
    state*: ButtonState

  ButtonState* {.pure.} = enum
    RELEASED, PRESSED

  InputDevice* {.bycopy.} = object
    impl*: ptr InputDevice_impl
    `type`*: InputDeviceType
    vendor*: cuint
    product*: cuint
    name*: cstring
    width_mm*: cdouble
    height_mm*: cdouble
    output_name*: cstring
    ano_wlr_input_device_49*: InputDevice_ano
    events*: InputDevice_events
    data*: pointer

  InputDevice_impl* {.bycopy.} = object
    destroy*: proc (wlr_device: ptr InputDevice)

  InputDeviceType* {.pure.} = enum
    KEYBOARD,
    POINTER,
    TOUCH,
    TABLET_TOOL,
    TABLET_PAD,
    SWITCH

  InputDevice_ano* {.bycopy, union.} = object
    device*: pointer # NOTE: _device
    keyboard*: ptr Keyboard
    pointer*: ptr Pointer
    switch_device*: ptr Switch
    touch*: ptr Touch
    tablet*: ptr Tablet
    tablet_pad*: ptr TabletPad

  InputDevice_events* {.bycopy.} = object
    destroy*: WlSignal

type EventKeyboardKey* {.bycopy.} = object
  time_msec*: uint32
  keycode*: uint32
  update_state*: bool
  state*: WlKeyboardKeyState

proc init*(keyboard: ptr Keyboard; impl: ptr Keyboard_impl) {.importc: "wlr_keyboard_init".}
proc destroy*(keyboard: ptr Keyboard) {.importc: "wlr_keyboard_destroy".}
proc notifyKey*(keyboard: ptr Keyboard; event: ptr EventKeyboardKey) {.importc: "wlr_keyboard_notify_key".}
proc notifyModifiers*(keyboard: ptr Keyboard; mods_depressed: uint32; mods_latched: uint32; mods_locked: uint32; group: uint32) {.importc: "wlr_keyboard_notify_modifiers".}

proc setKeymap*(kb: ptr Keyboard; keymap: ptr XkbKeymap): bool {.importc: "wlr_keyboard_set_keymap".}
proc keymapsMatch*(km1: ptr XkbKeymap; km2: ptr XkbKeymap): bool {.importc: "wlr_keyboard_keymaps_match".}

proc setRepeatInfo*(kb: ptr Keyboard; rate: int32; delay: int32) {.importc: "wlr_keyboard_set_repeat_info".}
proc ledUpdate*(keyboard: ptr Keyboard; leds: uint32) {.importc: "wlr_keyboard_led_update".}
proc getModifiers*(keyboard: ptr Keyboard): uint32 {.importc: "wlr_keyboard_get_modifiers".}

## wlr_keyboard_group

proc createKeyboardGroup*(): ptr KeyboardGroup {.importc: "wlr_keyboard_group_create".}
proc keyboardGroup*(keyboard: ptr Keyboard): ptr KeyboardGroup {.importc: "wlr_keyboard_group_from_wlr_keyboard".}
proc addKeyboard*(group: ptr KeyboardGroup; keyboard: ptr Keyboard): bool {.importc: "wlr_keyboard_group_add_keyboard".}
proc removeKeyboard*(group: ptr KeyboardGroup; keyboard: ptr Keyboard) {.importc: "wlr_keyboard_group_remove_keyboard".}
proc destroy*(group: ptr KeyboardGroup) {.importc: "wlr_keyboard_group_destroy".}

## wlr_input_device

proc init*(wlr_device: ptr InputDevice; `type`: InputDevice_type; impl: ptr InputDevice_impl; name: cstring; vendor: cint; product: cint) {.importc: "wlr_input_device_init".}
proc destroy*(dev: ptr InputDevice) {.importc: "wlr_input_device_destroy".}

## drm

proc createDrmBackend*(display: ptr WlDisplay; session: ptr Session; dev: ptr Device; parent: ptr Backend): ptr Backend {.importc: "wlr_drm_backend_create".}

proc isDrm*(backend: ptr Backend): bool {.importc: "wlr_backend_is_drm".}
proc isDrm*(output: ptr Output): bool {.importc: "wlr_output_is_drm".}

proc getId*(output: ptr Output): uint32 {.importc: "wlr_drm_connector_get_id".}

proc getNonMasterFd*(backend: ptr Backend): cint {.importc: "wlr_drm_backend_get_non_master_fd".}
proc createDrmlease*(outputs: ptr ptr Output; n_outputs: csize_t; lease_fd: ptr cint): ptr DrmLease {.importc: "wlr_drm_create_lease".}
proc terminate*(lease: ptr DrmLease) {.importc: "wlr_drm_lease_terminate".}

type drmModeModeInfo* = rmModeModeInfo # TODO: _drmModeModeInfo

proc addMode*(output: ptr Output; mode: ptr drmModeModeInfo): ptr OutputMode {.importc: "wlr_drm_connector_add_mode".}
proc getPanelOrientation*(output: ptr Output): WlOutputTransform {.importc: "wlr_drm_connector_get_panel_orientation".}

## headless

proc createHeadlessBackend*(display: ptr WlDisplay): ptr Backend {.importc: "wlr_headless_backend_create".}
proc addHeadlessOutput*(backend: ptr Backend; width: cuint; height: cuint): ptr Output {.importc: "wlr_headless_add_output".}
proc addHeadlessInputDevice*(backend: ptr Backend; `type`: InputDeviceType): ptr InputDevice {.importc: "wlr_headless_add_input_device".}

proc isHeadless*(backend: ptr Backend): bool {.importc: "wlr_backend_is_headless".}
proc isHeadless*(device: ptr InputDevice): bool {.importc: "wlr_input_device_is_headless".}
proc isHeadless*(output: ptr Output): bool {.importc: "wlr_output_is_headless".}

## libinput

proc createLibinputBackend*(display: ptr WlDisplay; session: ptr Session): ptr Backend {.importc: "wlr_libinput_backend_create".}
proc getLibinputDeviceHandle*(dev: ptr InputDevice): ptr libinput_device {.importc: "wlr_libinput_get_device_handle".}

proc isLibinput*(backend: ptr Backend): bool {.importc: "wlr_backend_is_libinput".}
proc isLibinput*(device: ptr InputDevice): bool {.importc: "wlr_input_device_is_libinput".}

## multi

proc createMultiBackend*(display: ptr WlDisplay): ptr Backend {.importc: "wlr_multi_backend_create".}

proc add*(multi: ptr Backend; backend: ptr Backend): bool {.importc: "wlr_multi_backend_add".}
proc remove*(multi: ptr Backend; backend: ptr Backend) {.importc: "wlr_multi_backend_remove".}

proc isMulti*(backend: ptr Backend): bool {.importc: "wlr_backend_is_multi".}
proc isEmpty*(backend: ptr Backend): bool {.importc: "wlr_multi_is_empty".}

proc forEach*(backend: ptr Backend; callback: proc (backend: ptr Backend; data: pointer); data: pointer) {.importc: "wlr_multi_for_each_backend".}

## wayland

proc createWaylandBackend*(display: ptr WlDisplay; remote: cstring): ptr Backend {.importc: "wlr_wl_backend_create".}
proc getRemoteDisplay*(backend: ptr Backend): ptr WlDisplay {.importc: "wlr_wl_backend_get_remote_display".}
proc createWaylandOutput*(backend: ptr Backend): ptr Output {.importc: "wlr_wl_output_create".}

proc isWL*(backend: ptr Backend): bool {.importc: "wlr_backend_is_wl".}
proc isWL*(device: ptr InputDevice): bool {.importc: "wlr_input_device_is_wl".}
proc isWL*(output: ptr Output): bool {.importc: "wlr_output_is_wl".}

proc setWaylandTitle*(output: ptr Output; title: cstring) {.importc: "wlr_wl_output_set_title".}

proc getSurface*(output: ptr Output): ptr WlSurface {.importc: "wlr_wl_output_get_surface".}
proc getSeat*(dev: ptr InputDevice): ptr WlSeat {.importc: "wlr_wl_input_device_get_seat".}

## x11

proc createX11Backend*(display: ptr WlDisplay; x11_display: cstring): ptr Backend {.importc: "wlr_x11_backend_create".}
proc createX11Output*(backend: ptr Backend): ptr Output {.importc: "wlr_x11_output_create".}

proc isX11*(backend: ptr Backend): bool {.importc: "wlr_backend_is_x11".}
proc isX11*(device: ptr InputDevice): bool {.importc: "wlr_input_device_is_x11".}
proc isX11*(output: ptr Output): bool {.importc: "wlr_output_is_x11".}

proc setX11Title*(output: ptr Output; title: cstring) {.importc: "wlr_x11_output_set_title".}

## wlr_pointer

proc init*(pointer: ptr Pointer; impl: ptr Pointer_impl) {.importc: "wlr_pointer_init".}
proc destroy*(pointer: ptr Pointer) {.importc: "wlr_pointer_destroy".}

type EventPointerMotion* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  delta_x*, delta_y*: cdouble
  unaccel_dx*, unaccel_dy*: cdouble

type EventPointerMotionAbsolute* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  x*, y*: cdouble

type AxisSource* {.pure.} = enum
  WHEEL,
  FINGER,
  CONTINUOUS,
  WHEEL_TILT

type AxisOrientation* {.pure.} = enum
  VERTICAL,
  HORIZONTAL

type EventPointerAxis* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  source*: AxisSource
  orientation*: AxisOrientation
  delta*: cdouble
  delta_discrete*: int32

type EventPointerSwipeBegin* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  fingers*: uint32

type EventPointerSwipeUpdate* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  fingers*: uint32
  dx*, dy*: cdouble

type EventPointerSwipeEnd* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  cancelled*: bool

type EventPointerPinchBegin* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  fingers*: uint32

type EventPointerPinchUpdate* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  fingers*: uint32
  dx*, dy*: cdouble
  scale*: cdouble
  rotation*: cdouble

type EventPointerPinchEnd* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  cancelled*: bool

type EventPointerHoldBegin* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  fingers*: uint32

type EventPointerHoldEnd* {.bycopy.} = object
  device*: ptr InputDevice
  time_msec*: uint32
  cancelled*: bool

## wlr_output_layout

type
  OutputLayout* {.bycopy.} = object
    outputs*: WlList
    state*: ptr OutputLayout_state
    events*: OutputLayout_events
    data*: pointer

  OutputLayout_events* {.bycopy.} = object
    add*: WlSignal
    change*: WlSignal
    destroy*: WlSignal

type
  OutputLayoutOutput* {.bycopy.} = object
    output*: ptr Output
    x*, y*: cint
    link*: WlList
    state*: ptr OutputLayoutOutput_state
    addon*: Addon
    events*: OutputLayoutOutput_events

  OutputLayoutOutput_events* {.bycopy.} = object
    destroy*: WlSignal

proc createOutputLayout*(): ptr OutputLayout {.importc: "wlr_output_layout_create".}
proc destroy*(layout: ptr OutputLayout) {.importc: "wlr_output_layout_destroy".}
proc get*(layout: ptr OutputLayout; reference: ptr Output): ptr OutputLayoutOutput {.importc: "wlr_output_layout_get".}
proc outputAt*(layout: ptr OutputLayout; lx: cdouble; ly: cdouble): ptr Output {.importc: "wlr_output_layout_output_at".}
proc add*(layout: ptr OutputLayout; output: ptr Output; lx: cint; ly: cint) {.importc: "wlr_output_layout_add".}
proc move*(layout: ptr OutputLayout; output: ptr Output; lx: cint; ly: cint) {.importc: "wlr_output_layout_move".}
proc remove*(layout: ptr OutputLayout; output: ptr Output) {.importc: "wlr_output_layout_remove".}
proc outputCoords*(layout: ptr OutputLayout; reference: ptr Output; lx: ptr cdouble; ly: ptr cdouble) {.importc: "wlr_output_layout_output_coords".}
proc containsPoint*(layout: ptr OutputLayout; reference: ptr Output; lx: cint; ly: cint): bool {.importc: "wlr_output_layout_contains_point".}
proc intersects*(layout: ptr OutputLayout; reference: ptr Output; target_lbox: ptr Box): bool {.importc: "wlr_output_layout_intersects".}
proc closestPoint*(layout: ptr OutputLayout; reference: ptr Output; lx: cdouble; ly: cdouble; dest_lx: ptr cdouble; dest_ly: ptr cdouble) {.importc: "wlr_output_layout_closest_point".}
proc getBox*(layout: ptr OutputLayout; reference: ptr Output): ptr Box {.importc: "wlr_output_layout_get_box".}
proc addAuto*(layout: ptr OutputLayout; output: ptr Output) {.importc: "wlr_output_layout_add_auto".}
proc getCenterOutput*(layout: ptr OutputLayout): ptr Output {.importc: "wlr_output_layout_get_center_output".}

type Direction* {.pure.} = enum
  UP = 1 shl 0,
  DOWN = 1 shl 1,
  LEFT = 1 shl 2,
  RIGHT = 1 shl 3

proc adjacentOutput*(layout: ptr OutputLayout; direction: Direction; reference: ptr Output; ref_lx: cdouble; ref_ly: cdouble): ptr Output {.importc: "wlr_output_layout_adjacent_output".}
proc farthestOutput*(layout: ptr OutputLayout; direction: Direction; reference: ptr Output; ref_lx: cdouble; ref_ly: cdouble): ptr Output {.importc: "wlr_output_layout_farthest_output".}

## wlr_cursor

type
  Cursor* {.bycopy.} = object
    state*: ptr CursorState
    x*, y*: cdouble
    events*: Cursor_events
    data*: pointer

  Cursor_events* {.bycopy.} = object
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

proc createCursor*(): ptr Cursor {.importc: "wlr_cursor_create".}
proc destroy*(cur: ptr Cursor) {.importc: "wlr_cursor_destroy".}
proc warp*(cur: ptr Cursor; dev: ptr InputDevice; lx: cdouble; ly: cdouble): bool {.importc: "wlr_cursor_warp".}
proc absoluteToLayoutCoords*(cur: ptr Cursor; dev: ptr InputDevice; x: cdouble; y: cdouble; lx: ptr cdouble; ly: ptr cdouble) {.importc: "wlr_cursor_absolute_to_layout_coords".}
proc warpClosest*(cur: ptr Cursor; dev: ptr InputDevice; x: cdouble; y: cdouble) {.importc: "wlr_cursor_warp_closest".}
proc warpAbsolute*(cur: ptr Cursor; dev: ptr InputDevice; x: cdouble; y: cdouble) {.importc: "wlr_cursor_warp_absolute".}
proc move*(cur: ptr Cursor; dev: ptr InputDevice; delta_x: cdouble; delta_y: cdouble) {.importc: "wlr_cursor_move".}
proc setImage*(cur: ptr Cursor; pixels: ptr uint8; stride: int32; width: uint32; height: uint32; hotspot_x: int32; hotspot_y: int32; scale: cfloat) {.importc: "wlr_cursor_set_image".}
proc setSurface*(cur: ptr Cursor; surface: ptr Surface; hotspot_x: int32; hotspot_y: int32) {.importc: "wlr_cursor_set_surface".}
proc attachInputDevice*(cur: ptr Cursor; dev: ptr InputDevice) {.importc: "wlr_cursor_attach_input_device".}
proc detachInputDevice*(cur: ptr Cursor; dev: ptr InputDevice) {.importc: "wlr_cursor_detach_input_device".}
proc attachOutputLayout*(cur: ptr Cursor; l: ptr OutputLayout) {.importc: "wlr_cursor_attach_output_layout".}
proc mapToOutput*(cur: ptr Cursor; output: ptr Output) {.importc: "wlr_cursor_map_to_output".}
proc mapInputToOutput*(cur: ptr Cursor; dev: ptr InputDevice; output: ptr Output) {.importc: "wlr_cursor_map_input_to_output".}
proc mapToRegion*(cur: ptr Cursor; box: ptr Box) {.importc: "wlr_cursor_map_to_region".}
proc mapInputToRegion*(cur: ptr Cursor; dev: ptr InputDevice; box: ptr Box) {.importc: "wlr_cursor_map_input_to_region".}

## wlr_primary_selection

type
  PrimarySelectionSource* {.bycopy.} = object
    impl*: ptr PrimarySelectionSource_impl
    mime_types*: WlArray
    events*: PrimarySelectionSource_events
    data*: pointer

  PrimarySelectionSource_impl* {.bycopy.} = object
    send*: proc (source: ptr PrimarySelectionSource; mime_type: cstring; fd: cint)
    destroy*: proc (source: ptr PrimarySelectionSource)

  PrimarySelectionSource_events* {.bycopy.} = object
    destroy*: WlSignal

## wlr_seat

const WLR_SERIAL_RINGSET_SIZE* = 128

type SerialRange* {.bycopy.} = object
  min_incl*: uint32
  max_incl*: uint32

type SerialRingset* {.bycopy.} = object
  data*: array[WLR_SERIAL_RINGSET_SIZE, SerialRange]
  `end`*: cint
  count*: cint

const WLR_POINTER_BUTTONS_CAP* = 16

type
  Seat* {.bycopy.} = object
    global*: ptr WlGlobal
    display*: ptr WlDisplay
    clients*: WlList
    name*: cstring
    capabilities*: uint32
    accumulated_capabilities*: uint32
    last_event*: Timespec
    selection_source*: ptr DataSource
    selection_serial*: uint32
    selection_offers*: WlList
    primary_selection_source*: ptr PrimarySelectionSource
    primary_selection_serial*: uint32
    drag*: ptr Drag
    drag_source*: ptr DataSource
    drag_serial*: uint32
    drag_offers*: WlList
    pointer_state*: SeatPointerState
    keyboard_state*: SeatKeyboardState
    touch_state*: SeatTouchState
    display_destroy*: WlListener
    selection_source_destroy*: WlListener
    primary_selection_source_destroy*: WlListener
    drag_source_destroy*: WlListener
    events*: Seat_events
    data*: pointer

  SeatPointerState* {.bycopy.} = object
    seat*: ptr Seat
    focused_client*: ptr SeatClient
    focused_surface*: ptr Surface
    sx*, sy*: cdouble
    grab*: ptr SeatPointerGrab
    default_grab*: ptr SeatPointerGrab
    sent_axis_source*: bool
    cached_axis_source*: AxisSource
    buttons*: array[WLR_POINTER_BUTTONS_CAP, uint32]
    button_count*: csize_t
    grab_button*: uint32
    grab_serial*: uint32
    grab_time*: uint32
    surface_destroy*: WlListener
    events*: SeatPointerState_events

  SeatPointerState_events* {.bycopy.} = object
    focus_change*: WlSignal

  SeatKeyboardState* {.bycopy.} = object
    seat*: ptr Seat
    keyboard*: ptr Keyboard
    focused_client*: ptr SeatClient
    focused_surface*: ptr Surface
    keyboard_destroy*: WlListener
    keyboard_keymap*: WlListener
    keyboard_repeat_info*: WlListener
    surface_destroy*: WlListener
    grab*: ptr SeatKeyboardGrab
    default_grab*: ptr SeatKeyboardGrab
    events*: SeatKeyboardState_events

  SeatKeyboardState_events* {.bycopy.} = object
    focus_change*: WlSignal

  SeatTouchState* {.bycopy.} = object
    seat*: ptr Seat
    touch_points*: WlList
    grab_serial*: uint32
    grab_id*: uint32
    grab*: ptr SeatTouchGrab
    default_grab*: ptr SeatTouchGrab

  Seat_events* {.bycopy.} = object
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

  SeatClient* {.bycopy.} = object
    client*: ptr WlClient
    seat*: ptr Seat
    link*: WlList
    resources*: WlList
    pointers*: WlList
    keyboards*: WlList
    touches*: WlList
    data_devices*: WlList
    events*: SeatClient_events
    serials*: SerialRingset
    needs_touch_frame*: bool

  SeatClient_events* {.bycopy.} = object
    destroy*: WlSignal

  TouchPoint* {.bycopy.} = object
    touch_id*: int32
    surface*: ptr Surface
    client*: ptr SeatClient
    focus_surface*: ptr Surface
    focus_client*: ptr SeatClient
    sx*, sy*: cdouble
    surface_destroy*: WlListener
    focus_surface_destroy*: WlListener
    client_destroy*: WlListener
    events*: TouchPoint_events
    link*: WlList

  TouchPoint_events* {.bycopy.} = object
    destroy*: WlSignal

  SeatTouchGrab* {.bycopy.} = object
    `interface`*: ptr TouchGrab_interface
    seat*: ptr Seat
    data*: pointer

  TouchGrabInterface* {.bycopy.} = object
    down*: proc (grab: ptr SeatTouchGrab; time_msec: uint32; point: ptr TouchPoint): uint32
    up*: proc (grab: ptr SeatTouchGrab; time_msec: uint32; point: ptr TouchPoint)
    motion*: proc (grab: ptr SeatTouchGrab; time_msec: uint32; point: ptr TouchPoint)
    enter*: proc (grab: ptr SeatTouchGrab; time_msec: uint32; point: ptr TouchPoint)
    frame*: proc (grab: ptr SeatTouchGrab)
    cancel*: proc (grab: ptr SeatTouchGrab)

  SeatKeyboardGrab* {.bycopy.} = object
    `interface`*: ptr KeyboardGrab_interface
    seat*: ptr Seat
    data*: pointer

  KeyboardGrabInterface* {.bycopy.} = object
    enter*: proc (grab: ptr SeatKeyboardGrab; surface: ptr Surface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr Keyboard_modifiers)
    clear_focus*: proc (grab: ptr SeatKeyboardGrab)
    key*: proc (grab: ptr SeatKeyboardGrab; time_msec: uint32; key: uint32; state: uint32)
    modifiers*: proc (grab: ptr SeatKeyboardGrab; modifiers: ptr Keyboard_modifiers)
    cancel*: proc (grab: ptr SeatKeyboardGrab)

  SeatPointerGrab* {.bycopy.} = object
    `interface`*: ptr PointerGrab_interface
    seat*: ptr Seat
    data*: pointer

  PointerGrabInterface* {.bycopy.} = object
    enter*: proc (grab: ptr SeatPointerGrab; surface: ptr Surface; sx: cdouble; sy: cdouble)
    clear_focus*: proc (grab: ptr SeatPointerGrab)
    motion*: proc (grab: ptr SeatPointerGrab; time_msec: uint32; sx: cdouble; sy: cdouble)
    button*: proc (grab: ptr SeatPointerGrab; time_msec: uint32; button: uint32; state: ButtonState): uint32
    axis*: proc (grab: ptr SeatPointerGrab; time_msec: uint32; orientation: AxisOrientation; value: cdouble; value_discrete: int32; source: AxisSource)
    frame*: proc (grab: ptr SeatPointerGrab)
    cancel*: proc (grab: ptr SeatPointerGrab)

  DataSource* {.bycopy.} = object
    impl*: ptr DataSource_impl
    mime_types*: WlArray
    actions*: int32
    accepted*: bool
    current_dnd_action*: WlDataDeviceManagerDndAction
    compositor_action*: uint32
    events*: DataSource_events

  DataSource_impl* {.bycopy.} = object
    send*: proc (source: ptr DataSource; mime_type: cstring; fd: int32)
    accept*: proc (source: ptr DataSource; serial: uint32; mime_type: cstring)
    destroy*: proc (source: ptr DataSource)
    dnd_drop*: proc (source: ptr DataSource)
    dnd_finish*: proc (source: ptr DataSource)
    dnd_action*: proc (source: ptr DataSource; action: WlDataDeviceManagerDndAction)

  DataSource_events* {.bycopy.} = object
    destroy*: WlSignal

  Drag* {.bycopy.} = object
    grab_type*: DragGrabType
    keyboard_grab*: SeatKeyboardGrab
    pointer_grab*: SeatPointerGrab
    touch_grab*: SeatTouchGrab
    seat*: ptr Seat
    seat_client*: ptr SeatClient
    focus_client*: ptr SeatClient
    icon*: ptr DragIcon
    focus*: ptr Surface
    source*: ptr DataSource
    started*: bool
    dropped*: bool
    cancelling*: bool
    grab_touch_id*: int32
    touch_id*: int32
    events*: Drag_events
    source_destroy*: WlListener
    seat_client_destroy*: WlListener
    icon_destroy*: WlListener
    data*: pointer

  Drag_events* {.bycopy.} = object
    focus*: WlSignal
    motion*: WlSignal
    drop*: WlSignal
    destroy*: WlSignal

  DragIcon* {.bycopy.} = object
    drag*: ptr Drag
    surface*: ptr Surface
    mapped*: bool
    events*: DragIcon_events
    surface_destroy*: WlListener
    data*: pointer

  DragIcon_events* {.bycopy.} = object
    map*: WlSignal
    unmap*: WlSignal
    destroy*: WlSignal

  DragGrabType* {.pure.} = enum
    KEYBOARD,
    KEYBOARD_POINTER,
    KEYBOARD_TOUCH

## wlr_primary_selection

proc init*(source: ptr PrimarySelectionSource; impl: ptr PrimarySelectionSource_impl) {.importc: "wlr_primary_selection_source_init".}
proc destroy*(source: ptr PrimarySelectionSource) {.importc: "wlr_primary_selection_source_destroy".}
proc send*(source: ptr PrimarySelectionSource; mime_type: cstring; fd: cint) {.importc: "wlr_primary_selection_source_send".}
proc requestSetPrimarySelection*(seat: ptr Seat; client: ptr SeatClient; source: ptr PrimarySelectionSource; serial: uint32) {.importc: "wlr_seat_request_set_primary_selection".}
proc setPrimarySelection*(seat: ptr Seat; source: ptr PrimarySelectionSource; serial: uint32) {.importc: "wlr_seat_set_primary_selection".}

## wlr_data_device

type
  DataDeviceManager* {.bycopy.} = object
    global*: ptr WlGlobal
    data_sources*: WlList
    display_destroy*: WlListener
    events*: DataDeviceManager_events
    data*: pointer

  DataDeviceManager_events* {.bycopy.} = object
    destroy*: WlSignal

type
  DataOffer* {.bycopy.} = object
    resource*: ptr WlResource
    source*: ptr DataSource
    `type`*: DataOfferType
    link*: WlList
    actions*: uint32
    preferred_action*: WlDataDeviceManagerDndAction
    in_ask*: bool
    source_destroy*: WlListener

  DataOfferType* {.pure.} = enum
    SELECTION, DRAG

type DragMotionEvent* {.bycopy.} = object
  drag*: ptr Drag
  time*: uint32
  sx*, sy*: cdouble

type DragDropEvent* {.bycopy.} = object
  drag*: ptr Drag
  time*: uint32

proc createDataDeviceManager*(display: ptr WlDisplay): ptr DataDeviceManager {.importc: "wlr_data_device_manager_create".}
proc requestSetSelection*(seat: ptr Seat; client: ptr SeatClient; source: ptr DataSource; serial: uint32) {.importc: "wlr_seat_request_set_selection".}
proc setSelection*(seat: ptr Seat; source: ptr DataSource; serial: uint32) {.importc: "wlr_seat_set_selection".}

proc createDrag*(seat_client: ptr SeatClient; source: ptr DataSource; icon_surface: ptr Surface): ptr Drag {.importc: "wlr_drag_create".}
proc requestStartDrag*(seat: ptr Seat; drag: ptr Drag; origin: ptr Surface; serial: uint32) {.importc: "wlr_seat_request_start_drag".}

proc startDrag*(seat: ptr Seat; drag: ptr Drag; serial: uint32) {.importc: "wlr_seat_start_drag".}
proc startPointerDrag*(seat: ptr Seat; drag: ptr Drag; serial: uint32) {.importc: "wlr_seat_start_pointer_drag".}
proc startTouchDrag*(seat: ptr Seat; drag: ptr Drag; serial: uint32; point: ptr TouchPoint) {.importc: "wlr_seat_start_touch_drag".}

proc init*(source: ptr DataSource; impl: ptr DataSource_impl) {.importc: "wlr_data_source_init".}
proc send*(source: ptr DataSource; mime_type: cstring; fd: int32) {.importc: "wlr_data_source_send".}
proc accept*(source: ptr DataSource; serial: uint32; mime_type: cstring) {.importc: "wlr_data_source_accept".}
proc destroy*(source: ptr DataSource) {.importc: "wlr_data_source_destroy".}

proc dndDrop*(source: ptr DataSource) {.importc: "wlr_data_source_dnd_drop".}
proc dndFinish*(source: ptr DataSource) {.importc: "wlr_data_source_dnd_finish".}
proc dndAction*(source: ptr DataSource; action: WlDataDeviceManagerDndAction) {.importc: "wlr_data_source_dnd_action".}

## wlr_data_device
var DataDevicePointerDragInterface*: PointerGrabInterface
var DataDeviceKeyboardDragInterface*: KeyboardGrabInterface
var DataDeviceTouchDragInterface*: TouchGrabInterface

type SeatPointerRequestSetCurserEvent* {.bycopy.} = object
  seat_client*: ptr SeatClient
  surface*: ptr Surface
  serial*: uint32
  hotspot_x*, hotspot_y*: int32

type SeatRequestSetSelectionEvent* {.bycopy.} = object
  source*: ptr DataSource
  serial*: uint32

type SeatRequestSetPrimarySelectionEvent* {.bycopy.} = object
  source*: ptr PrimarySelectionSource
  serial*: uint32

type SeatRequestStartDragEvent* {.bycopy.} = object
  drag*: ptr Drag
  origin*: ptr Surface
  serial*: uint32

type SeatPointerFocusChangeEvent* {.bycopy.} = object
  seat*: ptr Seat
  old_surface*: ptr Surface
  new_surface*: ptr Surface
  sx*, sy*: cdouble

type SeatKeyboardFocusChangeEvent* {.bycopy.} = object
  seat*: ptr Seat
  old_surface*: ptr Surface
  new_surface*: ptr Surface

proc createSeat*(display: ptr WlDisplay; name: cstring): ptr Seat {.importc: "wlr_seat_create".}
proc destroy*(wlr_seat: ptr Seat) {.importc: "wlr_seat_destroy".}
proc clientForWlClient*(wlr_seat: ptr Seat; wl_client: ptr WlClient): ptr SeatClient {.importc: "wlr_seat_client_for_wl_client".}
proc setCapabilities*(wlr_seat: ptr Seat; capabilities: uint32) {.importc: "wlr_seat_set_capabilities".}
proc setName*(wlr_seat: ptr Seat; name: cstring) {.importc: "wlr_seat_set_name".}

proc pointerSurfaceHasFocus*(wlr_seat: ptr Seat; surface: ptr Surface): bool {.importc: "wlr_seat_pointer_surface_has_focus".}
proc pointerEnter*(wlr_seat: ptr Seat; surface: ptr Surface; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_enter".}
proc pointerClearFocus*(wlr_seat: ptr Seat) {.importc: "wlr_seat_pointer_clear_focus".}
proc pointerSendMotion*(wlr_seat: ptr Seat; time_msec: uint32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_send_motion".}
proc pointerSendButton*(wlr_seat: ptr Seat; time_msec: uint32; button: uint32; state: ButtonState): uint32 {.importc: "wlr_seat_pointer_send_button".}
proc pointerSendAxis*(wlr_seat: ptr Seat; time_msec: uint32; orientation: AxisOrientation; value: cdouble; value_discrete: int32; source: AxisSource) {.importc: "wlr_seat_pointer_send_axis".}
proc pointerSendFrame*(wlr_seat: ptr Seat) {.importc: "wlr_seat_pointer_send_frame".}
proc pointerNotifyEnter*(wlr_seat: ptr Seat; surface: ptr Surface; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_notify_enter".}
proc pointerNotifyClearFocus*(wlr_seat: ptr Seat) {.importc: "wlr_seat_pointer_notify_clear_focus".}
proc pointerWarp*(wlr_seat: ptr Seat; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_warp".}
proc pointerNotifyMotion*(wlr_seat: ptr Seat; time_msec: uint32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_pointer_notify_motion".}
proc pointerNotifyButton*(wlr_seat: ptr Seat; time_msec: uint32; button: uint32; state: ButtonState): uint32 {.importc: "wlr_seat_pointer_notify_button".}
proc pointerNotifyAxis*(wlr_seat: ptr Seat; time_msec: uint32; orientation: AxisOrientation; value: cdouble; value_discrete: int32; source: AxisSource) {.importc: "wlr_seat_pointer_notify_axis".}
proc pointerNotifyFrame*(wlr_seat: ptr Seat) {.importc: "wlr_seat_pointer_notify_frame".}
proc pointerStartGrab*(wlr_seat: ptr Seat; grab: ptr SeatPointerGrab) {.importc: "wlr_seat_pointer_start_grab".}
proc pointerEndGrab*(wlr_seat: ptr Seat) {.importc: "wlr_seat_pointer_end_grab".}
proc pointerHasGrab*(seat: ptr Seat): bool {.importc: "wlr_seat_pointer_has_grab".}

proc setKeyboard*(seat: ptr Seat; dev: ptr InputDevice) {.importc: "wlr_seat_set_keyboard".}
proc getKeyboard*(seat: ptr Seat): ptr Keyboard {.importc: "wlr_seat_get_keyboard".}

proc keyboardSendKey*(seat: ptr Seat; time_msec: uint32; key: uint32; state: uint32) {.importc: "wlr_seat_keyboard_send_key".}
proc keyboardSendModifiers*(seat: ptr Seat; modifiers: ptr Keyboard_modifiers) {.importc: "wlr_seat_keyboard_send_modifiers".}
proc keyboardEnter*(seat: ptr Seat; surface: ptr Surface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr Keyboard_modifiers) {.importc: "wlr_seat_keyboard_enter".}
proc keyboardClearFocus*(wlr_seat: ptr Seat) {.importc: "wlr_seat_keyboard_clear_focus".}
proc keyboardNotifyKey*(seat: ptr Seat; time_msec: uint32; key: uint32; state: uint32) {.importc: "wlr_seat_keyboard_notify_key".}
proc keyboardNotifyModifiers*(seat: ptr Seat; modifiers: ptr Keyboard_modifiers) {.importc: "wlr_seat_keyboard_notify_modifiers".}
proc keyboardNotifyEnter*(seat: ptr Seat; surface: ptr Surface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr Keyboard_modifiers) {.importc: "wlr_seat_keyboard_notify_enter".}
proc keyboardNotifyClearFocus*(wlr_seat: ptr Seat) {.importc: "wlr_seat_keyboard_notify_clear_focus".}
proc keyboardStartGrab*(wlr_seat: ptr Seat; grab: ptr SeatKeyboardGrab) {.importc: "wlr_seat_keyboard_start_grab".}
proc keyboardEndGrab*(wlr_seat: ptr Seat) {.importc: "wlr_seat_keyboard_end_grab".}
proc keyboardHasGrab*(seat: ptr Seat): bool {.importc: "wlr_seat_keyboard_has_grab".}

proc touchGetPoint*(seat: ptr Seat; touch_id: int32): ptr TouchPoint {.importc: "wlr_seat_touch_get_point".}
proc touchPointFocus*(seat: ptr Seat; surface: ptr Surface; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_touch_point_focus".}
proc touchPointClearFocus*(seat: ptr Seat; time_msec: uint32; touch_id: int32) {.importc: "wlr_seat_touch_point_clear_focus".}
proc touchSendDown*(seat: ptr Seat; surface: ptr Surface; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble): uint32 {.importc: "wlr_seat_touch_send_down".}
proc touchSendUp*(seat: ptr Seat; time_msec: uint32; touch_id: int32) {.importc: "wlr_seat_touch_send_up".}
proc touchSendMotion*(seat: ptr Seat; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_touch_send_motion".}
proc touchSendFrame*(seat: ptr Seat) {.importc: "wlr_seat_touch_send_frame".}
proc touchNotifyDown*(seat: ptr Seat; surface: ptr Surface; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble): uint32 {.importc: "wlr_seat_touch_notify_down".}
proc touchNotifyUp*(seat: ptr Seat; time_msec: uint32; touch_id: int32) {.importc: "wlr_seat_touch_notify_up".}
proc touchNotifyMotion*(seat: ptr Seat; time_msec: uint32; touch_id: int32; sx: cdouble; sy: cdouble) {.importc: "wlr_seat_touch_notify_motion".}
proc touchNotifyFrame*(seat: ptr Seat) {.importc: "wlr_seat_touch_notify_frame".}
proc touchNumPoints*(seat: ptr Seat): cint {.importc: "wlr_seat_touch_num_points".}
proc touchStartGrab*(wlr_seat: ptr Seat; grab: ptr SeatTouchGrab) {.importc: "wlr_seat_touch_start_grab".}
proc touchEndGrab*(wlr_seat: ptr Seat) {.importc: "wlr_seat_touch_end_grab".}
proc touchHasGrab*(seat: ptr Seat): bool {.importc: "wlr_seat_touch_has_grab".}

proc validateGrabSerial*(seat: ptr Seat; serial: uint32): bool {.importc: "wlr_seat_validate_grab_serial".}
proc validatePointerGrabSerial*(seat: ptr Seat; origin: ptr Surface; serial: uint32): bool {.importc: "wlr_seat_validate_pointer_grab_serial".}
proc validateTouchGrabSerial*(seat: ptr Seat; origin: ptr Surface; serial: uint32; point_ptr: ptr ptr TouchPoint): bool {.importc: "wlr_seat_validate_touch_grab_serial".}
proc nextSerial*(client: ptr SeatClient): uint32 {.importc: "wlr_seat_client_next_serial".}
proc validateEventSerial*(client: ptr SeatClient; serial: uint32): bool {.importc: "wlr_seat_client_validate_event_serial".}
proc seatClient*(resource: ptr WlResource): ptr SeatClient {.importc: "wlr_seat_client_from_resource".}
proc seatClientFromPointerResource*(resource: ptr WlResource): ptr SeatClient {.importc: "wlr_seat_client_from_pointer_resource".}
proc acceptsTouch*(wlr_seat: ptr Seat; surface: ptr Surface): bool {.importc: "wlr_surface_accepts_touch".}

## wlr_data_control_v1

type
  DataControlManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    devices*: WlList
    events*: DataControlManager_v1_events
    display_destroy*: WlListener

  DataControlManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    new_device*: WlSignal

type DataControlDevice_v1* {.bycopy.} = object
  resource*: ptr WlResource
  manager*: ptr DataControlManager_v1
  link*: WlList
  seat*: ptr Seat
  selection_offer_resource*: ptr WlResource
  primary_selection_offer_resource*: ptr WlResource
  seat_destroy*: WlListener
  seat_set_selection*: WlListener
  seat_set_primary_selection*: WlListener

proc createDataControlManager_v1*(display: ptr WlDisplay): ptr DataControlManager_v1 {.importc: "wlr_data_control_manager_v1_create".}
proc destroy*(device: ptr DataControlDevice_v1) {.importc: "wlr_data_control_device_v1_destroy".}

## wlr_drm_lease_v1

type
  DrmLeaseDevice_v1* {.bycopy.} = object
    resources*: WlList
    global*: ptr WlGlobal
    manager*: ptr DrmLease_v1_manager
    backend*: ptr Backend
    connectors*: WlList
    leases*: WlList
    requests*: WlList
    link*: WlList
    backend_destroy*: WlListener
    data*: pointer

  DrmLease_v1_manager* {.bycopy.} = object
    devices*: WlList
    display*: ptr WlDisplay
    display_destroy*: WlListener
    events*: DrmLease_v1_manager_events

  DrmLease_v1_manager_events* {.bycopy.} = object
    request*: WlSignal

type
  DrmLease_v1* {.bycopy.} = object
    resource*: ptr WlResource
    drm_lease*: ptr DrmLease
    device*: ptr DrmLeaseDevice_v1
    connectors*: ptr ptr DrmLeaseConnector_v1
    n_connectors*: csize_t
    link*: WlList
    destroy*: WlListener
    data*: pointer

  DrmLeaseConnector_v1* {.bycopy.} = object
    resources*: WlList
    output*: ptr Output
    device*: ptr DrmLeaseDevice_v1
    active_lease*: ptr DrmLease_v1
    destroy*: WlListener
    link*: WlList

  DrmLeaseRequest_v1* {.bycopy.} = object
    resource*: ptr WlResource
    device*: ptr DrmLeaseDevice_v1
    connectors*: ptr ptr DrmLeaseConnector_v1
    n_connectors*: csize_t
    lease*: ptr DrmLease_v1
    invalid*: bool
    link*: WlList

proc createDrmLease_v1_manager*(display: ptr WlDisplay; backend: ptr Backend): ptr DrmLease_v1_manager {.importc: "wlr_drm_lease_v1_manager_create".}

proc offerOutput*(manager: ptr DrmLease_v1_manager; output: ptr Output): bool {.importc: "wlr_drm_lease_v1_manager_offer_output".}
proc withdrawOutput*(manager: ptr DrmLease_v1_manager; output: ptr Output) {.importc: "wlr_drm_lease_v1_manager_withdraw_output".}

proc grant*(request: ptr DrmLeaseRequest_v1): ptr DrmLease_v1 {.importc: "wlr_drm_lease_request_v1_grant".}
proc reject*(request: ptr DrmLeaseRequest_v1) {.importc: "wlr_drm_lease_request_v1_reject".}
proc revoke*(lease: ptr DrmLease_v1) {.importc: "wlr_drm_lease_v1_revoke".}

## wlr_drm

type DrmBuffer* {.bycopy.} = object
  base*: Buffer
  resource*: ptr WlResource
  dmabuf*: DmabufAttributes
  release*: WlListener

type
  Drm* {.bycopy.} = object
    global*: ptr WlGlobal
    renderer*: ptr Renderer
    node_name*: cstring
    events*: Drm_events
    display_destroy*: WlListener
    renderer_destroy*: WlListener

  Drm_events* {.bycopy.} = object
    destroy*: WlSignal

proc isResourceDrmBuffer*(resource: ptr WlResource): bool {.importc: "wlr_drm_buffer_is_resource".}
proc fromResourceDrmBuffer*(resource: ptr WlResource): ptr DrmBuffer {.importc: "wlr_drm_buffer_from_resource".}
proc createDrm*(display: ptr WlDisplay; renderer: ptr Renderer): ptr Drm {.importc: "wlr_drm_create".}

## wlr_export_dmabuf_v1

type
  ExportDmabufManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    frames*: WlList
    display_destroy*: WlListener
    events*: ExportDmabufManager_v1_events

  ExportDmabufManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type ExportDmabufFrame_v1* {.bycopy.} = object
  resource*: ptr WlResource
  manager*: ptr ExportDmabufManager_v1
  link*: WlList
  output*: ptr Output
  cursor_locked*: bool
  output_commit*: WlListener

proc createExportDmabufManager_v1*(display: ptr WlDisplay): ptr ExportDmabufManager_v1 {.importc: "wlr_export_dmabuf_manager_v1_create".}

## wlr_foreign_toplevel_manager

type
  ForeignToplevelManager_v1* {.bycopy.} = object
    event_loop*: ptr WlEventLoop
    global*: ptr WlGlobal
    resources*: WlList
    toplevels*: WlList
    display_destroy*: WlListener
    events*: ForeignToplevelManager_v1_events
    data*: pointer

  ForeignToplevelManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type ForeignToplevelHandle_v1_state* {.pure.} = enum
  MAXIMIZED = (1 shl 0),
  MINIMIZED = (1 shl 1),
  ACTIVATED = (1 shl 2),
  FULLSCREEN = (1 shl 3)

type
  ForeignToplevelHandle_v1* {.bycopy.} = object
    manager*: ptr ForeignToplevelManager_v1
    resources*: WlList
    link*: WlList
    idle_source*: ptr WlEventSource
    title*: cstring
    app_id*: cstring
    parent*: ptr ForeignToplevelHandle_v1
    outputs*: WlList
    state*: uint32
    events*: ForeignToplevelHandle_v1_events
    data*: pointer

  ForeignToplevelHandle_v1_events* {.bycopy.} = object
    request_maximize*: WlSignal
    request_minimize*: WlSignal
    request_activate*: WlSignal
    request_fullscreen*: WlSignal
    request_close*: WlSignal
    set_rectangle*: WlSignal
    destroy*: WlSignal

type ForeignToplevelHandle_v1_output* {.bycopy.} = object
  link*: WlList
  output*: ptr Output
  toplevel*: ptr ForeignToplevelHandle_v1
  output_bind*: WlListener
  output_destroy*: WlListener

type ForeignToplevelHandle_v1_maximized_event* {.bycopy.} = object
  toplevel*: ptr ForeignToplevelHandle_v1
  maximized*: bool

type ForeignToplevelHandle_v1_minimized_event* {.bycopy.} = object
  toplevel*: ptr ForeignToplevelHandle_v1
  minimized*: bool

type ForeignToplevelHandle_v1_activated_event* {.bycopy.} = object
  toplevel*: ptr ForeignToplevelHandle_v1
  seat*: ptr Seat

type ForeignToplevelHandle_v1_fullscreen_event* {.bycopy.} = object
  toplevel*: ptr ForeignToplevelHandle_v1
  fullscreen*: bool
  output*: ptr Output

type ForeignToplevelHandle_v1_set_rectangle_event* {.bycopy.} = object
  toplevel*: ptr ForeignToplevelHandle_v1
  surface*: ptr Surface
  x*, y*: int32
  width*, height*: int32

proc createForeignToplevelManager_v1*(display: ptr WlDisplay): ptr ForeignToplevelManager_v1 {.importc: "wlr_foreign_toplevel_manager_v1_create".}
proc createForeignToplevelHandle_v1*(manager: ptr ForeignToplevelManager_v1): ptr ForeignToplevelHandle_v1 {.importc: "wlr_foreign_toplevel_handle_v1_create".}

proc destroy*(toplevel: ptr ForeignToplevelHandle_v1) {.importc: "wlr_foreign_toplevel_handle_v1_destroy".}
proc setTitle*(toplevel: ptr ForeignToplevelHandle_v1; title: cstring) {.importc: "wlr_foreign_toplevel_handle_v1_set_title".}
proc setAppId*(toplevel: ptr ForeignToplevelHandle_v1; app_id: cstring) {.importc: "wlr_foreign_toplevel_handle_v1_set_app_id".}
proc outputEnter*(toplevel: ptr ForeignToplevelHandle_v1; output: ptr Output) {.importc: "wlr_foreign_toplevel_handle_v1_output_enter".}
proc outputLeave*(toplevel: ptr ForeignToplevelHandle_v1; output: ptr Output) {.importc: "wlr_foreign_toplevel_handle_v1_output_leave".}
proc setMaximized*(toplevel: ptr ForeignToplevelHandle_v1; maximized: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_maximized".}
proc setMinimized*(toplevel: ptr ForeignToplevelHandle_v1; minimized: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_minimized".}
proc setActivated*(toplevel: ptr ForeignToplevelHandle_v1; activated: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_activated".}
proc setFullscreen*(toplevel: ptr ForeignToplevelHandle_v1; fullscreen: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_fullscreen".}

proc setParent*(toplevel: ptr ForeignToplevelHandle_v1; parent: ptr ForeignToplevelHandle_v1) {.importc: "wlr_foreign_toplevel_handle_v1_set_parent".}

## wlr_fullscreen_shell_v1

# import fullscreen-shell-unstable-v1-protocol

type
  FullscreenShell_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    events*: FullscreenShell_v1_events
    display_destroy*: WlListener
    data*: pointer

  FullscreenShell_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    present_surface*: WlSignal

type FullscreenShell_v1_present_surface_event* {.bycopy.} = object
  client*: ptr WlClient
  surface*: ptr Surface
  `method`*: zwp_fullscreen_shell_v1_present_method
  output*: ptr Output

proc createFullscreenShell_v1*(display: ptr WlDisplay): ptr FullscreenShell_v1 {.importc: "wlr_fullscreen_shell_v1_create".}

type
  GammaControlManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    controls*: WlList
    display_destroy*: WlListener
    events*: GammaControlManager_v1_events
    data*: pointer

  GammaControlManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type GammaControl_v1* {.bycopy.} = object
  resource*: ptr WlResource
  output*: ptr Output
  link*: WlList
  table*: ptr uint16
  ramp_size*: csize_t
  output_commit_listener*: WlListener
  output_destroy_listener*: WlListener
  data*: pointer

proc createGammaControlManager_v1*(display: ptr WlDisplay): ptr GammaControlManager_v1 {.importc: "wlr_gamma_control_manager_v1_create".}

## wlr_idle_inhibit_v1

type
  IdleInhibitManager_v1* {.bycopy.} = object
    inhibitors*: WlList
    global*: ptr WlGlobal
    display_destroy*: WlListener
    events*: WllrIdleInhibitManager_v1_events
    data*: pointer

  WllrIdleInhibitManager_v1_events* {.bycopy.} = object
    new_inhibitor*: WlSignal
    destroy*: WlSignal

type
  IdleInhibitor_v1* {.bycopy.} = object
    surface*: ptr Surface
    resource*: ptr WlResource
    surface_destroy*: WlListener
    link*: WlList
    events*: IdleInhibitor_v1_events
    data*: pointer

  IdleInhibitor_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createIdleInhibit_v1*(display: ptr WlDisplay): ptr IdleInhibitManager_v1 {.importc: "wlr_idle_inhibit_v1_create".}

## wlr_idle

type
  Idle* {.bycopy.} = object
    global*: ptr WlGlobal
    idle_timers*: WlList
    event_loop*: ptr WlEventLoop
    enabled*: bool
    display_destroy*: WlListener
    events*: Idle_events
    data*: pointer

  Idle_events* {.bycopy.} = object
    activity_notify*: WlSignal
    destroy*: WlSignal

type
  IdleTimeout* {.bycopy.} = object
    resource*: ptr WlResource
    link*: WlList
    seat*: ptr Seat
    idle_source*: ptr WlEventSource
    idle_state*: bool
    enabled*: bool
    timeout*: uint32
    events*: IdleTimeout_events
    input_listener*: WlListener
    seat_destroy*: WlListener
    data*: pointer

  IdleTimeout_events* {.bycopy.} = object
    idle*: WlSignal
    resume*: WlSignal
    destroy*: WlSignal

proc createIdle*(display: ptr WlDisplay): ptr Idle {.importc: "wlr_idle_create".}
proc notifyActivity*(idle: ptr Idle; seat: ptr Seat) {.importc: "wlr_idle_notify_activity".}
proc setEnabled*(idle: ptr Idle; seat: ptr Seat; enabled: bool) {.importc: "wlr_idle_set_enabled".}
proc createIdleTimeout*(idle: ptr Idle; seat: ptr Seat; timeout: uint32): ptr IdleTimeout {.importc: "wlr_idle_timeout_create".}
proc destroy*(timeout: ptr IdleTimeout) {.importc: "wlr_idle_timeout_destroy".}

## wlr_input_inhibitor

type
  InputInhibitManager* {.bycopy.} = object
    global*: ptr WlGlobal
    active_client*: ptr WlClient
    active_inhibitor*: ptr WlResource
    display_destroy*: WlListener
    events*: InputInhibitManager_events
    data*: pointer

  InputInhibitManager_events* {.bycopy.} = object
    activate*: WlSignal
    deactivate*: WlSignal
    destroy*: WlSignal

proc createInputInhibitManager*(display: ptr WlDisplay): ptr InputInhibitManager {.importc: "wlr_input_inhibit_manager_create".}

## wlr_input_method_v2

type
  InputMethod_v2* {.bycopy.} = object
    resource*: ptr WlResource
    seat*: ptr Seat
    seat_client*: ptr SeatClient
    pending*: InputMethod_v2_state
    current*: InputMethod_v2_state
    active*: bool
    client_active*: bool
    current_serial*: uint32
    popup_surfaces*: WlList
    keyboard_grab*: ptr InputMethodKeyboardGrab_v2
    link*: WlList
    seat_client_destroy*: WlListener
    events*: InputMethod_v2_events

  InputMethod_v2_state* {.bycopy.} = object
    preedit*: InputMethod_v2_preedit_string
    commit_text*: cstring
    delete*: InputMethod_v2_delete_surrounding_text

  InputMethod_v2_preedit_string* {.bycopy.} = object
    text*: cstring
    cursor_begin*: int32
    cursor_end*: int32

  InputMethod_v2_delete_surrounding_text* {.bycopy.} = object
    before_length*: uint32
    after_length*: uint32

  InputMethodKeyboardGrab_v2* {.bycopy.} = object
    resource*: ptr WlResource
    input_method*: ptr InputMethod_v2
    keyboard*: ptr Keyboard
    keyboard_keymap*: WlListener
    keyboard_repeat_info*: WlListener
    keyboard_destroy*: WlListener
    events*: InputMethodKeyboardGrab_v2_events

  InputMethodKeyboardGrab_v2_events* {.bycopy.} = object
    destroy*: WlSignal

  InputMethod_v2_events* {.bycopy.} = object
    commit*: WlSignal
    new_popup_surface*: WlSignal
    grab_keyboard*: WlSignal
    destroy*: WlSignal

type
  InputPopupSurface_v2* {.bycopy.} = object
    resource*: ptr WlResource
    input_method*: ptr InputMethod_v2
    link*: WlList
    mapped*: bool
    surface*: ptr Surface
    surface_destroy*: WlListener
    events*: InputPopupSurface_v2_events
    data*: pointer

  InputPopupSurface_v2_events* {.bycopy.} = object
    map*: WlSignal
    unmap*: WlSignal
    destroy*: WlSignal

type
  InputMethodManager_v2* {.bycopy.} = object
    global*: ptr WlGlobal
    input_methods*: WlList
    display_destroy*: WlListener
    events*: InputMethodManager_v2_events

  InputMethodManager_v2_events* {.bycopy.} = object
    input_method*: WlSignal
    destroy*: WlSignal

proc createInputMethodManager_v2*(display: ptr WlDisplay): ptr InputMethodManager_v2 {.importc: "wlr_input_method_manager_v2_create".}
proc sendActivate*(input_method: ptr InputMethod_v2) {.importc: "wlr_input_method_v2_send_activate".}
proc sendDeactivate*(input_method: ptr InputMethod_v2) {.importc: "wlr_input_method_v2_send_deactivate".}
proc sendSurroundingText*(input_method: ptr InputMethod_v2; text: cstring; cursor: uint32; anchor: uint32) {.importc: "wlr_input_method_v2_send_surrounding_text".}
proc sendContentType*(input_method: ptr InputMethod_v2; hint: uint32; purpose: uint32) {.importc: "wlr_input_method_v2_send_content_type".}
proc sendTextChangeCause*(input_method: ptr InputMethod_v2; cause: uint32) {.importc: "wlr_input_method_v2_send_text_change_cause".}
proc send_done*(input_method: ptr InputMethod_v2) {.importc: "wlr_input_method_v2_send_done".}
proc sendUnavailable*(input_method: ptr InputMethod_v2) {.importc: "wlr_input_method_v2_send_unavailable".}

proc isInputPopupSurface_v2*(surface: ptr Surface): bool {.importc: "wlr_surface_is_input_popup_surface_v2".}
proc inputPopupSurface_v2*(surface: ptr Surface): ptr InputPopupSurface_v2 {.importc: "wlr_input_popup_surface_v2_from_wlr_surface".}
proc sendTextInputRectangle*(popup_surface: ptr InputPopupSurface_v2; sbox: ptr Box) {.importc: "wlr_input_popup_surface_v2_send_text_input_rectangle".}
proc sendKey*(keyboard_grab: ptr InputMethodKeyboardGrab_v2; time: uint32; key: uint32; state: uint32) {.importc: "wlr_input_method_keyboard_grab_v2_send_key".}
proc sendModifiers*(keyboard_grab: ptr InputMethodKeyboardGrab_v2; modifiers: ptr KeyboardModifiers) {.importc: "wlr_input_method_keyboard_grab_v2_send_modifiers".}
proc setKeyboard*(keyboard_grab: ptr InputMethodKeyboardGrab_v2; keyboard: ptr Keyboard) {.importc: "wlr_input_method_keyboard_grab_v2_set_keyboard".}
proc destroy*(keyboard_grab: ptr InputMethodKeyboardGrab_v2) {.importc: "wlr_input_method_keyboard_grab_v2_destroy".}

## wlr_keyboard_shortcuts_inhibit_v1

type
  KeyboardShortcutsInhibitManager_v1* {.bycopy.} = object
    inhibitors*: WlList
    global*: ptr WlGlobal
    display_destroy*: WlListener
    events*: KeyboardShortcutsInhibitManager_v1_events
    data*: pointer

  KeyboardShortcutsInhibitManager_v1_events* {.bycopy.} = object
    new_inhibitor*: WlSignal
    destroy*: WlSignal

type
  KeyboardShortcutsInhibitor_v1* {.bycopy.} = object
    surface*: ptr Surface
    seat*: ptr Seat
    active*: bool
    resource*: ptr WlResource
    surface_destroy*: WlListener
    seat_destroy*: WlListener
    link*: WlList
    events*: KeyboardShortcutsInhibitor_v1_events
    data*: pointer

  KeyboardShortcutsInhibitor_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createKeyboardShortcutsInhibit_v1*(display: ptr WlDisplay): ptr KeyboardShortcutsInhibitManager_v1 {.importc: "wlr_keyboard_shortcuts_inhibit_v1_create".}
proc activate*(inhibitor: ptr KeyboardShortcutsInhibitor_v1) {.importc: "wlr_keyboard_shortcuts_inhibitor_v1_activate".}
proc deactivate*(inhibitor: ptr KeyboardShortcutsInhibitor_v1) {.importc: "wlr_keyboard_shortcuts_inhibitor_v1_deactivate".}

## wlr_layer_shell_v1

# import wlr-layer-shell-unstable-v1-protocol

type
  LayerShell_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    display_destroy*: WlListener
    events*: LayerShell_v1_events
    data*: pointer

  LayerShell_v1_events* {.bycopy.} = object
    new_surface*: WlSignal
    destroy*: WlSignal

type LayerSurface_v1_state_field* {.pure.} = enum
  DESIRED_SIZE = 1 shl 0,
  ANCHOR = 1 shl 1,
  EXCLUSIVE_ZONE = 1 shl 2,
  MARGIN = 1 shl 3,
  KEYBOARD_INTERACTIVITY = 1 shl 4,
  LAYER = 1 shl 5

type
  LayerSurface_v1* {.bycopy.} = object
    surface*: ptr Surface
    output*: ptr Output
    resource*: ptr WlResource
    shell*: ptr LayerShell_v1
    popups*: WlList
    namespace*: cstring
    added*: bool
    configured*: bool
    mapped*: bool
    configure_list*: WlList
    current*: LayerSurface_v1_state
    pending*: LayerSurface_v1_state
    surface_destroy*: WlListener
    events*: LayerSurface_v1_events
    data*: pointer

  LayerSurface_v1_state_margin* {.bycopy.} = object
    top*: uint32
    right*: uint32
    bottom*: uint32
    left*: uint32

  LayerSurface_v1_state* {.bycopy.} = object
    committed*: uint32
    anchor*: uint32
    exclusive_zone*: int32
    margin*: LayerSurface_v1_state_margin
    keyboard_interactive*: zwlr_layer_surface_v1_keyboard_interactivity
    desired_width*, desired_height*: uint32
    layer*: zwlr_layer_shell_v1_layer
    configure_serial*: uint32
    actual_width*, actual_height*: uint32

  LayerSurface_v1_configure* {.bycopy.} = object
    link*: WlList
    serial*: uint32
    width*, height*: uint32

  LayerSurface_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    map*: WlSignal
    unmap*: WlSignal
    new_popup*: WlSignal

proc createLayerShell_v1*(display: ptr WlDisplay): ptr LayerShell_v1 {.importc: "wlr_layer_shell_v1_create".}
proc configure*(surface: ptr LayerSurface_v1;width: uint32; height: uint32): uint32 {.importc: "wlr_layer_surface_v1_configure".}
proc destroy*(surface: ptr LayerSurface_v1) {.importc: "wlr_layer_surface_v1_destroy".}
proc isLayerSurface*(surface: ptr Surface): bool {.importc: "wlr_surface_is_layer_surface".}
proc layerSurface_v1*(surface: ptr Surface): ptr LayerSurface_v1 {.importc: "wlr_layer_surface_v1_from_wlr_surface".}
proc forEachSurface*(surface: ptr LayerSurface_v1; `iterator`: SurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_layer_surface_v1_for_each_surface".}
proc forEachPopupSurface*(surface: ptr LayerSurface_v1; `iterator`: SurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_layer_surface_v1_for_each_popup_surface".}

proc surfaceAt*(surface: ptr LayerSurface_v1; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr Surface {.importc: "wlr_layer_surface_v1_surface_at".}
proc popupSurfaceAt*(surface: ptr LayerSurface_v1; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr Surface {.importc: "wlr_layer_surface_v1_popup_surface_at".}

## wlr_linux_dmabuf_v1

type Dmabuf_v1_buffer* {.bycopy.} = object
  base*: Buffer
  resource*: ptr WlResource
  attributes*: DmabufAttributes
  release*: WlListener

proc isBuffer*(buffer_resource: ptr WlResource): bool {.importc: "wlr_dmabuf_v1_resource_is_buffer".}
proc dmabuf_v1_buffer*(buffer_resource: ptr WlResource): ptr Dmabuf_v1_buffer {.importc: "wlr_dmabuf_v1_buffer_from_buffer_resource".}

type
  LinuxDmabufFeedback_v1* {.bycopy.} = object
    main_device*: Dev
    tranches_len*: csize_t
    tranches*: ptr LinuxDmabufFeedback_v1_tranche

  LinuxDmabufFeedback_v1_tranche* {.bycopy.} = object
    target_device*: Dev
    flags*: uint32
    formats*: ptr DrmFormatSet

type
  LinuxDmabuf_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    renderer*: ptr Renderer
    events*: LinuxDmabuf_v1_events
    default_feedback*: ptr LinuxDmabufFeedback_v1_compiled
    surfaces*: WlList
    display_destroy*: WlListener
    renderer_destroy*: WlListener

  LinuxDmabuf_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createLinuxDmabuf_v1*(display: ptr WlDisplay; renderer: ptr Renderer): ptr LinuxDmabuf_v1 {.importc: "wlr_linux_dmabuf_v1_create".}
proc setSurfaceFeedback*(linux_dmabuf: ptr LinuxDmabuf_v1; surface: ptr Surface; feedback: ptr LinuxDmabufFeedback_v1): bool {.importc: "wlr_linux_dmabuf_v1_set_surface_feedback".}

## wlr_matrix

# NOTE: float mat[static 9]
proc identity*(mat: array[9, cfloat]) {.importc: "wlr_matrix_identity".}
# NOTE: float mat[static 9], const float a[static 9], const float b[static 9]
proc multiply*(mat: array[9, cfloat]; a: array[9, cfloat]; b: array[9, cfloat]) {.importc: "wlr_matrix_multiply".}
# NOTE: float mat[static 9], const float a[static 9]
proc transpose*(mat: array[9, cfloat]; a: array[9, cfloat]) {.importc: "wlr_matrix_transpose".}
# NOTE: float mat[static 9]
proc translate*(mat: array[9, cfloat]; x: cfloat; y: cfloat) {.importc: "wlr_matrix_translate".}
# NOTE: float mat[static 9]
proc scale*(mat: array[9, cfloat]; x: cfloat; y: cfloat) {.importc: "wlr_matrix_scale".}
# NOTE: float mat[static 9]
proc rotate*(mat: array[9, cfloat]; rad: cfloat) {.importc: "wlr_matrix_rotate".}
# NOTE: float mat[static 9]
proc transform*(mat: array[9, cfloat]; transform: WlOutputTransform) {.importc: "wlr_matrix_transform".}
# NOTE: float mat[static 9]
proc projection*(mat: array[9, cfloat]; width: cint; height: cint; transform: WlOutputTransform) {.importc: "wlr_matrix_projection".}
# NOTE: float mat[static 9], const float projection[static 9]
proc projectBox*(mat: array[9, cfloat]; box: ptr Box; transform: WlOutputTransform; rotation: cfloat; projection: array[9, cfloat]) {.importc: "wlr_matrix_project_box".}

## wlr_output_damage

const WLR_OUTPUT_DAMAGE_PREVIOUS_LEN* = 2

type
  OutputDamage* {.bycopy.} = object
    output*: ptr Output
    max_rects*: cint
    current*: PixmanRegion32
    previous*: array[WLR_OUTPUT_DAMAGE_PREVIOUS_LEN, PixmanRegion32]
    previous_idx*: csize_t
    pending_attach_render*: bool
    events*: OutputDamage_events
    output_destroy*: WlListener
    output_mode*: WlListener
    output_needs_frame*: WlListener
    output_damage*: WlListener
    output_frame*: WlListener
    output_precommit*: WlListener
    output_commit*: WlListener

  OutputDamage_events* {.bycopy.} = object
    frame*: WlSignal
    destroy*: WlSignal

proc createOutputDamage*(output: ptr Output): ptr OutputDamage {.importc: "wlr_output_damage_create".}
proc destroy*(output_damage: ptr OutputDamage) {.importc: "wlr_output_damage_destroy".}
proc attachRender*(output_damage: ptr OutputDamage; needs_frame: ptr bool; buffer_damage: ptr PixmanRegion32): bool {.importc: "wlr_output_damage_attach_render".}
proc add*(output_damage: ptr OutputDamage; damage: ptr PixmanRegion32) {.importc: "wlr_output_damage_add".}
proc addWhole*(output_damage: ptr OutputDamage) {.importc: "wlr_output_damage_add_whole".}
proc addBox*(output_damage: ptr OutputDamage; box: ptr Box) {.importc: "wlr_output_damage_add_box".}

## wlr_output_power_management

type
  OutputManager_v1* {.bycopy.} = object
    display*: ptr WlDisplay
    global*: ptr WlGlobal
    resources*: WlList
    heads*: WlList
    serial*: uint32
    current_configuration_dirty*: bool
    events*: OutputManager_v1_events
    display_destroy*: WlListener
    data*: pointer

  OutputManager_v1_events* {.bycopy.} = object
    apply*: WlSignal
    test*: WlSignal
    destroy*: WlSignal

type
  OutputHead_v1* {.bycopy.} = object
    state*: OutputHead_v1_state
    manager*: ptr OutputManager_v1
    link*: WlList
    resources*: WlList
    mode_resources*: WlList
    output_destroy*: WlListener

  OutputHead_v1_state* {.bycopy.} = object
    output*: ptr Output
    enabled*: bool
    mode*: ptr Output_mode
    custom_mode*: OutputHead_v1_state_custom_mode
    x*, y*: int32
    transform*: WlOutputTransform
    scale*: cfloat

  OutputHead_v1_state_custom_mode* {.bycopy.} = object
    width*, height*: int32
    refresh*: int32

type OutputConfiguration_v1* {.bycopy.} = object
  heads*: WlList
  manager*: ptr OutputManager_v1
  serial*: uint32
  finalized*: bool
  finished*: bool
  resource*: ptr WlResource

type OutputConfigurationHead_v1* {.bycopy.} = object
  state*: OutputHead_v1_state
  config*: ptr OutputConfiguration_v1
  link*: WlList
  resource*: ptr WlResource
  output_destroy*: WlListener

proc createOutputManager_v1*(display: ptr WlDisplay): ptr OutputManager_v1 {.importc: "wlr_output_manager_v1_create".}
proc setConfiguration*(manager: ptr OutputManager_v1; config: ptr OutputConfiguration_v1) {.importc: "wlr_output_manager_v1_set_configuration".}
proc createOutputConfiguration_v1*(): ptr OutputConfiguration_v1 {.importc: "wlr_output_configuration_v1_create".}
proc destroy*(config: ptr OutputConfiguration_v1) {.importc: "wlr_output_configuration_v1_destroy".}
proc sendSucceeded*(config: ptr OutputConfiguration_v1) {.importc: "wlr_output_configuration_v1_send_succeeded".}
proc sendFailed*(config: ptr OutputConfiguration_v1) {.importc: "wlr_output_configuration_v1_send_failed".}
proc createOutputConfigurationHead_v1*(config: ptr OutputConfiguration_v1; output: ptr Output): ptr OutputConfigurationHead_v1 {.importc: "wlr_output_configuration_head_v1_create".}

## wlr_pointer_constraints_v1

# import pointer-constraints-unstable-v1-protocol

type PointerConstraint_v1_type* {.pure.} = enum
  LOCKED,
  CONFINED

type PointerConstraint_v1_state_field* {.pure.} = enum
  REGION = 1 shl 0,
  CURSOR_HINT = 1 shl 1

type
  PointerConstraint_v1* {.bycopy.} = object
    pointer_constraints*: ptr PointerConstraints_v1
    resource*: ptr WlResource
    surface*: ptr Surface
    seat*: ptr Seat
    lifetime*: zwp_pointer_constraints_v1_lifetime
    `type`*: PointerConstraint_v1_type
    region*: PixmanRegion32
    current*: PointerConstraint_v1_state
    pending*: PointerConstraint_v1_state
    surface_commit*: WlListener
    surface_destroy*: WlListener
    seat_destroy*: WlListener
    link*: WlList
    events*: PointerConstraint_v1_events
    data*: pointer

  PointerConstraint_v1_state* {.bycopy.} = object
    committed*: uint32
    region*: PixmanRegion32
    cursor_hint*: PointerConstraint_v1_state_hint

  PointerConstraint_v1_state_hint* {.bycopy.} = object
    x*, y*: cdouble

  PointerConstraint_v1_events* {.bycopy.} = object
    set_region*: WlSignal
    destroy*: WlSignal

  PointerConstraints_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    constraints*: WlList
    events*: PointerConstraints_v1_events
    display_destroy*: WlListener
    data*: pointer

  PointerConstraints_v1_events* {.bycopy.} = object
    new_constraint*: WlSignal

proc createPointerConstraints_v1*(display: ptr WlDisplay): ptr PointerConstraints_v1 {.importc: "wlr_pointer_constraints_v1_create".}
proc constraintForSurface*(pointer_constraints: ptr PointerConstraints_v1; surface: ptr Surface; seat: ptr Seat): ptr PointerConstraint_v1 {.importc: "wlr_pointer_constraints_v1_constraint_for_surface".}
proc sendActivated*(constraint: ptr PointerConstraint_v1) {.importc: "wlr_pointer_constraint_v1_send_activated".}
proc sendDeactivated*(constraint: ptr PointerConstraint_v1) {.importc: "wlr_pointer_constraint_v1_send_deactivated".}

## wlr_pointer_gestures_v1

type
  PointerGestures_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    swipes*: WlList
    pinches*: WlList
    holds*: WlList
    display_destroy*: WlListener
    events*: PointerGestures_v1_events
    data*: pointer

  PointerGestures_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createPointerGestures_v1*(display: ptr WlDisplay): ptr PointerGestures_v1 {.importc: "wlr_pointer_gestures_v1_create".}
proc sendSwipeBegin*(gestures: ptr PointerGestures_v1; seat: ptr Seat; time_msec: uint32; fingers: uint32) {.importc: "wlr_pointer_gestures_v1_send_swipe_begin".}
proc sendSwipeUpdate*(gestures: ptr PointerGestures_v1; seat: ptr Seat; time_msec: uint32; dx: cdouble; dy: cdouble) {.importc: "wlr_pointer_gestures_v1_send_swipe_update".}
proc sendSwipeEnd*(gestures: ptr PointerGestures_v1; seat: ptr Seat; time_msec: uint32; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_swipe_end".}
proc sendPinchBegin*(gestures: ptr PointerGestures_v1; seat: ptr Seat; time_msec: uint32; fingers: uint32) {.importc: "wlr_pointer_gestures_v1_send_pinch_begin".}
proc sendPinchUpdate*(gestures: ptr PointerGestures_v1; seat: ptr Seat; time_msec: uint32; dx: cdouble; dy: cdouble; scale: cdouble; rotation: cdouble) {.importc: "wlr_pointer_gestures_v1_send_pinch_update".}
proc sendPinchEnd*(gestures: ptr PointerGestures_v1; seat: ptr Seat; time_msec: uint32; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_pinch_end".}
proc sendHoldBegin*(gestures: ptr PointerGestures_v1; seat: ptr Seat; time_msec: uint32; fingers: uint32) {.importc: "wlr_pointer_gestures_v1_send_hold_begin".}
proc sendHoldEnd*(gestures: ptr PointerGestures_v1; seat: ptr Seat; time_msec: uint32; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_hold_end".}

## wlr_presentation_time

type
  Presentation* {.bycopy.} = object
    global*: ptr WlGlobal
    clock*: ClockId
    events*: Presentation_events
    display_destroy*: WlListener

  Presentation_events* {.bycopy.} = object
    destroy*: WlSignal

type PresentationFeedback* {.bycopy.} = object
  resources*: WlList
  output*: ptr Output
  output_committed*: bool
  output_commit_seq*: uint32
  output_commit*: WlListener
  output_present*: WlListener
  output_destroy*: WlListener

type PresentationEvent* {.bycopy.} = object
  output*: ptr Output
  tv_sec*: uint64
  tv_nsec*: uint32
  refresh*: uint32
  seq*: uint64
  flags*: uint32

proc createPresentation*(display: ptr WlDisplay; backend: ptr Backend): ptr Presentation {.importc: "wlr_presentation_create".}
proc surfaceSampled*(presentation: ptr Presentation; surface: ptr Surface): ptr PresentationFeedback {.importc: "wlr_presentation_surface_sampled".}
proc feedbackSendPresented*(feedback: ptr PresentationFeedback; event: ptr PresentationEvent) {.importc: "wlr_presentation_feedback_send_presented".}
proc feedbackDestroy*(feedback: ptr PresentationFeedback) {.importc: "wlr_presentation_feedback_destroy".}
proc eventFromOutput*(event: ptr Presentation_event; output_event: ptr OutputEventPresent) {.importc: "wlr_presentation_event_from_output".}
proc surfaceSampledOnOutput*(presentation: ptr Presentation; surface: ptr Surface; output: ptr Output) {.importc: "wlr_presentation_surface_sampled_on_output".}

## wlr_primary_selection_v1

type
  PrimarySelection_v1_device_manager* {.bycopy.} = object
    global*: ptr WlGlobal
    devices*: WlList
    display_destroy*: WlListener
    events*: PrimarySelection_v1_device_manager_events
    data*: pointer

  PrimarySelection_v1_device_manager_events* {.bycopy.} = object
    destroy*: WlSignal

type PrimarySelection_v1_device* {.bycopy.} = object
  manager*: ptr PrimarySelection_v1_device_manager
  seat*: ptr Seat
  link*: WlList
  resources*: WlList
  offers*: WlList
  seat_destroy*: WlListener
  seat_focus_change*: WlListener
  seat_set_primary_selection*: WlListener
  data*: pointer

proc createPrimarySelection_v1_device_manager*(display: ptr WlDisplay): ptr PrimarySelection_v1_device_manager {.importc: "wlr_primary_selection_v1_device_manager_create".}

proc region*(resource: ptr WlResource): ptr PixmanRegion32 {.importc: "wlr_region_from_resource".}

## XXX: wlr_region??

## wlr_relative_pointer

type
  RelativePointerManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    relative_pointers*: WlList
    events*: RelativePointerManager_v1_events
    display_destroy_listener*: WlListener
    data*: pointer

  RelativePointerManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    new_relative_pointer*: WlSignal

type
  RelativePointer_v1* {.bycopy.} = object
    resource*: ptr WlResource
    pointer_resource*: ptr WlResource
    seat*: ptr Seat
    link*: WlList
    events*: RelativePointer_v1_events
    seat_destroy*: WlListener
    pointer_destroy*: WlListener
    data*: pointer

  RelativePointer_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createRelativePointerManager_v1*(display: ptr WlDisplay): ptr RelativePointerManager_v1 {.importc: "wlr_relative_pointer_manager_v1_create".}
proc sendRelativeMotion*(manager: ptr RelativePointerManager_v1; seat: ptr Seat; time_usec: uint64; dx: cdouble; dy: cdouble; dx_unaccel: cdouble; dy_unaccel: cdouble) {.importc: "wlr_relative_pointer_manager_v1_send_relative_motion".}
proc relativePointer_v1*(resource: ptr WlResource): ptr RelativePointer_v1 {.importc: "wlr_relative_pointer_v1_from_resource".}

## wlr_xdg_shell

# import xdg-shell-protocol

type
  XdgClient* {.bycopy.} = object
    shell*: ptr XdgShell
    resource*: ptr WlResource
    client*: ptr WlClient
    surfaces*: WlList
    link*: WlList
    ping_serial*: uint32
    ping_timer*: ptr WlEventSource

  XdgShell* {.bycopy.} = object
    global*: ptr WlGlobal
    clients*: WlList
    popup_grabs*: WlList
    ping_timeout*: uint32
    display_destroy*: WlListener
    events*: XdgShell_events
    data*: pointer

  XdgShell_events* {.bycopy.} = object
    new_surface*: WlSignal
    destroy*: WlSignal

type
  XdgPositioner* {.bycopy.} = object
    anchor_rect*: Box
    anchor*: XdgPositionerAnchor
    gravity*: XdgPositionerGravity
    constraint_adjustment*: XdgPositionerConstraintAdjustment
    size*: XdgPositioner_size
    offset*: XdgPositioner_offset

  XdgPositioner_size* {.bycopy.} = object
    width*, height*: int32

  XdgPositioner_offset* {.bycopy.} = object
    x*, y*: int32

type XdgSurfaceRole* {.pure.} = enum
  NONE,
  TOPLEVEL,
  POPUP

type
  XdgSurface* {.bycopy.} = object
    client*: ptr XdgClient
    resource*: ptr WlResource
    surface*: ptr Surface
    link*: WlList
    role*: XdgSurfaceRole
    ano_wlr_xdg_shell_189*: XdgSurface_ano
    popups*: WlList
    added*: bool
    configured*: bool
    mapped*: bool
    configure_idle*: ptr WlEventSource
    scheduled_serial*: uint32
    configure_list*: WlList
    current*: XdgSurfaceState
    pending*: XdgSurfaceState
    surface_destroy*: WlListener
    surface_commit*: WlListener
    events*: XdgSurface_events
    data*: pointer

  XdgSurfaceConfigure* {.bycopy.} = object
    surface*: ptr XdgSurface
    link*: WlList
    serial*: uint32
    toplevel_configure*: ptr XdgToplevelConfigure

  XdgSurfaceState* {.bycopy.} = object
    configure_serial*: uint32
    geometry*: Box

  XdgSurface_ano* {.bycopy, union.} = object
    toplevel*: ptr XdgToplevel
    popup*: ptr XdgPopup

  XdgSurface_events* {.bycopy.} = object
    destroy*: WlSignal
    ping_timeout*: WlSignal
    new_popup*: WlSignal
    map*: WlSignal
    unmap*: WlSignal
    configure*: WlSignal
    ack_configure*: WlSignal

  XdgPopup* {.bycopy.} = object
    base*: ptr XdgSurface
    link*: WlList
    resource*: ptr WlResource
    committed*: bool
    parent*: ptr Surface
    seat*: ptr Seat
    geometry*: Box
    positioner*: XdgPositioner
    grab_link*: WlList

  XdgPopupGrab* {.bycopy.} = object
    client*: ptr WlClient
    pointer_grab*: SeatPointerGrab
    keyboard_grab*: SeatKeyboardGrab
    touch_grab*: SeatTouchGrab
    seat*: ptr Seat
    popups*: WlList
    link*: WlList
    seat_destroy*: WlListener

  XdgToplevel* {.bycopy.} = object
    resource*: ptr WlResource
    base*: ptr XdgSurface
    added*: bool
    parent*: ptr XdgSurface
    parent_unmap*: WlListener
    current*: XdgToplevelState
    pending*: XdgToplevelState
    scheduled*: XdgToplevelConfigure
    requested*: XdgToplevelRequested
    title*: cstring
    app_id*: cstring
    events*: XdgToplevel_events

  XdgToplevelState* {.bycopy.} = object
    maximized*: bool
    fullscreen*: bool
    resizing*: bool
    activated*: bool
    tiled*: uint32
    width*, height*: uint32
    max_width*, max_height*: uint32
    min_width*, min_height*: uint32

  XdgToplevelConfigure* {.bycopy.} = object
    maximized*: bool
    fullscreen*: bool
    resizing*: bool
    activated*: bool
    tiled*: uint32
    width*, height*: uint32

  XdgToplevelRequested* {.bycopy.} = object
    maximized*: bool
    minimized*: bool
    fullscreen*: bool
    fullscreen_output*: ptr Output
    fullscreen_output_destroy*: WlListener

  XdgToplevel_events* {.bycopy.} = object
    request_maximize*: WlSignal
    request_fullscreen*: WlSignal
    request_minimize*: WlSignal
    request_move*: WlSignal
    request_resize*: WlSignal
    request_show_window_menu*: WlSignal
    set_parent*: WlSignal
    set_title*: WlSignal
    set_app_id*: WlSignal

type XdgToplevelMoveEvent* {.bycopy.} = object
  surface*: ptr XdgSurface
  seat*: ptr SeatClient
  serial*: uint32

type XdgToplevelResizeEvent* {.bycopy.} = object
  surface*: ptr XdgSurface
  seat*: ptr SeatClient
  serial*: uint32
  edges*: uint32

type XdgToplevelSetFullscreenEvent* {.bycopy.} = object
  surface*: ptr XdgSurface
  fullscreen*: bool
  output*: ptr Output

type XdgToplevelShowWindowMenuEvent* {.bycopy.} = object
  surface*: ptr XdgSurface
  seat*: ptr SeatClient
  serial*: uint32
  x*, y*: uint32

proc createXdgShell*(display: ptr WlDisplay): ptr XdgShell {.importc: "wlr_xdg_shell_create".}
proc xdgSurface*(resource: ptr WlResource): ptr XdgSurface {.importc: "wlr_xdg_surface_from_resource".}
proc xdgSurfaceFromPopup*(resource: ptr WlResource): ptr XdgSurface {.importc: "wlr_xdg_surface_from_popup_resource".}
proc xdgSurfaceFromToplevel*(resource: ptr WlResource): ptr XdgSurface {.importc: "wlr_xdg_surface_from_toplevel_resource".}
proc ping*(surface: ptr XdgSurface) {.importc: "wlr_xdg_surface_ping".}
proc setSizeToplevel*(surface: ptr XdgSurface; width: uint32; height: uint32): uint32 {.importc: "wlr_xdg_toplevel_set_size".}
proc setActivatedToplevel*(surface: ptr XdgSurface; activated: bool): uint32 {.importc: "wlr_xdg_toplevel_set_activated".}
proc setMaximizedToplevel*(surface: ptr XdgSurface; maximized: bool): uint32 {.importc: "wlr_xdg_toplevel_set_maximized".}
proc setFullscreenToplevel*(surface: ptr XdgSurface; fullscreen: bool): uint32 {.importc: "wlr_xdg_toplevel_set_fullscreen".}
proc setResizingToplevel*(surface: ptr XdgSurface; resizing: bool): uint32 {.importc: "wlr_xdg_toplevel_set_resizing".}
proc setTiledToplevel*(surface: ptr XdgSurface; tiled_edges: uint32): uint32 {.importc: "wlr_xdg_toplevel_set_tiled".}
proc sendCloseToplevel*(surface: ptr XdgSurface) {.importc: "wlr_xdg_toplevel_send_close".}
proc setParentToplevel*(surface: ptr XdgSurface; parent: ptr XdgSurface) {.importc: "wlr_xdg_toplevel_set_parent".}
proc destroy*(surface: ptr XdgSurface) {.importc: "wlr_xdg_popup_destroy".}
proc getPosition*(popup: ptr XdgPopup; popup_sx: ptr cdouble; popup_sy: ptr cdouble) {.importc: "wlr_xdg_popup_get_position".}
proc getGeometry*(positioner: ptr XdgPositioner): Box {.importc: "wlr_xdg_positioner_get_geometry".}
proc getAnchorPoint*(popup: ptr XdgPopup; toplevel_sx: ptr cint; toplevel_sy: ptr cint) {.importc: "wlr_xdg_popup_get_anchor_point".}
proc getToplevelCoords*(popup: ptr XdgPopup; popup_sx: cint; popup_sy: cint; toplevel_sx: ptr cint; toplevel_sy: ptr cint) {.importc: "wlr_xdg_popup_get_toplevel_coords".}
proc unconstrainFromBox*(popup: ptr XdgPopup; toplevel_sx_box: ptr Box) {.importc: "wlr_xdg_popup_unconstrain_from_box".}
proc invertX*(positioner: ptr XdgPositioner) {.importc: "wlr_positioner_invert_x".}
proc invertY*(positioner: ptr XdgPositioner) {.importc: "wlr_positioner_invert_y".}
proc surfaceAt*(surface: ptr XdgSurface; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr Surface {.importc: "wlr_xdg_surface_surface_at".}
proc popupSurfaceAt*(surface: ptr XdgSurface; sx: cdouble; sy: cdouble; sub_x: ptr cdouble; sub_y: ptr cdouble): ptr Surface {.importc: "wlr_xdg_surface_popup_surface_at".}
proc isXdgSurface*(surface: ptr Surface): bool {.importc: "wlr_surface_is_xdg_surface".}
proc xdgSurface*(surface: ptr Surface): ptr XdgSurface {.importc: "wlr_xdg_surface_from_wlr_surface".}
proc getGeometry*(surface: ptr XdgSurface; box: ptr Box) {.importc: "wlr_xdg_surface_get_geometry".}
proc forEachSurface*(surface: ptr XdgSurface; `iterator`: SurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_xdg_surface_for_each_surface".}
proc forEachPopupSurface*(surface: ptr XdgSurface; `iterator`: SurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_xdg_surface_for_each_popup_surface".}
proc scheduleConfigure*(surface: ptr XdgSurface): uint32 {.importc: "wlr_xdg_surface_schedule_configure".}

## wlr_scene

type SceneNodeType* {.pure.} = enum
  ROOT,
  TREE,
  SURFACE,
  RECT,
  BUFFER

type SceneNode_state* {.bycopy.} = object
  link*: WlList
  children*: WlList
  enabled*: bool
  x*, y*: cint

type
  SceneNode* {.bycopy.} = object
    `type`*: SceneNodeType
    parent*: ptr SceneNode
    state*: SceneNode_state
    events*: SceneNode_events
    data*: pointer

  SceneNode_events* {.bycopy.} = object
    destroy*: WlSignal

type Scene* {.bycopy.} = object
  node*: SceneNode
  outputs*: WlList
  presentation*: ptr Presentation
  presentation_destroy*: WlListener
  pending_buffers*: WlList

type SceneTree* {.bycopy.} = object
  node*: SceneNode

type SceneSurface* {.bycopy.} = object
  node*: SceneNode
  surface*: ptr Surface
  primary_output*: ptr Output
  prev_width*, prev_height*: cint
  surface_destroy*: WlListener
  surface_commit*: WlListener

type SceneRect* {.bycopy.} = object
  node*: SceneNode
  width*, height*: cint
  color*: array[4, cfloat]

type SceneBuffer* {.bycopy.} = object
  node*: SceneNode
  buffer*: ptr Buffer
  texture*: ptr Texture
  src_box*: Fbox
  dst_width*, dst_height*: cint
  transform*: WlOutputTransform
  pending_link*: WlList

type SceneOutput* {.bycopy.} = object
  output*: ptr Output
  link*: WlList
  scene*: ptr Scene
  addon*: Addon
  damage*: ptr OutputDamage
  x*, y*: cint
  prev_scanout*: bool

type SceneNodeIteratorFunc_t* = proc (node: ptr SceneNode; sx: cint; sy: cint; data: pointer)

proc destroy*(node: ptr SceneNode) {.importc: "wlr_scene_node_destroy".}
proc setEnabled*(node: ptr SceneNode; enabled: bool) {.importc: "wlr_scene_node_set_enabled".}
proc setPosition*(node: ptr SceneNode; x: cint; y: cint) {.importc: "wlr_scene_node_set_position".}
proc placeAbove*(node: ptr SceneNode; sibling: ptr SceneNode) {.importc: "wlr_scene_node_place_above".}
proc placeBelow*(node: ptr SceneNode; sibling: ptr SceneNode) {.importc: "wlr_scene_node_place_below".}
proc raiseToTop*(node: ptr SceneNode) {.importc: "wlr_scene_node_raise_to_top".}
proc lowerToBottom*(node: ptr SceneNode) {.importc: "wlr_scene_node_lower_to_bottom".}
proc reparent*(node: ptr SceneNode; new_parent: ptr SceneNode) {.importc: "wlr_scene_node_reparent".}
proc coords*(node: ptr SceneNode; lx: ptr cint; ly: ptr cint): bool {.importc: "wlr_scene_node_coords".}
proc forEachSurface*(node: ptr SceneNode; `iterator`: SurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_scene_node_for_each_surface".}
proc at*(node: ptr SceneNode; lx: cdouble; ly: cdouble; nx: ptr cdouble; ny: ptr cdouble): ptr SceneNode {.importc: "wlr_scene_node_at".}
proc createScene*(): ptr Scene {.importc: "wlr_scene_create".}
proc render_output*(scene: ptr Scene; output: ptr Output; lx: cint; ly: cint; damage: ptr PixmanRegion32) {.importc: "wlr_scene_render_output".}
proc set_presentation*(scene: ptr Scene; presentation: ptr Presentation) {.importc: "wlr_scene_set_presentation".}
proc createSceneTree*(parent: ptr SceneNode): ptr SceneTree {.importc: "wlr_scene_tree_create".}
proc createSceneSurface*(parent: ptr SceneNode; surface: ptr Surface): ptr SceneSurface {.importc: "wlr_scene_surface_create".}
proc sceneSurface*(node: ptr SceneNode): ptr SceneSurface {.importc: "wlr_scene_surface_from_node".}
# NOTE: const float color[static 4]
proc createSceneRect*(parent: ptr SceneNode; width: cint; height: cint; color: array[4, cfloat]): ptr SceneRect {.importc: "wlr_scene_rect_create".}
proc setSize*(rect: ptr SceneRect; width: cint; height: cint) {.importc: "wlr_scene_rect_set_size".}
# NOTE: const float color[static 4]
proc setColor*(rect: ptr SceneRect; color: array[4, cfloat]) {.importc: "wlr_scene_rect_set_color".}
proc createSceneBuffer*(parent: ptr SceneNode; buffer: ptr Buffer): ptr SceneBuffer {.importc: "wlr_scene_buffer_create".}
proc setSourceBox*(scene_buffer: ptr SceneBuffer; box: ptr Fbox) {.importc: "wlr_scene_buffer_set_source_box".}
proc setDestSize*(scene_buffer: ptr SceneBuffer; width: cint; height: cint) {.importc: "wlr_scene_buffer_set_dest_size".}
proc setTransform*(scene_buffer: ptr SceneBuffer; transform: WlOutputTransform) {.importc: "wlr_scene_buffer_set_transform".}
proc createSceneOutput*(scene: ptr Scene; output: ptr Output): ptr SceneOutput {.importc: "wlr_scene_output_create".}
proc destroy*(scene_output: ptr SceneOutput) {.importc: "wlr_scene_output_destroy".}
proc setPosition*(scene_output: ptr SceneOutput; lx: cint; ly: cint) {.importc: "wlr_scene_output_set_position".}
proc commit*(scene_output: ptr SceneOutput): bool {.importc: "wlr_scene_output_commit".}
proc sendFrameDone*(scene_output: ptr SceneOutput; now: ptr Timespec) {.importc: "wlr_scene_output_send_frame_done".}
proc forEachSurface*(scene_output: ptr SceneOutput; `iterator`: SurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_scene_output_for_each_surface".}
proc getSceneOutput*(scene: ptr Scene; output: ptr Output): ptr SceneOutput {.importc: "wlr_scene_get_scene_output".}
proc attachOutputLayout*(scene: ptr Scene; output_layout: ptr OutputLayout): bool {.importc: "wlr_scene_attach_output_layout".}
proc createSceneSubsurfaceTree*(parent: ptr SceneNode; surface: ptr Surface): ptr SceneNode {.importc: "wlr_scene_subsurface_tree_create".}
proc createSceneXdgSurface*(parent: ptr SceneNode; xdg_surface: ptr XdgSurface): ptr SceneNode {.importc: "wlr_scene_xdg_surface_create".}

## wlr_screencopy_v1

type
  ScreencopyManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    frames*: WlList
    display_destroy*: WlListener
    events*: ScreencopyManager_v1_events
    data*: pointer

  ScreencopyManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type Screencopy_v1_client* {.bycopy.} = object
  `ref`*: cint
  manager*: ptr ScreencopyManager_v1
  damages*: WlList

type ScreencopyFrame_v1* {.bycopy.} = object
  resource*: ptr WlResource
  client*: ptr Screencopy_v1_client
  link*: WlList
  format*: WlShmFormat
  fourcc*: uint32
  box*: Box
  stride*: cint
  overlay_cursor*: bool
  cursor_locked*: bool
  with_damage*: bool
  shm_buffer*: ptr WlShmBuffer
  dma_buffer*: ptr Dmabuf_v1_buffer
  buffer_destroy*: WlListener
  output*: ptr Output
  output_commit*: WlListener
  output_destroy*: WlListener
  output_enable*: WlListener
  data*: pointer

proc createScreencopyManager_v1*(display: ptr WlDisplay): ptr ScreencopyManager_v1 {.importc: "wlr_screencopy_manager_v1_create".}

## wlr_server_decoration

type ServerDecorationManagerMode* {.pure.} = enum
  NONE = 0,
  CLIENT = 1,
  SERVER = 2

type
  ServerDecorationManager* {.bycopy.} = object
    global*: ptr WlGlobal
    resources*: WlList
    decorations*: WlList
    default_mode*: uint32
    display_destroy*: WlListener
    events*: ServerDecorationManager_events
    data*: pointer

  ServerDecorationManager_events* {.bycopy.} = object
    new_decoration*: WlSignal
    destroy*: WlSignal

type
  ServerDecoration* {.bycopy.} = object
    resource*: ptr WlResource
    surface*: ptr Surface
    link*: WlList
    mode*: uint32
    events*: ServerDecoration_events
    surface_destroy_listener*: WlListener
    data*: pointer

  ServerDecoration_events* {.bycopy.} = object
    destroy*: WlSignal
    mode*: WlSignal

proc createServerDecoration*(display: ptr WlDisplay): ptr ServerDecorationManager {.importc: "wlr_server_decoration_manager_create".}
proc setDefaultMode*(manager: ptr ServerDecorationManager; default_mode: uint32) {.importc: "wlr_server_decoration_manager_set_default_mode".}

## wlr_tablet_v2

# import tablet-unstable-v2-protocol

const WLR_TABLET_V2_TOOL_BUTTONS_CAP* = 16

type
  TabletManager_v2* {.bycopy.} = object
    wl_global*: ptr WlGlobal
    clients*: WlList
    seats*: WlList
    display_destroy*: WlListener
    events*: TabletManager_v2_events
    data*: pointer

  TabletManager_v2_events* {.bycopy.} = object
    destroy*: WlSignal

type Tablet_v2_tablet* {.bycopy.} = object
  link*: WlList
  wlr_tablet*: ptr Tablet
  wlr_device*: ptr InputDevice
  clients*: WlList
  tool_destroy*: WlListener
  current_client*: ptr TabletClient_v2

type
  Tablet_v2_tablet_tool* {.bycopy.} = object
    link*: WlList
    wlr_tool*: ptr TabletTool
    clients*: WlList
    tool_destroy*: WlListener
    current_client*: ptr TabletToolClient_v2
    focused_surface*: ptr Surface
    surface_destroy*: WlListener
    grab*: ptr TabletTool_v2_grab
    default_grab*: TabletTool_v2_grab
    proximity_serial*: uint32
    is_down*: bool
    down_serial*: uint32
    num_buttons*: csize_t
    pressed_buttons*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32]
    pressed_serials*: array[WLR_TABLET_V2_TOOL_BUTTONS_CAP, uint32]
    events*: Tablet_v2_tablet_tool_events

  TabletTool_v2_grab* {.bycopy.} = object
    `interface`*: ptr TabletTool_v2_grab_interface
    tool*: ptr Tablet_v2_tablet_tool
    data*: pointer

  TabletTool_v2_grab_interface* {.bycopy.} = object
    proximityIn*: proc (grab: ptr TabletTool_v2_grab; tablet: ptr Tablet_v2_tablet; surface: ptr Surface)
    down*: proc (grab: ptr TabletTool_v2_grab)
    up*: proc (grab: ptr TabletTool_v2_grab)
    motion*: proc (grab: ptr TabletTool_v2_grab; x: cdouble; y: cdouble)
    pressure*: proc (grab: ptr TabletTool_v2_grab; pressure: cdouble)
    distance*: proc (grab: ptr TabletTool_v2_grab; distance: cdouble)
    tilt*: proc (grab: ptr TabletTool_v2_grab; x: cdouble; y: cdouble)
    rotation*: proc (grab: ptr TabletTool_v2_grab; degrees: cdouble)
    slider*: proc (grab: ptr TabletTool_v2_grab; position: cdouble)
    wheel*: proc (grab: ptr TabletTool_v2_grab; degrees: cdouble; clicks: int32)
    proximityOut*: proc (grab: ptr TabletTool_v2_grab)
    button*: proc (grab: ptr TabletTool_v2_grab; button: uint32; state: zwp_tablet_pad_v2_button_state)
    cancel*: proc (grab: ptr TabletTool_v2_grab)

  Tablet_v2_tablet_tool_events* {.bycopy.} = object
    set_cursor*: WlSignal

type
  Tablet_v2_tablet_pad* {.bycopy.} = object
    link*: WlList
    wlr_pad*: ptr TabletPad
    wlr_device*: ptr InputDevice
    clients*: WlList
    group_count*: csize_t
    groups*: ptr uint32
    pad_destroy*: WlListener
    current_client*: ptr TabletPadClient_v2
    grab*: ptr TabletPad_v2_grab
    default_grab*: TabletPad_v2_grab
    events*: Tablet_v2_tablet_pad_events

  TabletPad_v2_grab* {.bycopy.} = object
    `interface`*: ptr TabletPad_v2_grab_interface
    pad*: ptr Tablet_v2_tablet_pad
    data*: pointer

  TabletPad_v2_grab_interface* {.bycopy.} = object
    enter*: proc (grab: ptr TabletPad_v2_grab; tablet: ptr Tablet_v2_tablet; surface: ptr Surface): uint32
    button*: proc (grab: ptr TabletPad_v2_grab; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state)
    strip*: proc (grab: ptr TabletPad_v2_grab; strip: uint32; position: cdouble; finger: bool; time: uint32)
    ring*: proc (grab: ptr TabletPad_v2_grab; ring: uint32; position: cdouble; finger: bool; time: uint32)
    leave*: proc (grab: ptr TabletPad_v2_grab; surface: ptr Surface): uint32
    mode*: proc (grab: ptr TabletPad_v2_grab; group: csize_t; mode: uint32; time: uint32): uint32
    cancel*: proc (grab: ptr TabletPad_v2_grab)

  Tablet_v2_tablet_pad_events* {.bycopy.} = object
    button_feedback*: WlSignal
    strip_feedback*: WlSignal
    ring_feedback*: WlSignal

type Tablet_v2_event_cursor* {.bycopy.} = object
  surface*: ptr Surface
  serial*: uint32
  hotspot_x*, hotspot_y*: int32
  seat_client*: ptr SeatClient

type WltTablet_v2_event_feedback* {.bycopy.} = object
  description*: cstring
  index*: csize_t
  serial*: uint32

proc createTablet*(manager: ptr TabletManager_v2; wlr_seat: ptr Seat; wlr_device: ptr InputDevice): ptr Tablet_v2_tablet {.importc: "wlr_tablet_create".}
proc createTabletPad*(manager: ptr TabletManager_v2; wlr_seat: ptr Seat; wlr_device: ptr InputDevice): ptr Tablet_v2_tablet_pad {.importc: "wlr_tablet_pad_create".}
proc createTabletTool*(manager: ptr TabletManager_v2; wlr_seat: ptr Seat; wlr_tool: ptr TabletTool): ptr Tablet_v2_tablet_tool {.importc: "wlr_tablet_tool_create".}
proc createTablet*(display: ptr WlDisplay): ptr TabletManager_v2 {.importc: "wlr_tablet_v2_create".}

proc proximityIn*(tool: ptr Tablet_v2_tablet_tool; tablet: ptr Tablet_v2_tablet; surface: ptr Surface) {.importc: "wlr_send_tablet_v2_tablet_tool_proximity_in".}
proc down*(tool: ptr Tablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_down".}
proc up*(tool: ptr Tablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_up".}
proc motion*(tool: ptr Tablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_motion".}
proc pressure*(tool: ptr Tablet_v2_tablet_tool; pressure: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_pressure".}
proc distance*(tool: ptr Tablet_v2_tablet_tool; distance: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_distance".}
proc tilt*(tool: ptr Tablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_tilt".}
proc rotation*(tool: ptr Tablet_v2_tablet_tool; degrees: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_rotation".}
proc slider*(tool: ptr Tablet_v2_tablet_tool; position: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_slider".}
proc wheel*(tool: ptr Tablet_v2_tablet_tool; degrees: cdouble; clicks: int32) {.importc: "wlr_send_tablet_v2_tablet_tool_wheel".}
proc proximityOut*(tool: ptr Tablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_proximity_out".}
proc button*(tool: ptr Tablet_v2_tablet_tool; button: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_send_tablet_v2_tablet_tool_button".}

proc notifyProximityIn*(tool: ptr Tablet_v2_tablet_tool; tablet: ptr Tablet_v2_tablet; surface: ptr Surface) {.importc: "wlr_tablet_v2_tablet_tool_notify_proximity_in".}
proc notifyDown*(tool: ptr Tablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_down".}
proc notifyUp*(tool: ptr Tablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_up".}
proc notifyMotion*(tool: ptr Tablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_motion".}
proc notifyPressure*(tool: ptr Tablet_v2_tablet_tool; pressure: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_pressure".}
proc notifyDistance*(tool: ptr Tablet_v2_tablet_tool; distance: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_distance".}
proc notifyTilt*(tool: ptr Tablet_v2_tablet_tool; x: cdouble; y: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_tilt".}
proc notifyRotation*(tool: ptr Tablet_v2_tablet_tool; degrees: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_rotation".}
proc notifySlider*(tool: ptr Tablet_v2_tablet_tool; position: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_slider".}
proc notifyWheel*(tool: ptr Tablet_v2_tablet_tool; degrees: cdouble; clicks: int32) {.importc: "wlr_tablet_v2_tablet_tool_notify_wheel".}
proc notifyProximityOut*(tool: ptr Tablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_proximity_out".}
proc notifyButton*(tool: ptr Tablet_v2_tablet_tool; button: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_tablet_v2_tablet_tool_notify_button".}

proc startGrab*(tool: ptr Tablet_v2_tablet_tool; grab: ptr TabletTool_v2_grab) {.importc: "wlr_tablet_tool_v2_start_grab".}
proc endGrab*(tool: ptr Tablet_v2_tablet_tool) {.importc: "wlr_tablet_tool_v2_end_grab".}
proc startImplicitGrab*(tool: ptr Tablet_v2_tablet_tool) {.importc: "wlr_tablet_tool_v2_start_implicit_grab".}
proc hasImplicitGrab*(tool: ptr Tablet_v2_tablet_tool): bool {.importc: "wlr_tablet_tool_v2_has_implicit_grab".}
proc enter*(pad: ptr Tablet_v2_tablet_pad; tablet: ptr Tablet_v2_tablet; surface: ptr Surface): uint32 {.importc: "wlr_send_tablet_v2_tablet_pad_enter".}
proc button*(pad: ptr Tablet_v2_tablet_pad; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_send_tablet_v2_tablet_pad_button".}
proc strip*(pad: ptr Tablet_v2_tablet_pad; strip: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_send_tablet_v2_tablet_pad_strip".}
proc ring*(pad: ptr Tablet_v2_tablet_pad; ring: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_send_tablet_v2_tablet_pad_ring".}
proc leave*(pad: ptr Tablet_v2_tablet_pad; surface: ptr Surface): uint32 {.importc: "wlr_send_tablet_v2_tablet_pad_leave".}
proc mode*(pad: ptr Tablet_v2_tablet_pad; group: csize_t; mode: uint32; time: uint32): uint32 {.importc: "wlr_send_tablet_v2_tablet_pad_mode".}
proc notifyEnter*(pad: ptr Tablet_v2_tablet_pad; tablet: ptr Tablet_v2_tablet; surface: ptr Surface): uint32 {.importc: "wlr_tablet_v2_tablet_pad_notify_enter".}
proc notifyButton*(pad: ptr Tablet_v2_tablet_pad; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_tablet_v2_tablet_pad_notify_button".}
proc notifyStrip*(pad: ptr Tablet_v2_tablet_pad; strip: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_tablet_v2_tablet_pad_notify_strip".}
proc notifyRing*(pad: ptr Tablet_v2_tablet_pad; ring: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_tablet_v2_tablet_pad_notify_ring".}
proc notifyLeave*(pad: ptr Tablet_v2_tablet_pad; surface: ptr Surface): uint32 {.importc: "wlr_tablet_v2_tablet_pad_notify_leave".}
proc notifyMode*(pad: ptr Tablet_v2_tablet_pad; group: csize_t; mode: uint32; time: uint32): uint32 {.importc: "wlr_tablet_v2_tablet_pad_notify_mode".}

proc endGrab*(pad: ptr Tablet_v2_tablet_pad) {.importc: "wlr_tablet_v2_end_grab".}
proc startGrab*(pad: ptr Tablet_v2_tablet_pad; grab: ptr TabletPad_v2_grab) {.importc: "wlr_tablet_v2_start_grab".}
proc accepts*(tablet: ptr Tablet_v2_tablet; surface: ptr Surface): bool {.importc: "wlr_surface_accepts_tablet_v2".}

## wlr_text_input_v3

type TextInput_v3_features* {.pure.} = enum
  SURROUNDING_TEXT = 1 shl 0,
  CONTENT_TYPE = 1 shl 1,
  CURSOR_RECTANGLE = 1 shl 2

type
  TextInput_v3* {.bycopy.} = object
    seat*: ptr Seat
    resource*: ptr WlResource
    focused_surface*: ptr Surface
    pending*: TextInput_v3_state
    current*: TextInput_v3_state
    current_serial*: uint32
    pending_enabled*: bool
    current_enabled*: bool
    active_features*: uint32
    link*: WlList
    surface_destroy*: WlListener
    seat_destroy*: WlListener
    events*: TextInput_v3_events

  TextInput_v3_surrounding* {.bycopy.} = object
    text*: cstring
    cursor*: uint32
    anchor*: uint32

  TextInput_v3_state_content_type* {.bycopy.} = object
    hint*: uint32
    purpose*: uint32

  TextInput_v3_state* {.bycopy.} = object
    surrounding*: TextInput_v3_surrounding
    text_change_cause*: uint32
    content_type*: TextInput_v3_state_content_type
    cursor_rectangle*: Box
    features*: uint32

  TextInput_v3_events* {.bycopy.} = object
    enable*: WlSignal
    commit*: WlSignal
    disable*: WlSignal
    destroy*: WlSignal

type
  TextInputManager_v3* {.bycopy.} = object
    global*: ptr WlGlobal
    text_inputs*: WlList
    display_destroy*: WlListener
    events*: TextInputManager_v3_events

  TextInputManager_v3_events* {.bycopy.} = object
    text_input*: WlSignal
    destroy*: WlSignal

proc createTextInputManager_v3*(wl_display: ptr WlDisplay): ptr TextInputManager_v3 {.importc: "wlr_text_input_manager_v3_create".}
proc sendEnter*(text_input: ptr TextInput_v3; wlr_surface: ptr Surface) {.importc: "wlr_text_input_v3_send_enter".}
proc sendLeave*(text_input: ptr TextInput_v3) {.importc: "wlr_text_input_v3_send_leave".}
proc sendPreeditString*(text_input: ptr TextInput_v3; text: cstring; cursor_begin: int32; cursor_end: int32) {.importc: "wlr_text_input_v3_send_preedit_string".}
proc sendCommitString*(text_input: ptr TextInput_v3; text: cstring) {.importc: "wlr_text_input_v3_send_commit_string".}
proc sendDeleteSurroundingText*(text_input: ptr TextInput_v3; before_length: uint32; after_length: uint32) {.importc: "wlr_text_input_v3_send_delete_surrounding_text".}
proc sendDone*(text_input: ptr TextInput_v3) {.importc: "wlr_text_input_v3_send_done".}

## wlr_viewporter

type
  Viewporter* {.bycopy.} = object
    global*: ptr WlGlobal
    events*: Viewporter_events
    display_destroy*: WlListener

  Viewporter_events* {.bycopy.} = object
    destroy*: WlSignal

proc createViewporter*(display: ptr WlDisplay): ptr Viewporter {.importc: "wlr_viewporter_create".}

## wlr_virtual_keyboard_v1

type
  VirtualKeyboardManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    virtual_keyboards*: WlList
    display_destroy*: WlListener
    events*: VirtualKeyboardManager_v1_events

  VirtualKeyboardManager_v1_events* {.bycopy.} = object
    new_virtual_keyboard*: WlSignal
    destroy*: WlSignal

type
  VirtualKeyboard_v1* {.bycopy.} = object
    input_device*: InputDevice
    resource*: ptr WlResource
    seat*: ptr Seat
    has_keymap*: bool
    link*: WlList
    events*: VirtualKeyboard_v1_events

  VirtualKeyboard_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createVirtualKeyboardManager_v1*(display: ptr WlDisplay): ptr VirtualKeyboardManager_v1 {.importc: "wlr_virtual_keyboard_manager_v1_create".}
proc getVirtualKeyboard*(wlr_dev: ptr InputDevice): ptr VirtualKeyboard_v1 {.importc: "wlr_input_device_get_virtual_keyboard".}

## wlr_virtual_pointer_v1

type
  VirtualPointerManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    virtual_pointers*: WlList
    display_destroy*: WlListener
    events*: VirtualPointerManager_v1_events

  VirtualPointerManager_v1_events* {.bycopy.} = object
    new_virtual_pointer*: WlSignal
    destroy*: WlSignal

type
  VirtualPointer_v1* {.bycopy.} = object
    input_device*: InputDevice
    resource*: ptr WlResource
    axis_event*: array[2, EventPointerAxis]
    axis*: WlPointerAxis
    axis_valid*: array[2, bool]
    link*: WlList
    events*: VirtualPointer_v1_events

  VirtualPointer_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type VirtualPointer_v1_new_pointer_event* {.bycopy.} = object
  new_pointer*: ptr VirtualPointer_v1
  suggested_seat*: ptr Seat
  suggested_output*: ptr Output

proc createVirtualPointerManager_v1*(display: ptr WlDisplay): ptr VirtualPointerManager_v1 {.importc: "wlr_virtual_pointer_manager_v1_create".}

## wlr_xcursor_manager

type XcursorManagerTheme* {.bycopy.} = object
  scale*: cfloat
  theme*: ptr XcursorTheme
  link*: WlList

type XcursorManager* {.bycopy.} = object
  name*: cstring
  size*: uint32
  scaled_themes*: WlList

proc createXcursorManager*(name: cstring; size: uint32): ptr XcursorManager {.importc: "wlr_xcursor_manager_create".}
proc destroy*(manager: ptr XcursorManager) {.importc: "wlr_xcursor_manager_destroy".}
proc load*(manager: ptr XcursorManager; scale: cfloat): bool {.importc: "wlr_xcursor_manager_load".}
proc getXcursor*(manager: ptr XcursorManager; name: cstring; scale: cfloat): ptr Xcursor {.importc: "wlr_xcursor_manager_get_xcursor".}
proc setCursorImage*(manager: ptr XcursorManager; name: cstring; cursor: ptr Cursor) {.importc: "wlr_xcursor_manager_set_cursor_image".}

## wlr_xdg_activation_v1

type
  XdgActivation_v1* {.bycopy.} = object
    token_timeout_msec*: uint32
    tokens*: WlList
    events*: XdgActivation_v1_events
    display*: ptr WlDisplay
    global*: ptr WlGlobal
    display_destroy*: WlListener

  XdgActivation_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    request_activate*: WlSignal

  XdgActivationToken_v1* {.bycopy.} = object
    activation*: ptr XdgActivation_v1
    surface*: ptr Surface
    seat*: ptr Seat
    serial*: uint32
    app_id*: cstring
    link*: WlList
    data*: pointer
    events*: XdgActivationToken_v1_events
    token*: cstring
    resource*: ptr WlResource
    timeout*: ptr WlEventSource
    seat_destroy*: WlListener
    surface_destroy*: WlListener

  XdgActivationToken_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type XdgActivation_v1_request_activate_event* {.bycopy.} = object
  activation*: ptr XdgActivation_v1
  token*: ptr XdgActivationToken_v1
  surface*: ptr Surface

proc createXdgActivation_v1*(display: ptr WlDisplay): ptr XdgActivation_v1 {.importc: "wlr_xdg_activation_v1_create".}
proc createXdgActivationToken_v1*(activation: ptr XdgActivation_v1): ptr XdgActivationToken_v1 {.importc: "wlr_xdg_activation_token_v1_create".}
proc destroy*(token: ptr XdgActivationToken_v1) {.importc: "wlr_xdg_activation_token_v1_destroy".}
proc findToken*(activation: ptr XdgActivation_v1; token_str: cstring): ptr XdgActivationToken_v1 {.importc: "wlr_xdg_activation_v1_find_token".}
proc getName*(token: ptr XdgActivationToken_v1): cstring {.importc: "wlr_xdg_activation_token_v1_get_name".}
proc addToken*(activation: ptr XdgActivation_v1; token_str: cstring): ptr XdgActivationToken_v1 {.importc: "wlr_xdg_activation_v1_add_token".}

## wlr_xdg_decoration_v1

type
  XdgDecorationManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    decorations*: WlList
    display_destroy*: WlListener
    events*: XdgDecorationManager_v1_events
    data*: pointer

  XdgDecorationManager_v1_events* {.bycopy.} = object
    new_toplevel_decoration*: WlSignal
    destroy*: WlSignal

type
  XdgToplevelDecoration_v1* {.bycopy.} = object
    resource*: ptr WlResource
    surface*: ptr XdgSurface
    manager*: ptr XdgDecorationManager_v1
    link*: WlList
    current*: XdgToplevelDecoration_v1_state
    pending*: XdgToplevelDecoration_v1_state
    scheduled_mode*: XdgToplevelDecoration_v1_mode
    requested_mode*: XdgToplevelDecoration_v1_mode
    added*: bool
    configure_list*: WlList
    events*: XdgToplevelDecoration_v1_events
    surface_destroy*: WlListener
    surface_configure*: WlListener
    surface_ack_configure*: WlListener
    surface_commit*: WlListener
    data*: pointer

  XdgToplevelDecoration_v1_mode* {.pure.} = enum
    NONE = 0,
    CLIENT_SIDE = 1,
    SERVER_SIDE = 2

  XdgToplevelDecoration_v1_configure* {.bycopy.} = object
    link*: WlList
    surface_configure*: ptr XdgSurfaceConfigure
    mode*: XdgToplevelDecoration_v1_mode

  XdgToplevelDecoration_v1_state* {.bycopy.} = object
    mode*: XdgToplevelDecoration_v1_mode

  XdgToplevelDecoration_v1_events* {.bycopy.} = object
    destroy*: WlSignal
    request_mode*: WlSignal

proc createXdgDecorationManager_v1*(display: ptr WlDisplay): ptr XdgDecorationManager_v1 {.importc: "wlr_xdg_decoration_manager_v1_create".}
proc setMode*(decoration: ptr XdgToplevelDecoration_v1; mode: XdgToplevelDecoration_v1_mode): uint32 {.importc: "wlr_xdg_toplevel_decoration_v1_set_mode".}

## wlr_xdg_foreign_registry

const WLR_XDG_FOREIGN_HANDLE_SIZE* = 37

type
  XdgForeignRegistry* {.bycopy.} = object
    exported_surfaces*: WlList
    display_destroy*: WlListener
    events*: XdgForeignRegistry_events

  XdgForeignRegistry_events* {.bycopy.} = object
    destroy*: WlSignal

type
  XdgForeignExported* {.bycopy.} = object
    link*: WlList
    registry*: ptr XdgForeignRegistry
    surface*: ptr Surface
    handle*: array[WLR_XDG_FOREIGN_HANDLE_SIZE, char]
    events*: XdgForeignExported_events

  XdgForeignExported_events* {.bycopy.} = object
    destroy*: WlSignal

proc createXdgForeignRegistry*(display: ptr WlDisplay): ptr XdgForeignRegistry {.importc: "wlr_xdg_foreign_registry_create".}
proc init*(surface: ptr XdgForeignExported; registry: ptr XdgForeignRegistry): bool {.importc: "wlr_xdg_foreign_exported_init".}
proc findByHandle*(registry: ptr XdgForeignRegistry; handle: cstring): ptr XdgForeignExported {.importc: "wlr_xdg_foreign_registry_find_by_handle".}
proc finish*(surface: ptr XdgForeignExported) {.importc: "wlr_xdg_foreign_exported_finish".}

## wlr_xdg_foreign_v1

type
  XdgForeign_v1* {.bycopy.} = object
    exporter*: XdgForeign_v1_porter
    importer*: XdgForeign_v1_porter
    foreign_registry_destroy*: WlListener
    display_destroy*: WlListener
    registry*: ptr XdgForeignRegistry
    events*: XdgForeign_v1_events
    data*: pointer

  XdgForeign_v1_porter* {.bycopy.} = object
    global*: ptr WlGlobal
    objects*: WlList

  XdgForeign_v1_events* {.bycopy.} = object
    destroy*: WlSignal

type XdgExported_v1* {.bycopy.} = object
  base*: XdgForeignExported
  resource*: ptr WlResource
  xdg_surface_destroy*: WlListener
  link*: WlList

type XdgImported_v1* {.bycopy.} = object
  exported*: ptr XdgForeignExported
  exported_destroyed*: WlListener
  resource*: ptr WlResource
  link*: WlList
  children*: WlList

type XdgImportedChild_v1* {.bycopy.} = object
  imported*: ptr XdgImported_v1
  surface*: ptr Surface
  link*: WlList
  xdg_surface_unmap*: WlListener
  xdg_toplevel_set_parent*: WlListener

proc createXdgForeign_v1*(display: ptr WlDisplay; registry: ptr XdgForeignRegistry): ptr XdgForeign_v1 {.importc: "wlr_xdg_foreign_v1_create".}

## wlr_xdg_foreign_v2

type
  XdgForeign_v2* {.bycopy.} = object
    exporter*: XdgForeign_v2_porter
    importer*: XdgForeign_v2_porter
    foreign_registry_destroy*: WlListener
    display_destroy*: WlListener
    registry*: ptr XdgForeignRegistry
    events*: XdgForeign_v2_events
    data*: pointer

  XdgForeign_v2_porter* {.bycopy.} = object
    global*: ptr WlGlobal
    objects*: WlList

  XdgForeign_v2_events* {.bycopy.} = object
    destroy*: WlSignal

type XdgExported_v2* {.bycopy.} = object
  base*: XdgForeignExported
  resource*: ptr WlResource
  xdg_surface_destroy*: WlListener
  link*: WlList

type XdgImported_v2* {.bycopy.} = object
  exported*: ptr XdgForeignExported
  exported_destroyed*: WlListener
  resource*: ptr WlResource
  link*: WlList
  children*: WlList

type XdgImportedChild_v2* {.bycopy.} = object
  imported*: ptr XdgImported_v2
  surface*: ptr Surface
  link*: WlList
  xdg_surface_unmap*: WlListener
  xdg_toplevel_set_parent*: WlListener

proc createXdgForeign_v2*(display: ptr WlDisplay; registry: ptr XdgForeignRegistry): ptr XdgForeign_v2 {.importc: "wlr_xdg_foreign_v2_create".}

## wlr_xdg_output

type
  XdgOutput_v1* {.bycopy.} = object
    manager*: ptr XdgOutputManager_v1
    resources*: WlList
    link*: WlList
    layout_output*: ptr OutputLayout_output
    x*, y*: int32
    width*, height*: int32
    destroy*: WlListener
    description*: WlListener

  XdgOutputManager_v1* {.bycopy.} = object
    global*: ptr WlGlobal
    layout*: ptr OutputLayout
    outputs*: WlList
    events*: XdgOutputManager_v1_events
    display_destroy*: WlListener
    layout_add*: WlListener
    layout_change*: WlListener
    layout_destroy*: WlListener

  XdgOutputManager_v1_events* {.bycopy.} = object
    destroy*: WlSignal

proc createXdgOutputManager_v1*(display: ptr WlDisplay; layout: ptr OutputLayout): ptr XdgOutputManager_v1 {.importc: "wlr_xdg_output_manager_v1_create".}

{.pop.}
