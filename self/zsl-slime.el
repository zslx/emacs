;;; zsl-slime.el
;;; lisp ide major-mode

;;; A basic slime configuration
(add-to-list 'load-path "/home/zsl/dev/clisp/slime/")
(add-to-list 'load-path "/home/zsl/dev/clisp/slime/contrib/")

(require 'slime)

;; Important(!): 'slime-fancy' is the meta contrib that will enable
;; all sorts of advanced features.
(slime-setup '(slime-fancy slime-asdf))

;; ("foo") means that the programm "foo" is tried to be executed.
(setq slime-lisp-implementations
	  '((clisp		("clisp")	:coding-system utf-8-unix)
		(cmucl		("lisp")	:coding-system iso-latin-1-unix)
		(sbcl		("sbcl")	:coding-system utf-8-unix)
		(sbcl-git	("sbcl-git") :coding-system utf-8-unix)
		(sbcl-cvs-no-utf8 ("sbcl-cvs"))))

;; 'M-x slime' will execute this entry in 'slime-lisp-implementations'.
;; You can specify another entry to be used by 'M-- M-x slime'.
(setf slime-default-lisp 'clisp)

(provide 'zsl-slime)
;;; zsl-slime.el ends here