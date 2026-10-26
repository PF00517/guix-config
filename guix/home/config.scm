(define-module (guix home config)
  #:use-module (gnu services)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services pm)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services syncthing)
  #:use-module (guix home emacs)
  #:use-module (guix home udiskie)
  #:use-module (guix home desktop)
  #:use-module (guix gexp))

(define-public config-home-services
  (list
   (simple-service 'profile-env-vars-service
                   home-environment-variables-service-type
                   '(("LC_COLLATE" . "C")

                     ("BROWSER" . "zen")
                     ("VISUAL" . "emacsclient")
                     ("EDITOR" . "emacsclient")
                     ("TERMINAL" . "foot")
                     ("WM" . "river")

                     ("PATH" . "$HOME/.local/bin:$PATH")

                     ;; Route GPG pinentry to the current terminal
                     ("GPG_TTY" . "$(tty)")

                     ;; Make sure Flatpak apps are visible
                     ("XDG_DATA_DIRS" . "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share")

                     ;; ("XDG_CURRENT_DESKTOP" . "hyprland")
                     ;; ("XDG_SESSION_TYPE" . "wayland")
                     ; ("RTC_USE_PIPEWIRE" . "true")
                     ; ("SDL_VIDEODRIVER" . "wayland")
                     ; ("MOZ_ENABLE_WAYLAND" . "1")
                     ; ("CLUTTER_BACKEND" . "wayland")
                     ; ("ELM_ENGINE" . "wayland-egl")
                     ; ("ECORE_EVAS_ENGINE" . "wayland-egl")
                     ("QT_QPA_PLATFORM" . "wayland;xcb")
                     ("QT_QPA_PLATFORMTHEME" . "flatpak")))

   ;; Set up the shell environment
   (service home-zsh-service-type
            (home-zsh-configuration
             (zshrc
              `(,(local-file "../../../.local/bin/bash-prompt")
                ,(plain-file "gpg-tty-update"
                             (string-append
                              ;; Tell gpg-agent the current tty for pinentry routing\n"
                              "gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1\n"))))))

   ;; Emacs configuration
   (service home-emacs-config-service-type)

   ;; Run user dbus session
   (service home-dbus-service-type)

   ;; Set up desktop environment
   (service home-desktop-service-type)

   ;; File synchronization
   (service home-syncthing-service-type)

   ;; Monitor battery levels
   (service home-batsignal-service-type
            (home-batsignal-configuration
             (poll-delay (* 5 60))
             (full-level 90)
             (warning-level 70)
             (critical-level 30)
             (danger-level 20)
             (danger-command "doas zzz")
             (full-message "Unplug the cable")
             (warning-message "You may want to plug the cable")
             (critical-message "Plug the cable")
             (notifications-expire? #t)))

   ;; Udiskie for auto-mounting devices
   (service home-udiskie-service-type)))
