(define-module (guix packages freedesktop)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages freedesktop)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix gexp))

(define-public xdg-desktop-portal-minimal
  (package/inherit xdg-desktop-portal
    (name "xdg-desktop-portal-minimal")
    (source
     (origin
      (inherit (package-source xdg-desktop-portal))))
    (inputs
     (modify-inputs inputs
       (delete "geoclue")
       (replace "pipewire" pipewire-minimal)))
    (arguments
     (substitute-keyword-arguments arguments
       ((#:configure-flags flags #~'())
        #~(cons* "-Dgeoclue=disabled" #$flags))
       ((#:phases phases #~%standard-phases)
        #~(modify-phases #$phases
            (add-after 'unpack 'disable-location-tests
              (lambda _
                (substitute* "tests/test_location.py"
                  (("class TestLocation:" line)
                   (string-append
                    "@pytest.mark.skip(reason=\"geoclue disabled\")\n"
                    line)))))))))))

(define-public xdg-utils/wayland
  (package/inherit xdg-utils
    (name "xdg-utils-wayland")
    (inputs (modify-inputs (package-inputs xdg-utils)
              (delete "xprop")
              (delete "xset")))
    (arguments
      (substitute-keyword-arguments (package-arguments xdg-utils)
        ((#:phases phases #~%standard-phases)
         #~(modify-phases #$phases
             (replace 'wrap-executables
               (lambda* (#:key inputs outputs #:allow-other-keys)
                 (let* ((dependencies
                         '("awk" "grep" "hostname" "ls" "mimeopen" "sed"))
                        (pkgs (map (lambda (cmd)
                                     (search-input-file inputs
                                                        (string-append "bin/" cmd)))
                                   dependencies))
                        (bindirs (map dirname pkgs)))
                   (with-directory-excursion (string-append #$output "/bin")
                     (for-each (cute wrap-program <>
                                     `("PATH" ":" prefix ,bindirs))
                               (find-files "."))))))))))))

(define-public xdg-desktop-portal-wlr-minimal
  (package/inherit xdg-desktop-portal-wlr
    (name "xdg-desktop-portal-wlr-minimal")
    (inputs (modify-inputs (package-inputs xdg-desktop-portal-wlr)
              (replace "elogind" basu)))
    (arguments
     (substitute-keyword-arguments (package-arguments xdg-desktop-portal-wlr)
       ((#:configure-flags _)
        #~'("-Dsystemd=disabled"
            "-Dsd-bus-provider=basu"))))))
