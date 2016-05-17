;;「Getting Things Done《尽管去做：无压工作的艺术》」是美国的商业顾问David Allen提倡的一种提高生产效率的系统。利用GTD可以缓解压力，使心情平静，专心地工作，学习。

;; 
;; 3 输入链接 "C-c C-l"in org buffer, [[link][description]]
;;   "C-c C-o" 打开光标处的链接。
;; 
;; 每个文件可以有自己私有的配置, 例如:
;; #+TAGS: { GUI(g) Server(s) } Editor(e) Browser(b)
;; 
;; 设置标签的主要目的还是为了查询。org-mode 会为搜索结果建立一个视图
;; C-c / T
;; C-u C-c \	搜索带 TODO 的标签
;; 
;; 在查询视图中 C-c C-c 退出, 根据光标不同的位置，不同的行为。刷新标签，设置标签。
;; 
;; 2 "C-c C-t" set keyword, todo, started, done, canceled,,,
;; 6 事件状态: TODO DONE 'C-c C-t'切换
;; 'M-S-RET' 新建事件 org-insert-todo-heading
;; #+SEQ_TODO: TODO(t) | DONE(d!) CANCELED(c@/!)
;; | 分割完成和未完成两种状态， 完成状态会打上 CLOSED 时间戳.
;; 
;; 'C-c C-v', 'C-c / t' 查询视图
;; 'C-c [' 将当前文件加入日程表, org-agenda-file-to-front
;; 
;; 7 告诉 org-agenda 从哪些文件搜索内容, org-agenda-files
;; 'C-c a':
;; t 进入全局 TODO 列表， "n/p" 移动， "t" 更改状态。
;; a 进入 org-agenda 视图, 'l' 开启/关闭 log-mode
;; 'C-c ]' org-remove-file
;; 
;; 8 优先级： A,B,C : 'C-c ,', 'S-up','S-down';
;; 
;; 9 进度： [67%] or [1/3]
;; 
;; x 时间： 'C-c C-d' DeadLine, 'C-c C-s' Scheduled.
;; 'C-c .' org-time-stamp 当前位置插入一个时间戳。
;; S-left|S-right	以天为单位调整时间戳时间
;; S-up|S-down	调整光标所在时间单位；如果光标在时间戳之外，调整时间戳类型（是否在日程表中显示）
;; 
;; C-u C-c .	更加精确的时间戳，在日程表中以时间线显示
;; C-c !	插入时间戳，不在日程表中显示
;; C-c <	直接插入时间戳（当前日期）
;; C-c >	查看日历
;; C-c C-o	访问当前时间戳的日程表
;; C-c C-y	计算时间范围长度
;; 
;; y 列视图
;; C-c C-x C-c 进入列视图；按 q 退出：
;; r|g	刷新
;; q	退出
;; left|right	在列间移动
;; S-left|S-right	改变当前列的值
;; n|p
;; 1~9,0	用编号选择值
;; v	查看当前值

;;  Org-mode作弊条
;; ~~~~~~~~~~~~~~~~~ cursor on the title
;; 快捷键          功能
;; C-c a           agenda模式
;; C-c C-s         设置schedule时间
;; C-c C-d         设置deadline时间
;; C-c C-t         设置事务状态
;; C-c C-c         设置标签, tag
;; C-c ,           设置优先级
;; S-/   改变优先级


;; Org 文件最好事先创建好，头部是一些设置。 分类用的标签
;; STARTUP, TAGS, SEQ_TODO,

;; org文件中的配置
;; ====================
;; org-mode也支持per-file-variable，所以可以对每个文件进行单独的配置。由于我使用类GTD的方法进行管理，所以我在每个文件中都加上类似的标签配置。
;; #+TAGS: @work(w) @home(h) @sport(s)
;; #+TAGS: laptop(l) pc(p)
;; 这些标签用于标示GTD中的context概念。
;; 注：这里的内容可以随时更改，修改后用 'C-c C-c' 刷新设置。

;; http://www.douban.com/group/topic/9183787/

;; GTD:getting things done
;; 1 collect  收集
;; 2 process  整理      todo.org
;; 3 organise 组织执行
;; 4 review   回顾
;; 5 do       执行
;; 
;; 这五个步骤的记录操作都在一个org文件中完成。
;; todo.org  amuse.org notes.org
;; 
;; 用以下的词汇来表征任务表：
;; 处理，提问，回避，购买，变更，明确，收集，委托，从事，深思，想象，决定，延期，开发，废弃，重新实现，下载，输入，整理，跟踪，雇佣，改善，增加，报告，寻找，维持，测定，检测，订货，描画，打电话，设置优先级，购入，减少，记忆，修理，回复，调查，回顾，时间安排，卖，送，服务，指定，开始，停止，建议，规划，坐车，更新，升级，写。

;; 与任务的（Next Action）中说明的一样，这里也用一些动词来表述项目：安成，决定，处理，调查，提示，扩大，计划，设计，结束，确定，查询，展开，更新，安装，改良，设定。

;; 如果想高效地使用GTD系统需要掌握以下的方法
;; **系统**中收集你所关心的和必须要做的所有事情。这个系统包括物理的实体（或者可以表现的东西），纸，E-Mail，邮件，笔记等。
;; 准备一个 收集箱 放入任何关心的内容。收集箱可以是一个文件盒，邮件客户端程序，语言邮件或者是一个笔记本等。
;; 定期地将关心的事情收集整理的工作流。通常需要每天执行。
;; Next Action（下一步的工作）阶段，为了容易地执行任务，用明确的动词定义目地和行为。
;; 基于具体的情境（Contexts），时间等，在合适的分类构造中组织管理提示和信息。这样的系统结构中包含日历，备忘录，文件整理系统等。
;; 大概每天或者一周一次回顾，从而保证你的“委托”和“任务”保持最新状态。
;; 定义并执行项目，自然而然地形成一个任务计划模型。
;; 使用GTD系统的好处是做任何事的时候可以专心一意，不用担心有被遗忘的项目。我定期地将思考的问题，委托别人做的工作，创意构思，「to do」等项目记录到可信赖的系统中。这样一来，我可以不在顾虑是否有遗忘的工作，想法，从而专心致志地思考，工作。


;; (require 'org)
;; (require 'org-install)
;; (add-to-list 'auto-mode-alist '("\.\(org\|org_archive\|txt\)$" . org-mode))

;; remember 帮助写 org 内容
;; (autoload 'remember "remember" nil t)
;; (autoload 'remember-region "remember" nil t)

;; (require 'remember)
;; (require 'org-remember)

(setq org-root-dir edatas)
(setq org-directory (concat org-root-dir "/Org"))
(setq org-default-notes-file (concat org-directory "/notes.org"))

(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)

;; (setq org-remember-templates
;; 	  '(
;; 		("Todo" ?t "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" "GTD/newgtd.org" "Tasks")
;; 		("Private" ?p "\n* %^{topic} %T \n%i%?\n" "GTD/privnotes.org")
;; 		("WordofDay" ?w "\n* %^{topic} \n%i%?\n" "GTD/wotd.org")
;; 		("Note" ?n "\n* %U %^{笔记} %^g \n%i%?\n %a" "GTD/notes.org")
;; 		))

(setq org-remember-templates
	  '(
		;; ("Collect" ?c "\n* %^{topic|s闪现|a遗留|b添花 } %T \n%i%?\n" "GTD/collect.org" "Collection")
		("Todo" ?t "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" "GTD/todo.org" "Tasks")
		("Task" ?k "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" "task.org" "Tasks")
		("fomo" ?o "\n* %U \n%i%?\n" "GTD/amuse.org")
		;; ("Note" ?n "\n* %U %^{笔记} %^g \n%i%?\n %a" "GTD/notes.org" "Note from org-remember")
		("Note" ?n "\n* %U %^g \n%i%?\n" "GTD/notes.org" "Note from org-remember")
		))


;; (setq org-log-done nil) ; time, note,
;; (setq org-hide-leading-stars t)
;; (setq org-agenda-include-diary nil)
;; (setq org-deadline-warning-days 7)
;; (setq org-timeline-show-empty-dates t)
;; (setq org-insert-mode-line-in-empty-file t)



;; (setq org-agenda-files (list org-directory))
;; (setq org-agenda-files '())
;; home, office, on-road,
(when (file-exists-p org-root-dir)
  (setq org-agenda-files
		(list
		 (concat org-directory "/GTD/todo.org")
		 (concat org-directory "/GTD/notes.org")
		 (concat org-directory "/GTD/amuse.org")
		 (concat org-directory "/task.org")
		 ;; (concat org-directory "personal.org")
		 ;; (concat org-directory "lab.org")
		 ;; (concat org-directory "opensource.org")
		 )))

(defun todo ()
  (interactive)
  (find-file (concat org-directory "/GTD/todo.org"))
  )

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
;;           (tags-todo "Kungfu")
;;           (tags-todo "FOMO")
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


;; (setq org-todo-keywords '((sequence "TODO" "STARTED" "DONE" "CALENDAR" "DEFERRED")))
;; (setq org-todo-keywords (list "TODO(t)" "STARTED(s!)" "WAITING(w@)" "|" "CANCELED(c)" "DONE(d)"))

;; (add-hook 'org-agenda-mode-hook 'hl-line-mode)

;; 任务提醒，用 appt(appointments)
(defun wl-org-agenda-to-appt ()
  ;; Dangerous!!!  This might remove entries added by `appt-add' manually. 
  (org-agenda-to-appt t "TODO"))

(defadvice  org-agenda-redo (after org-agenda-redo-add-appts)
  "Pressing `r' on the agenda will also add appointments."
  (progn
    (let ((config (current-window-configuration)))
      (appt-check t)
      (set-window-configuration config))
    (wl-org-agenda-to-appt)))

;; (wl-org-agenda-to-appt)
;; (ad-activate 'org-agenda-redo)


;; GTD key bindings
(define-key global-map "\C-cr" 'org-remember)

(global-set-key (kbd "C-c g") 'todo)
(global-set-key "\C-ca" 'org-agenda)

(define-key global-map "\C-cl" 'org-store-link)

;; (global-set-key "\C-cb" 'org-iswitchb)

;; (define-key global-map [f8] 'remember)
;; (define-key global-map [f9] 'remember-region)

;; (global-set-key "\C-x\C-r" 'prefix-region)
;; (global-set-key "\C-x\C-l" 'goto-line)
;; (global-set-key "\C-x\C-y" 'copy-region-as-kill)

;; <C-S-return> in Org mode



;; 对于记笔记，我的打算很简单，一个目录用来装所有的笔记，一个目录用来存放publish成HTML格式的笔记。并且能够自动生成索引文件。这样就可以在索引文件里直接查找并跳转到所有的笔记里。

;; (setq org-publish-project-alist
;;       '(("note-org"
;;          :base-directory "MyDropbox/emacs/org/org"
;;          :publishing-directory "MyDropbox/emacs/org/publish"
;; 		 :base-extension "org"
;;          :recursive t
;;          :publishing-function org-publish-org-to-html
;;          :auto-index nil
;;          :index-filename "index.org"
;;          :index-title "index"
;;          :link-home "index.html"
;;          :section-numbers nil
;;          :style "<link rel=\"stylesheet\"
;;                 href=\"./style/emacs.css\"
;;                 type=\"text/css\"/>")
;;         ("note-static"
;;          :base-directory "MyDropbox/emacs/org/org"
;;          :publishing-directory "MyDropbox/emacs/org/publish"
;;          :recursive t
;;          :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|swf\\|zip\\|gz\\|txt\\|el"
;;          :publishing-function org-publish-attachment)
;;         ("note" 
;;          :components ("note-org" "note-static")
;;          :author "shenglinzh@gmail.com"
;;          )))

;; (global-set-key (kbd "<f8> p") 'org-publish)


;; 我所使用的Org-mode文件有以下几种：

;; newgtd.org
;; 最主要的文件。包括TODO，项目，预定等，到了时间需要想到的东西都被记录在内。

;; newgtd.org_archive
;; newgtd.org文件的档案文件。这里记录了已完成任务的履历。

;; someday.org
;; 　将来/也许（Someday/Maybe）某天会做的事文件。这里记录了我还没决定何时做的事情，比如像学习什么，想读的书，想去的地方，新项目的构思，想法等。这里的内容我会每周回顾。

;; journal.org
;; 这个文件作为电子笔记记录了Web地址，每天的笔记，摄影记录，读书笔记，会议笔记，行动记录等信息。

;; birthday.org
;; 记录生日或者是纪念日等信息。这个文件也是一个我的预定计划文件。

;; 主要的GTD文件有5个部分组成。它们分别是任务，日历，工程项目，借的东西，财务管理。每个标题用议程表格式来区分不同的分类级别。

;; 任务（TASKS）

;; 这个就是一般的ToDo链表功能。如果有什么需要做的了，我就会执行「C-c r t」命令，使用Remember mode来添加这个任务。简明扼要地写好了任务之后，我会使用「C-c C-c」命令来添加该任务的情境（Contexts，HOME、OFFICE等）。

;; 任务分类刚开始像是下面这个样子。2
;; #+STARTUP: showall
;; * TASKS
;; #+CATEGORY: Tasks
;; ** Tidy out the middle desk drawer            :HOME:
;; ** Read the Training Objectives               :OFFICE:
;; ** Watch Star Wars IV                         :DVD:
;;    SCHEDULED: <2009-01-14 Wed>

;; GTD系统中任务的情境（Contexts），是指比如HOME（在家）或者OFFICE（在公司）等完成任务的场所。


;; 添加任务的过程很快捷，并不会打乱工作的流程。且Remember的模板中包含可以添加日期的设定。即使任务的链表很长，或者有延迟的任务时，通过回顾能有效地明确当前的任务。通常回顾的时候，可以按照添加任务的顺序或者是时间先后顺序来记录。

;; ("Todo" ?t "* TODO %^{Brief Description} %^g\n%?\nAdded: %U"
;;       "c:/charles/GTD/newgtd.org" "Tasks")

;; 任何任务都应该用明确的动词来表征「Next Action」的行为，并记述该动词的目的和行为的目标。这样一来你不需要再次思考任务的形式，从而简单地执行。比如，与其写「周报告」不如以「总结这一周的来表述任务的内容更加能够容易理解该做什么。

;; 我用以下的词汇来表征任务表： action
;; 处理，提问，回避，购买，变更，明确，收集，委托，从事，深思，想象，决定，延期，开发，废弃，重新实现，下载，输入，整理，跟踪，雇佣，改善，增加，报告，寻找，维持，测定，检测，订货，描画，打电话，设置优先级，购入，减少，记忆，修理，回复，调查，回顾，时间安排，卖，送，服务，指定，开始，停止，建议，规划，坐车，更新，升级，写。


;; 日历
;; 这里记录了节假日，学校的联欢会等特别的活动的时间信息，以里程碑的形式组织并使用。需要在特殊日子里完成的任务或项目被记录到该分类中，用日程表的形式来确认。

;; 比如我将公共假期用以下的形式来表示：
;; #+STARTUP: showall
;; ** Calendar
;; #+CATEGORY: Calendar
;; *** Public Holidays 2009
;; **** Australia Day (Holiday)
;;      SCHEDULED: <2009-01-26 Mon>
;; **** Valentines Day
;;      SCHEDULED: <2009-02-14 Sat>
;; **** St Patricks Day
;;      SCHEDULED: <2009-03-17 Tue>
;; **** Good Friday (Holiday)
;;      SCHEDULED: <2009-04-10 Fri>


;; 工程项目
;; 我使用这个分类来记录各个工程项目中的详细信息。一个工程项目对应一个以上的行动，并且它们通常都付有结束的日期。

;; 在各个工程项目的目录中记述项目的内容，换句话说就是细化项目流程，在其下方用目录构造表示。

;; 与任务的（Next Action）中说明的一样，这里我也用一些动词来表述项目：安成，决定，处理，调查，提示，扩大，计划，设计，结束，确定，查询，展开，更新，安装，改良，设定。

;; #+STARTUP: showall
;; * Projects
;; #+CATEGORY: Projects
;; ** Implement Brian Tracy Focal Point Program                     :PROJECT:
;; *** Outcome
;;     DEADLINE: <2009-09-30 Wed>
;;     Make the Focal Point methodology an ingrained part of my being
;; *** TODO Detailed study of Health and Fitness Chapter            :READING:
;;     DEADLINE: <2009-01-19 Mon>
;; *** Detailed study of Business and Career (Focal Point)          :READING:
;; *** Detailed study of Family & Personal life (Focal Point)       :READING:
;; *** Detailed study of Money and Investments (Focal Point)        :READING:
;; *** Detailed study of Personal Growth and Develop (Focal Poin    :READING:
;; *** Detailed study of Social and Community (Focal Point)         :READING:
;; *** Detailed study of Spiritual Dev & Inner Peace (Focal Point)  :READING:


;; 财务管理

;; 我支付的账单记录被保存在此，包括现金和信用卡的支付记录。
;; #+STARTUP: showall
;; ** Financial
;; #+CATEGORY: Financial
;; ** TODO Prepare a Budget for 2009                                   :COMPUTER:
;; ** Pay Credit Cards                                                 :COMPUTER:
;;    SCHEDULED: <2009-01-22 Wed +1m>
;; ** Pay Mortgage                                                     :COMPUTER:
;;    SCHEDULED: <2009-01-22 Wed +1m>

;; 最后面两个是每个月都会定期发生的，这种情况下可以设定支付的日期。


;; 借的东西

;; 我经常去公司和家附近的图书馆。所以基本上过3～4周都有必须返还的书籍，DVD，CD，杂志等，差不多每次最少的情况下都会有20多种。所以我使用Org-mode来管理返还的时间期限。
;; #+STARTUP: showall
;; ** Borrowed
;; #+CATEGORY: Borrowed
;; *** Stanton Library
;; **** TODO Watch Mikrokosmos                                              :DVD:
;;      DEADLINE: <2009-01-30 Fri>
;; **** TODO Read Parrots of Australia                                  :READING:
;;      DEADLINE: <2009-01-30 Fri>
;; **** TODO Watch The diaries of Vaslav Nijinsky                           :DVD:
;;      DEADLINE: <2009-01-23 Fri>


;; 配置设定

;; 文件的最后部分是用来设置Org-mode的。这些内容通常是不显示的。

;; ** org-mode configuration
;; #+STARTUP: overview
;; #+STARTUP: hidestars
;; #+STARTUP: logdone
;; #+PROPERTY: Effort_ALL  0:10 0:20 0:30 1:00 2:00 4:00 6:00 8:00
;; #+COLUMNS: %38ITEM(Details) %TAGS(Context) %7TODO(To Do) %5Effort(Time){:} %6CLOCKSUM{Total}
;; #+TAGS: { OFFICE(o) HOME(h) } COMPUTER(c) PROJECT(p) READING(r)
;; #+TAGS: DVD(d) LUNCHTIME(l)
;; #+SEQ_TODO: TODO(t) STARTED(s) WAITING(w) APPT(a) | DONE(d) CANCELLED(c) DEFERRED(f)



;; 分类用标签

;; 为了使各个分类项目的标题在日程表（Agenda View）1中显示，需要在项目名称下面写上「#+CATEGORY」。显示的项目是“工程项目”，“任务”，“借的东西”（近期必须结束的）或者“财务管理”中的一部分。

;; 写这篇文章的时候，使用「#+CATEGORY」有不能对应多个匹配任务的问题。为了替代它，使用类似与下面PROPERTIES的方法。

;; :PROPERTIES:
;; :CATEGORY: Projects
;; :END:

;; 下面是一个将分类的标签用Agenda View表示的例子。按照情境（Contexts）的标签顺序来排序。

;; Tasks:      TODO Write descrip of my GTD / orgmode                  :COMPUTER:
;; Tasks:      TODO Study the Inkscape Tutorial Book                   :COMPUTER:
;; Tasks:      TODO Write an article about org-mode vocabulary capture :COMPUTER:
;; Projects:   TODO Write notes and lists of Japanese adjectives       :COMPUTER:
;; Financial:  TODO Pay Mastercard                                     :COMPUTER:
;; Projects:   TODO Tidy up my GTD web site .. directory on display    :COMPUTER:
;; Tasks:      TODO Watch TOKYO STORY                                       :DVD:
;; Projects:   TODO Daily Hiragana review on Anki                          :HOME:
;; Projects:   TODO Daily Katakana review on Anki                          :HOME:
;; Projects:   TODO Study - Beyond Words: A Guide to Drawing Out Ideas     :HOME:
;; Projects:   TODO Read TALE OF THE GENJI                              :READING:



;; 情境（Contexts）的标签

;; GTD系统中情境（Contexts）的标签是指任务执行的场所，环境。在时间管理的概念中就是按所处的环境来分割TODO项目。

;; 我在公司的时候，会搜索“OFFICE”情境的标签，在家的时候查看“HOME”或者“HOME COMPUTER”情境的标签。吃早餐的时候或是上班坐车的路上我会读书，这时需要搜索“READING”情境的标签。

;; 即使有许多的任务，使用情境也能简单地筛选出当前环境处理的任务。我的情境标签像下面一样设置。

;; #+TAGS: { OFFICE(o) HOME(h) } COMPUTER(c) PROJECT(p) READING(r)
;; #+TAGS: DVD(d) LUNCHTIME(l)
;; 简单地说明一下各个情境的意思。

;; Office
;; 在悉尼我的办公室安成的工作
;; Home
;; 在家或者自己空闲的时候安成的工作。比如，「给Bill送去包裹」等任务
;; Computer
;; 在家使用计算机安成的任务
;; Reading
;; 早餐，上班路上阅读书籍，杂志等
;; DVD
;; 在家欣赏电影
;; Lunchtime
;; 中午午休时间必须要完成的任务。这里包含上班前/后需要安成的任务。比如逛街购物等。
;; Project
;; 为了表示我所参与的项目，项目的标题部分添加标签。

;; 执行「C-c C-c」，可以选择你所期望的标签。


;; ToDo的状态

;; 为了表示ToDo的状态，我使用一下的组合。这些和在John Wiegley的博客中示范的一样。

;; #+SEQ_TODO: TODO(t) STARTED(s) WAITING(w) APPT(a) | DONE(d) CANCELLED(c) DEFERRED(f)
;; 这些状态标签按照以下的意思使用。

;; TODO
;; 这个项目是指该项目不久以后，或者某一天（也许某一时间）准备开始的项目。它是与预定相关的标签。一些任务会有DEADLINE来表明该任务安成的最终截止期限。
;; STARTED
;; 对于已经开始的任务，我会使用该标签。
;; WAITING
;; 我只能等待任务的结果的时候，使用该标签。使用该标签的时候，在任务的内容中填写记录。为了将来想起该任务将其添加到预定中。
;; APPT
;; 并不是任何时候都执行的任务，而是在特定的时间，日期需要完成的时候使用该标签。
;; DONE
;; 安成的任务
;; CANCELLED
;; 该任务决定不需要执行的时候在文件中用该标签标记
;; DEFERRED
;; 为了明确当前还没有开始执行的项目，使用该标签。理由是因为很多的情况下在任务的内容中记录了大量的笔记。
;; 为了快速的选择该标签，我将「org-use-fast-todo-selection」参数设置为TRUE。用「C-c C-t」命令后显示如下画面。


;; 一天的计划

;; 当开始新的一天，我会首先用「C-c a H」命令来查看所有的情景，回顾这一天的预定。接下来，按照不同的标签，安排这一天的的任务。为了浏览该表，我定制了以下的命令。

;; ("H" "Office and Home Lists"
;;     ((agenda)
;;          (tags-todo "OFFICE")
;;          (tags-todo "HOME")
;;          (tags-todo "COMPUTER")
;;          (tags-todo "DVD")
;;          (tags-todo "READING")))

;; 接下来，我会确认是否有逼近最终期限，发出警告的东西，并将发现的任务加入预定表中。比如，像下面支付建筑物保险的日子只有5天了。

;; Financial:  In 5 d.:  NRMA Home Building Renewal due         :OFFICE
;; 我4周前接到通知，支付的期限是１月１８日。我创建该任务并记入支付的最终期限。

;; #+STARTUP: showall
;; ** NRMA Home Building Renewal due                      :OFFICE:
;;    DEADLINE: <2009-01-18 Sun>
;; 结果，当日期临近，系统会提醒我不要忘了交账单。我决定星期四交，那么在该任务预定处输入「C-c C-s」命令，然后输入「Thur」后回车，就变成下面的样子。

;; #+STARTUP: showall
;; ** NRMA Home Building Renewal due                       :OFFICE
;;    DEADLINE: <2009-01-18 Sun> SCHEDULED: <2009-01-15 Thu>
;; 当到了星期四，我回顾特定的项目以后，根据标签来将项目分组。用GTD系统按照情境表示需要做的工作，如果我在公司，就可以按照OFFICE来搜索。

;; 我选择必须在今天完成的项目，并维护其进度。同时努力使任务的长度不超过15项。

;; 为了以情景的顺序表示今天的预定表，需要在做成一张日程表（Agenda View）。我经常将这张表打印出来，用荧光笔涂掉安成的项目，并将其随身携带。为了生成它，我有以下的设定。

;; ("D" "Daily Action List"
;;      (
;;           (agenda "" ((org-agenda-ndays 1)
;;                       (org-agenda-sorting-strategy
;;                       (quote ((agenda time-up priority-down tag-up) )))
;;                       (org-deadline-warning-days 0)
;;                      ))))



;; 预计一天的工作

;; 我知道我该做什么，那些能做好，完成所有的任务需要多少时间。使用Org-mode提供的功能，预计每项任务需要多少时间。通过下面的设置，我可以预见任务所需要的时间。

;; #+PROPERTY: Effort_ALL 0 0:10 0:20 0:30 1:00 2:00 4:00 6:00 8:00
;; 需要花好几天的任务，比如开完一本书，我可以预计我今天花多久来执行。比方说今天的重要任务我分配了4个小时。

;; 预计任务时间的最基本方法是使用Column视图。执行「C-c C-x C-c」命令切换到这个视图.



;; 如果想修改预计的时间值，可以使用「shift-Left arrow」或者「shift-Right arrow」键来更改，改变的值就是刚才在「EffortALL」属性中设置的值。

;; 方便起见，使用数字来代替时间选择。像下面的设定：

;; #+PROPERTY: Effort_ALL 0 0:10 0:20 0:30 1:00 2:00 3:00 4:00 8:00
;; Short cut  ------>     1   2    3    4    5    6   7    8    9
;; 这一天的总时间会在日程表的最上方表示出来。


;; 当天的工作

;; 为了记录工作的时间，我使用了Clock模式。通过它，我可以比较预计的时间和实际花费的时间，从而掌握任务的进度。比如我可以知道某一任务（缴纳账单）比预计的时间短，而另一件需要追加时间。

;; 我准备开始执行任务的时候，首先在日程表中将光标移动到当前任务的所在行，使用 “I” 命令启动时钟。通过Emacs的画面我就可以知道任务的开始时间。这能帮助我了解现在正在做什么，并掌握在什么时间做什么工作。

;; 当完成了任务，我会使用「C-c C-x C-o」或者在日程表画面中点击「0」停止时钟。日程表中会显示任务的累计耗时。

;; 另外通过「l」命令，可以浏览已经完成的任务列表。从中可以掌握一天中我怎样分配时间，任务。




;; 周回顾

;; 周回顾是GTD的工作流中不可缺少的一部分，通过回顾没有完成的任务/项目，保持自己的GTD系统时刻处于最新状态。我专门为周回顾制作了单独的文件（weekly_review.org），作为任务执行列表来使用。

;; 为了使自己不要忘记了周回顾，我在日历中重复的登录了该项目。像下面的设置，将周回顾的文件链接添加到主文件中，并记录每次周回顾的开始/结束时间。

;; #+STARTUP: showall
;; * TODO Review Weekly                                                    :HOME:
;;   SCHEDULED: <2009-01-16 Fri +1w>
;; - State "DONE"       [2009-01-10 Sat 21:46]
;;   CLOCK: [2009-01-10 Sat 20:37]--[2009-01-10 Sat 21:44] =>  1:07
;;   :PROPERTIES:
;;   :Effort:   1:00
;;   :END:
;;  [[file:weekly_review.org][Open Weekly Review Checklist]]





;; 转接（Refiling）

;; 在周回顾中，回顾“将来/也许”（Someday/Maybe）列表中的想法和任务，如果需要将其更改为需要执行的项目。这样的项目需要从「Someday」文件中转移到「active」文件。同样有时候也需要将项目由「active」文件转移到「someday」文件。

;; 「Someday.org」文件有两层分类：

;; #+STARTUP: showall
;; * Someday
;; ** Books to Read
;; ** Films to Watch
;; ** Things to Do
;; ** Things to Learn
;; ** New Projects
;; 这里可以使用Refiling功能。使用「C-c C-w」file 就可以将现在标题所在的项目移动到新的地方。重新读取不同位置的参数是「org-refile-targets」，你可以像下面这样设置。

;; '(org-refile-targets (quote (("newgtd.org" :maxlevel . 1)
;;                              ("someday.org" :level . 2))))
;; 通过这样的设定，可以表示出「someday.org」文件中第二阶层的标题和「newgtd.org」文件中第一阶层的标题。

;; 使用「C-c C-w」命令可以显示出文件名和标题。下面的图表示我将读书的任务移动到「newgtd.org」文件的Task段中的例子。







;; 记笔记

;; 在一天直接我会使用Remember-mode来记录笔记或者是创意。在工作中我会用「privnotes.org」文件，而在家我使用「journal.org」文件。我的「journal.org」文件中的标题如下所示：

;; #+STARTUP: overview
;; #+TAGS: DIARY(d) READING(r) FILMS(f)
;; #+TAGS: IDEAS(i) WEIGHT(w) CONTACTS(a) PYTHON(y)

;; * December 2008
;; * January 2009
;; 我每个月用第一阶层标题表示，用两个星（*）表示每天的标题。通过这样来管理每个月的笔记。给各种各样的Remember-mode的模板附上适当的标签，我可以立刻查询想看的电影，书籍，或者是管理减肥的记录。





;; 同步家中和公司的「org-mode」文件

;; 我需要在家和公司访问「newgtd.org」文件。为了方便起见，在家中的电脑和公司的电脑上都是成了专门的目录，并用优盘来同步它们，同时使用Python的脚本程序。

;; 在桌面上生成了名为「GTD Backup」的快捷方式，指向Python脚本程序，其有简单的菜单可以选择。

;; GTD directory is  C:/charles/GTD/
;; USB directory is  e:/GTD/

;; ----------------------------------
;; 1. Copy files from USB to disk
;; 2. Copy files from disk to USB
;; 3. Backup USB directory
;; 4. Backup Disk directory
;; Q. Quit
;; ----------------------------------
;; What is your choice:
;; 该脚本使用预先设定好的目录和文件，对其进行拷贝，并用zip压缩备份。程序中有一项非常重要的逻辑部分，就是防止你用旧的版本覆盖新的版本内容。

;; TOP加深阅读

;; David Allen 网站上关于GTD的文章
;; Charles Cave的 NaturalProjectPlanning
;; Charles Cave的 RememberModeTutorial
;; "Using Org-mode as a Day Planner"－ John Wiegley的博客
;; 我的.emacs文件
;; 我修整过的newgtd.org文件
;; Org-mode相关的引述
;; Author: Charles Cave < charlesweb@optusnet.com.au >

;; Date: January 2009

;; HTML generated by org-mode 6.17c in emacs 22

;; 1. Agenda view 就是要把你的数据，按时间来排列分割，然后展示给你看的。在你打开Emacs的任何时候，可以用(C-c a a)来打开agenda view。

;; 2. 本文中关于Org-mode例子中为了显示全部的代码，使用了 #+STARTUP: showall 属性。实际使用中不是每部分代码都需要的，只是在设置段落中出现。




;; David Allen的第二部著作「Ready for Anything 中文翻译本《结果第一：平衡工作和生活的52条原则》」。戴维从一个更宽泛的角度来看待工作与生活的平衡问题，不只是局限于GTD。

;; 使用GTD，将你现在所想到的，计划到的完全用目录表格的形式记录起来，并通过一系列系统的方法整理，回顾做成的内容。在你的工作和生活中，任何时候都可以以不同的级别来查询/浏览下一步该做什么。
