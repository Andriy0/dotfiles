(define-module (home andriy packages)
  #:use-module (gnu packages))

(define-public packages
  (map (compose list specification->package+output)
       '("ungoogled-chromium-wayland"
         "ublock-origin-chromium"
         "firefox-wayland"
         "telegram-desktop"
	 "libreoffice"
	 "gimp"
	 ;; "krita"
	 ;; "xorg-server"
	 ;; "xorg-server-xwayland"
	 ;; "kwayland"
	 ;; "qtwayland"
	 ;; "darktable"
	 "virt-manager"
	 "evince"
	 "nautilus"
         "pavucontrol"
         "bluez"
	 "imv"
	 "playerctl"
	 "mpv" "mpv-mpris" "youtube-dl"
         "xdg-utils"
	 "font-mononoki"
	 "font-abattis-cantarell"
         "font-iosevka"
         "font-openmoji"
         "font-google-roboto"
         "font-google-noto"
         "bemenu"
	 "wofi"
	 "rofi"
         "mako"
         "swappy"
         "grim"
         "slurp"
         "wl-clipboard"
         "hicolor-icon-theme"
         ;; "adwaita-icon-theme"
         "gnome-themes-standard"
	 "gnome-backgrounds"
         ;; "git:send-email"
	 ;; "xsettingsd"
	 "glib:bin"
         "xdg-desktop-portal"
         "xdg-desktop-portal-wlr"
         "direnv"
         "swayidle"
         ;; "nyxt"
         ;; "sbcl-slynk"
         "gstreamer"
         "gst-libav"
         "gst-plugins-base"
         "gst-plugins-good"
         "gst-plugins-bad"
         "gst-plugins-ugly"
         "acpi"
         "alsa-utils"
         "light"
	 "redshift-wayland"
         "wlsunset")))
