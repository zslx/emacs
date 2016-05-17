;; auto-complete
(add2load_path elibs "auto-complete/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (concat elibs "auto-complete/ac-dict") )
(ac-config-default)
(require 'auto-complete)
(global-auto-complete-mode t)

;; 不让回车的时候执行`ac-complete', 因为当你输入完一个单词的时候,
;; 很有可能补全菜单还在, 这时候你要回车的话, 必须要干掉补全菜单, 很麻烦.
;; 用M-j来执行`ac-complete'
;; (define-key ac-complete-mode-map "<return>"   'nil)
;; (define-key ac-complete-mode-map "RET"        'nil)
;; (define-key ac-complete-mode-map "M-j"        'ac-complete)
;; (define-key ac-complete-mode-map "<C-return>" 'ac-complete)

;; yasnippet
(add2load_path elibs "yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory (concat elibs "yasnippet-0.6.1c/snippets") )
;; (require 'yasnippet-bundle)

(provide 'zsl-auto-complete)