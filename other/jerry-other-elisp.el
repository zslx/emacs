;;; jerry-other-elisp.el ---
;;; 一些零碎的小扩展，这些小扩展很实用
;; redo
(require 'redo)

;; emacs-goodies-el
(add-to-list 'load-path "/usr/share/emacs/site-lisp/emacs-goodies-el/")

;; ASCII码表
(autoload 'ascii "ascii-table" "ASCII TABLE" t)

;; 保存状态
(require 'session)
(add-hook 'after-init-hook  'session-initialize)
;;use both desktop and session
;(setq desktop-globals-to-save '(desktop-missing-file-warning))

;; Add "Open Recent" menu to the Files menu.
;; Must be set before require, else not passed on initial call to
;; package it seems. Not sure why.
(setq recentf-save-file (expand-file-name "recentf" (concat cfghome ".emacs.d/") )
      recentf-max-saved-items 100
      recentf-max-menu-items  20
      ;recentf-exclude '("/VM/" "/Gnus/" "/bbdb" "\\`/[a-zA-Z0-9@]+:")
      )

;; 一个使用recentf可以打开最近打开文件列表的功能
(defun recentf-open-files-compl ()
  (interactive)
  (let* ((all-files recentf-list)
         (tocpl (mapcar (function
                         (lambda (x) (cons (file-name-nondirectory x) x))) all-files))
         (prompt (append '("最近打开的文件: ") tocpl))
    ;;(prompt (append '("File name: ") tocpl))
         (fname (completing-read (car prompt) (cdr prompt) nil nil)))
    (find-file (cdr (assoc-string fname tocpl)))))

(require 'recentf)
(recentf-mode 1)

;;制作图表的
;(require 'table)
;(autoload 'table-insert "table" "WYGIWYS table editor")
;(add-hook 'text-mode-hook 'table-recognize)

;; 观看kill-ring
;(require 'browse-kill-ring)
;(browse-kill-ring-default-keybindings)

(autoload 'sawfish-mode "sawfish" "sawfish-mode" t)

;; 数学工程 (autoload 'maxima "maxima" "Maxima interaction" t)

;;2种编辑html的好模式
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
(autoload 'css-mode "css-mode" "Mode for editing CSS files" t)

;;查看端口
(autoload 'services-lookup      "services" "Perform a service lookup" t)
(autoload 'services-clear-cache "services" "Clear the service cache"  t)

;;使用xcscope ;;cscope的前端
;(require 'xcscope)

;;emacs的grep
;; 2014-06-23 10:19:59 zsl
;;windows only stuff
(when (string-equal system-type "windows-nt")
  (progn
	(setq cygwin-bin "c:\\cygwin64\\bin")
	(setq gnu-bin "C:\\apps\\GnuWin32\\gnuwin32\\bin")
	(setenv "PATH"
			(concat cygwin-bin ";" gnu-bin ";"))
	(setq exec-path
		  '(cygwin-bin gnu-bin))))

;(require 'igrep)
(autoload 'igrep "igrep"
     "*Run `grep` PROGRAM to match EXPRESSION in FILES..." t)
(autoload 'igrep-find "igrep"
     "*Run `grep` via `find`..." t)
(autoload 'igrep-visited-files "igrep"
     "*Run `grep` ... on all visited files." t)
(autoload 'dired-do-igrep "igrep"
     "*Run `grep` on the marked (or next prefix ARG) files." t)
(autoload 'dired-do-igrep-find "igrep"
     "*Run `grep` via `find` on the marked (or next prefix ARG) directories." t)
(autoload 'Buffer-menu-igrep "igrep"
     "*Run `grep` on the files visited in buffers marked with '>'." t)
(autoload 'igrep-insinuate "igrep"
     "Define `grep' aliases for the corresponding `igrep' commands." t)
(autoload 'igrep-find-query-replace "igrep-find-query-replace" "" t)
(put 'igrep-files-default 'c++-mode
    (lambda () "*.h *.cpp *.c"))
(put 'igrep-files-default 'c-mode
    (lambda () "*.[ch]"))

;; sdcv mode使用sdcv查字典
(require 'sdcv-mode)

;; show the line number
(require 'setnu)
(autoload 'setnu-plus "setnu-plus" t)
;; 另一个 show line number
(require 'linum)

;; 高亮过于长的行
;(require 'highlight-beyond-fill-column)

;;CJK Table
(if window-system
    (autoload 'keisen-mode "keisen-mouse" "MULE table" t)
  (autoload 'keisen-mode "keisen-mule" "MULE table" t))

;; svn的客户端
;(require 'psvn)

;;;;;"Remember" is a mode for remembering data.
(autoload 'remember "remember" nil t)
(autoload 'remember-region "remember" nil t)

;;;; 多主模式的使用
;;(autoload 'mmm-mode "mmm-mode" "Multiple Major Modes" t)
;;(autoload 'mmm-parse-buffer "mmm-mode" "Automatic MMM-ification" t)
;;(set-face-background 'mmm-default-submode-face nil)

;; edit-env 编辑环境变量
(require 'edit-env)

;; keywiz游戏- 训练你的键绑定-crazy game
(require 'keywiz)

;; todo mode
(autoload 'todo-mode "todo-mode" "Major mode for editing TODO lists." t)
(autoload 'todo-show "todo-mode" "Show TODO items." t)
(autoload 'todo-insert-item "todo-mode" "Add TODO item." t)
(setq todo-file-do (concat cfghome ".emacs.d/todo-do") )
(setq todo-file-done (concat cfghome ".emacs.d/todo-done") )
(setq todo-file-top (concat cfghome ".emacs.d/todo-top") )

;; slime 用于 common-lisp 编程
(add-to-list 'load-path (concat cfghome ".emacs.d/slime/") )  ; your SLIME directory
;;(setq inferior-lisp-program "/opt/sbcl/bin/sbcl") ; your Lisp system
(require 'slime)
(slime-setup)

;;如果安装了 Emacs-w3m 的话，直接在 Emacs-w3m 里面打开 HyperSpec 就更方便了：
;(require 'hyperspec)
;(setq common-lisp-hyperspec-root "file:/usr/share/doc/hyperspec/")
;; (setq browse-url-browser-function
;;       '(("/usr/share/doc/hyperspec/" . w3m-browse-url)
;;         ("." . browse-url-default-browser)))

(defun create-scratch-buffer nil
  "create a new scratch buffer to work in. (could be *scratch* - *scratchX*)"
  (interactive)
  (let ((n 0)
	bufname)
    (while (progn
	     (setq bufname (concat "*scratch"
				   (if (= n 0) "" (int-to-string n))
				   "*"))
	     (setq n (1+ n))
	     (get-buffer bufname)
	     )
      )

    (switch-to-buffer (get-buffer-create bufname))
    (if (= n 1) (lisp-interaction-mode)) ; 1, because n was incremented
    )
  )

;;使用ibuffer,把菜单里的也换掉
(require 'ibuffer)
(setq ibuffer-delete-window-on-quit t)
(defadvice ibuffer-quit (after kill-ibuffer activate)
  "Kill the ibuffer buffer on exit."
  (kill-buffer "*Ibuffer*"))
;; NB unusual way to modify menu entry. Found by C-h v menu-bar- [TAB].
(setq menu-bar-buffers-menu-command-entries
      ;;'(list-all-buffers menu-item "List All Buffers" ibuffer
      ;;     (nil)
      ;;     :help "Pop up a window listing all Emacs buffer"))
      '((command-separator "--")
   ;;(next-buffer menu-item "Next Buffer" next-buffer
   (next-buffer menu-item "下一个Buffer" next-buffer
           ([24 C-right]
            . "  (C-x <C-right>)")
           :help "在一个循环里切换到 \"next\" buffer")
           ;;:help "Switch to the \"next\" buffer in a cyclic order")
   ;;(previous-buffer menu-item "Previous Buffer" previous-buffer
   (previous-buffer menu-item "前一个Buffer" previous-buffer
          ([24 C-left]
           . "  (C-x <C-left>)")
          :help "在一个循环里切换到 \"previous\" buffer")
          ;;:help "Switch to the \"previous\" buffer in a cyclic order")
   ;;(select-named-buffer menu-item "Select Named Buffer..." switch-to-buffer
   (select-named-buffer menu-item "从Buffer的名字里选择..." switch-to-buffer
              ([24 98]
               . "  (C-x b)")
              :help "提示buffer的名字,并把选中的buffer显示在当前的窗口")
              ;;:help "Prompt for a buffer name, and select that buffer in the current window")
   ;;(list-all-buffers menu-item "List All Buffers" ibuffer ;;就是这样
   (list-all-buffers menu-item "列出所有的buffers" ibuffer ;;就是这样
           ([24 98]
               . "  (C-x C-b)")
           ;;(nil)
           :help "弹出一个窗口列出所有打开的buffer")))
           ;;:help "Pop up a window listing all Emacs buffers")))

;; Ibuffer的彩色效果
;; (setq ibuffer-formats '((mark modified read-only " " (name 16 16) " "
;;                         (size 6 -1 :right) " " (mode 16 16 :center)
;;                          " " (process 8 -1) " " filename)
;;                           (mark " " (name 16 -1) " " filename))
;;       ibuffer-elide-long-columns t
;;       ibuffer-eliding-string "&")

;;; emms 配置
;;(add-to-list 'load-path (expand-file-name (concat cfghome "emacs/packages/emms") ))
(add-to-list 'load-path (concat cfghome ".emacs.d/emms-3.0/") )

(require 'emms-source-file)
(require 'emms-source-playlist)
(require 'emms-player-simple)
(require 'emms-player-mplayer)
(require 'emms-playlist-mode)
(require 'emms-info)
(require 'emms-cache)
(require 'emms-mode-line)
(require 'emms-playing-time)
(require 'emms-score)
(require 'emms-volume)

(setq emms-playlist-default-major-mode 'emms-playlist-mode)
(add-to-list 'emms-track-initialize-functions 'emms-info-initialize-track)
(add-to-list 'emms-info-functions 'kid-emms-info-simple)
(setq emms-track-description-function 'kid-emms-info-track-description)
(when (fboundp 'emms-cache)
  (emms-cache 1))

(setq emms-player-list
      '(emms-player-mpg321
        emms-player-ogg123
        emms-player-mplayer))

(setq emms-info-asynchronously nil)
(setq emms-playlist-buffer-name "*Music*")
; use faster finding facility if you have GNU find
(setq emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
; My musics
(setq emms-source-file-default-directory "/media/hda6/舞曲")
(add-hook 'emms-player-started-hook 'emms-show)
; mode line format
(setq emms-mode-line-format "[ %s "
      emms-playing-time-display-format "%s ]")
(setq global-mode-string
      '("" emms-mode-line-string " " emms-playing-time-string))
;
(defun kid-emms-info-simple (track)
  "Get info from the filename.
mp3 标签的乱码问题总是很严重，幸好我系统里面的音乐文件
都放得比较有规律，所以我决定直接从文件名获取标签信息。"
  (when (eq 'file (emms-track-type track))
    (let ((regexp "/\\([^/]+\\)/\\([^/]+\\)\\.[^.]+$")
          (name (emms-track-name track)))
      (if (string-match regexp name)
          (progn
            (emms-track-set track 'info-artist (match-string 1 name))
            (emms-track-set track 'info-title (match-string 2 name)))
          (emms-track-set track
                          'info-title
                          (file-name-nondirectory name))))))

(defun kid-emms-info-track-description (track)
  "Return a description of the current track."
  (let ((artist (emms-track-get track 'info-artist))
        (title (emms-track-get track 'info-title)))
    (format "%-10s +| %s"
            (or artist
                "")
            title)))


(provide 'jerry-other-elisp)

;;; jerry-other-elisp.el ends here
