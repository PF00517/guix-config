(define-module (guix home emacs)
  #:use-module (guix packages emacs)
  #:use-module (gnu packages)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu home services)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (guix transformations)
  #:export (home-emacs-config-service-type))

(define (home-emacs-config-profile-service config)
  (list
   emacs-next-pgtk

   emacs-bluetooth

   emacs-ement

   emacs-lua-mode
   emacs-janet-mode

   emacs-pinentry
   pinentry-emacs

   emacs-password-store
   ;; emacs-auth-source-pass

   emacs-xclip

   emacs-org
   emacs-denote
   emacs-consult-notes
   emacs-logos
   emacs-howm

   ripgrep

   emacs-helpful

   emacs-geiser

   emacs-orgalist
   emacs-markdown-mode

   emacs-a

   emacs-eat
   emacs-xterm-color
   emacs-exec-path-from-shell

   emacs-tracking

   emacs-telega
   emacs-jabber

   emacs-guix

   emacs-daemons

   emacs-docker
   emacs-dockerfile-mode))

(define home-emacs-config-service-type
  (service-type (name 'home-emacs-config)
                (description "A service for configuring Emacs.")
                (extensions
                 (list (service-extension
                        home-profile-service-type
                        home-emacs-config-profile-service)))
                (default-value #f)))
