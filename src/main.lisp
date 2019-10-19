(cl:in-package :moppu)

;; blah blah blah.
; Set window properties
(gamekit:defgame moppu (gamekit.postproc:postproc)()
  (:canvas-height 60)
  (:canvas-width 80)
  (:viewport-width 800)           ; window's width
  (:viewport-height 600)          ; window's height
  (:viewport-title "moppu")    ; window's title
  (:draw-rate 120)
  (:act-rate 120)
  (:default-initargs :postproc-indirect-width 800
                     :postproc-indirect-height 600))

(defun run ()
  (gamekit:start 'moppu))

; Start the game loop
(defvar *debug* nil)

; player vars
(defvar *locked* nil)
(defvar *move-dir* 0)
(defvar *velocity* 0)
(defvar *grounded* t)
(defvar *speed* 0.1)

;; scene vars
(defvar *clouds-one-pos-x* 0)
(defvar *clouds-two-pos-x* 80)

;; menu vars
(defvar *triggered* nil)
(defvar *map-blocks* nil)

(defvar *game-state* 0) ; 0- menu, 1- game, 2- credits

; Methods
(defun update-position ()
  (unless *locked*
  (setf (gamekit:x (rect *player*)) (+ (* *move-dir* *speed*) (gamekit:x (rect *player*))))
  (incf (gamekit:y (rect *player*)) *velocity*)
  (when (< (gamekit:x (rect *player*)) 0) (setf (gamekit:x (rect *player*)) 0))
  (when (> (gamekit:x (rect *player*)) (- 80 (gamekit:z (rect *player*)))) (setf (gamekit:x (rect *player*)) (- 80 (gamekit:z (rect *player*)))))))

(defun check-collision (item-a item-b)
  (setf collided
    (and (not (is-trigger item-b))
      (< (+ (gamekit:x (rect item-a)) (gamekit:x (coll item-a))) (- (+ (gamekit:x (rect item-b)) (gamekit:z (rect item-b))) (gamekit:y (coll item-b))))
      (> (- (+ (gamekit:x (rect item-a)) (gamekit:z (rect item-a))) (gamekit:y (coll item-a))) (+ (gamekit:x (rect item-b)) (gamekit:x (coll item-b))))
      (< (+ (gamekit:y (rect item-a)) (gamekit:w (coll item-a))) (- (+ (gamekit:y (rect item-b)) (gamekit:w (rect item-b))) (gamekit:z (coll item-b))))
      (> (- (+ (gamekit:y (rect item-a)) (gamekit:w (rect item-a))) (gamekit:z (coll item-a))) (+ (gamekit:y (rect item-b)) (gamekit:w (coll item-b))))))

  (setf hit
    (and (is-trigger item-b)
      (< (+ (gamekit:x (rect item-a)) (gamekit:x (hit-coll item-a))) (- (+ (gamekit:x (rect item-b)) (gamekit:z (rect item-b))) (gamekit:y (coll item-b))))
      (> (- (+ (gamekit:x (rect item-a)) (gamekit:z (rect item-a))) (gamekit:y (hit-coll item-a))) (+ (gamekit:x (rect item-b)) (gamekit:x (coll item-b))))
      (< (+ (gamekit:y (rect item-a)) (gamekit:w (hit-coll item-a))) (- (+ (gamekit:y (rect item-b)) (gamekit:w (rect item-b))) (gamekit:z (coll item-b))))
      (> (- (+ (gamekit:y (rect item-a)) (gamekit:w (rect item-a))) (gamekit:z (hit-coll item-a))) (+ (gamekit:y (rect item-b)) (gamekit:w (coll item-b))))))

  (if hit (funcall (trigger-event item-b) item-b))
  collided)

(defun check-collision-all (item)
  (setf collides nil)
  (loop
    :for elem :in (nth (- *game-state* 2) *levels*)
    :when (check-collision item elem)
    :do (setf collides t))
  collides)

(defun real-time-seconds ()
  "Return seconds since certain point of time"
  (/ (get-internal-real-time) internal-time-units-per-second))

(defun draw-collider (elem)
  (if (is-trigger elem) (setf color (gamekit:vec4 0 0 1 0.5)) (setf color (gamekit:vec4 1 0 0 0.5)))
  (gamekit:draw-rect
  (gamekit:vec2 (+ (gamekit:x (rect elem)) (gamekit:x (coll elem))) (+ (gamekit:y (rect elem)) (gamekit:w (coll elem))))
  (- (gamekit:z (rect elem)) (gamekit:x (coll elem)) (gamekit:y (coll elem)))
  (- (gamekit:w (rect elem)) (gamekit:z (coll elem)) (gamekit:w (coll elem)))
  :fill-paint color))

(defvar *alpha* 0)
(defvar *transition-state* 0)
(defvar *level-switch* nil)

(defun transition ()
  (case *transition-state*
    (1  ;darken
      (incf *alpha* 0.02)
      (when (>= *alpha* 1)
        (incf *transition-state*)))
    (2
      (setf
        (gamekit:x (rect *player*)) 0
        (gamekit:y (rect *player*)) 10
        *velocity* 0
        *locked* nil)
      (incf *transition-state*)
      (when *level-switch*
        (incf *game-state*)
        (setf *level-switch* nil)))
    (3  ;brighten
      (decf *alpha* 0.02)
      (when (<= *alpha* 0)
        (setf *transition-state* 0)))))

(defun jump()
  (setf *velocity* 0.7)
  (setf *grounded* nil))

(defun update-game()
  (when (and (< *velocity* 0) (check-collision-all *player*))
    (setf *grounded* t)
    (setf *velocity* 0))

  (when (not (check-collision-all *player*))
    (setf *grounded* nil))

  (when (not *grounded*)
   (decf *velocity* 0.02)
   (setf *speed* 0.2))

  (if *grounded*
    (setf *speed* 0.1))

  (update-position)
  (if (< *clouds-one-pos-x* -80) (setf *clouds-one-pos-x* 0))
  (decf *clouds-one-pos-x* 0.02)
  (if (< *clouds-two-pos-x* 0) (setf *clouds-two-pos-x* 80))
  (decf *clouds-two-pos-x* 0.02))

(defvar *player* (make-instance 'game-object))
(setf (src  *player*) nil)
(setf (rect *player*) (gamekit:vec4 0 10 5 6))
(setf (coll *player*) (gamekit:vec4 1 1 5.5 0))
(setf (hit-coll *player*) (gamekit:vec4 1 1 0 0))

; Game logic
(defmethod gamekit:draw ((app moppu))
  (bodge-canvas:antialias-shapes nil)
  (case *game-state*
    (0 (draw-menu))
    (1 (gamekit:draw-image (gamekit:vec2 0 0) :controls-msg))
    (2 (draw-level))
    (3 (draw-level))
    (4 (draw-level))
    (5 (draw-level))
    (6 (draw-level))
    (7 (draw-level))
    (8 (draw-level))
    (9 (draw-level))
    (10 (gamekit:draw-image (gamekit:vec2 0 0) :credits-msg)))

  (gamekit:draw-rect (gamekit:vec2 0 0) 80 60 :fill-paint (gamekit:vec4 0 0 0 *alpha*))

  (when *debug*
    (draw-collider *player*)
    (loop
        :for elem :in (nth (- *game-state* 2) *levels*)
        :do (draw-collider elem)))
)

(defun move-next()
  (when (and *menu-start-pressed* (= *transition-state* 0))
    (setf *transition-state* 1)
    (setf *level-switch* t)
    (setf *end-wait* 0)
    (setf *menu-start-pressed* nil)))

(defmethod gamekit:act ((app moppu))
  (transition)
  (case *game-state*
    (0 (update-menu))
    (1 (move-next))
    (2 (update-game))
    (3 (update-game))
    (4 (update-game))
    (5 (update-game))
    (6 (update-game))
    (7 (update-game))
    (8 (update-game))
    (9 (update-game))
    (10 (move-next))
    (11 (reset-game)))) ;reset game

(defun reset-game()
  (load-all-levels)
  (setf *game-state* 0)
  (setf *end-wait* 0)
  (setf *end-message* :success-msg)
  (setf *collected-flowers* (list))
  (setf *menu-start-pressed* nil)
  (setf *game-completed* nil))

(defmethod gamekit:post-initialize ((this moppu))
  (gamekit:bind-button
   :left :pressed
   (lambda () (setf *move-dir* -1)))

  (gamekit:bind-button
   :left :released
   (lambda () (setf *move-dir* 0)))

  (gamekit:bind-button
   :right :pressed
   (lambda () (setf *move-dir* 1)))

  (gamekit:bind-button
   :right :released
   (lambda () (setf *move-dir* 0)))

  (gamekit:bind-button
   :o :released
   (lambda () (setf *debug* (not *debug*))))

  (gamekit:bind-button
   :space :pressed
   (lambda ()
     (case *game-state*
       (0 (setf *menu-start-pressed* t))
       (1 (setf *menu-start-pressed* t))
       (2 (when *grounded* (jump)))
       (3 (when *grounded* (jump)))
       (4 (when *grounded* (jump)))
       (5 (when *grounded* (jump)))
       (6 (when *grounded* (jump)))
       (7 (when *grounded* (jump)))
       (8 (when *grounded* (jump)))
       (10 (setf *menu-start-pressed* t))))))
