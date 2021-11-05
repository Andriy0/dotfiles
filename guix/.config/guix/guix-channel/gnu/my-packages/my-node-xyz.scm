(define-module (gnu my-packages my-node-xyz)
  #:use-module (gnu packages node-xyz)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system node))

(define-public node-min-indent
  (package
    (name "node-min-indent")
    (version "1.0.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/jamiebuilds/min-indent")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32
          "1zcamwmdcxgsd0np9yphbhnjzbinva9ihbfz4a8bn2zgrdv73gx8"))))
    (build-system node-build-system)
    (arguments
     '(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (inputs
     `(("node-color-name" ,node-color-name)))
    (home-page "https://github.com/tlrobinson/long-stack-traces")
    (synopsis "Long stacktraces implemented in user-land JavaScript")
    (description "This package provides long stacktraces for V8 implemented in
user-land JavaScript.")
    (license license:expat))) ; in README

(define-public node-strip-indent
  (package
    (name "node-strip-indent")
    (version "4.0.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/sindresorhus/strip-indent")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32
          "08lpfxhp4g93j6qcgzn3r1gdfz4qfspdg1i8azp9bymx17v2gf0l"))))
    (build-system node-build-system)
    (arguments
     '(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (inputs
     `(("node-min-indent" ,node-min-indent)))
    (home-page "https://github.com/tlrobinson/long-stack-traces")
    (synopsis "Long stacktraces implemented in user-land JavaScript")
    (description "This package provides long stacktraces for V8 implemented in
user-land JavaScript.")
    (license license:expat))) ; in README

(define-public node-yorkie
  (package
    (name "node-yorkie")
    (version "0.14.3")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/yyx990803/yorkie")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32
          "09678902yd62a37d3j3bi23jca94yks9872imjccjfwgck6rhsmj"))))
    (build-system node-build-system)
    (arguments
     '(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (inputs
     `(("node-strip-indent" ,node-strip-indent)))
    (home-page "https://github.com/tlrobinson/long-stack-traces")
    (synopsis "Long stacktraces implemented in user-land JavaScript")
    (description "This package provides long stacktraces for V8 implemented in
user-land JavaScript.")
    (license license:expat))) ; in README

(define-public node-vue-cli
  (package
    (name "node-vue-cli")
    (version "4.5.14")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/vuejs/vue-cli")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32
          "0hhr5lm2yqj4da5ayy9wqjiz0jns6aiav5cgvnnvvfan71dhzdh7"))))
    (build-system node-build-system)
    (arguments
     '(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (home-page "https://github.com/tlrobinson/long-stack-traces")
    (synopsis "Long stacktraces implemented in user-land JavaScript")
    (description "This package provides long stacktraces for V8 implemented in
user-land JavaScript.")
    (license license:expat))) ; in README
