(define-module (montokapro emacs-xyz)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 match))

;;;
;;; Emacs hacking.
;;;

(define-public emacs-helm-projectile
  (let ((commit "2f3a2a03d6cb9419c25b432637aa11c8d2f9f3b7")
        (revision "1"))
    (package
      (name "emacs-helm-projectile")
      (version (git-version "1.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/bbatsov/helm-projectile")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0h6r8v2lj6abjz73iv8568ijs7l37j76nf58h4p9r9ldpdigihzz"))))
      (build-system emacs-build-system)
      (propagated-inputs
       `(("emacs-helm" ,emacs-helm)
         ("emacs-projectile" ,emacs-projectile)))
      (home-page "https://github.com/bbatsov/helm-projectile")
      (synopsis "Helm integration for Projectile")
      (description
       "This Emacs library provides a Helm interface for Projectile.")
      (license license:gpl3+))))
