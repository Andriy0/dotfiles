;; This is an operating system configuration template
;; for a "desktop" setup without full-blown desktop
;; environments.

(use-modules 
 (srfi srfi-1)
 (guix channels)
 (guix inferior)
 (guix packages)
 (gnu) 
 (gnu system nss) 
 (gnu services pm)
 (gnu services sound)
 (gnu services dbus)
 (gnu services nix)
 (gnu services sysctl)
 (gnu services sddm)
 (gnu services audio)
 (gnu services networking)
 (gnu services virtualization)
 (gnu services shepherd)
 (gnu packages)
 (gnu packages vim)
 (gnu packages pulseaudio)
 (gnu packages package-management)
 (gnu packages version-control)
 (gnu packages xorg)
 (gnu packages xdisorg)
 (gnu packages linux)
 (gnu packages audio)
 (gnu packages gnome)
 (gnu packages lisp)
 (nongnu packages linux) 
 (nongnu system linux-initrd))

(use-service-modules desktop xorg)

(use-package-modules bootloaders certs emacs emacs-xyz openbox xfce
		     ratpoison suckless wm fonts xorg terminals)

;; Allow members of the "video" group to change the screen brightness.
(define %backlight-udev-rule
  (udev-rule
   "90-backlight.rules"
   (string-append "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chgrp video /sys/class/backlight/%k/brightness\""
                  "\n"
                  "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
                  "RUN+=\"/run/current-system/profile/bin/chmod g+w /sys/class/backlight/%k/brightness\"")))

(define %my-desktop-services
  (modify-services %desktop-services
		   (elogind-service-type config =>
					 (elogind-configuration (inherit config)
								(handle-lid-switch-external-power 'suspend)))
		   (udev-service-type config =>
				      (udev-configuration (inherit config)
							  (rules (cons %backlight-udev-rule
								       (udev-configuration-rules config)))))
		   (guix-service-type config =>
				      (guix-configuration
				       (inherit config)
				       (substitute-urls (append
							 %default-substitute-urls
							 ;; (list "https://guix.rohleder.de")
							 (list "http://substitutes.guix.sama.re")
							 (list "https://mirror.brielmaier.net")))
				       (authorized-keys (append
							 %default-authorized-guix-keys
							 ;; (list (local-file "guix.rohdeler.de.pub"))
							 (list (local-file "substitutes.guix.sama.re.pub"))
							 (list (local-file "mirror.brielmaier.net.pub"))))))
		   
		   (network-manager-service-type config =>
						 (network-manager-configuration (inherit config)
										(vpn-plugins (list network-manager-openvpn))))))

(define %xorg-libinput-config
  "Section \"InputClass\"
  Identifier \"Touchpads\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsTouchpad \"on\"
  Option \"Tapping\" \"on\"
  Option \"TappingButtonMap\" \"lmr\"
  Option \"TappingDrag\" \"on\"
  Option \"DisableWhileTyping\" \"off\"
  Option \"MiddleEmulation\" \"on\"
  Option \"ScrollMethod\" \"twofinger\"
  Option \"NaturalScrolling\" \"true\"
EndSection

Section \"InputClass\"
  Identifier \"Keyboards\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsKeyboard \"on\"
  Option \"XkbLayout\" \"us,ua\"
  Option \"XkbModel\" \"pc105\"
  Option \"XkbOptions\" \"caps:ctrl_modifier,altwin:menu_win,grp:ctrls_toggle\"
EndSection
")

(operating-system
 ;; (kernel 
 ;;  (let*
 ;;      ((channels
 ;;        (list (channel
 ;;               (name 'nonguix)
 ;;               (url "https://gitlab.com/nonguix/nonguix")
 ;;               (commit "967838c40d9d4a04254b9e496b356a8a7b5015ae"))
 ;;              (channel
 ;;               (name 'guix)
 ;;               (url "https://git.savannah.gnu.org/git/guix.git")
 ;;               (commit "a0fd46304e42f1df711b001a7159160c8e26d21d"))))
 ;;       (inferior
 ;;        (inferior-for-channels channels)))
 ;;    (first (lookup-inferior-packages inferior "linux" "5.13.10"))))
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))

 (host-name "guixsd")
 (timezone "Europe/Kiev")
 (locale "en_US.utf8")

 ;; Use the UEFI variant of GRUB with the EFI System
 ;; Partition mounted on /boot/efi.
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (target "/boot/efi")))

 (kernel-arguments
  (append
   (list "modprobe.blacklist=pcspkr"
	 "intel_pstate=disable"
	 "snd_hda_intel.index=1"
	 "dev.i915.perf_stream_paranoid=0")
   %default-kernel-arguments))

 ;; Assume the target root file system is labelled "my-root",
 ;; and the EFI System Partition has UUID 1234-ABCD.
 (file-systems (append
                (list (file-system
                       (device (file-system-label "guixsd"))
                       (mount-point "/")
                       (type "btrfs")
		       (flags '(no-atime))
                       (options "ssd,space_cache,compress=zstd,commit=120,subvol=@"))
                      (file-system
                       (device (file-system-label "guixsd"))
                       (mount-point "/home")
                       (type "btrfs")
                       (options "subvol=@home"))
                      (file-system
                       (device (file-system-label "guixsd"))
                       (mount-point "/gnu")
                       (type "btrfs")
		       (flags '(no-atime))
                       (options "subvol=@gnu"))
		      ;; It didn't work with /var on separate subvol
                      ;; (file-system
                      ;;   (device (file-system-label "guixsd"))
                      ;;   (mount-point "/var")
                      ;;   (type "btrfs")
                      ;;   (options "subvol=@var"))
                      (file-system
                       (device (file-system-label "ESP"))
                       (mount-point "/boot/efi")
                       (type "vfat")
		       (flags '(no-atime))
		       (check? #f)))
                %base-file-systems))

 (users (cons (user-account
               (name "andriy")
               (comment "Andrii")
               (group "users")
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video"
				       "lp" "kvm"
				       "libvirt")))
              %base-user-accounts))

 ;; Add the 'realtime' group
 (groups (cons (user-group (system? #t) (name "realtime"))
               %base-groups))

 ;; Add a bunch of window managers; we can choose one at
 ;; the log-in screen with F1.
 (packages (append (map specification->package
                    '(;; window managers
                    "awesome"
		    ;; "emacs-exwm"
		    ;; "emacs-desktop-environment"
		    ;; bspwm sxhkd
		    "sbcl" "stumpwm"
		    ;; "stumpwm:lib"
		    "sbcl-stumpwm-ttf-fonts"
		    "font-dejavu"
		    ;; openbox xfce bspwm
		    "sxhkd" "rofi" "dmenu"
		    "sway" "xdg-desktop-portal" "xdg-desktop-portal-wlr"
		    ;; editors
                    "emacs-next" "vim" "neovim"
                    ;; terminal emulator
                    "xterm" "alacritty"
		    ;; mics
		    "git" "xf86-input-libinput"
		    ;; "pulseaudio"
		    "alsa-utils"
		    "bluez" "bluez-alsa"
		    "pipewire"
		    "tlp" "gvfs" "cpupower"
		    "acpi"
                    ;; for HTTPS access
                    "nss-certs"))
                   %base-packages))

 ;; Use the "desktop" services, which include the X11
 ;; log-in service, networking with NetworkManager, and more.
 ;; (services %desktop-services)

 (services
  (cons*
   ;; (service slim-service-type
   ;; 	     (slim-configuration
   ;; 	      (xorg-configuration
   ;; 	       (xorg-configuration
   ;; 		(extra-config (list %xorg-libinput-config))))))
   (service sddm-service-type
	    (sddm-configuration
	     (numlock "off")
	     (themes-directory "/home/andriy/.local/share/sddm/themes")
	     (theme "chili")
	     (sessions-directory "/home/andriy/.local/share/wayland-sessions")
	     (xsessions-directory "/home/andriy/.local/share/xsessions")
	     (xorg-configuration
	      (xorg-configuration
	       (extra-config (list %xorg-libinput-config))))))
   (service tlp-service-type
	    (tlp-configuration
	     (cpu-boost-on-ac? #f)
	     (cpu-boost-on-bat? #f)
	     (cpu-scaling-governor-on-ac (list "ondemand"))
	     (cpu-scaling-governor-on-bat (list "ondemand"))
	     (cpu-scaling-max-freq-on-ac 1500000)
	     (cpu-scaling-max-freq-on-bat 1500000)))
   (pam-limits-service ;; This enables JACK to enter realtime mode
    (list
     (pam-limits-entry "@realtime" 'both 'rtprio 99)
     (pam-limits-entry "@realtime" 'both 'memlock 'unlimited)))
   ;; (service mpd-service-type
   ;;          (mpd-configuration
   ;;           (user "andriy")
   ;; 	     (music-dir "~/Music")
   ;;           (playlist-dir "~/.local/share/mpd/playlists")
   ;;           (db-file "~/.local/share/mpd/tag_cache")
   ;;           (state-file "~/.local/share/mpd/state")
   ;;           (sticker-file "~/.local/share/mpd/sticker.sql")
   ;; 	     (port "6600")
   ;;           (address "localhost")))
   ;; (service alsa-service-type
   ;; 	     (alsa-configuration
   ;; 	      (pulseaudio? #f)))
   (screen-locker-service xscreensaver "xscreensaver")
   (service libvirt-service-type
	    (libvirt-configuration
	     (unix-sock-group "libvirt")
	     (tls-port "16555")))
   (service virtlog-service-type
	    (virtlog-configuration
	     (max-clients 1000)))
   ;; (service sysctl-service-type
   ;;          (sysctl-configuration
   ;;           (settings '(("dev.i915.perf_stream_paranoid" ."0")))))
   (service nix-service-type)
   (bluetooth-service #:auto-enable? #f)
   (remove (lambda (service)
	      (eq? (service-kind service) gdm-service-type))
	   %my-desktop-services)))

 
 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))

