(defsystem "format-string-reader"
  :class :package-inferred-system
  :version "1.0.0"
  :author "Phoebe Goldman"
  :license "MIT"
  :depends-on ("format-string-reader/package")
  :in-order-to ((test-op (test-op "format-string-reader/test"))))

(defsystem "format-string-reader/test"
  :defsystem-depends-on ((:version "fiveam-asdf" "3"))
  :class :package-inferred-fiveam-tester-system
  :depends-on ("format-string-reader/test/package")
  :test-package :format-string-reader/test/package
  :test-names (#:format-string-reader-tests))
