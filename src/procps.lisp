;;; -*- mode: lisp -*-

(in-package #:cl-procps)

(defparameter proc-dir "/proc/*")

(defclass process ()
  ((pid
    :type integer
    :initarg :pid)
   (cmdline
    :type list
    :initarg :cmdline)))

(defmethod print-object ((process process) stream)
  (with-slots (pid cmdline)
      process
    (format stream "#<PROCESS pid: ~a, cmdline: ~a>" pid cmdline)))

(defun pathname-last (pathname)
  (let ((components (pathname-directory pathname)))
    (first (last components))))

(defun only-digits-p (string)
  (= (length string)
     (loop for c across string
        while (digit-char-p c)
        count 1)))

(defun process-dir-p (pathname)
  (only-digits-p (pathname-last pathname)))

(defun processes-dirs ()
  (remove-if-not
   #'process-dir-p
   (directory proc-dir)))

(defun read-cmdline (process-path)
  (let ((cmdline (merge-pathnames process-path "/cmdline")))
    (with-open-file (stream cmdline)
      (loop
         with current-word = '()
         for char = (read-char stream nil)
         until (eq char nil)
         if (eq char #\Nul)
         collect (map 'string #'identity (reverse current-word))
         and do (setf current-word '())
         else
         do (setf current-word (cons char current-word))))))

(defun create-process (process-path)
  (make-instance 'process
                 :pid (parse-integer (pathname-last process-path))
                 :cmdline (read-cmdline process-path)))

(defun processes ()
  (let ((proc-paths (processes-dirs)))
    (mapcar #'create-process proc-paths)))
