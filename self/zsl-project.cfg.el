(zsl-read-project-cfg
 '(project-name . "your-project")
 '(project-dirs . ("/your/project/src1" "/your/project/src2"))
 '(project-file-types . ("c" "h" "cpp" "hpp" "el" "cxx" "cc" "CC" "c++" "hxx"))
 '(common-dir-list . (
					  "/usr/include"
					  "/emacs/emacs-23.3/lisp"
					  "/neo/buildenv"
					  "/usr/local/include"
					  ))
 '(custom-item . ("your value"))
 )

;; custom-item such as "exclude-dir", build, bin, cmake ...