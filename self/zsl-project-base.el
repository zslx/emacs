
;; [FIXED BUGS]
;; gtags: Gtags causes segmentation fault if it read its input file names from
;; a file list (use -f option), and the input files aren't in the working
;; directory or its sub-directories.

(load "zsl-project-core.el")

(defvar emacs-project-files '((srcflist nil) ;source file list
							  (gtagsdir nil)
							  (tagxflist nil))
  "保存工程所需的各类文件列表，是一个 alist(association list)")

(defsubst init-project-vars ()
  (set-alist-value 'srcflist '() emacs-project-files)
  (set-alist-value 'tagxflist '() emacs-project-files)
  (set-alist-value 'gtagsdir '() emacs-project-files)
  )

(defun make-project-srclist-name (spath)
  (let (sfpath)
	(setq spath (zsl-preproc-dir spath))
	(setq sfpath
		  (replace-regexp-in-string
		   "/\\|:" "_" (expand-file-name spath)))
	(concat sfpath ".srclist")))

(defsubst get-srclist-dir (sfile)
  (let* ((dstr (file-name-sans-extension (substring sfile 1)))
		 (dirs (split-string dstr "_")) sdir (ok t))
	(dolist (d dirs)
	  (if ok (setq sdir (concat sdir "/" d))
		(setq sdir (concat sdir "_" d)))
	  (if (file-exists-p sdir) (setq ok t) (setq ok nil))
	  )
	sdir
	)
  )

(defsubst query-srclist-dir (sfile dlist)
  (let (thed e (f (file-name-nondirectory sfile)))
	(while dlist
	  (setq e (car dlist) dlist (cdr dlist))
	  (when (string-equal f (make-project-common-file-name e))
	    (setq thed e dlist ())
		)
	  )
	thed
	)
  )

;; create source files list
(defun create-src-file-list ()
  "每个目录中的文件写入一个srclist文件"
  (let ((srcdirs (alist-value 'project-dirs zsl-project-cfg))
		(outdir (zsl-project-dir))
		(extfilter (alist-value 'project-file-types zsl-project-cfg))
		srclist
		)
	;; project source files
	(dolist (dir srcdirs)
	  (when (file-directory-p dir)
		(setq srclist (append (update-dirfile-list dir outdir extfilter) srclist))
		))

	;; common lib files
	(setq srcdirs (alist-value 'common-dir-list zsl-project-cfg))
	(setq outdir (zsl-project-common-dir))
	(dolist (dir srcdirs)
	  (when (file-directory-p dir)
		(setq srclist (append (update-dirfile-list dir outdir extfilter) srclist))
		))
  (set-alist-value 'srcflist srclist emacs-project-files)
  (message "create-src-file-list complete!")
  ))

(defsubst zsl-project-dir () (concat (zsl-expand-file-name eprojs) (alist-value 'project-name zsl-project-cfg)))
(defsubst zsl-project-common-dir () (concat (zsl-expand-file-name eprojs) "common/"))

(defsubst make-etags-fname (tdir sname)
  (concat tdir sname ".tags")
  )

;; etags 找到定义
(defsubst zsl-create-etags (tdir sname srclist)
  (let ((tagfile (make-etags-fname tdir sname)) args)
	(append-alist-value 'tagxflist tagfile emacs-project-files)
	(if (file-exists-p tagfile)
		(message "project tag-xref[%s] exists" tagfile)
	  (progn (setq args (read-file2list srclist))
			 (setq args (append (list "-a" "-o" tagfile) args))
			 ;; (princ args)
			 (create-etags-table-sync args))
	  )
	)
  )

(defsubst make-global-dname (tdir sname)
  (concat tdir sname ".gtags")
  )

;; global.gtags 找到使用
(defsubst zsl-create-gtags (tdir sname srclist)
  (cd "/")							;source tree root
  (let ((gtagsd (make-global-dname tdir sname)) args)
	(append-alist-value 'gtagsdir gtagsd emacs-project-files)
	(if (file-exists-p gtagsd) (message "project gtags[%s] exists" gtagsd)
	  (progn (make-directory gtagsd)
			 (setq args (list "-f" srclist gtagsd))
			 ;; (message "gtags(%s)[%s]" (pwd) args)
			 (create-gtags-sync args))
	  )
	)
  )

;; create tags and xcscope
(defun update-tags-xref (srclist)
  (interactive "fThe project source file list:")
  (setq srclist (expand-file-name srclist))
  ;; (message "project srcfile list[%s]" srclist)
  (setq make-backup-files nil)			;临时关闭备份
  (let ((sname (file-name-nondirectory srclist))
		(sdir (file-name-directory srclist))
		)

	;; etags
	(zsl-create-etags sdir sname srclist)
	;; global gtags
	(zsl-create-gtags sdir sname srclist)

	;; cscope
	;; (setq cscope-index-file srclist)
	;; (cscope-unix-index-files-internal (file-name-directory srclist) nil "-bq")
	)
  (setq make-backup-files t)
  )

(defun update-tags-xref-1 (srclist)
  (interactive "fThe project source file list:")
  (setq srclist (expand-file-name srclist))
  ;; (message "project srcfile list[%s]" srclist)
  (let ((sname (file-name-nondirectory srclist))
		(sdir (file-name-directory srclist))
		tagfile gtagsd)
	;; etags
	(setq tagfile (make-etags-fname sdir sname))
	(append-alist-value 'tagxflist tagfile emacs-project-files)

	;; global
	(setq gtagsd (make-global-dname sdir sname))
	(append-alist-value 'gtagsdir gtagsd emacs-project-files)

	;; cscope
	;; (setq cscope-index-file srclist)
	;; (cscope-unix-index-files-internal (file-name-directory srclist) nil "-bq")
	)
  )

(defsubst reset-etags-table-list ()
  (setq tags-table-list '())
  (setq tags-file-name nil)
  (dolist (var (alist-value 'tagxflist emacs-project-files)) ;3
  	;; (visit-tags-table var)
	(setq tags-table-list (cons var tags-table-list))
  	)
  )

;; (getenv "GTAGSLIBPATH")
(defsubst reset-global-env ()
  "Tell tags commands the root directory of source tree."
  (let ((tagdirs (list2string (cdr (assq 'gtagsdir emacs-project-files)) ":")))
	(setenv "GTAGSROOT" "/")
	(setenv "GTAGSDBPATH" tagdirs)
	(setenv "GTAGSLIBPATH" tagdirs)
	))

;; eg. define user commond
(defun find-symbol-define (symbol)
  "find the symbol define\n"
  (interactive
   (let ((sb (symbol-at-point)) val)
	 (setq val (completing-read
				(if sb (format "find (default %s):" sb)
				  "find symbol:")
				obarray 'boundp t nil nil (and sb (symbol-name sb))))
	 (list (if (equal val "") sb (intern val)))
	 ))
  
  (if (null symbol) (message "You didn't specify a symbol")
	(message "find %s\n" (symbol-name symbol)))
  )

(defun locate-to-symbol ()
  (interactive)
  (let* ((l (buffer-substring-no-properties
			(line-beginning-position) (line-end-position)))
		 (li (split-string l))
		 (buffer (find-file (nth 2 li))))
	(goto-line (string-to-int (nth 1 li)))
	(bookmark-set "tmp-project-jump-reg")
	)
  )
(defun zsl-project-jump-back ()
  (bookmark-jump "tmp-project-jump-reg")
  )

(defun global-find-tag (tagname &rest opts)
  "find the tag\n"
  (setq buffer (generate-new-buffer
				(generate-new-buffer-name (concat "*GTAGS* " tagname))))
  (set-buffer buffer)
  ;; (cd "/")							;source tree root
  (let ((option "-x")
		(sroot "/")
		(l (cdr (assq 'gtagsdir emacs-project-files)))
		(axe (locate-file-internal "zsl-global.sh" load-path))
		)
	(dolist (e opts)
	  (setq option (concat option e))
	  )
	(dolist (d l)
	  ;; (cd d)
	  (insert d "\n")
	  ;; (call-process "global" nil t nil option tagname)
	  (call-process axe nil t nil sroot d option tagname)
	  )
	)
  ;; (vi-mode t)
  (switch-to-buffer buffer)
  )
