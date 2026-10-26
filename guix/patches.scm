(define-module (guix patches)
  #:use-module (gnu packages)
  #:export (%patch-path))

(define %patch-path
  (and=> (search-path %load-path "guix/patches.scm")
         (lambda (dir)
           (list (string-append (dirname dir)
                                "/packages/patches")))))
