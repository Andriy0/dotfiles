(define-module (gnu packages flatpak-next)
  #:use-module (gnu packages package-management)
  #:use-module (guix packages)
  #:use-module (guix download))

(define-public flatpak-next
  (package
   (inherit flatpak)
   (name "flatpak-next")
   (version "1.12.1")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://github.com/flatpak/flatpak/releases/download/"
                         version "/flatpak-" version ".tar.xz"))
     (sha256
      (base32 "0my82ijg1ipa4lwrvh88jlrxbabfqfz2ssfb8cn6k0pfgz53p293"))))))
