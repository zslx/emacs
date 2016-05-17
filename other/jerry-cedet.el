;;; Jerry-cedet.el
;;; CEDET是一些使用emacs开发软件的时候常用的插件集合，其中的ECB，semantic,speedbar，都很实用
;;; Code:
;;Load CEDET
(load-file (concat elibs "cedet-1.1/common/cedet.el"))

;;Semantic
;; ---------------------------------------
(setq semanticdb-default-save-directory (concat etmp "semanticdb"))
;; (require 'semantic-ia) ;; 默认加载？
;; 设置 semantic 启用的功能
;; (semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
;; (semantic-load-enable-guady-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)
;; (semantic-load-enable-semantic-debugging-helpers)

;;配置Sementic的检索范围, 去哪里找头文件。 ede project
;; (setq semanticdb-project-roots (list (expand-file-name "/")))
(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))

(setq cedet-sys-include-dirs (list
                              "/usr/include"
                              "/usr/include/bits"
                              "/usr/include/glib-2.0"
                              "/usr/include/gnu"
                              "/usr/include/gtk-2.0"
                              "/usr/include/gtk-2.0/gdk-pixbuf"
                              "/usr/include/gtk-2.0/gtk"
                              "/usr/local/include"
                              "/usr/local/include"))

(setq cedet-others-include-dirs (list
								 "/neo/buildenv/core/include"
								 "/neo/buildenv/3rdparty/include"
								 "../utility"
								 "../../conf"))

(defconst cedet-win32-include-dirs
  (list "C:/MinGW/include"
        "C:/MinGW/include/c++/3.4.5"
        "C:/MinGW/include/c++/3.4.5/mingw32"
        "C:/MinGW/include/c++/3.4.5/backward"
        "C:/MinGW/lib/gcc/mingw32/3.4.5/include"
        "C:/Program Files/Microsoft Visual Studio/VC98/MFC/Include"))

(require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
  (when (eq system-type 'windows-nt)
    (setq include-dirs (append include-dirs cedet-win32-include-dirs)))
  (append include-dirs cedet-sys-include-dirs)
  (append include-dirs cedet-others-include-dirs)

  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))


;; 上面配置中 (require ’semantic-c nil ‘noerror)是必须的，因为semantic的大部分功能是autoload的，如果不在这儿load semantic-c，那打开一个c文件时会自动load semantic-c，它会把semantic-dependency-system-include-path重设为/usr/include，结果就造成前面自定义的include路径丢失了。
;; 解析文件是semantic基本高级功能的基础，正确地解析了文件我们才能实现：代码跳转和代码补全。

(when (executable-find "global")
  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode))

;; 有了前面的配置，semantic自动就解析c/c++文件，解析完后跳转就容易了：光标放在函数上，执行M-x semantic-ia-fast-jump，马上就跳转到函数的定义上了。如果跳不过去，那就检查一下前面配置的INCLUDE路径，是不是当前文件 include的所有头文件都能在INCLUDE中找到。
;; 通过C-h v semantic-dependency-system-include-path RET检查INCLUDE路径

;; 另外，跳转过去了还需要跳回来，在打开 mru-bookmark-mode 的情况下，按[C-x B]，emacs会提示你跳回到哪个地方，一般默认的就是上一次semantic-ia-fast-jump的位置，所以回车就可以回去了。

;; global-semantic-mru-bookmark-mode
;; 要按[C-x B] [RET]这么多键实在有点麻烦，所以写个函数不提示直接就跳回上次的位置，并把它绑定到shift+f12上了：
(defun semantic-ia-fast-jump-back ()
  (interactive)
  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
	  (error "Semantic Bookmark ring is currently empty"))
  (let* ((ring (oref semantic-mru-bookmark-ring ring))
		 (alist (semantic-mrub-ring-to-assoc-list ring))
		 (first (cdr (car alist))))
	(if (semantic-equivalent-tag-p (oref first tag)
								   (semantic-current-tag))
		(setq first (cdr (car (cdr alist)))))
	(semantic-mrub-switch-tags first)))

;; 除了semantic-ia-fast-jump可以跳转之外，其实semantic中还有两个函数也有类似的功能：
;; * semantic-complete-jump-local
;; * semantic-complete-jump

;; 查看当前光标下面的函数被哪些函数调用了。 Cedet中的 semantic-symref 实现了这一功能


;; semantic中有4个用来代码补全的命令：
;; * senator-complete-symbol
;; * senator-completion-menu-popup
;; * semantic-ia-complete-symbol
;; * semantic-ia-complete-symbol-menu


;; ;;;; Custom template for srecode
;; (setq srecode-map-load-path
;; 	  (list (srecode-map-base-template-dir)
;; 			(expand-file-name (concat elibs "cedet-1.1/srecode/templates") )))
;; ;; help: C-u C-h i pkg-dir/common/cedet.info ;; info: pnut,lLr,d

;; 配置 Emacs Code Browser : ecb-2.40 不好用
;; add path to load-path
;; (require 'ecb)

;(global-srecode-minor-mode 1)            ; Enable template insertion menu

;;Eieio
;; (global-ede-mode t)		 ; Enable the Project management system

;; (enable-visual-studio-bookmarks)
;; 之后就可以通过下面几个按键操作书签了：
;;     * F2 在当前行设置或取消书签
;;     * C-F2 查找下一个书签
;;     * S-F2 查找上一个书签
;;     * C-S-F2 清空当前文件的所有书签
  ;; (define-key global-map [(control f2)] 'viss-bookmark-toggle)
  ;; (define-key global-map [M-f2] 'viss-bookmark-toggle)
  ;; (define-key global-map (kbd "ESC <f2>") 'viss-bookmark-toggle) ; putty
  ;; (define-key global-map [(f2)] 'viss-bookmark-next-buffer)
  ;; (define-key global-map [(shift f2)] 'viss-bookmark-prev-buffer)
  ;; (define-key global-map [(control shift f2)] 'viss-bookmark-clear-all-buffer)
;; 有点遗憾的是这个书签功能只能在当前buffer的书签间跳转。 

;; h/cpp切换
;; eassist-switch-h-cpp有个BUG：它是通过文件扩展名来匹配的(通过eassist-header-switches可配置)，默认它能识别h/hpp/cpp/c/C/H/cc这几个扩展名的文件；但是C++的扩展名还可能会有别的，比如c++,cxx等，对一个扩展名为cxx的文件调用eassist-switch-h-cpp的话，它会创建一个新buffer显示错误信息。所以把eassist-header- switches配置为： 
(setq eassist-header-switches
      '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
        ("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
        ("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
        ("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
        ("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
        ("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
        ("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
        ("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
        ("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
        ("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
        ("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
        ("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
        ("c" . ("h"))
        ("m" . ("h"))
        ("mm" . ("h"))))
;; 基本上所有C/C++的扩展名都包含了，同时ObjectiveC也可以用了。 


;; 我期待像eclipse那样可以通过鼠标在直接点击就可以打开和折叠代码，这个功能在cedet也实现了，就是semantic-tag-folding.el(也在cedet的contrib目录下)
(require 'semantic-tag-folding nil 'noerror)
(global-semantic-tag-folding-mode 1)

;; 只要用鼠标点击左侧的小三角图标就可以打开或折叠代码了。箭头向下的空心三角表示这段代码可以被折叠，箭头向右的实心三角表示这段代码被打折过了。

;; 为了方便键盘操作，按键绑定到了[C-c , -]和[C-c , +]上(绑定这么复杂的按键主要是为了和senator兼容，后面会讲到senator实现代码折叠)： 
(define-key semantic-tag-folding-mode-map (kbd "C-c , -") 'semantic-tag-folding-fold-block)
(define-key semantic-tag-folding-mode-map (kbd "C-c , =") 'semantic-tag-folding-show-block)

;; 同时它还提供了两个函数可以同时打开和折叠整个buffer的所有代码，分别是semantic-tag-folding-fold-all和semantic-tag-folding-show-all，把它们绑定到了[C-_]和[C-+]上：
(define-key semantic-tag-folding-mode-map (kbd "C-_") 'semantic-tag-folding-fold-all)
(define-key semantic-tag-folding-mode-map (kbd "C-+") 'semantic-tag-folding-show-all)

;; 打开semantic-tag-folding-mode后，用gdb调试时不能点左侧的fringe切换断点了，所以我把C-?定义为semantic-tag-folding-mode的切换键，在gdb调试时临时把semantic-tag-folding关掉：
(global-set-key (kbd "C-?") 'global-semantic-tag-folding-mode)

;; senator-fold-tag
;; 终端下不用semantic-tag-folding了，替代方案：首先 hs-minor-mode，此外cedet的senator也提供了一种代码折叠方案。

;; 只要启用了senator-minor-mode(emacs中会出现Senator菜单)，就可以通过M-x senator-fold-tag和M-x senator-unfold-tag来折叠和打开代码了，GUI和终端下都可以使用。
;; 默认地，senator-fold-tag绑定到[C-c , -]，senator-unfold-tag绑定到[C-c , +]上(所以前面把semantic折叠的快捷键也绑定到这两个键上，这样GUI和终端下快捷键就一致了)。不过senator里好像没有对应的 fold-all和show-all方法。


;; keybindings
;;(global-set-key [(control tab)] 'senator-complete-symbol);
;;(global-set-key [(control tab)] ' senator-completion-menu-popup)
;(global-set-key [(control tab)] 'semantic-ia-complete-symbol-menu)

;; ;;ecb keys,  show/hide ecb
;; (global-set-key (kbd "C-c e") 'ecb-activate)
;; (global-set-key (kbd "C-c o") 'ecb-show-ecb-windows)
;; (global-set-key (kbd "C-c c") 'ecb-hide-ecb-windows)
;; (global-set-key (kbd "C-;") 'ecb-goto-window-edit-last) ;;切换到编辑窗口
;; (global-set-key (kbd "C-'") 'ecb-goto-window-methods) ;;切换到函数窗口

(provide 'jerry-cedet)
;;; jerry-cedet.el ends here
