;; 第一个使用的输入法
;;Library of Emacs Input Method
;; M-x set-input-method, C-\ toggle-input-method

; (add2load_path "leim") ;include emacs

;; Begin 2016-05-26 22:34:32 
(add-to-list 'load-path "~/github/emacs-eim")
(autoload 'eim-use-package "eim" "Another emacs input method")
;; Tooltip 暂时还不好用
(setq eim-use-tooltip nil)
(register-input-method "eim-py" "euc-cn" 'eim-use-package "拼音" "汉字拼音输入法" "py.txt")

;; ;; 用 ; 暂时输入英文
;; (require 'eim-extra)
;; (global-set-key ";" 'eim-insert-ascii)

;; End  2016-05-26 22:34:37

;; 第二个使用的输入法, linux 下集成操作系统的输入法，缺点是占用了 C-space
;; ibus

;; (add-to-list 'load-path "/backup/doit/emacs/ibus-el-0.3.0/")
;; (require 'ibus)
;; (add-hook 'after-init-hook 'ibus-mode-on)
;; (setq ibus-agent-file-name "/backup/doit/emacs/ibus-el-0.3.0/ibus-el-agent")

;; ;; Use C-SPC for Set Mark command
;; (ibus-define-common-key ?\C-\s nil)
;; ;; Use C-/ for Undo command
;; (ibus-define-common-key ?\C-/ nil)

;; (setq ibus-cursor-color '("red" "blue" "limegreen"))
;; If you use thumb shift input method, you have to specify the
;; (setq ibus-ibus-simultaneous-pressing-time 0.1)

;; 这一段有错误，注释掉就可以用了;
;; Error:'IBusELInputContext' object has no attribute 'needs_surrounding_text'.
;; # if use_surrounding_text and pressed != False \
;; #         and ic.needs_surrounding_text() and not ic.surrouding_text_received:
;; #     print '(ibus-query-surrounding-text-cb %d %d ?\\x%x "%s" "%s")'% \
;; #         (id_no, keyval, modmask, backslash, pressed)
;; #     return 

(provide 'zsl-eim)
