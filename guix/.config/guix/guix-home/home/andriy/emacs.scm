(define-module (home andriy emacs)
  #:use-module (guix gexp)
  #:use-module (guix transformations)

  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (rde packages)

  #:use-module (gnu home services)
  #:use-module (gnu home-services emacs)
  #:use-module (gnu home-services-utils))

;; (define transform
;;   (options->transformation
;;    '((with-commit . "emacs-use-package=a7422fb8ab1baee19adb2717b5b47b9c3812a84c")
;;      (with-commit . "emacs-embark=acbe1cba548832d295449da348719f69b9685c6f"))))

(define packages
  (map specification->package
       '("emacs-vterm"
         )))

(define-public services
  (list
   (service home-emacs-service-type
            (home-emacs-configuration
             (package emacs-next-pgtk)
             (rebuild-elisp-packages? #t)
	     (server-mode? #f)
             ;; (init-el
             ;;  `(,(slurp-file-gexp (local-file "/home/andriy/dotfiles/emacs/.config/emacs/init.el"))))
             (elisp-packages packages)))))
