;; Emacs 的配色
;; 我以前的 Emacs 配色非常简单，黑底白字。用的时间长了会腻，而且，Emacs 默认的代码高亮配色只能说相当的一般。
;; (setq default-frame-alist
;;       '((cursor-color . "purple")
;;         (cursor-type . box)
;;         (foreground-color . "white")
;;         (background-color . "black"))
;; 这两天在网上搜 Emacs 相关配置的时候，无意见发现了一个很漂亮的配置。一个好心人用了下 Mac 上的神级编辑器 TextMate。发现里面的 Blackboard 颜色主题很养眼，于是就把这个配色方案写成了一个 color-theme 移到了 Emacs 上，效果相当赞。

;; 我在使用这个主题时做了三处调整

;; 变量声明的颜色改为 绿宝石色，与函数声明的颜色相区别
;; 背景底色由黑板色改为纯黑色，增加对比度
;; 当前行高亮色改为深蓝色（#001），不让它太明显
;; 下面是我调整后的主题：

;; Blackboard Colour Theme for Emacs.
;; Defines a colour scheme resembling that of the original TextMate Blackboard colour theme.
;; To use add the following to your .emacs file (requires the color-theme package):
;;
;; (require 'color-theme)
;; (color-theme-initialize)
;; (load-file "~/.emacs.d/themes/color-theme-blackboard.el")
;;
;; And then (color-theme-blackboard) to activate it.
;;
;; MIT License Copyright (c) 2008 JD Huntington <jdhuntington at gmail dot com>
;; Credits due to the excellent TextMate Blackboard theme
;;
;; All patches welcome

(defun color-theme-blackboard ()
  "Color theme by JD Huntington, based off the TextMate Blackboard theme, created 2008-11-27"
  (interactive)
  (color-theme-install
   '(color-theme-blackboard
     (
      ;; (background-color . "#0C1021")
      (background-color . "black")
      (background-mode . dark)
      (border-color . "black")
      (cursor-color . "#A7A7A7")
      (foreground-color . "#F8F8F8")
      (mouse-color . "sienna1"))
     ;; (default ((t (:background "#0C1021" :foreground "#F8F8F8"))))
     (default ((t (:background "black" :foreground "#F8F8F8"))))
     (blue ((t (:foreground "blue"))))
     (bold ((t (:bold t))))
     (bold-italic ((t (:bold t))))
     (border-glyph ((t (nil))))
     (buffers-tab ((t (:background "#0C1021" :foreground "#F8F8F8"))))
     (font-lock-builtin-face ((t (:foreground "#F8F8F8"))))
     (font-lock-comment-face ((t (:italic t :foreground "#AEAEAE"))))
     (font-lock-constant-face ((t (:foreground "#D8FA3C"))))
     (font-lock-doc-string-face ((t (:foreground "DarkOrange"))))
     (font-lock-function-name-face ((t (:foreground "#FF6400"))))
     (font-lock-keyword-face ((t (:foreground "#FBDE2D"))))
     (font-lock-preprocessor-face ((t (:foreground "Aquamarine"))))
     (font-lock-reference-face ((t (:foreground "SlateBlue"))))
	 
     (font-lock-regexp-grouping-backslash ((t (:foreground "#E9C062"))))
     (font-lock-regexp-grouping-construct ((t (:foreground "red"))))
	 
     (font-lock-string-face ((t (:foreground "#61CE3C"))))
     (font-lock-type-face ((t (:foreground "#8DA6CE"))))
     ;; (font-lock-variable-name-face ((t (:foreground "#FF6400"))))
     (font-lock-variable-name-face ((t (:foreground "#40E0D0"))))
     (font-lock-warning-face ((t (:bold t :foreground "Pink"))))
     (gui-element ((t (:background "#D4D0C8" :foreground "black"))))
     (region ((t (:background "#253B76"))))
     (mode-line ((t (:background "grey75" :foreground "black"))))
     ;; (highlight ((t (:background "#222222"))))
     ;; (highlight ((t (:background "#0C1021"))))
     (highlight ((t (:background "#001"))))
     (highline-face ((t (:background "SeaGreen"))))
     (italic ((t (nil))))
     (left-margin ((t (nil))))
     (text-cursor ((t (:background "yellow" :foreground "black"))))
     (toolbar ((t (nil))))
     (underline ((nil (:underline nil))))
     (zmacs-region ((t (:background "snow" :foreground "ble")))))))

;; 使用的话需要先安装 color-theme 包，将上面的配色存为 color-theme-blackboard.el 放在 emacs 的 load path 中，再加入下面的配置就好了：

;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-blackboard)))

;; 来看看我配置的使用 Consolas + “雅黑”+ blackboard-theme 的 Emacs：
;; 虽说 10 个人会配出 11 种不同的 Emacs，不过我这个还算是芙蓉出水，落落大方吧 

;; 折腾到此结束，“整容”后的 Emacs 更加的漂亮听话了。话说回来，Emacs 实在是要与时俱进，多和苹果学学，改进一下自己难学难用的形象，最好将这些好用的 UI 操作设为默认配置。毕竟对最终用户来说这样的折腾也只能偶尔为之，老是将心思花在配置这神一样的编辑器上面，自己早晚也要成为半仙。
