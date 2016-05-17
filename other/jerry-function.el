;;; 我常用的lisp函数，有很多都是从别的地方抄过来的，能不能用大家自己试
;;; jerry-function.el --- my function

;; emacs-lisp-mode ;; emacs编译整个目录下的*.el文件两3个办法
;; 1. 输入 [Alt]-x 。 当提示输入命令时，输入: byte-force-recompile [Enter] 。
;; 2. 在dired里面用m标记，然后用B编译
;; 3. 还有就是用emacs的批处理： emacs -batch -f batch-byte-compile *.el

;;  保存时自动编译目录下的el文件 为.elc文件
(defconst emacs-basic-conf-dir zlisp)
(defconst emacs-ext-elisp-dir elib)
(defun autocompile nil
  "Automagically compile change to .emacs and other dotfiles."
  (interactive)
  (cond ( (string= (buffer-file-name) (concat default-directory ".emacs") )
         (byte-compile-file (buffer-file-name)))

        ((string= (abbreviate-file-name (buffer-file-name))
				  (concat emacs-basic-conf-dir
						  (replace-regexp-in-string "\\.el" "" (buffer-name)) ".el"))
		 (byte-compile-file (buffer-file-name)))

		((string= (abbreviate-file-name (buffer-file-name))
                  (concat emacs-ext-elisp-dir
                          (replace-regexp-in-string "\\.el" "" (buffer-name)) ".el"))
		 (byte-compile-file (buffer-file-name)))
        )
  )
;;(add-hook 'after-save-hook 'autocompile)

;;{{{ 时间戳设置，插入文档内的
(defun my-timestamp ()
  "Insert the \"Time-stamp: <>\" string at point."
  (interactive)
  (if (interactive-p)
      (insert " Time-stamp: <>")
    " Time-stamp: <>"))
;;}}}

;;{{{ 找到这个buffer里最长的一行，并且到达哪里，很不错的功能
(defun my-longest-line (&optional goto)
  "Find visual length (ie in columns) of longest line in buffer.
If optional argument GOTO is non-nil, go to that line."
  (interactive "p")                    ; NB not p
  (let ((maxlen 0)
        (line 1)
        len maxline)
    (save-excursion
      (goto-char (point-min))
      (goto-char (line-end-position))
      ;; Not necessarily same as line-end - line-beginning (eg tabs)
      ;; and this function is for visual purposes.
      (setq len (current-column))
      (if (eobp)                        ; 1 line in buffer
          (setq maxlen len
                maxline line)
        (while (zerop (forward-line))
          (goto-char (line-end-position))
          (setq line (1+ line)
                len (current-column))
          (if (> len maxlen)
              (setq maxlen len
                    maxline line)))))
    (if (not (interactive-p))
        maxlen
      (message "最长的一行是第%s行 (%s)" maxline maxlen)
      ;(message "Longest line is line %s (%s)" maxline maxlen)
      (if goto (goto-line maxline)))))
;;}}}

;;{{{ 删除一些临时的buffers，少占我的内存
(defvar my-clean-buffers-names
  '("\\*Completions" "\\*Compile-Log" "\\*.*[Oo]utput\\*$"
    "\\*Apropos" "\\*compilation" "\\*Customize" "\\*Calc""\\keywiz-scores"
    "\\*BBDB\\*" "\\*trace of SMTP" "\\*vc" "\\*cvs" "\\*keywiz"
    "\\*WoMan-Log" "\\*tramp" "\\*desktop\\*" ;;"\\*Async Shell Command"
    )
  "List of regexps matching names of buffers to kill.")

(defvar my-clean-buffers-modes
  '(help-mode );Info-mode)
  "List of modes whose buffers will be killed.")

(defun my-clean-buffers ()
  "Kill buffers as per `my-clean-buffer-list' and `my-clean-buffer-modes'."
  (interactive)
  (let (string buffname)
    (mapcar (lambda (buffer)
              (and (setq buffname (buffer-name buffer))
                   (or (catch 'found
                         (mapcar '(lambda (name)
                                    (if (string-match name buffname)
                                        (throw 'found t)))
                                 my-clean-buffers-names)
                         nil)
                       (save-excursion
                         (set-buffer buffname)
                         (catch 'found
                           (mapcar '(lambda (mode)
                                      (if (eq major-mode mode)
                                          (throw 'found t)))
                                   my-clean-buffers-modes)
                           nil)))
                   (kill-buffer buffname)
                   (setq string (concat string
                                        (and string ", ") buffname))))
            (buffer-list))
    (if string (message "清理buffer: %s" string)
    ;(if string (message "Deleted: %s" string)
       (message "没有多余的buffer"))))
      ;(message "No buffers deleted"))))
;;}}}

;;{{{ 打印出我的键盘图，很酷吧－全部热键都显示出来，呵呵
(defun my-keytable (arg)
  "Print the key bindings in a tabular form.
Argument ARG Key."
  (interactive "sEnter a modifier string:")
  (with-output-to-temp-buffer "*Key table*"
    (let* ((i 0)
           (keys (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n"
                       "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
                       "<return>" "<down>" "<up>" "<right>" "<left>"
                       "<home>" "<end>" "<f1>" "<f2>" "<f3>" "<f4>" "<f5>"
                       "<f6>" "<f7>" "<f8>" "<f9>" "<f10>" "<f11>" "<f12>"
                       "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
                       "`" "~" "!" "@" "#" "$" "%" "^" "&" "*" "(" ")" "-" "_"
                       "=" "+" "\\" "|" "{" "[" "]" "}" ";" "'" ":" "\""
                       "<" ">" "," "." "/" "?"))
           (n (length keys))
           (modifiers (list "" "C-" "M-" "S-" "M-C-" "S-C-")))
      (or (string= arg "") (setq modifiers (list arg)))
      (setq k (length modifiers))
      (princ (format " %-10.10s |" "Key"))
      (let ((j 0))
        (while (< j k)
          (princ (format " %-50.50s |" (nth j modifiers)))
          (setq j (1+ j))))
      (princ "\n")
      (princ (format "_%-10.10s_|" "__________"))
      (let ((j 0))
        (while (< j k)
          (princ (format "_%-50.50s_|"
                         "__________________________________________________"))
          (setq j (1+ j))))
      (princ "\n")
      (while (< i n)
        (princ (format " %-10.10s |" (nth i keys)))
        (let ((j 0))
          (while (< j k)
            (let* ((binding
                    (key-binding (read-kbd-macro (concat (nth j modifiers)
                                                         (nth i keys)))))
                   (binding-string "_"))
              (when binding
                (if (eq binding 'self-insert-command)
                    (setq binding-string (concat "'" (nth i keys) "'"))
                  (setq binding-string (format "%s" binding))))
              (setq binding-string
                    (substring binding-string 0 (min (length
                                                      binding-string) 48)))
              (princ (format " %-50.50s |" binding-string))
              (setq j (1+ j)))))
        (princ "\n")
        (setq i (1+ i)))
      (princ (format "_%-10.10s_|" "__________"))
      (let ((j 0))
        (while (< j k)
          (princ (format "_%-50.50s_|"
                         "__________________________________________________"))
          (setq j (1+ j))))))
  (delete-window)
  ;;(hscroll-mode)
  (setq truncate-lines t))              ; for emacs 21
;;}}}

;;     在回显区显示一点东西,以免觉得 Emacs 在干什么其他奇怪的事情。
;;     (message "searching for %s ..." (buffer-substring begin end))

;; 默认就有下面功能吧？
;;{{{
;; ;; 调用 stardict 的命令行接口来查辞典
;; ;; 如果选中了 region 就查询 region 的内容，
;; ;; 否则就查询当前光标所在的词
;; (defun kid-star-dict ()
;;   "Serch dict in stardict."
;;   (interactive)
;;   (let ((begin (point-min))
;;         (end (point-max)))
;;     (if mark-active
;;         (setq begin (region-beginning)
;;               end (region-end))
;;       (save-excursion
;;         (backward-word)
;;         (mark-word)
;;         (setq begin (region-beginning)
;;               end (region-end))))
;;     ;; 有时候 stardict 会很慢，所以
;;     在回显区显示一点东西,以免觉得 Emacs 在干什么其他奇怪的事情。
;;     (message "searching for %s ..." (buffer-substring begin end))
;;     (tooltip-show
;;      (shell-command-to-string
;;       (concat "sdcv -n "
;;               (buffer-substring begin end))))))

;; ;; 如果选中了 region 就查询 region 的内容，否则查询当前光标所在的单词
;; ;; 查询结果在一个叫做 *sdcv* 的 buffer 里面显示出来，在这个 buffer 里面
;; ;; 按 q 可以把这个 buffer 放到 buffer 列表末尾，按 d 可以查询单词
;; (defun kid-sdcv-to-buffer ()
;;   "Search dict in region or world."
;; (interactive)
;;   (let ((word (if mark-active
;;                   (buffer-substring-no-properties (region-beginning) (region-end))
;;       (current-word nil t))))
;;     (setq word (read-string (format "Search the dictionary for (default %s): " word)
;;                             nil nil word))
;;     (set-buffer (get-buffer-create "*sdcv*"))
;;     (buffer-disable-undo)
;;     (erase-buffer)
;;     (let ((process (start-process-shell-command "sdcv" "*sdcv*" "sdcv" "-n" word)))
;;       (set-process-sentinel
;;        process
;;        (lambda (process signal)
;;          (when (memq (process-status process) '(exit signal))
;;            (unless (string= (buffer-name) "*sdcv*")
;;              (setq kid-sdcv-window-configuration (current-window-configuration))
;;              (switch-to-buffer-other-window "*sdcv*")
;;              (local-set-key (kbd "d") 'kid-sdcv-to-buffer)
;;              (local-set-key (kbd "q") (lambda ()
;;                                         (interactive)
;;                                         (bury-buffer)
;;                                         (unless (null (cdr (window-list))) ; only one window
;;                                           (delete-window)))))
;;            (goto-char (point-min))))))))
;;}}}

;;{{{ lisp 里快速找到函数
(defvar my-defun-re
  (regexp-opt '("defun" "defsubst" "defmacro" "defadvice") 'paren)
  "Regular expression used to identify a defun.")

(defun my-jump-to-defun (func)
  "Jump to the definition of function FUNC in the current buffer, if found.
Return the position of the defun, or nil if not found."
  (interactive
   ;; From `describe-function'. *NB ?*
   (let ((fn (function-called-at-point)))
     (list (completing-read (if fn
                                (format "Find defun for (default %s): " fn)
                              "Find defun for: ")
                            obarray 'fboundp t nil nil (symbol-name fn)))))
  (let (place)
    (save-excursion
      (goto-char (point-min))
      (if (re-search-forward
           (concat "^[ \t]*(" my-defun-re "[ \t]+"
                   (regexp-quote func) "[ \t]+") (point-max) t)
          (setq place (point))))
    (if (not place)
        (if (interactive-p) (message "No defun found for `%s'" func))
      (when (interactive-p)
        (push-mark)
        (goto-char place)
        (message "Found defun for `%s'" func))
      place)))
;;}}}

;;{{{ 改变 tabbar-buffer-groups-function
;; 原来的 tabbar 强行对你的 buffer 进行分组，但是如果你想在你编辑的buffer间切换而不论它们是什么组，那么似乎没有
;; 一个好办法。但是 tabbar 本来提供了一个机制，让你可以自己确定 tab 属于哪组，只要修改
;; tabbar-buffer-groups-function 就行了。

;; 这样，我可以把每个 buffer 同时加入它所在的 major mode 的组和一个叫做 "default" 的组，这样我在 default 组里就
;; 可以方便的浏览到所有的 buffer 了。而切换到其它组就可以分组浏览。你还可以自行把某些 buffer 分到一组，比如我可
;; 以把 scheme-mode 的 buffer 和 inferer-scheme-mode 的 buffer 分到同一个组。
(setq tabbar-buffer-groups-function 'tabbar-buffer-ignore-groups)

(defun tabbar-buffer-ignore-groups (buffer)
  "Return the list of group names BUFFER belongs to.
Return only one group for each buffer."
  (with-current-buffer (get-buffer buffer)
    (cond
     ((or (get-buffer-process (current-buffer))
          (memq major-mode
                '(comint-mode compilation-mode)))
      '("Process")
      )
     ((member (buffer-name)
              '("*scratch*" "*Messages*"))
      '("Common")
      )
     ((eq major-mode 'dired-mode)
      '("Dired")
      )
     ((memq major-mode
            '(help-mode apropos-mode Info-mode Man-mode))
      '("Help")
      )
     ((memq major-mode
            '(rmail-mode
              rmail-edit-mode vm-summary-mode vm-mode mail-mode
              mh-letter-mode mh-show-mode mh-folder-mode
              gnus-summary-mode message-mode gnus-group-mode
              gnus-article-mode score-mode gnus-browse-killed-mode))
      '("Mail")
      )
     (t
      (list
       "default"  ;; no-grouping
       (if (and (stringp mode-name) (string-match "[^ ]" mode-name))
           mode-name
         (symbol-name major-mode)))
      )
     )))
;;}}}


(provide 'jerry-function)

;;; jerry-function.el ends here
