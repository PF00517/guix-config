(define-module (guix packages linux)
  #:use-module (gnu packages linux)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix services pm)
  #:use-module (guix gexp))

(define-public thinkfan-next
  (package
   (inherit thinkfan)
   (arguments
    (substitute-keyword-arguments (package-arguments thinkfan)
     ((#:phases phases #~%standard-phases)
      #~(modify-phases #$phases
         (replace 'create-init-scripts
          (lambda _
            (substitute* "CMakeLists.txt"
              (("/etc") (string-append #$output "/etc")))))))))))
