;; 首先获得工程的相关文件，从配置文件的目录获得信息
;; 遍历目录
;; 配置文件读写，参照 custom-set-variables
;; 查找函数定义，变量定义; 查找函数和变量使用的地方; 打开头文件;
;; 使用find，grep，tags工具

(defsubst hide-dir-p (dir)
  (let ((endstr (file-name-nondirectory dir)))
	(char-equal (aref endstr 0) ?.)
  ))

(defsubst zsl-preproc-dir (dir &optional backslash)
  "backslash 要不要最后的反斜线"
  (let ((l (length dir)))
	(if (char-equal ?/ (aref dir (1- l)))
		(unless backslash (setq dir (substring dir 0 (1- l))))
	  (when backslash (setq dir (concat dir "/"))))) dir)

(defsubst zsl-expand-file-name (f)
  (setq f (zsl-preproc-dir f t))
  (expand-file-name f))

(defsubst skip-dir (dir)
  (let ( (ll (length dir)) )
	(or (hide-dir-p dir)
		(string= (substring dir (- ll 2) ll) "..")
		(string= (substring dir (- ll 1) ll) ".")
		(string= (substring dir (- ll 4) ll) ".svn")
		)
	)
  )

(defsubst skip-file (f)
  (let* ((fname (file-name-nondirectory f))
		(l (length fname)))
	(or (char-equal (aref fname 0) ?.)
		(char-equal (aref fname 0) ?#)
		(char-equal (aref fname (- l 1)) ?~)
		)))

(defun get-file-recursive (dir)
  "取得目录中的所有文件,包括子目录.没使用递归."
  (let (files dirs)
	(while dir
	  (dolist (f (directory-files dir t))
		(if (file-regular-p f)
			(unless (skip-file f) (setq files (cons f files)))
		  (if (file-directory-p f)
			  (unless (skip-dir f) (setq dirs (cons f dirs))))))

	  (setq dir (car dirs))
	  (setq dirs (cdr dirs))
	  )
	files
	)
  )

(defun directory-contents-modified (dir buf timestamp)
  (let (stamp)
	(with-current-buffer buf
	  (goto-char (point-min))
	  (setq stamp (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
	  (setq stamp (car (read-from-string stamp)))

	  (if (equal stamp timestamp)
		  (progn (message "no change in dir[%s]" dir) nil)
		(progn (message "dir[%s] contents changed." dir) t))
	  )))

(defun get-dirs-and-files2disk (dir file extfilter)
  "得到目录中的文件，写入文件列表; 返回子目录list"
  (let ((buf (find-file-noselect file))
		(timestamp  (nth 5 (file-attributes dir)))
		subdirs dfiles)
	
	(dolist (var (directory-files dir t))
	  (if (file-regular-p var)
		  (when (and (not (skip-file var)) (member (file-name-extension var) extfilter))
			(setq dfiles (cons var dfiles)))
		(when (file-directory-p var)
		  (unless (skip-dir var) (setq subdirs (cons var subdirs))))))

	(when (and dfiles
			   (or (= (buffer-size buf) 0) (directory-contents-modified dir buf timestamp)))
	  (with-current-buffer buf
		(buffer-disable-undo)
		(erase-buffer)
		(insert (format "%S\n" timestamp))
		(dolist (fv dfiles) (progn (insert fv) (insert "\n")))
		(save-buffer)))
	(kill-buffer buf)
	(cons (length dfiles) subdirs)
	))

(defun update-dirfile-list (idir odir extfilter)
  ;; 每个目录中的文件写入一个srclist文件,不递归
  (let ((bk make-backup-files)
		(base-dir (zsl-expand-file-name odir))
		(idir (expand-file-name idir))
		dirs ret file-list-name full-file-name srclist)

	(setq make-backup-files nil)			;临时关闭备份
	(unless (file-exists-p base-dir) (make-directory base-dir))
	(while idir
	  (setq file-list-name (make-project-srclist-name idir))
	  (setq full-file-name (concat base-dir file-list-name))
	  (setq ret (get-dirs-and-files2disk idir full-file-name extfilter))
	  (when (> (car ret) 0) (setq srclist (cons full-file-name srclist)))

	  (setq dirs (append (cdr dirs) (cdr ret)))
	  (setq idir (car dirs))
	  )

	(setq make-backup-files bk)			;恢复备份
	(message "update file list  complete!")
	srclist
	)
  )

(defun zsl-read-project-cfg (&rest args)
  (message "%S" args)
  (setq zsl-project-cfg args)
  )

(defun zsl-get-cfg-name ()
  (let ((base (zsl-expand-file-name eprojs))
		(pname (alist-value 'project-name zsl-project-cfg))
		)
	(concat base pname ".cfg.el")
  ))

(defun zsl-write-project-cfg (file cfg &optional update)
  (message "%S" cfg)
  (if (and (file-exists-p file) (not update)) (message "The %s already exists." file)
	(with-current-buffer (find-file-noselect file)
	  (buffer-disable-undo) (erase-buffer)
	  (zsl-project-print-cfg cfg)
	  (save-buffer)
	  (kill-buffer)))
  )

(defsubst zsl-project-print-cfg (cfg)
  (insert "(zsl-read-project-cfg\n")
  (mapcar
   (lambda (e)
	 (progn (insert "'(")
			(insert (symbol-name (car e)))
			(insert " . ")
			(if (stringp (cdr e))
				(insert "\"" (cdr e) "\"")
			  (insert (format "%S" (cdr e))))
			(insert ")\n")
			))
   cfg)
  (insert ")\n")
  )

(defun find-string-in-file (s file)
  (let ((filebuf (find-file-noselect file))	p lines)
	(with-current-buffer filebuf
	  (setq buffer-read-only t)
	  (setq s (concat "\\b" s "\\b"))
	  (goto-char (point-min))
	  (while (setq p (search-forward-regexp s (point-max) t))
		;; (setq points (cons p points))
		(setq lines
			  (cons (buffer-substring-no-properties
					 (line-beginning-position)
					 (line-end-position)) lines))
		)
	  (kill-buffer)
	  )
	lines
	)
  )

(defun read-file2string (file )
  (let ((filebuf (find-file-noselect file))	lb le blines)
	(with-current-buffer filebuf
	  (setq buffer-read-only t)
	  (while (not (eobp))
		(setq lb (line-beginning-position) le (line-end-position))
		(unless (= lb le)
		  (if (= 0 (length blines))
			  (setq blines (buffer-substring-no-properties lb le))
			(setq blines
				  (concat blines " " (buffer-substring-no-properties lb le)))))
		(forward-line)
		)
	  (kill-buffer)
	  )
	blines
	)
  )

(defun read-file2list (file )
  (let ((filebuf (find-file-noselect file))	lb le blines)
	(with-current-buffer filebuf
	  (setq buffer-read-only t)
	  (forward-line)					;skip first line : timestamp
	  (while (not (eobp))
		(setq lb (line-beginning-position) le (line-end-position))
		(unless (= lb le)
			(setq blines
				  (cons (buffer-substring-no-properties lb le) blines)))
		(forward-line)
		)
	  (kill-buffer)
	  )
	blines
	)
  )

(defsubst list2string (l &optional separator)
  (let (s)
	(while l
	  (if (stringp (car l)) (setq s (concat s (car l))))
	  (setq l (cdr l))
	  (if (and separator l) (setq s (concat s ":")))
	  )
	s
	)
  )

(defsubst alist-value (key alist) (cdr (assq key alist)))
(defsubst alist-value1 (key alist) (cdr (assoc key alist)))

(defsubst set-alist-value (key value alist) (setcdr (assq key alist) value))
(defsubst set-alist-value1 (key value alist)
  "如果新增了element,则反回新的alist, 否则反回nil."
  (let ((e (assoc key alist))
		)
	(if e (progn (setcdr e value) nil)
	  (cons (cons key value) alist))
	))

;; (defsubst append-alist-value (key value alist)
;;   (let ((x (alist-value key alist))) (setcdr (assq key alist) (cons value x))))
(defsubst append-alist-value (key value alist)
  (let ((e (assq key alist))) (setcdr e (cons value (cdr e)))))

(defun sentinel-msg-me (process event)
  (princ
   (format "\nProcess: %s had the event `%s'" process event)))

(defun create-etags-table-async (args)
  (if (executable-find "etags")
	  (let ((etags-init-process
			 (apply 'start-process
					"etags-process" "etags-process-buffer" "etags" args)))
		(set-process-sentinel etags-init-process 'sentinel-msg-me))
	(message "command `etags' not find!\n"))
  )

(defun create-etags-table-sync (args)
  (if (executable-find "etags")
	  (apply 'call-process
			 "etags" nil "etags-process-buffer" nil args)
	(message "command `etags' not find!\n"))
  )

(defun create-gtags-sync (args)
  (if (executable-find "gtags")
	  (apply 'call-process
			 "gtags" nil "global-gtags-process-buffer" nil args)
	(message "command `gtags' not find!\n"))
  )

(defun update-gtags-sync (args)
  (if (executable-find "global")
	  (apply 'call-process
			 "global" nil "update-gtags-process-buffer" nil args)
	(message "command `global' not find!\n"))
  )

;; (defun cscope-run (args)
;;   (setq args (append args
;; 					 (list "-v"
;; 						   "-i" cscope-index-file
;; 						   "-f" cscope-database-file
;; 						   (if cscope-use-relative-paths
;; 							   "." top-directory))))
;;   (if cscope-index-recursively
;; 	  (setq args (cons "-r" args)))
;;   (setq cscope-unix-index-process
;; 		(apply 'start-process "cscope-indexer"
;; 			   cscope-unix-index-process-buffer
;; 			   cscope-indexing-script args))
;;   (set-process-sentinel cscope-unix-index-process
;; 						'cscope-unix-index-files-sentinel)
;;   (process-kill-without-query cscope-unix-index-process)
;;   )

(defun zsl-string-inquote ()
  (interactive)
  (save-excursion
	(let* ((begin (line-beginning-position))
		   (end (line-end-position)) symbol)
	  (skip-chars-backward "^\"< (`'\n")
	  (setq begin (point))
	  (skip-chars-forward "^\"> ')\n")
	  (setq end (point))
	  (setq symbol (buffer-substring-no-properties begin end))
	  ;; (message "[%s]" symbol)
	  symbol
	  )
	))