; Set window properties
(gamekit:defgame :the-game () 
  ()
  (:viewport-width 800)           ; window's width
  (:viewport-height 600)          ; window's height
  (:viewport-title "The Game")    ; window's title
  (:draw-rate 60)
  (:act-rate 1))

; Load assets
(gamekit:register-resource-package :keyword "assets/")
(gamekit:define-image :player "moppy.png")

; Start the game loop
(gamekit:start :the-game)

; Variables
(defvar player-position (gamekit:vec2 400 300))
(defvar target-position (gamekit:vec2 0 0))

; Methods
(defun update-position ((position))
  (if (> (gamekit:x position) (gamekit:x target-position)) (decf (gamekit:x position) 2))
  (if (< (gamekit:x position) (gamekit:x target-position)) (incf (gamekit:x position) 2)))

; Game logic
(defmethod gamekit:draw ((app :the-game))
  (gamekit:draw-image (gamekit:vec2 player-position) :player))

(defmethod gamekit:act ((app :the-game))
  (update-position player-position))

; Input bindings
(gamekit:bind-cursor (lambda (x y) 
  (setf 
    (gamekit:x target-position) x
    (gamekit:y target-position) y)))