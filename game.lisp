; Set window properties
(gamekit:defgame :the-game () 
  ()
  (:viewport-width 800)           ; window's width
  (:viewport-height 600)          ; window's height
  (:viewport-title "The Game")    ; window's title
  (:draw-rate 60)
  (:act-rate 60))

; Load assets
(gamekit:register-resource-package :keyword "assets/")
(gamekit:define-image :player "moppy.png")
(gamekit:define-image :background "background.png")

; Start the game loop
(gamekit:start :the-game)

; Variables
(defvar *player-position* (gamekit:vec2 400 180))
(defvar *target-position* (gamekit:vec2 0 0))
(defvar *mouse-pressed* nil)

; Methods
(defun update-position (position)
  (if (> (gamekit:x position) (gamekit:x *target-position*)) (decf (gamekit:x position) 2))
  (if (< (gamekit:x position) (gamekit:x *target-position*)) (incf (gamekit:x position) 2)))

; Game logic
(defmethod gamekit:draw ((app :the-game))
  (gamekit:draw-image (gamekit:vec2 0 0) :background)
  (gamekit:draw-image *player-position* :player)
  (gamekit:print-text (write-to-string (gamekit:x *target-position*)) 10 590)
  (gamekit:print-text (write-to-string (gamekit:x *player-position*)) 10 570)
  (gamekit:print-text (write-to-string *mouse-pressed*) 10 550))

(defmethod gamekit:act ((app :the-game))
  (update-position *player-position*))

; Input bindings
(gamekit:bind-cursor (lambda (x y)
  (when *mouse-pressed*
    (setf 
      (gamekit:x *target-position*) x
      (gamekit:y *target-position*) y))))

(gamekit:bind-button :mouse-left :pressed
  (lambda () (setf *mouse-pressed* t)))

(gamekit:bind-button :mouse-left :released
  (lambda () (setf *mouse-pressed* nil)))