{.push dynlib: "libwlroots.so".}

import wayland, pixman
import types

## wlr_box

proc closest_point*(box: ptr WlrBox; x, y: cdouble; dest_x, dest_y: ptr cdouble) {.importc: "wlr_box_closest_point".}
proc intersection*(dest: ptr WlrBox; box_a, box_b: ptr WlrBox): bool {.importc: "wlr_box_intersection".}
proc contains_point*(box: ptr WlrBox; x, y: cdouble): bool {.importc: "wlr_box_contains_point".}
proc empty*(box: ptr WlrBox): bool {.importc: "wlr_box_empty".}
proc transform*(dest, box: ptr WlrBox; transform: WlOutputTransform; width, height: cint) {.importc: "wlr_box_transform".}
proc rotated_bounds*(dest, box: ptr WlrBox; rotation: cfloat) {.importc: "wlr_box_rotated_bounds".}
proc from_pixman_box32*(dest: ptr WlrBox; box: PixmanBox32) {.importc: "wlr_box_from_pixman_box32".}

## wlr_buffer

proc init*(buffer: ptr WlrBuffer; impl: ptr WlrBuffer_impl; width, height: cint) {.importc: "wlr_buffer_init".}
proc drop*(buffer: ptr WlrBuffer) {.importc: "wlr_buffer_drop".}
proc lock*(buffer: ptr WlrBuffer): ptr WlrBuffer {.importc: "wlr_buffer_lock".}
proc unlock*(buffer: ptr WlrBuffer) {.importc: "wlr_buffer_unlock".}
proc get_dmabuf*(buffer: ptr WlrBuffer; attribs: ptr WlrDmabufAttributes): bool {.importc: "wlr_buffer_get_dmabuf".}
proc get_shm*(buffer: ptr WlrBuffer; attribs: ptr WlrShmAttributes): bool {.importc: "wlr_buffer_get_shm".}

proc get_wlr_client_buffer*(buffer: ptr WlrBuffer): ptr WlrClient_buffer {.importc: "wlr_client_buffer_get".}
proc is_buffer*(resource: ptr WlResource): bool {.importc: "wlr_resource_is_buffer".}
proc get_buffer_size*(resource: ptr WlResource; renderer: ptr WlrRenderer; width: ptr cint; height: ptr cint): bool {.importc: "wlr_resource_get_buffer_size".}
proc import_wlr_client_buffer*(renderer: ptr WlrRenderer; resource: ptr WlResource): ptr WlrClientBuffer {.importc: "wlr_client_buffer_import".}
proc apply_damage*(buffer: ptr WlrClientBuffer; resource: ptr WlResource; damage: ptr PixmanRegion32): ptr WlrClientBuffer {.importc: "wlr_client_buffer_apply_damage".}

## wlr_compositor

proc create_wlr_compositor*(display: ptr WlDisplay; renderer: ptr WlrRenderer): ptr WlrCompositor {.importc: "wlr_compositor_create".}
proc is_subsurface*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_is_subsurface".}
proc wlr_subsurface_from_wlr_surface*(surface: ptr WlrSurface): ptr WlrSubsurface {.importc: "wlr_subsurface_from_wlr_surface".}

## wlr_cursor

proc create_wlr_cursor*(): ptr WlrCursor {.importc: "wlr_cursor_create".}
proc destroy*(cur: ptr WlrCursor) {.importc: "wlr_cursor_destroy".}

proc warp*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; lx, ly: cdouble): bool {.importc: "wlr_cursor_warp".}
proc absolute_to_layout_coords*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; x, y: cdouble; lx, ly: ptr cdouble) {.importc: "wlr_cursor_absolute_to_layout_coords".}
proc warp_closest*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; x, y: cdouble) {.importc: "wlr_cursor_warp_closest".}
proc warp_absolute*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; x, y: cdouble) {.importc: "wlr_cursor_warp_absolute".}
proc move*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; delta_x, delta_y: cdouble) {.importc: "wlr_cursor_move".}

proc set_image*(cur: ptr WlrCursor; pixels: ptr uint8; stride: int32; width, height: uint32; hotspot_x, hotspot_y: int32; scale: cfloat) {.importc: "wlr_cursor_set_image".}
proc set_surface*(cur: ptr WlrCursor; surface: ptr WlrSurface; hotspot_x, hotspot_y: int32) {.importc: "wlr_cursor_set_surface".}

proc attach_input_device*(cur: ptr WlrCursor; dev: ptr WlrInputDevice) {.importc: "wlr_cursor_attach_input_device".}
proc detach_input_device*(cur: ptr WlrCursor; dev: ptr WlrInputDevice) {.importc: "wlr_cursor_detach_input_device".}
proc attach_output_layout*(cur: ptr WlrCursor; l: ptr WlrOutput_layout) {.importc: "wlr_cursor_attach_output_layout".}

proc map_to_output*(cur: ptr WlrCursor; output: ptr WlrOutput) {.importc: "wlr_cursor_map_to_output".}
proc map_input_to_output*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; output: ptr WlrOutput) {.importc: "wlr_cursor_map_input_to_output".}
proc map_to_region*(cur: ptr WlrCursor; box: ptr WlrBox) {.importc: "wlr_cursor_map_to_region".}
proc map_input_to_region*(cur: ptr WlrCursor; dev: ptr WlrInputDevice; box: ptr WlrBox) {.importc: "wlr_cursor_map_input_to_region".}

## wlr_data_control_v1

proc create_wlr_data_control_manager_v1*(display: ptr WlDisplay): ptr WlrDataControlManager_v1 {.importc: "wlr_data_control_manager_v1_create".}
proc destroy*(device: ptr WlrDataControlDevice_v1) {.importc: "wlr_data_control_device_v1_destroy".}

## wlr_data_device

proc create_wlr_data_device_manager*(display: ptr WlDisplay): ptr WlrDataDeviceManager {.importc: "wlr_data_device_manager_create".}
proc request_set_selection*(seat: ptr WlrSeat; client: ptr WlrSeatClient; source: ptr WlrDataSource; serial: uint32) {.importc: "wlr_seat_request_set_selection".}
proc set_selection*(seat: ptr WlrSeat; source: ptr WlrDataSource; serial: uint32) {.importc: "wlr_seat_set_selection".}
proc create_wlr_drag*(seat_client: ptr WlrSeatClient; source: ptr WlrDataSource; icon_surface: ptr WlrSurface): ptr WlrDrag {.importc: "wlr_drag_create".}
proc request_start_drag*(seat: ptr WlrSeat; drag: ptr WlrDrag; origin: ptr WlrSurface; serial: uint32) {.importc: "wlr_seat_request_start_drag".}
proc start_drag*(seat: ptr WlrSeat; drag: ptr WlrDrag; serial: uint32) {.importc: "wlr_seat_start_drag".}
proc start_pointer_drag*(seat: ptr WlrSeat; drag: ptr WlrDrag; serial: uint32) {.importc: "wlr_seat_start_pointer_drag".}
proc start_touch_drag*(seat: ptr WlrSeat; drag: ptr WlrDrag; serial: uint32; point: ptr WlrTouchPoint) {.importc: "wlr_seat_start_touch_drag".}
proc init*(source: ptr WlrDataSource; impl: ptr WlrDataSource_impl) {.importc: "wlr_data_source_init".}
proc send*(source: ptr WlrDataSource; mime_type: cstring; fd: int32) {.importc: "wlr_data_source_send".}
proc accept*(source: ptr WlrDataSource; serial: uint32; mime_type: cstring) {.importc: "wlr_data_source_accept".}
proc destroy*(source: ptr WlrDataSource) {.importc: "wlr_data_source_destroy".}
proc dnd_drop*(source: ptr WlrDataSource) {.importc: "wlr_data_source_dnd_drop".}
proc dnd_finish*(source: ptr WlrDataSource) {.importc: "wlr_data_source_dnd_finish".}
proc dnd_action*(source: ptr WlrDataSource; action: WlrDataDeviceManagerDndAction) {.importc: "wlr_data_source_dnd_action".}

## wlr_export_dmabuf_v1

proc create_wlr_export_dmabuf_manager_v1*(display: ptr WlDisplay): ptr WlrExportDmabufManager_v1 {.importc: "wlr_export_dmabuf_manager_v1_create".}

## wlr_foreign_toplevel_management_v1

proc create_wlr_foreign_toplevel_manager_v1*(display: ptr WlDisplay): ptr WlrForeignToplevelManager_v1 {.importc: "wlr_foreign_toplevel_manager_v1_create".}
proc create_wlr_foreign_toplevel_handle_v1*(manager: ptr WlrForeignToplevelManager_v1): ptr WlrForeignToplevelHandle_v1 {.importc: "wlr_foreign_toplevel_handle_v1_create".}

proc destroy*(toplevel: ptr WlrForeignToplevelHandle_v1) {.importc: "wlr_foreign_toplevel_handle_v1_destroy".}

proc set_title*(toplevel: ptr WlrForeignToplevelHandle_v1; title: cstring) {.importc: "wlr_foreign_toplevel_handle_v1_set_title".}
proc set_app_id*(toplevel: ptr WlrForeignToplevelHandle_v1; app_id: cstring) {.importc: "wlr_foreign_toplevel_handle_v1_set_app_id".}

proc output_enter*(toplevel: ptr WlrForeignToplevelHandle_v1; output: ptr WlrOutput) {.importc: "wlr_foreign_toplevel_handle_v1_output_enter".}
proc output_leave*(toplevel: ptr WlrForeignToplevelHandle_v1; output: ptr WlrOutput) {.importc: "wlr_foreign_toplevel_handle_v1_output_leave".}

proc set_maximized*(toplevel: ptr WlrForeignToplevelHandle_v1; maximized: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_maximized".}
proc set_minimized*(toplevel: ptr WlrForeignToplevelHandle_v1; minimized: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_minimized".}
proc set_activated*(toplevel: ptr WlrForeignToplevelHandle_v1; activated: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_activated".}
proc set_fullscreen*(toplevel: ptr WlrForeignToplevelHandle_v1; fullscreen: bool) {.importc: "wlr_foreign_toplevel_handle_v1_set_fullscreen".}

proc set_parent*(toplevel: ptr WlrForeignToplevelHandle_v1; parent: ptr WlrForeignToplevelHandle_v1) {.importc: "wlr_foreign_toplevel_handle_v1_set_parent".}

## wlr_fullscreen_shell_v1

proc create_wlr_fullscreen_shell_v1*(display: ptr WlDisplay): ptr WlrFullscreenShell_v1 {.importc: "wlr_fullscreen_shell_v1_create".}

## wlr_gamma_control_v1

proc create_wlr_gamma_control_manager_v1*(display: ptr WlDisplay): ptr WlrGammaControlManager_v1 {.importc: "wlr_gamma_control_manager_v1_create".}

## wlr_idle

proc create_wlr_idle_inhibit_v1*(display: ptr WlDisplay): ptr WlrIdleInhibitManager_v1 {.importc: "wlr_idle_inhibit_v1_create".}

## wlr_idle_inhibit_v1

proc create_wlr_idle*(display: ptr WlDisplay): ptr WlrIdle {.importc: "wlr_idle_create".}
proc notify_activity*(idle: ptr WlrIdle; seat: ptr WlrSeat) {.importc: "wlr_idle_notify_activity".}
proc set_enabled*(idle: ptr WlrIdle; seat: ptr WlrSeat; enabled: bool) {.importc: "wlr_idle_set_enabled".}
proc create_wlr_idle_timeout*(idle: ptr WlrIdle; seat: ptr WlrSeat; timeout: uint32): ptr WlrIdleTimeout {.importc: "wlr_idle_timeout_create".}
proc destroy*(timeout: ptr WlrIdleTimeout) {.importc: "wlr_idle_timeout_destroy".}

## wlr_input_device

## wlr_input_inhibitor

proc create_wlr_input_inhibit_manager*(display: ptr WlDisplay): ptr WlrInputInhibitManager {.importc: "wlr_input_inhibit_manager_create".}

## wlr_input_method_v2

proc create_wlr_input_method_manager_v2*(display: ptr WlDisplay): ptr WlrInputMethodManager_v2 {.importc: "wlr_input_method_manager_v2_create".}

proc send_activate*(input_method: ptr WlrInputMethod_v2) {.importc: "wlr_input_method_v2_send_activate".}
proc send_deactivate*(input_method: ptr WlrInputMethod_v2) {.importc: "wlr_input_method_v2_send_deactivate".}
proc send_surrounding_text*(input_method: ptr WlrInputMethod_v2; text: cstring; cursor: uint32; anchor: uint32) {.importc: "wlr_input_method_v2_send_surrounding_text".}
proc send_content_type*(input_method: ptr WlrInputMethod_v2; hint: uint32; purpose: uint32) {.importc: "wlr_input_method_v2_send_content_type".}
proc send_text_change_cause*(input_method: ptr WlrInputMethod_v2; cause: uint32) {.importc: "wlr_input_method_v2_send_text_change_cause".}
proc send_done*(input_method: ptr WlrInputMethod_v2) {.importc: "wlr_input_method_v2_send_done".}
proc send_unavailable*(input_method: ptr WlrInputMethod_v2) {.importc: "wlr_input_method_v2_send_unavailable".}

proc send_key*(keyboard_grab: ptr WlrInputMethodKeyboardGrab_v2; time: uint32; key: uint32; state: uint32) {.importc: "wlr_input_method_keyboard_grab_v2_send_key".}
proc send_modifiers*(keyboard_grab: ptr WlrInputMethodKeyboardGrab_v2; modifiers: ptr WlrKeyboardModifiers) {.importc: "wlr_input_method_keyboard_grab_v2_send_modifiers".}
proc set_keyboard*(keyboard_grab: ptr WlrInputMethodKeyboardGrab_v2; keyboard: ptr WlrKeyboard) {.importc: "wlr_input_method_keyboard_grab_v2_set_keyboard".}
proc destroy*(keyboard_grab: ptr WlrInputMethodKeyboardGrab_v2) {.importc: "wlr_input_method_keyboard_grab_v2_destroy".}

## wlr_keyboard_group

proc create_wlr_keyboard_group*(): ptr WlrKeyboardGroup {.importc: "wlr_keyboard_group_create".}
proc wlr_keyboard_group_from_wlr_keyboard*(keyboard: ptr WlrKeyboard): ptr WlrKeyboardGroup {.importc: "wlr_keyboard_group_from_wlr_keyboard".}
proc add_keyboard*(group: ptr WlrKeyboardGroup; keyboard: ptr WlrKeyboard): bool {.importc: "wlr_keyboard_group_add_keyboard".}
proc remove_keyboard*(group: ptr WlrKeyboardGroup; keyboard: ptr WlrKeyboard) {.importc: "wlr_keyboard_group_remove_keyboard".}
proc destroy*(group: ptr WlrKeyboardGroup) {.importc: "wlr_keyboard_group_destroy".}

## wlr_keyboard

proc set_keymap*(kb: ptr WlrKeyboard; keymap: ptr xkb_keymap): bool {.importc: "wlr_keyboard_set_keymap".}
proc keymaps_match*(km1: ptr xkb_keymap; km2: ptr xkb_keymap): bool {.importc: "wlr_keyboard_keymaps_match".}
proc set_repeat_info*(kb: ptr WlrKeyboard; rate: int32; delay: int32) {.importc: "wlr_keyboard_set_repeat_info".}
proc led_update*(keyboard: ptr WlrKeyboard; leds: uint32) {.importc: "wlr_keyboard_led_update".}
proc get_modifiers*(keyboard: ptr WlrKeyboard): uint32 {.importc: "wlr_keyboard_get_modifiers".}

## wlr_keyboard_shortcuts_inhibit_v1

proc create_wlr_keyboard_shortcuts_inhibit_v1*(display: ptr WlDisplay): ptr WlrKeyboardShortcutsInhibitManager_v1 {.importc: "wlr_keyboard_shortcuts_inhibit_v1_create".}
proc activate*(inhibitor: ptr WlrKeyboardShortcutsInhibitor_v1) {.importc: "wlr_keyboard_shortcuts_inhibitor_v1_activate".}
proc deactivate*(inhibitor: ptr WlrKeyboardShortcutsInhibitor_v1) {.importc: "wlr_keyboard_shortcuts_inhibitor_v1_deactivate".}

## wlr_layer_shell_v1

proc create_wlr_layer_shell_v1*(display: ptr WlDisplay): ptr WlrLayerShell_v1 {.importc: "wlr_layer_shell_v1_create".}
proc configure*(surface: ptr WlrLayerSurface_v1; width, height: uint32) {.importc: "wlr_layer_surface_v1_configure".}
proc close*(surface: ptr WlrLayerSurface_v1) {.importc: "wlr_layer_surface_v1_close".}
proc is_layer_surface*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_is_layer_surface".}
proc wlr_layer_surface_v1_from_wlr_surface*(surface: ptr WlrSurface): ptr WlrLayerSurface_v1 {.importc: "wlr_layer_surface_v1_from_wlr_surface".}
proc for_each_surface*(surface: ptr WlrLayerSurface_v1; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_layer_surface_v1_for_each_surface".}
proc for_each_popup_surface*(surface: ptr WlrLayerSurface_v1; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_layer_surface_v1_for_each_popup_surface".}
proc surface_at*(surface: ptr WlrLayerSurface_v1; sx, sy: cdouble; sub_x, sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_layer_surface_v1_surface_at".}
proc popup_surface_at*(surface: ptr WlrLayerSurface_v1; sx, sy: cdouble; sub_x, sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_layer_surface_v1_popup_surface_at".}

## wlr_linux_dmabuf_v1

proc is_buffer*(buffer_resource: ptr WlResource): bool {.importc: "wlr_dmabuf_v1_resource_is_buffer".}
proc wlr_dmabuf_v1_buffer_from_buffer_resource*(buffer_resource: ptr WlResource): ptr WlrDmabuf_v1_buffer {.importc: "wlr_dmabuf_v1_buffer_from_buffer_resource".}
proc create_wlr_linux_dmabuf_v1*(display: ptr WlDisplay; renderer: ptr WlrRenderer): ptr WlrLinuxDmabuf_v1 {.importc: "wlr_linux_dmabuf_v1_create".}

## wlr_list

proc init*(list: ptr WlrList): bool {.importc: "wlr_list_init".}
proc finish*(list: ptr WlrList) {.importc: "wlr_list_finish".}
proc for_each*(list: ptr WlrList; callback: proc (item: pointer)) {.importc: "wlr_list_for_each".}
proc push*(list: ptr WlrList; item: pointer): ssize_t {.importc: "wlr_list_push".}
proc insert*(list: ptr WlrList; index: csize_t; item: pointer): ssize_t {.importc: "wlr_list_insert".}
proc del*(list: ptr WlrList; index: csize_t) {.importc: "wlr_list_del".}
proc pop*(list: ptr WlrList): pointer {.importc: "wlr_list_pop".}
proc peek*(list: ptr WlrList): pointer {.importc: "wlr_list_peek".}
proc cat*(list: ptr WlrList; source: ptr WlrList): ssize_t {.importc: "wlr_list_cat".}
proc qsort*(list: ptr WlrList; compare: proc (left: pointer; right: pointer): cint) {.importc: "wlr_list_qsort".}
proc find*(list: ptr WlrList; compare: proc (item: pointer; cmp_to: pointer): cint; cmp_to: pointer): ssize_t {.importc: "wlr_list_find".}

## wlr_matrix

proc identity*(mat: array[9, cfloat]) {.importc: "wlr_matrix_identity".}
proc multiply*(mat: array[9, cfloat]; a: array[9, cfloat]; b: array[9, cfloat]) {.importc: "wlr_matrix_multiply".}
proc transpose*(mat: array[9, cfloat]; a: array[9, cfloat]) {.importc: "wlr_matrix_transpose".}
proc translate*(mat: array[9, cfloat]; x, y: cfloat) {.importc: "wlr_matrix_translate".}
proc scale*(mat: array[9, cfloat]; x, y: cfloat) {.importc: "wlr_matrix_scale".}
proc rotate*(mat: array[9, cfloat]; rad: cfloat) {.importc: "wlr_matrix_rotate".}
proc transform*(mat: array[9, cfloat]; transform: WlOutputTransform) {.importc: "wlr_matrix_transform".}
proc projection*(mat: array[9, cfloat]; width: cint; height: cint; transform: WlOutputTransform) {.importc: "wlr_matrix_projection".}
proc project_box*(mat: array[9, cfloat]; box: ptr WlrBox; transform: WlOutputTransform; rotation: cfloat; projection: array[9, cfloat]) {.importc: "wlr_matrix_project_box".}

## wlr_output_damage

proc create_wlr_output_damage*(output: ptr WlrOutput): ptr WlrOutputDamage {.importc: "wlr_output_damage_create".}
proc destroy*(output_damage: ptr WlrOutputDamage) {.importc: "wlr_output_damage_destroy".}
proc attach_render*(output_damage: ptr WlrOutputDamage; needs_frame: ptr bool; buffer_damage: ptr PixmanRegion32): bool {.importc: "wlr_output_damage_attach_render".}
proc add*(output_damage: ptr WlrOutputDamage; damage: ptr PixmanRegion32) {.importc: "wlr_output_damage_add".}
proc add_whole*(output_damage: ptr WlrOutputDamage) {.importc: "wlr_output_damage_add_whole".}
proc add_box*(output_damage: ptr WlrOutputDamage; box: ptr WlrBox) {.importc: "wlr_output_damage_add_box".}

## wlr_output

proc enable*(output: ptr WlrOutput; enable: bool) {.importc: "wlr_output_enable".}
proc create_global*(output: ptr WlrOutput) {.importc: "wlr_output_create_global".}
proc destroy_global*(output: ptr WlrOutput) {.importc: "wlr_output_destroy_global".}

proc preferred_mode*(output: ptr WlrOutput): ptr WlrOutputMode {.importc: "wlr_output_preferred_mode".}
proc set_mode*(output: ptr WlrOutput; mode: ptr WlrOutput_mode) {.importc: "wlr_output_set_mode".}
proc set_custom_mode*(output: ptr WlrOutput; width, height: int32; refresh: int32) {.importc: "wlr_output_set_custom_mode".}
proc set_transform*(output: ptr WlrOutput; transform: WlOutputTransform) {.importc: "wlr_output_set_transform".}
proc enable_adaptive_sync*(output: ptr WlrOutput; enabled: bool) {.importc: "wlr_output_enable_adaptive_sync".}

proc set_scale*(output: ptr WlrOutput; scale: cfloat) {.importc: "wlr_output_set_scale".}
proc set_subpixel*(output: ptr WlrOutput; subpixel: WlOutputSubpixel) {.importc: "wlr_output_set_subpixel".}
proc set_description*(output: ptr WlrOutput; desc: cstring) {.importc: "wlr_output_set_description".}

proc schedule_done*(output: ptr WlrOutput) {.importc: "wlr_output_schedule_done".}
proc destroy*(output: ptr WlrOutput) {.importc: "wlr_output_destroy".}

proc transformed_resolution*(output: ptr WlrOutput; width, height: ptr cint) {.importc: "wlr_output_transformed_resolution".}
proc effective_resolution*(output: ptr WlrOutput; width, height: ptr cint) {.importc: "wlr_output_effective_resolution".}

proc attach_render*(output: ptr WlrOutput; buffer_age: ptr cint): bool {.importc: "wlr_output_attach_render".}
proc attach_buffer*(output: ptr WlrOutput; buffer: ptr WlrBuffer) {.importc: "wlr_output_attach_buffer".}

proc preferred_read_format*(output: ptr WlrOutput): uint32 {.importc: "wlr_output_preferred_read_format".}
proc set_damage*(output: ptr WlrOutput; damage: ptr PixmanRegion32) {.importc: "wlr_output_set_damage".}
proc test*(output: ptr WlrOutput): bool {.importc: "wlr_output_test".}
proc commit*(output: ptr WlrOutput): bool {.importc: "wlr_output_commit".}
proc rollback*(output: ptr WlrOutput) {.importc: "wlr_output_rollback".}
proc schedule_frame*(output: ptr WlrOutput) {.importc: "wlr_output_schedule_frame".}

proc get_gamma_size*(output: ptr WlrOutput): csize_t {.importc: "wlr_output_get_gamma_size".}
proc set_gamma*(output: ptr WlrOutput; size: csize_t; r, g, b: ptr uint16) {.importc: "wlr_output_set_gamma".}
proc export_dmabuf*(output: ptr WlrOutput; attribs: ptr WlrDmabufAttributes): bool {.importc: "wlr_output_export_dmabuf".}
proc wlr_output_from_resource*(resource: ptr WlResource): ptr WlrOutput {.importc: "wlr_output_from_resource".}

proc lock_attach_render*(output: ptr WlrOutput; lock: bool) {.importc: "wlr_output_lock_attach_render".}
proc lock_software_cursors*(output: ptr WlrOutput; lock: bool) {.importc: "wlr_output_lock_software_cursors".}
proc render_software_cursors*(output: ptr WlrOutput; damage: ptr PixmanRegion32) {.importc: "wlr_output_render_software_cursors".}
proc create_wlr_output_cursor*(output: ptr WlrOutput): ptr WlrOutputCursor {.importc: "wlr_output_cursor_create".}

proc set_image*(cursor: ptr WlrOutputCursor; pixels: ptr uint8; stride: int32; width, height: uint32; hotspot_x, hotspot_y: int32): bool {.importc: "wlr_output_cursor_set_image".}
proc set_surface*(cursor: ptr WlrOutputCursor; surface: ptr WlrSurface; hotspot_x, hotspot_y: int32) {.importc: "wlr_output_cursor_set_surface".}
proc move*(cursor: ptr WlrOutputCursor; x, y: cdouble): bool {.importc: "wlr_output_cursor_move".}
proc destroy*(cursor: ptr WlrOutputCursor) {.importc: "wlr_output_cursor_destroy".}

proc invert*(tr: WlOutputTransform): WlOutputTransform {.importc: "wlr_output_transform_invert".}
proc compose*(tr_a, tr_b: WlOutputTransform): WlOutputTransform {.importc: "wlr_output_transform_compose".}

## wlr_output_layout

proc create_wlr_output_layout*(): ptr WlrOutputLayout {.importc: "wlr_output_layout_create".}
proc destroy*(layout: ptr WlrOutputLayout) {.importc: "wlr_output_layout_destroy".}
proc get*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput): ptr WlrOutputLayout_output {.importc: "wlr_output_layout_get".}
proc output_at*(layout: ptr WlrOutputLayout; lx, ly: cdouble): ptr WlrOutput {.importc: "wlr_output_layout_output_at".}

proc add*(layout: ptr WlrOutputLayout; output: ptr WlrOutput; lx, ly: cint) {.importc: "wlr_output_layout_add".}
proc move*(layout: ptr WlrOutputLayout; output: ptr WlrOutput; lx, ly: cint) {.importc: "wlr_output_layout_move".}
proc remove*(layout: ptr WlrOutputLayout; output: ptr WlrOutput) {.importc: "wlr_output_layout_remove".}

proc output_coords*(layout: ptr WlrOutput_layout; reference: ptr WlrOutput; lx, ly: ptr cdouble) {.importc: "wlr_output_layout_output_coords".}
proc contains_point*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput; lx, ly: cint): bool {.importc: "wlr_output_layout_contains_point".}
proc intersects*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput; target_lbox: ptr WlrBox): bool {.importc: "wlr_output_layout_intersects".}

proc closest_point*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput; lx, ly: cdouble; dest_lx, dest_ly: ptr cdouble) {.importc: "wlr_output_layout_closest_point".}
proc get_box*(layout: ptr WlrOutputLayout; reference: ptr WlrOutput): ptr WlrBox {.importc: "wlr_output_layout_get_box".}
proc add_auto*(layout: ptr WlrOutput_layout; output: ptr WlrOutput) {.importc: "wlr_output_layout_add_auto".}
proc get_center_output*(layout: ptr WlrOutputLayout): ptr WlrOutput {.importc: "wlr_output_layout_get_center_output".}

proc adjacent_output*(layout: ptr WlrOutput_layout; direction: WlrDirection; reference: ptr WlrOutput; ref_lx, ref_ly: cdouble): ptr WlrOutput {.importc: "wlr_output_layout_adjacent_output".}
proc farthest_output*(layout: ptr WlrOutputLayout; direction: WlrDirection; reference: ptr WlrOutput; ref_lx, ref_ly: cdouble): ptr WlrOutput {.importc: "wlr_output_layout_farthest_output".}

## wlr_output_management_v1

proc create_wlr_output_manager_v1*(display: ptr WlDisplay): ptr WlrOutputManager_v1 {.importc: "wlr_output_manager_v1_create".}
proc set_configuration*(manager: ptr WlrOutput_manager_v1; config: ptr WlrOutputConfiguration_v1) {.importc: "wlr_output_manager_v1_set_configuration".}
proc create_wlr_output_configuration_v1*(): ptr WlrOutputConfiguration_v1 {.importc: "wlr_output_configuration_v1_create".}
proc destroy*(config: ptr WlrOutputConfiguration_v1) {.importc: "wlr_output_configuration_v1_destroy".}
proc send_succeeded*(config: ptr WlrOutputConfiguration_v1) {.importc: "wlr_output_configuration_v1_send_succeeded".}
proc send_failed*(config: ptr WlrOutputConfiguration_v1) {.importc: "wlr_output_configuration_v1_send_failed".}
proc create_wlr_output_configuration_head_v1*(config: ptr WlrOutputConfiguration_v1; output: ptr WlrOutput): ptr WlrOutputConfigurationHead_v1 {.importc: "wlr_output_configuration_head_v1_create".}

## wlr_output_power_management_v1

proc create_wlr_output_power_manager_v1*(display: ptr WlDisplay): ptr WlrOutput_power_manager_v1 {.importc: "wlr_output_power_manager_v1_create".}

## wlr_pointer_constraints_v1

proc create_wlr_pointer_constraints_v1*(display: ptr WlDisplay): ptr WlrPointerConstraints_v1 {.importc: "wlr_pointer_constraints_v1_create".}
proc constraint_for_surface*(pointer_constraints: ptr WlrPointerConstraints_v1; surface: ptr WlrSurface; seat: ptr WlrSeat): ptr WlrPointerConstraint_v1 {.importc: "wlr_pointer_constraints_v1_constraint_for_surface".}
proc send_activated*(constraint: ptr WlrPointerConstraint_v1) {.importc: "wlr_pointer_constraint_v1_send_activated".}
proc send_deactivated*(constraint: ptr WlrPointerConstraint_v1) {.importc: "wlr_pointer_constraint_v1_send_deactivated".}

## wlr_pointer_gestures_v1

proc create_wlr_pointer_gestures_v1*(display: ptr WlDisplay): ptr WlrPointerGestures_v1 {.importc: "wlr_pointer_gestures_v1_create".}

proc send_swipe_begin*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; fingers: uint32) {.importc: "wlr_pointer_gestures_v1_send_swipe_begin".}
proc send_swipe_update*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; dx, dy: cdouble) {.importc: "wlr_pointer_gestures_v1_send_swipe_update".}
proc send_swipe_end*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_swipe_end".}

proc send_pinch_begin*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; fingers: uint32) {.importc: "wlr_pointer_gestures_v1_send_pinch_begin".}
proc send_pinch_update*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; dx, dy: cdouble; scale, rotation: cdouble) {.importc: "wlr_pointer_gestures_v1_send_pinch_update".}
proc send_pinch_end*(gestures: ptr WlrPointerGestures_v1; seat: ptr WlrSeat; time_msec: uint32; cancelled: bool) {.importc: "wlr_pointer_gestures_v1_send_pinch_end".}

## wlr_pointer

## wlr_presentation_time

proc create_wlr_presentation*(display: ptr WlDisplay; backend: ptr WlrBackend): ptr WlrPresentation {.importc: "wlr_presentation_create".}
proc surface_sampled*(presentation: ptr WlrPresentation; surface: ptr WlrSurface): ptr WlrPresentationFeedback {.importc: "wlr_presentation_surface_sampled".}
proc send_presented*(feedback: ptr WlrPresentationFeedback; event: ptr WlrPresentation_event) {.importc: "wlr_presentation_feedback_send_presented".}
proc destroy*(feedback: ptr WlrPresentationFeedback) {.importc: "wlr_presentation_feedback_destroy".}
proc from_output*(event: ptr WlrPresentation_event; output_event: ptr WlrOutputEventPresent) {.importc: "wlr_presentation_event_from_output".}
proc surface_sampled_on_output*(presentation: ptr WlrPresentation; surface: ptr WlrSurface; output: ptr WlrOutput) {.importc: "wlr_presentation_surface_sampled_on_output".}

## wlr_primary_selection

proc init*(source: ptr WlrPrimarySelectionSource; impl: ptr WlrPrimarySelectionSource_impl) {.importc: "wlr_primary_selection_source_init".}
proc destroy*(source: ptr WlrPrimarySelectionSource) {.importc: "wlr_primary_selection_source_destroy".}
proc send*(source: ptr WlrPrimarySelectionSource; mime_type: cstring; fd: cint) {.importc: "wlr_primary_selection_source_send".}

proc request_set_primary_selection*(seat: ptr WlrSeat; client: ptr WlrSeatClient; source: ptr WlrPrimarySelectionSource; serial: uint32) {.importc: "wlr_seat_request_set_primary_selection".}
proc set_primary_selection*(seat: ptr WlrSeat; source: ptr WlrPrimarySelectionSource; serial: uint32) {.importc: "wlr_seat_set_primary_selection".}

## wlr_primary_selection_v1

proc create_wlr_primary_selection_v1_device_manager*(display: ptr WlDisplay): ptr WlrPrimarySelection_v1_device_manager {.importc: "wlr_primary_selection_v1_device_manager_create".}

## wlr_region

proc wlr_region_from_resource*(resource: ptr WlResource): ptr PixmanRegion32 {.importc: "wlr_region_from_resource".}

## wlr_relative_pointer_v1

proc create_wlr_relative_pointer_manager_v1*(display: ptr WlDisplay): ptr WlrRelativePointerManager_v1 {.importc: "wlr_relative_pointer_manager_v1_create".}
proc send_relative_motion*(manager: ptr WlrRelativePointerManager_v1; seat: ptr WlrSeat; time_usec: uint64; dx, dy: cdouble; dx_unaccel, dy_unaccel: cdouble) {.importc: "wlr_relative_pointer_manager_v1_send_relative_motion".}
proc wlr_relative_pointer_v1_from_resource*(resource: ptr WlResource): ptr WlrRelativePointer_v1 {.importc: "wlr_relative_pointer_v1_from_resource".}

## wlr_screencopy_v1

proc create_wlr_screencopy_manager_v1*(display: ptr WlDisplay): ptr WlrScreencopyManager_v1 {.importc: "wlr_screencopy_manager_v1_create".}

## wlr_seat

proc create_wlr_seat*(display: ptr WlDisplay; name: cstring): ptr WlrSeat {.importc: "wlr_seat_create".}
proc destroy*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_destroy".}
proc client_for_wl_client*(wlr_seat: ptr WlrSeat; WlClient: ptr WlClient): ptr WlrSeatClient {.importc: "wlr_seat_client_for_wl_client".}
proc set_capabilities*(wlr_seat: ptr WlrSeat; capabilities: uint32) {.importc: "wlr_seat_set_capabilities".}
proc set_name*(wlr_seat: ptr WlrSeat; name: cstring) {.importc: "wlr_seat_set_name".}

proc pointer_surface_has_focus*(wlr_seat: ptr WlrSeat; surface: ptr WlrSurface): bool {.importc: "wlr_seat_pointer_surface_has_focus".}
proc pointer_enter*(wlr_seat: ptr WlrSeat; surface: ptr WlrSurface; sx, sy: cdouble) {.importc: "wlr_seat_pointer_enter".}
proc pointer_clear_focus*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_clear_focus".}
proc pointer_send_motion*(wlr_seat: ptr WlrSeat; time_msec: uint32; sx, sy: cdouble) {.importc: "wlr_seat_pointer_send_motion".}
proc pointer_send_button*(wlr_seat: ptr WlrSeat; time_msec: uint32; button: uint32; state: WlrButton_state): uint32 {.importc: "wlr_seat_pointer_send_button".}
proc pointer_send_axis*(wlr_seat: ptr WlrSeat; time_msec: uint32; orientation: WlrAxisOrientation; value: cdouble; value_discrete: int32; source: WlrAxisSource) {.importc: "wlr_seat_pointer_send_axis".}
proc pointer_send_frame*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_send_frame".}
proc pointer_notify_enter*(wlr_seat: ptr WlrSeat; surface: ptr WlrSurface; sx, sy: cdouble) {.importc: "wlr_seat_pointer_notify_enter".}
proc pointer_notify_clear_focus*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_notify_clear_focus".}
proc pointer_warp*(wlr_seat: ptr WlrSeat; sx, sy: cdouble) {.importc: "wlr_seat_pointer_warp".}
proc pointer_notify_motion*(wlr_seat: ptr WlrSeat; time_msec: uint32; sx, sy: cdouble) {.importc: "wlr_seat_pointer_notify_motion".}
proc pointer_notify_button*(wlr_seat: ptr WlrSeat; time_msec: uint32; button: uint32; state: WlrButton_state): uint32 {.importc: "wlr_seat_pointer_notify_button".}
proc pointer_notify_axis*(wlr_seat: ptr WlrSeat; time_msec: uint32; orientation: WlrAxisOrientation; value: cdouble; value_discrete: int32; source: WlrAxisSource) {.importc: "wlr_seat_pointer_notify_axis".}
proc pointer_notify_frame*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_notify_frame".}
proc pointer_start_grab*(wlr_seat: ptr WlrSeat; grab: ptr WlrSeatPointerGrab) {.importc: "wlr_seat_pointer_start_grab".}
proc pointer_end_grab*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_pointer_end_grab".}
proc pointer_has_grab*(seat: ptr WlrSeat): bool {.importc: "wlr_seat_pointer_has_grab".}

proc set_keyboard*(seat: ptr WlrSeat; dev: ptr WlrInputDevice) {.importc: "wlr_seat_set_keyboard".}
proc get_keyboard*(seat: ptr WlrSeat): ptr WlrKeyboard {.importc: "wlr_seat_get_keyboard".}
proc keyboard_send_key*(seat: ptr WlrSeat; time_msec: uint32; key: uint32; state: uint32) {.importc: "wlr_seat_keyboard_send_key".}
proc keyboard_send_modifiers*(seat: ptr WlrSeat; modifiers: ptr WlrKeyboardModifiers) {.importc: "wlr_seat_keyboard_send_modifiers".}
proc keyboard_enter*(seat: ptr WlrSeat; surface: ptr WlrSurface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr WlrKeyboardModifiers) {.importc: "wlr_seat_keyboard_enter".}
proc keyboard_clear_focus*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_keyboard_clear_focus".}
proc keyboard_notify_key*(seat: ptr WlrSeat; time_msec: uint32; key: uint32; state: uint32) {.importc: "wlr_seat_keyboard_notify_key".}
proc keyboard_notify_modifiers*(seat: ptr WlrSeat; modifiers: ptr WlrKeyboardModifiers) {.importc: "wlr_seat_keyboard_notify_modifiers".}
proc keyboard_notify_enter*(seat: ptr WlrSeat; surface: ptr WlrSurface; keycodes: ptr uint32; num_keycodes: csize_t; modifiers: ptr WlrKeyboardModifiers) {.importc: "wlr_seat_keyboard_notify_enter".}
proc keyboard_notify_clear_focus*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_keyboard_notify_clear_focus".}
proc keyboard_start_grab*(wlr_seat: ptr WlrSeat; grab: ptr WlrSeatKeyboardGrab) {.importc: "wlr_seat_keyboard_start_grab".}
proc keyboard_end_grab*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_keyboard_end_grab".}
proc keyboard_has_grab*(seat: ptr WlrSeat): bool {.importc: "wlr_seat_keyboard_has_grab".}

proc touch_get_point*(seat: ptr WlrSeat; touch_id: int32): ptr WlrTouchPoint {.importc: "wlr_seat_touch_get_point".}
proc touch_point_focus*(seat: ptr WlrSeat; surface: ptr WlrSurface; time_msec: uint32; touch_id: int32; sx, sy: cdouble) {.importc: "wlr_seat_touch_point_focus".}
proc touch_point_clear_focus*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32) {.importc: "wlr_seat_touch_point_clear_focus".}
proc touch_send_down*(seat: ptr WlrSeat; surface: ptr WlrSurface; time_msec: uint32; touch_id: int32; sx, sy: cdouble): uint32 {.importc: "wlr_seat_touch_send_down".}
proc touch_send_up*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32) {.importc: "wlr_seat_touch_send_up".}
proc touch_send_motion*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32; sx, sy: cdouble) {.importc: "wlr_seat_touch_send_motion".}
proc touch_notify_down*(seat: ptr WlrSeat; surface: ptr WlrSurface; time_msec: uint32; touch_id: int32; sx, sy: cdouble): uint32 {.importc: "wlr_seat_touch_notify_down".}
proc touch_notify_up*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32) {.importc: "wlr_seat_touch_notify_up".}
proc touch_notify_motion*(seat: ptr WlrSeat; time_msec: uint32; touch_id: int32; sx, sy: cdouble) {.importc: "wlr_seat_touch_notify_motion".}
proc touch_num_points*(seat: ptr WlrSeat): cint {.importc: "wlr_seat_touch_num_points".}
proc touch_start_grab*(wlr_seat: ptr WlrSeat; grab: ptr WlrSeatTouchGrab) {.importc: "wlr_seat_touch_start_grab".}
proc touch_end_grab*(wlr_seat: ptr WlrSeat) {.importc: "wlr_seat_touch_end_grab".}
proc touch_has_grab*(seat: ptr WlrSeat): bool {.importc: "wlr_seat_touch_has_grab".}

proc validate_grab_serial*(seat: ptr WlrSeat; serial: uint32): bool {.importc: "wlr_seat_validate_grab_serial".}
proc validate_pointer_grab_serial*(seat: ptr WlrSeat; origin: ptr WlrSurface; serial: uint32): bool {.importc: "wlr_seat_validate_pointer_grab_serial".}
proc validate_touch_grab_serial*(seat: ptr WlrSeat; origin: ptr WlrSurface; serial: uint32; point_ptr: ptr ptr WlrTouchPoint): bool {.importc: "wlr_seat_validate_touch_grab_serial".}
proc next_serial*(client: ptr WlrSeatClient): uint32 {.importc: "wlr_seat_client_next_serial".}
proc validate_event_serial*(client: ptr WlrSeatClient; serial: uint32): bool {.importc: "wlr_seat_client_validate_event_serial".}
proc wlr_seat_client_from_resource*(resource: ptr WlResource): ptr WlrSeatClient {.importc: "wlr_seat_client_from_resource".}
proc wlr_seat_client_from_pointer_resource*(resource: ptr WlResource): ptr WlrSeatClient {.importc: "wlr_seat_client_from_pointer_resource".}
proc accepts_touch*(wlr_seat: ptr WlrSeat; surface: ptr WlrSurface): bool {.importc: "wlr_surface_accepts_touch".}

## wlr_server_decoration

proc create_wlr_server_decoration_manager*(display: ptr WlDisplay): ptr WlrServerDecorationManager {.importc: "wlr_server_decoration_manager_create".}
proc set_default_mode*(manager: ptr WlrServerDecorationManager; default_mode: uint32) {.importc: "wlr_server_decoration_manager_set_default_mode".}

## wlr_surface

proc set_role*(surface: ptr WlrSurface; role: ptr WlrSurfaceRole; role_data: pointer; error_resource: ptr WlResource; error_code: uint32): bool {.importc: "wlr_surface_set_role".}
proc has_buffer*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_has_buffer".}
proc get_texture*(surface: ptr WlrSurface): ptr WlrTexture {.importc: "wlr_surface_get_texture".}
proc create_wlr_subsurface*(surface: ptr WlrSurface; parent: ptr WlrSurface; version: uint32; id: uint32; resource_list: ptr WlList): ptr WlrSubsurface {.importc: "wlr_subsurface_create".}
proc get_root_surface*(surface: ptr WlrSurface): ptr WlrSurface {.importc: "wlr_surface_get_root_surface".}
proc point_accepts_input*(surface: ptr WlrSurface; sx, sy: cdouble): bool {.importc: "wlr_surface_point_accepts_input".}
proc surface_at*(surface: ptr WlrSurface; sx, sy: cdouble; sub_x, sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_surface_surface_at".}
proc send_enter*(surface: ptr WlrSurface; output: ptr WlrOutput) {.importc: "wlr_surface_send_enter".}
proc send_leave*(surface: ptr WlrSurface; output: ptr WlrOutput) {.importc: "wlr_surface_send_leave".}
proc send_frame_done*(surface: ptr WlrSurface; `when`: ptr Timespec) {.importc: "wlr_surface_send_frame_done".}
proc get_extends*(surface: ptr WlrSurface; box: ptr WlrBox) {.importc: "wlr_surface_get_extends".}
proc from_resource*(resource: ptr WlResource): ptr WlrSurface {.importc: "wlr_surface_from_resource".}
proc for_each_surface*(surface: ptr WlrSurface; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_surface_for_each_surface".}
proc get_effective_damage*(surface: ptr WlrSurface; damage: ptr PixmanRegion32) {.importc: "wlr_surface_get_effective_damage".}
proc get_buffer_source_box*(surface: ptr WlrSurface; box: ptr WlrFbox) {.importc: "wlr_surface_get_buffer_source_box".}
proc lock_pending*(surface: ptr WlrSurface): uint32 {.importc: "wlr_surface_lock_pending".}
proc unlock_cached*(surface: ptr WlrSurface; seq: uint32) {.importc: "wlr_surface_unlock_cached".}

## wlr_switch

## wlr_tablet_pad

## wlr_tablet_tool

## wlr_tablet_v2

proc create_wlr_tablet*(manager: ptr WlrTabletManager_v2; wlr_seat: ptr WlrSeat; wlr_device: ptr WlrInputDevice): ptr WlrTablet_v2_tablet {.importc: "wlr_tablet_create".}
proc create_wlr_tablet_pad*(manager: ptr WlrTabletManager_v2; wlr_seat: ptr WlrSeat; wlr_device: ptr WlrInputDevice): ptr WlrTablet_v2_tablet_pad {.importc: "wlr_tablet_pad_create".}
proc create_wlr_tablet_tool*(manager: ptr WlrTabletManager_v2; wlr_seat: ptr WlrSeat; wlr_tool: ptr WlrTabletTool): ptr WlrTablet_v2_tablet_tool {.importc: "wlr_tablet_tool_create".}
proc create_wlr_tablet_v2*(display: ptr WlDisplay): ptr WlrTabletManager_v2 {.importc: "wlr_tablet_v2_create".}

proc proximity_in*(tool: ptr WlrTablet_v2_tablet_tool; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface) {.importc: "wlr_send_tablet_v2_tablet_tool_proximity_in".}
proc down*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_down".}
proc up*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_up".}
proc motion*(tool: ptr WlrTablet_v2_tablet_tool; x, y: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_motion".}
proc pressure*(tool: ptr WlrTablet_v2_tablet_tool; pressure: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_pressure".}
proc distance*(tool: ptr WlrTablet_v2_tablet_tool; distance: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_distance".}
proc tilt*(tool: ptr WlrTablet_v2_tablet_tool; x, y: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_tilt".}
proc rotation*(tool: ptr WlrTablet_v2_tablet_tool; degrees: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_rotation".}
proc slider*(tool: ptr WlrTablet_v2_tablet_tool; position: cdouble) {.importc: "wlr_send_tablet_v2_tablet_tool_slider".}
proc wheel*(tool: ptr WlrTablet_v2_tablet_tool; degrees: cdouble; clicks: int32) {.importc: "wlr_send_tablet_v2_tablet_tool_wheel".}
proc proximity_out*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_send_tablet_v2_tablet_tool_proximity_out".}
proc button*(tool: ptr WlrTablet_v2_tablet_tool; button: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_send_tablet_v2_tablet_tool_button".}

proc notify_proximity_in*(tool: ptr WlrTablet_v2_tablet_tool; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface) {.importc: "wlr_tablet_v2_tablet_tool_notify_proximity_in".}
proc notify_down*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_down".}
proc notify_up*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_up".}
proc notify_motion*(tool: ptr WlrTablet_v2_tablet_tool; x, y: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_motion".}
proc notify_pressure*(tool: ptr WlrTablet_v2_tablet_tool; pressure: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_pressure".}
proc notify_distance*(tool: ptr WlrTablet_v2_tablet_tool; distance: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_distance".}
proc notify_tilt*(tool: ptr WlrTablet_v2_tablet_tool; x, y: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_tilt".}
proc notify_rotation*(tool: ptr WlrTablet_v2_tablet_tool; degrees: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_rotation".}
proc notify_slider*(tool: ptr WlrTablet_v2_tablet_tool; position: cdouble) {.importc: "wlr_tablet_v2_tablet_tool_notify_slider".}
proc notify_wheel*(tool: ptr WlrTablet_v2_tablet_tool; degrees: cdouble; clicks: int32) {.importc: "wlr_tablet_v2_tablet_tool_notify_wheel".}
proc notify_proximity_out*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_v2_tablet_tool_notify_proximity_out".}
proc notify_button*(tool: ptr WlrTablet_v2_tablet_tool; button: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_tablet_v2_tablet_tool_notify_button".}

proc start_grab*(tool: ptr WlrTablet_v2_tablet_tool; grab: ptr WlrTabletTool_v2_grab) {.importc: "wlr_tablet_tool_v2_start_grab".}
proc end_grab*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_tool_v2_end_grab".}
proc start_implicit_grab*(tool: ptr WlrTablet_v2_tablet_tool) {.importc: "wlr_tablet_tool_v2_start_implicit_grab".}
proc has_implicit_grab*(tool: ptr WlrTablet_v2_tablet_tool): bool {.importc: "wlr_tablet_tool_v2_has_implicit_grab".}

proc enter*(pad: ptr WlrTablet_v2_tablet_pad; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface): uint32 {.importc: "wlr_send_tablet_v2_tablet_pad_enter".}
proc button*(pad: ptr WlrTablet_v2_tablet_pad; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_send_tablet_v2_tablet_pad_button".}
proc strip*(pad: ptr WlrTablet_v2_tablet_pad; strip: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_send_tablet_v2_tablet_pad_strip".}
proc ring*(pad: ptr WlrTablet_v2_tablet_pad; ring: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_send_tablet_v2_tablet_pad_ring".}
proc leave*(pad: ptr WlrTablet_v2_tablet_pad; surface: ptr WlrSurface): uint32 {.importc: "wlr_send_tablet_v2_tablet_pad_leave".}
proc mode*(pad: ptr WlrTablet_v2_tablet_pad; group: csize_t; mode: uint32; time: uint32): uint32 {.importc: "wlr_send_tablet_v2_tablet_pad_mode".}

proc notify_enter*(pad: ptr WlrTablet_v2_tablet_pad; tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface): uint32 {.importc: "wlr_tablet_v2_tablet_pad_notify_enter".}
proc notify_button*(pad: ptr WlrTablet_v2_tablet_pad; button: csize_t; time: uint32; state: zwp_tablet_pad_v2_button_state) {.importc: "wlr_tablet_v2_tablet_pad_notify_button".}
proc notify_strip*(pad: ptr WlrTablet_v2_tablet_pad; strip: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_tablet_v2_tablet_pad_notify_strip".}
proc notify_ring*(pad: ptr WlrTablet_v2_tablet_pad; ring: uint32; position: cdouble; finger: bool; time: uint32) {.importc: "wlr_tablet_v2_tablet_pad_notify_ring".}
proc notify_leave*(pad: ptr WlrTablet_v2_tablet_pad; surface: ptr WlrSurface): uint32 {.importc: "wlr_tablet_v2_tablet_pad_notify_leave".}
proc notify_mode*(pad: ptr WlrTablet_v2_tablet_pad; group: csize_t; mode: uint32; time: uint32): uint32 {.importc: "wlr_tablet_v2_tablet_pad_notify_mode".}

proc end_grab*(pad: ptr WlrTablet_v2_tablet_pad) {.importc: "wlr_tablet_v2_end_grab".}
proc start_grab*(pad: ptr WlrTablet_v2_tablet_pad; grab: ptr WlrTabletPad_v2_grab) {.importc: "wlr_tablet_v2_start_grab".}
proc accepts*(tablet: ptr WlrTablet_v2_tablet; surface: ptr WlrSurface): bool {.importc: "wlr_surface_accepts_tablet_v2".}

## wlr_text_input_v3

proc create_wlr_text_input_manager_v3*(wl_display: ptr WlDisplay): ptr WlrTextInputManager_v3 {.importc: "wlr_text_input_manager_v3_create".}
proc send_enter*(text_input: ptr WlrTextInput_v3; wlr_surface: ptr WlrSurface) {.importc: "wlr_text_input_v3_send_enter".}
proc send_leave*(text_input: ptr WlrTextInput_v3) {.importc: "wlr_text_input_v3_send_leave".}
proc send_preedit_string*(text_input: ptr WlrTextInput_v3; text: cstring; cursor_begin: uint32; cursor_end: uint32) {.importc: "wlr_text_input_v3_send_preedit_string".}
proc send_commit_string*(text_input: ptr WlrTextInput_v3; text: cstring) {.importc: "wlr_text_input_v3_send_commit_string".}
proc send_delete_surrounding_text*(text_input: ptr WlrTextInput_v3; before_length: uint32; after_length: uint32) {.importc: "wlr_text_input_v3_send_delete_surrounding_text".}
proc send_done*(text_input: ptr WlrTextInput_v3) {.importc: "wlr_text_input_v3_send_done".}

## wlr_touch

## wlr_viewporter

proc create_wlr_viewporter*(display: ptr WlDisplay): ptr WlrViewporter {.importc: "wlr_viewporter_create".}

## wlr_virtual_keyboard_v1

proc create_wlr_virtual_keyboard_manager_v1*(display: ptr WlDisplay): ptr WlrVirtualKeyboardManager_v1 {.importc: "wlr_virtual_keyboard_manager_v1_create".}
proc get_virtual_keyboard*(wlr_dev: ptr WlrInputDevice): ptr WlrVirtualKeyboard_v1 {.importc: "wlr_input_device_get_virtual_keyboard".}

## wlr_virtual_pointer_v1

proc create_wlr_virtual_pointer_manager_v1*(display: ptr WlDisplay): ptr WlrVirtualPointerManager_v1 {.importc: "wlr_virtual_pointer_manager_v1_create".}

## wlr_xcursor_manager

proc create_wlr_xcursor_manager*(name: cstring; size: uint32): ptr WlrXcursorManager {.importc: "wlr_xcursor_manager_create".}
proc destroy*(manager: ptr WlrXcursorManager) {.importc: "wlr_xcursor_manager_destroy".}
proc load*(manager: ptr WlrXcursorManager; scale: cfloat): bool {.importc: "wlr_xcursor_manager_load".}
proc get_xcursor*(manager: ptr WlrXcursorManager; name: cstring; scale: cfloat): ptr WlrXcursor {.importc: "wlr_xcursor_manager_get_xcursor".}
proc set_cursor_image*(manager: ptr WlrXcursorManager; name: cstring; cursor: ptr WlrCursor) {.importc: "wlr_xcursor_manager_set_cursor_image".}

## wlr_xdg_activation_v1

proc create_wlr_xdg_activation_v1*(display: ptr WlDisplay): ptr WlrXdgActivation_v1 {.importc: "wlr_xdg_activation_v1_create".}

## wlr_xdg_decoration_v1

proc create_wlr_xdg_decoration_manager_v1*(display: ptr WlDisplay): ptr WlrXdgDecorationManager_v1 {.importc: "wlr_xdg_decoration_manager_v1_create".}
proc set_mode*(decoration: ptr WlrXdgToplevelDecoration_v1; mode: WlrXdgToplevelDecoration_v1_mode): uint32 {.importc: "wlr_xdg_toplevel_decoration_v1_set_mode".}

## wlr_xdg_foreign_registry

proc create_wlr_xdg_foreign_registry*(display: ptr WlDisplay): ptr WlrXdgForeignRegistry {.importc: "wlr_xdg_foreign_registry_create".}
proc init*(surface: ptr WlrXdgForeignExported; registry: ptr WlrXdgForeignRegistry): bool {.importc: "wlr_xdg_foreign_exported_init".}
proc find_by_handle*(registry: ptr WlrXdgForeignRegistry; handle: cstring): ptr WlrXdgForeignExported {.importc: "wlr_xdg_foreign_registry_find_by_handle".}
proc finish*(surface: ptr WlrXdgForeignExported) {.importc: "wlr_xdg_foreign_exported_finish".}

## wlr_xdg_foreign_v1

proc create_wlr_xdg_foreign_v1*(display: ptr WlDisplay; registry: ptr WlrXdgForeignRegistry): ptr WlrXdgForeign_v1 {.importc: "wlr_xdg_foreign_v1_create".}

## wlr_xdg_foreign_v2

proc create_wlr_xdg_foreign_v2*(display: ptr WlDisplay; registry: ptr WlrXdgForeignRegistry): ptr WlrXdgForeign_v2 {.importc: "wlr_xdg_foreign_v2_create".}

## wlr_xdg_output_v1

proc create_wlr_xdg_output_manager_v1*(display: ptr WlDisplay; layout: ptr WlrOutputLayout): ptr WlrXdgOutputManager_v1 {.importc: "wlr_xdg_output_manager_v1_create".}

## wlr_xdg_shell

proc create_wlr_xdg_shell*(display: ptr WlDisplay): ptr WlrXdgShell {.importc: "wlr_xdg_shell_create".}

proc wlr_xdg_surface_from_resource*(resource: ptr WlResource): ptr WlrXdgSurface {.importc: "wlr_xdg_surface_from_resource".}
proc wlr_xdg_surface_from_popup_resource*(resource: ptr WlResource): ptr WlrXdgSurface {.importc: "wlr_xdg_surface_from_popup_resource".}
proc wlr_xdg_surface_from_toplevel_resource*(resource: ptr WlResource): ptr WlrXdgSurface {.importc: "wlr_xdg_surface_from_toplevel_resource".}

proc ping*(surface: ptr WlrXdgSurface) {.importc: "wlr_xdg_surface_ping".}
proc toplevel_set_size*(surface: ptr WlrXdgSurface; width, height: uint32): uint32 {.importc: "wlr_xdg_toplevel_set_size".}
proc toplevel_set_activated*(surface: ptr WlrXdgSurface; activated: bool): uint32 {.importc: "wlr_xdg_toplevel_set_activated".}
proc toplevel_set_maximized*(surface: ptr WlrXdgSurface; maximized: bool): uint32 {.importc: "wlr_xdg_toplevel_set_maximized".}
proc toplevel_set_fullscreen*(surface: ptr WlrXdgSurface; fullscreen: bool): uint32 {.importc: "wlr_xdg_toplevel_set_fullscreen".}
proc toplevel_set_resizing*(surface: ptr WlrXdgSurface; resizing: bool): uint32 {.importc: "wlr_xdg_toplevel_set_resizing".}
proc toplevel_set_tiled*(surface: ptr WlrXdgSurface; tiled_edges: uint32): uint32 {.importc: "wlr_xdg_toplevel_set_tiled".}
proc toplevel_send_close*(surface: ptr WlrXdgSurface) {.importc: "wlr_xdg_toplevel_send_close".}
proc toplevel_set_parent*(surface: ptr WlrXdgSurface; parent: ptr WlrXdgSurface) {.importc: "wlr_xdg_toplevel_set_parent".}

proc destroy*(surface: ptr WlrXdgSurface) {.importc: "wlr_xdg_popup_destroy".}
proc get_position*(popup: ptr WlrXdgPopup; popup_sx, popup_sy: ptr cdouble) {.importc: "wlr_xdg_popup_get_position".}
proc get_geometry*(positioner: ptr WlrXdgPositioner): WlrBox {.importc: "wlr_xdg_positioner_get_geometry".}
proc get_anchor_point*(popup: ptr WlrXdgPopup; toplevel_sx, toplevel_sy: ptr cint) {.importc: "wlr_xdg_popup_get_anchor_point".}
proc get_toplevel_coords*(popup: ptr WlrXdgPopup; popup_sx, popup_sy: cint; toplevel_sx, toplevel_sy: ptr cint) {.importc: "wlr_xdg_popup_get_toplevel_coords".}

proc unconstrain_from_box*(popup: ptr WlrXdgPopup; toplevel_sx_box: ptr WlrBox) {.importc: "wlr_xdg_popup_unconstrain_from_box".}
proc invert_x*(positioner: ptr WlrXdgPositioner) {.importc: "wlr_positioner_invert_x".}
proc invert_y*(positioner: ptr WlrXdgPositioner) {.importc: "wlr_positioner_invert_y".}
proc surface_at*(surface: ptr WlrXdgSurface; sx, sy: cdouble; sub_x, sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_xdg_surface_surface_at".}
proc popup_surface_at*(surface: ptr WlrXdgSurface; sx, sy: cdouble; sub_x, sub_y: ptr cdouble): ptr WlrSurface {.importc: "wlr_xdg_surface_popup_surface_at".}
proc is_xdg_surface*(surface: ptr WlrSurface): bool {.importc: "wlr_surface_is_xdg_surface".}
proc wlr_xdg_surface_from_wlr_surface*(surface: ptr WlrSurface): ptr WlrXdgSurface {.importc: "wlr_xdg_surface_from_wlr_surface".}
proc get_geometry*(surface: ptr WlrXdgSurface; box: ptr WlrBox) {.importc: "wlr_xdg_surface_get_geometry".}
proc for_each_surface*(surface: ptr WlrXdgSurface; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_xdg_surface_for_each_surface".}
proc for_each_popup_surface*(surface: ptr WlrXdgSurface; `iterator`: WlrSurfaceIteratorFunc_t; user_data: pointer) {.importc: "wlr_xdg_surface_for_each_popup_surface".}
proc schedule_configure*(surface: ptr WlrXdgSurface): uint32 {.importc: "wlr_xdg_surface_schedule_configure".}
