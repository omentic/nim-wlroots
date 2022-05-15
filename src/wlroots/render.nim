{.push dynlib: "libwlroots.so".}

import std/posix
import wayland, pixman, wlroots/backend, wlroots/util

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
  EGLDisplay = object
  EGLContext = object
  EGLDeviceEXT = object
  gbm_device = object
  GLuint = object
  GLenum = object

## dmabuf

const WLR_DMABUF_MAX_PLANES* = 4

type WlrDmabufAttributes* {.bycopy.} = object
  width*, height*: int32
  format*: uint32
  modifier*: uint64
  n_planes*: cint
  offset*: array[WLR_DMABUF_MAX_PLANES, uint32]
  stride*: array[WLR_DMABUF_MAX_PLANES, uint32]
  fd*: array[WLR_DMABUF_MAX_PLANES, cint]

proc finish*(attribs: ptr WlrDmabufAttributes) {.importc: "wlr_dmabuf_attributes_finish".}
proc copy*(dst: ptr WlrDmabufAttributes; src: ptr WlrDmabufAttributes): bool {.importc: "wlr_dmabuf_attributes_copy".}

## wlr_buffer

type
  WlrBuffer* {.bycopy.} = object
    impl*: ptr WlrBuffer_impl
    width*, height*: cint
    dropped*: bool
    n_locks*: csize_t
    accessing_data_ptr*: bool
    events*: WlrBuffer_events
    addons*: WlrAddonSet

  WlrShmAttributes* {.bycopy.} = object
    fd*: cint
    format*: uint32
    width*, height*: cint
    stride*: cint
    offset*: Off

  WlrBuffer_impl* {.bycopy.} = object
    destroy*: proc (buffer: ptr WlrBuffer)
    get_dmabuf*: proc (buffer: ptr WlrBuffer; attribs: ptr WlrDmabufAttributes): bool
    get_shm*: proc (buffer: ptr WlrBuffer; attribs: ptr WlrShmAttributes): bool
    begin_data_ptr_access*: proc (buffer: ptr WlrBuffer; flags: uint32; data: ptr pointer; format: ptr uint32; stride: ptr csize_t): bool
    end_data_ptr_access*: proc (buffer: ptr WlrBuffer)

  WlrBuffer_events* {.bycopy.} = object
    destroy*: WlSignal
    release*: WlSignal

type WlrBufferCap* = enum
  WLR_BUFFER_CAP_DATA_PTR = 1 shl 0,
  WLR_BUFFER_CAP_DMABUF = 1 shl 1,
  WLR_BUFFER_CAP_SHM = 1 shl 2

type WlrBufferResourceInterface* {.bycopy.} = object
  name*: cstring
  is_instance*: proc (resource: ptr WlResource): bool
  from_resource*: proc (resource: ptr WlResource): ptr WlrBuffer

proc init*(buffer: ptr WlrBuffer; impl: ptr WlrBuffer_impl; width: cint; height: cint) {.importc: "wlr_buffer_init".}
proc drop*(buffer: ptr WlrBuffer) {.importc: "wlr_buffer_drop".}
proc lock*(buffer: ptr WlrBuffer): ptr WlrBuffer {.importc: "wlr_buffer_lock".}
proc unlock*(buffer: ptr WlrBuffer) {.importc: "wlr_buffer_unlock".}
proc getDmabuf*(buffer: ptr WlrBuffer; attribs: ptr WlrDmabufAttributes): bool {.importc: "wlr_buffer_get_dmabuf".}
proc getShm*(buffer: ptr WlrBuffer; attribs: ptr WlrShmAttributes): bool {.importc: "wlr_buffer_get_shm".}
proc register*(iface: ptr WlrBufferResourceInterface) {.importc: "wlr_buffer_register_resource_interface".}
proc wlrBuffer*(resource: ptr WlResource): ptr WlrBuffer {.importc: "wlr_buffer_from_resource".}

type WlrBufferDataPtrAccessFlag* = enum
  WLR_BUFFER_DATA_PTR_ACCESS_READ = 1 shl 0,
  WLR_BUFFER_DATA_PTR_ACCESS_WRITE = 1 shl 1

proc beginDataPtrAccess*(buffer: ptr WlrBuffer; flags: uint32; data: ptr pointer; format: ptr uint32; stride: ptr csize_t): bool {.importc: "wlr_buffer_begin_data_ptr_access".}
proc endDataPtrAccess*(buffer: ptr WlrBuffer) {.importc: "wlr_buffer_end_data_ptr_access".}

## drm_format_set

type WlrDrmFormat* {.bycopy.} = object
  format*: uint32
  len*, capacity*: csize_t
  modifiers*: UncheckedArray[uint64]

type WlrDrmFormatSet* {.bycopy.} = object
  len*, capacity*: csize_t
  formats*: ptr ptr WlrDrmFormat

proc finish*(set: ptr WlrDrmFormatSet) {.importc: "wlr_drm_format_set_finish".}
proc get*(set: ptr WlrDrmFormatSet; format: uint32): ptr WlrDrmFormat {.importc: "wlr_drm_format_set_get".}
proc has*(set: ptr WlrDrmFormatSet; format: uint32; modifier: uint64): bool {.importc: "wlr_drm_format_set_has".}
proc add*(set: ptr WlrDrmFormatSet; format: uint32; modifier: uint64): bool {.importc: "wlr_drm_format_set_add".}
proc intersect*(dst: ptr WlrDrmFormatSet; a: ptr WlrDrmFormatSet; b: ptr WlrDrmFormatSet): bool {.importc: "wlr_drm_format_set_intersect".}

## wlr_renderer

type WlrRendererReadPixelsFlags* = enum
  WLR_RENDERER_READ_PIXELS_Y_INVERT = 1

type
  WlrRenderer* {.bycopy.} = object
    impl*: ptr WlrRenderer_impl
    rendering*: bool
    rendering_with_buffer*: bool
    events*: WlrRenderer_events

  WlrRenderer_impl* {.bycopy.} = object
    bind_buffer*: proc (renderer: ptr WlrRenderer; buffer: ptr WlrBuffer): bool
    begin*: proc (renderer: ptr WlrRenderer; width: uint32; height: uint32)
    `end`*: proc (renderer: ptr WlrRenderer)
    # NOTE: const float color[static 4]
    clear*: proc (renderer: ptr WlrRenderer; color: array[4, cfloat])
    scissor*: proc (renderer: ptr WlrRenderer; box: ptr WlrBox)
    # NOTE: const float matrix[static 9]
    render_subtexture_with_matrix*: proc (renderer: ptr WlrRenderer; texture: ptr WlrTexture; box: ptr WlrFbox; matrix: array[9, cfloat]; alpha: cfloat): bool
    # NOTE: const float color[static 4], const float matrix[static 9]
    render_quad_with_matrix*: proc (renderer: ptr WlrRenderer; color: array[4, cfloat]; matrix: array[9, cfloat])
    get_shm_texture_formats*: proc (renderer: ptr WlrRenderer; len: ptr csize_t): ptr uint32
    get_dmabuf_texture_formats*: proc (renderer: ptr WlrRenderer): ptr WlrDrmFormatSet
    get_render_formats*: proc (renderer: ptr WlrRenderer): ptr WlrDrmFormatSet
    preferred_read_format*: proc (renderer: ptr WlrRenderer): uint32
    read_pixels*: proc (renderer: ptr WlrRenderer; fmt: uint32; flags: ptr uint32; stride: uint32; width: uint32; height: uint32; src_x: uint32; src_y: uint32; dst_x: uint32; dst_y: uint32; data: pointer): bool
    destroy*: proc (renderer: ptr WlrRenderer)
    get_drm_fd*: proc (renderer: ptr WlrRenderer): cint
    get_render_buffer_caps*: proc (renderer: ptr WlrRenderer): uint32
    texture_from_buffer*: proc (renderer: ptr WlrRenderer; buffer: ptr WlrBuffer): ptr WlrTexture

  WlrRenderer_events* {.bycopy.} = object
    destroy*: WlSignal

  WlrTexture* {.bycopy.} = object
    impl*: ptr WlrTexture_impl
    width*, height*: uint32

  WlrTexture_impl* {.bycopy.} = object
    is_opaque*: proc (texture: ptr WlrTexture): bool
    write_pixels*: proc (texture: ptr WlrTexture; stride: uint32; width: uint32; height: uint32; src_x: uint32; src_y: uint32; dst_x: uint32; dst_y: uint32; data: pointer): bool
    destroy*: proc (texture: ptr WlrTexture)

proc init*(renderer: ptr WlrRenderer; impl: ptr WlrRenderer_impl) {.importc: "wlr_renderer_init".}

proc autocreateWlrRenderer*(backend: ptr WlrBackend): ptr WlrRenderer {.importc: "wlr_renderer_autocreate".}
proc begin*(r: ptr WlrRenderer; width: uint32; height: uint32) {.importc: "wlr_renderer_begin".}
proc beginWithBuffer*(r: ptr WlrRenderer; buffer: ptr WlrBuffer): bool {.importc: "wlr_renderer_begin_with_buffer".}
proc `end`*(r: ptr WlrRenderer) {.importc: "wlr_renderer_end".}
# NOTE: const float color[static 4]
proc clear*(r: ptr WlrRenderer; color: array[4, cfloat]) {.importc: "wlr_renderer_clear".}

proc scissor*(r: ptr WlrRenderer; box: ptr WlrBox) {.importc: "wlr_renderer_scissor".}
# NOTE: const float projection[static 9]
proc texture*(r: ptr WlrRenderer; texture: ptr WlrTexture; projection: array[9, cfloat]; x: cint; y: cint; alpha: cfloat): bool {.importc: "wlr_render_texture".}
# NOTE: const float matrix[static 9]
proc textureWithMatrix*(r: ptr WlrRenderer; texture: ptr WlrTexture; matrix: array[9, cfloat]; alpha: cfloat): bool {.importc: "wlr_render_texture_with_matrix".}
# NOTE: const float matrix[static 9]
proc subtextureWithMatrix*(r: ptr WlrRenderer; texture: ptr WlrTexture; box: ptr WlrFbox; matrix: array[9, cfloat]; alpha: cfloat): bool {.importc: "wlr_render_subtexture_with_matrix".}
# NOTE: const float color[static 4], const float projection[static 9]
proc rect*(r: ptr WlrRenderer; box: ptr WlrBox; color: array[4, cfloat]; projection: array[9, cfloat]) {.importc: "wlr_render_rect".}

# NOTE: const float color[static 4], const float matrix[static 9]
proc quadWithMatrix*(r: ptr WlrRenderer; color: array[4, cfloat]; matrix: array[9, cfloat]) {.importc: "wlr_render_quad_with_matrix".}
proc getShmTextureFormats*(r: ptr WlrRenderer; len: ptr csize_t): ptr uint32 {.importc: "wlr_renderer_get_shm_texture_formats".}
proc getDmabufTextureFormats*(renderer: ptr WlrRenderer): ptr WlrDrmFormatSet {.importc: "wlr_renderer_get_dmabuf_texture_formats".}
proc readPixels*(r: ptr WlrRenderer; fmt: uint32; flags: ptr uint32; stride: uint32; width: uint32; height: uint32; src_x: uint32; src_y: uint32; dst_x: uint32; dst_y: uint32; data: pointer): bool {.importc: "wlr_renderer_read_pixels".}
proc initWlDisplay*(r: ptr WlrRenderer; wl_display: ptr WlDisplay): bool {.importc: "wlr_renderer_init_wl_display".}
proc initWlShm*(r: ptr WlrRenderer; wl_display: ptr WlDisplay): bool {.importc: "wlr_renderer_init_wl_shm".}
proc getDrmFd*(r: ptr WlrRenderer): cint {.importc: "wlr_renderer_get_drm_fd".}
proc destroy*(renderer: ptr WlrRenderer) {.importc: "wlr_renderer_destroy".}

## wlr_texture

proc init*(texture: ptr WlrTexture; impl: ptr WlrTexture_impl; width: uint32; height: uint32) {.importc: "wlr_texture_init".}

proc wlrTextureFromPixels*(renderer: ptr WlrRenderer; fmt: uint32; stride: uint32; width: uint32; height: uint32; data: pointer): ptr WlrTexture {.importc: "wlr_texture_from_pixels".}
proc wlrTextureFromDmabuf*(renderer: ptr WlrRenderer; attribs: ptr WlrDmabufAttributes): ptr WlrTexture {.importc: "wlr_texture_from_dmabuf".}

proc isOpaque*(texture: ptr WlrTexture): bool {.importc: "wlr_texture_is_opaque".}
proc writePixels*(texture: ptr WlrTexture; stride: uint32; width: uint32; height: uint32; src_x: uint32; src_y: uint32; dst_x: uint32; dst_y: uint32; data: pointer): bool {.importc: "wlr_texture_write_pixels".}
proc destroy*(texture: ptr WlrTexture) {.importc: "wlr_texture_destroy".}

proc wlrTextureFromBuffer*(renderer: ptr WlrRenderer; buffer: ptr WlrBuffer): ptr WlrTexture {.importc: "wlr_texture_from_buffer".}

## wlr_buffer_ii

type WlrClientBuffer* {.bycopy.} = object
  base*: WlrBuffer
  texture*: ptr WlrTexture
  source*: ptr WlrBuffer
  source_destroy*: WlListener
  shm_source_format*: uint32

proc createClientWlrBuffer*(buffer: ptr WlrBuffer; renderer: ptr WlrRenderer): ptr WlrClientBuffer {.importc: "wlr_client_buffer_create".}
proc getClient*(buffer: ptr WlrBuffer): ptr WlrClientBuffer {.importc: "wlr_client_buffer_get".}
proc isBuffer*(resource: ptr WlResource): bool {.importc: "wlr_resource_is_buffer".}
proc applyDamage*(client_buffer: ptr WlrClientBuffer; next: ptr WlrBuffer; damage: ptr PixmanRegion32): bool {.importc: "wlr_client_buffer_apply_damage".}

## allocator

type
  WlrAllocator* {.bycopy.} = object
    impl*: ptr WlrAllocatorInterface
    buffer_caps*: uint32
    events*: WlrAllocator_events

  WlrAllocatorInterface* {.bycopy.} = object
    create_buffer*: proc (alloc: ptr WlrAllocator; width: cint; height: cint; format: ptr WlrDrmFormat): ptr WlrBuffer
    destroy*: proc (alloc: ptr WlrAllocator)

  WlrAllocator_events* {.bycopy.} = object
    destroy*: WlSignal

proc init*(alloc: ptr WlrAllocator; impl: ptr WlrAllocatorInterface; buffer_caps: uint32) {.importc: "wlr_allocator_init".}

proc autocreateWlrAllocator*(backend: ptr WlrBackend; renderer: ptr WlrRenderer): ptr WlrAllocator {.importc: "wlr_allocator_autocreate".}
proc destroy*(alloc: ptr WlrAllocator) {.importc: "wlr_allocator_destroy".}
proc createBuffer*(alloc: ptr WlrAllocator; width: cint; height: cint; format: ptr WlrDrmFormat): ptr WlrBuffer {.importc: "wlr_allocator_create_buffer".}

## egl

type WlrEgl_exts* {.bycopy.} = object
  KHR_image_base*: bool
  EXT_image_dma_buf_import*: bool
  EXT_image_dma_buf_import_modifiers*: bool
  IMG_context_priority*: bool
  EXT_device_drm*: bool
  EXT_device_drm_render_node*: bool
  EXT_device_query*: bool
  KHR_platform_gbm*: bool
  EXT_platform_device*: bool

type WlrEgl_procs* {.bycopy.} = object
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

type WlrEgl* {.bycopy.} = object
  display*: EGLDisplay
  context*: EGLContext
  device*: EGLDeviceEXT
  gbm_device*: ptr gbm_device
  exts*: WlrEgl_exts
  procs*: WlrEgl_procs
  has_modifiers*: bool
  dmabuf_texture_formats*: WlrDrmFormatSet
  dmabuf_render_formats*: WlrDrmFormatSet

proc createWlrEglWithContext*(display: EGLDisplay; context: EGLContext): ptr WlrEgl {.importc: "wlr_egl_create_with_context".}
proc makeCurrent*(egl: ptr WlrEgl): bool {.importc: "wlr_egl_make_current".}
proc unsetCurrent*(egl: ptr WlrEgl): bool {.importc: "wlr_egl_unset_current".}
proc isCurrent*(egl: ptr WlrEgl): bool {.importc: "wlr_egl_is_current".}

# TODO: double check these are all the procs

## gles2

proc createWlrGles2RendererWithDrmFd*(drm_fd: cint): ptr WlrRenderer {.importc: "wlr_gles2_renderer_create_with_drm_fd".}
proc createWlrGles2Renderer*(egl: ptr WlrEgl): ptr WlrRenderer {.importc: "wlr_gles2_renderer_create".}

proc getEgl*(renderer: ptr WlrRenderer): ptr WlrEgl {.importc: "wlr_gles2_renderer_get_egl".}
proc checkExt*(renderer: ptr WlrRenderer; ext: cstring): bool {.importc: "wlr_gles2_renderer_check_ext".}

proc getCurrentFbo*(wlr_renderer: ptr WlrRenderer): GLuint {.importc: "wlr_gles2_renderer_get_current_fbo".}

type WlrGles2TextureAttribs* {.bycopy.} = object
  target*: GLenum
  tex*: GLuint
  has_alpha*: bool

proc isGles2*(wlr_renderer: ptr WlrRenderer): bool {.importc: "wlr_renderer_is_gles2".}
proc isGles2*(texture: ptr WlrTexture): bool {.importc: "wlr_texture_is_gles2".}
proc getAttribs*(texture: ptr WlrTexture; attribs: ptr WlrGles2TextureAttribs) {.importc: "wlr_gles2_texture_get_attribs".}

## interface

## pixman

proc createWlrPixmanRenderer*(): ptr WlrRenderer {.importc: "wlr_pixman_renderer_create".}

proc getCurrentImage*(wlr_renderer: ptr WlrRenderer): ptr PixmanImage {.importc: "wlr_pixman_renderer_get_current_image".}

proc isPixman*(wlr_renderer: ptr WlrRenderer): bool {.importc: "wlr_renderer_is_pixman".}
proc isPixman*(texture: ptr WlrTexture): bool {.importc: "wlr_texture_is_pixman".}
proc getImage*(wlr_texture: ptr WlrTexture): ptr PixmanImage {.importc: "wlr_pixman_texture_get_image".}

## vulkan

proc createWlrVkRendererWithDrmFd*(drm_fd: cint): ptr WlrRenderer {.importc: "wlr_vk_renderer_create_with_drm_fd".}
proc isVK*(texture: ptr WlrTexture): bool {.importc: "wlr_texture_is_vk".}

{.pop.}
