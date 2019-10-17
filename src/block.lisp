(cl:in-package :moppu)

(defclass game-object ()(
  (src  :accessor src)
  (rect :accessor rect)
  (coll :accessor coll)
  (draw-pos :reader draw-pos)
  (is-trigger  :accessor is-trigger :initform nil)
  (trigger-event :reader trigger-event)))

(defmethod draw-pos ((object game-object))
   (gamekit:vec2 (gamekit:x (rect object)) (gamekit:y (rect object))))

(defmethod trigger-event ((object game-object))
  (setf *transitioning* t)
  (setf *alpha* 0)
  nil)
