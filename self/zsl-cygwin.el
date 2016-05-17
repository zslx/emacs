;; 在系统的环境变量(我的电脑->属性->高级->环境变量  系统变量)中加入
;; CYGWIN=nodosfilewarning 变量即可.

;; (setq shell-file-name "bash")
;; (setq explicit-shell-file-name shell-file-name)

;; (cond ((eq window-system 'w32)
;; 	   (setq tramp-default-method "scpx"))
;; 	  (t
;; 	   (setq tramp-default-method "scpc")))


;; Put in your .emacs or site-start.el file the following lines:
(require 'cygwin-mount)
;; 可直接使用 linux 格式的路径
(cygwin-mount-activate)
