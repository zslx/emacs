;;; jerry-dired.el --- dired的配置

;;设定显示文件的参数，以版本/人性化的显示就是ls的参数
;; (setq dired-listing-switches "-aluh")                  ;传给 ls 的参数
(setq dired-listing-switches "-vhl")
;; C-u s 就可以编辑 dired 的 dired-listing-switches 这个变量，从而达到控制排序的方法的目的。


;;允许复制和删除时将文件夹里所有内容一起带上
(setq dired-recursive-copies t)                        ;可以递归的进行拷贝
(setq dired-recursive-deletes t)                       ;可以递归的删除目录

;; (toggle-dired-find-file-reuse-dir 1)                   ;使用单一模式浏览Dired

;;对于特定的文件应用shell命令，用！。
;;在后面带上&，为后台运行，我们还要用Emacs做别的事情呢!

;; (setq dired-recursive-deletes 'always)                 ;删除东西时不提示
;; (setq dired-recursive-copies 'always)                  ;拷贝东西时不提示

;; (setq dired-details-hidden-string "[ ... ] ")          ;设置隐藏dired里面详细信息的字符串
;; (setq directory-free-space-args "-Pkh")                ;目录空间选项
;; (setq dired-omit-size-limit nil)                       ;dired忽略的上限
;; (setq dired-dwim-target t)                             ;Dired试着猜默认的目标目录
;; (setq my-dired-omit-status t)                          ;设置默认忽略文件
;; (setq my-dired-omit-regexp "^\\.?#\\|^\\..*")          ;设置忽略文件的匹配正则表达式
;; (setq my-dired-omit-extensions '(".cache"))            ;设置忽略文件的扩展名列表
;; (add-hook 'dired-after-readin-hook 'dired-sort-method) ;先显示目录, 然后显示文件
;; (add-hook 'dired-mode-hook 'dired-omit-method)         ;隐藏文件的方法

;;下面的文件用的是正则表达式，要表达清楚
;; (setq dired-guess-shell-alist-user
;; 	  (list
;; 	   (list "\\.tar\\.bz2$" "tar jxvf *   &")
;; 	   '("\\.tar\\.gz$" "tar zxvf *   &")
;; 	   '("\\.chm$" "chmsee *  &")
;; 	   '("\\.ps$" "gv *   &")
;; 	   '("\\.pdf$"  "acroread *  &" "evince *   &")
;; 	   '("\\.\\(jpe?g\\|gif\\|png\\|bmp\\|xbm\\|xpm\\|fig\\|eps\\)$" "gthumb * &" "gqview *  &" "display *   &" "xloadimage *   &" )
;; 	   '("\\.rmvb$" "mplayer * &")
;; 	   ))

(provide 'jerry-dired)

;;; jerry-dired.el ends here
