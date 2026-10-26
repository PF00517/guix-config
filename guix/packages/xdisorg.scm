(define-module (guix packages xdisorg)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix build-system gnu)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module ((guix patches) #:prefix guix:)
  #:use-module (guix packages freedesktop)

  #:replace (wl-clipboard))

(define-public fuzzel-lowercase
  (package
   (inherit fuzzel)
   (name "fuzzel-lowercase")
   (version "1.13.1")
   (source
    (let ((fuzzel-origin (package-source fuzzel)))
      (origin
       (uri (git-reference
             (url "https://codeberg.org/dnkl/fuzzel")
             (commit version)))
       (method git-fetch)
       (file-name (git-file-name name version))
       (sha256
        (base32 "07cjm6nj995nwc88n0dq6g7rr80hchs2cqzh4mdbpiysnny8qvi5"))
       (patches (append (origin-patches fuzzel-origin)
                        (parameterize ((%patch-path guix:%patch-path))
                          (search-patches "fuzzel-lowercase.patch")))))))
   (description
    (format #f "~a~%This version provides a consistent display of
                 application names by rendering them all in lowercase."
            (package-description fuzzel)))))

(define-public gammastep-minimal
  (package
   (name "gammastep-minimal")
   (version "2.0.11")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://gitlab.com/chinstrap/gammastep")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0i8042ks83h5hcm0cbwfv9s7lca5nclpfnrg92rqnbf7n506khkk"))))
   (build-system gnu-build-system)
   (native-inputs
    (list autoconf automake gettext-minimal intltool libtool pkg-config))
   (inputs
    (list glib wayland))
   (home-page "https://gitlab.com/chinstrap/gammastep")
   (synopsis "Adjust the color temperature of your screen")
   (description
    "Gammastep automatically adjusts the color temperature of your
screen according to your surroundings.  This may help your eyes hurt
less if you are working in front of the screen at night.")
   (license license:gpl3)))

(define-public wl-clipboard
  ((package-input-rewriting `((,xdg-utils . ,xdg-utils/wayland)))
   (@ (gnu packages xdisorg) wl-clipboard)))
