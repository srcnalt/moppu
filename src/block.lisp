(cl:in-package :moppu)

(defclass game-object ()(
  (src  :accessor src)
  (alt  :accessor alt)
  (rect :accessor rect)
  (coll :accessor coll)
  (hit-coll :accessor hit-coll)
  (init-y :accessor init-y)
  (draw-pos :reader draw-pos)
  (is-moving  :accessor is-moving :initform nil)
  (is-trigger  :accessor is-trigger :initform nil)
  (trigger-event :initform #'trigger-door  :accessor trigger-event)))

(defmethod draw-pos ((object game-object))
  (if (is-moving object)
    (setf (gamekit:y (rect object)) (+ (init-y object) (* 10 (sin (real-time-seconds)))))
    (gamekit:vec2 (gamekit:x (rect object)) (gamekit:y (rect object))))
  (gamekit:vec2 (gamekit:x (rect object)) (gamekit:y (rect object))))
