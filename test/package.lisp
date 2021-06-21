(uiop:define-package :format-string-reader/test/package
  (:nicknames :format-string-reader/test)
  (:use :named-readtables :format-string-reader/package :fiveam :cl)
  (:export #:format-string-reader-tests))
(in-package :format-string-reader/test/package)

(def-suite format-string-reader-tests)

(defmacro define-test (name &body body)
  `(def-test ,name (:suite format-string-reader-tests)
     ,@body))

(defun read-as-cl-string (string)
  (let* ((as-string-lit (prin1-to-string string)))
    (read-from-string as-string-lit)))

(defun read-as-format-string (string)
  (let* ((as-format-lit (format nil "#\"~a\"" string))
         (*readtable* (find-readtable 'format-string-readtable)))
    (read-from-string as-format-lit)))

(define-test equiv-without-format
  (for-all ((string (gen-string)))
    (let* ((without-tildes (substitute #\- #\~ string))
           (cl (read-as-cl-string without-tildes))
           (format (read-as-format-string without-tildes)))
      (is (string= without-tildes cl))
      (is (string= without-tildes format))
      (is (string= cl format)))))

(define-test format-newline
  (is (string= "abcdef"
               (read-as-format-string "abc~
def")))
  (is (string= "abcdef"
               (read-as-format-string "abc~
                                       def"))))

(define-test tilde-tilde
  (is (string= "abc~def"
               (read-as-format-string "abc~~def"))))

(define-test tilde-ampersand-percent
  (is (string= ""
               (read-as-format-string "~&")))
  (is (string= "abc
def"
               (read-as-format-string "abc~&def")))
  (is (string= "abc
def"
               (read-as-format-string "abc~%~&def"))))
