(define-module (guix home home)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (gnu home services sound)
  #:use-module (guix home video)
  #:use-module (guix home config))

(home-environment
 (services (cons* (service home-pipewire-service-type
                           (home-pipewire-configuration
                            (wireplumber (@ (gnu packages linux) wireplumber-minimal))))
                  (service home-video-service-type)
                  config-home-services)))
