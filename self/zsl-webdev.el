;; espresso-mode is a Javascript-mode for GNU Emacs
;;Espresso has been incorporated into GNU Emacs starting with version 23.2 and has been renamed js-mode.

;; 3 multi-web-mode
(require 'php-mode)
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
;; (setq mweb-default-major-mode 'sgml-mode) ;; html-mode 从 sgml-mode 继承的

;;
;; (require 'yasnippet-bundle)

(setq mweb-tags '(
				  ;; html-mode ;; 对符号 '->' 识别有误
				  (php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script[^>]*>" "</script>")
                  (css-mode "<style[^>]*>" "</style>")))


(setq mweb-filename-extensions '("php" "htm" "html" "tpl" "ctp" "phtml" "php4" "php5"))

(defun delete-some-keybinding()
  (local-unset-key "(")
  (local-unset-key ")")
  (local-unset-key ";")
  (local-unset-key ":")
  )
(add-hook 'php-mode-hook 'delete-some-keybinding)


(defun php-mode-indent ()
  (setq tab-width 4 indent-tabs-mode nil) ; tab as 4 whitespace
  ;; (c-set-style "zsl-cxx-style")
  ;; (setq c-offsets-alist '(
  ;; 						  (defun-block-intro . +)
  ;; 						  (arglist-intro . ++)
  ;; 						  (arglist-close . --)
  ;; 						  (arglist-cont . 0)
  ;; 						  (arglist-cont-nonempty . ++)
  ;; 						  (statement-block-intro . +)
  ;; 						  (substatement . +)
  ;; 						  ))
  )
(add-hook 'php-mode-hook 'php-mode-indent)
;; (add-hook 'javascript-mode 'php-mode-indent)

(multi-web-global-mode 1)

;; 2 nXhtml
;; (let ((nxhtml (concat cfghome ".emacs.d/downloads/nxhtml/autostart.el")))
;;   (load nxhtml)
;;   )

;; 1 HtmlModeDeluxe deluxe
;; (add-to-list 'load-path (concat cfghome ".emacs.d/php") )
;; (add-to-list 'load-path (concat cfghome ".emacs.d/mmm-mode"))
;; ;(load "php-mode")
;; (require 'php-mode)
;; (require 'mmm-mode)

;; ;; PHP 语法支持,需要MMM模块的添加才支持混合代码
;; (add-hook 'php-mode-user-hook 'turn-on-font-lock)

;; (add-to-list 'auto-mode-alist
;;      	     '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))

;; (setq mmm-global-mode 'maybe)

;; (mmm-add-group
;;  'php-in-html
;;   '(
;; 	(html-php-tagged
;; 	 :submode php-mode
;; 	 :front "<\?"
;; 	 :back "\?>"
;; 	 :include-back t)))

;; (add-hook 'html-mode-hook '(lambda ()
;; 							 (setq mmm-classes '(php-in-html))
;; 							 (set-face-background 'mmm-default-submode-face "black")
;; 							 (mmm-mode-on)))

;; ;; (add-to-list 'mmm-mode-ext-classes-alist '(html-mode nil fancy-html))


;; ;; Customize flymake-jslint options. On Windows set flymake-jslint-command to: ~/.emacs.d/jslint.bat
;; (require 'flymake-jslint)
;; (setq flymake-jslint-command "~/.emacs.d/jslint.bat")
;; (add-hook 'js-mode-hook 'flymake-jslint-load)
;; Troubleshooting
;; Customize flymake-log-level and inspect the *Messages* buffer.
;; Make sure that the command configured in flymake-jslint-command runs in EShell.
;; Check flymake-jslint-args.

;; html-mode keybindings: C-c C-t: sgml-tag 插入标签; C-c C-f/b: 标签级别的进退
;; C-c		Prefix Command
;; ESC		Prefix Command
;; /		sgml-slash
;; C-c C-c		Prefix Command

;; C-c ?		sgml-tag-help

;; C-c C-d ;; C-c DEL		sgml-delete-tag
;; C-c C-f ;; C-c <right>	sgml-skip-tag-forward
;; C-c C-b ;; C-c <left>	sgml-skip-tag-backward

;; C-c C-j		html-line; insert '<br>'
;; C-c RET		html-paragraph; <p>
;; C-c /		sgml-close-tag
;; C-c C-t		sgml-tag
;; C-c 1		html-headline-1
;; C-c 2		html-headline-2
;; C-c 3		html-headline-3
;; C-c 4		html-headline-4
;; C-c 5		html-headline-5
;; C-c 6		html-headline-6

;; C-c C-c -	html-horizontal-rule
;; C-c C-c c	html-checkboxes
;; C-c C-c h	html-href-anchor
;; C-c C-c i	html-image
;; C-c C-c l	html-list-item
;; C-c C-c n	html-name-anchor
;; C-c C-c o	html-ordered-list
;; C-c C-c r	html-radio-buttons
;; C-c C-c u	html-unordered-list

;; C-c C-a		sgml-attributes
;; C-c 8		sgml-name-8bit-mode
;; C-c TAB		sgml-tags-invisible
;; C-c C-n		sgml-name-char
;; C-c C-s		html-autoview-mode

;; C-c C-v		browse-url-of-buffer
;; C-c C-v		sgml-validate ; 在浏览器中查看当前文件
;; (that binding is currently shadowed by another mode)

;; M-TAB		ispell-complete-word


;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)) ;2016-05-17 10:21:00
(let ((item (assoc "\\.js\\'" auto-mode-alist))) (setcdr item 'js2-mode)) ;替换
;; (add-hook 'js-mode-hook 'js2-minor-mode)
;; (add-hook 'js-mode-hook nil)

(provide 'zsl-webdev)
