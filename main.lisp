(defvar *canvas-width* 800)
(defvar *canvas-height* 600)

(gamekit:defgame hello-gamekit () ()
  (:viewport-width *canvas-width*)     ; window's width
  (:viewport-height *canvas-height*)   ; window's height
  (:viewport-title "Hello Gamekit!"))  ; window's title

  
(gamekit:register-resource-package :keyword "assets/")
(gamekit:define-image :snake-head "snake-head.png")
(gamekit:define-sound :snake-grab "snake-grab.ogg")


(gamekit:start 'hello-gamekit)

;;;;;;;;;;;;;;;;;;;

(defvar *black* (gamekit:vec4 0 0 0 1))
(defvar *origin* (gamekit:vec2 0 0))

(defmethod gamekit:draw ((app hello-gamekit))
  ;; Let's draw a black box in the bottom-left corner
  (gamekit:draw-rect *origin* 100 100 :fill-paint *black*))

;;;;;;;;;;;;;;;;;;;

(defvar *current-box-position* (gamekit:vec2 0 0))

(defun real-time-seconds ()
  "Return seconds since certain point of time"
  (/ (get-internal-real-time) internal-time-units-per-second))

(defun update-position (position time)
  "Update position vector depending on the time supplied"
  (let* ((subsecond (nth-value 1 (truncate time)))
         (angle (* 2 pi subsecond)))
    (setf (gamekit:x position) (+ 350 (* 100 (cos angle)))
          (gamekit:y position) (+ 250 (* 100 (sin angle))))))

(defmethod gamekit:draw ((app hello-gamekit))
  (update-position *current-box-position* (real-time-seconds))
  (gamekit:draw-rect *current-box-position* 100 100 :fill-paint *black*))

(defvar *curve* (make-array 4 :initial-contents (list (gamekit:vec2 300 300)
                                                      (gamekit:vec2 375 300)
                                                      (gamekit:vec2 425 300)
                                                      (gamekit:vec2 500 300))))

(defun update-position (position time)
  (let* ((subsecond (nth-value 1 (truncate time)))
         (angle (* 2 pi subsecond)))
    (setf (gamekit:y position) (+ 300 (* 100 (sin angle))))))

(defmethod gamekit:act ((app hello-gamekit))
  (update-position (aref *curve* 1) (real-time-seconds))
  (update-position (aref *curve* 2) (+ 0.3 (real-time-seconds))))

(defmethod gamekit:draw ((app hello-gamekit))
  (gamekit:print-text "A snake that is!" 300 400)
  (gamekit:draw-curve (aref *curve* 0)
                      (aref *curve* 3)
                      (aref *curve* 1)
                      (aref *curve* 2)
                      *black*
                      :thickness 5.0)
  ;; let's center image position properly first
  (let ((head-image-position (gamekit:subt (aref *curve* 3) (gamekit:vec2 32 32))))
    ;; then draw it where it belongs
    (gamekit:draw-image head-image-position :snake-head)))

(defvar *cursor-position* (gamekit:vec2 0 0))

(gamekit:bind-cursor (lambda (x y)
                       "Save cursor position"
                       (setf (gamekit:x *cursor-position*) x
                             (gamekit:y *cursor-position*) y)))

(gamekit:bind-button :mouse-left :pressed
                     (lambda ()
                       "Copy saved cursor position into snake's head position vector"
                       (let ((head-position (aref *curve* 3)))
                         (setf (gamekit:x head-position) (gamekit:x *cursor-position*)
                               (gamekit:y head-position) (gamekit:y *cursor-position*)))))

(defvar *head-grabbed-p* nil)

(gamekit:bind-cursor (lambda (x y)
                       "When left mouse button is pressed, update snake's head position"
                       (when *head-grabbed-p*
                         (let ((head-position (aref *curve* 3)))
                           (setf (gamekit:x head-position) x
                                 (gamekit:y head-position) y)))))


(gamekit:bind-button :mouse-left :pressed
                     (lambda () (setf *head-grabbed-p* t)))

(gamekit:bind-button :mouse-left :released
                     (lambda () (setf *head-grabbed-p* nil)))

(gamekit:bind-button :mouse-left :pressed
                     (lambda ()
                       (gamekit:play :snake-grab)
                       (setf *head-grabbed-p* t)))
