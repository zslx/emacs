;; Editor: text and symbol, create\read\update\delete\view
;; 基本概念  basic concept
window,buffer,frame,minibuffer,mode line,
point,region,
format, scrolling
;; 
;; 写代码重点是提示，看代码主要用跳转，保证最终运行还有测试,调试和CMM.
;; 编辑普通文本：方便的输入和修改，光标移动和定位，不同不部分的对照，
;; 
;; task:
1 整理 keybindings 顺序, 根据 key sequences 特点分组,方便查看和维护
;; 中英文两种注释，方便查找
2 精简，
例如 C-0 C-k : (zsl-global-set-key  (kbd "<C-backspace>") (lambda () (interactive) (kill-line 0)) t)
3 常用功能 !eq 定制的功能
;; 
;; * findding
C-q C-j 输入换行符 quoted-insert newline-and-indent
F1 e view-echo-area-messages
;; 刷新文件
(zsl-global-set-key (kbd "C-c C-r") 'revert-buffer)

ESC ESC ESC keyboard-escape-quit  C-g keyboard-quit

C-[0~9-]\M-[0~9-] digit-argument
C-0 C-k kill
M-r move
C-l scroll
C-o | C-j | C-RET | M-RET  line
M-c capitalize-word

C-M-SPC mark-sexp

C-s `M-e   edit the string
M-c   toggle case-sensitivity
M-s w toggle word mode
M-r   toggle regular-expression mode'
C-z o occur

;; kill n char and save in kill ring
(zsl-global-set-key "\C-zk" (lambda (n) (interactive "p") (kill-forward-chars (or n 1))) t)

M-= count-lines-region  C-x l count-lines-page
M-O other-frame  C-x B switch-to-buffer-other-frame

eval-region  C-x C-e eval-last-sexp  C-z e eval-buffer

(zsl-global-set-key [f8] 'describe-function)
(zsl-global-set-key [f9] 'describe-key-briefly)
(zsl-global-set-key [f11] 'describe-variable)
(zsl-global-set-key (kbd "M-O") 'other-frame) ;需要连续操作的命令
(zsl-global-set-key (kbd "C-x B") 'switch-to-buffer-other-frame)

C-x C-o delete-blank-lines

;; 最常用
1 self-insert-command  Insert the character you type.
2 C-x 2\3\1\0  C-x o\M-o  multiple window
3 C-x C-f | C-x b | C-x C-s  file and buffer
  C-x k | C-x C-d |
4 cursor and point
5 mark and region, char,word,line,clause,paragraph
6 undo, kill, delete, yank,
7 indent, format?
8 syntax, color, expand,
9 F3, F4 macro  C-x C-k e


;; ====== efficient ====== 高效
1 C-x z  repeat 重复最近一次命令; 需要连续操作的命令，另一个解决方法。
last-repeatable-command

;; Here are some other key sequences with which repeat might be useful:
;;   C-u - C-t      [shove preceding character backward in line]
;;   C-u - M-t      [shove preceding word backward in sentence]
;;         C-x ^    enlarge-window [one line] (assuming frame has > 1 window)
;;   C-u - C-x ^    [shrink window one line]
;;         C-x `    next-error
;;   C-u - C-x `    [previous error]
;;         C-x DEL  backward-kill-sentence
;;         C-x e    call-last-kbd-macro
;;         C-x r i  insert-register
;;         C-x r t  string-rectangle
;;         C-x TAB  indent-rigidly [one character]
;;   C-u - C-x TAB  [outdent rigidly one character]
;;         C-x {    shrink-window-horizontally
;;         C-x }    enlarge-window-horizontally


2 multiple window, multiple frame,
C-x 5 2 make-frame-command  C-x 5 0 delete-frame
C-x 5 o | M-O other-frame   C-x 5 b | C-x B switch-to-buffer-other-frame

tab:C-x t n ==> C-x b,C-x C-b, ibuffer,ido-switch-buffer
C-z C-z,C-z z, next-user-buffer

3 M-w, C-k; C-y, M-y, C-w, M-h, 选择和操作
C-@,C-SPC,M-#, M-@,

4 macro
F3 kmacro-start-macro-or-insert-counter  C-x e | F4 kmacro-end-or-call-macro
C-x C-k e edit-kbd-macro
insert-kbd-macro last-kbd-macro read-kbd-macro

C-h l view-lossage

5 查看文件信息
C-x l  count-lines-page  C-x = what-cursor-position
M-= count-lines-region   C-z s s linum-mode


;; emacs 优势：
;; 思想－－设计－－实现
;; ？？－－？？－－C & lisp

快速的选择和剪切，复制，粘贴，移动，
记住最后打开的 buffers，
快速打开和关闭文件，切换文件，
多窗格显示，
方便而强大的定制能力 elisp,
各种模式中的语法支持 mode: html,css,js,php,c/c++,python, lisp,

;; basic concept
C: Ctrl
M: Meta\Alt\Edit,
S: Shift
F1~F12
ESC,SPC,Return\Enter

* 获得更多帮助（getting more help）
C-h k describe-key  C-h c describe-key-briefly  C-h f describe-function
C-h m describe-mode  C-h ? help-for-help  C-h i info
C-h C describe-coding-system  C-h a | F1 a apropos-command

(message "%s" buffer-file-coding-system)

C-x RET f set-buffer-file-coding-system
C-x RET r revert-buffer-with-coding-system

file-coding-system-alist
select-safe-coding-system
coding-system-for-write
M-x list-coding-systems

* 基本的光标控制（basic cursor control）

C-p previous-line  C-n next-line  M-p scroll-down  M-n scroll-up
C-f forward-char  C-b backward-char  M-f forward-word  M-b backward-word
C-M-f forward-sexp  C-M-b backward-sexp

C-e move-end-of-line  C-a move-beginning-of-line  C-z C-a beginning-of-line-text
M-e forward-sentence  M-a backward-sentence  M-{ backward-paragraph  M-} forward-paragraph
forward-line forward-visible-line forward-to-indentation forward-thing

C-x r SPC point-to-register  C-x r j jump-to-register
C-x r i | C-x r g  insert-register

如果 Emacs 对命令失去响应,可以用 C-g 安全地终止这条命令。
C-g 也可以终止一条执行过久的命令,还可以取消数字参数和只输入到一半的命令。

如果你不小心按了一下 <ESC>，你也可以用 C-g 来取消它。
【这个说法似乎有问题，因为按照这个按键顺序输入的应该是 C-M-g。取消 <ESC> 的正确做法是再连按两次 <ESC>。】

C-v scroll-up  M-v scroll-down  C-l recenter-top-bottom  M-r move-to-window-line-top-bottom
M-M move-to-window-line nil  M-L move-to-window-line -1  M-H move-to-window-line 0
M-> end-of-buffer  M-< beginning-of-buffer  C-x ] forward-page  C-x [ backward-page

scroll-step  move-
q View-quit

RET\<return>\<Enter> newline  C-o open-line   M-RET open-line  C-RET newline
M-q  fill-paragraph

* command argument
C-u universal-argument  eg. C-u C-p, C-u C-n, C-u 6 C-n,
C-[1234567890-] \ M-[1234567890-] \ ESC[1234567890-] digit-argument - negative-argument
It is bound to C-9, C-8, C-7, C-6, C-5, C-4, C-3, C-2, C-1, C-0, ESC 0, C-M-9, C-M-7, C-M-6, C-M-5,
C-M-4, C-M-3, C-M-2, C-M-1, C-M-0.

* 被禁用的命令（disabled commands） 一些危险操作
>> 试试 C-x C-l （这是一个被禁用的命令 downcase-region）

* 插入与删除（inserting and deleting）
C-d delete-char  M-d kill-word  DEL\<delback>\Backspace backward-delete-char-untabify
C-DEL\M-DEL\M-<backspace>\M-<Delback> backward-kill-word  C-k kill-line
C-0 C-k : (zsl-global-set-key  (kbd "<C-backspace>") (lambda () (interactive) (kill-line 0)) t)


C-w kill-region  M-w kill-ring-save   C-M-w append-next-kill ??
C-y yank  M-y yank-pop

(kill-forward-chars 1)  (kill-backward-chars 3)  save in kill ring
backward-delete-char\delete-backward-char\delete-char  (delete-char -3)
kill-ring-max

Delete vs Kill ?

M-u upcase-word  M-l downcase-word  M-c capitalize-word
M-= count-lines-region  C-x l count-lines-page  C-z s s linum-mode

* region
M-@ mark-word  M-#\C-@\C-SPC set-mark-command  M-h mark-paragraph  C-x h mark-whole-buffer
C-x C-p mark-page  C-M-SPC\C-M-@ mark-sexp
mark-even-if-inactive mark-active mark-marker mark-end-of-sentence

* 撤销（undo）
C-x u | C-_ | C-/ undo

* 文件（file）
C-x C-f ido-find-file find-file
C-x C-s save-buffer
C-x C-w ido-write-file write-file
C-x C-d kill-buffer   C-x k ido-kill-buffer

* 缓冲区（buffer）
C-x C-b ibuffer  C-x b ido-switch-buffer switch-to-buffer
C-x s save-some-buffers

* 命令集扩展（extending the command set）
Emacs 的命令就像天上的星星，数也数不清。把它们都对应到 CONTROL 和 META
组合键上显然是不可能的。Emacs 用扩展（eXtend）命令来解决这个问题，扩展
命令有两种风格：
C-x     字符扩展。  C-x 之后输入另一个字符或者组合键。
M-x     命令名扩展。M-x 之后输入一个命令名。

TAB\<tab> indent-for-tab-command  C-q quoted-insert  C-x TAB indent-rigidly

* 自动保存（auto save） #x#
M-x recover-file <Return>

* 状态栏（mode line）
status, mode, major, minor, toggle

M-/ dabbrev-expand  M-? hippie-expand  自动补全

* 搜索（searching）
C-s isearch-forward  C-M-8 isearch-forward-word   word-search-forward ? search-forward-regexp
C-s `M-e edit the string  M-c toggle case-sensitivity  M-s w toggle word mode   M-r toggle regular-expression mode'
C-r isearch-backward  C-M-s isearch-forward-regexp  C-M-r

incremental

* 窗格（windows）
* 多窗格（multiple windows）
C-x 2 split-window-vertically  C-x 3 split-window-horizontally
C-x 1 delete-other-windows  C-x 0 delete-window
M-next | ESC C-v | C-M-v scroll-other-window   M-prior | C-M-V scroll-other-window-down

C-x o | M-o other-window  C-x 4 C-o ido-display-buffer  C-x 4 f | C-x 4 C-f ido-find-file-other-window

next\PgDn prior\PgUp
modifier key


* 递归编辑（recursive editing levels）
ESC ESC ESC,
arguments

* 更多精彩（more features）
completion, dired, info,

* 总结（conclusion）

command               命令
cursor                光标
scrolling             滚动
numeric argument      数字参数
window                窗格 [1]
insert                插入
delete                删除 [2]
kill                  移除 [2]
yank                  召回 [2]
undo                  撤销
file                  文件
buffer                缓冲区
minibuffer            小缓冲
echo area             回显区
mode line             状态栏
search                搜索
incremental search    渐进式搜索 [3]
frame



;; 目标一： 文件树，方便浏览项目相关的所有文件.
;; tree-widget : project tree, disk file tree;
;; 自动刷新? or 手动刷新? 部分刷新
;; 鼠标操作? 节点编号,直接子结点,层级跳转
;; 
;; 目标二： 查找 symbol 的定义和使用处。函数，变量，类; 打开头文件;
;; 4 find，grep 最靠谱
;; 变量查找: 先字符串查找，筛选出文件，再语法分析查找，精确定位。
;; 空闲时自动调用语法分析，建立索引文件，为输入提示和自动完成做准备。
;; directory_name.symbol.index.n 每个文件索引100个文件，
;; 若目录中超过100个，则在后面加数字区别 n.
;; 
;; 目标三：写程序时，代码提示，自动完成，模板生成等
;; 
;; 主要目标：代码浏览，项目的文件管理（限定操作范围）
;; ui 设计，命令
;; 
;; 
;; find-symbol-define
;; find-symbol-using
;; cpp-include-file
;; cpp-implement-file

;; 支持鼠标点击， 绑定鼠标键 mouse-1 mouse-2 mouse-3
;; 功能键绑定： f1~12 鼠标; 写代码时键盘为主，看代码时鼠标也好用。

;; 文件树 project tree, 方便的浏览和限定操作范围。

requirement:
1 删除 buffer 以及 file
2 ediff
3 find, grep

hideshow, C-x nn | C-x nw narrow-to-region

self-insert-command :
before insertion `expand-abbrev';
after insertion `auto-fill-function', `auto-fill-chars';
at the end, it runs `post-self-insert-hook'.
blink-paren-post-self-insert-function

例子
1 成对输入
(zsl-global-set-key
 "("
 (lambda (n) (interactive "p")
   (self-insert-command (or n 1))
   (insert ")")
   (backward-char)
   )
 t
 )

2 自动输入闭合标签 div, 有选择区则包围选区
(defun tag-region(tag)
  (interactive "")
  (if region-active))

(zsl-global-set-key (kbd "C-'") 'select-inside-quotes)

eim:
M-x set-input-method eim-py
C-\ toggle-input-method

(getenv "PATH")
