(define-module (guix packages wm)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system zig)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages zig)
  #:use-module (gnu packages zig-xyz)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xdisorg)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp))

(define zig-wayland-0.4
  (package/inherit zig-wayland
                   (name "zig-wayland")
                   (version "0.4.0")
                   (source
                    (origin
                     (uri (git-reference
                           (url "https://codeberg.org/ifreund/zig-wayland")
                           (commit (string-append "v" version))))
                     (method git-fetch)
                     (file-name (git-file-name name version))
                     (sha256
                      (base32
                       "0kkmg2gxb03xjrsd4kzxwvchxlcj3mvx0hajzpbcz949k0ihhlms"))))
                   (arguments
                    (substitute-keyword-arguments (package-arguments zig-wayland)
                                                  ((#:zig _ #f) zig-0.15)))))

(define-public libseat-minimal
  (package/inherit libseat
    (name "libseat-minimal")
    (arguments
     (substitute-keyword-arguments (package-arguments libseat)
       ((#:configure-flags _) #~(list "-Dserver=disabled"))))
    (propagated-inputs
     (modify-inputs (package-propagated-inputs libseat)
       (delete "elogind")))))

(define-public zig-mvzr
  (package
    (name "zig-mvzr")
    (version "0.3.12")
    (source
     (origin
       (uri (git-reference
             (url "https://github.com/mnemnion/mvzr")
             (commit "v0.3.12")))
       (method git-fetch)
       (file-name (git-file-name name version))
       (sha256
        (base32 "0iivg8x6rlww0i9gigvyhlg94crrccwbki4wqj9kvwkhv9iyqpdb"))))
    (build-system zig-build-system)
    (arguments
     (list #:zig zig-0.16
           #:skip-build? #t))
    (home-page "https://github.com/mnemnion/mvzr")
    (synopsis "Zig parsing library")
    (description "Source-only Zig parsing library.")
    (license license:expat)))

(define-public kwm
  (package
   (name "kwm")
   (version "0.3.0")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/kewuaa/kwm")
           (commit "ee81d6e352250a0e97d31cc0e93870416aa6c479")))
     (method git-fetch)
     (file-name (git-file-name name version))
     (sha256
      (base32 "1gdm9kdhinhrp6sqm43ws0jpykp8z6gmpw0wxp9zsamfb4zkbsqd"))))
   (build-system zig-build-system)
   (arguments
    (list #:zig zig-0.16
          #:tests? #f
          #:install-source? #f
          #:zig-release-type "safe"
          #:zig-build-flags
          #~(list "-Dbar=false"
                  "-Dkwim=false"
                  ;; "-Dllvm" ;; idk
                  )
          #:phases
          #~(modify-phases %standard-phases
                           (add-before 'unpack-dependencies 'rename-zig-dependencies
                                       (lambda _
                                         (substitute* "build.zig.zon"
                                                      (("\\.xkbcommon") ".@\"zig-xkbcommon\"")
                                                      (("\\.wayland") ".@\"zig-wayland\"")
                                                      (("\\.mvzr") ".@\"zig-mvzr\""))))
                           (add-after 'unpack-dependencies 'restore-zig-dependencies
                                      (lambda _
                                        (substitute* "build.zig.zon"
                                                     (("\\.@\"zig-xkbcommon\"") ".xkbcommon")
                                                     (("\\.@\"zig-wayland\"") ".wayland")
                                                     (("\\.@\"zig-mvzr\"") ".mvzr"))))
                           (add-after 'restore-zig-dependencies 'fix-keysym-comparison
                                      (lambda _
                                        (substitute* "src/kwm/seat.zig"
                                                     (("Keysym\\.XF86Screensaver")
                                                      "@intFromEnum(Keysym.XF86Screensaver)")
                                                     (("return Keysym\\.XF86ScreenSaver;")
                                                      "return @intFromEnum(Keysym.XF86ScreenSaver);")))))))
   (inputs
    (list zig-xkbcommon
          zig-wayland
          zig-mvzr))
   (native-inputs
    (list pkg-config
          wayland-protocols))
   (home-page "https://github.com/kewuaa/kwm")
   (synopsis "A window manager based on River Wayland compositor.")
   (description "River is a non-monolithic Wayland compositor, it does not combine the compositor and window manager into one program.
kwm is a DWM-like dynamic tiling window manager implementing the river-window-management-v1 protocol.")
   (license license:gpl3+)))

(define-public rivercarro
  (package
   (name "rivercarro")
   (version "0.6.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://git.sr.ht/~novakane/rivercarro")
           (commit (string-append "v" version))
           (recursive? #t)))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0xfil2adsja2n8mrr65h4kzjrj1mw2hs71a7b17ly55i8d0fsrgc"))))
   (build-system zig-build-system)
   (arguments
    (list #:zig zig-0.15
          #:tests? #f
          #:install-source? #f
          #:zig-release-type "safe"
          #:phases #~(modify-phases %standard-phases
                       (delete 'validate-runpath)
                       (add-after 'install 'install-documentation
                         (lambda* (#:key inputs outputs #:allow-other-keys)
                           (let* ((out (assoc-ref outputs "out"))
                                  (man (string-append out "/share/man/man1")))
                             (install-file "doc/rivercarro.1" man)))))))
   (native-inputs
    (list pkg-config
          zig-wayland-0.4))
   (home-page "https://git.sr.ht/~novakane/rivercarro")
   (synopsis "A slightly modified version of rivertile layout generator for river")
   (description
    "A modified version of rivertile which adds: monocle layout, gaps rather
than padding, gap size modification at run time, and smart gaps.")
   (license license:gpl3+)))

(define-public river-bedload
  (package
   (name "river-bedload")
   (version "0.2.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://git.sr.ht/~novakane/river-bedload")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0byxr81vswid4jgxgvmx1q52k9jjzw32chkg99d0pz4lp6xn7rih"))))
   (build-system zig-build-system)
   (arguments
    (list #:tests? #f
          #:install-source? #f
          #:zig zig-0.15
          #:zig-release-type "safe"
          #:phases
          #~(modify-phases %standard-phases
                           (add-after 'unpack 'fix-build.zig.zon
                                      (lambda* (#:key inputs #:allow-other-keys)
                                        (substitute* "build.zig.zon"
                                                     (("https://.*.tar.gz")
                                                      (assoc-ref inputs "zig-wayland"))))))))
   (inputs
    (list pkg-config
          wayland
          wayland-protocols
          zig-wayland-0.4))
   (home-page "https://git.sr.ht/~novakane/river-bedload")
   (synopsis "Display information about river in json in the STDOUT.")
   (description "Display information about river in json in the STDOUT.")
   (license license:gpl3)))

(define-public river-minimal
  ((package-input-rewriting
     `((,libseat . ,libseat-minimal)))
   (@ (gnu packages zig-xyz) river-classic)))
