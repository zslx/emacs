;; Project Tree views
;;; study form dirtree.el --- Directory tree views
;; Sat Mar 17 16:50:02 CST 2012 by zhshenglin@163.com

;; http://sourceforge.net/directory/development/emacs

;; todo
;; 1 open a eshell : M-x eshell
;; 2 open dired : F6
;; 3 edit current selected ok
;; 
(require 'tree-mode)
;; (require 'dired-x)						;dired-omit-regexp

(define-derived-mode zptree-mode tree-mode "Project-Trees"
  "A mode to display tree of projects"
  (tree-widget-set-theme "folder"))

(defun zptree-open ()
  "打开工程的目录"
  (interactive)

  (switch-to-buffer (concat "*emacs projects*"))
  (kill-all-local-variables)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (widget-insert (format "%s \n\n" (expand-file-name eprojs)))

  ;; project tree root widget
  (widget-create 'tree-widget
				 :open t
				 :tag "project root"
				 :expander 'zptree-expand-projects
				 :data eprojs
				 )

  (use-local-map widget-keymap)
  (widget-setup)
  (zptree-mode)
  )

(defun zptree-expand-projects (tree)
  "列出有哪些工程"
  (let ((data (widget-get tree :data))
		root)
	(when (file-directory-p data)
	  (setq root (expand-file-name data))
	  (mapcar 'zptree-new-projnode (zsl-valid-regular-files root)))))

(defun zptree-new-projnode (e)
  `(tree-widget
	:tag ,(file-name-nondirectory e)
	:expander zptree-expand-the-project
	:data ,e
	)
  )

(defun zptree-expand-the-project (tree)
  (let ((data (widget-get tree :data))
		)
	(load data) 						;set global var zsl-project-cfg
	;; (message "%S" zsl-project-cfg)
	(mapcar (lambda (e)
			  (list 'tree-widget
					:tag (symbol-name (car e))
					:expander 'zptree-expand-project-item
					:data (cdr e)
					)) zsl-project-cfg)))

(defun zptree-expand-project-item (tree)
  (let* ((tag (widget-get tree :tag))
		 (data (widget-get tree :data))
		 ef
		 )
	(if (stringp data) (list
						`(tree-widget
						  :node (push-button
								 :tag ,data
								 :format "%[%t%]\n"
								 :button-icon "leaf")))
	  (if (listp data)
		  (mapcar (lambda (e)
					(setq ef (expand-file-name e))
					(if (file-readable-p ef)
						(if (file-directory-p ef)
							`(tree-widget
							  :node (push-button
									 :tag ,ef
									 :format "%[%t%]\n"
									 :button-icon "bucket"
									 )
							  :expander zptree-expand-dir
							  :data ,ef
							  )
						  `(tree-widget
							:node (push-button
								   :tag ,(file-name-nondirectory ef)
								   :format "%[%t%]\n"
								   :button-icon "leaf"
								   :notify zptree-view-file
								   )
							:data ,ef))
					  `(tree-widget
						:node (push-button
							   :tag ,e
							   :format "%[%t%]\n"
							   :button-icon "leaf"
							   :notify zptree-show-message
							   )
						:tag ,e))) data)))))

(defun zptree-show-message (widget &rest ignore)
  (message "%s" (widget-get (widget-get widget :parent) :tag))
  )

(defun zptree-view-file (widget &rest ignore)
  (let ((data (widget-get (widget-get widget :parent) :data))
		)
	(when (file-readable-p data)
	  (view-file-other-window data))))

(defun zptree-expand-dir (tree)
  (let* ((data (widget-get tree :data))
		 )
	(mapcar (lambda (e)
			  (if (file-directory-p e)
				  `(tree-widget
					:node (push-button
						   :tag ,(file-name-nondirectory e)
						   :format "%[%t%]\n"
						   :button-icon "bucket"
						   :notify zptree-show-message
						   )								 
					:tag ,e
					:expander zptree-expand-dir
					:data ,e
					)
				`(tree-widget
				  :node (push-button
						 :tag ,(file-name-nondirectory e)
						 :format "%[%t%]\n"
						 :button-icon "leaf"
						 :notify zptree-view-file
						 )
				  :tag ,e
				  :data ,e
				  )))
			(zsl-valid-files data))))

(defun zsl-valid-files (dir)
  (let ((files (directory-files dir 'full))
		validfs)
	(mapcar (lambda (d)
			  (when
				  (and (file-readable-p d)
					   (not (skip-dir d)) (not (skip-file d)))
				(setq validfs (cons d validfs)))) files)
	validfs
	)
  )

(defun zsl-valid-regular-files (dir)
  (let ((files (directory-files dir 'full))
		validfs)
	(mapcar (lambda (d) (when (and (file-readable-p d) (file-regular-p d)
								   (not (skip-dir d)) (not (skip-file d)))
						  (setq validfs (cons d validfs)))) files)
	validfs
	)
  )


(defun zptree-refresh-node (widget &rest ignore)
  "Refresh WIDGET parent tree children.
IGNORE other arguments."
  ;; Clear the tree children cache.
  (widget-put widget :args nil)
  ;; Redraw the tree node.
  (widget-value-set widget (widget-value widget)))


(defun zptree-mode-reflesh ()
  "Reflesh parent tree."
  (interactive)
  (message "zptree-mode-reflesh")
  (let ((tree (tree-mode-parent-current-line)))
    (if tree
        (zptree-refresh-node tree)
      (message "No tree at point!"))))

(defun zptree-mode-edit ()
  (interactive)
	(let ((w (widget-at))
		  fname)
	  (when w (setq fname (widget-get (widget-get w :parent) :data))
			(message "%s" fname)
			(and (file-readable-p fname)
				 (find-file-other-window fname)))))

(defun zptree-mode-node-info ()
  (interactive)
  (let ((icon (widget-at))
		w tag data parent itag)
	(if icon
		(progn
		  (setq w (widget-get icon :parent))
		  (when w
			(setq tag (widget-get w :tag))
			(setq itag (widget-get icon :tag))
			(setq data (widget-get w :data))
			(setq parent (widget-get w :parent))
			(message "w:%s i:%s p:%s\n wtag:%s, wdat:%s, itag:%s"
					 (car w) (car icon) (car parent) tag data itag)
			))
	  (message "point not have a widget.")))
  )

(defun zptree-mode-get-projcfg ()
  (interactive)
  (let (root projr cfg)
	(ignore-errors
	  (setq root (tree-mode-widget-root (tree-mode-icon-current-line)))
	  (setq projr (tree-mode-icon-current-line))
	  (while (not (eq root (widget-get projr :parent)))
		(setq projr (widget-get projr :parent)))
	  (setq cfg (widget-get projr :data))
	  ;; (message "%s, %s" (widget-get projr :tag) cfg)
	  )
	)
  )

(defun zptree-mode-switch-project (refresh)
  "prefix argument, 有则执行刷新，无则执行切换, 默认值是 1"
  (interactive "p")
  (let ((cfg (zptree-mode-get-projcfg))
		(projdir (zsl-project-dir))
		)
	(load cfg)
	(if (and (equal refresh 1) (file-exists-p projdir))
		(zsl-switch-project) (zsl-prepare-project))
	))

;; common
(define-widget 'ztree-dir-widget 'tree-widget
  "Directory Tree widget."
  :expander 'ztree-expand
  :has-children t)

(define-widget 'ztree-file-widget 'push-button
  "File widget."
  :format "%[%t%]\n"
  :button-face 'default
  :notify 'ztree-select)

(defvar ztree-ignore-file-regexp "\.svn$")
(setq ztree-ignore-file-regexp "\.svn$\\|\.o$\\|\.elc\\|^\.$\\|^\.\.$")

(defun ztree-expand (tree)
  (or (widget-get tree :args)
	  (let ((directory (widget-get tree :data))
			;; (re (dired-omit-regexp))
			(re ztree-ignore-file-regexp)
			fname dirs files
			)
		(dolist (file (directory-files directory t))
		  (setq fname (file-name-nondirectory file))
		  (unless (string-match re fname)
			(if (file-directory-p file)
				(push (cons file fname) dirs)
			  (push (cons file fname) files))))
        (setq dirs (sort dirs (lambda (a b) (string< (cdr a) (cdr b)))))
        (setq files (sort files (lambda (a b) (string< (cdr a) (cdr b)))))
		(append
		 (mapcar (lambda (file)
				   `(ztree-dir-widget
					 :data ,(car file)
					 :node (ztree-file-widget
							:tag ,(cdr file)
							:data ,(car file))))
				 dirs)
		 (mapcar (lambda (file)
				   `(ztree-file-widget
					 :data ,(car file)
					 :tag ,(cdr file)))
				 files)))))

(defun ztree-select (node &rest ignore)
  (let ((file (widget-get node :data)))
	(and file (view-file-other-window file))))

(defun ztree-root-widget (dir)
  `(ztree-dir-widget
	:node (ztree-file-widget
		   :tag ,dir
		   :data ,dir)
	:data ,dir
	:open t))

(defun ztree-mode-new-tree (dir)
  ;; (interactive "DDirectory: \nP")
  (interactive "DDirectory: \n")
  (let ((root (expand-file-name dir))
		tree
		)
  (message "%s" dir)
  (goto-char (point-max))
  (setq tree (widget-create (ztree-root-widget root)))
  ))

(defun ztree-mode-root-linep ()
  "If the root tree node in current line, return t"
  (let ((wid (tree-mode-icon-current-line)))
    (and wid (not (tree-widget-leaf-node-icon-p wid))
         (null (widget-get (widget-get wid :parent) :parent)))))

(defun ztree-delete-tree ()
  "Delete a tree from buffer."
  (interactive)
  (if (tree-mode-root-linep)
      (if (yes-or-no-p "Delete current tree? ")
          (widget-delete (tree-mode-tree-ap)))
    (message "No tree at point!")))

(defun ztree-create-project-cfg ()
  (interactive)
  (let ((subw (widget-at))
		w tag dir)
	(if subw
		(progn
		  (setq w (widget-get subw :parent))
		  (setq dir (widget-get w :data))
		  (setq tag (file-name-nondirectory dir))
		  (when (and (file-directory-p dir) (file-readable-p dir))
			(message "%s:%s" tag dir)
			(zsl-create-project-cfg tag dir)))
	  (message "No project at point!")
	  )))

(defun zptree-mode-exclude-dir ()
  (interactive)
  (let ((subw (widget-at))
		w dir)
	(if subw
		(progn
		  (setq w (widget-get subw :parent))
		  (setq dir (widget-get w :data))
		  (if (and (stringp dir) (file-directory-p dir))
			  (progn
				(message "exclude dir[%s]" dir)
				(zsl-update-project-cfg 'excluded-dir dir)
				)
			(message "Isn't directory at point!")
			))
	  (message "No directory at point!")
	  )))

;; tree operations
(define-key zptree-mode-map "g" 'zptree-mode-reflesh)
(define-key zptree-mode-map "\C-cn" 'ztree-mode-new-tree)
(define-key zptree-mode-map "\C-ck" 'ztree-delete-tree)
;; test
(define-key zptree-mode-map "\C-c\C-c" 'zptree-mode-node-info)

;; project operations
(define-key zptree-mode-map "\C-c\C-f" 'zptree-mode-edit)
(define-key zptree-mode-map "\C-cp" 'zptree-mode-switch-project)
(define-key zptree-mode-map "\C-c\C-e" 'zptree-mode-exclude-dir)
(define-key zptree-mode-map "\C-czp" 'ztree-create-project-cfg)

;; C-z g : zsl-ffap (locate-file

;; tree-mode bindings
;; key             binding
;; ---             -------
;; RET		widget-button-press
;; ESC		Prefix Command
;; 0 .. 9		digit-argument

;; !		tree-mode-collapse-other-except
;; /		tree-mode-keep-match

;; D		tree-mode-delete-tree
;; E		tree-mode-expand-level

;; e		tree-mode-toggle-expand
;; g		tree-mode-reflesh

;; j		tree-mode-next-sib
;; k		tree-mode-previous-sib
;; n		tree-mode-next-node
;; p		tree-mode-previous-node
;; r		tree-mode-goto-root
;; u		tree-mode-goto-parent

;; s		tree-mode-sort-by-tag
;; DEL		scroll-down
;; <S-tab>		widget-backward
;; <backtab>	widget-backward
;; <down-mouse-1>	widget-button-click
;; <down-mouse-2>	widget-button-click

;; C-M-i		widget-backward
