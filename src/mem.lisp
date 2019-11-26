;;; -*- mode: lisp -*-

(in-package #:cl-procps)

(defparameter PROC-MEMINFO "/proc/meminfo")

(defun unit-to-multiplier (unit-string)
  (cond
    ((null unit-string) 1)
    ((string= "kB" unit-string) 1024)
    (t (error "Unknown unit ~a" unit-string))))

(defun parse-meminfo-line (line)
  (let* ((parts (split-sequence #\Space line :remove-empty-subseqs t))
         (multiplier (unit-to-multiplier (nth 2 parts)))
         (name-kw (intern
                   (string-upcase
                    (substitute #\. #\(
                                (substitute #\. #\)
                                            (let ((name (car parts)))
                                              (subseq name 0 (- (length name) 1))))))
                   :keyword))
         (value (parse-integer (car (cdr parts)))))
    (cons name-kw (* value multiplier))))

(defun meminfo ()
  (with-open-file (s PROC-MEMINFO)
    (loop for memline = (read-line s nil nil)
          while memline
          collect (parse-meminfo-line memline))))
