;; I use this code to let flymake-mode work with my php modules, on Windows.

(defvar phpwin-php.exe-location "d:\\xampp\\php\\php.exe"
  "Location for the PHP.exe executable on windows.")

(defun phpwin-flymake-create-temp-intemp (file-name prefix)
  "Return file name in temporary directory for checking FILE-NAME.
    This is a replacement for `flymake-create-temp-inplace'. The
    difference is that it gives a file name in
    `temporary-file-directory' instead of the same directory as
    FILE-NAME.

    For the use of PREFIX see that function.

    This won't always work; it will fail if the source module
    refers to relative paths.
    "
  (unless (stringp file-name)
    (error "Invalid file-name"))
  (or prefix
      (setq prefix "flymake"))
  (let* ((name (concat
                (file-name-nondirectory
                 (file-name-sans-extension file-name))
                "_" prefix))
         (ext  (concat "." (file-name-extension file-name)))
         (temp-name (make-temp-file name nil ext))
         )
    (flymake-log 3 "create-temp-intemp: file=%s temp=%s" file-name temp-name)
    temp-name))


(defun phpwin-flymake-get-cmdline  (source base-dir)
  "Gets the cmd line for running a flymake session in a PHP buffer.
    This gets called by flymake itself."
  (list phpwin-php.exe-location (list "-f" source  "-l")))


(defun phpwin-flymake-init ()
  "initialize flymake for php"
  (let ((create-temp-f 'phpwin-flymake-create-temp-intemp)
        ;;(create-temp-f 'flymake-create-temp-inplace)
        (use-relative-base-dir t)
        (use-relative-source t)
        (get-cmdline-f 'phpwin-flymake-get-cmdline)
        args
        temp-source-file-name)

    (setq temp-source-file-name (flymake-init-create-temp-buffer-copy create-temp-f)

          args (flymake-get-syntax-check-program-args
                temp-source-file-name "."
                use-relative-base-dir use-relative-source
                get-cmdline-f))
    args))


(defun phpwin-flymake-cleanup () )

(eval-after-load "flymake"
  '(progn

     ;; add an entry for PHP to the flymake-allowed-file-name-masks,
     ;; or modify the existing entry.
     (let* ((key "\\.php\\'")
            (phpentry (assoc key flymake-allowed-file-name-masks)))
       (if phpentry
           (setcdr phpentry '(phpwin-flymake-init phpwin-flymake-cleanup))
         (add-to-list
          'flymake-allowed-file-name-masks
          (list key 'phpwin-flymake-init 'phpwin-flymake-cleanup))))))
