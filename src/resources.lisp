(cl:in-package :moppu)

(gamekit:register-resource-package
	:keyword (asdf:system-relative-pathname :moppu "assets/"))

(gamekit:define-font :sevenfour "fonts/SevenFour.ttf")

; Player
(gamekit:define-image :player-right "moppy-right.png" 		 		:use-nearest-interpolation t)
(gamekit:define-image :player-left  "moppy-left.png" 		 			:use-nearest-interpolation t)
(gamekit:define-image :player-front "moppy-front.png" 	     	:use-nearest-interpolation t)
(gamekit:define-image :player-cry   "moppy-cry.png" 	     	  :use-nearest-interpolation t)

; Level
(gamekit:define-image :block 				"block.png" 			 				:use-nearest-interpolation t)
(gamekit:define-image :door 				"door.png" 			 				  :use-nearest-interpolation t)
(gamekit:define-image :clouds 			"clouds.png" 			 				:use-nearest-interpolation t)
(gamekit:define-image :background 	"background.png" 		 			:use-nearest-interpolation t)
(gamekit:define-image :ground			 	"ground.png" 		 					:use-nearest-interpolation t)
(gamekit:define-image :thorn-1			"thorn-1.png" 		 				:use-nearest-interpolation t)
(gamekit:define-image :thorn-2			"thorn-2.png" 		 				:use-nearest-interpolation t)
(gamekit:define-image :flower-1			"flower-1.png" 		 				:use-nearest-interpolation t)
(gamekit:define-image :flower-2			"flower-2.png" 		 				:use-nearest-interpolation t)
(gamekit:define-image :flower-3			"flower-3.png" 		 				:use-nearest-interpolation t)
(gamekit:define-image :score			  "score.png" 		 				  :use-nearest-interpolation t)

; Menu
(gamekit:define-image :letter-m 		"menu/letter-m.png" 	 		:use-nearest-interpolation t)
(gamekit:define-image :letter-o 		"menu/letter-o.png" 	 		:use-nearest-interpolation t)
(gamekit:define-image :letter-p 		"menu/letter-p.png" 	 		:use-nearest-interpolation t)
(gamekit:define-image :letter-u 		"menu/letter-u.png" 	 		:use-nearest-interpolation t)
(gamekit:define-image :under-text 	"menu/under-text.png" 	 	:use-nearest-interpolation t)
(gamekit:define-image :menu-bg 			"menu/menu-bg.png" 		 		:use-nearest-interpolation t)
(gamekit:define-image :menu-f-1 		"menu/menu-flower-1.png" 	:use-nearest-interpolation t)
(gamekit:define-image :menu-f-2 		"menu/menu-flower-2.png" 	:use-nearest-interpolation t)
(gamekit:define-image :menu-f-3 		"menu/menu-flower-3.png" 	:use-nearest-interpolation t)
(gamekit:define-image :start-btn 		"menu/start.png" 					:use-nearest-interpolation t)
(gamekit:define-image :start-prs 		"menu/start-pressed.png" 	:use-nearest-interpolation t)
