;; (use-modules (guix channels))

;; (channel
;;       (name 'flat)
;;       (url "https://github.com/flatwhatson/guix-channel.git")
;;       (commit
;;         "8d550700c535dbcd4721cc65c0a11decbf070abb")
;;       (introduction
;;         (make-channel-introduction
;;           "33f86a4b48205c0dc19d7c036c85393f0766f806"
;;           (openpgp-fingerprint
;;             "736A C00E 1254 378B A982  7AF6 9DBE 8265 81B6 4490"))))

(specifications->manifest
 '(
   ;; "emacs-native-comp@28.0.50-149"
   ;; "emacs-native-comp"
   "emacs-pgtk-native-comp"
   ;; "emacs-next"
   ;; "emacs"

   ;; "emacs-exwm"
   ;; "emacs-desktop-environment"
   ;; "emacs-guix"
   ;; 
   ;; "emacs-esup"
   ;; 
   ;; "emacs-use-package"
   ;; 
   ;; "emacs-general"
   ;; "emacs-evil"
   ;; "emacs-evil-collection"
   ;; "emacs-undo-tree"
   ;; 
   ;; "emacs-modus-themes"
   ;; 
   ;; "emacs-all-the-icons"
   ;; "emacs-doom-modeline"
   ;; 
   ;; "emacs-which-key"
   ;; 
   ;; "emacs-vertico"
   ;; "emacs-consult"
   ;; "emacs-prescient"
   ;; "emacs-marginalia"
   ;; 
   ;; "emacs-diminish"
   ;; 
   ;; "emacs-helpful"
   ;; 
   ;; "emacs-hydra"
   ;; 
   ;; "emacs-visual-fill-column"
   ;; 
   ;; "emacs-lsp-mode"
   ;; ;; "emacs-flycheck"
   ;; 
   ;; "emacs-lsp-ivy"
   ;; 
   ;; "emacs-lua-mode"
   ;; "emacs-lsp-lua-emmy"
   ;; 
   ;; "emacs-lua-mode"
   ;; "emacs-lsp-lua-emmy"
   ;; 
   ;; "emacs-geiser"
   ;; "emacs-geiser-guile"
   ;; 
   ;; "emacs-slime"
   ;; 
   ;; "ccls"
   ;; "emacs-ccls"
   ;; "clang-toolchain"
   ;; "gcc-toolchain"
   ;; "make"
   ;; "emacs-yasnippet-snippets"
   ;; 
   ;; "emacs-company"
   ;; "emacs-company-box"
   ;; "emacs-company-lsp"
   ;; "emacs-company-coq"
   ;; "emacs-slime-company"
   ;; 
   ;; "emacs-evil-nerd-commenter"
   ;; 
   ;; "emacs-rainbow-delimiters"
   ;; 
   ;; "emacs-parinfer-mode"
   ;; 
   ;; "emacs-vterm"
   ;; 
   ;; "emacs-diredfl"
   ;; "emacs-dired-hacks"
   ;; "emacs-all-the-icons-dired"
   ;; 
   ;; "emacs-bluetooth"
   ;; 
   ;; "emacs-guix"
   ;; 
   "emacs-vterm"
   ;; "emacs-slime"
   ;; "emacs-ccls" ; for c/c++ on lsp or eglot
   "sbcl"
   "ccls"
   "gcc-toolchain"
   "clang-toolchain"
   "make"
   "libtool" ; required to compile vterm
   "libvterm"
   "perl"
   "cmake"
   "ripgrep"
))
