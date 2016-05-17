;; Fonts setting

;; 1 通过配置文件设置 =======================================================
;;中文字体设定,这里是一部分，还在.Xresources中有，
;; (describe-font "DejaVu Sans Mono")

;; 喜欢大字体16。这个pixelsize大多数人是设成13吧
;; (set-default-font "DejaVu Sans Mono:pixelsize=15")
;; 中文字体的设定
;; (set-fontset-font (frame-parameter nil 'font) 'unicode '("WenQuanYi Bitmap Song" . "unicode-bmp"))
;; (set-fontset-font (frame-parameter nil 'font) 'han '("WenQuanYi Bitmap Song" . "unicode-bmp"))

;;~/.Xresources中关于emacs的字体设置的部分，或 .Xdefaults
;;!! Emacs 23 font set
;;Emacs.FontBackend: xft
;;Emacs.font: DejaVu Sans Mono:pixelsize=16

;; 2 通过函数设置 ==========================================================
;; `C-x C-=' `C-x C--' text-scale-adjust
;; 设置两个字体变量，一个中文的一个英文的
;; 之所以两个字体大小是因为有的中文和英文相同字号的显示大小不一样，需要手动调整一下。

;; (setq cjk-font-size 16)
;; (setq ansi-font-size 16)

;; 设置一个字体集，用的是create-fontset-from-fontset-spec内置函数
;; 中文一个字体，英文一个字体混编。显示效果很好。
(defun set-font()
  (interactive)
  (create-fontset-from-fontset-spec
   (concat
    "-*-fixed-medium-r-normal-*-*-*-*-*-*-*-fontset-myfontset," 
    (format "ascii:-outline-Consolas-normal-normal-normal-mono-%d-*-*-*-c-*-iso8859-1," ansi-font-size)

    (format "unicode:-microsoft-Microsoft YaHei-normal-normal-normal-*-%d-*-*-*-*-0-iso8859-1," cjk-font-size)
    (format "chinese-gb2312:-microsoft-Microsoft YaHei-normal-normal-normal-*-%d-*-*-*-*-0-iso8859-1," cjk-font-size)

    ;; (format "unicode:-outline-文泉驿等宽微米黑-normal-normal-normal-sans-*-*-*-*-p-*-gb2312.1980-0," cjk-font-size)
    ;; (format "chinese-gb2312:-outline-文泉驿等宽微米黑-normal-normal-normal-sans-*-*-*-*-p-*-gb2312.1980-0," cjk-font-size)
    )))

;; 函数字体增大，每次增加2个字号，最大48号
(defun increase-font-size()
  "increase font size"
  (interactive)
  (if (< cjk-font-size 48)
      (progn
        (setq cjk-font-size (+ cjk-font-size 2))
        (setq ansi-font-size (+ ansi-font-size 2))))
  (message "cjk-size:%d pt, ansi-size:%d pt" cjk-font-size ansi-font-size)
  (set-font)
  (sit-for .5))

;; 函数字体增大，每次减小2个字号，最小2号
(defun decrease-font-size()
  "decrease font size"
  (interactive)
  (if (> cjk-font-size 2)
      (progn 
        (setq cjk-font-size (- cjk-font-size 2))
        (setq ansi-font-size (- ansi-font-size 2))))
  (message "cjk-size:%d pt, ansi-size:%d pt" cjk-font-size ansi-font-size)
  (set-font)
  (sit-for .5))

;; 恢复成默认大小16号
(defun default-font-size()
  "default font size"
  (interactive)
  (setq cjk-font-size 16)
  (setq ansi-font-size 16)
  (message "cjk-size:%d pt, ansi-size:%d pt" cjk-font-size ansi-font-size)
  (set-font)
  (sit-for .5))

;; 只在GUI情况下应用字体。Console时保持终端字体。
(if (and window-system nil)
    (progn
      (set-font)
      ;; 把上面的字体集设置成默认字体
      ;; 这个字体名使用是create-fontset-from-fontset-spec函数的第一行的最后两个字段
      ;; (set-frame-font "fontset-myfontset")
      (set-frame-font "-fontset-myfontset")

      ;; 鼠标快捷键绑定
      (global-set-key '[C-wheel-up] 'increase-font-size)
      (global-set-key '[C-wheel-down] 'decrease-font-size)
      ;; 键盘快捷键绑定
      ;; (global-set-key (kbd "C--") 'decrease-font-size) ;Ctrl+-
      ;; (global-set-key (kbd "C-0") 'default-font-size)  ;Ctrl+0
      ;; (global-set-key (kbd "C-=") 'increase-font-size) ;Ctrl+=
      ))

;; 3 自动设置 autosfont ===================== new good font set =================
;; 自动选择字体
;; 我想要的功能是：如果系统有雅黑字体，就用雅黑，否则（如 Linux 系统上默认没有雅黑）用开源字体文泉驿微米黑。

;; 首先，要能判断某个字体在系统中是否安装
(defun qiang-font-existsp (font) (if (null (x-list-fonts font)) nil t))

;; 其次，要按顺序找到一个字体列表（list）中第一个已经安装可用的字体，下面是个例子：
;; (defvar font-list '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体"))
;; (require 'cl) ;; find-if is in common list package
;; (find-if #'qiang-font-existsp font-list)

;; 还要有个辅助函数，用来产生带上 font size 信息的 font 描述文本：
(defun qiang-make-font-string (font-name font-size)
  (if (and (stringp font-size)
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s %s" font-name font-size)))
;; 这里绕的地方是，如果传入的 font-size 是“:pixelsize=18”这样的话，字体名称和它之间不能有空格。如果是普通的数字的话（12 或“12”），需要有个空格分隔字体名称和字体大小。

;; 有了这些函数，下面出场的就是自动设置字体函数了：
(defun qiang-set-font (english-fonts english-font-size
                       chinese-fonts &optional chinese-font-size)
  
  "english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-size to nil, it will follow english-font-size"
  (require 'cl) ;; for find-if ;; find-if is in common list package
  (let ((en-font (qiang-make-font-string
                  (find-if #'qiang-font-existsp english-fonts)
                  english-font-size))
        (zh-font (font-spec :family (find-if #'qiang-font-existsp chinese-fonts)
                            :size chinese-font-size)))
	
    ;; Set the default English font
    ;; The following 2 method cannot make the font settig work in new frames.
    ;; (set-default-font "Consolas:pixelsize=18")
    ;; (add-to-list 'default-frame-alist '(font . "Consolas:pixelsize=18"))
    ;; We have to use set-face-attribute
    (message "Set English Font to %s" en-font)
    (set-face-attribute 'default nil :font en-font)
	
    ;; Set Chinese font
    ;; Do not use 'unicode charset, it will cause the English font setting invalid
    (message "Set Chinese Font to %s" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset zh-font))))

;; 利用这个函数，Emacs 字体设置就是小菜一碟了：
(qiang-set-font
 '("Consolas" "Monaco" "DejaVu Sans Mono" "Monospace" "Courier New") ":pixelsize=16"
 '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体"))

;; 这样 Emacs 会优先选用 Consolas + “雅黑”的组合。如果“雅黑”没有装的话，就使用“文泉驿等宽微米黑”，依此类推。
;; 这份字体配置不用改动就能在不同的操作系统字体环境下面使用，相信应该没有其它编辑器有这么变态的后备字体列表设置了吧。
;; 至此，Emacs 在字体设置这方面总算是“体面”地稍稍胜出了其它编辑器。把上面的三个函数加到配置文件 .emacs 里赶快看看效果吧。
