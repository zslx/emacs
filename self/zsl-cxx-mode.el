;;; zsl-cxx-mode.el --- 编程模式mode的配置，cc mode, c,c++
;; 看emacs自带的manual中的cc-mode一节，哇，发现新大陆了！不光讲得很细，还有个例子，拷过来就可以用了，那缩进，怎一个酷字了得！
;; `C-c C-s' 查看当前光标所在处的缩进标签.
;; `C-c C-o' 交互式设置缩进
;; `C-c C-q' 缩进defun
;; 缩进值， 0
;; +   c-basic-offset times 1
;; -   c-basic-offset times -1
;; ++  c-basic-offset times 2
;; --  c-basic-offset times -2
;; *   c-basic-offset times 0.5
;; /   c-basic-offset times -0.5

(setq c-basic-offset 4)

;; c-initialization-hook
;; c-mode-common-hook
;; c-mode-hook
;; c++-mode-hook

;(setq-default c-electric-flag nil) ;; 键入{};等符号时，自动缩进

;; <RET> newline and indent
(defun my-make-CR-do-indent ()
  (define-key c-mode-base-map "\C-m" 'c-context-line-break))
(add-hook 'c-initialization-hook 'my-make-CR-do-indent)

;; c-default-style

(defconst zsl-cxx-style
  '((c-tab-always-indent . t)
	(c-comment-only-line-offset . 0)
	(c-hanging-braces-alist . ((substatement-open before after)
							   (brace-list-open)))
    (c-hanging-colons-alist . ((member-init-intro before) 
							   (inher-intro) 
							   (case-label after) 
							   (label after) 
							   (access-label after)))
	(c-cleanup-list . (comment-close-slash
					   scope-operator
					   empty-defun-braces
					   defun-close-semi
					   compact-empty-funcall))
	(c-offsets-alist . ((innamespace . 0)
						(member-init-intro . 0)
						(substatement-open . 0)
						(arglist-close . c-lineup-arglist)
						(cpp-macro . 0)
						(case-label . +)
						(access-label . -)
						(inline-open . 0)
						(block-open . 0)))
	(setq comment-start "/*" comment-end "*/")
	(c-echo-syntactic-information-p . t)
	(setq indent-tabs-mode nil))
  "zsl-cxx-style"
  )

;; c-style-alist
(c-add-style "zsl-cxx-style" zsl-cxx-style)

;; offset customizations not in my-c-style 
(setq c-offsets-alist '((member-init-intro . ++)))

(defun zsl-cxx-hook ()
  (setq tab-width 4 indent-tabs-mode nil) ; tab as 4 whitespace
  (c-toggle-auto-hungry-state 1)		  ; hungry-delete and auto-newline
  ;; ;;显示C的typedef
  ;; (require 'ctypes)
  ;; (ctypes-auto-parse-mode 1)
  (c-set-style "zsl-cxx-style")
  )

(add-hook 'c++-mode-hook 'zsl-cxx-hook)

;;set *.h and *.c and *.cpp files use c++ mode
(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.c$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cpp$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.hpp$" . c++-mode) auto-mode-alist))



(require 'highlight-symbol)

;; ==================================================================
;; C/C++语言编辑策略

(defun my-c-mode-common-hook()
  (setq tab-width 4 indent-tabs-mode nil) ; tab as whitespace
  (c-set-style "stroustrup")

  (hs-minor-mode 1)				 ;; hideshow 代码折叠
  (define-key c-mode-base-map (kbd "C-,") 'hs-toggle-hiding)
  ;; hideshow mode 的 bug修正
  (add-to-list 'hs-special-modes-alist
			   '(c-mode "[\n\t ]*{" "}" "/[*/]" nil hs-c-like-adjust-block-beginning))
  (add-to-list 'hs-special-modes-alist
			   '(c++-mode "[\n\t ]*{" "}" "/[*/]" nil hs-c-like-adjust-block-beginning))

  (setq abbrev-mode 1) ;; 缩写->扩展
  ;;(define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)
  ;;预处理设置
  (setq c-macro-shrink-window-flag t)
  (setq c-macro-preprocessor "cpp")
  (setq c-macro-cppflags " ")
  (setq c-macro-prompt-flag t)
  ;; (require 'xcscope)
  )

;; (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; senator vs semantic
(defun my-cedet-hook ()
  (local-set-key (kbd "C-.") 'senator-complete-symbol)
  (define-key c-mode-base-map "\C-cm" 'senator-completion-menu-popup)

  ;(local-set-key (kbd "C-.") 'semantic-ia-complete-symbol)
  (local-set-key "\C-c?" 'semantic-analyze-possible-completions)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (define-key c-mode-base-map [(control tab)] 'semantic-ia-complete-symbol-menu)

  (local-set-key "\C-c=" 'semantic-decoration-include-visit) ; 查看头文件内容
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle) ;声明和实现跳转
  (local-set-key "\C-cw" 'eassist-switch-h-cpp)
  (local-set-key "\C-ct" 'eassist-list-methods)
  )
;; (add-hook 'c-mode-common-hook 'my-cedet-hook)

(defun c-mode-cedet-hook ()
  ;; (local-set-key "." 'semantic-complete-self-insert)
  ;; (local-set-key ">" 'semantic-complete-self-insert)
  (local-set-key "\C-cf" 'semantic-symref)
  (local-set-key "\C-c\C-r" 'semantic-symref-symbol)
  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-z\C-t" 'find-tag)
  (local-set-key "\C-z\C-c" 'tags-loop-continue)

  (local-set-key "\C-cq" 'semantic-ia-show-summary)
  ;(local-set-key "\C-cs" 'semantic-ia-show-doc)
  )
;; (add-hook 'c-mode-common-hook 'c-mode-cedet-hook)

;; C-x B: semantic-mrub-switch-tags
;; C-c,j/J: semantic-complete-jump-local, semantic-complete-jump
;; C-c,n/p: senator-next-tag, senator-previous-tag
;; C-c,u  : senator-go-to-up-reference

;; C-c,-/+: senator-fold-tag, senator-unfold-tag
;; C-c,C-w: C-c,M-w: C-c,C-y: C-y; senator-kill/copy/yank-tag

;; ;; C/C++语言启动时自动加载semantic对/usr/include的索引数据库
;; (setq semanticdb-search-system-databases t)
;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;; 	    (setq semanticdb-project-system-databases
;; 		  (list (semanticdb-create-database
;; 			 semanticdb-new-database-class
;; 			 "/usr/include")))))

;; (autoload 'gtags-mode "gtags" "" t)
;; (setq tags-table-list '("./TAGS" "../TAGS" "../../TAGS"))
;; (require 'tags-tree)					;C-o, G

;(require 'xcscope)
;; C-c s a             设定初始化的目录，一般是你代码的根目录  
;; C-c s I             对目录中的相关文件建立列表并进行索引  
;; C-c s s             序找符号  
;; C-c s g             寻找全局的定义  
;; C-c s c             看看指定函数被哪些函数所调用  
;; C-c s C             看看指定函数调用了哪些函数  
;; C-c s e             寻找正则表达式  
;; C-c s f             寻找文件  
;; C-c s i             看看指定的文件被哪些文件include
;; C-c s C-h           帮助


;; (defvar xref-key-binding 'none) ; 加载 xrefactory 时不执行键绑定
;(load "xrefactory")

;; Xrefactory configuration part ;; 必需依赖 Makefile ?!
;; some Xrefactory defaults can be set here
;; (defvar xref-current-project nil) ;; can be also "my_project_name"
;; (defvar xref-key-binding 'global) ;; can be also 'local or 'none
;; (setq load-path
;; 	  (cons "/backup/work.bk/03Dev/eDevelopEnvironment/03IDE/emacsIDE/xref/emacs" 
;; 			load-path))
;; (setq exec-path
;; 	  (cons "/backup/work.bk/03Dev/eDevelopEnvironment/03IDE/emacsIDE/xref"
;; 			exec-path))
;(load "xrefactory")
;; end of Xrefactory configuration part ;;
;(message "xrefactory loaded")

(provide 'zsl-c-mode)
;; file ends here
