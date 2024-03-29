(define-module (home andriy packages)
  #:use-module (gnu packages))

(define-public packages
  (map (compose list specification->package+output)
       '(
	 ;; "ungoogled-chromium"
         ;; "ublock-origin-chromium"
         ;; "firefox"
         "telegram-desktop"
	 "libreoffice"
	 "gimp"
	 "qalculate-gtk"
	 ;; "krita"
	 "xorg-server"
	 "xorg-server-xwayland"
	 "kwayland"
	 "qtwayland"
	 ;; "darktable"
	 ;; "virt-manager"
	 "evince"
	 "nautilus"
         "pavucontrol"
         "bluez"
	 "blueman"
	 "imv"
	 "playerctl"
	 "mpv" "mpv-mpris" "youtube-dl"
         "xdg-utils"
	 "font-mononoki"
	 "font-abattis-cantarell"
         "font-iosevka"
         "font-openmoji"
         "font-google-roboto"
         ;; "font-google-noto"
	 "sway"
	 "waybar"
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
	 "glibc"
	 "glibc-locales"
	 "glib:bin"
         "xdg-desktop-portal"
         "xdg-desktop-portal-wlr"
	 "curl"
         "direnv"
	 "ripgrep"
	 "fd"
	 "unzip"
	 "zip"
	 "stow"
	 "make"
	 "htop"
	 "tree"
	 "sbcl"
	 "zathura" "zathura-pdf-poppler" "zathura-pdf-mupdf"
	 "openssh"
	 "fish"
	 "ncurses"
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
