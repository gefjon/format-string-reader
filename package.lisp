(uiop:define-package :format-string-reader/package
  (:nicknames :format-string-reader)
  (:use :named-readtables :cl :iterate)
  (:export :read-format-string :format-string-readtable))
(in-package :format-string-reader/package)

(defparameter *delimiters* '((#\[ . #\])
                             (#\{ . #\})
                             (#\< . #\>)
                             (#\( . #\))))

(defun read-string (stream open-delim)
  (macrolet ((getchar () `(read-char stream t nil t))
             (gather (char) `(collect ,char result-type string)))
    (iter (with terminator = (or (cdr (assoc open-delim *delimiters*))
                                 open-delim))
      (for char = (getchar))
      (cond ((char= char #\\) (gather (getchar)))
            ((char= char terminator) (finish))
            (:otherwise (gather char))))))

(defun read-format-string (stream subchar arg)
  (assert (not arg) ()
          "`read-format-string' doesn't know how to handle an infix arg!")
  (format nil (read-string stream subchar)))

(defreadtable format-string-readtable
  (:merge :standard)
  (:dispatch-macro-char #\# #\" #'read-format-string))
