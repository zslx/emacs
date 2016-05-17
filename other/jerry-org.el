;; jerry-org.el --- org模式的配置
;;; org是在outline-mode基础上建立的，一些outline的快捷键在这里都可以用，尤其喜欢C-tab 来变换视图
;; 还有 remember-mode

(setq org-todo-keywords '("TODO" "FEEDBACK" "VERIFY" "DEFERRED" "CANCELED"  "DONE") org-todo-interpretation 'sequence)

(setq org-tag-alist
	  '((:startgroup . nil)
		("@home" . ?h) ("@office" . ?o) ("onroute" . ?r)
		(:endgroup . nil)
		("web" . ?w) ("local" . ?l)
		))
					  
;; (setq org-tag-alist
;; 	  '((:startgroup . nil)
;; 		("web" . ?w) ("local" . ?l) (:endgroup . nil)
;; 		("life" . ?l) ("yoga" . ?y) ("model" . ?m) ))

;; GTD (getting things done) How I use Emacs and Org-mode to implement GTD.
;; http://members.optusnet.com.au/~charles57/GTD/gtd_workflow.html

;; (setq org-agenda-files
;;       (list (concat cfghome ".emacs.d/GTD/birthday.org") 
;;        (concat cfghome ".emacs.d/GTD/newgtd.org") 
;;      ;  "~/org/sparetime.org"
;;      ;  "~/org/fortune.org"
;;        ))

;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(auto-raise-tool-bar-buttons t t)
;;  '(auto-resize-tool-bars t t)
;;  '(case-fold-search t)
;;  '(current-language-environment "Latin-1")
;;  '(default-input-method "latin-1-prefix")
;;  '(make-backup-files nil)
;;  '(normal-erase-is-backspace t)
;;  '(org-agenda-files (quote ("c:/Charles/GTD/birthday.org" "c:/Charles/GTD/newgtd.org")))
;;  '(org-agenda-ndays 7)
;;  '(org-agenda-repeating-timestamp-show-all nil)
;;  '(org-agenda-restore-windows-after-quit t)
;;  '(org-agenda-show-all-dates t)
;;  '(org-agenda-skip-deadline-if-done t)
;;  '(org-agenda-skip-scheduled-if-done t)
;;  '(org-agenda-sorting-strategy (quote ((agenda time-up priority-down tag-up) (todo tag-up))))
;;  '(org-agenda-start-on-weekday nil)
;;  '(org-agenda-todo-ignore-deadlines t)
;;  '(org-agenda-todo-ignore-scheduled t)
;;  '(org-agenda-todo-ignore-with-date t)
;;  '(org-agenda-window-setup (quote other-window))
;;  '(org-deadline-warning-days 7)
;;  '(org-export-html-style "<link rel=\"stylesheet\" type=\"text/css\" href=\"mystyles.css\">")
;;  '(org-fast-tag-selection-single-key nil)
;;  '(org-log-done (quote (done)))
;;  '(org-refile-targets (quote (("newgtd.org" :maxlevel . 1) ("someday.org" :level . 2))))
;;  '(org-reverse-note-order nil)
;;  '(org-tags-column -78)
;;  '(org-tags-match-list-sublevels nil)
;;  '(org-time-stamp-rounding-minutes 5)
;;  '(org-use-fast-todo-selection t)
;;  '(org-use-tag-inheritance nil)
;;  '(unify-8859-on-encoding-mode t nil (ucs-tables)))

;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)

;; (setq org-log-done nil)
;; (setq org-agenda-include-diary nil)
;; (setq org-deadline-warning-days 7)
;; (setq org-timeline-show-empty-dates t)
;; (setq org-insert-mode-line-in-empty-file t)

;; (setq org-directory (concat cfghome ".emacs.d/orgfiles/") )
;; (setq org-default-notes-file (concat cfghome ".emacs.d/org.notes") )
;; (setq remember-annotation-functions '(org-remember-annotation))
;; (setq remember-handler-functions '(org-remember-handler))
;; (add-hook 'remember-mode-hook 'org-remember-apply-template)
;; (define-key global-map "\C-cr" 'org-remember)

;; (setq org-remember-templates
;; 	  '(
;; 		("Todo" ?t "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" (concat cfghome ".emacs.d/GTD/newgtd.org")  "Tasks")
;; 		("Private" ?p "\n* %^{topic} %T \n%i%?\n" (concat cfghome ".emacs.d/GTD/privnotes.org") )
;; 		("WordofDay" ?w "\n* %^{topic} \n%i%?\n" (concat cfghome ".emacs.d/GTD/wotd.org") )
;; 		))

;; (define-key global-map [f8] 'remember)
;; (define-key global-map [f9] 'remember-region)

;; (setq org-agenda-exporter-settings
;;       '((ps-number-of-columns 1)
;;         (ps-landscape-mode t)
;;         (htmlize-output-type 'css)))

;; (setq org-agenda-custom-commands
;; 	  '(
;; 		("P" "Projects"   
;; 		 ((tags "PROJECT")))
;; 		("H" "Office and Home Lists"
;; 		 ((agenda)
;;           (tags-todo "OFFICE")
;;           (tags-todo "HOME")
;;           (tags-todo "COMPUTER")
;;           (tags-todo "DVD")
;;           (tags-todo "READING")))
;; 		("D" "Daily Action List"
;; 		 (
;;           (agenda "" ((org-agenda-ndays 1)
;;                       (org-agenda-sorting-strategy
;;                        (quote ((agenda time-up priority-down tag-up) )))
;;                       (org-deadline-warning-days 0)
;;                       ))))
;; 		)
;; 	  )

;; (defun gtd ()
;;   (interactive)
;;   (find-file (concat cfghome ".emacs.d/GTD/newgtd.org") )
;;   )
;; (global-set-key (kbd "C-c g") 'gtd)

;; (add-hook 'org-agenda-mode-hook 'hl-line-mode)

; org mode start - added 20 Feb 2006
;; The following lines are always needed. Choose your own keys.

;; (global-set-key "\C-x\C-r" 'prefix-region)
;; (global-set-key "\C-x\C-l" 'goto-line)
;; (global-set-key "\C-x\C-y" 'copy-region-as-kill)

;; ===================================================== end == tmp

;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; ;(define-key global-map "\C-cl" 'org-store-link)
;; ;(define-key global-map "\C-ca" 'org-agenda)
;; (setq org-log-done 'time)

;; ;; Face for TODO keywords
;; (setq org-todo-keyword-faces
;;       '(
;;    ("TODO"      . (:foreground "red" :weight bold))
;;    ;("TODO"      . org-warning)
;;    ("DEFERRED"  . shadow)     ;; 延缓执行
;;    ("CANCELED"  . (:foreground "blue" :weight bold));;取消
;;    ))

;; ;; OrgMode & Remember
;; (org-remember-insinuate)
;; (setq org-directory "~/org")
;; (setq org-default-notes-file "~/org/notes.org")
;; (setq remember-annotation-functions '(org-remember-annotation))
;; (setq remember-handler-functions '(org-remember-handler))
;; (add-hook 'remember-mode-hook 'org-remember-apply-template)

;; ;; org project
;; (setq org-publish-project-alist
;;       '(("org"
;;     :base-directory "~/org/"
;;     :publishing-directory "~/org/public_html"
;;     :section-numbers nil
;;     :table-of-contents nil
;;     :style "<link rel=stylesheet
;;       href=\"../other/mystyle.css\"
;;       type=\"text/css\">")))

;; ;; 一些有用的命令
;; ;; C-c a W/w 找WAITING
;; ;; C-C a U/v/u 找BOSS-URGENT
;; ;; C-c a f 找 FIXME
;; (setq org-agenda-custom-commands
;;       '(("w" todo "WAITING")
;;    ("W" todo-tree "WAITING")
;;    ("u" tags "+BOSS-URGENT")
;;    ("v" tags-todo "+BOSS-URGENT")
;;    ("U" tags-tree "+BOSS-URGENT")
;;    ("f" occur-tree "\\<FIXME\\>")))


;; ;; 关联上Emacs的diary
;; ;; (setq org-agenda-include-diary t)
;; ;; open appt message function
;; (add-hook 'diary-hook 'appt-make-list)
;; (setq appt-display-diary nil)

;; ;; org to appt
;; (setq appt-display-format 'window)
;; (setq appt-display-duration 60)
;; (setq appt-audible t)
;; (setq appt-display-mode-line t)
;; (appt-activate 1)
;; ;(setq appt-msg-countdown-list '(10 0))
;;       ;(org-agenda)
;; (org-agenda-to-appt )
;; ;; 只要你在任务中，C-c C-s后，把Schedule的单词删除，那么就是
;; ;; 一个时间戳的概念，那么OrgMode就知道你是要让这个任务中特定的
;; ;; 时间跳出来，提醒你。这时，需要你使用我之前注释掉的代码：
;; ;; 来让OrgMode将这个任务条转换为appt。就是到时间提醒你，很实用的功能

(provide 'jerry-org)
;;; jerry-org.el ends here
