;;; jerry-mode.el --- 编程模式mode的配置
;;; 关于编程的配置，现在编程少了，所以不怎么全，如果你是个programmer，那这里你就要好好配置一下了

(add-hook 'text-mode-hook 'turn-on-auto-fill) ;; 自动换行,在输入时，自动插入换行符号

(defun my-menu-bar-find-file (file doc help)
  "Make a menu-item to visit a file read-only.
  FILE is the file to visit, relative to `data-directory'.
  DOC is the text to use the menu entry.
  HELP is the text to use for the tooltip."
  `(menu-item ,doc
              (lambda () (interactive)
                (find-file-read-only
                 (expand-file-name ,file data-directory)))
              :help ,help))

; start point in menu
(let ( (last 'emacs-problems) file doc this )
  (mapcar (lambda (elem)
            (setq file (car elem)
                  doc (cdr elem)
                  ;; NB how make symbol on the fly. Not `make-symbol'.
                  this (intern (concat "emacs-" (downcase file))))
            (define-key-after menu-bar-help-menu `[,this]
                              (my-menu-bar-find-file file doc doc)
                              last)
            (setq last this))
          '(("TODO"       . "Emacs的TODO")
            ("DEBUG"      . "Emacs调试信息")
            ("JOKES"      . "Emacs笑话")
            ("future-bug" . "Emacs未来的bug"))))
;; '(("TODO"       . "Emacs TODO List")
;;   ("DEBUG"      . "Emacs Debugging Information")
;;   ("JOKES"      . "Emacs Jokes")
;;   ("future-bug" . "Emacs Future Bug"))))
;;
;;}}} Menu ;;;;

;;启动语法高亮模式
(global-font-lock-mode t)
;;使用gdb的图形模式
(setq gdb-many-windows t)

;; Support mode.
;;{{{ 缩写词 abbrev mode
;; ensure abbrev mode is always on
(setq-default abbrev-mode t)
;; do not bug me about saving my abbreviations
(setq save-abbrevs nil)

;; load up msf-abbrevs for these modes
(require 'msf-abbrev)
(setq msf-abbrev-verbose t) ;; optional
(setq msf-abbrev-root (concat cfghome ".emacs.d/mode-abbrevs") ) ;; 需要词典
;; (global-set-key (kbd "C-c ml") 'msf-abbrev-goto-root)
;; (global-set-key (kbd "C-c ma") 'msf-abbrev-define-new-abbrev-this-mode)
;(msf-abbrev-load)
;;}}}

;; 我的linux的kernel的编辑策略
(defun my-linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "k&r")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8))

;; FIXME 我的C/C++语言编辑策略
;;;;
;;;; My C and C++ outline-minor-mode settings ( Jacek M. Holeczek 1999 ).
;;;;
;;;; Outline mode headings are lines of C and C++ source code which contain,
;;;; at any position, C or C++ commentary headings ( that is `/*' or `//' )
;;;; followed by one or more asterisk, hash or underscore characters ( mixing
;;;; of them is allowed ) : one character for major headings, two characters
;;;; for subheadings, etc., optionally followed by a (sub)heading description
;;;; ( see `my-c-c++-outline-regexp' and `my-c-c++-outline-level' below ).
;;;; All other C and C++ source code lines are body lines.
;;;;
;;(defvar my-c-c++-outline-regexp
;;  "^.*/[\*/][ \t]*\\(\\)[\*#_]+\\([ \t]+.*$\\|$\\)")
;;(defun my-c-c++-outline-level ()
;;  (save-excursion
;;    (looking-at outline-regexp)
;;    (- (match-beginning 2) (match-end 1))))
;;;;
;;;; Outline mode headings are lines of C and C++ source code which in the
;;;; beginning, not counting leading white space characters, contain C or
;;;; C++ commentary headings ( that is `/*' or `//' ) followed by one or
;;;; more asterisk, hash or underscore characters ( the count of these
;;;; characters does not matter, mixing of them is allowed ), optionally
;;;; followed by a (sub)heading description. The heading's nesting level is
;;;; calculated from the indentation of the C or C++ commentary ( see
;;;; `my-c-c++-outline-regexp' and `my-c-c++-outline-level' below ).
;;;; All other C and C++ source code lines are body lines.
;;;;
;; (setq outline-regexp "[0-9]+\\.[0-9.]*") ; for numbered sections

(defvar my-c-c++-outline-regexp "^[ \t]*\\(\\)/[\*/][ \t]*[\*#_]+\\([ \t]+.*$\\|$\\)")
;;(defvar my-c-c++-outline-regexp "[\*{\*}]")
(defun my-c-c++-outline-level ()
  (save-excursion
    (looking-at outline-regexp)
    (string-width (buffer-substring (match-beginning 0) (match-end 1)))))
;;;;
;;;; Also the foldout.el is automatically loaded. It provides folding editor
;;;; extensions and mouse bindings for entering and exiting folds and for
;;;; showing and hiding text ( Meta-Control-Down-Mouse-{1,2,3} - see the
;;;; foldout.el source code for details ).
;;;;
(add-hook 'c-mode-hook
	  (function
	   (lambda ()
	     (setq outline-regexp my-c-c++-outline-regexp)
	     (setq outline-level 'my-c-c++-outline-level)
	     (outline-minor-mode 1)
	     (require 'foldout))))
(add-hook 'c++-mode-hook
	  (function
	   (lambda ()
	     (setq outline-regexp my-c-c++-outline-regexp)
	     (setq outline-level 'my-c-c++-outline-level)
	     (outline-minor-mode 1)
	     (require 'foldout))))
;;;; End of my C and C++ outline-minor-mode settings.
;;;;
;; initially hide all but the headers
;;  (hide-body)
(defun my-c-mode-common-hook()
  ;;(setq tab-width 4 indent-tabs-mode t)
  (setq tab-width 4 indent-tabs-mode nil) ; tab an whitespace
  ;; (c-set-style "k&r")
  (c-set-style "stroustrup")
  ;; hungry-delete and auto-newline
  (c-toggle-auto-hungry-state 1)
  ;;(hs-minor-mode 1)
  (setq abbrev-mode 1)
  ;;按键定义, 都移到 jerry-key-bindings.el
  ;;(define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)
  ;;预处理设置
  (setq c-macro-shrink-window-flag t)
  (setq c-macro-preprocessor "cpp")
  (setq c-macro-cppflags " ")
  (setq c-macro-prompt-flag t)
  ;; (require 'xcscope)
  ;;   ;;显示C的typedef
  ;;   (require 'ctypes)
  ;;   (ctypes-auto-parse-mode 1)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;(add-hook 'c-mode-hook 'imenu-add-menubar-index)

;;打开c mode的时候打开cscope,和type define

;;;;我的C++语言编辑策略
(defun my-c++-mode-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  (c-set-style "stroustrup")
  ;; (require 'xcscope)
  ;;   ;;显示C的typedef
  ;;   (require 'ctypes)
  ;;   (ctypes-auto-parse-mode 1)
  ;;  (define-key c++-mode-map [f3] 'replace-regexp)
  ;;
)

(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'c-mode-hook 'my-c++-mode-hook) ;; c-mode-common-hook不一样

;;;;C/C++语言启动时自动加载semantic对/usr/include的索引数据库
(setq semanticdb-search-system-databases t)
(add-hook 'c-mode-common-hook
          (lambda ()
	    (setq semanticdb-project-system-databases
		  (list (semanticdb-create-database
			 semanticdb-new-database-class
			 "/usr/include")))))
;;}}} c mode

;;{{{ 我的Java语言编辑策略
(defun my-java-mode-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  )

(add-hook 'java-mode-hook 'my-java-mode-hook)
;;}}}

;;{{{ Python Mode设置
;;=== python == shenglin.zhu
;; (add-to-list 'load-path (concat cfghome ".emacs.d/python") )

;; ;;代码提示
;; (require 'pycomplete)
;; ;(require 'doctest-mode)

;; ;; ipython as the shell
;; (setq ipython-command "/usr/bin/ipython")
;; (require 'ipython)

;; ;; load pydb
;; (require 'pydb)
;; (autoload 'pydb "pydb" "Python Debugger mode via GUD and pydb" t)

;; ;; Pymacs
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; ;;(eval-after-load "pymacs"
;; ;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

;; ;; python-mode
;; (autoload 'python-mode "python-mode" "Python editing mode." t)
;; (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; (setq interpreter-mode-alist (cons '("python" . python-mode)
;;                                    interpreter-mode-alist))

;(global-font-lock-mode t)
;(setq font-lock-maximum-decoration t)

; add my customization
(add-hook 'python-mode-hook 'my-python-hook)
; this gets called by outline to deteremine the level.
; Just use the length of the whitespace
(defun py-outline-level ()
  (let (buffer-invisibility-spec)
    (save-excursion
      (skip-chars-forward "\t ")
      (current-column))))

; this get called after python mode is enabled
(defun my-python-hook ()
  ; outline uses this regexp to find headers.
  ; I match lines with no indent and indented "class"
  ; and "def" lines.
  ;(defvar py-outline-regexp "^\\([ \t]*\\)\\(def\\|class\\|if\\|elif\\|else\\|while\\|for\\|try\\|except\\|with\\)"
  ;  "This variable defines what constitutes a 'headline' to outline mode.")
  (setq outline-regexp "[^ \t]\\|[ \t]*\\(def\\|class\\) ")
  ; enable our level computation
  (setq outline-level 'py-outline-level)
  ; do not use their \C-c@ prefix, too hard to type.
  ; Note this overides some python mode bindings
  ;(setq outline-minor-mode-prefix "\C-c")
  ; turn on outline mode
  (outline-minor-mode t)
  ; initially hide all but the headers
  (hide-body)
  ; I use CUA mode on the PC so I rebind these to make the more accessible
  ;(local-set-key [?\C-\t] 'py-shift-region-right)
  ;(local-set-key [?\C-\S-\t] 'py-shift-region-left)
  ; make paren matches visible
  (show-paren-mode 1)
)
;;}}} python end.

;;{{{ makefile-mode ;;;;
(add-hook 'makefile-mode-hook 'imenu-add-menubar-index)
;;}}} makefile-mode ;;;;

;;{{{ Lisp-mode ;;;;
;; 增加一些常用的高亮颜色
(font-lock-add-keywords
'emacs-lisp-mode
'((";" ("\\<\\(GM\\|NB\\|TODO\\|FIXME\\)\\>"  nil nil
         (0 'font-lock-warning-face t)))
   (";" ("[* ]\\*[ \t]*\\(\\w.*\\)\\*" nil nil
         (1 'font-lock-warning-face t)))))

;; (mapcar (function (lambda (elem)
;;                     (add-hook 'emacs-lisp-mode-hook elem)))
;;         '(imenu-add-menubar-index turn-on-eldoc-mode))
;;               ;; checkdoc-minor-mode))

;; lisp 开发用的
(defun my-emacs-lisp-mode-hook-fn ()
  "Function added to `emacs-lisp-mode-hook'."
  (local-set-key "\C-cd" 'my-jump-to-defun)
  ;;(hs-minor-mode 1)
  ;; A little shorter than "Emacs-Lisp".
  ;; Avoid lisp-interaction and other derived modes.
  (if (eq major-mode 'emacs-lisp-mode)
      (setq mode-name "Elisp"))
  (when (boundp 'comment-auto-fill-only-comments)
    (setq comment-auto-fill-only-comments t)
    (kill-local-variable 'normal-auto-fill-function)))

(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook-fn)

(defun my-lisp-interaction-mode-hook-fn ()
  "Function added to `lisp-interaction-mode-hook'."
  (setq mode-name "Lisp Int"))
(add-hook 'lisp-interaction-mode-hook 'my-lisp-interaction-mode-hook-fn)

(setq eval-expression-print-level  10
      eval-expression-print-length 100)

;;}}} Lisp-mode ;;;;

;;{{{ WoMan ;;;;
(setq
 woman-cache-filename (expand-file-name "woman.cache" (concat cfghome ".emacs.d/") )
 woman-bold-headings nil
 woman-imenu-title "WoMan-imenu"
 woman-imenu t
 woman-use-own-frame nil		;不使用单独的frame
 woman-use-topic-at-point nil
 woman-fill-frame nil
 woman-show-log nil)

;;配置一下woman的颜色设置
(defun my-woman-pre-format-fn ()
  "."
  (face-spec-set 'woman-bold-face '((t (:foreground "white" :weight normal))))
  (face-spec-set 'woman-italic-face   '((t (:foreground "yellow"))))
  (face-spec-set 'woman-addition-face '((t (:foreground "orange"))))
  (face-spec-set 'woman-unknown-face  '((t (:foreground "cyan"))))
  ;; TODO can a function know its name?
  (remove-hook 'woman-pre-format-hook 'my-woman-pre-format-fn))

(add-hook 'woman-pre-format-hook 'my-woman-pre-format-fn)

;; So that each instance will pop up a new frame.
;; Maybe `special-display-regexps' would be better?
(add-hook 'woman-post-format-hook (lambda () (setq woman-frame nil)))
;;}}} WoMan ;;;;

;;{{{ eshell ;;;;
;; (defface my-eshell-code-face
;;   '((t (:foreground "Green")))
;;   "Eshell face for code (.c, .f90 etc) files.")

;; (defface my-eshell-img-face
;;   '((t (:foreground "magenta" :weight bold)))
;;   "Eshell face for image (.jpg etc) files.")

;; (defface my-eshell-movie-face
;;   '((t (:foreground "white" :weight bold)))
;;   "Eshell face for movie (.mpg etc) files.")

;; (defface my-eshell-music-face
;;   '((t (:foreground "magenta")))
;;   "Eshell face for music (.mp3 etc) files.")

;; (defface my-eshell-ps-face
;;   '((t (:foreground "cyan")))
;;   "Eshell face for PostScript (.ps, .pdf etc) files.")

;; (setq my-eshell-code-list '("f90" "f" "c" "bash" "sh" "csh" "awk" "el")
;;       my-eshell-img-list
;;       '("jpg" "jpeg" "png" "gif" "bmp" "ppm" "tga" "xbm" "xpm" "tif" "fli")
;;       my-eshell-movie-list '("mpg" "avi" "gl" "dl")
;;       my-eshell-music-list '("mp3" "ogg")
;;       my-eshell-ps-list    '("ps" "eps" "cps" "pdf")
;;       eshell-ls-highlight-alist nil)

;; (let (list face)
;;   (mapcar (lambda (elem)
;;             (setq list (car elem)
;;                   face (cdr elem))
;;             (add-to-list 'eshell-ls-highlight-alist
;;                          (cons `(lambda (file attr)
;;                                   (string-match
;;                                    (concat "\\." (regexp-opt ,list t) "$")
;;                                    file))
;;                                face)))
;;           '((my-eshell-code-list  . my-eshell-code-face)
;;             (my-eshell-img-list   . my-eshell-img-face)
;;             (my-eshell-movie-list . my-eshell-movie-face)
;;             (my-eshell-music-list . my-eshell-music-face)
;;             (my-eshell-ps-list    . my-eshell-ps-face))))

;; (defun my-tidy-pwd (string)
;;   "Replace leading ~ by $HOME in output of pwd.
;; Argument STRING pwd."
;;   (replace-regexp-in-string "^~" (getenv "HOME") string))

;; (defun my-eshell-prompt-function ()
;;   "Return the prompt for eshell."
;;   (format "[%s@%s %s]%s "
;;           (eshell-user-name)
;;           (replace-regexp-in-string "\\..*" "" (system-name))
;;           (eshell/basename (eshell/pwd))
;;           (if (zerop (user-uid)) "#" "$")))

;; (defun my-eshell-line-discard ()
;;   "Eshell implementation of C-u."
;;   (interactive)
;;   (eshell-bol)
;;   (kill-line))


;; (defun my-eshell-clear-buffer ()
;;   "Eshell clear buffer."
;;   (interactive)
;;   (let ((eshell-buffer-maximum-lines 0))
;;     (eshell-truncate-buffer)))

;; (defalias 'eshell/clear 'my-eshell-clear-buffer)


;; (setq eshell-directory-name (expand-file-name "eshell" (concat cfghome ".emacs.d/") )
;;       eshell-pwd-convert-function 'my-tidy-pwd
;;       eshell-prompt-function 'my-eshell-prompt-function
;;       eshell-prompt-regexp "^\\[.*\\][#$] "
;;       eshell-ask-to-save-history 'always
;;       eshell-banner-message `(format-time-string
;;                               "Eshell startup: %T, %A %d %B %Y\n\n"))


;; (defun my-eshell-first-time-mode-hook-fn ()
;;   "Function added to `eshell-first-time-mode-hook'."
;;   (face-spec-set 'eshell-ls-backup-face '((t(:foreground "Goldenrod"))))
;;   (face-spec-set 'eshell-ls-archive-face '((t(:foreground "red" :weight bold))))
;;   (face-spec-set 'eshell-ls-missing-face '((t(:foreground "orchid"))))
;;   ;(define-key eshell-mode-map "\C-ca" 'eshell-bol)
;;   ;(define-key eshell-mode-map "\C-c\C-u" 'my-eshell-line-discard)
;;   (mapcar (lambda (elem)
;;             (add-to-list 'eshell-visual-commands elem))
;;           '("pico" "nano")))

;; (add-hook 'eshell-first-time-mode-hook 'my-eshell-first-time-mode-hook-fn)

;; ;;}}} eshell ;;;;


;;{{{ Shell-mode ;;;;
;;; Prefer terminal-mode really. Eshell even better.
(setq explicit-shell-file-name "bash"
;;;      shell-file-name "/bin/bash"
      ;; Auto-generated variable name.
      explicit-bash-args '("--login")
      comint-scroll-to-bottom-on-input t
      comint-scroll-show-maximum-output t
      comint-scroll-to-bottom-on-output 'all
      comint-input-ignoredups t   ; 1 copy only of identical input
      comint-completion-autolist t
      comint-completion-addsuffix t
      comint-buffer-maximum-size 200    ; lines
      comint-highlight-input nil  ; highlight previous input
      comint-highlight-prompt nil)

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(defun my-shell-mode-hook-fn ()
  "Function added to `shell-mode-hook'."
  ;; M-p by default.
  (define-key shell-mode-map [up] 'comint-previous-input)
  ;; M-n by default.
  (define-key shell-mode-map [down] 'comint-next-input)
  (define-key shell-mode-map [backspace] 'my-shell-backspace))

(add-hook 'shell-mode-hook 'my-shell-mode-hook-fn)

;; Passing with lambda expression not liked.
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

;;}}} Shell-mode ;;;;

;;{{{ 对相应的文件设定相应的模式，以便正确的语法显亮
;;文件名用正则表达式表示，注意不要后面覆盖了前面的而引起的误会
;;修改这个之前先C-h v auto-mode-alist查查已有的设置
;;一个简单的办法设置 auto-mode-alist, 免得写很多 add-to-list
(mapcar
(function (lambda (setting)
        (setq auto-mode-alist
         (cons setting auto-mode-alist))))
'(
   ("\\.\\(xml\\|rdf\\)\\'" . sgml-mode)
   ("\\.\\([ps]?html?\\|cfm\\|asp\\)\\'" . html-helper-mode)
   ("\\.html$" . html-helper-mode)
   ("\\.css\\'" . css-mode)
   ("\\.\\(emacs\\|el\\|session\\|gnus\\)\\'" . emacs-lisp-mode)
   ("\\.wiki\\'" . emacs-wiki-mode)
   ("\\.\\(jl\\|sawfishrc\\)\\'" . sawfish-mode)
   ("\\.scm\\'" . scheme-mode)
   ("\\.py\\'" . python-mode)
   ("\\.\\(ba\\)?sh\\'" . sh-mode)
   ("\\.l\\'" . c-mode)
   ("\\.max\\'" . maxima-mode)
   ;;("\\config" . fvwm-mode)
   ("\\.fvwm2rc$" . fvwm-mode)
   ("\\.fvwmrc$" . fvwm-mode)
   ("\\.strokes$" . fvwm-mode)
   ("\\.conkyrc$" . fvwm-mode)
   ))

;;}}}auto-list-mode

(provide 'jerry-mode)

;;; jerry-mode.el ends here
