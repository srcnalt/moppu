(cl:in-package :moppu)

(defclass game-object ()(
  (src  :accessor src)
  (rect :accessor rect)
  (coll :accessor coll)
  (hit-coll :accessor hit-coll)
  (draw-pos :reader draw-pos)
  (is-trigger  :accessor is-trigger :initform nil)
  (trigger-event :initform #'trigger-door  :accessor trigger-event)))

(defmethod draw-pos ((object game-object))
   (gamekit:vec2 (gamekit:x (rect object)) (gamekit:y (rect object))))
