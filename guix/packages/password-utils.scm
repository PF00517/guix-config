(define-module (guix packages password-utils)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (gnu packages password-utils)
  #:use-module (guix packages xdisorg)
  #:use-module (guix packages freedesktop))

(define-public password-store-minimal/wayland
  (package/inherit password-store
    (name "password-store-minimal-wayland")
    (inputs
     (modify-inputs (package-inputs password-store)
       (delete "dmenu")
       (delete "xclip")
       (delete "xdotool")
       (replace "wl-clipboard" wl-clipboard)))
    (arguments
     (substitute-keyword-arguments (package-arguments password-store)
       ((#:phases phases #~%standard-phases)
        #~(modify-phases #$phases
            (delete 'patch-passmenu-path)
            (delete 'install-passmenu)
             (replace 'wrap-path
               (lambda* (#:key inputs #:allow-other-keys)
                 (let* ((requisites '("getopt" "git" "gpg" "qrencode" "sed"
                                      "tail" "tree" "which" "wl-copy"))
                        (path
                         (map (lambda (pkg)
                                (dirname (search-input-file
                                          inputs (string-append "/bin/" pkg))))
                              requisites)))
                   (wrap-program (string-append #$output "/bin/pass")
                     `("PATH" ":" prefix (,(string-join path ":")))))))))))))

(define-public tessen/wayland
  (package/inherit tessen
    (name "tessen-wayland")
    (inputs
     (modify-inputs (package-inputs tessen)
       (replace "xdg-utils" xdg-utils/wayland)
       (replace "wl-clipboard" wl-clipboard)))))
