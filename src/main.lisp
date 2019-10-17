(cl:in-package :moppu)

;; blah blah blah.
; Set window properties
(gamekit:defgame :moppu ()
  ()
  (:viewport-width 800)           ; window's width
  (:viewport-height 600)          ; window's height
  (:viewport-title "moppu")    ; window's title
  (:draw-rate 120)
  (:act-rate 120))

; Start the game loop
(defvar *debug* nil)

; player vars
(defvar *move-dir* 0)
(defvar *velocity* 0)
(defvar *grounded* t)
(defvar *speed* 1)

;; scene vars
(defvar *clouds-one-pos-x* 0)
(defvar *clouds-two-pos-x* 800)

;; menu vars
(defvar *letter-padding* 210)
(defvar *letter-move* 0)
(defvar *transitioning* nil)
(defvar *alpha* 0)

(defvar *game-state* 0) ; 0- menu, 1- game, 2- credits

; Methods
(defun update-position ()
  (setf (gamekit:x (pos *player*)) (+ (* *move-dir* *speed*) (gamekit:x (pos *player*))))
  (incf (gamekit:y (pos *player*)) *velocity*))

(defun moving-height (letter-height init-value)
  (+ letter-height (* 4 (sin (+ *letter-move* init-value)))))

  (defun check-collision (item-a item-b)
    (and
      (< (gamekit:x (pos item-a)) (+ (gamekit:x (pos item-b)) (gamekit:x (size item-b))))
      (< (gamekit:y (pos item-a)) (+ (gamekit:y (pos item-b)) (gamekit:y (size item-b))))
      (> (+ (gamekit:x (pos item-a)) (gamekit:x (size item-a))) (gamekit:x (pos item-b)))
      (> (+ (gamekit:y (pos item-a)) (gamekit:y (size item-a))) (gamekit:y (pos item-b)))))

  (defun check-collision-all (item)
    (loop
      :with *collides* := nil
      :for elem :in *blocks*
      :when (check-collision item elem)
      :do (setf *collides* t)
      (return *collides*)))

  (defun real-time-seconds ()
    "Return seconds since certain point of time"
    (/ (get-internal-real-time) internal-time-units-per-second))

; objects
;; TODO: collision area vec4
(defclass block-item ()
  (
    (src  :accessor src)
    (pos  :accessor pos)
    (size :accessor size)
    (draw-pos :reader draw-pos)
  )
)

(defmethod draw-pos ((object block-item))
   (gamekit:vec2 (- (gamekit:x (pos object)) 10) (gamekit:y (pos object)))
)

(defvar *player* (make-instance 'block-item))
(setf (src  *player*) nil)
(setf (pos  *player*) (gamekit:vec2 400 100))
(setf (size *player*) (gamekit:vec2 30 1))

(defvar *ground* (make-instance 'block-item))
(setf (src  *ground*) :blank)
(setf (pos  *ground*) (gamekit:vec2 0 0))
(setf (size *ground*) (gamekit:vec2 800 100))

;; TODO: move these into a loop
(defvar *block-a* (make-instance 'block-item))
(setf (src  *block-a*) :block)
(setf (pos  *block-a*) (gamekit:vec2 200 150))
(setf (size *block-a*) (gamekit:vec2 60 30))

(defvar *block-b* (make-instance 'block-item))
(setf (src  *block-b*) :block)
(setf (pos  *block-b*) (gamekit:vec2 300 200))
(setf (size *block-b*) (gamekit:vec2 60 30))

(defvar *block-c* (make-instance 'block-item))
(setf (src  *block-c*) :block)
(setf (pos  *block-c*) (gamekit:vec2 400 250))
(setf (size *block-c*) (gamekit:vec2 60 30))

(defvar *block-d* (make-instance 'block-item))
(setf (src  *block-d*) :block)
(setf (pos  *block-d*) (gamekit:vec2 550 250))
(setf (size *block-d*) (gamekit:vec2 60 30))

(defvar *blocks* (list *ground* *block-a* *block-b* *block-c* *block-d*))

; Game logic
(defmethod gamekit:draw ((app :moppu))
  (case *game-state*
    (0
      (gamekit:draw-image (gamekit:vec2 0 0) :menu-bg)
      (gamekit:draw-image (gamekit:vec2 310 520) :under-text)
      (gamekit:draw-image (gamekit:vec2 *letter-padding* (moving-height 400 0)) :letter-m)
      (gamekit:draw-image (gamekit:vec2 (+ *letter-padding* 110) (moving-height 390 20)) :letter-o)
      (gamekit:draw-image (gamekit:vec2 (+ *letter-padding* 180) (moving-height 360 40)) :letter-p)
      (gamekit:draw-image (gamekit:vec2 (+ *letter-padding* 250) (moving-height 360 10)) :letter-p)
      (gamekit:draw-image (gamekit:vec2 (+ *letter-padding* 320) (moving-height 390 50)) :letter-u)

      (gamekit:draw-image (gamekit:vec2 0 (moving-height -20 10)) :menu-f-1)
      (gamekit:draw-image (gamekit:vec2 0 (moving-height -30 20)) :menu-f-2)
      (gamekit:draw-image (gamekit:vec2 0 (moving-height -10 10)) :menu-f-3)
    )

    (1
      (gamekit:draw-image (gamekit:vec2 0 0) :background)
      (gamekit:draw-image (gamekit:vec2 *clouds-one-pos-x* 430) :clouds)
      (gamekit:draw-image (gamekit:vec2 *clouds-two-pos-x* 430) :clouds)

      (case *move-dir*
        (1  (gamekit:draw-image (draw-pos *player*) :player-right))
        (-1 (gamekit:draw-image (draw-pos *player*) :player-left))
        (0  (gamekit:draw-image (draw-pos *player*) :player-front)))

      (loop
          :for elem :in *blocks*
          :do (gamekit:draw-image (pos elem) (src elem)))
    )

    (2 ())
  )

  (gamekit:draw-rect (gamekit:vec2 0 0) 800 600 :fill-paint (gamekit:vec4 0 0 0 *alpha*))

  (when *debug*
    (gamekit:print-text (format nil "Grounded: ~a"  *grounded*) 10 580)
    (gamekit:print-text (format nil "Velocity: ~3a" *velocity*) 10 560)
    (gamekit:print-text (format nil "Collides: ~a" (check-collision-all *player*)) 10 540))
)

(defmethod gamekit:act ((app :moppu))
  (case *game-state*
    (0
      (setf *letter-move* (* 2 (real-time-seconds)))
      (if *transitioning*
        (incf *alpha* 0.02))
      (if (>= *alpha* 1)
        (setf *game-state* 1))
    )

    (1
      (if *transitioning*
        (decf *alpha* 0.02))
      (if (<= *alpha* 0)
        (setf *transitioning* nil))

      (when (and (< *velocity* 0) (check-collision-all *player*))
        (setf *grounded* t)
        (setf *velocity* 0)
        (incf (gamekit:x (pos *player*)) 0.2))

      (when (not (check-collision-all *player*))
        (setf *grounded* nil))

      (when (not *grounded*)
       (decf *velocity* 0.2)
       (setf *speed* 2))

      (if *grounded*
        (setf *speed* 1))

      (update-position)
      (if (< *clouds-one-pos-x* -800) (setf *clouds-one-pos-x* 0))
      (decf *clouds-one-pos-x* 0.2)
      (if (< *clouds-two-pos-x* 0) (setf *clouds-two-pos-x* 800))
      (decf *clouds-two-pos-x* 0.2)
    )

    (2 ())
  )
)

(defun run()
  (gamekit:start :moppu)

  ; testing
  (gamekit:bind-button :right :repeating
    (lambda () (incf (gamekit:x (pos *block-a*)) 2)))

  (gamekit:bind-button :left :repeating
    (lambda () (decf (gamekit:x (pos *block-a*)) 2)))

  (gamekit:bind-button :up :repeating
    (lambda () (incf (gamekit:y (pos *block-a*)) 2)))

  (gamekit:bind-button :down :repeating
    (lambda () (decf (gamekit:y (pos *block-a*)) 2)))

  ; Input bindings
  (gamekit:bind-button :a :pressed
    (lambda () (setf *move-dir* -1)))

  (gamekit:bind-button :a :released
    (lambda () (setf *move-dir* 0)))

  (gamekit:bind-button :d :pressed
    (lambda () (setf *move-dir* 1)))

  (gamekit:bind-button :d :released
    (lambda () (setf *move-dir* 0)))

  (gamekit:bind-button :space :pressed
    (lambda ()
      (case *game-state*
        (0
          (setf *transitioning* t)
        )

        (1
            (when *grounded*
              (setf *velocity* 7)
              (setf *grounded* nil))
        )

        (2 ())))))
