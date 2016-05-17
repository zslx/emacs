;;  -*- mode: lisp  -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Shenglin zhu's dotemacs file
;;; Last modified time
;;; Time-stamp: <zsl 12/11/2008 17:41:18>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;以上是time stamp，后面将有详细说明

;;设置书签文件，默认~/.emacs.bmk，把emacs的文件尽量放在一个文件夹，方便管理。
(setq bookmark-default-file (concat edatas system-name "-" user-login-name "-" (format-time-string "%Y-%m" (current-time)) "-emacs.bmk"))

;; 设置 custom-file, 用 M-x customize 定义的变量和 Face 会写入到这个文件中
(setq custom-file (concat emacs-local "zsl-custom.el"))
(if (file-exists-p custom-file)
    (load custom-file) ;; 必须执行才有效    
  (write-file custom-file))

;;配置文件很长，按类分别放在不同的文件里，方便管理
(load "zsl-info.el")
(load "zsl-fonts.el")
(load "zsl-functions")
(load "jerry-basic")
;; (load "zsl-async-process.el")
(require 'zsl-frame)
;(load "zsl-cygwin.el")

(require 'undo-tree)
(global-undo-tree-mode)
;; C-_  C-/  (`undo-tree-undo');;   Undo changes.
;; M-_  C-?  (`undo-tree-redo');;   Redo changes.
;; C-x u  (`undo-tree-visualize');;   Visualize the undo tree.
;;   (Better try pressing this button too!)


;; M-x ido一样提示
(load "smex")
(smex-initialize)

;;(load "jerry-dired")
(ido-mode t)
;; 提示列表的长度
(setq ido-max-prospects 60)

;; ido - interactively do things with buffers and files
;; (require 'anything-config)
;; anything - open anything / QuickSilver-like candidate-selection framework
;; anything 的基本能力跟 ido 很类似，也是列举备选项供用户选择，差异在于:
;; 1 用一个临时buffer来列举备选项，每行一个（而ido是在minibuffer中）
;; 2 缺省不改变find-file, switch-buffer 等命令的行为，而是用单独的命令激活(比如M-x anything-find-files或者<f5> a C-x C-f ）
;; 3 匹配备选项时支持多个关键字（用空格隔开）
;; 4 有不少地方是先选择被操作的内容，然后选择操作，比如M-x anything-find-files 是先列举文件供选择，按<tab>后再选操作(打开文件、比较文件、拷贝/删除/复制文件、转到dired中查看、将eshell转到相应目 录等等）
;; 5 自带了很多source，也就是选择/补全之上要完成的具体功能，不仅仅有切换buffer, 打开文件, recentf, kill-ring, imenu这些编辑器相关的内容，还有apt, gentoo, world-time, firefox-bookmarks等方面的功能

(require 'unicad) ;auto detect code

;; (require 'zsl-auto-complete)
(require 'zsl-vim)

;; (when (eq system-type 'gnu/linux)
;;   (progn
;; 	(require 'zsl-eim) ;; emacs input method
;; 	(load "zsl-sdcv.el") ;; 查词典
;; 	;;   (require 'jerry-cedet)
;; 	;;	 (load "zsl-cxx-mode")
;; 	))

;(load "zsl-cxx-mode")
(load "zsl-webdev")
;; php-mode

;; ;; Project Management for Emacs
;; (load "zsl-project-cmd.el")
;; (load "zsl-project-tree.el")

;; (require 'jerry-org)
;; (load "zsl-gtd.el")			;get things done

;; (require 'ps-ccrypt "ps-ccrypt.el")

;; (require 'init-hideshow)

(when (fboundp 'winner-mode) (winner-mode 1)) ;窗口布局的 undo redo : C-f1 C-f2
;; 例如，有三个窗口，现在要其中一个全屏查看，之后再回复这三个窗口。

;; Session Management for Emacs, 必须放在最后

(load "jerry-key-bindings") ;;; 最后执行,防止被重置; 首先执行，看看哪些键冲突,是另一种策略

;; 等一会儿再执行才可
(setq timer1
	  (run-with-idle-timer
	   1 nil (lambda ()
			   (progn
				 (my-toggle-fullscreen)
				 (cancel-timer timer1)
				 ))))
;; (message "%S" timer1)
;; end of .emacs
