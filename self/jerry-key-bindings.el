;;; jerry-key-bindings.el --- 全局键盘绑定设置
;; 原则 1
;; 键配置都放到这里，最后加载，不会被前面加载的插件所干扰;还是会被动态加载的模式所覆盖，例如，在次模式的hook里定义的 keybinding
;; 原则 2
;; 尽量不覆盖默认的键绑定，除非明确知道不好用的。 C-h r : Key (Character) Index 查看 emacs 默认 keybindings
;; 原则 3
;; 模式相关的 keybindings 用 local-set-key 放在各自的 mode-xyz.el 中。
;; 先用 "C-h c" 看一下 keys 是否已经绑定了函数，然后放在 “默认”和“新定义”两个组中
;; isearch-forward-regexp : f[0-9]\{1,2\}
;; 原则 4
;; 经常整理，保证有效和常用

;; Keybinding Conventions 约定俗成
;; C-x ... is often something to do with controlling Emacs itself (buffers, windows)
;; C-c ... is often something to do with a major mode (i.e. not core Emacs)
;; C-h ... is always help
;; M-... is usually like a C-... binding, but bigger or more unusual (or sometimes opposite). 更大 or 与众不同的 or 相反的
;; C-u [some other keybinding] usually means, “do the other keybinding but ask for the required argument”
;; C-u can also accept a numerical argument and have the following keybinding repeat
;; C-c C-c is usually send, post, store..
;; ================================================
;; <C-x C-w> To write the content of a buffer to a different file.
;; <M-%> (query-replace) to begin replacing text. y,n,!,q.
;; <M-x org-info RET>

;; How to Define Keyboard Shortcuts in Emacs
;; 1) Single Modifier Key
;; Example of shortcuts with a single modifier key:
;; (global-set-key (kbd "M-a") 'cmd) ; Meta+a,Alt-a
;; (global-set-key (kbd "C-a") 'cmd) ; Ctrl+a

;; 2) Function keys and Special keys
;; (global-set-key (kbd "<f2>")   'cmd)   ; F2 key
;; (global-set-key (kbd "<kp-2>") 'cmd)   ; the “2” key on the number keypad

;; (global-set-key (kbd "<insert>") 'cmd) ; the Ins key
;; (global-set-key (kbd "<delete>") 'cmd) ; the Del key
;; (global-set-key (kbd "<home>") 'cmd)
;; (global-set-key (kbd "<end>") 'cmd)
;; (global-set-key (kbd "<next>") 'cmd)   ; page down key
;; (global-set-key (kbd "<prior>") 'cmd)  ; page up key 

;; (global-set-key (kbd "<left>") 'cmd)   ; ←
;; (global-set-key (kbd "<right>") 'cmd)  ; →
;; (global-set-key (kbd "<up>") 'cmd)     ; ↑
;; (global-set-key (kbd "<down>") 'cmd)   ; ↓

;; (global-set-key (kbd "RET") 'cmd) ; the Enter/Return key
;; (global-set-key (kbd "SPC") 'cmd) ; the Space bar key

;; 3) Modifier + Special Key
;; (global-set-key (kbd "M-<f2>") 'cmd) ; Meta+F2
;; (global-set-key (kbd "C-<f2>") 'cmd)  ; Ctrl+F2
;; (global-set-key (kbd "S-<f2>") 'cmd)  ; Shift+F2

;; (global-set-key (kbd "M-<up>") 'cmd)  ; Meta+↑
;; (global-set-key (kbd "C-<up>") 'cmd)  ; Ctrl+↑
;; (global-set-key (kbd "S-<up>") 'cmd)  ; Shift+↑

;; 4) Two Modifier Keys
;; Example of shortcuts with 2 modifier keys pressed simultaneously, plus a letter key:
;; (global-set-key (kbd "M-A") 'cmd) ; Meta+Shift+a
;; (global-set-key (kbd "C-A") 'cmd) ; Ctrl+Shift+a
;; (global-set-key (kbd "C-M-a") 'cmd) ; Ctrl+Meta+a

;; 5) Three Modifier Keys
;; (global-set-key (kbd "C-M-S-a") 'cmd)   ; Ctrl+Meta+Shift+a
;; (global-set-key (kbd "C-M-!") 'cmd)     ; Ctrl+Meta+Shift+1
;; (global-set-key (kbd "C-M-\"") 'cmd)    ; Ctrl+Meta+Shift+'
;; (global-set-key (kbd "C-M-S-<up>") 'cmd); Ctrl+Meta+Shift+↑

;; 6) Key Sequence
;; (global-set-key (kbd "C-c a") 'cmd)  ; Ctrl+c a
;; (global-set-key (kbd "C-c SPC") 'cmd)  ; Ctrl+c Space
;; (global-set-key (kbd "C-c <f2>") 'cmd)   ; Ctrl+c f2
;; (global-set-key (kbd "C-c <up>") 'cmd)   ; Ctrl+c ↑

;; (global-set-key (kbd "C-c C-c <up>") 'cmd); Ctrl+c Ctrl+c ↑

;; 7) No Modifiers
;; A shortcut can be created without any modifier keys.
;; (global-set-key (kbd "2") 'cmd)
;; (global-set-key (kbd "a") 'cmd)
;; (global-set-key (kbd "é") 'cmd)
;; (global-set-key (kbd "α") 'cmd)
;; (global-set-key (kbd "π") 'cmd)
;; (global-set-key (kbd "(") 'cmd)
;; (global-set-key (kbd "你") 'cmd)

;; 8) Keys To Avoid
;; quirk 怪癖
;; Emacs has its quirks. The following keys you should not redefine:

;;     * Keys involving the question mark symbol “?”. (due to emacs technical implementation quirk)
;;     * The “Esc” key. The Esc key has complicated meanings depending when it is pressed and how many times it is pressed.
;;     * “Ctrl+h” (This key combo is used for emacs help system and have a special status in emacs's key system.)
;;     * “Ctrl+m” (there are complicated relation between “Ctrl+m” and Return/Enter)
;;     * “Ctrl+i” (there are complicated relation between “Ctrl+i” and Tab)
;;     * Enter (On some keyboards it is labeled Return.)
;;     * “Ctrl+Shift+‹letter›”. Try not to use this combination, because in many text terminals, it cannot distinguish shifted and unshifted versions of such combination. distinguish 区别、辨认

;; 9) Good Key Choices
;; The following keys are good spots for your own definitions, and does not cause any problems in practice.

;;     * F5 to F9. Other function keys are also good choices if you don't use their default actions. (To know what are the defaults, see: Emacs's Keybinding Layout.)
;;     * Any “Ctrl+‹Function Key›”. “Alt+‹Function Key›” and “Shift+‹Function Key›” are also good.
;;     * Any “Ctrl+‹number›” is a good choice. “Alt+‹number›” is also good. By default, they call digit-argument, which is rarely used.

;; Shifted Key Combination
;; Examples:
;; GOOD				BAD				Keystroke
;; (kbd "M-A")		(kbd "M-S-a")	Meta+Shift+a
;; (kbd "M-@")		(kbd "M-S-2")	Meta+Shift+2
;; (kbd "M-:")		(kbd "M-S-;")	Meta+Shift+;
;; (kbd "C-S-a")	(kbd "C-A")		Ctrl+Shift+a ###
;; "C-S-<letter>" Try not to use this combination.

;; global-unset-key  to unset a keybinding

;;; 注释用中英文两种语言，方便Search查找, 注明shortkey各种形式。
;; 常用帮助 info(C-h i) 和 woman 显示man在一个buffer里面
;; 重绑定默认 keybindings

;;; 不常用的 =======================================================

;; for elisp
;;让当前buffer生效的快捷方式
(add-hook 'emacs-lisp-mode-hook
		  (lambda () (progn
					   (local-set-key "\C-ze" 'eval-buffer)
					   ;;编译当前emacs-lisp源码为elc
					   ;; (local-set-key (kbd "C-z b") 'emacs-lisp-byte-compile)
					   ;; (local-set-key (kbd "C-c b") (lambda () (interactive) (byte-compile-file buffer-file-name)))
					   ;;在编译后并加载
					   ;;(local-set-key (kbd "C-z x") 'emacs-lisp-byte-compile-and-load)
					   ;; (local-set-key (kbd "M-<up>") 'backward-up-list)
					   ;; (local-set-key (kbd "M-<down>") 'down-list)
					   ;; (local-set-key (kbd "M-<left>") 'backward-sexp)
					   ;; (local-set-key (kbd "M-<right>") 'forward-sexp)
					   )))

;; (global-set-key (kbd "H-s") (lambda () (interactive) (insert "[]") (backward-char 1)))
;; (global-set-key (kbd "s-d") (lambda () (interactive) (insert "()") (backward-char 1)))
;; (global-set-key (kbd "H-f") (lambda () (interactive) (insert "{}") (backward-char 1)))

;;; ==== common binding =======
;; F3,F4, edit-kbd-macro, insert-kbd-macro 然后可以做点修改，调整
;; C-x C-q  toggle-read-only 
;; C-x C-= \ C-x C-- text-scale-adjust , font size

;;类似vi的f(x)命令，使用方法为C-c a "x",x为任意字符,找第几个字符按几次
(define-key global-map (kbd "C-z t") 'wy-go-to-char)
;; `M-g g',`M-g M-g' : goto line number, char count
(zsl-global-set-key "\M-gc" 'goto-char) ; M-g c : goto-char 是从buffer开头计算的

;; vim:ga 查看字符信息
;; 字节位置， 相对于字符位置 "C-x =" what-cursor-position
(zsl-global-set-key (kbd "C-z =") 'my-get-bytes-pos)

;; 开/关菜单
(zsl-global-set-key [f10] 'menu-bar-mode t)
;; (zsl-global-set-key [C-f10] 'my-fullscreen)

(zsl-global-set-key [C-f10] 'my-toggle-fullscreen)
(zsl-global-set-key [M-f4] 'delete-frame)

;;用Emacs时常用多个窗口，窗口之间的移动很常见 M-o
(zsl-global-set-key [(meta  o)] 'other-window t)
;; 跳转到另一个 window, C-x o ;; 类似 vim h j k l
(zsl-global-set-key "\C-z\C-h" 'windmove-left)
(zsl-global-set-key "\C-z\C-j" 'windmove-down)
(zsl-global-set-key "\C-z\C-k" 'windmove-up)
(zsl-global-set-key "\C-z\C-l" 'windmove-right)

(zsl-global-set-key (kbd "M-O") 'other-frame) ;需要连续操作的命令
(zsl-global-set-key (kbd "C-x B") 'switch-to-buffer-other-frame)

(zsl-global-set-key [(meta up)]            'move-frame-up)
(zsl-global-set-key [(meta down)]          'move-frame-down)
(zsl-global-set-key [(meta left)]          'move-frame-left t)
(zsl-global-set-key [(meta right)]         'move-frame-right t)

;; (global-set-key [(control home)]         'move-frame-to-screen-top-left)
(zsl-global-set-key [(control down)]       'enlarge-frame t)
(zsl-global-set-key [(control up)]         'shrink-frame t)
(zsl-global-set-key [(control right)]      'enlarge-frame-horizontally t)
(zsl-global-set-key [(control left)]       'shrink-frame-horizontally t)
;; (zsl-global-set-key [C-left] 'previous-buffer t)
;; (zsl-global-set-key [C-right] 'next-buffer t)


(zsl-global-set-key [f8] 'describe-function)
(zsl-global-set-key [f9] 'describe-key-briefly)
(zsl-global-set-key [f11] 'describe-variable)

;; (zsl-global-set-key [f6] 'dired-jump);; 打开当前文件所在的目录
(zsl-global-set-key [f6] 'dired-at-point);; 打开当前文件所在的目录

;; bookmark and register
;; C-x rl : `bookmark-bmenu-list' 列举我的书签 ; [f8] 'list-bookmarks)
;; C-x rm : 添加当前页到书签中; (zsl-global-set-key [f9] 'bookmark-set)
;; C-x rb : bookmark-jump

;; vim下C-o, C-i这样的键? 就是跳转到刚才待过的地方. "C-x C-x" ,pop-global-mark 不好用!
;; 'point-to-register, 'jump-to-register
;; list-registers ? register-alist
(zsl-global-set-key "\C-zr" 'ska-point-to-register)
(zsl-global-set-key "\C-z\C-s" 'ska-jump-to-register) ;switch point and mark
;; (require 'recent-jump nil t)			; 增加 require 参数防止找不到插件出错
;; ann77 的一个 elisp，用于跳转到前一个大幅度跳转的位置。类似于 vim 的 C-o 和 C-i。
(when (featurep 'recent-jump)
  (zsl-global-set-key "\C-zr" 'recent-jump-jump-backward)
  (zsl-global-set-key "\C-zu" 'recent-jump-jump-forward))

;; 快速切换 buffer
(zsl-global-set-key (kbd "C-z z") 'previous-user-buffer)
(zsl-global-set-key (kbd "C-z C-z") 'next-user-buffer)

;; vim % : C-M-p,C-M-n, C-M-f,C-M-b ;; 跳到配对的括号

;; show line number, 'setnu-mode in emacs-goodies
(zsl-global-set-key (kbd "C-z s s") 'linum-mode) ;;打开行号显示,和vi一样的

;; 补全命令, like M-/ but power more
(zsl-global-set-key (kbd "M-?") 'hippie-expand)

;; M-@ 执行 mark-word, C-@ 是 set-mark 但很不好按，还跟输入法的快捷键冲突!
(zsl-global-set-key (kbd "M-#") 'set-mark-command) ;C-M-Space mark-sexp
;; 如果 C-SPC 不能用，这个还是一个很好的选择。不过 w3m 下不能用。
;; (zsl-global-set-key (kbd "S-SPC") 'set-mark-command)

;;把speedbar集成到emacs的frame里. Same Frame Speedbar
(zsl-global-set-key (kbd "C-z s b") 'sr-speedbar-toggle)

;; (define-key global-map "\M-\C-8" 'isearch-forward-word)
(zsl-global-set-key [?\M-\C-8] 'isearch-forward-word t)
;; `C-s' `C-r', `C-M-s', `C-M-r'
;; (zsl-global-set-key (kbd "C-z C-s") 'search-forward-regexp)
;; (zsl-global-set-key (kbd "C-z C-r") 'search-backward-regexp)
;;occur使用正则查找,列出一个buffer中匹配的行
(zsl-global-set-key (kbd "C-z o") 'occur)
;; 精确查找 vim:*#
;; Query replace `M-%' query-replace, `C-M-%' 'query-replace-regexp 带正则表达式的搜索

;; vim:gf find-file-at-point:ffap
(zsl-global-set-key (kbd "C-z g") 'find-file-at-point)
(zsl-global-set-key (kbd "C-z w") 'ffap-other-window) ;在 eshell 里用
(zsl-global-set-key (kbd "C-z b") 'zsl-eshell)

;; vim zt,zb,zz . C-l, M-[n] C-v, C-x z,
;; vim-H, M, L这样的键? 就是跳转到屏幕的顶端,中部和底端,M-r,C-l,C-u n C-l.
(zsl-global-set-key (kbd "M-M")			; "M-S-m"
					'(lambda () "mycenter" (interactive) (move-to-window-line nil)))
(zsl-global-set-key (kbd "M-H")
					'(lambda () "myhome" (interactive) (move-to-window-line 0)))
(zsl-global-set-key (kbd "M-L")
					'(lambda () "myend" (interactive) (move-to-window-line -1)))

;; vim d%这样的键? 就是删除从当前括号一直到匹配括号(包括匹配的注释符号/*...*/)间的文字
;; emacs有两个命令： kill-sexp和backward-kill-sexp：C-M-k和 Esc C-del (或者Esc C-backspace)，

;; 前面插入行 M-RET ，后面插入行 C-RET; RET，还有 C-j,M-j.
(zsl-global-set-key  (kbd "<C-return>")
					 '(lambda () (interactive) (progn (move-end-of-line nil) (newline nil))))
(zsl-global-set-key  (kbd "<M-return>")
					 '(lambda () (interactive) (progn (move-beginning-of-line nil) (open-line 1))))

;; 创建一个空buffer
;; (zsl-global-set-key (kbd "C-z n") '(generate-new-buffer-name "new file"))
(zsl-global-set-key (kbd "C-z n")
					(lambda () (interactive)
					  (switch-to-buffer
					   (get-buffer-create
						(format-time-string "**buffer%H%M%S%3N" (current-time))
						))))

;; 注释region ;;比较常用，来回改的麻烦，还是这个方便
;; 'comment-region, comment-line ?
;; 'uncomment-region, comment-or-uncomment-region

;; 屏幕滚动光标不动 M-p, M-n
(zsl-global-set-key [(meta n)] (lambda (&optional n) (interactive "p") (scroll-up (or n 1))))
(zsl-global-set-key [(meta p)] (lambda (&optional n) (interactive "p") (scroll-down (or n 1))))

;; M-tab , ispell-complete-word-dict
(zsl-global-set-key "\C-z\C-f" 'ispell-complete-word)

;; 插入日期A
(zsl-global-set-key
 (kbd "C-z d")
 (lambda () (interactive)
   (insert (format-time-string "%Y-%m-%d %H:%M:%S " (current-time)))) t)

;; 插入日期B
(zsl-global-set-key
 (kbd "C-z C-d")
 (lambda () (interactive)
   ;; (move-beginning-of-line (point))
   (goto-char 0)
   ;; (shell-command "date" (point))
   (insert (format-time-string "%Y-%m-%d %H:%M:%S" (current-time)))
   ;; (next-line)
   (newline)
   (newline)
   (previous-line)
   )
 t)

(zsl-global-set-key "\C-x\C-d" (lambda () (interactive) (kill-buffer (current-buffer))) t)

(zsl-global-set-key (kbd "C-'") 'select-inside-quotes)
;; `C-(' C-)

;; clear 多个空格  M-SPC | M-\ delete-horizontal-space
;; (zsl-global-set-key (kbd "C-z c") 'just-one-space)
(zsl-global-set-key (kbd "C-z c") (lambda () (interactive) (message "%s" buffer-file-coding-system)))

;; 'M-\' delete-horizontal-space ==> 'C-z c' leim,eim
;; (zsl-global-set-key (kbd "M-\\") 'eim-insert-ascii t) ;输入法临时切换

(zsl-global-set-key (kbd "C-z v") 'svn-status)

;; comment-dwim , do what i mean
(zsl-global-set-key "\M-;" 'qiang-comment-dwim-line t)

;; 切换自动换行模式
(zsl-global-set-key (kbd "C-c $") 'toggle-truncate-lines)

;; 刷新文件
(zsl-global-set-key (kbd "C-c C-r") 'revert-buffer)

(zsl-global-set-key (kbd "C-<f1>") 'winner-undo)
(zsl-global-set-key (kbd "C-<f2>") 'winner-redo)
(zsl-global-set-key (kbd "C-<f3>") 'anything)

;;; ==== zsl-project-cmd.el ====
;; default binding
;; <esc-map ".">: find-tag , `M-[n] M-.' goto next matching definition. [n]任意数字
;; (define-key esc-map "*" 'pop-tag-mark) 
;; (define-key esc-map [?\C-.] 'find-tag-regexp)
;; (define-key ctl-x-4-map "." 'find-tag-other-window)

;; global-unset-key  to unset a keybinding
(zsl-global-set-key (kbd "<C-down-mouse-1>") nil t) ;; 去掉原来的帮定关系
(zsl-global-set-key (kbd "<C-mouse-1>") 'zsl-project-fsfap t)

;; complete-tag, tags-search, tags-query-replace, visit-tags-table

(zsl-global-set-key (kbd "<f5>") 'visit-tags-table)
(zsl-global-set-key (kbd "<f7>") 'tags-search) ;then `M-,'tags-loop-continue
;; (zsl-global-set-key (kbd "<f12>") 'locate-to-symbol)
(zsl-global-set-key (kbd "M-<f12>") 'zsl-project-jump-back)
;; jerry-cedet
(zsl-global-set-key [S-f12] 'semantic-ia-fast-jump-back)

(zsl-global-set-key (kbd "<f12>") 'repeat)


(zsl-global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
;;; zsl-project-tree.el
;(zsl-global-set-key "\C-z\C-e" 'zptree-open) ;explorer
(zsl-global-set-key "\C-zp" 'zptree-open) ;project

;; (zsl-global-set-key (kbd "C-z f") 'zsl-dirtree-at-point)
;; ==== end zsl-project-cmd binding ====

;;; hs-minor-mode
(load "zsl-hide-show.el")
(zsl-global-set-key (kbd "C-c H") 'hs-minor-mode)

(zsl-global-set-key "\C-z\C-a" 'beginning-of-line-text)

;;; mouse keys
;; 默认配置: 用鼠标左键 click 一个位置，可以以移动光标到这个位置，这是最基本，也是最自然的功能了。
;; (global-set-key (kbd "<mouse-1>") 'mouse-set-point)
;; 这段代码不用放在配置文件中，因为默认配置就是这样。
;; 尽管是默认配置，我还是把他们写出了，因为有的时候我们想改变默认配置。把默认的功能对应到其他的按键方式上去。

;; (global-set-key (kbd "<mouse-1>") 'mouse-set-point)
;; (global-set-key (kbd "<mouse-2>") 'mouse-yank-at-click)
;; (global-set-key (kbd "<mouse-3>") 'mouse-save-then-kill)

;; (global-set-key (kbd "<down-mouse-1>") 'mouse-drag-region)
;; (global-set-key (kbd "<C-down-mouse-1>") 'mouse-buffer-menu)

;; (global-set-key (kbd "<S-down-mouse-1>") 'mouse-set-font)
(zsl-global-set-key (kbd "<S-down-mouse-1>") 'mouse-drag-drag t)
;; (global-set-key (kbd "<C-down-mouse-2>") 'mouse-popup-menuar-stuff)

;; (global-set-key [M-down-mouse-1] 'mouse-drag-secondary-pasting)
;; (global-set-key [M-S-down-mouse-1] 'mouse-drag-secondary-moving)

(zsl-global-set-key (kbd "C-z s h") 'highlight-symbol-at-point t)
(zsl-global-set-key (kbd "C-z s j") 'highlight-symbol-next)
(zsl-global-set-key (kbd "C-z s r") 'highlight-symbol-remove-all)

;; (zsl-global-set-key (kbd "M-<f6>") ')
;; (zsl-global-set-key (kbd "C-<f6>") ')
;; (zsl-global-set-key [f1] ')
;; (zsl-global-set-key [f2] ')
;; (zsl-global-set-key [f5] ')
;; (zsl-global-set-key [f8] ')
;; (zsl-global-set-key (kbd "C-<prior>") ' t) ; Ctrl+PageDown
;; (zsl-global-set-key (kbd "C-<next>") ' t) ; Ctrl+PageUp
;; (zsl-global-set-key (kbd "C-z s n") ')
;; (zsl-global-set-key "\C-zu" ')
;; (zsl-global-set-key (kbd "C-z r") ')
;; (zsl-global-set-key (kbd "C-z f v") ')
;; C-c C-c
;; (zsl-global-set-key (kbd "<home>") ')
;; (zsl-global-set-key (kbd "<muhenkan>") ')
;; (zsl-global-set-key (kbd "<end>") ')

(zsl-global-set-key "\C-c\C-t" 'zsl-project-ffap t)

;; 使用的ibuffer
(zsl-global-set-key (kbd "C-x C-b") 'ibuffer t) ;; ibuffer-other-window
(zsl-global-set-key (kbd "M-x") 'smex t)

(zsl-global-set-key "\C-zk" (lambda (n) (interactive "p") (kill-forward-chars (or n 1))) t)

(provide 'jerry-key-bindings)			; help provide
;;; jerry-key-bindings.el ends here
