
;; emacsִ�г���Դ�롢�������ı�����ú���չ�� bin,src,modes
;; emacs-local emacs-online
;; 
;; elib   �Լ���װ��ģ��
;; etmp    ʹ���в��������ݣ����뱸��
;; 
;; edatas  ʹ��emacs������ļ���Ҫ����
;; eprojs  ͳһ��� project �ļ��ĵط� zsl-project.el

;; emacs-online, emacs-local in .emacs
(setq edatas (concat emacs-online "edatas/"))
(setq olisp (concat emacs-online "other/"))
(setq zlisp (concat emacs-online "self/"))
(setq elib (concat emacs-online "lib/"))

(setq etmp (concat emacs-local "etmp/"))
(setq eprojs (concat emacs-local "eprojs/"))

(unless (file-exists-p etmp)(make-directory etmp))
(unless (file-exists-p eprojs)(make-directory eprojs))

(add-to-list 'load-path elib)
(add-to-list 'load-path olisp)
(add-to-list 'load-path zlisp)

(defun add2load_path (base path) (add-to-list 'load-path (concat base path)))

;; ;; load-path exec-path
;; ;; ��ӵ� Windows�� PATH ���������·���÷ֺŷָ "d:/cygwin64/bin"
;; (if (file-directory-p "c:/cygwin64/bin")
;; 	(progn
;; 	  (add-to-list 'exec-path "c:/cygwin64/bin")
;; 	  ;; (add-to-list 'exec-path "d:/cygwin64/user/sbin")
;; 	  ))

;(setq load-path (cons (concat elib "xcscope")  load-path))

;(when (eq system-type 'gnu/linux)
;  (setq load-path (cons "/usr/local/share/gtags" load-path)))

;; find file in project
;(add2load_path "libs/ffip")

;; �༭����� html php js �ȴ�����ļ�
(add2load_path elib "multi-web-mode")
;; (add2load_path "php")

;; emacs source code
;; (setq find-function-C-source-directory (concat emacs-online "../emacs-24.3/src"))

(defvar zsl-emacs-projects-dir eprojs)
;; ================= end of path setting ===========================
