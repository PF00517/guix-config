(define-module (guix services pm)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services configuration)
  #:use-module (gnu packages linux)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:export (thinkfan-configuration
            thinkfan-service-type))

(define (string-or-file-like? x)
  (or (string? x)
      (file-like? x)))

(define-configuration/no-serialization thinkfan-configuration
  (thinkfan
   (package thinkfan)
   "Thinkfan package to be used.")
  (auto-start?
   (boolean #t)
   "Whether thinkfan should be started automatically or not.")
  (pid-file
   (string "/var/run/thinkfan.pid")
   "Where to store the PID file.")
  (config-file
   (string-or-file-like "/etc/thinkfan.conf")
   "Configuration file to use.")
  (log-file
   (string "/var/log/thinkfan.log")
   "File where ‘thinkfan’ writes its log to.")
  (extra-options
   (list-of-strings '())
   "This option provides an “escape hatch” for the user to provide
arbitrary command-line arguments to ‘thinkfan’ as a list of strings."))

(define thinkfan-shepherd-service
  (match-record-lambda <thinkfan-configuration>
                       (thinkfan auto-start? pid-file config-file log-file extra-options)
                       (list (shepherd-service
                              (provision '(thinkfan))
                              (auto-start? auto-start?)
                              (documentation
                               "Adjust fan level according to configured temperature limits.")
                              (requirement '(user-processes))
                              (start #~(make-forkexec-constructor
                                        (list (string-append #$thinkfan "/sbin/thinkfan")
                                              #$@extra-options
                                              "-c" #$config-file)
                                        #:log-file #$log-file
                                        #:pid-file #$pid-file))
                              (stop #~(make-kill-destructor))
                              (respawn? #t)))))

(define thinkfan-modprobe-config
  (plain-file "thinkfan.conf"
              "options thinkpad_acpi experimental=1 fan_control=1"))

(define (thinkfan-modprobe-etc-service config)
  `(("modprobe.d/thinkfan.conf" ,thinkfan-modprobe-config)))

(define thinkfan-service-type
  (service-type
   (name 'thinkfan)
   (extensions
    (list (service-extension shepherd-root-service-type
                             thinkfan-shepherd-service)
          (service-extension etc-service-type
                             thinkfan-modprobe-etc-service)))
   (default-value (thinkfan-configuration))
   (description
    "Adjust fan level according to configured temperature limits.")))
