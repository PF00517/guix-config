;; -*- mode: scheme; -*-
;; This is an operating system configuration template
;; for a "desktop" setup without full-blown desktop
;; environments.

(use-modules (gnu)
             (gnu system nss))
(use-service-modules desktop xorg networking)
(use-package-modules bootloaders
                     wm
                     text-editors
                     fonts
                     python-xyz
                     terminals
                     version-control
                     ncurses
                     gnuzilla
                     xdisorg
                     admin
                     xorg
                     compton
                     lxde gnome)

(operating-system
  (host-name "guix")
  (timezone "Europe/Kyiv")
  (locale "en_US.utf8")

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))))

  ;; Assume the target root file system is labelled "my-root",
  ;; and the EFI System Partition has UUID 1234-ABCD.
  (file-systems (append (list (file-system
                                (device "/dev/sda3")
                                (mount-point "/")
                                (type "ext4"))
                              (file-system
                                (device "/dev/sda1")
                                (mount-point "/boot/efi")
                                (type "vfat"))) %base-file-systems))

  (users (cons (user-account
                 (name "lain")
                 (group "users")
                 (supplementary-groups '("wheel" "netdev" "audio" "video")))
               %base-user-accounts))

  ;; Add a bunch of window managers; we can choose one at
  ;; the log-in screen with F1.
  (packages (append (list
                     ;; window managers
                     qtile rofi
                     ;; xorg stuff
                     xorg-server xinit xwallpaper xset xrandr
                     ;; text editor
                     vis geany
                     ;; fonts
                     font-jetbrains-mono
                     ;; browser
                     icecat
                     ;; terminal emulator
                     alacritty
                     ;; utils
                     git btop ncurses picom pcmanfm
		     network-manager wpa-supplicant) 
		    %base-packages))

  ;; Use the "desktop" services, which include the X11
  ;; log-in service, networking with NetworkManager, and more.
  ;; (services %desktop-services)
  (services
   (append (list (service xorg-server-service-type)
                 (service slim-service-type)
                 (service network-manager-service-type)
		 (service wpa-supplicant-service-type)) 
	   %base-services)))
