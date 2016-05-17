;;; jerry-wiki.el --- wiki的设置
;;; 使用wiki管理你的笔记发布网站很方便，比html语言简单了很多

;;加载emacs-wiki, http://mwolson.org/static/dist/emacs-wiki/
(setq load-path (add-to-list 'load-path (concat cfghome ".emacs.d/emacs-wiki-2.72") ))
(require 'emacs-wiki)

;;设置wiki所在文件夹
(setq emacs-wiki-directories '((concat cfghome "wiki") ))
;;设置wiki转换为html后所在的文件夹
(setq emacs-wiki-publishing-directory "publish")
;;设置wiki转为html用的解码
;;但好像仍然有些问题，用firefox打开时有时仍需手动调整解码
(setq emacs-wiki-meta-charset "gb2312")
;;GBK中文设置
;; (setq emacs-wiki-meta-content-coding "gbk")
;; (setq emacs-wiki-charset-default "gbk")
;; (setq emacs-wiki-coding-default 'gbk)

;;设置wiki转为html的样式，不过目前我还没用
(setq emacs-wiki-style-sheet "")
;;设置Wiki内图片的路径
(setq emacs-wiki-inline-relative-to 'default-directory)

;;现面两个函数，是由王垠编写的
;;预览生成网页的源码，即html源码
;;不过先将wiki生成html
(defun emacs-wiki-preview-source ()
  "生成wiki的预览."
  (interactive)
  (emacs-wiki-publish-this-page)
  (find-file (emacs-wiki-published-file)))
;;这个函数是预览在浏览器中所生成的网页
;;这里用的是emacs-w3m浏览器，你也可使用外部浏览器，如firefox，这可能稍复杂点
(defun emacs-wiki-preview-html ()
  "生成wiki的himl代码."
  (Interactive)
  (emacs-wiki-publish-this-page)
  (w3m-browse-url (emacs-wiki-published-file)))

;;设定你的Wiki项目，有时候你可能拥有几个，一个给个人整理笔记用，一个用来发表为网站形式
(setq emacs-wiki-projects
      '(("default" . ((emacs-wiki-directories . ((concat cfghome "wiki") ))))
   ("work" . ((fill-column . 65)
         (emacs-wiki-directories . ((concat cfghome "wiki/workwiki/") ))))))

(provide 'jerry-wiki)

;;; jerry-wiki.el ends here
