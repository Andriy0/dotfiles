(define-module (gnu packages xmonad-next)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system haskell)
  #:use-module (gnu packages)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages haskell-check))

(define-public ghc-extensible-exceptions-next
  (package
    (inherit ghc-extensible-exceptions)
    (arguments
     `(#:haskell ,ghc-8.10))))

(define-public ghc-quickcheck-next
  (package
    (inherit ghc-quickcheck)
    (arguments
     `(#:haskell ,ghc-8.10))))

(define-public ghc-semigroups-next
  (package
    (inherit ghc-semigroups)
    (arguments
     `(#:haskell ,ghc-8.10))))

(define-public ghc-setlocale-next
  (package
    (inherit ghc-setlocale)
    (arguments
     `(#:haskell ,ghc-8.10))))

(define-public ghc-utf8-string-next
  (package
    (inherit ghc-utf8-string)
    (arguments
     `(#:haskell ,ghc-8.10))))

(define-public ghc-x11-next
  (package
    (inherit ghc-x11)
    (arguments
     `(#:haskell ,ghc-8.10))))

(define-public xmonad-next
  (package
    (inherit xmonad)
    (name "xmonad-next")
    (version "0.15")
    (synopsis "Tiling window manager")
    (inputs
     `(("ghc-extensible-exceptions" ,ghc-extensible-exceptions-next)
       ("ghc-quickcheck"            ,ghc-quickcheck-next)
       ("ghc-semigroups"            ,ghc-semigroups-next)
       ("ghc-setlocale"             ,ghc-setlocale-next)
       ("ghc-utf8-string"           ,ghc-utf8-string-next)
       ("ghc-x11"                   ,ghc-x11-next)))
    (arguments
     `(#:haskell ,ghc-8.10
       #:phases
       (modify-phases %standard-phases
         (add-after
          'install 'install-xsession
          (lambda _
            (let* ((xsessions (string-append %output "/share/xsessions")))
              (mkdir-p xsessions)
              (call-with-output-file
                  (string-append xsessions "/xmonad.desktop")
                (lambda (port)
                  (format port "~
                    [Desktop Entry]~@
                    Name=~a~@
                    Comment=~a~@
                    Exec=~a/bin/xmonad~@
                    Type=Application~%" ,name ,synopsis %output)))))))))))
