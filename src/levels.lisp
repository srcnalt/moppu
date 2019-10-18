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
          (setf (rect wall) (gamekit:vec4 (* j 5) (+ 10 (* (- *level-row* i 1) 5)) 5 5))
          (setf (coll wall) (gamekit:vec4 0 0 0 4))
          (push wall (cdr (last level-blocks))))
        (2
          (setf door (make-instance 'game-object))
          (setf (src  door) :door)
          (setf (rect door) (gamekit:vec4 (* j 5) (+ 10 (* (- *level-row* i 1) 5)) 10 10))
          (setf (coll door) (gamekit:vec4 0 0 0 0))
          (setf (is-trigger door) t)
          (push door (cdr (last level-blocks))))))))

(defun print-level (level-blocks)
  (loop
    :for elem :in level-blocks
    :do (gamekit:draw-image (draw-pos elem) (src elem))))

(defvar *ground* (make-instance 'game-object))
(setf (src  *ground*) :ground)
(setf (rect *ground*) (gamekit:vec4 0 0 80 14))
(setf (coll *ground*) (gamekit:vec4 0 0 4 0))


;;; Level 1
(defvar *level-1-blocks* (list *ground*))

(defparameter *level-1* (make-array (list *level-row* *level-col*) :initial-contents '(
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0)
  (0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))))

(load-level *level-1* *level-1-blocks*)

;;; Level 2
(defvar *level-2-blocks* (list *ground*))

(defparameter *level-2* (make-array (list *level-row* *level-col*) :initial-contents '(
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1)
  (0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0)
  (0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0)
  (0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))))

(load-level *level-2* *level-2-blocks*)

(defvar *levels* (list *level-1-blocks* *level-2-blocks*))
