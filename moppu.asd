(asdf:defsystem :moppu
	:description "Moppu - Autumn Lisp Game Jam 2019 Entry"
	:author "Sercan Altundas"
	:license "GPLv3"
	:depends-on (:trivial-gamekit :trivial-gamekit-postproc)
	:pathname "src/"
	:serial t
	:components (
		(:file "packages")
		(:file "resources")
		(:file "main")))
