;; asynchronous process
;; emacs 后台异步运行一个程序的方法：
;; 1 start-process 启动一个异步子进程
;; 2 process sentinel: 收到子进程结束的消息，再启动下一个子进程
;; 3 接手输出，避免超限。

;; eg. 每秒输出一次时间; 其他任务都可以模仿这个过程，大多只需重写 zsl-async-worker 函数即可。
;; zsl-async-worker 启动异步工作，完成后调用下一个异步工作。实现单线程异步处理。

(defvar zsl-worker-have-task t)
(setq zsl-worker-have-task t)
(setq zsl-worker-times 0)

(defun zsl-worker-filter (process output)
  ;; (princ (format "--%s:%s--" process output))
  (setq zsl-worker-output output)
  )

;; finished or exited , substring-no-properties(s, 0, 6)
(defun zsl-worker-sentinel (process event)
  ;; (princ (format "Process: %s had the event `%s'" process event))
  (when (or (compare-strings event 0 8 "finished" 0 8)
			(compare-strings event 0 6 "exited" 0 6))
	(zsl-async-waiter))
  )

(defun zsl-waiter-filter (process output)
  (princ (format "%s:%s" process output))
  )

(defun zsl-waiter-sentinel (process event)
  ;; (message "Process: %s had the event `%s'" process event)
  (when (and zsl-worker-have-task (string= event "finished\n"))
	(zsl-async-worker))
  )

(defun zsl-async-worker ()
  (let ((worker (start-process "async-do-something" "*datetime*" "date" "+%F %T"))
		)
	(set-process-filter worker 'zsl-worker-filter)
	(set-process-sentinel worker 'zsl-worker-sentinel)
	(setq zsl-worker-times (1+ zsl-worker-times))
	(message "%d:`%s'" zsl-worker-times zsl-worker-output)

	(when (> zsl-worker-times 10) (setq zsl-worker-have-task nil))
	)
  )

(defsubst zsl-async-waiter ()
  (let ((waiter  (start-process "async-waitting" "*asyc waiter*" "sleep" "3"))
		)
	(set-process-filter waiter 'zsl-waiter-filter)
	(set-process-sentinel waiter 'zsl-waiter-sentinel)
	)
  )

;; (zsl-async-worker)
