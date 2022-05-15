{.push dynlib: "libwlroots.so".}

## allocator

discard "forward decl of wlr_allocator"
discard "forward decl of wlr_backend"
discard "forward decl of wlr_drm_format"
discard "forward decl of wlr_renderer"

type wlr_allocator_interface* {.bycopy.} = object
  create_buffer*: proc (alloc: ptr wlr_allocator; width: cint; height: cint; format: ptr wlr_drm_format): ptr wlr_buffer
  destroy*: proc (alloc: ptr wlr_allocator)

proc wlr_allocator_init*(alloc: ptr wlr_allocator; impl: ptr wlr_allocator_interface; buffer_caps: uint32_t) {.importc: "wlr_allocator_init".}

type INNER_C_STRUCT_allocator_35* {.bycopy.} = object
  destroy*: wl_signal

type wlr_allocator* {.bycopy.} = object
  impl*: ptr wlr_allocator_interface
  buffer_caps*: uint32_t
  events*: INNER_C_STRUCT_allocator_35

proc wlr_allocator_autocreate*(backend: ptr wlr_backend; renderer: ptr wlr_renderer): ptr wlr_allocator {.importc: "wlr_allocator_autocreate".}
proc wlr_allocator_destroy*(alloc: ptr wlr_allocator) {.importc: "wlr_allocator_destroy".}
proc wlr_allocator_create_buffer*(alloc: ptr wlr_allocator; width: cint; height: cint; format: ptr wlr_drm_format): ptr wlr_buffer {.importc: "wlr_allocator_create_buffer".}

## dmabuf

const WLR_DMABUF_MAX_PLANES* = 4

type wlr_dmabuf_attributes* {.bycopy.} = object
  width*: int32_t
  height*: int32_t
  format*: uint32_t
  modifier*: uint64_t
  n_planes*: cint
  offset*: array[WLR_DMABUF_MAX_PLANES, uint32_t]
  stride*: array[WLR_DMABUF_MAX_PLANES, uint32_t]
  fd*: array[WLR_DMABUF_MAX_PLANES, cint]

proc wlr_dmabuf_attributes_finish*(attribs: ptr wlr_dmabuf_attributes) {.importc: "wlr_dmabuf_attributes_finish".}
proc wlr_dmabuf_attributes_copy*(dst: ptr wlr_dmabuf_attributes; src: ptr wlr_dmabuf_attributes): bool {.importc: "wlr_dmabuf_attributes_copy".}

## drm_format_set

type wlr_drm_format* {.bycopy.} = object
  format*: uint32_t
  len*: csize_t
  capacity*: csize_t
  modifiers*: UncheckedArray[uint64_t]

type wlr_drm_format_set* {.bycopy.} = object
  len*: csize_t
  capacity*: csize_t
  formats*: ptr ptr wlr_drm_format

proc wlr_drm_format_set_finish*(set: ptr wlr_drm_format_set) {.importc: "wlr_drm_format_set_finish".}
proc wlr_drm_format_set_get*(set: ptr wlr_drm_format_set; format: uint32_t): ptr wlr_drm_format {.importc: "wlr_drm_format_set_get".}
proc wlr_drm_format_set_has*(set: ptr wlr_drm_format_set; format: uint32_t; modifier: uint64_t): bool {.importc: "wlr_drm_format_set_has".}
proc wlr_drm_format_set_add*(set: ptr wlr_drm_format_set; format: uint32_t; modifier: uint64_t): bool {.importc: "wlr_drm_format_set_add".}
proc wlr_drm_format_set_intersect*(dst: ptr wlr_drm_format_set; a: ptr wlr_drm_format_set; b: ptr wlr_drm_format_set): bool {.importc: "wlr_drm_format_set_intersect".}

## egl

type INNER_C_STRUCT_egl_40* {.bycopy.} = object
  KHR_image_base*: bool
  EXT_image_dma_buf_import*: bool
  EXT_image_dma_buf_import_modifiers*: bool
  IMG_context_priority*: bool
  EXT_device_drm*: bool
  EXT_device_drm_render_node*: bool
  EXT_device_query*: bool
  KHR_platform_gbm*: bool
  EXT_platform_device*: bool

type INNER_C_STRUCT_egl_56* {.bycopy.} = object
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

type wlr_egl* {.bycopy.} = object
  display*: EGLDisplay
  context*: EGLContext
  device*: EGLDeviceEXT
  gbm_device*: ptr gbm_device
  exts*: INNER_C_STRUCT_egl_40
  procs*: INNER_C_STRUCT_egl_56
  has_modifiers*: bool
  dmabuf_texture_formats*: wlr_drm_format_set
  dmabuf_render_formats*: wlr_drm_format_set

proc wlr_egl_create_with_context*(display: EGLDisplay; context: EGLContext): ptr wlr_egl {.importc: "wlr_egl_create_with_context".}
proc wlr_egl_make_current*(egl: ptr wlr_egl): bool {.importc: "wlr_egl_make_current".}
proc wlr_egl_unset_current*(egl: ptr wlr_egl): bool {.importc: "wlr_egl_unset_current".}
proc wlr_egl_is_current*(egl: ptr wlr_egl): bool {.importc: "wlr_egl_is_current".}

## gles2

discard "forward decl of wlr_egl"
proc wlr_gles2_renderer_create_with_drm_fd*(drm_fd: cint): ptr wlr_renderer {.importc: "wlr_gles2_renderer_create_with_drm_fd".}
proc wlr_gles2_renderer_create*(egl: ptr wlr_egl): ptr wlr_renderer {.importc: "wlr_gles2_renderer_create".}
proc wlr_gles2_renderer_get_egl*(renderer: ptr wlr_renderer): ptr wlr_egl {.importc: "wlr_gles2_renderer_get_egl".}
proc wlr_gles2_renderer_check_ext*(renderer: ptr wlr_renderer; ext: cstring): bool {.importc: "wlr_gles2_renderer_check_ext".}

proc wlr_gles2_renderer_get_current_fbo*(wlr_renderer: ptr wlr_renderer): GLuint {.importc: "wlr_gles2_renderer_get_current_fbo".}
type wlr_gles2_texture_attribs* {.bycopy.} = object
  target*: GLenum
  tex*: GLuint
  has_alpha*: bool

proc wlr_renderer_is_gles2*(wlr_renderer: ptr wlr_renderer): bool {.importc: "wlr_renderer_is_gles2".}
proc wlr_texture_is_gles2*(texture: ptr wlr_texture): bool {.importc: "wlr_texture_is_gles2".}
proc wlr_gles2_texture_get_attribs*(texture: ptr wlr_texture; attribs: ptr wlr_gles2_texture_attribs) {.importc: "wlr_gles2_texture_get_attribs".}

## interface

discard "forward decl of wlr_box"
discard "forward decl of wlr_fbox"
type wlr_renderer_impl* {.bycopy.} = object
  bind_buffer*: proc (renderer: ptr wlr_renderer; buffer: ptr wlr_buffer): bool
  begin*: proc (renderer: ptr wlr_renderer; width: uint32_t; height: uint32_t)
  `end`*: proc (renderer: ptr wlr_renderer)
  # NOTE: const float color[static 4]
  clear*: proc (renderer: ptr wlr_renderer; color: array[4, cfloat])
  scissor*: proc (renderer: ptr wlr_renderer; box: ptr wlr_box)
  # NOTE: const float matrix[static 9]
  render_subtexture_with_matrix*: proc (renderer: ptr wlr_renderer; texture: ptr wlr_texture; box: ptr wlr_fbox; matrix: array[9, cfloat]; alpha: cfloat): bool
  # NOTE: const float color[static 4], const float matrix[static 9]
  render_quad_with_matrix*: proc (renderer: ptr wlr_renderer; color: array[4, cfloat]; matrix: array[9, cfloat])
  get_shm_texture_formats*: proc (renderer: ptr wlr_renderer; len: ptr csize_t): ptr uint32_t
  get_dmabuf_texture_formats*: proc (renderer: ptr wlr_renderer): ptr wlr_drm_format_set
  get_render_formats*: proc (renderer: ptr wlr_renderer): ptr wlr_drm_format_set
  preferred_read_format*: proc (renderer: ptr wlr_renderer): uint32_t
  read_pixels*: proc (renderer: ptr wlr_renderer; fmt: uint32_t; flags: ptr uint32_t; stride: uint32_t; width: uint32_t; height: uint32_t; src_x: uint32_t; src_y: uint32_t; dst_x: uint32_t; dst_y: uint32_t; data: pointer): bool
  destroy*: proc (renderer: ptr wlr_renderer)
  get_drm_fd*: proc (renderer: ptr wlr_renderer): cint
  get_render_buffer_caps*: proc (renderer: ptr wlr_renderer): uint32_t
  texture_from_buffer*: proc (renderer: ptr wlr_renderer; buffer: ptr wlr_buffer): ptr wlr_texture

proc wlr_renderer_init*(renderer: ptr wlr_renderer; impl: ptr wlr_renderer_impl) {.importc: "wlr_renderer_init".}
type wlr_texture_impl* {.bycopy.} = object
  is_opaque*: proc (texture: ptr wlr_texture): bool
  write_pixels*: proc (texture: ptr wlr_texture; stride: uint32_t; width: uint32_t; height: uint32_t; src_x: uint32_t; src_y: uint32_t; dst_x: uint32_t; dst_y: uint32_t; data: pointer): bool
  destroy*: proc (texture: ptr wlr_texture)

proc wlr_texture_init*(texture: ptr wlr_texture; impl: ptr wlr_texture_impl; width: uint32_t; height: uint32_t) {.importc: "wlr_texture_init".}

## pixman

proc wlr_pixman_renderer_create*(): ptr wlr_renderer {.importc: "wlr_pixman_renderer_create".}

proc wlr_pixman_renderer_get_current_image*(wlr_renderer: ptr wlr_renderer): ptr pixman_image_t {.importc: "wlr_pixman_renderer_get_current_image".}
proc wlr_renderer_is_pixman*(wlr_renderer: ptr wlr_renderer): bool {.importc: "wlr_renderer_is_pixman".}
proc wlr_texture_is_pixman*(texture: ptr wlr_texture): bool {.importc: "wlr_texture_is_pixman".}
proc wlr_pixman_texture_get_image*(wlr_texture: ptr wlr_texture): ptr pixman_image_t {.importc: "wlr_pixman_texture_get_image".}

## vulkan

proc wlr_vk_renderer_create_with_drm_fd*(drm_fd: cint): ptr wlr_renderer {.importc: "wlr_vk_renderer_create_with_drm_fd".}
proc wlr_texture_is_vk*(texture: ptr wlr_texture): bool {.importc: "wlr_texture_is_vk".}

## wlr_renderer

type wlr_renderer_read_pixels_flags* = enum
  WLR_RENDERER_READ_PIXELS_Y_INVERT = 1

discard "forward decl of wlr_renderer_impl"
discard "forward decl of wlr_drm_format_set"
discard "forward decl of wlr_buffer"
discard "forward decl of wlr_box"
discard "forward decl of wlr_fbox"

type INNER_C_STRUCT_render_wlr_renderer_34* {.bycopy.} = object
  destroy*: wl_signal

type wlr_renderer* {.bycopy.} = object
  impl*: ptr wlr_renderer_impl
  rendering*: bool
  rendering_with_buffer*: bool
  events*: INNER_C_STRUCT_render_wlr_renderer_34

proc wlr_renderer_autocreate*(backend: ptr wlr_backend): ptr wlr_renderer {.importc: "wlr_renderer_autocreate".}
proc wlr_renderer_begin*(r: ptr wlr_renderer; width: uint32_t; height: uint32_t) {.importc: "wlr_renderer_begin".}
proc wlr_renderer_begin_with_buffer*(r: ptr wlr_renderer; buffer: ptr wlr_buffer): bool {.importc: "wlr_renderer_begin_with_buffer".}
proc wlr_renderer_end*(r: ptr wlr_renderer) {.importc: "wlr_renderer_end".}
# NOTE: const float color[static 4]
proc wlr_renderer_clear*(r: ptr wlr_renderer; color: array[4, cfloat]) {.importc: "wlr_renderer_clear".}
proc wlr_renderer_scissor*(r: ptr wlr_renderer; box: ptr wlr_box) {.importc: "wlr_renderer_scissor".}
# NOTE: const float projection[static 9]
proc wlr_render_texture*(r: ptr wlr_renderer; texture: ptr wlr_texture; projection: array[9, cfloat]; x: cint; y: cint; alpha: cfloat): bool {.importc: "wlr_render_texture".}
# NOTE: const float matrix[static 9]
proc wlr_render_texture_with_matrix*(r: ptr wlr_renderer; texture: ptr wlr_texture; matrix: array[9, cfloat]; alpha: cfloat): bool {.importc: "wlr_render_texture_with_matrix".}
# NOTE: const float matrix[static 9]
proc wlr_render_subtexture_with_matrix*(r: ptr wlr_renderer; texture: ptr wlr_texture; box: ptr wlr_fbox; matrix: array[9, cfloat]; alpha: cfloat): bool {.importc: "wlr_render_subtexture_with_matrix".}
# NOTE: const float color[static 4], const float projection[static 9]
proc wlr_render_rect*(r: ptr wlr_renderer; box: ptr wlr_box; color: array[4, cfloat]; projection: array[9, cfloat]) {.importc: "wlr_render_rect".}
# NOTE: const float color[static 4], const float matrix[static 9]
proc wlr_render_quad_with_matrix*(r: ptr wlr_renderer; color: array[4, cfloat]; matrix: array[9, cfloat]) {.importc: "wlr_render_quad_with_matrix".}
proc wlr_renderer_get_shm_texture_formats*(r: ptr wlr_renderer; len: ptr csize_t): ptr uint32_t {.importc: "wlr_renderer_get_shm_texture_formats".}
proc wlr_renderer_get_dmabuf_texture_formats*(renderer: ptr wlr_renderer): ptr wlr_drm_format_set {.importc: "wlr_renderer_get_dmabuf_texture_formats".}
proc wlr_renderer_read_pixels*(r: ptr wlr_renderer; fmt: uint32_t; flags: ptr uint32_t; stride: uint32_t; width: uint32_t; height: uint32_t; src_x: uint32_t; src_y: uint32_t; dst_x: uint32_t; dst_y: uint32_t; data: pointer): bool {.importc: "wlr_renderer_read_pixels".}
proc wlr_renderer_init_wl_display*(r: ptr wlr_renderer; wl_display: ptr wl_display): bool {.importc: "wlr_renderer_init_wl_display".}
proc wlr_renderer_init_wl_shm*(r: ptr wlr_renderer; wl_display: ptr wl_display): bool {.importc: "wlr_renderer_init_wl_shm".}
proc wlr_renderer_get_drm_fd*(r: ptr wlr_renderer): cint {.importc: "wlr_renderer_get_drm_fd".}
proc wlr_renderer_destroy*(renderer: ptr wlr_renderer) {.importc: "wlr_renderer_destroy".}

## wlr_texture

discard "forward decl of wlr_buffer"
discard "forward decl of wlr_renderer"
discard "forward decl of wlr_texture_impl"
type wlr_texture* {.bycopy.} = object
  impl*: ptr wlr_texture_impl
  width*: uint32_t
  height*: uint32_t

proc wlr_texture_from_pixels*(renderer: ptr wlr_renderer; fmt: uint32_t; stride: uint32_t; width: uint32_t; height: uint32_t; data: pointer): ptr wlr_texture {.importc: "wlr_texture_from_pixels".}
proc wlr_texture_from_dmabuf*(renderer: ptr wlr_renderer; attribs: ptr wlr_dmabuf_attributes): ptr wlr_texture {.importc: "wlr_texture_from_dmabuf".}
proc wlr_texture_is_opaque*(texture: ptr wlr_texture): bool {.importc: "wlr_texture_is_opaque".}
proc wlr_texture_write_pixels*(texture: ptr wlr_texture; stride: uint32_t; width: uint32_t; height: uint32_t; src_x: uint32_t; src_y: uint32_t; dst_x: uint32_t; dst_y: uint32_t; data: pointer): bool {.importc: "wlr_texture_write_pixels".}
proc wlr_texture_destroy*(texture: ptr wlr_texture) {.importc: "wlr_texture_destroy".}
proc wlr_texture_from_buffer*(renderer: ptr wlr_renderer; buffer: ptr wlr_buffer): ptr wlr_texture {.importc: "wlr_texture_from_buffer".}

{.pop.}
