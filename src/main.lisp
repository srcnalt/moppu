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
(defvar *move-dir* 0)
(defvar *velocity* 0)
(defvar *grounded* t)
(defvar *speed* 0.1)

;; scene vars
(defvar *clouds-one-pos-x* 0)
(defvar *clouds-two-pos-x* 80)

;; menu vars
(defvar *transitioning* nil)
(defvar *alpha* 0)
(defvar *triggered* nil)

(defvar *game-state* 0) ; 0- menu, 1- game, 2- credits

; Methods
(defun update-position ()
  (setf (gamekit:x (rect *player*)) (+ (* *move-dir* *speed*) (gamekit:x (rect *player*))))
  (incf (gamekit:y (rect *player*)) *velocity*))


(defun check-collision (item-a item-b)
  (setf collided
    (and
      (< (+ (gamekit:x (rect item-a)) (gamekit:x (coll item-a))) (- (+ (gamekit:x (rect item-b)) (gamekit:z (rect item-b))) (gamekit:y (coll item-b))))
      (> (- (+ (gamekit:x (rect item-a)) (gamekit:z (rect item-a))) (gamekit:y (coll item-a))) (+ (gamekit:x (rect item-b)) (gamekit:x (coll item-b))))
      (< (+ (gamekit:y (rect item-a)) (gamekit:w (coll item-a))) (- (+ (gamekit:y (rect item-b)) (gamekit:w (rect item-b))) (gamekit:z (coll item-b))))
      (> (- (+ (gamekit:y (rect item-a)) (gamekit:w (rect item-a))) (gamekit:z (coll item-a))) (+ (gamekit:y (rect item-b)) (gamekit:w (coll item-b))))))
  (if (and collided (is-trigger item-b))
    (trigger-event item-b)
    collided))

(defun check-collision-all (item)
  (loop
    :with *collides* := nil
    :for elem :in *level-1-blocks*
    :when (check-collision item elem)
    :do (setf *collides* t)
    (return *collides*)))

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

; objects
;; TODO: collision area vec4

(defvar *player* (make-instance 'game-object))
(setf (src  *player*) nil)
(setf (rect *player*) (gamekit:vec4 10 10 5 6))
(setf (coll *player*) (gamekit:vec4 1 1 5 0))

; Game logic
(defmethod gamekit:draw ((app moppu))
  (bodge-canvas:antialias-shapes nil)
  (case *game-state*
    (0
      (draw-menu)
    )

    (1
      (gamekit:draw-image (gamekit:vec2 0 0) :background)
      (gamekit:draw-image (gamekit:vec2 *clouds-one-pos-x* 43) :clouds)
      (gamekit:draw-image (gamekit:vec2 *clouds-two-pos-x* 43) :clouds)

      (print-level *level-1-blocks*)

      (case *move-dir*
        (1  (gamekit:draw-image (draw-pos *player*) :player-right))
        (-1 (gamekit:draw-image (draw-pos *player*) :player-left))
        (0  (gamekit:draw-image (draw-pos *player*) :player-front)))
    )

    (2 ())
  )

  (gamekit:draw-rect (gamekit:vec2 0 0) 80 60 :fill-paint (gamekit:vec4 0 0 0 *alpha*))

  (when *debug*
    ;(gamekit:print-text (format nil "Grounded: ~a"  *grounded*) (gamekit:vec2 1 58) :font (gamekit:make-font :sevenfour 7))
    ;(gamekit:print-text (format nil "Velocity: ~3a" *velocity*) (gamekit:vec2 1 56) :font (gamekit:make-font :sevenfour 7))
    ;(gamekit:print-text (format nil "Triggerd: ~a" *triggered*) (gamekit:vec2 1 52) :font (gamekit:make-font :sevenfour 7))
    ;(gamekit:print-text (format nil "Collides: ~a" (check-collision-all *player*)) 1 54)
    (draw-collider *player*)
    (loop
        :for elem :in *level-1-blocks*
        :do (draw-collider elem)))
)

(defmethod gamekit:act ((app moppu))
  (case *game-state*
    (0
      (update-menu)
    )

    (1
      (if *transitioning*
        (decf *alpha* 0.02))
      (if (<= *alpha* 0)
        (setf *transitioning* nil))

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
      (decf *clouds-two-pos-x* 0.02)
    )

    (2 ())
  )
)

(defmethod gamekit:post-initialize ((this moppu))
  (gamekit:bind-button
   :a :pressed
   (lambda () (setf *move-dir* -1)))

  (gamekit:bind-button
   :a :released
   (lambda () (setf *move-dir* 0)))

  (gamekit:bind-button
   :d :pressed
   (lambda () (setf *move-dir* 1)))

  (gamekit:bind-button
   :d :released
   (lambda () (setf *move-dir* 0)))

  (gamekit:bind-button
   :o :released
   (lambda () (setf *debug* (not *debug*))))

  (gamekit:bind-button
   :space :pressed
   (lambda ()
     (case *game-state*
       (0 (setf *transitioning* t))

       (1 (when *grounded*
            (setf *velocity* 0.7)
            (setf *grounded* nil)))
       (2 ())))))
