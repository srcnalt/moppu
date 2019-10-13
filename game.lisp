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

(gamekit:define-image :player-right "moppy-right.png")
(gamekit:define-image :player-left  "moppy-left.png")
(gamekit:define-image :player-front "moppy-front.png")

(gamekit:define-image :clouds "clouds.png")
(gamekit:define-image :background "background.png")

; Start the game loop
(gamekit:start :the-game)

; Variables
(defvar *player-position* (gamekit:vec2 400 180))
(defvar *move-dir* 0)
(defvar *speed* 2)
(defvar *clouds-one-pos-x* 0)
(defvar *clouds-two-pos-x* 800)

; Methods
(defun update-position ()
  (setf (gamekit:x *player-position*) (+ (* *move-dir* *speed*) (gamekit:x *player-position*))))

; Game logic
(defmethod gamekit:draw ((app :the-game))
  (gamekit:draw-image (gamekit:vec2 0 0) :background)
  (gamekit:draw-image (gamekit:vec2 *clouds-one-pos-x* 430) :clouds)
  (gamekit:draw-image (gamekit:vec2 *clouds-two-pos-x* 430) :clouds)

  (case *move-dir* 
    (1  (gamekit:draw-image *player-position* :player-right))
    (-1 (gamekit:draw-image *player-position* :player-left))
    (0  (gamekit:draw-image *player-position* :player-front)))
  
  (gamekit:print-text (write-to-string *move-dir*) 10 590)
  (gamekit:print-text (write-to-string (gamekit:x *player-position*)) 10 570))

(defmethod gamekit:act ((app :the-game))
  (update-position)
  (if (< *clouds-one-pos-x* -800) (setf *clouds-one-pos-x* 0))
  (decf *clouds-one-pos-x* 1)
  (if (< *clouds-two-pos-x* 0) (setf *clouds-two-pos-x* 800))
  (decf *clouds-two-pos-x* 1))

; Input bindings
(gamekit:bind-button :a :pressed
  (lambda () (setf *move-dir* -1)))

(gamekit:bind-button :a :released
  (lambda () (setf *move-dir* 0)))

(gamekit:bind-button :d :pressed
  (lambda () (setf *move-dir* 1)))

(gamekit:bind-button :d :released
  (lambda () (setf *move-dir* 0)))