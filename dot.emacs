;;  -*- mode: lisp  -*-
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

;; (defvar emacs-run-name "emacs" "����emacs�Ŀ�ִ���ļ�����")
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
;; ��ӵ� Windows�� PATH ���������·���÷ֺŷָ "d:/cygwin64/bin"
(if (file-directory-p "c:/cygwin64/bin")
	(progn
	  (add-to-list 'exec-path "c:/cygwin64/bin")
	  (add-to-list 'exec-path "d:/cygwin64/user/sbin")
	  ))

;; (directory-files emacs-online)
(load (concat emacs-online "dircfg.el"))
(load (concat emacs-online "_emacs"))
;; �����༭�ķ��� UbuntuOne.emacs-online �Զ�ͬ����
;; �����仯�Ͳ���Ҫ����ͬ�������ݷ��� emacs-local, �иı�ʱ��ѹ���ļ�ͨ�����̴��ݡ�
;; ����ѹ����emacs �Զ���ѹ��ѹ����

;; cp ../win/jslint.bat ~/.emacs.d/

(put 'scroll-left 'disabled nil)
(setq-default indent-tabs-mode nil)
