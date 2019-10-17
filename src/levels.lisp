(cl:in-package :moppu)

(defvar *level-col* 16)
(defvar *level-row* 10)

(defun load-level (level level-blocks)
  (dotimes (i *level-row*)
    (dotimes (j *level-col*)
      (case (aref level i j)
        (1
          (setf wall (make-instance 'game-object))
          (setf (src  wall) :block)
          (setf (rect wall) (gamekit:vec4 (* j 50) (+ 100 (* (- *level-row* i 1) 50)) 50 50))
          (setf (coll wall) (gamekit:vec4 0 0 0 40))
          (push wall (cdr (last level-blocks))))
        (2
          (setf door (make-instance 'game-object))
          (setf (src  door) :door)
          (setf (rect door) (gamekit:vec4 (* j 50) (+ 100 (* (- *level-row* i 1) 50)) 100 100))
          (setf (coll door) (gamekit:vec4 0 0 0 0))
          (setf (is-trigger door) t)
          (push door (cdr (last level-blocks))))))))

(defun print-level (level-blocks)
  (loop
    :for elem :in level-blocks
    :do (gamekit:draw-image (draw-pos elem) (src elem))))

(defvar *ground* (make-instance 'game-object))
(setf (src  *ground*) :blank)
(setf (rect *ground*) (gamekit:vec4 0 0 800 100))
(setf (coll *ground*) (gamekit:vec4 0 0 0 0))

(defvar *level-1-blocks* (list *ground*))

(defparameter *level-1* (make-array (list *level-row* *level-col*) :initial-contents '(
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0)
  (0 0 0 0 0 0 1 1 1 1 0 0 1 1 1 1)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0))))

(load-level *level-1* *level-1-blocks*)
