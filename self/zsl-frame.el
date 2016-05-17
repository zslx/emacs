;; ;; 新开 frame 初始位置和大小
;; (setq default-frame-alist
;; 	  `(
;; 		;; (top . 42)
;; 		;; (left . 42)
;; 		(height . 30)
;; 		(width . 90)
;; 		;; (menu-bar-lines . 0)
;; 		;; (tool-bar-lines . 0)
;; 		))

;; emacs 启动时的 frame 参数
(setq initial-frame-alist
	  '((top . 1) (left . 3) (width . 88) (height . 30)
		))

(require 'desktop-frame) ;;; 窗口布局 frame-window-layout

(require 'frame-cmds)

(require 'window-numbering)
(window-numbering-mode)


;; ;全屏 !== 最大化
;; (defun my-fullscreen ()
;;   (interactive)
;;   (x-send-client-message
;;     nil 0 nil "_NET_WM_STATE" 32
;;     '(2 "_NET_WM_STATE_FULLSCREEN" 0)))

;; (defun my-fullscreen ()
;;   (interactive)
;;   (set-frame-parameter
;;    nil 'fullscreen
;;    (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

;; linux and windows
(defvar my-fullscreen-p t "Check if fullscreen is on or off")

;; (frame-parameters)

(defun my-non-fullscreen ()
  (interactive)
  (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND restore #xf120
	  (w32-send-sys-command 61728)
	(progn (set-frame-parameter nil 'width 82)
		   (set-frame-parameter nil 'fullscreen 'fullheight))
	))

(defun my-fullscreen ()
  (interactive)
  (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND maximaze #xf030
	  (w32-send-sys-command 61488)
	;; (set-frame-parameter nil 'fullscreen 'fullboth)))
	(set-frame-parameter nil 'fullscreen 'maximized)))

(defun my-toggle-fullscreen ()
  (interactive)
  (setq my-fullscreen-p (not my-fullscreen-p))
  (if my-fullscreen-p
	  (my-non-fullscreen)
	(my-fullscreen)))

(let ((df (concat etmp "desktopframe/")))
  (unless (file-exists-p df)(make-directory df)))

(defun zsl-kill-desktop ()
  (desktop-frame-save (concat etmp "desktopframe/") ))
(add-hook 'kill-emacs-hook 'zsl-kill-desktop)


(defun zsl-restore-deskframe ()
  (delete-other-windows)
  (load-file (concat etmp "desktopframe/" frame-layout-basefilename)))

;; (add-hook 'after-init-hook 'zsl-restore-deskframe)
;(add-hook 'desktop-after-read-hook 'zsl-restore-deskframe)

(desktop-read (concat etmp "desktopframe/"))

;;; wcy-desktop.el --- faster than desktop.el and less features.
;; 只保存了文件路径，并且没有真实加载文件
;; (add-to-list 'load-path "/backup/doit/emacs/")
;; (require 'wcy-desktop)
;; (wcy-desktop-init)

;; ;; desktopaid.el
;; (add-to-list 'load-path "/backup/doit/emacs/desktopaid/")
;; (load "desktopaid.el")
;; (setq dta-cfg-dir (concat etmp "desktopaid/"))
;; (setq dta-default-cfg "default.conf")
;; (dta-hook-up)

(provide 'zsl-frame)
