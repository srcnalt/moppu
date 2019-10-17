(cl:in-package :moppu)

;; blah blah blah.
; Set window properties
(gamekit:defgame moppu (gamekit.postproc:postproc)()
  (:viewport-width 800)           ; window's width
  (:viewport-height 600)          ; window's height
  (:viewport-title "moppu")    ; window's title
  (:draw-rate 120)
  (:act-rate 120)
  (:default-initargs :postproc-indirect-width 200
                     :postproc-indirect-height 150))

(defun run ()
  (gamekit:start 'moppu))




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
  (setf (gamekit:x (rect *player*)) (+ (* *move-dir* *speed*) (gamekit:x (rect *player*))))
  (incf (gamekit:y (rect *player*)) *velocity*))

(defun moving-height (letter-height init-value)
  (+ letter-height (* 4 (sin (+ *letter-move* init-value)))))

(defun check-collision (item-a item-b)
  (and
    ; x y w h
    ; l r t b
    ; a.x  < b.xw  ->  a.x+l  < b.x+w-r
    ; a.xw > b.x   ->  a.x+w-r > b.x+l
    ; a.y  < b.yh  ->  a.y+b  < b.y+h-t
    ; a.yh > b.y   ->  a.y+h-t > b.y+b

    ; a.(rect x) + (coll x)     < b.(rect x + z) - (coll y)
    ; a.(rect x + z) - (coll y) > b.(rect x) + (coll x)
    ; a.(rect y) + (coll w)     < b.(rect y + w) - (coll z)
    ; a.(rect y + w) - (coll z) > b.(rect y) + (coll w)

    (< (+ (gamekit:x (rect item-a)) (gamekit:x (coll item-a))) (- (+ (gamekit:x (rect item-b)) (gamekit:z (rect item-b))) (gamekit:y (coll item-b))))
    (> (- (+ (gamekit:x (rect item-a)) (gamekit:z (rect item-a))) (gamekit:y (coll item-a))) (+ (gamekit:x (rect item-b)) (gamekit:x (coll item-b))))
    (< (+ (gamekit:y (rect item-a)) (gamekit:w (coll item-a))) (- (+ (gamekit:y (rect item-b)) (gamekit:w (rect item-b))) (gamekit:z (coll item-b))))
    (> (- (+ (gamekit:y (rect item-a)) (gamekit:w (rect item-a))) (gamekit:z (coll item-a))) (+ (gamekit:y (rect item-b)) (gamekit:w (coll item-b))))))

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

(defun draw-collider (elem)
  (gamekit:draw-rect
  (gamekit:vec2 (+ (gamekit:x (rect elem)) (gamekit:x (coll elem))) (+ (gamekit:y (rect elem)) (gamekit:w (coll elem))))
  (- (gamekit:z (rect elem)) (gamekit:x (coll elem)) (gamekit:y (coll elem)))
  (- (gamekit:w (rect elem)) (gamekit:z (coll elem)) (gamekit:w (coll elem)))
  :fill-paint (gamekit:vec4 1 0 0 0.5)))

; objects
;; TODO: collision area vec4
(defclass block-item ()
  (
    (src  :accessor src)
    (rect :accessor rect)
    (coll :accessor coll)
    (draw-pos :reader draw-pos)
  )
)

(defmethod draw-pos ((object block-item))
   (gamekit:vec2 (gamekit:x (rect object)) (gamekit:y (rect object)))
)

(defvar *player* (make-instance 'block-item))
(setf (src  *player*) nil)
(setf (rect *player*) (gamekit:vec4 200 300 50 60))
(setf (coll *player*) (gamekit:vec4 10 10 60 -5))

(defvar *ground* (make-instance 'block-item))
(setf (src  *ground*) :blank)
(setf (rect *ground*) (gamekit:vec4 0 0 800 100))
(setf (coll *ground*) (gamekit:vec4 0 0 0 0))

;; TODO: move these into a loop
(defvar *block-a* (make-instance 'block-item))
(setf (src  *block-a*) :block)
(setf (rect *block-a*) (gamekit:vec4 200 150 60 30))
(setf (coll *block-a*) (gamekit:vec4 0 0 0 20))

(defvar *block-b* (make-instance 'block-item))
(setf (src  *block-b*) :block)
(setf (rect *block-b*) (gamekit:vec4 300 200 60 30))
(setf (coll *block-b*) (gamekit:vec4 0 0 0 20))

(defvar *block-c* (make-instance 'block-item))
(setf (src  *block-c*) :block)
(setf (rect *block-c*) (gamekit:vec4 300 400 60 30))
(setf (coll *block-c*) (gamekit:vec4 0 0 0 20))

(defvar *block-d* (make-instance 'block-item))
(setf (src  *block-d*) :block)
(setf (rect *block-d*) (gamekit:vec4 450 300 60 30))
(setf (coll *block-d*) (gamekit:vec4 0 0 0 20))

(defvar *blocks* (list *ground* *block-a* *block-b* *block-c* *block-d*))
; Game logic
(defmethod gamekit:draw ((app moppu))
  (bodge-canvas:antialias-shapes nil)
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

      (loop
          :for elem :in *blocks*
          :do (gamekit:draw-image (draw-pos elem) (src elem)))

      (case *move-dir*
        (1  (gamekit:draw-image (draw-pos *player*) :player-right))
        (-1 (gamekit:draw-image (draw-pos *player*) :player-left))
        (0  (gamekit:draw-image (draw-pos *player*) :player-front)))
    )

    (2 ())
  )

  (gamekit:draw-rect (gamekit:vec2 0 0) 800 600 :fill-paint (gamekit:vec4 0 0 0 *alpha*))

  (when *debug*
    (gamekit:print-text (format nil "Grounded: ~a"  *grounded*) 10 580)
    (gamekit:print-text (format nil "Velocity: ~3a" *velocity*) 10 560)
    (gamekit:print-text (format nil "Collides: ~a" (check-collision-all *player*)) 10 540)
    (draw-collider *player*)
    (loop
        :for elem :in *blocks*
        :do (draw-collider elem)))
)

(defmethod gamekit:act ((app moppu))
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
        (setf *velocity* 0))

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

; testing
(defmethod post-initialize ((this moppu))
  (gamekit:bind-button
   :right :repeating
   (lambda () (incf (gamekit:x (rect *block-a*)) 2)))

  (gamekit:bind-button
   :left :repeating
   (lambda () (decf (gamekit:x (rect *block-a*)) 2)))

  (gamekit:bind-button
   :up :repeating
   (lambda () (incf (gamekit:y (rect *block-a*)) 2)))

  (gamekit:bind-button
   :down :repeating
   (lambda () (decf (gamekit:y (rect *block-a*)) 2)))

  ;; Input bindings
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
            (setf *velocity* 7)
            (setf *grounded* nil)))
       (2 ())))))
