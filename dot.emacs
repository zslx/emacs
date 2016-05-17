;;  -*- mode: lisp  -*-
;; 2016-05-17 14:05:03 修改, 上传 github
;; 安装依赖
;; GNU ELPA (M-x list-packages).
;; js2-mode undo-tree

(if (eq system-type 'gnu/linux)
    (progn
      (setq emacs-online "/home/zsl/online/Dropbox/emacs/")
      (setq emacs-local "~/emacs/"))
  (if (eq system-type 'windows-nt)
      (progn
		(setq emacs-online "f:/kuaipan/emacs/git/")
		;; (setq load-path (cons "f:/kuaipan/emacs/win/ccrypt/" load-path))
		;; (setq emacs-local "d:/kuaipan/emacs/loc/")
		(setq emacs-local (concat (expand-file-name "~") "/emacs/")))
    (if (eq system-type 'cygwin)
		(progn
		  (setq emacs-online "/home/CBS/d/kuaipan/emacs/git/")
		  (setq emacs-local "~/emacs/"))
	  )))

;; (defvar emacs-run-name "emacs" "启动emacs的可执行文件名称")
;; (if (eq system-type 'windows-nt)
;;     (let ((emacs-run-name "runemacs.exe")
;; 	  (emacs-bin-path
;; 	   (dolist (v exec-path x)
;; 	     (progn
;; 	       (if (file-exists-p (concat v "/" emacs-run-name))
;; 		   (setq x v)  (message "%S" v))))))

;;       (setq emacs-online (concat emacs-bin-path "/../../git/"))
;;       (setq emacs-local (concat emacs-bin-path "/../../loc/"))
;;       )
;;   )

(unless (file-exists-p emacs-local) (make-directory emacs-local))


;; This is GNU Emacs 24.3.1 (i386-mingw-nt6.1.7601)

;; load-path exec-path
;; 添加到 Windows的 PATH 变量，多个路径用分号分割， "d:/cygwin64/bin"
(if (file-directory-p "c:/cygwin64/bin")
	(progn
	  (add-to-list 'exec-path "c:/cygwin64/bin")
	  (add-to-list 'exec-path "d:/cygwin64/user/sbin")
	  ))

;; (directory-files emacs-online)
(load (concat emacs-online "dircfg.el"))
(load (concat emacs-online "_emacs"))
;; 经常编辑的放在 UbuntuOne.emacs-online 自动同步。
;; 不常变化和不需要各地同步的内容放在 emacs-local, 有改变时用压缩文件通过网盘传递。
;; 加密压缩，emacs 自动解压和压缩。

;; cp ../win/jslint.bat ~/.emacs.d/

(put 'scroll-left 'disabled nil)
(setq-default indent-tabs-mode nil)
