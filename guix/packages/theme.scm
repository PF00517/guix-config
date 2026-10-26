(define-module (guix packages theme)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages web)
  #:use-module (ice-9 optargs))

(define*-public (tela-circle-icon-theme #:optional variant)
  (let ((variant (if variant variant "standard")))
    (package
     (name (string-append "tela-circle-icon-theme"
                          (if (equal? (string-downcase variant) "standard")
                              ""
                              (string-append "-" (string-downcase variant)))))
     (version "2026-07-07")
     (source
      (origin
       (uri (git-reference
             (url "https://github.com/vinceliuice/Tela-circle-icon-theme")
             (commit version)))
       (method git-fetch)
       (file-name (git-file-name "tela-circle-icon-theme" version))
       (sha256
        (base32 "18bckv8z6nbcdm6bj638l7b09vsikm7anni7d76c4gn118phmznh"))))
     (build-system gnu-build-system)
     (arguments
      (list
       #:tests? #f
       #:phases
       #~(modify-phases %standard-phases
                        (delete 'configure)
                        (replace 'build
                                 (lambda _
                                   (substitute* "install.sh"
                                                (("gtk-update-icon-cache.*") ""))
                                   (apply invoke "./install.sh"
                                          "-d" "dist/icons"
                                          (if (equal? (string-downcase #$variant) "standard")
                                              '()
                                              `("-c" ,(string-downcase #$variant))))))
                        (replace 'install
                                 (lambda _
                                   (mkdir-p (string-append #$output "/share"))
                                   (copy-recursively "dist" (string-append #$output "/share")))))))
     (home-page "https://www.gnome-look.org/p/1359276/")
     (synopsis "Flat and colorful icons")
     (description
      "Tela Circle Icon Theme is a set of flat and colorful icons.")
     (license license:gpl3+))))
