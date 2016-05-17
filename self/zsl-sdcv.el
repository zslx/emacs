;; 参考:http://lifegoo.pluskid.org/wiki/EmacsStardict.html
;; 过程:
;; 1).安装星际译王: sudo urpmi stardict
;; 2).安装星际译王命令行工具: sudo urpmi sdcv
;; 3).安装两套词典：中英和英中，当然你可以装的更多。
;; urpmi stardict-xdict-en-zh_CN
;; urpmi stardict-xdict-zh_CN-en
;; 严重推荐：词典超多，速度嗷嗷的
;; ftp://nchc.dl.sourceforge.net/s/st/stardict/
;; 一般推荐：这里的词典，上面的链接里基本都有，而且下载速度有时像龟爬，有时根本下载不了
;; http://www.stardict.org/download.php
;; http://stardict.sourceforge.net/Dictionaries_zh_CN.php
;; http://debian.ustc.edu.cn/debian-uo/dists/sid/ustc/pool/stardict/ ok2010
;; 4).编辑~/.emacs文件，加入:

;; author: pluskid
;; 调用 stardict 的命令行程序 sdcv 来查辞典
;; 如果选中了 region 就查询 region 的内容，否则查询当前光标所在的单词
;; 查询结果在一个叫做 *sdcv* 的 buffer 里面显示出来，在这个 buffer 里面
;; 按 q 可以把这个 buffer 放到 buffer 列表末尾，按 d 可以查询单词

(setq sdcv-dictionary-simple-list       ;星际译王屏幕取词词典, 简单, 快速
      '("懒虫简明英汉词典"
        "懒虫简明汉英词典"
        "KDic11万英汉词典"))
(setq sdcv-dictionary-complete-list     ;星际译王的词典, 完全, 详细
      '("KDic11万英汉词典"
        "懒虫简明英汉词典"
        "朗道英汉字典5.0"
        "XDICT英汉辞典"
        "朗道汉英字典5.0"
        "XDICT汉英辞典"
        "懒虫简明汉英词典"
        "牛津英汉双解美化版"
        "stardict1.3英汉辞典"
        "英汉汉英专业词典"
        "CDICT5英汉辞典"
        "Jargon"
        "FOLDOC"
        "WordNet"))

;;("牛津现代英汉双解词典" "DrEye4in1词典" "朗道英汉字典5.0" "XDICT英汉辞典"))
;; (setq dic-lst
;; 	  '("-u" "朗道英汉字典5.0" "-u" "XDICT英汉辞典" 
;; 		"-u" "朗道汉英字典5.0" "-u" "XDICT汉英辞典"))

(global-set-key (kbd "C-c d") 'kid-sdcv-to-buffer)

(defun kid-sdcv-to-buffer ()
  (interactive)
  (let ((word (if mark-active
                  (buffer-substring-no-properties (region-beginning) (region-end))
				(current-word nil t))))
    (setq word (read-string (format "Search the dictionary for (default %s): " word)
							nil nil word))
    (set-buffer (get-buffer-create "*sdcv*"))
    (buffer-disable-undo)
    (erase-buffer)
    (let ((process (start-process-shell-command
					"sdcv" "*sdcv*" "sdcv" "-n" word "-u" "XDICT英汉辞典" "-u" "朗道英汉字典5.0" "-u" "XDICT汉英辞典" "-u" "朗道汉英字典5.0"  )))
      (set-process-sentinel
       process
       (lambda (process signal)
         (when (memq (process-status process) '(exit signal))
           (unless (string= (buffer-name) "*sdcv*")
             (setq kid-sdcv-window-configuration (current-window-configuration))
			 ;; (switch-to-buffer-other-window "*sdcv*")
			 (switch-to-buffer "*sdcv*")
             (local-set-key (kbd "d") 'kid-sdcv-to-buffer)
             (local-set-key (kbd "j") 'next-line)
             (local-set-key (kbd "n") 'next-line)
             (local-set-key (kbd "k") 'previous-line)
             (local-set-key (kbd "p") 'previous-line)
             (local-set-key (kbd "l") 'forward-word)
             (local-set-key (kbd "h") 'backward-word)
             (local-set-key (kbd "SPC") 'scroll-up)
             (local-set-key (kbd "DEL") 'scroll-down)
             (local-set-key (kbd "b") 'scroll-down)
             (local-set-key (kbd "q") (lambda ()
                                        (interactive)
                                        (bury-buffer)
                                        ;; (unless (null (cdr (window-list))) ; only one window
                                        ;;   (delete-window))
										(switch-to-buffer (car (buffer-list)))
										)))
		   (goto-char (point-min))  ) )))))

;; 测试: 进入emacs,C-c d,输入单词，就可以看到结果了。q键退出。


;; ;; 不使用 sdcv 程序
;; (require 'stardict)
;; ;; 这个库是用elisp解析stardict词典的数据来查词的，不需要其它程序，但同时加载词库比较慢，查询速度还凑合。
;; (defun zsl-lookup-word-from-dict (word dirname dictname)
;;   (let ((dict (stardict-open dirname dictname)))
;; 	(if (stardict-word-exist-p dict word)
;; 		(stardict-lookup dict word)
;; 	  (message "%s not exist!" word))))

;; (zsl-lookup-word-from-dict "能量" "~/.stardict/dic/" "xdict-ce-gb")

