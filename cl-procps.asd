;;;; -*- mode: lisp -*-

(defsystem :cl-procps
  :name "cl-procps"
  :author "Azamat S. Kalimoulline <turtle@bazon.ru>"
  :licence "Lessor Lisp General Public License"
  :version "0.0.1.0"
  :description "CL procps"
  :depends-on ()
  :components ((:module "src"
                        :components
                        ((:file "package")
                         (:file "procps" :depends-on ("package"))))))
