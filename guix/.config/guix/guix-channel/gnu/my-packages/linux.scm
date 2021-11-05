(define-module (gnu my-packages linux)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages build-tools)
  #:use-module (guix packages)
  #:use-module (guix build-system meson)
  #:use-module (guix git-download))

(define-public pipewire-0.3.39
  (package
    (inherit pipewire-0.3)
    (name "pipewire")
    (version "0.3.39")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/PipeWire/pipewire")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0crfhyaqac42lam5fylivi3l2vi5wwxg1vxssrh1chvfwgbx5r55"))))
    (build-system meson-build-system)
    (arguments
     `(#:configure-flags
       (list (string-append "-Dudevrulesdir=" (assoc-ref %outputs "out")
                            "/lib/udev/rules.d")
             "-Dsystemd=disabled")
       #:meson ,meson-next
       #:phases
       (modify-phases %standard-phases
         ;; Skip shrink-runpath, otherwise validate-runpath fails.
         (delete 'shrink-runpath))))))
