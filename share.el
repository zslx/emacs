;; Editor: text and symbol, create\read\update\delete\view
;; ��������  basic concept
window,buffer,frame,minibuffer,mode line,
point,region,
format, scrolling
;; 
;; д�����ص�����ʾ����������Ҫ����ת����֤�������л��в���,���Ժ�CMM.
;; �༭��ͨ�ı��������������޸ģ�����ƶ��Ͷ�λ����ͬ�����ֵĶ��գ�
;; 
;; task:
1 ���� keybindings ˳��, ���� key sequences �ص����,����鿴��ά��
;; ��Ӣ������ע�ͣ��������
2 ����
���� C-0 C-k : (zsl-global-set-key  (kbd "<C-backspace>") (lambda () (interactive) (kill-line 0)) t)
3 ���ù��� !eq ���ƵĹ���
;; 
;; * findding
C-q C-j ���뻻�з� quoted-insert newline-and-indent
F1 e view-echo-area-messages
;; ˢ���ļ�
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
(zsl-global-set-key (kbd "M-O") 'other-frame) ;��Ҫ��������������
(zsl-global-set-key (kbd "C-x B") 'switch-to-buffer-other-frame)

C-x C-o delete-blank-lines

;; ���
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


;; ====== efficient ====== ��Ч
1 C-x z  repeat �ظ����һ������; ��Ҫ���������������һ�����������
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

3 M-w, C-k; C-y, M-y, C-w, M-h, ѡ��Ͳ���
C-@,C-SPC,M-#, M-@,

4 macro
F3 kmacro-start-macro-or-insert-counter  C-x e | F4 kmacro-end-or-call-macro
C-x C-k e edit-kbd-macro
insert-kbd-macro last-kbd-macro read-kbd-macro

C-h l view-lossage

5 �鿴�ļ���Ϣ
C-x l  count-lines-page  C-x = what-cursor-position
M-= count-lines-region   C-z s s linum-mode


;; emacs ���ƣ�
;; ˼�룭����ƣ���ʵ��
;; ����������������C & lisp

���ٵ�ѡ��ͼ��У����ƣ�ճ�����ƶ���
��ס���򿪵� buffers��
���ٴ򿪺͹ر��ļ����л��ļ���
�ര����ʾ��
�����ǿ��Ķ������� elisp,
����ģʽ�е��﷨֧�� mode: html,css,js,php,c/c++,python, lisp,

;; basic concept
C: Ctrl
M: Meta\Alt\Edit,
S: Shift
F1~F12
ESC,SPC,Return\Enter

* ��ø��������getting more help��
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

* �����Ĺ����ƣ�basic cursor control��

C-p previous-line  C-n next-line  M-p scroll-down  M-n scroll-up
C-f forward-char  C-b backward-char  M-f forward-word  M-b backward-word
C-M-f forward-sexp  C-M-b backward-sexp

C-e move-end-of-line  C-a move-beginning-of-line  C-z C-a beginning-of-line-text
M-e forward-sentence  M-a backward-sentence  M-{ backward-paragraph  M-} forward-paragraph
forward-line forward-visible-line forward-to-indentation forward-thing

C-x r SPC point-to-register  C-x r j jump-to-register
C-x r i | C-x r g  insert-register

��� Emacs ������ʧȥ��Ӧ,������ C-g ��ȫ����ֹ�������
C-g Ҳ������ֹһ��ִ�й��õ�����,������ȡ�����ֲ�����ֻ���뵽һ������

����㲻С�İ���һ�� <ESC>����Ҳ������ C-g ��ȡ������
�����˵���ƺ������⣬��Ϊ�����������˳�������Ӧ���� C-M-g��ȡ�� <ESC> ����ȷ���������������� <ESC>����

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

* �����õ����disabled commands�� һЩΣ�ղ���
>> ���� C-x C-l ������һ�������õ����� downcase-region��

* ������ɾ����inserting and deleting��
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

* ������undo��
C-x u | C-_ | C-/ undo

* �ļ���file��
C-x C-f ido-find-file find-file
C-x C-s save-buffer
C-x C-w ido-write-file write-file
C-x C-d kill-buffer   C-x k ido-kill-buffer

* ��������buffer��
C-x C-b ibuffer  C-x b ido-switch-buffer switch-to-buffer
C-x s save-some-buffers

* �����չ��extending the command set��
Emacs ������������ϵ����ǣ���Ҳ�����塣�����Ƕ���Ӧ�� CONTROL �� META
��ϼ�����Ȼ�ǲ����ܵġ�Emacs ����չ��eXtend�����������������⣬��չ
���������ַ��
C-x     �ַ���չ��  C-x ֮��������һ���ַ�������ϼ���
M-x     ��������չ��M-x ֮������һ����������

TAB\<tab> indent-for-tab-command  C-q quoted-insert  C-x TAB indent-rigidly

* �Զ����棨auto save�� #x#
M-x recover-file <Return>

* ״̬����mode line��
status, mode, major, minor, toggle

M-/ dabbrev-expand  M-? hippie-expand  �Զ���ȫ

* ������searching��
C-s isearch-forward  C-M-8 isearch-forward-word   word-search-forward ? search-forward-regexp
C-s `M-e edit the string  M-c toggle case-sensitivity  M-s w toggle word mode   M-r toggle regular-expression mode'
C-r isearch-backward  C-M-s isearch-forward-regexp  C-M-r

incremental

* ����windows��
* �ര��multiple windows��
C-x 2 split-window-vertically  C-x 3 split-window-horizontally
C-x 1 delete-other-windows  C-x 0 delete-window
M-next | ESC C-v | C-M-v scroll-other-window   M-prior | C-M-V scroll-other-window-down

C-x o | M-o other-window  C-x 4 C-o ido-display-buffer  C-x 4 f | C-x 4 C-f ido-find-file-other-window

next\PgDn prior\PgUp
modifier key


* �ݹ�༭��recursive editing levels��
ESC ESC ESC,
arguments

* ���ྫ�ʣ�more features��
completion, dired, info,

* �ܽᣨconclusion��

command               ����
cursor                ���
scrolling             ����
numeric argument      ���ֲ���
window                ���� [1]
insert                ����
delete                ɾ�� [2]
kill                  �Ƴ� [2]
yank                  �ٻ� [2]
undo                  ����
file                  �ļ�
buffer                ������
minibuffer            С����
echo area             ������
mode line             ״̬��
search                ����
incremental search    ����ʽ���� [3]
frame



;; Ŀ��һ�� �ļ��������������Ŀ��ص������ļ�.
;; tree-widget : project tree, disk file tree;
;; �Զ�ˢ��? or �ֶ�ˢ��? ����ˢ��
;; ������? �ڵ���,ֱ���ӽ��,�㼶��ת
;; 
;; Ŀ����� ���� symbol �Ķ����ʹ�ô�����������������; ��ͷ�ļ�;
;; 4 find��grep ���
;; ��������: ���ַ������ң�ɸѡ���ļ������﷨�������ң���ȷ��λ��
;; ����ʱ�Զ������﷨���������������ļ���Ϊ������ʾ���Զ������׼����
;; directory_name.symbol.index.n ÿ���ļ�����100���ļ���
;; ��Ŀ¼�г���100�������ں������������ n.
;; 
;; Ŀ������д����ʱ��������ʾ���Զ���ɣ�ģ�����ɵ�
;; 
;; ��ҪĿ�꣺�����������Ŀ���ļ������޶�������Χ��
;; ui ��ƣ�����
;; 
;; 
;; find-symbol-define
;; find-symbol-using
;; cpp-include-file
;; cpp-implement-file

;; ֧��������� ������ mouse-1 mouse-2 mouse-3
;; ���ܼ��󶨣� f1~12 ���; д����ʱ����Ϊ����������ʱ���Ҳ���á�

;; �ļ��� project tree, �����������޶�������Χ��

requirement:
1 ɾ�� buffer �Լ� file
2 ediff
3 find, grep

hideshow, C-x nn | C-x nw narrow-to-region

self-insert-command :
before insertion `expand-abbrev';
after insertion `auto-fill-function', `auto-fill-chars';
at the end, it runs `post-self-insert-hook'.
blink-paren-post-self-insert-function

����
1 �ɶ�����
(zsl-global-set-key
 "("
 (lambda (n) (interactive "p")
   (self-insert-command (or n 1))
   (insert ")")
   (backward-char)
   )
 t
 )

2 �Զ�����պϱ�ǩ div, ��ѡ�������Χѡ��
(defun tag-region(tag)
  (interactive "")
  (if region-active))

(zsl-global-set-key (kbd "C-'") 'select-inside-quotes)

eim:
M-x set-input-method eim-py
C-\ toggle-input-method

(getenv "PATH")
