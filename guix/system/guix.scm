(use-modules (gnu)
			 (gnu system)
             (gnu system nss)
             (gnu system accounts)
             (gnu system privilege)
			 (guix services pm)
             (guix system base)
             (guix system modules files)
             (guix system modules secrets)
			 (guix system modules file-systems)
             ((guix system substitute-keys) #:prefix substitute-key:)
             (guix gexp))

(use-service-modules admin base pm avahi dbus cups desktop guix
                     linux networking xorg shepherd sysctl)

(use-package-modules audio admin bash base video nfs linux shells
                     compression gawk guile less man pciutils ;; window-management 
					 libusb cups freedesktop file-systems tex-info
                     xdisorg gnome version-control package-management vim)

(operating-system
 (inherit base)
 (host-name "guix")
 (timezone "Europe/Kyiv")
 (locale "en_US.utf8")

 (kernel linux-libre-6.17)
 (kernel-arguments
  `("console=tty1"
    "modprobe.blacklist=usbmouse,usbkbd,pcspkr"
    "thinkpad_acpi.fan_control=1"
    "quiet"))

 (keyboard-layout (keyboard-layout "us" "altgr-intl" #:model "thinkpad"))

 (bootloader (bootloader-configuration
              (bootloader grub-bootloader)
              (targets '("/dev/disk/by-id/ata-CT120BX500SSD1_1925E18A61AF"))))

 (file-systems (append volumes persistent-directories))

 (users (cons* (user-account
                (name "lain")
                (password %lain-password)
                (group "users")
                (home-directory "/home/lain")
                (comment "Vadym Lakom")
                (shell (file-append zsh "/bin/zsh"))
                (uid 1000)
                (supplementary-groups '("audio"
                                        "kvm"
                                        "seat"
                                        "video"
                                        "wheel")))
               (user-account
                (name "root")
                (password %root-password)
                (home-directory "/root")
                (uid 0)
                (group "root")
                (shell (file-append bash "/bin/bash")))
               %base-user-accounts))

 (packages 
	(list bluez
          bluez-alsa
		  brightnessctl
          exfat-utils
          fuse-exfat
          git
          gvfs
          ;; intel-vaapi-driver
          ;; libva-utils
          ntfs-3g
          stow
          vim
				
			inetutils shadow zzz
			coreutils diffutils findutils grep sed tar which 
			bash 
			nss-certs
			gzip xz zstd 
			gawk
			guile-3.0 guile-colorized guile-readline
			less
			iproute kmod procps usbutils util-linux
			man-db man-pages
			pciutils
			info-reader))

 (services
  (list ;; (service elogind-service-type)
        (service seatd-service-type)

        ;; TTY
        (service virtual-terminal-service-type)

        (service greetd-service-type
                 (greetd-configuration
                  (greeter-supplementary-groups `("seat"))
                  (terminals
                   (list
                    (greetd-terminal-configuration
                     (terminal-vt "1")
                     (terminal-switch #t)
                     (default-session-command
                       #~(string-append
                          #$tuigreet "/bin/tuigreet "
                          "--time " "--cmd river "
                          "--power-shutdown 'loginctl poweroff' "
                          "--power-reboot 'loginctl reboot'")))
                    ;; (greetd-terminal-configuration (terminal-vt "2"))
                    ;; (greetd-terminal-configuration (terminal-vt "3"))
                    ;; (greetd-terminal-configuration (terminal-vt "4"))
                    ;; (greetd-terminal-configuration (terminal-vt "5"))
                    ;; (greetd-terminal-configuration (terminal-vt "6"))
                    ))))
        ;; (service screen-locker-service-type
        ;;          (screen-locker-configuration
        ;;           (name "hyprlock")
        ;;           (program (file-append hyprlock "/bin/hyprlock"))))

        ;; Give certain programs super-user access
        (simple-service 'mount-setuid-helpers
                        privileged-program-service-type
                        (map (lambda (program)
                               (privileged-program
                                (program program)
                                (setuid? #t)))
                             (list (file-append nfs-utils "/sbin/mount.nfs")
                                   (file-append ntfs-3g "/sbin/mount.ntfs-3g"))))

        ;; Networking services
        ;; (service network-manager-service-type)
		;; (service wpa-supplicant-service-type)
        ;; (service modem-manager-service-type)
        (service static-networking-service-type
                 (list %loopback-static-networking))
        (service iwd-service-type
                 (iwd-configuration
                  (config
                   (iwd-settings
                    (general
                     (iwd-general-settings
                      (enable-network-configuration? #t)
                      (extra-options `(("Country" . "UA")))))
                    (network
                     (iwd-network-settings
                      (name-resolving-service 'resolvconf)))))
                  (shepherd-provision
                   '(iwd wireless-daemon networking))))
        ;; (service bluetooth-service-type
        ;;          (bluetooth-configuration
        ;;           (auto-enable? #t)))
        ;; (service usb-modeswitch-service-type)

        ;; Log services
        (service log-rotation-service-type
                 (log-rotation-configuration
                  (expiry (* 2 30 24 60 60))))
        (service shepherd-system-log-service-type)
        (service log-cleanup-service-type
                 (log-cleanup-configuration
                  (directory "/var/log/guix/drvs")
                  (expiry (* 2 30 24 3600))))

        ;; Basic desktop system services (copied from %desktop-services)
        (service avahi-service-type)
        (service udisks-service-type)
        (service upower-service-type)
        (service cups-pk-helper-service-type)
        ;; (service geoclue-service-type)
        ;; (service polkit-service-type)
        (service dbus-root-service-type)
        fontconfig-file-system-service ;; Manage the fontconfig cache

        ;; Guix services
        (service guix-service-type
                 (guix-configuration
                  (build-accounts 16)
                  (authorized-keys
                   (cons* substitute-key:genenetwork.pub
                          substitute-key:inria.pub
                          substitute-key:moe.pub
                          substitute-key:yumiko.pub
                          %default-authorized-guix-keys))
                  (substitute-urls
                   `("https://cache-us-lax.guix.moe"
                     "https://cuirass.genenetwork.org"
                     "https://ci.guix.gnu.org"
                     "https://guix.bordeaux.inria.fr"))
                  (extra-options
                   `("--cores=4"
                     "--gc-keep-derivations=yes"
                     "--gc-keep-outputs=yes"))))
        (service shared-cache-service-type
                 (shared-cache-configuration
                  (users (list (user-cache (user "lain"))))))

        ;; Power and thermal management services
        ;; (service thermald-service-type)
        (service tlp-service-type
                 (tlp-configuration
                  (cpu-scaling-governor-on-ac `("performance"))
                  (cpu-scaling-governor-on-bat `("powersave"))
                  (cpu-scaling-min-freq-on-ac 1500000)
                  (cpu-scaling-max-freq-on-ac 3500000)
                  (cpu-scaling-min-freq-on-bat 1000000)
                  (cpu-scaling-max-freq-on-bat 3000000)
                  (cpu-min-perf-on-ac 0)
                  (cpu-max-perf-on-ac 100)
                  (cpu-min-perf-on-bat 0)
                  (cpu-max-perf-on-bat 40)
                  (cpu-boost-on-ac? #t)
                  (cpu-boost-on-bat? #f)
                  (nmi-watchdog? #t)
                  (start-charge-thresh-bat0 70)
                  (stop-charge-thresh-bat0 90)))
        ;; (service tlp-service-type
        ;;          (tlp-configuration
        ;;           (wifi-pwr-on-bat? #t)
        ;;           (cpu-boost-on-ac? #t)
        ;;           (start-charge-thresh-bat0 70)
        ;;           (stop-charge-thresh-bat0 90)))
        (service thinkfan-service-type
                 (thinkfan-configuration
                  (thinkfan thinkfan-next)
                  (auto-start? #f)
                  (config-file thinkfan-config)))

        ;; Enable printing and scanning
        (service sane-service-type)
        (service cups-service-type
                 (cups-configuration
                  (web-interface? #t)
                  (extensions
                   (list cups-filters))))

        ;; Set up the X11 socket directory for XWayland
        ;; (service x11-socket-directory-service-type)

        ;; Sync system clock with time servers
        (service ntp-service-type)

        ;; Add udev rules for MTP (mobile) devices for non-root user access
        (simple-service 'mtp udev-service-type (list libmtp))

        ;; Add udev rules for a few packages
        (udev-rules-service 'pipewire-add-udev-rules pipewire)
        (udev-rules-service 'brightnessctl-udev-rules brightnessctl)
		
        ;; Special file services
        (service special-files-service-type
                 `(("/bin/sh" ,(file-append bash "/bin/bash"))
                   ("/usr/bin/env" ,(file-append coreutils "/bin/env"))))
        (simple-service 'persistent-files
                        special-files-service-type
                        (map (lambda (dir)
                               (list dir (string-append "/gnu/persist" dir)))
                             persistent-files))
		
		;; Base services
        (service sysctl-service-type)
        (service urandom-seed-service-type)
        (service nscd-service-type)))

 ;; Allow resolution of '.local' host names with mDNS
 (name-service-switch %mdns-host-lookup-nss)
 
 ;; Do not generate a sudoers file
 (sudoers-file #f))