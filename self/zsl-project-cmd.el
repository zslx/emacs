;; 写代码重点是提示，看代码主要靠跳转，保证最终运行还有测试和调试。 CMM

;; 目标一： 文件树，方便浏览工程相关的所有文件; OK. use tree-widget
;; 实现策略： 参考 speedbar; 从 makefile/cmake 读取信息;
;; 工程的目录清单，文件清单（自动更新？），头文件，库文件，
;; 
;; Project Tree: include, source, others
;; include-dirs-files, project-used-files(根据 #include 关联进行扩展)
;; project-dirs, common-include-dirs
;; 鼠标操作，在浏览工程多个源文件时,编号
;; ? 目录和文件变化时，增删改？ 记录路径的最后更改时间
;; 
;; 如何关联？ 优先级？ 围绕项目用到的， 优先级顺序：项目目录，公司公共库目录，系统库目录;
;; 当前文件－>头文件->公共文件
;; system.type, company.type, project
;; system.el , company.cpp , zsl-emacs-lisp

;; 目标二： 查找 symbol 的定义和使用处。函数，变量，类; 打开头文件;
;; 实现策略：把已有的工具集成在一起 OnLinux
;; 4 find，grep 最靠谱 哈哈
;; 1 etags/ctags
;; 2 gtags,global, source navigator, understand, source insight,
;; 3 cscope,xcscope
;; (find-string-in-file "defun" "myelisp/zsl-project-cmd.el")
;; 5 开源的工具, variable, function, class, file, directory.
;; Semantic: (semantic).         Source code parsing utilities for Emacs.
;; 
;; 变量查找: 先字符串查找，筛选出文件，再语法分析查找，精确定位。
;; 空闲时自动调用语法分析，建立索引文件，为输入提示和自动完成做准备。
;; directory_name.symbol.index.n 每个文件索引一千个文件，
;; 若目录中超过一千个，则在后面加数字区别 n.
;; 如下：
;; common
;; _usr_include.srclist
;; _usr_include.tags
;; _usr_include.gtags
;; _usr_include.symbol.index.0
;; _usr_include.symbol.index.1
;; project folder
;; dir.srclist
;; dir.tags
;; dir.gtags
;; dir.symbol.index.n

;; 目标三：写程序时，代码提示，自动完成，模板生成等

;; 目标四：更新， 文件数量变化（增删、改名），文件内容发生变化（编辑）
;; 下面语句得到`last modification time', 文件以及目录内容被编辑的时间 (当前目录)
;; (current-time-string (nth 5 (file-attributes "/backup/2012/eprojs")))

;; 目标四：单元测试和Debug

;; 主要目标：代码浏览，工程管理（限定操作范围）
;; ui 设计，命令
;; find-symbol-define
;; find-symbol-using
;; goto-include-file
;; goto-implement-file

;; 支持鼠标点击， 绑定鼠标键 mouse-1 mouse-2 mouse-3

;; add-project-files
;; del-project-files
;; add-project-dir
;; del-project-dir
;; import-files-from-makefile

;; update-project-file-lists : code files and document,other files
;; update-tags

;; 根据配置文件，找到所有源文件，生成 source-list, tags ，然后就可以使用这些tags来搜索了。
;; 库文件和工程特有文件分开：相对稳定的源文件，经常修改的源文件; 从配置文件里设定，哪些目录，tags存储的位置，哪些类型


;; 功能键绑定： f1~12 鼠标; 写代码时键盘为主，看代码时鼠标效率高。

;;; (define-key esc-map "." 'find-tag) ;; tag-apropos
;;; (define-key esc-map [?\C-.] 'find-tag-regexp)
;;; (define-key esc-map "*" 'pop-tag-mark)
;;; (define-key ctl-x-4-map "." 'find-tag-other-window)
;;;###autoload (define-key esc-map "," 'tags-loop-continue)
;; complete-tag tags-search tags-query-replace

;(symbol-name 'find-symbol-define)
;; find-symbol-using
;; goto-include-file
;; goto-implement-file

(load "zsl-project-base.el")

(defun zsl-create-project-cfg (pname &optional srcdir)
  (interactive "sThe Pproject Name:\niThe dir:")
  (let ((cfg-template-file (locate-file-internal "zsl-project.cfg.el" load-path))
		(new-project-cfg (zsl-expand-file-name eprojs)))

	(unless pname (setq pname "projname"))
	(setq new-project-cfg (concat new-project-cfg pname ".cfg.el"))
	;; (message "%s-->%s" cfg-template-file new-project-cfg)
	;; (copy-file cfg-template-file new-project-cfg)

	(load cfg-template-file)			;set `zsl-project-cfg' variable
	(set-alist-value 'project-name pname zsl-project-cfg)
	(when srcdir (append-alist-value 'project-dirs srcdir zsl-project-cfg))
	(zsl-write-project-cfg new-project-cfg zsl-project-cfg)

	(message "Project config file created, you can edite it.")
	(find-file new-project-cfg)
	)
  )

(defun zsl-update-project-cfg (key vitem)
  (let ((v (assq key zsl-project-cfg))
		)
	(message "[%s]" v)
	(if v (unless (member vitem (cdr v)) (setcdr v (cons vitem (cdr v))))
	  (setq zsl-project-cfg (cons (list key vitem) zsl-project-cfg)))
	(zsl-write-project-cfg (zptree-mode-get-projcfg) zsl-project-cfg t)
	))

(defun zsl-prepare-project (&optional cfg)
  (interactive "fThe project config file:")
  (message "project config file[%s]" cfg)

  (and cfg (load cfg))					;and like when
  (init-project-vars)
  (create-src-file-list)

  (dolist (var (alist-value 'srcflist emacs-project-files))
	(update-tags-xref var)
	)

  (reset-etags-table-list)
  (reset-global-env)

  (message "prepare ok! now use etags and xcscope commands!")
  )

(defun zsl-switch-project (&optional cfg)
  (interactive "fThe project config file:")
  (message "project config file[%s]" cfg)

  (when cfg (load cfg))
  (init-project-vars)
  (create-src-file-list)
  (dolist (var (alist-value 'srcflist emacs-project-files))
	(update-tags-xref-1 var)
	)

  (reset-etags-table-list)
  (reset-global-env)

  (message "prepare ok! now use etags and xcscope commands!")
  )

(defun zsl-project-ffap ()
  "find file at point"
  (interactive)
  ;; 取得文件名,如何确定是文件名?
  ;; 取得查找范围
  ;; 查找并显示结果
  (let ((fap (zsl-string-inquote))
		(fileslist (alist-value 'srcflist emacs-project-files))
		files result)
	(message "find [%s]" fap)
	(dolist (f fileslist)
	  (setq result (find-string-in-file fap f))
	  (when result
		(setq files (append result files)))
	  )
	(zsl-show-ffap-result files fap)
	))

(defun zsl-show-ffap-result (x f)
  (if (= (length x) 1)
	  (view-file-other-window (car x))
	(if (= (length result) 0)
		(message "file[%s] not in proj[%s]" f (alist-value 'project-name zsl-project-cfg))
	  (let ((buf (switch-to-buffer "*ffap result*")))
		(with-current-buffer buf
		  (buffer-disable-undo)
		  (erase-buffer)
		  (dolist (v x)
			(insert (format "%s\n" v)))
		  )))))

(defun zsl-show-fsap-result (x)
  (let ((buf (switch-to-buffer "*fsap result*")))
	(with-current-buffer buf
	  (buffer-disable-undo)
	  (erase-buffer)
	  (dolist (v x)
		(insert (format "%s\n" (car v)))
		(dolist (s (cdr v))
		  (insert (format "\t%s\n" s))
		  )))))

(defun zsl-project-fsap ()
  "find symbole at point, define and using, from files."
  (interactive)
  ;; 取得变量名
  ;; 取得查找范围,如何缩小范围?
  ;; 查找并显示结果,查看结果详细? goto first and highlight all.
  (let ((fap (zsl-string-inquote))
		(fileslist (alist-value 'srcflist emacs-project-files))
		files result result-all bv)
	(message "find [%s]" fap)
	(dolist (f fileslist)
	  (setq files (read-file2list f))
	  (dolist (v files)
		(setq result (find-string-in-file fap v))
		(when result
		  (setq bv (set-alist-value1 v result result-all))
		  (when bv (setq result-all bv)))
		)
	  (setq result ())
	  )
	(when result-all (zsl-show-fsap-result result-all))
	))

;; Semantic: Source code parsing utilities for Emacs.
(defun zsl-project-fsap1 ()
  "find symbole at point, define and using, from index."
  )

(defun zsl-get-include-file ()
  (save-excursion
	(let ((p0 (point)) p1 p2 
		  (sig "#include")
		  (p3 (line-beginning-position))
		  s)
	  (setq s (buffer-substring p3 (+ p3 (length sig))))
	  (message "%s" s)
	  (if (string= sig s)
		  (progn 
			(skip-chars-backward "^\"<")
			(setq p1 (point))
			(skip-chars-forward "^\">")
			(setq p2 (point))
			(buffer-substring p1 p2)
			)
		nil))))

(defun zsl-project-fsfap ()
  "find symbol or file at point."
  (interactive)
  (let ((file (zsl-get-include-file))
		(symbol (funcall (or find-tag-default-function
							 (get major-mode 'find-tag-default-function)
							 'find-tag-default))))
	(if file (zsl-open-include-file file)
	  (find-tag symbol))))

(defun zsl-open-include-file (file)
  (let (result flist buf)
	(mapcar (lambda (sf)
			  (if sf (message "%s:%s" file sf) (message "no project prepared"))
			  (when (and sf (setq flist (find-string-in-file file sf)))
				(setq result (append flist result))))
			(alist-value 'srcflist emacs-project-files))
	(if (= (length result) 1)
		(view-file-other-window (car result))
	  (if (= (length result) 0)
		  (message "file[%s]not in proj[%s]" file (alist-value 'project-name zsl-project-cfg))
		(progn
		  (set 'buf (switch-to-buffer "*zproject view file*"))
		  (with-current-buffer buf
			(buffer-disable-undo)
			;; set local keybinding...
			(mapcar (lambda (e) (insert e "\n")) result)))))
	)
  )

(defun clear-project-files (cfg)
  (interactive "fThe project config file:")
  (message "project config file[%s]" cfg)
  (load cfg)
  (init-project-vars)
  (create-src-file-list)
  (let ((l (alist-value 'srcflist emacs-project-files)))
	(dolist (var l)
	  (update-tags-xref-1 var)
	  (if (file-exists-p var) (delete-file var))
	  )

	(setq l (alist-value 'tagxflist emacs-project-files))
	(dolist (var l)
	  (if (file-exists-p var) (delete-file var))
	  )

	(setq l (cdr (assq 'gtagsdir emacs-project-files)))
	(dolist (var l)
	  (if (file-exists-p var) (delete-directory var))
	  )
	)
  (message "delete project files ok!")
  )

(defun global-find-tag-x (tagname)
  "find the tag\n"
  (interactive
   (let ((sb (symbol-at-point)) val)
	 (setq val (completing-read
				(if sb (format "find (default %s):" sb) "find tag:")
				(tags-lazy-completion-table) nil t nil))
	 (list (if (equal val "") sb (intern val)))
	 ))
  
  (if (null tagname) (message "You didn't specify a symbol")
	(setq tagname (symbol-name tagname))
	(global-find-tag tagname)
	)
  )

(defun global-find-tag-r (tagname)
  "find the tag\n"
  (interactive
   (let ((sb (symbol-at-point)) val)
	 (setq val (completing-read
				(if sb (format "find (default %s):" sb) "find tag:")
				(tags-lazy-completion-table) nil t nil))
	 (list (if (equal val "") sb (intern val)))
	 ))
  
  (if (null tagname) (message "You didn't specify a symbol")
	(setq tagname (symbol-name tagname))
	(global-find-tag tagname "r")
	)
  )

(defun global-find-tag-s (tagname)
  "find the tag\n"
  (interactive
   (let ((sb (symbol-at-point)) val)
	 (setq val (completing-read
				(if sb (format "find (default %s):" sb) "find tag:")
				(tags-lazy-completion-table) nil t nil))
	 (list (if (equal val "") sb (intern val)))
	 ))
  
  (if (null tagname) (message "You didn't specify a symbol")
	(setq tagname (symbol-name tagname))
	(global-find-tag tagname "s")
	)
  )
