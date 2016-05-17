;;; 常用的lisp函数，许多是从别的地方抄过来的
;;; zsl-functions.el --- my function

;; with-timeout
;; cancel-timer

;; (setq timer1
;; 	  ;; (run-with-timer
;; 	  (run-with-idle-timer
;; 	   3 nil (lambda ()
;; 			 (progn
;; 			   (my-toggle-fullscreen)
;; 			   (cancel-timer timer1)))))

;; 	   (cancel-timer timer1)
;; 	   (timerp timer1)
;; 	   (timer-activate timer1)

;; 清楚知道自己的 keybinding 情况
(defun zsl-global-set-key (key command &optional force)
  (let ((cmd (key-binding key))
        (keys (key-description key)))
    (if cmd  ;已有绑定
        (if force  ;决定替换
            (progn (global-set-key key command)
                   (message "force rebind keys %s: %S => %S" keys cmd command))
          (message "sequence %s already bind %S" keys cmd))
      (global-set-key key command))))

;; `M-*' 通常有 `ESC *' 对应; 当 Alt-* 被占用时，非常有用了:)

(defun open-by-ie()
  (interactive)
  (let ((url (buffer-file-name)))
  ;; (call-process "C:/Program Files/Internet Explorer/iexplore.exe" nil 0 nil url)
  (call-process "~/c/Program Files/Internet Explorer/iexplore.exe" nil 0 nil url)
  ))


;; (call-process
;;  "c:/Program Files (x86)/GNU/GnuPG/pub/gpg.exe"
;;  nil
;;  "*scratch*"
;;  nil "-d"
;;  ;; "d:/快盘/notes/Org/logLifeHappy.blog.gpg"
;;  "d:/快盘/notes/Org/GTD/notes.org.gpg"
;;  )

(defun gpg-open(gpg_exe file)
  (interactive)
  (call-process gpg_exe nil "*scratch*" nil "-d" file ))

;; (let ((proc (start-process "cmd" nil "cmd.exe" "/C" "start" "cmd.exe")))
;;   (set-process-query-on-exit-flag proc nil))

;; 看看 load-path
;;(format "%S" load-path)

(defun ska-point-to-register()
  "Store cursorposition _fast_ in a register.
 Use ska-jump-to-register to jump back to the stored position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))

(defun ska-jump-to-register()
  "Switches between current cursorposition and
 position that was stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
	(jump-to-register 8)
	(set-register 8 tmp)))

(defun wy-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
 Typing `wy-go-to-char-key' again will move forwad to
 the next Nth occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (search-forward (string char) nil nil n)
  (while (char-equal (read-char) char) (search-forward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))

(defun next-user-buffer ()
  "Switch to the next user buffer in cyclic order.\n
User buffers are those not starting with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
	  (setq i (1+ i)) (next-buffer) )))

(defun previous-user-buffer ()
  "Switch to the previous user buffer in cyclic order.\n
User buffers are those not starting with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 50))
      (setq i (1+ i)) (previous-buffer) )))

;; shenglin.zh 看看 当前光标的字节位置
(defun zsl-cur-pos ()
  "显示当前光标的字节位置"
  (interactive)
  (prin1 (position-bytes (point)) ) )

(defun my-get-bytes-pos ()
  (interactive)
  (let (bpos str)
	(setq str (buffer-substring (point-min) (point)))
	(setq bpos (string-bytes str))
	(message "current cursor position(byte):%d." bpos)))


(defun qiang-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and
we are not at the end of the line, then comment current line.
Replaces default behaviour of comment-dwim,
when it inserts comment at the end of the line. "
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
 
;; Grab Between Matching Pairs
(defun select-inside-quotes ()
  "Select text between double straight quotes on each side of cursor."
  (interactive)
  (let (p1 p2)
    (skip-chars-backward "^\"")
    (setq p1 (point))
    (skip-chars-forward "^\"")
    (setq p2 (point))

    (goto-char p1)
    (push-mark p2)
    (setq mark-active t)
	)
  )

;; (defun kill-match-paren (arg)
;;   (interactive "p");; 删除匹配括号间内容
;;   (cond ((looking-at "[([{]") (kill-sexp 1) (backward-char))
;; 	((looking-at "[])}]") (forward-char) (backward-kill-sexp 1))
;; 	(t (self-insert-command (or arg 1)))))
;; (global-set-key (kbd "C-x %") 'kill-match-paren)
;; ;; 敲C-x %或者M-x kill-match-paren就可以完成vim里d %的功能了。


;;;###autoload
(defun zsl-eshell (&optional sdir)
  "Create an interactive Eshell buffer. buffer selected (or created)."
  (interactive)
  (or sdir (setq sdir (ffap-prompter)))
  (let ((buf (get-buffer-create "*eshell* this dir")))
    (assert (and buf (buffer-live-p buf)))
    (pop-to-buffer buf)
	(cd sdir)
    (unless (eq major-mode 'eshell-mode)
      (eshell-mode))
    buf))

;; require zsl-async-process.el and rewrite zsl-async-worker function

(defun zsl-download-url2file (url &optional dir)
  (let ((sname (upcase (md5 url)))
		fname
		)
	(when dir (setq fname (concat dir "/" sname)))
	(if (file-exists-p fname) (message "existing %s ==> %s" url fname)
	  (progn
		(message "%s ==> %s" url fname)
		(start-process "zsl-download-url2file" "*downloads*" "wget" url "-O" fname "-T" "60")))
		;; (call-process "wget" nil "*downloads*" nil url "-O" fname)))
	)
  )
;; set-process-sentinel

(defun zsl-foreach-file-line (fname handler &optional dir)
  (let ((bko make-backup-files)
		line
		)
	(setq make-backup-files nil)			;临时关闭备份
	(with-current-buffer (find-file-noselect fname)
	  (buffer-disable-undo)
	  (goto-char (point-min))
	  (while (< (line-end-position) (point-max))
		(setq line (buffer-substring (line-beginning-position) (line-end-position)))
		(funcall handler line dir)
		(next-line)
		)
		(kill-buffer))
	(setq make-backup-files bko)
	))

(defun zsl-get-url-list (urlfile)
  (let (urlist
		(fullfile (expand-file-name urlfile)))
	(zsl-foreach-file-line urlfile (lambda (url &optional dir) (setq urlist (cons url urlist))))
	urlist
	))

(defsubst zsl-download-get-fname (url wdir)
  (let ((sname (upcase (md5 url)))
		fname)
	(when wdir (setq fname (concat wdir "/" sname)))
	fname
	))

(defun zsl-async-worker ()
  (if (= (length g-url-list) 0) (message "empty url list")
	(let (url fname worker)
	  (message "url count:%d" (length g-url-list))

	  (setq url (car g-url-list))
	  (setq g-url-list (cdr g-url-list))
	  (setq fname (zsl-download-get-fname url g-downloads-work-dir))
	  (setq zsl-worker-times (1+ zsl-worker-times))
	  (while (file-exists-p fname)
		(progn
		  (message "existing %s ==> %s" url fname)
		  (setq url (car g-url-list))
		  (setq g-url-list (cdr g-url-list))
		  (setq fname (zsl-download-get-fname url g-downloads-work-dir))
		  (setq zsl-worker-times (1+ zsl-worker-times))
		  ))

	  (message "%s ==> %s" url fname)
	  (setq worker (start-process "zsl-url2file" "*downloads*"
								  "wget" url "-O" fname "-T" "60" "-t" "3"))
	  ;; (set-process-filter worker 'zsl-worker-filter)
	  (set-process-sentinel worker 'zsl-worker-sentinel)
	  ;; (message "%d : %s" zsl-worker-times zsl-worker-output)
	  )))

(defun zsl-save-url-content (url-or-list &optional odir)
  (interactive "sInput url and output dir:\nD")
  (if (file-exists-p url-or-list)
	  (progn
		(setq g-url-list (zsl-get-url-list url-or-list))
		(setq g-downloads-work-dir odir)
		(zsl-async-worker)
		)
	(zsl-download-url2file url-or-list odir))
  )

;; 1. 列一下我在用的xgtags相关函数, 比较初级. 应该有些很好用的没有发掘出来, 也请各位推荐一下 
;; xgtags-find-{file,rtag,tag,symbol,with-grep} 这些都是常用的 
;; xgtags-select-{next-tag,prev-tag} 
;; 一般常用的模式就是: 先xgtags-find-xxx, 屏幕分两半了, 然后就直接xgtags-select 
;; -{next-tag,prev-tag}, 在搜索到的多个点之间切换. 
;; 2. 目前的不便之处 
;; 2.1 如果找到的点太多, 单纯的select-next可能就会比较慢, 这时候就想要跳到列表中 
;; (*xgtags*), 然后直接选择想要看的点, 但是这时候似乎没有办法在别的buffer中打开 
;; , 直接就把当前的列表buffer( *xgtags*)给替换了.这时候, 就得xgtags-switch-to-b 
;; uffer, 重新跳回列表页. 
;; 问题是: 能不能在列表中选择某个tag点的时候, 直接变成在别的buffer打开呢? 这样就不用切换回列表页了. 
;; 2.2 更改了代码之后, 需要重新建索引, 都得手动到索引所在的目录去重新gtags 
;; 问题是: 有没有自动重新建立索引的办法, 或者有个函数来处理也行. 

;; 不过gtags有个“gtags --single-update filename”的指令，可以只更新指定的文件。我实验过几次，在项目特别大的时候，还是很慢。也可能是我不会使，反正我以后就一直没关注过这个问题。 

;; 我现在就手动更新。自己写了个函数： 
;; 如果把它绑定到after-save-hook上就可以保存后自动更新。对于整个项目的源代码大小小于100M的情况下效果还是不错的。 
(defun yp-gtags-append () 
  (interactive) 
  (if gtags-mode 
      (progn 
        (message "start to global -u") 
        (start-process "yp-gtags-append" "*scratch*" "global" "-u")))) 


;; 复制当前行
;; 发挥一下“按我说的做”的精神。为什么不把 Alt-w 变的更聪明一些，当没有激活的区域时就复制当前的一整行呢？说做就做:
;; <C-insert>
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
	 (message "Copied line")
	 (list (line-beginning-position)
		   (line-beginning-position 2)))))

;; 粘贴时自动格式化缩进
;; (dolist (command '(yank yank-pop))
;;   (eval
;;    `(defadvice, command (after indent-region activate)
;;       (and (not current-prefix-arg)
;;            (member major-mode
;; 				   '(emacs-lisp-mode
;; 					 lisp-mode clojure-mode scheme-mode
;; 					 haskell-mode ruby-mode rspec-mode
;; 					 python-mode c-mode c++-mode objc-mode
;; 					 latex-mode js-mode plain-tex-mode))

;; 		   (let ((mark-even-if-inactive transient-mark-mode))
;;              (indent-region (region-beginning) (region-end) nil))))))

(provide 'zsl-functions)
