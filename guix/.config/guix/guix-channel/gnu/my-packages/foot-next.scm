(define-module (gnu my-packages foot-next)
  #:use-module (gnu packages terminals)
  #:use-module (guix packages)
  #:use-module (guix git-download))

(define-public foot-next
  (package
   (inherit foot)
   (name "foot-next")
   (version "1.9.0")
   (home-page "https://codeberg.org/dnkl/foot")
   (source (origin
              (method git-fetch)
              (uri (git-reference (url home-page) (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0mkzq5lbgl5qp5nj8sk5gyg9hrrklmbjdqzlcr2a6rlmilkxlhwm"))))))
