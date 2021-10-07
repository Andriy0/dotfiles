(define-module (gnu packages sway-next)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages man)
  #:use-module (gnu packages calendar)
  #:use-module (gnu packages pretty-print)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages mpd)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages logging)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages samba)
  #:use-module (gnu packages cmake)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system gnu)
  #:use-module (ice-9 match))

(define-public libdrm-next
  (package
    (inherit libdrm)
    (name "libdrm")
    (version "2.4.107")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://dri.freedesktop.org/libdrm/libdrm-"
                    version ".tar.xz"))
              (sha256
               (base32
                "127qf1rzhaf13vdd75a58v5q34617hvangjlfnlkcdh37gqcwm65"))))
    (build-system meson-build-system)
    (arguments
     `(#:configure-flags
       '(,@(match (%current-system)
	     ((or "armhf-linux" "aarch64-linux")
	      '("-Dexynos=true"
		"-Domap=true"
		"-Detnaviv=true"
		"-Dtegra=true"
		"-Dfreedreno-kgsl=true"))
	     (_ '())))
       #:meson ,meson-next
       #:phases (modify-phases %standard-phases
                  (replace 'check
                    (lambda _
                      (invoke "meson" "test" "--timeout-multiplier" "5"))))))
    (inputs
     `(("libpciaccess" ,libpciaccess)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))))

(define-public wayland-next
  (package
    (inherit wayland)
    (name "wayland")
    (version "1.19.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://wayland.freedesktop.org/releases/"
                                  name "-" version ".tar.xz"))
              (sha256
               (base32
                "05bd2vphyx8qwa1mhsj1zdaiv4m4v94wrlssrn0lad8d601dkk5s"))))))

(define-public wayland-protocols-next
  (package
    (inherit wayland-protocols)
    (name "wayland-protocols")
    (version "1.21")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://wayland.freedesktop.org/releases/"
                    "wayland-protocols-" version ".tar.xz"))
              (sha256
               (base32
                "1rfdlkzz67qsb955zqb8jbw3m22pl6ppvrvfq8bqiqcb5n24b6dr"))))
    (build-system gnu-build-system)
    (inputs
     `(("wayland" ,wayland-next)))))
    
(define-public wlroots-next
  (package
   (inherit wlroots)
    (name "wlroots")
    (version "0.14.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/swaywm/wlroots")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1sshp3lvlkl1i670kxhwsb4xzxl8raz6769kqvgmxzcb63ns9ay1"))))
    (build-system meson-build-system)
    (arguments
     `(#:configure-flags '("-Dlogind-provider=elogind")
       #:meson ,meson-next
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'hardcode-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "xwayland/server.c"
               (("Xwayland") (string-append (assoc-ref inputs
                                                       "xorg-server-xwayland")
                                            "/bin/Xwayland")))
             #t)))))
    (propagated-inputs
     `(;; As required by wlroots.pc.
       ("elogind" ,elogind)
       ("seatd" ,seatd)
       ("eudev" ,eudev)
       ("libinput" ,libinput)
       ("libxkbcommon" ,libxkbcommon)
       ("libdrm" ,libdrm-next)
       ("mesa" ,mesa)
       ("pixman" ,pixman)
       ("wayland" ,wayland-next)
       ("wayland-protocols" ,wayland-protocols-next)
       ("xcb-util-errors" ,xcb-util-errors)
       ("xcb-util-wm" ,xcb-util-wm)
       ("xcb-util-renderutil", xcb-util-renderutil)
       ("xorg-server-xwayland" ,xorg-server-xwayland)))))

(define-public sway-next
  (package
   (inherit sway)
   (name "sway-next")
    (version "1.6.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/swaywm/sway")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0j4sdbsrlvky1agacc0pcz9bwmaxjmrapjnzscbd2i0cria2fc5j"))))
    (build-system meson-build-system)
    (arguments
     `(#:meson ,meson-next
       #:phases
       (modify-phases %standard-phases
         (add-before 'configure 'hardcode-paths
           (lambda* (#:key inputs #:allow-other-keys)
             ;; Hardcode path to swaybg.
             (substitute* "sway/config.c"
               (("strdup..swaybg..")
                (string-append "strdup(\"" (assoc-ref inputs "swaybg")
                               "/bin/swaybg\")")))
             ;; Hardcode path to scdoc.
             (substitute* "meson.build"
               (("scdoc.get_pkgconfig_variable..scdoc..")
                (string-append "'" (assoc-ref inputs "scdoc")
                               "/bin/scdoc'")))
             #t)))))
    (inputs `(("cairo" ,cairo)
              ("elogind" ,elogind)
              ("gdk-pixbuf" ,gdk-pixbuf)
              ("json-c" ,json-c)
              ("libevdev" ,libevdev)
              ("libinput" ,libinput)
              ("libxkbcommon" ,libxkbcommon)
	      ("libdrm" ,libdrm-next)
	      ("pango" ,pango)
              ("swaybg" ,swaybg)
              ("wayland" ,wayland-next)
              ("wlroots" ,wlroots-next)))
    (native-inputs
     `(("linux-pam" ,linux-pam)
       ("mesa" ,mesa)
       ("pkg-config" ,pkg-config)
       ("scdoc" ,scdoc)
       ("wayland-protocols" ,wayland-protocols-next)))))

(define-public waybar-next
  (package
    (inherit waybar)
    (name "waybar-next")
    (version "0.9.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Alexays/Waybar")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "109a49f064ma5js2d7maribmfalswbmmhq2fraa7hfz5pf2jxs2w"))))
    (build-system meson-build-system)
    (arguments
     `(#:meson ,meson-next))
    (inputs `(("date" ,date)
              ("fmt" ,fmt)
              ("gtk-layer-shell" ,gtk-layer-shell)
              ("gtkmm" ,gtkmm)
              ("jsoncpp" ,jsoncpp)
              ("libdbusmenu" ,libdbusmenu)
              ("libinput" ,libinput)
              ("libmpdclent" ,libmpdclient)
              ("libnl" ,libnl)
              ("pulseaudio" ,pulseaudio)
              ("spdlog" ,spdlog)
              ("wayland" ,wayland-next)
	      ("libxml++" ,libxml++)
	      ("libevdev" ,libevdev)))
    (native-inputs
     `(("gcc" ,gcc-8)                   ; for #include <filesystem>
       ("glib:bin" ,glib "bin")
       ("pkg-config" ,pkg-config)
       ("scdoc" ,scdoc)
       ("wayland-protocols" ,wayland-protocols-next)))))
