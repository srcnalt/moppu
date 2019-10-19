(cl:in-package :moppu)

(defvar *level-col* 16)
(defvar *level-row* 10)

(defvar *collected-flowers* (list))

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
          (setf (coll door) (gamekit:vec4 1 1 0 0))
          (setf (is-trigger door) t)
          (setf (trigger-event door) #'trigger-door)
          (push door (cdr (last level-blocks))))
        (3
          (setf thorn (make-instance 'game-object))
          (setf (src  thorn) :thorn-1)
          (setf (rect thorn) (gamekit:vec4 (* j 5) (+ 10 (* (- *level-row* i 1) 5)) 5 5))
          (setf (coll thorn) (gamekit:vec4 0 0 0 0))
          (setf (is-trigger thorn) t)
          (setf (trigger-event thorn) #'thorn-hit)
          (push thorn (cdr (last level-blocks))))
        (4
          (setf thorn (make-instance 'game-object))
          (setf (src  thorn) :thorn-2)
          (setf (rect thorn) (gamekit:vec4 (* j 5) (+ 10 (* (- *level-row* i 1) 5)) 5 5))
          (setf (coll thorn) (gamekit:vec4 0 0 0 0))
          (setf (is-trigger thorn) t)
          (setf (trigger-event thorn) #'thorn-hit)
          (push thorn (cdr (last level-blocks))))
        (5
          (setf flower (make-instance 'game-object))
          (setf (src  flower) :flower-1)
          (setf (rect flower) (gamekit:vec4 (* j 5) (+ 10 (* (- *level-row* i 1) 5)) 5 5))
          (setf (coll flower) (gamekit:vec4 1 1 0 0))
          (setf (is-trigger flower) t)
          (setf (trigger-event flower) #'collect-flower)
          (push flower (cdr (last level-blocks))))
        (6
          (setf flower (make-instance 'game-object))
          (setf (src  flower) :flower-2)
          (setf (rect flower) (gamekit:vec4 (* j 5) (+ 10 (* (- *level-row* i 1) 5)) 5 5))
          (setf (coll flower) (gamekit:vec4 1 1 0 0))
          (setf (is-trigger flower) t)
          (setf (trigger-event flower) #'collect-flower)
          (push flower (cdr (last level-blocks))))
        (7
          (setf flower (make-instance 'game-object))
          (setf (src  flower) :flower-3)
          (setf (rect flower) (gamekit:vec4 (* j 5) (+ 10 (* (- *level-row* i 1) 5)) 5 5))
          (setf (coll flower) (gamekit:vec4 1 1 0 0))
          (setf (is-trigger flower) t)
          (setf (trigger-event flower) #'collect-flower)
          (push flower (cdr (last level-blocks))))))))

(defun draw-level ()
  (gamekit:draw-image (gamekit:vec2 0 0) :background)
  (gamekit:draw-image (gamekit:vec2 *clouds-one-pos-x* 43) :clouds)
  (gamekit:draw-image (gamekit:vec2 *clouds-two-pos-x* 43) :clouds)

  (loop
    :for elem :in (nth (- *game-state* 1) *levels*)
    :do (gamekit:draw-image (draw-pos elem) (src elem)))

  (when *locked* (gamekit:draw-image (draw-pos *player*) :player-cry))
  (unless *locked*
    (case *move-dir*
      (1  (gamekit:draw-image (draw-pos *player*) :player-right))
      (-1 (gamekit:draw-image (draw-pos *player*) :player-left))
      (0  (gamekit:draw-image (draw-pos *player*) :player-front))))
  (loop
    :for flower :in *collected-flowers*
    :do (gamekit:draw-image (gamekit:vec2 (+ 10 (* 5 (- (list-length *collected-flowers*) (position flower *collected-flowers*)))) 54) flower)))

(defmethod trigger-door ((object game-object))
  (when (= *transition-state* 0)
    (setf *level-switch* t)
    (incf *transition-state*))
  nil)

(defmethod thorn-hit ((object game-object))
  (setf *locked* t)
  (when (= *transition-state* 0)
    (incf *transition-state*))
  nil)

(defmethod collect-flower ((object game-object))
  (push (src object) *collected-flowers*)
  (setf (nth (- *game-state* 1) *levels*) (remove object (nth (- *game-state* 1) *levels*)))
  nil)

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
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 5 0 0 0 0 0 2 0))))

(load-level *level-1* *level-1-blocks*)

;;; Level 2
(defvar *level-2-blocks* (list *ground*))

(defparameter *level-2* (make-array (list *level-row* *level-col*) :initial-contents '(
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (1 1 1 0 0 1 1 0 0 1 1 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))))

(load-level *level-2* *level-2-blocks*)

;;; Level 3
(defvar *level-3-blocks* (list *ground*))

(defparameter *level-3* (make-array (list *level-row* *level-col*) :initial-contents '(
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 3 1 1 3 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
  (0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0)
  (0 0 0 0 3 0 0 0 0 0 0 3 0 0 0 0))))

(load-level *level-1* *level-1-blocks*)

(defvar *levels* (list *level-1-blocks* *level-2-blocks*))
