(define-module (guix system modules file-systems)
  #:use-module (gnu system file-systems)
  #:export (partition-guix
            persistent-directories
            persistent-files
            volumes))

(define partition-guix
  (file-system-label "guix"))

(define volumes
  (list ;; Base
        %pseudo-terminal-file-system
        %shared-memory-file-system

        ;; Boot
        (file-system
         (device partition-guix)
         (type "btrfs")
         (mount-point "/boot")
         (check? #f)
         (needed-for-boot? #t)
         (flags '(no-atime))
         (options "subvol=@boot"))

        ;; Run
        (file-system
         (device "none")
         (type "tmpfs")
         (mount-point "/run")
         (check? #f)
         (needed-for-boot? #t)
         (flags '(no-dev strict-atime))
         (options (format #f "mode=0755,~
                              nr_inodes=800k,~
                              size=20%")))

        ;; Tmp
        (file-system
         (device "none")
         (type "tmpfs")
         (mount-point "/tmp")
         (check? #f)
         (needed-for-boot? #f))

        ;; Root
        (file-system
         (device "none")
         (type "tmpfs")
         (mount-point "/")
         (check? #f)
         (needed-for-boot? #t)
         (options "mode=0755"))

        ;; Gnu
        (file-system
         (device partition-guix)
         (type "btrfs")
         (mount-point "/gnu/persist")
         (needed-for-boot? #t)
         (flags '(no-atime))
         (options "subvol=@gnu/persist"))
        (file-system
         (device partition-guix)
         (type "btrfs")
         (mount-point "/gnu/store")
         (needed-for-boot? #t)
         (flags '(read-only no-atime))
         (options (format #f "compress=zstd,~
                              subvol=@gnu/store")))

        ;; Var
        (file-system
         (device partition-guix)
         (type "btrfs")
         (mount-point "/var/guix")
         (needed-for-boot? #t)
         (flags '(no-atime))
         (options (format #f "compress=zstd,~
                              subvol=@var/guix")))
        (file-system
         (device partition-guix)
         (type "btrfs")
         (mount-point "/var/lib")
         (needed-for-boot? #t)
         (flags '(no-atime))
         (options (format #f "compress=zstd,~
                              subvol=@var/lib")))
        (file-system
         (device partition-guix)
         (type "btrfs")
         (mount-point "/var/log")
         (check? #f)
         (needed-for-boot? #t)
         (flags '(no-atime))
         (options (format #f "compress=zstd,~
                              subvol=@var/log")))
        (file-system
         (device "none")
         (type "tmpfs")
         (mount-point "/var/run")
         (check? #f)
         (needed-for-boot? #t)
         (flags '(no-dev strict-atime))
         (options (format #f "mode=0755,~
                              nr_inodes=800k,~
                              size=20%")))

        ;; Snapshots
        (file-system
         (device partition-guix)
         (type "btrfs")
         (mount-point "/snapshots")
         (check? #f)
         (needed-for-boot? #t)
         (flags '(no-atime))
         (options (format #f "compress=zstd,~
                              subvol=@snapshots")))

        ;; Home
        (file-system
         (device partition-guix)
         (type "btrfs")
         (mount-point "/root")
         (flags '(no-atime))
         (options "subvol=@root"))
        (file-system
         (device partition-guix)
         (type "btrfs")
         (mount-point "/home")
         (flags '(no-atime))
         (options "subvol=@home"))))

(define persistent-directories
  (map (lambda (filename)
         (file-system
          (mount-point filename)
          (device (string-append "/gnu/persist" mount-point))
          (type "none")
          (check? #f)
          (flags '(no-atime bind-mount))))
       `("/etc/guix"
         "/etc/ssh"
         "/etc/wireguard")))

(define persistent-files
  `("/etc/machine-id"))
