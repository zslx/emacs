;; ��ϵͳ�Ļ�������(�ҵĵ���->����->�߼�->��������  ϵͳ����)�м���
;; CYGWIN=nodosfilewarning ��������.

;; (setq shell-file-name "bash")
;; (setq explicit-shell-file-name shell-file-name)

;; (cond ((eq window-system 'w32)
;; 	   (setq tramp-default-method "scpx"))
;; 	  (t
;; 	   (setq tramp-default-method "scpc")))


;; Put in your .emacs or site-start.el file the following lines:
(require 'cygwin-mount)
;; ��ֱ��ʹ�� linux ��ʽ��·��
(cygwin-mount-activate)
