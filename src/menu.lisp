(cl:in-package :moppu)

(defvar *letter-padding* 21)
(defvar *letter-move* 0)
(defvar *flower-x* -2)
(defvar *menu-start-pressed* nil)

(defun moving-height (letter-height init-value)
  (+ letter-height (sin (+ *letter-move* init-value))))

(defun draw-menu ()
  (gamekit:draw-image (gamekit:vec2 0 0) :menu-bg)
  (gamekit:draw-image (gamekit:vec2 31 52) :under-text)
  (gamekit:draw-image (gamekit:vec2 *letter-padding* (moving-height 40 0)) :letter-m)
  (gamekit:draw-image (gamekit:vec2 (+ *letter-padding* 11) (moving-height 39 2)) :letter-o)
  (gamekit:draw-image (gamekit:vec2 (+ *letter-padding* 18) (moving-height 36 4)) :letter-p)
  (gamekit:draw-image (gamekit:vec2 (+ *letter-padding* 25) (moving-height 36 1)) :letter-p)
  (gamekit:draw-image (gamekit:vec2 (+ *letter-padding* 32) (moving-height 39 5)) :letter-u)

  (if *menu-start-pressed*
    (gamekit:draw-image (gamekit:vec2 17 25) :start-prs)
    (gamekit:draw-image (gamekit:vec2 17 25) :start-btn))

  (gamekit:draw-image (gamekit:vec2 0 (moving-height (- *flower-x* 2) 1)) :menu-f-1)
  (gamekit:draw-image (gamekit:vec2 0 (moving-height (- *flower-x* 3) 2)) :menu-f-2)
  (gamekit:draw-image (gamekit:vec2 0 (moving-height (- *flower-x* 1) 1)) :menu-f-3))

(defun update-menu ()
  (if *menu-start-pressed*
    (if (> *flower-x* -25)
      (decf *flower-x* 0.3)
      (when (= *transition-state* 0)
        (setf *transition-state* 1))))
  (when (= *transition-state* 2)
    (setf *flower-x* -2)
    (setf *menu-start-pressed* nil)
    (incf *game-state*))
  (setf *letter-move* (* 2 (real-time-seconds))))
