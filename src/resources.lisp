(cl:in-package :moppu)

(gamekit:register-resource-package
	:keyword (asdf:system-relative-pathname :moppu "assets/"))

; (gamekit:define-font :retro "fonts/...")
  
(gamekit:define-image :player-right "moppy-right.png" 		 :use-nearest-interpolation t)
(gamekit:define-image :player-left  "moppy-left.png" 		 :use-nearest-interpolation t)
(gamekit:define-image :player-front "moppy-front.png" 	     :use-nearest-interpolation t)

(gamekit:define-image :block 		"block.png" 			 :use-nearest-interpolation t)
(gamekit:define-image :clouds 		"clouds.png" 			 :use-nearest-interpolation t)
(gamekit:define-image :background 	"background.png" 		 :use-nearest-interpolation t)
(gamekit:define-image :blank 		"blank.png" 		 	 :use-nearest-interpolation t)

(gamekit:define-image :letter-m 	"menu/letter-m.png" 	 :use-nearest-interpolation t)
(gamekit:define-image :letter-o 	"menu/letter-o.png" 	 :use-nearest-interpolation t)
(gamekit:define-image :letter-p 	"menu/letter-p.png" 	 :use-nearest-interpolation t)
(gamekit:define-image :letter-u 	"menu/letter-u.png" 	 :use-nearest-interpolation t)
(gamekit:define-image :under-text 	"menu/under-text.png" 	 :use-nearest-interpolation t)
(gamekit:define-image :menu-bg 		"menu/menu-bg.png" 		 :use-nearest-interpolation t)
(gamekit:define-image :menu-f-1 	"menu/menu-flower-1.png" :use-nearest-interpolation t)
(gamekit:define-image :menu-f-2 	"menu/menu-flower-2.png" :use-nearest-interpolation t)
(gamekit:define-image :menu-f-3 	"menu/menu-flower-3.png" :use-nearest-interpolation t)
