;; -*- Emacs-Lisp -*-
;; Time-stamp: <2010-02-23 13:52:32 Tuesday by ahei>

;;;这个适合喜欢终端界面的朋友用，看网页谁说一定要用firefox和opera呢？
;;; jerry-w3m.el --- emacs-w3m的配置
;;; Code: cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot co emacs-w3m
 
 
(require 'w3m)
(require 'w3m-lnum)
(require 'util)
 
(defvar w3m-buffer-name-prefix "*w3m" "Name prefix of w3m buffer")
(defvar w3m-buffer-name (concat w3m-buffer-name-prefix "*") "Name of w3m buffer")
(defvar w3m-bookmark-buffer-name (concat w3m-buffer-name-prefix "-bookmark*") "Name of w3m buffer")
(defvar w3m-dir (concat my-emacs-lisps-path "emacs-w3m/") "Dir of w3m.")
 
(setq w3m-command-arguments '("-cookie" "-F"))
(setq w3m-use-cookies t)
(setq w3m-icon-directory (concat w3m-dir "icons"))
(setq w3m-use-mule-ucs t)
(setq w3m-home-page "http://www.google.cn")
(setq w3m-default-display-inline-images t)
 
(defun w3m-settings ()
  (make-local-variable 'hl-line-face)
  (setq hl-line-face 'hl-line-nonunderline-face)
  (setq hl-line-overlay nil)
  (color-theme-adjust-hl-line-face))
 
(add-hook 'w3m-mode-hook 'w3m-settings)
 
(defun w3m-save-current-buffer ()
  "Save current w3m buffer."
  (interactive)
  (save-excursion
    (mark-whole-buffer)
    (call-interactively 'copy-region-as-kill-nomark))
  (with-temp-buffer
    (call-interactively 'yank)
    (call-interactively 'write-file)))
 
(defun w3m-print-current-url ()
  "Display current url."
  (interactive)
  (w3m-message "%s" (w3m-url-readable-string w3m-current-url)))
 
(defun w3m-copy-current-url ()
  "Display the current url in the echo area and put it into `kill-ring'."
  (interactive)
  (when w3m-current-url
    (let ((deactivate-mark nil))
      (kill-new w3m-current-url)
      (w3m-print-current-url))))
 
(defun view-w3m-bookmark ()
  "View w3m bokmark."
  (interactive)
  (let ((buffer (get-buffer w3m-bookmark-buffer-name)))
    (if buffer
        (switch-to-buffer buffer)
      (with-current-buffer (get-buffer-create w3m-bookmark-buffer-name)
        (w3m-mode)
        (w3m-bookmark-view)))))
 
(defun switch-to-w3m ()
  "Switch to *w3m* buffer."
  (interactive)
  (let ((buffer (get-buffer w3m-buffer-name)))
    (if buffer
        (switch-to-buffer buffer)
      (message "Could not found w3m buffer."))))
 
(defun w3m-browse-current-buffer ()
  "Use w3m browser current buffer."
  (interactive)
  (w3m-browse-buffer))
 
(defun w3m-browse-buffer (&optional buffer)
  "Use w3m browser buffer BUFFER."
  (interactive "bBuffer to browse use w3m: ")
  (unless buffer (setq buffer (current-buffer)))
  (let* ((file (buffer-file-name buffer))
         (name (buffer-name buffer)))
    (if file
        (w3m-goto-url-new-session file)
      (with-current-buffer buffer
        (save-excursion
          (mark-whole-buffer)
          (call-interactively 'copy-region-as-kill-nomark)))
      (let* ((new-name
              (concat
               w3m-buffer-name-prefix
               "-"
               (if (string= "*" (substring name 0 1))
                   (substring name 1)
                 (concat name "*"))))
             (new-buffer (get-buffer-create new-name)))
        (switch-to-buffer new-buffer)
        (call-interactively 'yank)
        (w3m-buffer)
        (w3m-mode)
        (setq w3m-current-title (buffer-name))))))
 
;; fix small bug about of `w3m-auto-show'
;; see my-blog/emacs/w3m-auto-show-bug.htm
(defun w3m-auto-show ()
  "Scroll horizontally so that the point is visible."
  (when (and truncate-lines
             w3m-auto-show
             (not w3m-horizontal-scroll-done)
             (not (and (eq last-command this-command)
                       (or (eq (point) (point-min))
                           (eq (point) (point-max)))))
             (or (memq this-command '(beginning-of-buffer end-of-buffer))
                 (string-match "\\`i?search-"
                               (if (symbolp this-command) (symbol-name this-command) ""))
                 (and (markerp (nth 1 w3m-current-position))
                      (markerp (nth 2 w3m-current-position))
                      (>= (point)
                          (marker-position (nth 1 w3m-current-position)))
                      (<= (point)
                          (marker-position (nth 2 w3m-current-position))))))
    (w3m-horizontal-on-screen))
  (setq w3m-horizontal-scroll-done nil))
 
(defun w3m-link-numbering (&rest args)
  "Make overlays that display link numbers."
  (when w3m-link-numbering-mode
    (save-excursion
      (goto-char (point-min))
      (let ((i 0)
            overlay num)
        (catch 'already-numbered
          (while (w3m-goto-next-anchor)
            (when (get-char-property (point) 'w3m-link-numbering-overlay)
              (throw 'already-numbered nil))
            (setq overlay (make-overlay (point) (1+ (point)))
                  num (format "[%d]" (incf i)))
            (w3m-static-if (featurep 'xemacs)
                (progn
                  (overlay-put overlay 'before-string num)
                  (set-glyph-face (extent-begin-glyph overlay)
                                  'w3m-link-numbering))
              (w3m-add-face-property 0 (length num) 'w3m-link-numbering num)
              (overlay-put overlay 'before-string num)
              (overlay-put overlay 'evaporate t))
            (overlay-put overlay 'w3m-link-numbering-overlay i)))))))
 
(apply-define-key
 global-map
 `(("M-M"     w3m-goto-url-new-session)
   ("C-x M-B" view-w3m-bookmark)
   ("C-x M-m" switch-to-w3m)))
 
(apply-define-key
 w3m-mode-map
  `(("<backtab>" w3m-previous-anchor)
    ("n"         w3m-next-anchor)
    ("p"         w3m-previous-anchor)
    ("w"         w3m-next-form)
    ("b"         w3m-previous-form)
    ("f"         w3m-go-to-linknum)
    ("M-n"       w3m-next-buffer)
    ("M-p"       w3m-previous-buffer)
    ("C-k"       kill-this-buffer)
    ("C-k"       w3m-delete-buffer)
    ("C-c 1"     w3m-delete-other-buffers)
    ("1"         delete-other-windows)
    ("C-x C-s"   w3m-save-current-buffer-sb)
    ("P"         w3m-print-current-url)
    ("U"         w3m-print-this-url)
    ("c"         w3m-copy-current-url)
    ("g"         w3m-goto-url-new-session)
    ("G"         w3m-goto-url)
    ("d"         w3m-download-this-url-sb)
    ("M-d"       w3m-download-sb)
    ("s"         w3m-search)
    ("S"         w3m-history)
    ("u"         View-scroll-page-backward)
    ("J"         roll-down)
    ("K"         roll-up)
    ("o"         other-window)
    ("m"         w3m-view-this-url-new-session)
    ("C-h"       w3m-view-previous-page)
    ("F"         w3m-view-next-page)
    ("C-;"       w3m-view-next-page)
    ("r"         w3m-reload-this-page)
    ("v"         w3m-bookmark-view-new-session)
    ("M-e"       w3m-bookmark-edit)
    ("'"         switch-to-other-buffer)))


===================================================================


;; official http://w3m.sourceforge.net/
(add-to-list 'load-path "/usr/share/emacs/site-lisp/w3m")
(require 'w3m-load)
;(require 'mime-w3m)

;;使用w3m作为默认的浏览器
(setq browse-url-browser-function 'w3m-browse-url)

;;启用cookie
(setq w3m-use-cookies t)
;;设定w3m图标所在文件夹
;(setq w3m-icon-directory "/home/zsl/.emacs.d/w3m/emacs-w3m-1.4.4/icons")

;;设定w3m运行的参数，分别为使用cookie和使用框架
(setq w3m-command-arguments '("-cookie" "-F"))

;;用w3m浏览网页时也显示图片
(setq w3m-default-display-inline-images t)

;;;w3m是使用tab的，设定Tab的宽度
;;(setq w3m-tab-width 4)
;;设定w3m的主页，同mozilla的默认主页一样
;;(setq w3m-home-page "file:///home/zsl/buffer/bookmarks.html")
(setq w3m-home-page "http://www.google.com")
;;当用 shift+RET 打开新链接时将不自动跳转到新的页面，等提示已经完全打开，才用 C-c C-n ，
;;C-c C-p 打开，这个好用
(setq w3m-view-this-url-new-session-in-background t)
(add-hook 'w3m-fontify-after-hook 'remove-w3m-output-garbages)

;;好像是有利于中文搜索的
(defun remove-w3m-output-garbages ()
  "去掉w3m输出的垃圾."
  (interactive)
  (let ((buffer-read-only))
    (setf (point) (point-min))
    (while (re-search-forward "[\200-\240]" nil t)
      (replace-match " "))
    (set-buffer-multibyte t))
  (set-buffer-modified-p nil))

(provide 'jerry-w3m)

;;; jerry-w3m.el ends here
;; Emacs-w3m的使用基本与w3m的使用相同，快捷键稍有不同。快捷键列表如下：

;; M-x w3m     启动
;; q     挂起 (w3m-close-window).
;; Q     退出 (w3m-quit)
;; Shift-RET     新标签打开  w3m-view-this-url-new-session
;; RET | Mouse-1     打开当前链接
;; M     用外部浏览器查看当前页面
;; R     刷新 (w3m-reload-this-page)
;; g     转到 (w3m-goto-url)
;; G     新标签中转到
;; U     转到
;; H     主页 (w3m-gohome)
;; s     历史 (w3m-history)
;; B     返回 (w3m-view-previous-page)
;; N     前进 (w3m-view-next-page).
;; ^     退回上一层 parent directory of the page currently displayed
;; SPC     下翻页 Scroll downwards
;; b     上翻页 
;; DEL     上翻页 Scroll upwards
;; d     下载 (w3m-download-this-url)
;; D 	(w3m-dtree)
;; \     查看源代码
;; =     查看头信息
;; u     复制链接地址到剪切板
;; c     复制本页地址到剪切板 (w3m-print-current-url)
;; E     编辑本页 (w3m-bookmark-edit)
;; e     编辑链接页
;; C-c C-c     提交textarea编辑 (w3m-submit-form)
;; C-c C-w     删除当前页 (w3m-delete-buffer) 只有一个标签页时，退出w3m.
;; C-c M-w     删除其他页 (w3m-delete-other-buffers) 
;; C-c C-t     复制当前页到新标签 (w3m-copy-buffer)
;; C-c C-n     下一个标签 (w3m-next-buffer)
;; C-c C-p     上一个标签 (w3m-previous-buffer)
;; C-c C-s     选择当前标签 (w3m-select-buffer)
;; C-c C-a 	(w3m-switch-buffer)
;; v     查看书签 (w3m-bookmark-view)
;; C-k 	(w3m-bookmark-kill-entry)
;; C-_ 	(w3m-bookmark-undo)
;; a     添加当前页面到书签 (w3m-bookmark-add-current-url)
;; M-a     添加链接到书签 (w3m-bookmark-add-this-url)
;; T     显示图片 (w3m-toggle-inline-images)
;; M-[     缩小当前图片 (w3m-zoom-out-image)
;; M-]     放大当前图片 (w3m-zoom-in-image)
;; M-i     保存当前位置图片 (w3m-save-image)
;; I     用外部查看器显示当前图片 (w3m-view-image)
;; key    move
;; M-g     跳到第 n 行
;; C-c C-@     标记当前位置
;; C-c C-v     跳到上次标记位置
;; TAB     下一个链接 Move the point to the next link
;; M-TAB     上一个链接 Move the point to the previous anchor.
;; ]     下一个表格 Move the point to the next form.
;; [     上一个表格 Move the point to the previous form.
;; }     下一幅图 Move the point to the next image.
;; {     上一幅图 Move the point to the previous image
;; >     右平移 (w3m-scroll-left)
;; <     左平移 (w3m-scroll-right)
;; .     最左端 Shift to the left
;; ,     最右端 Shift to the right
;; M-l     居中 (w3m-horizontal-recenter)
;; C-a     行首
;; C-e     行尾
;; J     屏幕下滚
;; K     屏幕上滚
;; r     重绘
;; C t     内容 重绘
;; C c     确定字符集 重绘
;; C C     确定字符集＋内容 重绘