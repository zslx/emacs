;;; jerry-dictionary.el --- dictionary字典配置
;; 参考:
;; 1).http://me.in-berlin.de/~myrkr/dictionary/installation.html
;; 2).http://lifegoo.pluskid.org/wiki/EmacsDictionary.html
;; 过程:
;; 1).安装dictd: sudo urpmi dictd
;; 2).下载emacs扩展包: http://me.in-berlin.de/~myrkr/dictionary/dictionary-1.8.7.tar.gz
;; 3).tar zxvf dictionary-1.8.7.tar.gz
;; 4).make
;; 5).将byte-complie后的.elc文件放在你集中放的emacs的lisp文件夹面面。
;; 6).配置emcas,在~/.emacs中加入:
;=======dictd=========
(autoload 'dictionary-search "dictionary"
  "Ask for a word and search it in all dictionaries" t)
(autoload 'dictionary-match-words "dictionary"
  "Ask for a word and search all matching words in the dictionaries" t)
(autoload 'dictionary-lookup-definition "dictionary"
  "Unconditionally lookup the word at point." t)
(autoload 'dictionary "dictionary"
  "Create a new dictionary buffer" t)
(autoload 'dictionary-mouse-popup-matching-words "dictionary"
  "Display entries matching the word at the cursor" t)
(autoload 'dictionary-popup-matching-words "dictionary"
  "Display entries matching the word at the point" t)
(autoload 'dictionary-tooltip-mode "dictionary"
  "Display tooltips for the current word" t)

(global-set-key (kbd "C-c s") 'dictionary-search)
(global-set-key (kbd "C-c m") 'dictionary-match-words)

(setq dictionary-tooltip-dictionary "wn")
(require 'dictionary)
(global-dictionary-tooltip-mode t)

(global-set-key (kbd "<mouse-3>") 'dictionary-mouse-popup-matching-words)
(global-set-key (kbd "C-c m") 'dictionary-popup-matching-words)
(add-hook 'text-mode-hook 'dictionary-tooltip-mode)
(add-hook 'text-mode-hook 'dictionary-tooltip-mode)

;;查单词，只要将光标移到单词上，"C-c d"即可，Emacs会开辟一个buffer显示单词释义。鼠标右键也可以
;; (global-set-key [mouse-3] 'dictionary-mouse-popup-matching-words)
;; (global-set-key [(control c)(d)] 'dictionary-lookup-definition)
;; (global-set-key [(control c)(s)] 'dictionary-search)
;; (global-set-key [(control c)(m)] 'dictionary-match-words)

;; 测试:
;;     打开emacs,然后C-c s,输入某个单词，看能否查到。可能速度有点慢，因为要连服务器。不过，目前只能查英文，我还没试出来如何中英文查询。

;;大家现在都使用stardict，其实这个也可以用，我现在使用sdcv，为了完整，所以这部分也方上来


;;设定字典服务器为本地服务器
;;如果你在包月的宽带上，不妨设定为[url]http://www.dict.org[/url]
;;如果你在局域网上，而局域网的某台机器有dictd服务器，你将服务器设定为他的IP即可。
(setq dictionary-server "localhost")
;;在字典提示模式中，使用wordnet字典数据库作为默认字典数据库
;;当然你可以修改，取决于你dictd服务器里的字典数据库
;(setq dictionary-tooltip-dictionary "wn")
;(require 'dictionary)
;; FIXME :使用这个全局tooltip很费内存啊
;(global-dictionary-tooltip-mode t)

;;在dictd中使用中文字典的时候，需要在~/.emacs中加入字典的编码格式。
;;我的locale用的是utf8的，就需要如下的设置，GB2312的类似：

;; 设定中文词典的解码
(setq dictionary-coding-systems-for-dictionaries
      '(("cdict" . utf-8)
		("xdict" . utf-8)
		("stardic" . utf-8)))

(provide 'jerry-dictionary)
;;; jerry-dictionary.el ends here
