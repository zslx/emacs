;; -*-Emacs-Lisp-*-
;;第一行里面的 -*- Emacs-Lisp -*- 能让 Emacs 打开所有 Emacs Lisp 的编辑特性。Emacs 一般会尝试根据文件名来猜测，有可能猜错。
;;; jerry-basic.el ---
;;公共的基本设置，统统放到一起。

;; C-z 是可以好好利用的一个按键。
;;默认的 Ctrl-z 是 suspend-emacs，在X中极少用到，而且还有 (C-x C-z) suspend-frame
;(define-prefix-command 'ctl-z-map) ;;将 Ctrl-z 作为自定义键绑定的前缀
;(zsl-global-set-key (kbd "C-z") 'ctl-z-map t)

;; "C-c m"是未定义的前缀，要先定义一下
;;(define-prefix-command 'ctl-cm-map)
;;(global-set-key (kbd "C-c m") 'ctl-cm-map)

;;(define-prefix-command 'ctl-ca-map)
;;(global-set-key (kbd "C-c a") 'ctl-ca-map)


;; 防止不小心按到菜单中的 print 时，emacs 死掉
(fset 'print-buffer 'ignore)
(setq lpr-command "")
(setq printer-name "")

;; ;; gnupg easypg 加密 文件加密
;; (if (eq system-type 'windows-nt)
;; 	(custom-set-variables
;; 	 ;; '(epa-file-name-regexp "\\.gpg\\(~\\|\\.~[0-9]+~\\)?\\'")
;; 	 ;; '(epg-gpg-program "c:/Program Files/GNU/GnuPG/pub/gpg2.exe")
;; 	 '(epg-gpg-program "C:/Program Files (x86)/GNU/GnuPG/pub/gpg2.exe")
;; 	 ))

;; 总是使用对称加密，不要用户选择邮件
;; (setq epa-file-encrypt-to nil)
;; 每次修改保存都要输入两次密码！！！
;; (setq epa-file-cache-passphrase-for-symmetric-encryption t)
;; auto-save
;; (setq epa-file-inhibit-auto-save nil)

;; ps-ccrypt.el 另一个加密方法
;; (require 'ps-ccrypt)

;;emacsclient file      在主框架中编辑。
;;emacsclient -t [file] 在Terminal中启动
;;emacsclient -c [file] 在GUI中启动

;; 从 B 上使用 A 上的 emacs server
;(setq server-host "192.168.1.89") ;use ip or host name
;(setq server-use-tcp t) ; listen tcp , not local socket
;; check file ~/.emacs.d/server/server
;; copy server file from host A to host B
;; scp ~/.emacs.d/server/server user@B:
;; ssh user@B
;; 2 On host B:
;; $ emacsclient -c -f server ;界面出现在A上！！ xhost+ssh_X DISPLAY

;;(server-mode t)
;; (server-start)

;; (mapcar (lambda (e) (insert "\n" (format "%S" e))) (frame-parameters))

;;;外观设置
(global-hl-line-mode 1) ;; highlight current line
;; (set-face-background 'hl-line "#222222") ;"#310"
;(set-face-background 'hl-line "#347")

;;;去掉工具栏
(tool-bar-mode -1)
;;;将F10绑定为显示菜单栏，万一什么东西忘了,菜单栏可以摁F10调出，再摁F10就去掉菜单
;(menu-bar-mode -1)
;;不要滚动栏，现在都用滚轴鼠标了
;; (scroll-bar-mode nil) < v24.1
(scroll-bar-mode 0)

;;所有的问题用y/n方式，不用yes/no方式。有点懒，只想输入一个字母
(fset 'yes-or-no-p 'y-or-n-p)

;;修改中文文本的行距,3个象素就可以了吧
(setq-default line-spacing 3)


;; mode-line-format
;;在minibuffer上面可以显示列号,行号
(column-number-mode t)
;(line-number-mode t)

;; ;;时间显示设置
;; (setq display-time-24hr-format t) ;;使用24小时制
;; (setq display-time-day-and-date t) ;;显示包括日期和具体时间
;; ;;(setq display-time-format "%H:%M %A%m月%d日") ;;显示时间的格式
;; (setq display-time-format "%A %m%d") ;;显示时间的格式

;; ;;(display-time-mode 1)
;; (display-time) ;; 不知为什么，有时这里执行不起作用，所以放到 .emacs 里


;;改变emacs标题栏的标题,显示buffer的名字
;(setq frame-title-format "%f %I %i")
(setq frame-title-format
	  (list '(:eval (if (buffer-file-name) (buffer-file-name) (buffer-name))) " %I %i"))
;(setq frame-title-format (list "%f %p %I " '(:eval (number-to-string (point)))) )

;(setq mlf_bk mode-line-format)
;; (setq mode-line-format
;; (list "%p(%l %c)" '(:eval (number-to-string (point))) ) )
;; (setq mode-line-format mlf_bk)

;;显示默认的文档的宽度，看起来比较舒服？ latex90分钟介绍里说66是最大限度,看来不错.
;(setq default-fill-column 100)

;; 不用 TAB 字符来indent, 这会引起很多奇怪的错误。编辑 Makefile 的时候也不用担心，
;; makefile-mode 会把 TAB 键设置成真正的 TAB 字符，并且加亮显示的。
;; dont use tabs for indenting 不用 TAB 来缩进，只用空格。
;; (setq-default indent-tabs-mode nil)
;; (setq-default tab-width 3)

(setq default-tab-width 4)
(setq tab-stop-list ())
;(loop for x downfrom 40 to 1 do
;	  (setq tab-stop-list (cons (* x 4) tab-stop-list)))

;; Save files in DOS mode
;; (setq-default buffer-file-coding-system 'raw-text-dos)

;;使用M-x color-theme-select 可以选择配色方案，在配色方案上按I 改变当前frame的配色
;;按i 改变所有frame的配色,按p 把当前配色方案的lisp打印出来，加入你的.emacs，
;;可以不用加载color-theme了，这样可以加快起动速度
(require 'color-theme)
;;; include "emacs-goodies-el"
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
	 ;; (load "color-theme-blackboard.el")
     ;; (color-theme-blackboard)
	 (color-theme-arjen)				;两个 color theme 的设置叠加了
	 ;; (color-theme-tty-dark) ;;蓝色太刺眼
	 ;; (color-theme-gnome2)
	 ;; (color-theme-charcoal-black)
	 ;; (color-theme-pierson) ;; 绿色太亮
	 ;; (color-theme-comidia)
	 ;; (color-theme-billw)
	 ;; (color-theme-charcoal-black)
	 ;; (color-theme-calm-forest)
	 ))

;; 行为设定
;;光标指针不要闪，我得眼睛花了
(blink-cursor-mode -1)
;(transient-mark-mode 1) ;;it will highlight the Active Region, default since 23

;;当指针到一个括号时，自动显示所匹配的另一个括号
(show-paren-mode 1)
;;去掉烦人的警告铃声 ,没有提示音，也不闪屏 (setq ring-bell-function 'ignore)
;(setq visible-bell nil)

;;当鼠标移动的时候自动转换frame，window或者minibuffer
;(setq mouse-autoselect-window t)

;;当寻找一个同名的文件，改变两个buffer的名字,前面加上目录名
;(setq uniquify-buffer-name-style 'forward)

;;滚动页面时比较舒服，不要整页的滚动；设置后有问题，还是用C-x z*来重复M-n C-l吧
;(setq scroll-step 1 scroll-margin 2 scroll-conservatively 10000)

;;可以操作压缩文档
;(auto-compression-mode 1)

;;使用C-k删掉point到行末的所有东西,包括换行符
(setq-default kill-whole-line t)
;;设定删除保存记录为200，可以方便以后无限恢复
(setq kill-ring-max 200)

;;自动重载更改的文件
;(global-auto-revert-mode 1)

;; 在退出 emacs 之前确认是否退出
(setq confirm-kill-emacs 'yes-or-no-p)

;;备份设置 ，默认在~/.emacs.d/auto-save-list里，参见"Sams teach yourself emacs in 24hours"
;; (setq make-backup-file t)
(setq
 backup-by-copying t
 backup-directory-alist `(("." . ,(concat etmp "backups/")))
 version-control t
 delete-old-versions t
 kept-new-versions 6 ; 保留最近的6个备份文件
 kept-old-versions 2 ; 保留最早的2个备份文件
 )

;; hippie-expand 补全方式是一个优先列表，优先使用表最前面的函数来补全
;; 先用当前 buffer补全，找不到，就到别的可见窗口里寻找，还找不到，那么到所有打开的buffer去找，到kill-ring，到文件名，到简称列表里，到list,...
;; 当前使用的匹配方式会在 echo 区域显示
(setq hippie-expand-try-functions-list
	  '(
	    ;; senator-try-expand-semantic ;;;优先调用了senator的分析结果-很慢
        try-expand-dabbrev          ;;; 搜索当前 buffer
		try-expand-dabbrev-visible  ;;; 搜索当前可见窗口
		try-expand-dabbrev-all-buffers ;;; 搜索所有 buffer
		try-expand-dabbrev-from-kill   ;;; 从 kill-ring 中搜索
		try-complete-file-name           ;;; 文件名匹配
		try-complete-file-name-partially ;;; 文件名部分匹配
		try-expand-all-abbrevs
		try-expand-list         ;;; 补全一个列表
        ;; try-expand-list-all-buffers
		try-expand-line         ;;; 补全当前行 ，补全整行文字。
        ;; try-expand-line-all-buffers
		;; try-expand-line-all-buffers
		try-complete-lisp-symbol-partially ;;; 部分补全 elisp symbol
		try-complete-lisp-symbol ;;; 补全 lisp symbol
		;; try-expand-whole-kill
 		)
      )
;; (global-set-key (kbd "M-?") 'hippie-expand)
;; (global-set-key (kbd "M-/") 'dabbrev-expand)

;;;启用部分补全功能，如输入M-x q r r相当于M-x query-replace-regexp
;(partial-completion-mode 1)
;;;在minibuffer里启用自动补全函数和变量 ;(icomplete-mode 1)

;;时间戳设置(time-stamp)
;;只要里在文档里有Time-stamp:的设置，就会自动保存时间戳
;;启用time-stamp
;(setq time-stamp-active t)
;;去掉time-stamp的警告？
;(setq time-stamp-warn-inactive t)
;;设置time-stamp的格式，我如下的格式所得的一个例子：
;(setq time-stamp-format "%:u %02m/%02d/%04y %02H:%02M:%02S")
;;将修改时间戳添加到保存文件的动作里。
;(add-hook 'write-file-hooks 'time-stamp)

;;;将默认模式从fundemental-mode改为text-mode ;
(setq default-major-mode 'text-mode)
;; (setq default-major-mode 'emacs-lisp-mode)
;; (setq default-major-mode 'lisp-interaction-mode)

;; 允许minibuffer自由变化其大小 （指宽度）
;; (setq resize-mini-windows t)

;;鼠标自动避开指针，如当你输入的时候，指针到了鼠标的位置，鼠标有点挡住视线了
;(mouse-avoidance-mode 'animate)

;;允许自动打开图片，如wiki里面
;(auto-image-file-mode t)

;;设定句子结尾，主要是针对中文设置
;(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
;(setq sentence-end-double-space nil)

;;当指针移到另一行，不要新增这一行？
;(setq next-line-add-newlines nil)
;;在文档最后自动插入空白一行，好像某些系统配置文件是需要这样的
;(setq require-final-newline t)
;(setq track-eol t)

;;增大使用查找函数和变量的寻找范围 ;(setq apropos-do-all t)
;;使用aspell程序作为Emacs的拼写检查程序 ;;没有aspell的字典，还是用ispell吧
;(setq-default ispell-program-name "ispell")

;; 允许emacs和外部其他程序的粘贴, 是 default?
;; (setq x-select-enable-clipboard t)

;; ;;把这些缺省禁用的功能打开。
;; (put 'set-goal-column 'disabled nil)
;; (put 'narrow-to-region 'disabled nil) ; C-x n n
;; (put 'LaTeX-hide-environment 'disabled nil)
;;(put 'scroll-left 'disabled nil)

;;可以递归的使用 minibuffer
;(setq enable-recursive-minibuffers t)

;;Save bookmarks file each time a bookmark is added, not just on exit.
(setq bookmark-save-flag 1)

;; narrow功能, 隐藏和显示不需要的部分： "C-x n n" narrow-to-region,"C-x n w" widen.
;(put 'narrow-to-region 'disabled nil) ;; C-x nn, C-xnw

;;custome的风格改为单一的树状风格 ;(setq custom-buffer-style 'brackets)
;;发送mail的时候使用fortune添加amuses ;(add-hook 'mail-setup-hook 'spook)

;; ;; M-x set-input-method, C-\ toggle-input-method
;; (add-to-list 'load-path (concat elib "eim"))
;; (autoload 'eim-use-package "eim" "Another emacs input method")
;; (setq eim-use-tooltip nil) ;; Tooltip 暂时还不好用

;; ;(register-input-method "eim-wb" "euc-cn" 'eim-use-package  "五笔" "汉字五笔输入法" "wb.txt")
;; (register-input-method "eim-py" "euc-cn" 'eim-use-package  "拼音" "汉字拼音输入法" "py.txt")
;; 用 ; 暂时输入英文
;(require 'eim-extra)
;(global-set-key ";" 'eim-insert-ascii)
;(set-input-method "eim-py")

;; ;; 远程编辑 tramp
;; (setq tramp-default-method "ssh")
;; (setq tramp-default-user "zsl")
;; (setq tramp-default-host "192.168.1.10")

;; set case sensitive
;(setq case-fold-search nil)

;(put 'dired-find-alternate-file 'disabled nil)
;(put 'upcase-region 'disabled nil)

;; ffip: find file in project
;; (autoload 'find-file-in-project "find-file-in-project" "Find file in project." t)

;; (appt-activate 3)						;事不过三
;; 开启约会提醒功能

;; (appt-check)
;; (appt-add "17:50" "事不过三")
;; (appt-delete)
;; (org-agenda-to-appt)

(provide 'jerry-basic)

;;; jerry-basic.el ends here
