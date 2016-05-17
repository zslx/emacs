
;; http://code.google.com/p/dea/source/browse/trunk/my-lisps/eval-after-load.el
;;;###autoload
(defun set-key-list (keymap key-defs)
  "Execute `define-key' on KEYMAP use arguments from KEY-DEFS.

KEY-DEFS should be one list, every element of it is a list
whose first element is key like argument of `define-key', and second element is command
like argument of `define-key'."
  (dolist (key-def key-defs)
	(when key-def
	  (define-key keymap (eval `(kbd ,(car key-def))) (nth 1 key-def))))
	  ;; (local-set-key keymap (eval `(kbd ,(car key-def))) (nth 1 key-def)))) ;; 语法有错误
  )

(defun set-hs-minor-mode-keys-hook ()
  (set-key-list
	hs-minor-mode-map
	`(
	  ("C-c h" hs-hide-all)
	  ("C-c S" hs-show-all)
	  ("C-c b" hs-hide-block)
	  ("C-c s" hs-show-block)
	  ("C-c e" hs-hide-level)
	  ("C-c C-c" hs-toggle-hiding)
	  )))

(add-hook 'hs-minor-mode-hook 'set-hs-minor-mode-keys-hook)