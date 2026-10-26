(define-module (guix home desktop)
  #:use-module (gnu)
  #:use-module (gnu home services)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (guix packages wm)
  ;; #:use-module (guix packages theme)
  #:use-module (guix packages seninha)
  #:use-module (guix packages xdisorg)
  #:use-module (guix packages freedesktop)
  #:use-module (guix packages password-utils)
  #:use-module (nongnu packages game-client) ;; steam
  ;; #:use-module (nongnu packages fonts) ; font-apple-color-emoji
  #:use-module (guix gexp)
  #:export (home-desktop-service-type))

(use-package-modules admin compression curl disk file fonts freedesktop gimp glib gnome gnuzilla gtk image
                     image-viewers linux lisp lsof music package-management pdf pulseaudio shellutils
                     ssh syncthing terminals video vim web wget window-management xdisorg xorg zig-xyz)

(define (home-desktop-profile-service config)
  (list ;; river-classic
        river-minimal
        rivercarro
        river-bedload
        wbg
        fuzzel-lowercase
        eww
        fnott
        wlrctl
        wlr-randr
        wl-clipboard
        foot
        gammastep-minimal
        grim
        lf

        ;; Web
        jq

        ;; Compatibility for older Xorg applications
        ;; xorg-server-xwayland

        ;; Flatpak and XDG utilities
        flatpak
        xdg-desktop-portal-minimal
        ;; xdg-desktop-portal-gtk
        xdg-desktop-portal-termfilechooser
        xdg-desktop-portal-wlr-minimal
        xdg-utils/wayland
        ;; xdg-dbus-proxy
        ;; shared-mime-info
        dbus

        ;; Languages
        janet
        ; lua

	      steam

        ;; Themes
        ;; adwaita-icon-theme
        ;; hicolor-icon-theme
        ;; (tela-circle-icon-theme "black")

        ;; Fonts
        font-iosevka
        font-iosevka-aile
        font-jetbrains-mono
        font-google-noto
        font-google-noto-emoji
        font-awesome
        font-mononoki
        ;; font-apple-color-emoji
        font-nerd-symbols
        font-ibm-plex

        ;; Browsers
        (specification->package "qtwayland@5")
        gtk+

        ;; Authentication
        password-store-minimal/wayland
        tessen/wayland

        ;; Audio devices and media playback
        mpv
        mpv-mpris
        yt-dlp
        playerctl
        alsa-utils
        pavucontrol

        ;; Graphics
        gimp

        ;; PDF reader
        zathura
        zathura-pdf-mupdf

        ;; File syncing
        syncthing-gtk

        ;; Terminal editor
        neovim

        ;; General utilities
        curl
        wget
        openssh
        zip
        unzip
        trash-cli
        chafa
        poppler
        ffmpegthumbnailer
        file
        fmutils

        ;; System monitoring and network tools
        btop
        lsof
        netcat
        (specification->package+output "bind" "utils")))

(define home-desktop-service-type
  (service-type (name 'home-desktop)
                (description "DE service.")
                (extensions
                 (list (service-extension
                        home-profile-service-type
                        home-desktop-profile-service)))
                (default-value #f)))
