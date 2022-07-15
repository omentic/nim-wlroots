{.push dynlib: "libwlroots.so".}

import std/posix
import wayland, egl, pixman, wlroots/backend, wlroots/util

## TODO: shims

type
  PFNEGLGETPLATFORMDISPLAYEXTPROC = object
  PFNEGLCREATEIMAGEKHRPROC = object
  PFNEGLDESTROYIMAGEKHRPROC = object
  PFNEGLQUERYWAYLANDBUFFERWL = object
  PFNEGLQUERYDMABUFFORMATSEXTPROC = object
  PFNEGLQUERYDMABUFMODIFIERSEXTPROC = object
  PFNEGLDEBUGMESSAGECONTROLKHRPROC = object
  PFNEGLQUERYDISPLAYATTRIBEXTPROC = object
  PFNEGLQUERYDEVICESTRINGEXTPROC = object
  PFNEGLQUERYDEVICESEXTPROC = object
  EGLDeviceEXT = object
  gbm_device = object
  GLuint = object
  GLenum = object

## dmabuf

const WLR_DMABUF_MAX_PLANES* = 4

type DmabufAttributes* {.bycopy.} = object
  width*, height*: int32
  format*: uint32
  modifier*: uint64
  n_planes*: cint
  offset*: array[WLR_DMABUF_MAX_PLANES, uint32]
  stride*: array[WLR_DMABUF_MAX_PLANES, uint32]
  fd*: array[WLR_DMABUF_MAX_PLANES, cint]

proc finish*(attribs: ptr DmabufAttributes) {.importc: "wlr_dmabuf_attributes_finish".}
proc copy*(dst: ptr DmabufAttributes; src: ptr DmabufAttributes): bool {.importc: "wlr_dmabuf_attributes_copy".}

## wlr_buffer

type
  Buffer* {.bycopy.} = object
    impl*: ptr Buffer_impl
    width*, height*: cint
    dropped*: bool
    n_locks*: csize_t
    accessing_data_ptr*: bool
    events*: BufferEvents
    addons*: AddonSet

  ShmAttributes* {.bycopy.} = object
    fd*: cint
    format*: uint32
    width*, height*: cint
    stride*: cint
    offset*: Off

  Buffer_impl* {.bycopy.} = object
    destroy*: proc (buffer: ptr Buffer)
    get_dmabuf*: proc (buffer: ptr Buffer; attribs: ptr DmabufAttributes): bool
    get_shm*: proc (buffer: ptr Buffer; attribs: ptr ShmAttributes): bool
    begin_data_ptr_access*: proc (buffer: ptr Buffer; flags: uint32; data: ptr pointer; format: ptr uint32; stride: ptr csize_t): bool
    end_data_ptr_access*: proc (buffer: ptr Buffer)

  BufferEvents* {.bycopy.} = object
    destroy*: WlSignal
    release*: WlSignal

type BufferCap* {.pure.} = enum
  DATA_PTR = 1 shl 0,
  DMABUF = 1 shl 1,
  SHM = 1 shl 2

type BufferResourceInterface* {.bycopy.} = object
  name*: cstring
  is_instance*: proc (resource: ptr WlResource): bool
  from_resource*: proc (resource: ptr WlResource): ptr Buffer

proc init*(buffer: ptr Buffer; impl: ptr Buffer_impl; width: cint; height: cint) {.importc: "wlr_buffer_init".}
proc drop*(buffer: ptr Buffer) {.importc: "wlr_buffer_drop".}
proc lock*(buffer: ptr Buffer): ptr Buffer {.importc: "wlr_buffer_lock".}
proc unlock*(buffer: ptr Buffer) {.importc: "wlr_buffer_unlock".}
proc getDmabuf*(buffer: ptr Buffer; attribs: ptr DmabufAttributes): bool {.importc: "wlr_buffer_get_dmabuf".}
proc getShm*(buffer: ptr Buffer; attribs: ptr ShmAttributes): bool {.importc: "wlr_buffer_get_shm".}
proc register*(iface: ptr BufferResourceInterface) {.importc: "wlr_buffer_register_resource_interface".}
proc buffer*(resource: ptr WlResource): ptr Buffer {.importc: "wlr_buffer_from_resource".}

type BufferDataPtrAccessFlag* {.pure.} = enum
  READ = 1 shl 0,
  WRITE = 1 shl 1

proc beginDataPtrAccess*(buffer: ptr Buffer; flags: uint32; data: ptr pointer; format: ptr uint32; stride: ptr csize_t): bool {.importc: "wlr_buffer_begin_data_ptr_access".}
proc endDataPtrAccess*(buffer: ptr Buffer) {.importc: "wlr_buffer_end_data_ptr_access".}

## drm_format_set

type DrmFormat* {.bycopy.} = object
  format*: uint32
  len*, capacity*: csize_t
  modifiers*: UncheckedArray[uint64]

type DrmFormatSet* {.bycopy.} = object
  len*, capacity*: csize_t
  formats*: ptr ptr DrmFormat

proc finish*(set: ptr DrmFormatSet) {.importc: "wlr_drm_format_set_finish".}
proc get*(set: ptr DrmFormatSet; format: uint32): ptr DrmFormat {.importc: "wlr_drm_format_set_get".}
proc has*(set: ptr DrmFormatSet; format: uint32; modifier: uint64): bool {.importc: "wlr_drm_format_set_has".}
proc add*(set: ptr DrmFormatSet; format: uint32; modifier: uint64): bool {.importc: "wlr_drm_format_set_add".}
proc intersect*(dst: ptr DrmFormatSet; a: ptr DrmFormatSet; b: ptr DrmFormatSet): bool {.importc: "wlr_drm_format_set_intersect".}

## wlr_renderer

type RendererReadPixelsFlags* {.pure.} = enum
  Y_INVERT = 1

type
  Renderer* {.bycopy.} = object
    impl*: ptr Renderer_impl
    rendering*: bool
    rendering_with_buffer*: bool
    events*: Renderer_events

  Renderer_impl* {.bycopy.} = object
    bind_buffer*: proc (renderer: ptr Renderer; buffer: ptr Buffer): bool
    begin*: proc (renderer: ptr Renderer; width: uint32; height: uint32)
    `end`*: proc (renderer: ptr Renderer)
    # NOTE: const float color[static 4]
    clear*: proc (renderer: ptr Renderer; color: array[4, cfloat])
    scissor*: proc (renderer: ptr Renderer; box: ptr Box)
    # NOTE: const float matrix[static 9]
    render_subtexture_with_matrix*: proc (renderer: ptr Renderer; texture: ptr Texture; box: ptr Fbox; matrix: array[9, cfloat]; alpha: cfloat): bool
    # NOTE: const float color[static 4], const float matrix[static 9]
    render_quad_with_matrix*: proc (renderer: ptr Renderer; color: array[4, cfloat]; matrix: array[9, cfloat])
    get_shm_texture_formats*: proc (renderer: ptr Renderer; len: ptr csize_t): ptr uint32
    get_dmabuf_texture_formats*: proc (renderer: ptr Renderer): ptr DrmFormatSet
    get_render_formats*: proc (renderer: ptr Renderer): ptr DrmFormatSet
    preferred_read_format*: proc (renderer: ptr Renderer): uint32
    read_pixels*: proc (renderer: ptr Renderer; fmt: uint32; flags: ptr uint32; stride: uint32; width: uint32; height: uint32; src_x: uint32; src_y: uint32; dst_x: uint32; dst_y: uint32; data: pointer): bool
    destroy*: proc (renderer: ptr Renderer)
    get_drm_fd*: proc (renderer: ptr Renderer): cint
    get_render_buffer_caps*: proc (renderer: ptr Renderer): uint32
    texture_from_buffer*: proc (renderer: ptr Renderer; buffer: ptr Buffer): ptr Texture

  Renderer_events* {.bycopy.} = object
    destroy*: WlSignal

  Texture* {.bycopy.} = object
    impl*: ptr Texture_impl
    width*, height*: uint32

  Texture_impl* {.bycopy.} = object
    is_opaque*: proc (texture: ptr Texture): bool
    write_pixels*: proc (texture: ptr Texture; stride: uint32; width: uint32; height: uint32; src_x: uint32; src_y: uint32; dst_x: uint32; dst_y: uint32; data: pointer): bool
    destroy*: proc (texture: ptr Texture)

proc init*(renderer: ptr Renderer; impl: ptr Renderer_impl) {.importc: "wlr_renderer_init".}

proc autocreateRenderer*(backend: ptr Backend): ptr Renderer {.importc: "wlr_renderer_autocreate".}
proc begin*(r: ptr Renderer; width: uint32; height: uint32) {.importc: "wlr_renderer_begin".}
proc beginWithBuffer*(r: ptr Renderer; buffer: ptr Buffer): bool {.importc: "wlr_renderer_begin_with_buffer".}
proc `end`*(r: ptr Renderer) {.importc: "wlr_renderer_end".}
# NOTE: const float color[static 4]
proc clear*(r: ptr Renderer; color: array[4, cfloat]) {.importc: "wlr_renderer_clear".}

proc scissor*(r: ptr Renderer; box: ptr Box) {.importc: "wlr_renderer_scissor".}
# NOTE: const float projection[static 9]
proc texture*(r: ptr Renderer; texture: ptr Texture; projection: array[9, cfloat]; x: cint; y: cint; alpha: cfloat): bool {.importc: "wlr_render_texture".}
# NOTE: const float matrix[static 9]
proc textureWithMatrix*(r: ptr Renderer; texture: ptr Texture; matrix: array[9, cfloat]; alpha: cfloat): bool {.importc: "wlr_render_texture_with_matrix".}
# NOTE: const float matrix[static 9]
proc subtextureWithMatrix*(r: ptr Renderer; texture: ptr Texture; box: ptr Fbox; matrix: array[9, cfloat]; alpha: cfloat): bool {.importc: "wlr_render_subtexture_with_matrix".}
# NOTE: const float color[static 4], const float projection[static 9]
proc rect*(r: ptr Renderer; box: ptr Box; color: array[4, cfloat]; projection: array[9, cfloat]) {.importc: "wlr_render_rect".}

# NOTE: const float color[static 4], const float matrix[static 9]
proc quadWithMatrix*(r: ptr Renderer; color: array[4, cfloat]; matrix: array[9, cfloat]) {.importc: "wlr_render_quad_with_matrix".}
proc getShmTextureFormats*(r: ptr Renderer; len: ptr csize_t): ptr uint32 {.importc: "wlr_renderer_get_shm_texture_formats".}
proc getDmabufTextureFormats*(renderer: ptr Renderer): ptr DrmFormatSet {.importc: "wlr_renderer_get_dmabuf_texture_formats".}
proc readPixels*(r: ptr Renderer; fmt: uint32; flags: ptr uint32; stride: uint32; width: uint32; height: uint32; src_x: uint32; src_y: uint32; dst_x: uint32; dst_y: uint32; data: pointer): bool {.importc: "wlr_renderer_read_pixels".}
proc initWlDisplay*(r: ptr Renderer; wl_display: ptr WlDisplay): bool {.importc: "wlr_renderer_init_wl_display".}
proc initWlShm*(r: ptr Renderer; wl_display: ptr WlDisplay): bool {.importc: "wlr_renderer_init_wl_shm".}
proc getDrmFd*(r: ptr Renderer): cint {.importc: "wlr_renderer_get_drm_fd".}
proc destroy*(renderer: ptr Renderer) {.importc: "wlr_renderer_destroy".}

## wlr_texture

proc init*(texture: ptr Texture; impl: ptr Texture_impl; width: uint32; height: uint32) {.importc: "wlr_texture_init".}

proc textureFromPixels*(renderer: ptr Renderer; fmt: uint32; stride: uint32; width: uint32; height: uint32; data: pointer): ptr Texture {.importc: "wlr_texture_from_pixels".}
proc textureFromDmabuf*(renderer: ptr Renderer; attribs: ptr DmabufAttributes): ptr Texture {.importc: "wlr_texture_from_dmabuf".}

proc isOpaque*(texture: ptr Texture): bool {.importc: "wlr_texture_is_opaque".}
proc writePixels*(texture: ptr Texture; stride: uint32; width: uint32; height: uint32; src_x: uint32; src_y: uint32; dst_x: uint32; dst_y: uint32; data: pointer): bool {.importc: "wlr_texture_write_pixels".}
proc destroy*(texture: ptr Texture) {.importc: "wlr_texture_destroy".}

proc textureFromBuffer*(renderer: ptr Renderer; buffer: ptr Buffer): ptr Texture {.importc: "wlr_texture_from_buffer".}

## wlr_buffer_ii

type ClientBuffer* {.bycopy.} = object
  base*: Buffer
  texture*: ptr Texture
  source*: ptr Buffer
  source_destroy*: WlListener
  shm_source_format*: uint32

proc createClientBuffer*(buffer: ptr Buffer; renderer: ptr Renderer): ptr ClientBuffer {.importc: "wlr_client_buffer_create".}
proc getClient*(buffer: ptr Buffer): ptr ClientBuffer {.importc: "wlr_client_buffer_get".}
proc isBuffer*(resource: ptr WlResource): bool {.importc: "wlr_resource_is_buffer".}
proc applyDamage*(client_buffer: ptr ClientBuffer; next: ptr Buffer; damage: ptr PixmanRegion32): bool {.importc: "wlr_client_buffer_apply_damage".}

## allocator

type
  Allocator* {.bycopy.} = object
    impl*: ptr AllocatorInterface
    buffer_caps*: uint32
    events*: AllocatorEvents

  AllocatorInterface* {.bycopy.} = object
    create_buffer*: proc (alloc: ptr Allocator; width: cint; height: cint; format: ptr DrmFormat): ptr Buffer
    destroy*: proc (alloc: ptr Allocator)

  AllocatorEvents* {.bycopy.} = object
    destroy*: WlSignal

proc init*(alloc: ptr Allocator; impl: ptr AllocatorInterface; buffer_caps: uint32) {.importc: "wlr_allocator_init".}

proc autocreateAllocator*(backend: ptr Backend; renderer: ptr Renderer): ptr Allocator {.importc: "wlr_allocator_autocreate".}
proc destroy*(alloc: ptr Allocator) {.importc: "wlr_allocator_destroy".}
proc createBuffer*(alloc: ptr Allocator; width: cint; height: cint; format: ptr DrmFormat): ptr Buffer {.importc: "wlr_allocator_create_buffer".}

## egl

type Egl_exts* {.bycopy.} = object
  KHR_image_base*: bool
  EXT_image_dma_buf_import*: bool
  EXT_image_dma_buf_import_modifiers*: bool
  IMG_context_priority*: bool
  EXT_device_drm*: bool
  EXT_device_drm_render_node*: bool
  EXT_device_query*: bool
  KHR_platform_gbm*: bool
  EXT_platform_device*: bool

type Egl_procs* {.bycopy.} = object
  eglGetPlatformDisplayEXT*: PFNEGLGETPLATFORMDISPLAYEXTPROC
  eglCreateImageKHR*: PFNEGLCREATEIMAGEKHRPROC
  eglDestroyImageKHR*: PFNEGLDESTROYIMAGEKHRPROC
  eglQueryWaylandBufferWL*: PFNEGLQUERYWAYLANDBUFFERWL
  eglQueryDmaBufFormatsEXT*: PFNEGLQUERYDMABUFFORMATSEXTPROC
  eglQueryDmaBufModifiersEXT*: PFNEGLQUERYDMABUFMODIFIERSEXTPROC
  eglDebugMessageControlKHR*: PFNEGLDEBUGMESSAGECONTROLKHRPROC
  eglQueryDisplayAttribEXT*: PFNEGLQUERYDISPLAYATTRIBEXTPROC
  eglQueryDeviceStringEXT*: PFNEGLQUERYDEVICESTRINGEXTPROC
  eglQueryDevicesEXT*: PFNEGLQUERYDEVICESEXTPROC

type Egl* {.bycopy.} = object
  display*: EGLDisplay
  context*: EGLContext
  device*: EGLDeviceEXT
  gbm_device*: ptr gbm_device
  exts*: Egl_exts
  procs*: Egl_procs
  has_modifiers*: bool
  dmabuf_texture_formats*: DrmFormatSet
  dmabuf_render_formats*: DrmFormatSet

proc createEglWithContext*(display: EGLDisplay; context: EGLContext): ptr Egl {.importc: "wlr_egl_create_with_context".}
proc makeCurrent*(egl: ptr Egl): bool {.importc: "wlr_egl_make_current".}
proc unsetCurrent*(egl: ptr Egl): bool {.importc: "wlr_egl_unset_current".}
proc isCurrent*(egl: ptr Egl): bool {.importc: "wlr_egl_is_current".}

# TODO: double check these are all the procs

## gles2

proc createGles2RendererWithDrmFd*(drm_fd: cint): ptr Renderer {.importc: "wlr_gles2_renderer_create_with_drm_fd".}
proc createGles2Renderer*(egl: ptr Egl): ptr Renderer {.importc: "wlr_gles2_renderer_create".}

proc getEgl*(renderer: ptr Renderer): ptr Egl {.importc: "wlr_gles2_renderer_get_egl".}
proc checkExt*(renderer: ptr Renderer; ext: cstring): bool {.importc: "wlr_gles2_renderer_check_ext".}

proc getCurrentFbo*(wlr_renderer: ptr Renderer): GLuint {.importc: "wlr_gles2_renderer_get_current_fbo".}

type Gles2TextureAttribs* {.bycopy.} = object
  target*: GLenum
  tex*: GLuint
  has_alpha*: bool

proc isGles2*(wlr_renderer: ptr Renderer): bool {.importc: "wlr_renderer_is_gles2".}
proc isGles2*(texture: ptr Texture): bool {.importc: "wlr_texture_is_gles2".}
proc getAttribs*(texture: ptr Texture; attribs: ptr Gles2TextureAttribs) {.importc: "wlr_gles2_texture_get_attribs".}

## interface

## pixman

proc createPixmanRenderer*(): ptr Renderer {.importc: "wlr_pixman_renderer_create".}

proc getCurrentImage*(wlr_renderer: ptr Renderer): ptr PixmanImage {.importc: "wlr_pixman_renderer_get_current_image".}

proc isPixman*(wlr_renderer: ptr Renderer): bool {.importc: "wlr_renderer_is_pixman".}
proc isPixman*(texture: ptr Texture): bool {.importc: "wlr_texture_is_pixman".}
proc getImage*(wlr_texture: ptr Texture): ptr PixmanImage {.importc: "wlr_pixman_texture_get_image".}

## vulkan

proc createVkRendererWithDrmFd*(drm_fd: cint): ptr Renderer {.importc: "wlr_vk_renderer_create_with_drm_fd".}
proc isVK*(texture: ptr Texture): bool {.importc: "wlr_texture_is_vk".}

{.pop.}
