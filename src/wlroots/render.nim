{.push dynlib: "libwlroots.so".}

import wayland, pixman

## dmabuf

const WLR_DMABUF_MAX_PLANES* = 4

type WlrDmabufAttributesFlags* = enum
  WLR_DMABUF_ATTRIBUTES_FLAGS_Y_INVERT = 1 shl 0,
  WLR_DMABUF_ATTRIBUTES_FLAGS_INTERLACED = 1 shl 1,
  WLR_DMABUF_ATTRIBUTES_FLAGS_BOTTOM_FIRST = 1 shl 2

type WlrDmabufAttributes* = object
  width*, height*: int32
  format*: uint32
  flags*: uint32
  modifier*: uint64
  n_planes*: cint
  offset*: array[WLR_DMABUF_MAX_PLANES, uint32]
  stride*: array[WLR_DMABUF_MAX_PLANES, uint32]
  fd*: array[WLR_DMABUF_MAX_PLANES, cint]

proc finish*(attribs: ptr WlrDmabufAttributes) {.importc: "wlr_dmabuf_attributes_finish".}
proc copy*(dst: ptr WlrDmabufAttributes; src: ptr WlrDmabufAttributes): bool {.importc: "wlr_dmabuf_attributes_copy".}

## drm_format_set

type WlrDrmFormat* = object
  format*: uint32
  len*, cap*: csize_t
  modifiers*: UncheckedArray[uint64]

type WlrDrmFormatSet* = object
  len*, cap*: csize_t
  formats*: ptr ptr WlrDrmFormat

proc finish*(set: ptr WlrDrmFormatSet) {.importc: "wlr_drm_format_set_finish".}
proc get*(set: ptr WlrDrmFormatSet; format: uint32): ptr WlrDrmFormat {.importc: "wlr_drm_format_set_get".}
proc has*(set: ptr WlrDrmFormatSet; format: uint32; modifier: uint64): bool {.importc: "wlr_drm_format_set_has".}
proc add*(set: ptr WlrDrmFormatSet; format: uint32; modifier: uint64): bool {.importc: "wlr_drm_format_set_add".}

## egl

type WlrEglContext* = object
  display*: EGLWlDisplay
  context*: EGLContext
  draw_surface*: EGLSurface
  read_surface*: EGLSurface

type WlrEglExts* = object
  bind_wayland_display_wl*: bool #  WlDisplay extensions
  image_base_khr*: bool
  image_dmabuf_import_ext*: bool
  image_dmabuf_import_modifiers_ext*: bool #  Device extensions
  device_drm_ext*: bool

type WlrEglProcs* = object
  eglGetPlatformWlDisplayEXT*: PFNEGLGETPLATFORMDISPLAYEXTPROC
  eglCreateImageKHR*: PFNEGLCREATEIMAGEKHRPROC
  eglDestroyImageKHR*: PFNEGLDESTROYIMAGEKHRPROC
  eglQueryWaylandBufferWL*: PFNEGLQUERYWAYLANDBUFFERWL
  eglBindWaylandWlDisplayWL*: PFNEGLBINDWAYLANDDISPLAYWL
  eglUnbindWaylandWlDisplayWL*: PFNEGLUNBINDWAYLANDDISPLAYWL
  eglQueryDmaBufFormatsEXT*: PFNEGLQUERYDMABUFFORMATSEXTPROC
  eglQueryDmaBufModifiersEXT*: PFNEGLQUERYDMABUFMODIFIERSEXTPROC
  eglDebugMessageControlKHR*: PFNEGLDEBUGMESSAGECONTROLKHRPROC
  eglQueryWlDisplayAttribEXT*: PFNEGLQUERYDISPLAYATTRIBEXTPROC
  eglQueryDeviceStringEXT*: PFNEGLQUERYDEVICESTRINGEXTPROC

type WlrEgl* = object
  display*: EGLWlDisplay
  context*: EGLContext
  device*: EGLDeviceEXT      #  may be EGL_NO_DEVICE_EXT
  gbm_device*: ptr gbm_device
  exts*: WlrEglExts
  procs*: WlrEglProcs
  wl_display*: ptr WlDisplay
  dmabuf_texture_formats*: WlrDrmFormatSet
  dmabuf_render_formats*: WlrDrmFormatSet

proc create_wlr_egl*(platform: EGLenum; remote_display: pointer): ptr WlrEgl {.importc: "wlr_egl_create".}
proc destroy*(egl: ptr WlrEgl) {.importc: "wlr_egl_destroy".}
proc bind_display*(egl: ptr WlrEgl; local_display: ptr WlDisplay): bool {.importc: "wlr_egl_bind_display".}

proc create_image_from_wl_drm*(egl: ptr WlrEgl; data: ptr WlResource; fmt: ptr EGLint; width, height: ptr cint; inverted_y: ptr bool): EGLImageKHR {.importc: "wlr_egl_create_image_from_wl_drm".}
proc create_image_from_dmabuf*(egl: ptr WlrEgl; attributes: ptr WlrDmabufAttributes; external_only: ptr bool): EGLImageKHR {.importc: "wlr_egl_create_image_from_dmabuf".}
proc get_dmabuf_texture_formats*(egl: ptr WlrEgl): ptr WlrDrmFormat_set {.importc: "wlr_egl_get_dmabuf_texture_formats".}
proc get_dmabuf_render_formats*(egl: ptr WlrEgl): ptr WlrDrmFormat_set {.importc: "wlr_egl_get_dmabuf_render_formats".}

proc export_image_to_dmabuf*(egl: ptr WlrEgl; image: EGLImageKHR; width, height: int32; flags: uint32; attribs: ptr WlrDmabufAttributes): bool {.importc: "wlr_egl_export_image_to_dmabuf".}
proc destroy_image*(egl: ptr WlrEgl; image: EGLImageKHR): bool {.importc: "wlr_egl_destroy_image".}

proc make_current*(egl: ptr WlrEgl): bool {.importc: "wlr_egl_make_current".}
proc unset_current*(egl: ptr WlrEgl): bool {.importc: "wlr_egl_unset_current".}
proc is_current*(egl: ptr WlrEgl): bool {.importc: "wlr_egl_is_current".}
proc save_context*(context: ptr WlrEglContext) {.importc: "wlr_egl_save_context".}
proc restore_context*(context: ptr WlrEglContext): bool {.importc: "wlr_egl_restore_context".}

proc dup_drm_fd*(egl: ptr WlrEgl): cint {.importc: "wlr_egl_dup_drm_fd".}

## gles2

proc create_with_drm_fd_wlr_gles2_renderer*(drm_fd: cint): ptr WlrRenderer {.importc: "wlr_gles2_renderer_create_with_drm_fd".}
proc create_wlr_gles2_renderer*(egl: ptr WlrEgl): ptr WlrRenderer {.importc: "wlr_gles2_renderer_create".}

proc get_egl*(renderer: ptr WlrRenderer): ptr WlrEgl {.importc: "wlr_gles2_renderer_get_egl".}
proc check_ext*(renderer: ptr WlrRenderer; ext: cstring): bool {.importc: "wlr_gles2_renderer_check_ext".}

proc get_current_fbo*(wlr_renderer: ptr WlrRenderer): GLuint {.importc: "wlr_gles2_renderer_get_current_fbo".}
type WlrGles2Texture_attribs* = object
  target*: GLenum            #  either GL_TEXTURE_2D or GL_TEXTURE_EXTERNAL_OES
  tex*: GLuint
  inverted_y*: bool
  has_alpha*: bool

proc is_gles2*(wlr_renderer: ptr WlrRenderer): bool {.importc: "wlr_renderer_is_gles2".}
proc is_gles2*(texture: ptr WlrTexture): bool {.importc: "wlr_texture_is_gles2".}
proc get_attribs*(texture: ptr WlrTexture; attribs: ptr WlrGles2Texture_attribs) {.importc: "wlr_gles2_texture_get_attribs".}

## interface

type WlrRenderer_impl* = object
  bind_buffer*: proc (renderer: ptr WlrRenderer; buffer: ptr WlrBuffer): bool

  begin*: proc (renderer: ptr WlrRenderer; width, height: uint32)
  `end`*: proc (renderer: ptr WlrRenderer)
  clear*: proc (renderer: ptr WlrRenderer; color: array[4, cfloat])
  scissor*: proc (renderer: ptr WlrRenderer; box: ptr WlrBox)

  render_subtexture_with_matrix*: proc (renderer: ptr WlrRenderer; texture: ptr WlrTexture; box: ptr WlrFbox; matrix: array[9, cfloat]; alpha: cfloat): bool
  render_quad_with_matrix*: proc (renderer: ptr WlrRenderer; color: array[4, cfloat]; matrix: array[9, cfloat])

  get_shm_texture_formats*: proc (renderer: ptr WlrRenderer; len: ptr csize_t): ptr uint32
  resource_is_wl_drm_buffer*: proc (renderer: ptr WlrRenderer; resource: ptr WlResource): bool
  wl_drm_buffer_get_size*: proc (renderer: ptr WlrRenderer; buffer: ptr WlResource; width, height: ptr cint)
  get_dmabuf_texture_formats*: proc (renderer: ptr WlrRenderer): ptr WlrDrmFormat_set
  get_render_formats*: proc (renderer: ptr WlrRenderer): ptr WlrDrmFormat_set

  preferred_read_format*: proc (renderer: ptr WlrRenderer): uint32
  read_pixels*: proc (renderer: ptr WlrRenderer; fmt: uint32; flags: ptr uint32; stride, width, height: uint32; src_x, src_y: uint32; dst_x, dst_y: uint32; data: pointer): bool

  texture_from_pixels*: proc (renderer: ptr WlrRenderer; fmt: uint32; stride, width, height: uint32; data: pointer): ptr WlrTexture
  texture_from_wl_drm*: proc (renderer: ptr WlrRenderer; data: ptr WlResource): ptr WlrTexture
  texture_from_dmabuf*: proc (renderer: ptr WlrRenderer; attribs: ptr WlrDmabufAttributes): ptr WlrTexture

  destroy*: proc (renderer: ptr WlrRenderer)
  init_wl_display*: proc (renderer: ptr WlrRenderer; WlDisplay: ptr WlDisplay): bool

  get_drm_fd*: proc (renderer: ptr WlrRenderer): cint
  get_render_buffer_caps*: proc (renderer: ptr WlrRenderer): uint32

  texture_from_buffer*: proc (renderer: ptr WlrRenderer; buffer: ptr WlrBuffer): ptr WlrTexture

proc init*(renderer: ptr WlrRenderer; impl: ptr WlrRenderer_impl) {.importc: "wlr_renderer_init".}

type WlrTexture_impl* = object
  is_opaque*: proc (texture: ptr WlrTexture): bool
  write_pixels*: proc (texture: ptr WlrTexture; stride, width, height: uint32; src_x, src_y: uint32; dst_x, dst_y: uint32; data: pointer): bool
  destroy*: proc (texture: ptr WlrTexture)

proc init*(texture: ptr WlrTexture; impl: ptr WlrTexture_impl; width, height: uint32) {.importc: "wlr_texture_init".}

## pixman

proc create_wlr_pixman_renderer*(): ptr WlrRenderer {.importc: "wlr_pixman_renderer_create".}

proc get_current_image*(wlr_renderer: ptr WlrRenderer): ptr PixmanImage {.importc: "wlr_pixman_renderer_get_current_image".}

proc is_pixman*(wlr_renderer: ptr WlrRenderer): bool {.importc: "wlr_renderer_is_pixman".}
proc is_pixman*(texture: ptr WlrTexture): bool {.importc: "wlr_texture_is_pixman".}
proc get_image*(wlr_texture: ptr WlrTexture): ptr PixmanImage {.importc: "wlr_pixman_texture_get_image".}

## wlr_renderer

type wlrRendererReadPixelsFlags = enum
  WLR_RENDERER_READ_PIXELS_Y_INVERT = 1

type WlrDrmFormatSet* = object
type WlrBuffer* = object

type WlrRenderer_events* = object
  destroy*: WlSignal

type WlrRenderer* = object
  impl*: ptr WlrRenderer_impl
  rendering*: bool
  rendering_with_buffer*: bool
  events*: WlrRenderer_events

proc autocreate_wlr_renderer*(backend: ptr WlrBackend): ptr WlrRenderer {.importc: "wlr_renderer_autocreate".}
proc begin*(r: ptr WlrRenderer; width, height: uint32) {.importc: "wlr_renderer_begin".}
proc begin_with_buffer*(r: ptr WlrRenderer; buffer: ptr WlrBuffer): bool {.importc: "wlr_renderer_begin_with_buffer".}
proc endRenderer*(r: ptr WlrRenderer) {.importc: "wlr_renderer_end".}
proc clear*(r: ptr WlrRenderer; color: array[4, cfloat]) {.importc: "wlr_renderer_clear".}

proc scissor*(r: ptr WlrRenderer; box: ptr WlrBox) {.importc: "wlr_renderer_scissor".}
proc texture*(r: ptr WlrRenderer; texture: ptr WlrTexture; projection: array[9, cfloat]; x, y: cint; alpha: cfloat): bool {.importc: "wlr_render_texture".}
proc texture_with_matrix*(r: ptr WlrRenderer; texture: ptr WlrTexture; matrix: array[9, cfloat]; alpha: cfloat): bool {.importc: "wlr_render_texture_with_matrix".}
proc subtexture_with_matrix*(r: ptr WlrRenderer; texture: ptr WlrTexture; box: ptr WlrFbox; matrix: array[9, cfloat]; alpha: cfloat): bool {.importc: "wlr_render_subtexture_with_matrix".}
proc rect*(r: ptr WlrRenderer; box: ptr WlrBox; color: array[4, cfloat]; projection: array[9, cfloat]) {.importc: "wlr_render_rect".}
proc quad_with_matrix*(r: ptr WlrRenderer; color: array[4, cfloat]; matrix: array[9, cfloat]) {.importc: "wlr_render_quad_with_matrix".}
proc get_shm_texture_formats*(r: ptr WlrRenderer; len: ptr csize_t): ptr uint32 {.importc: "wlr_renderer_get_shm_texture_formats".}
proc resource_is_wl_drm_buffer*(renderer: ptr WlrRenderer; buffer: ptr WlResource): bool {.importc: "wlr_renderer_resource_is_wl_drm_buffer".}
proc wl_drm_buffer_get_size*(renderer: ptr WlrRenderer; buffer: ptr WlResource; width, height: ptr cint) {.importc: "wlr_renderer_wl_drm_buffer_get_size".}
proc get_dmabuf_texture_formats*(renderer: ptr WlrRenderer): ptr WlrDrmFormatSet {.importc: "wlr_renderer_get_dmabuf_texture_formats".}
proc read_pixels*(r: ptr WlrRenderer; fmt: uint32; flags: ptr uint32; stride, width, height: uint32; src_x, src_y: uint32; dst_x, dst_y: uint32; data: pointer): bool {.importc: "wlr_renderer_read_pixels".}
proc init_display*(r: ptr WlrRenderer; WlDisplay: ptr WlDisplay): bool {.importc: "wlr_renderer_init_wl_display".}
proc get_drm_fd*(r: ptr WlrRenderer): cint {.importc: "wlr_renderer_get_drm_fd".}
proc destroy*(renderer: ptr WlrRenderer) {.importc: "wlr_renderer_destroy".}

## wlr_texture


type WlrTexture* = object
  impl*: ptr WlrTexture_impl
  width*, height*: uint32

proc wlr_texture_from_pixels*(renderer: ptr WlrRenderer; fmt: uint32; stride, width, height: uint32; data: pointer): ptr WlrTexture {.importc: "wlr_texture_from_pixels".}
proc wlr_texture_from_wl_drm*(renderer: ptr WlrRenderer; data: ptr WlResource): ptr WlrTexture {.importc: "wlr_texture_from_wl_drm".}
proc wlr_texture_from_dmabuf*(renderer: ptr WlrRenderer; attribs: ptr WlrDmabufAttributes): ptr WlrTexture {.importc: "wlr_texture_from_dmabuf".}

proc is_opaque*(texture: ptr WlrTexture): bool {.importc: "wlr_texture_is_opaque".}
proc write_pixels*(texture: ptr WlrTexture; stride, width, height: uint32; src_x, src_y: uint32; dst_x, dst_y: uint32; data: pointer): bool {.importc: "wlr_texture_write_pixels".}
proc destroy*(texture: ptr WlrTexture) {.importc: "wlr_texture_destroy".}

{.pop.}
