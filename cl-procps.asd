;;;; -*- mode: lisp -*-

(defsystem :cl-procps
  :name "cl-procps"
  :author "Azamat S. Kalimoulline <turtle@bazon.ru>"
  :licence "Lessor Lisp General Public License"
  :version "0.0.1.1"
  :description "CL procps"
  :depends-on (split-sequence)
  :components ((:module "src"
                        :components
                        ((:file "package")
                         (:file "procps"
                          :depends-on ("package"))
                         (:file "mem"
                          :depends-on ("package"))))))
