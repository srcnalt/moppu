(cl:in-package :moppu)

(defvar *letter-padding* 21)
(defvar *letter-move* 0)

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

  (gamekit:draw-image (gamekit:vec2 0 (moving-height -2 1)) :menu-f-1)
  (gamekit:draw-image (gamekit:vec2 0 (moving-height -3 2)) :menu-f-2)
  (gamekit:draw-image (gamekit:vec2 0 (moving-height -1 1)) :menu-f-3))

(defun update-menu ()
  (setf *letter-move* (* 2 (real-time-seconds))))
