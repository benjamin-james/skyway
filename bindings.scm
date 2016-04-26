(define-module (skyway bindings)
  #:use-module (system foreign)
  #:use-module (skyway config))

(define wlc-func
  (let ((lib (dynamic-link %libwlc)))
    (lambda (return-type function-name arg-types)
      "Return a procedure for the foreign function with function-name in the WLC library. That function returns the type return-type and has parameters arg-types."
      (pointer->procedure return-type
			  (dynamic-func function-name lib)
			  arg-types))))

(define-syntax-rule (define-foreign name return-type func-name arg-types)
  (define-public name
    (wlc-func return-type func-name arg-types)))

(define-public bool int)
(define-public wlc_handle long)

(define-public wlc_size (list uint32 uint32))
(define-public (wlc_size->w s)
  (car (parse-c-struct s wlc_size)))
(define-public (wlc-size->h s)
  (cadr (parse-c-struct s wlc_size)))
(define-public wlc_point (list int32 int32))
(define-public (wlc_point->x p)
  (car (parse-c-struct p wlc_point)))
(define-public (wlc_point->y p)
  (cadr (parse-c-struct p wlc_point)))
(define-public wlc_geometry (list wlc_point wlc_size))
(define-public (wlc_geometry->origin g)
  (car (parse-c-struct g wlc_geometry)))
(define-public (wlc_geometry->size g)
  (cadr (parse-c-struct g wlc_geometry)))

(define-public *wlc-origin-zero*
  (make-c-struct wlc_point (list 0 0)))
(define-public *wlc-point-zero* *wlc-origin-zero*)

;;; Core API
(define-foreign wlc-log-set-handler
  void "wlc_log_set_handler" '(*))

(define-foreign wlc-init
  bool "wlc_init" '())

(define-foreign wlc-terminate
  void "wlc_terminate" '())

(define-foreign wlc-exec
  void "wlc_exec" '(* *))

(define-foreign wlc-run
  void "wlc_run" '())

(define-foreign wlc-handle-set-user-data
  void "wlc_handle_set_user_data" (list wlc_handle '*))

(define-foreign wlc-handle-get-user-data
  '* "wlc_handle_get_user_data" (list wlc_handle))

(define-foreign wlc-event-loop-add-fd
  '* "wlc_event_loop_add_fd" (list int uint32 '* '*))

(define-foreign wlc-event-loop-add-timer
  '* "wlc_event_loop_add_timer" '(* *))

(define-foreign wlc-event-source-timer-update
  bool "wlc_event_source_timer_update" (list '* int32))

(define-foreign wlc-event-source-remove
  void "wlc_event_source_remove" '(*))

;;; Output API
(define-foreign wlc-get-outputs
  '* "wlc_get_outputs" '(*))

(define-foreign wlc-get-focused-output
  wlc_handle "wlc_get_focused_output" '())

(define-foreign wlc-output-get-name
  '* "wlc_output_get_name" (list wlc_handle))

(define-foreign wlc-output-get-sleep
  bool "wlc_output_get_sleep" (list wlc_handle))

(define-foreign wlc-output-set-sleep
  void "wlc_output_set_sleep" (list wlc_handle bool))

(define-foreign wlc-output-get-resolution
  '* "wlc_output_get_resolution" (list wlc_handle))

(define-foreign wlc-output-set-resolution
  void "wlc_output_set_resolution" (list wlc_handle '*))

(define-foreign wlc-output-get-mask
  uint32 "wlc_output_get_mask" (list wlc_handle))

(define-foreign wlc-output-set-mask
  void "wlc_output_set_mask" (list wlc_handle uint32))

(define-foreign wlc-output-get-views
  '* "wlc_output_get_views" (list wlc_handle '*))

(define-foreign wlc-output-get-mutable-views
  '* "wlc_output_get_mutable_views" (list wlc_handle '*))

(define-foreign wlc-output-set-views
  bool "wlc_output_set_views" (list wlc_handle '* size_t))

(define-foreign wlc-output-focus
  void "wlc_output_focus" (list wlc_handle))

(define-foreign wlc-view-focus
  void "wlc_view_focus" (list wlc_handle))

(define-foreign wlc-view-close
  void "wlc_view_close" (list wlc_handle))

(define-foreign wlc-view-get-output
  wlc_handle "wlc_view_get_output" (list wlc_handle))

(define-foreign wlc-view-set-output
  void "wlc_view_set_output" (list wlc_handle wlc_handle))

(define-foreign wlc-view-send-to-back
  void "wlc_view_send_to_back" (list wlc_handle))

(define-foreign wlc-view-send-below
  void "wlc_view_send_below" (list wlc_handle wlc_handle))

(define-foreign wlc-view-bring-above
  void "wlc_view_bring_above" (list wlc_handle wlc_handle))

(define-foreign wlc-view-bring-to-front
  void "wlc_view_bring_to_front" (list wlc_handle))

(define-foreign wlc-view-set-mask
  void "wlc_view_set_mask" (list wlc_handle uint32))

(define-foreign wlc-view-get-geometry
  '* "wlc_view_get_geometry" (list wlc_handle))

(define-foreign wlc-view-get-visible-geometry
  void "wlc_view_get_visible_geometry" (list wlc_handle '*))

(define-foreign wlc-view-set-geometry
  void "wlc_view_set_geometry" (list wlc_handle uint32 '*))

(define-foreign wlc-view-get-type
  uint32 "wlc_view_get_type" (list wlc_handle))

(define-foreign wlc-view-set-type
  void "wlc_view_set_type" (list wlc_handle int bool))

(define-foreign wlc-view-get-state
  uint32 "wlc_view_get_state" (list wlc_handle))

(define-foreign wlc-view-set-state
  void "wlc_view_set_state" (list wlc_handle int bool))

(define-foreign wlc-view-get-parent
  wlc_handle "wlc_view_get_parent" (list wlc_handle))

(define-foreign wlc-view-set-parent
  void "wlc_view_set_parent" (list wlc_handle wlc_handle))

(define-foreign wlc-view-get-title
  '* "wlc_view_get_title" (list wlc_handle))

(define-foreign wlc-view-get-class
  '* "wlc_view_get_class" (list wlc_handle))

(define-foreign wlc-view-get-app-id
  '* "wlc_view_get_app_id" (list wlc_handle))

;;; Input API
(define-foreign wlc-keyboard-get-xkb-state
  '* "wlc_keyboard_get_xkb_state" '())

(define-foreign wlc-keyboard-get-xkb-keymap
  '* "wlc_keyboard_get_xkb_keymap" '())

(define-foreign wlc-keyboard-get-current-keys
  '* "wlc_keyboard_get_current_keys" '(*))

(define-foreign wlc-keyboard-get-keysym-for-key
  uint32 "wlc_keyboard_get_keysym_for_key" (list uint32 '*))

(define-foreign wlc-keyboard-get-utf32-for-key
  uint32 "wlc_keyboard_get_utf32_for_key" (list uint32 '*))

(define-foreign wlc-pointer-get-position
  void "wlc_pointer_get_position" '(*))

(define-foreign wlc-pointer-set-position
  void "wlc_pointer_set_position" '(*))

;;; Callback API
(define-foreign wlc-set-output-created-cb
  void "wlc_set_output_created_cb" '(*))

(define-foreign wlc-set-output-destroyed-cb
  void "wlc_set_output_destroyed_cb" '(*))

(define-foreign wlc-set-output-resolution-cb
  void "wlc_set_output_resolution_cb" '(*))

(define-foreign wlc-set-output-focus-cb
  void "wlc_set_output_focus_cb" '(*))

(define-foreign wlc-set-output-render-pre-cb
  void "wlc_set_output_render_pre_cb" '(*))

(define-foreign wlc-set-output-render-post-cb
  void "wlc_set_output_render_post_cb" '(*))

(define-foreign wlc-set-output-context-created-cb
  void "wlc_set_output_context_created_cb" '(*))

(define-foreign wlc-set-output-context-destroyed-cb
  void "wlc_set_output_context_destroyed_cb" '(*))

(define-foreign wlc-set-view-created-cb
  void "wlc_set_view_created_cb" '(*))

(define-foreign wlc-set-view-destroyed-cb
  void "wlc_set_view_destroyed_cb" '(*))

(define-foreign wlc-set-view-focus-cb
  void "wlc_set_view_focus_cb" '(*))

(define-foreign wlc-set-view-move-to-output-cb
  void "wlc_set_view_move_to_output_cb" '(*))

(define-foreign wlc-set-view-request-geometry-cb
  void "wlc_set_view_request_geometry_cb" '(*))

(define-foreign wlc-set-view-request-state-cb
  void "wlc_set_view_request_state_cb" '(*))

(define-foreign wlc-set-view-request-move-cb
  void "wlc_set_view_request_move_cb" '(*))

(define-foreign wlc-set-view-request-resize-cb
  void "wlc_set_view_request_resize_cb" '(*))

(define-foreign wlc-set-view-render-pre-cb
  void "wlc_set_view_render_pre_cb" '(*))

(define-foreign wlc-set-view-render-post-cb
  void "wlc_set_view_render_post_cb" '(*))

(define-foreign wlc-set-keyboard-key-cb
  void "wlc_set_keyboard_key_cb" '(*))

(define-foreign wlc-set-pointer-motion-cb
  void "wlc_set_pointer_motion_cb" '(*))

(define-foreign wlc-set-pointer-button-cb
  void "wlc_set_pointer_button_cb" '(*))

(define-foreign wlc-set-pointer-scroll-cb
  void "wlc_set_pointer_scroll_cb" '(*))

(define-foreign wlc-set-touch-cb
  void "wlc_set_touch_cb" '(*))

(define-foreign wlc-set-compositor-ready-cb
  void "wlc_set_compositor_ready_cb" '(*))

(define-foreign wlc-set-compositor-terminate-cb
  void "wlc_set_compositor_terminate_cb" '(*))

(define-foreign wlc-set-input-created-cb
  void "wlc_set_input_created_cb" '(*))

(define-foreign wlc-set-input-destroyed-cb
  void "wlc_set_input_destroyed_cb" '(*))

