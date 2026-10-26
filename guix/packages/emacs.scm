(define-module (guix packages emacs)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (guix build-system emacs)
  #:use-module (guix build utils)
  #:use-module ((guix licenses) #:prefix license:))

(define-public emacs-unicode-fonts
  (package
   (name "emacs-unicode-fonts")
   (version "20260202.1156")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/rolandwalker/unicode-fonts")
           (commit "d4a0648a2206d9a896433817110957b3b9e1c17a")))
     (method git-fetch)
     (sha256
      (base32 "14xplcx1miq1qbpkxb5rijqk5qpn464kd2v4j85sqxdyf4a047ls"))))
   (build-system emacs-build-system)
   (arguments `(#:tests? #f))
   (propagated-inputs
    (list emacs-font-utils
          emacs-ucs-utils
          emacs-list-utils
          emacs-persistent-soft
          emacs-pcache))
   (home-page "http://github.com/rolandwalker/unicode-fonts")
   (synopsis "Configure Unicode fonts")
   (description "Emacs maintains font mappings on a per-glyph basis, meaning that multiple fonts are used at the same time (transparently) to display any character for which you have a font. Furthermore, Emacs does this out of the box.")
   (license license:gpl3+)))

(define-public emacs-ucs-utils
  (package
   (name "emacs-ucs-utils")
   (version "20230119.2237")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/rolandwalker/ucs-utils")
           (commit "91b9e0207fff5883383fd39c45ad5522e9b90e65")))
     (method git-fetch)
     (sha256
      (base32 "18yqzy8w4icp60z25ckbrx6wradm3m26vic35kmzr88msc0qdsva"))))
   (build-system emacs-build-system)
   (arguments `(#:tests? #f))
   (propagated-inputs
    (list emacs-persistent-soft emacs-pcache emacs-list-utils))
   (home-page "http://github.com/rolandwalker/ucs-utils")
   (synopsis "Utilities for Unicode characters")
   (description "This library provides utilities for manipulating Unicode characters, with integrated ability to return fallback characters when Unicode display is not possible.")
   (license #f)))

(define-public emacs-font-utils
  (package
   (name "emacs-font-utils")
   (version "20210405.1149")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/rolandwalker/font-utils")
           (commit "abc572eb0dc30a26584c0058c3fe6c7273a10003")))
     (method git-fetch)
     (sha256
      (base32 "0hx3k2zx2kdavivr1b957jq7kcwk301yzw77aprxzbs7jz73a35x"))))
   (build-system emacs-build-system)
   (arguments `(#:tests? #f))
   (propagated-inputs (list emacs-persistent-soft emacs-pcache))
   (home-page "http://github.com/rolandwalker/font-utils")
   (synopsis "Utility functions for working with fonts")
   (description "Font-utils is a collection of functions for working with fonts. This library has no user-level interface; it is only useful for programming in Emacs Lisp.")
   (license #f)))

(define-public emacs-pcache
  (package
   (name "emacs-pcache")
   (version "20260728.1657")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/sigma/pcache")
           (commit "17d785afa4532043afa8b2dc9ae3d9733528e758")))
     (method git-fetch)
     (sha256
      (base32 "1aj3syq039lz4z647i41gnhpbgsr3xlzinp4ax5bd8fbp7hv335a"))
     (file-name (git-file-name name version))))
   (build-system emacs-build-system)
   (arguments `(#:tests? #f))
   (home-page "https://github.com/sigma/pcache")
   (synopsis "Persistent caching for Emacs")
   (description
    "Pcache provides a persistent way of caching data, in a hashtable-like structure. It relies on `eieio-persistent' in the backend")
   (license #f)))

(define-public emacs-persistent-soft
  (package
   (name "emacs-persistent-soft")
   (version "20260202.1154")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/rolandwalker/persistent-soft")
           (commit "c94b34332529df573bad8a97f70f5a35d5da7333")))
     (method git-fetch)
     (sha256
      (base32 "057wk7ai3l1anhxxlgvqgsl3r2rjyivwi8mi5swsidc9qgzwczvf"))))
   (build-system emacs-build-system)
   (arguments `(#:tests? #f))
   (propagated-inputs (list emacs-pcache emacs-list-utils))
   (home-page "https://github.com/rolandwalker/persistent-soft")
   (synopsis "Persistent storage, returning nil on failure")
   (description
    "This is a wrapper around pcache.el, providing \"soft\" fetch and store routines which never throw an error, but instead return nil on failure.")
   (license license:gpl3+)))

(define-public emacs-all-the-icons-nerd-fonts
  (package
   (name "emacs-all-the-icons-nerd-fonts")
   (version "20260614.1246")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/mohkale/all-the-icons-nerd-fonts")
           (commit "4583cf5e8cce73c35e8ec3195915ce693d703bb1")))
     (method git-fetch)
     (sha256
      (base32 "0lc770zw5v3k97mi39ppkgag3p9i49wwxrmycw1n9264xpjvqcjk"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-all-the-icons emacs-nerd-icons))
   (home-page "https://github.com/mohkale/all-the-icons-nerd-fonts")
   (synopsis "Nerd font integration for all-the-icons-nerd-fonts")
   (description
    "A bridge between all-the-icons and nerd-icons")
   (license license:gpl3+)))

(define-public emacs-fic-mode
  (package
   (name "emacs-fic-mode")
   (version "20180603.2035")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/lewang/fic-mode")
           (commit "a05fc36ed54ba0c6dc22ac216a6a72cf191ca13d")))
     (method git-fetch)
     (sha256
      (base32 "074dfwdir2dx5cpbjk1ac8d3hkjkrylivy7agir5mnmzjm3bs9gw"))
     ; (file-name (git-file-name name version))
     ))
   (build-system emacs-build-system)
   (home-page "https://github.com/lewang/fic-mode")
   (synopsis "Show color-coded FIXME/TODO/HACK in source code")
   (description
    "fic-mode highlights FIXME, TODO, HACK, and similar keywords in source code with configurable colors.")
   (license license:gpl3+)))

(define-public emacs-flycheck-posframe
  (package
   (name "emacs-flycheck-posframe")
   (version "20260409.14")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/alexmurray/flycheck-posframe.git")
           (commit "aeccb14e90ba25f45e1919b776777fc6ec95e251")))
     (method git-fetch)
     (sha256
      (base32 "1sqxwsy3pk0k48aiii9igqgjj7kg1sbpxr6ayhqzgps2k3wnl5v7"))))
   (build-system emacs-build-system)
   (propagated-inputs (list emacs-flycheck emacs-posframe))
   (home-page "https://github.com/alexmurray/flycheck-posframe")
   (synopsis "Show flycheck errors via posframe.el")
   (description "Show flycheck error messages using posframe.el")
   (license license:gpl3)))

(define-public emacs-flymake-lua
  (package
   (name "emacs-flymake-lua")
   (version "20170129.154")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/sroccaserra/flymake-lua.git")
           (commit "84589f20066921a5b79cf3a1f914a223a2552d2a")))
     (method git-fetch)
     (sha256
      (base32 "1f4nigl65g1g5w15ddf33ypk2b07xph964pkdq1bw81451vmvzhn"))))
   (build-system emacs-build-system)
   (home-page "https://github.com/sroccaserra/flymake-lua")
   (synopsis "Flymake for Lua")
   (description "Documentation at https://melpa.org/#/flymake-lua")
   (license #f)))

(define-public emacs-markless
  (package
   (name "emacs-markless")
   (version "20250811.1924")
   (source
    (origin
     (uri (git-reference
           (url "https://codeberg.org/shirakumo/markless.el.git")
           (commit "f8bd797f4d5962fec1dcf9807fba8cf0be17b2f9")))
     (method git-fetch)
     (sha256
      (base32 "1slf0zlw07yp8fl1yiz3ipqk6ajad44kwkb52i53pi98vhlj0y3a"))))
   (build-system emacs-build-system)
   (home-page "https://codeberg.org/shirakumo/markless.el")
   (synopsis "Major mode for Markless documents")
   (description "This package implements a major mode for Markless documents. Markless is a new document markup standard. This does *not* implement a full Markless parser that is compliant with the specification. It uses a simplified grammar that should be adequate for syntax highlighting.")
   (license license:zlib)))

(define-public emacs-bnf-mode
  (package
   (name "emacs-bnf-mode")
   (version "20240915.2118")
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/sergeyklay/bnf-mode.git")
           (commit "5304ab647e04916c5be4fdde41477ad429a89120")))
     (method git-fetch)
     (sha256
      (base32 "0d2w2hbfzvqmln7jzq5j4i4365rvl1fbi3fx252ig1ivkcb4jk8c"))))
   (build-system emacs-build-system)
   (arguments `(#:tests? #f))
   (home-page "https://github.com/sergeyklay/bnf-mode")
   (synopsis "Major mode for editing BNF grammars")
   (description "BNF Mode is a GNU Emacs major mode for editing BNF grammars. Presently it provides basic syntax and font-locking for BNF files. BNF notation is supported exactly form as it was first announced in the ALGOL 60 report.")
   (license license:gpl3)))
