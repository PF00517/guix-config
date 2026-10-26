(define-module (guix packages seninha)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp))

(define-public fmutils
  (let ((commit "919b32fbc47d0303d59cdca66bfc6f0a8906a0ae")
        (revision "0"))
    (package
     (name "fmutils")
     (version (git-version "0.0.0" revision commit))
     (source (origin
              (uri (git-reference
                    (url "https://github.com/phillbush/fmutils")
                    (commit commit)))
              (method git-fetch)
              (file-name (git-file-name name version))
              (sha256
               (base32 "1ikn2y1bj8gg045nq7s9g9fc1619pabv3c5lljxxv5bmrlmaxvh4"))))
     (build-system copy-build-system)
     (arguments
      (list #:install-plan #~'(("bulkrename" "bin/")
                                ("pick" "bin/")
                                ("preview" "bin/")
                                ("skel" "bin/")
                                ("trash" "bin/")
                                ("untrash" "bin/")
                                ("unpack" "bin/")
                                ("bulkrename.1" "share/man/man1/")
                                ("pick.1" "share/man/man1/")
                                ("preview.1" "share/man/man1/")
                                ("skel.1" "share/man/man1/")
                                ("trash.1" "share/man/man1/")
                                ("unpack.1" "share/man/man1/"))))
     (home-page "https://github.com/void-linux/void-runit")
     (synopsis "File management utilities in POSIX shell scripts.")
     (description "\
fmutils is a set of public domain POSIX scripts implementing some file
management related utilities.  There are man pages for each script.

The scripts are the following.
@itemize
@item bulkrename: Bulk rename files with your text editor.
@item pick:       Interactivelly select options.
@item preview:    Generate text preview of a file to be used by lf(1) or ranger(1).
@item skel:       Create a template file in the current directory.
@item trash:      Move files to trash following XDG trash specification.
@item untrash:    Remove files from trash following XDG trash specification.
@item unpack:     Unarchive archived files (.zip, .rar, .tar.gz, etc).
@end itemize")
     (license license:public-domain))))
