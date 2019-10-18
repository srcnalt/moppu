(cl:in-package :moppu)

(defclass game-object ()(
  (src  :accessor src)
  (rect :accessor rect)
  (coll :accessor coll)
  (draw-pos :reader draw-pos)
  (is-trigger  :accessor is-trigger :initform nil)
  (is-triggered :accessor is-triggered :initform nil)
  (trigger-event :reader trigger-event)))

(defmethod draw-pos ((object game-object))
   (gamekit:vec2 (gamekit:x (rect object)) (gamekit:y (rect object))))

(defmethod trigger-event ((object game-object))
  (unless (is-triggered object)
    (incf *transition-state*)
    (setf (is-triggered object) t))    ;making sure event triggered only once
  nil)
