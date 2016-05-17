;;; jerry-folding.el --- folding mode的配置 , 需要改变注释风格，所以使用 outline 不使用这个插件
;;当编辑很大一段代码的时候，折叠起来或许更好一些
;;小知识：autoload和load相比，前者是在emacs启动时只加载这个函数名而已，也就是让Emacs知道有这个函数。

;;(autoload 'folding-mode "folding"  "Minor mode that simulates a folding editor" t)
;;(autoload 'turn-off-folding-mode "folding" "Folding mode" t)
;;(autoload 'turn-on-folding-mode  "folding" "Folding mode" t)

;; (setq folding-default-keys-function 'folding-bind-backward-compatible-keys)

;;;(load-library  "folding")
;;(if (load "folding" 'nomessage 'noerror) (folding-mode-add-find-file-hook))

;;;;设定各个模式下，折叠的具体内容和方式
;; (folding-add-to-marks-list 'c++-mode "//<" "//>" "")
;; (folding-add-to-marks-list 'lisp-mode ";;{{{" ";;}}}" "")
;; (folding-add-to-marks-list 'html-mode "<!-- { " "<!-- } -->" "-->")
;; (folding-add-to-marks-list 'sh-mode "# {{{ " "# }}}" nil)

;; Tutorial
;;      To enter a fold, use `C-c @ >'. To show it without entering,
;;      use `C-c @ C-s', which produces this display:

;;      To show everything, just as the file would look like if
;;      Folding mode hadn't been activated, give the command `M-x'
;;      `folding-open-buffer' `RET', normally bound to `C-c' `@'
;;      `C-o'.  To close all folds and go to the top level, the
;;      command `folding-whole-buffer' could be used.

(provide 'jerry-foldinging)

;;; jerry-folding.el ends here
