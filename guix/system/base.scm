(define-module (guix system base)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system)
  #:use-module (gnu system pam)
  #:use-module (guix gexp)
  #:use-module (ice-9 match)
  #:export (base))

(define symlink-/etc/config.scm-shepherd-service
  (shepherd-service
   (provision '(symlink-/etc/config.scm))
   (requirement '(user-processes host-name))
   (start #~(lambda _
              (let* ((guix "/home/lain/init/guix/")
                     (host-config (string-append guix "system/"
                                                 (gethostname) ".scm")))
                (symlink host-config "/etc/config.scm")
                host-config)))
   (stop #~(lambda _
             (when (file-exists? "/etc/config.scm")
               (delete-file "/etc/config.scm"))))))

(define freetype-properties
  `((cff:no-stem-darkening . 0)
    (cff:darkening-parameters . (500 400 1000 350 1500 325 2000 300))
    (autofitter:no-stem-darkening . 0)
    (autofitter:darkening-parameters . (500 400 1000 350 1500 325 2000 300))))

(define base
  (operating-system
   (host-name "base")
   (file-systems '())
   (bootloader #f)
   (essential-services
    (cons* (simple-service 'symlink-/etc/config.scm
                           shepherd-root-service-type
                           (list symlink-/etc/config.scm-shepherd-service))
           (simple-service 'global-environment-variables
                           session-environment-service-type
                           `(("FREETYPE_PROPERTIES"
                              . ,(string-join
                                   (map (match-lambda
                                          [(var . (? number? val))
                                           (format #f "~a=~a" var val)]
                                          [(var . (? list? val))
                                           (apply format #f "~a=~a~@{,~a~}" var val)])
                                        freetype-properties)))))
           (operating-system-default-essential-services this-operating-system)))))
