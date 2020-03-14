(define-module (montokapro emacs-xyz)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system emacs)
  #:use-module (gnu packages)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages code)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages dictionaries)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages tcl)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages lesstif)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages image)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages music)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages w3m)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages acl)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages scheme)
  #:use-module (gnu packages speech)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages mp3)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages fribidi)
  #:use-module (gnu packages gd)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages sphinx)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages video)
  #:use-module (gnu packages haskell-xyz)
  #:use-module (gnu packages wordnet)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 match))

;;;
;;; Emacs hacking.
;;;

(define-public emacs-sbt-mode
  (package
    (name "emacs-sbt-mode")
    (version "2.0.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/hvesalai/emacs-sbt-mode.git")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0lv9ridzk9x6rkf7lj21srnszypyq04vqg05vl10zhpz1yqlnbjd"))))
    (build-system emacs-build-system)
    (propagated-inputs
     `(("emacs-hydra" ,emacs-hydra)
       ("emacs-spinner" ,emacs-spinner)))
    (home-page "https://github.com/hvesalai/emacs-sbt-mode")
    (synopsis "Interact with sbt inside emacs")
    (description "The mode provides basic functionality required for
successfully interacting with sbt inside emacs. The core functionality includes
interacting with sbt shell and scala console and compiling code and navigating
to errors.")
    (license license:gpl3+)))

(define-public emacs-scala-mode
  ;; Remove unused file with ensime dependency
  (let ((commit "46bb948345f165ebffe6ff3116e36a3b8a3f219d"))
    (package
      (name "emacs-scala-mode")
      (version "1.0.0")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/hvesalai/emacs-scala-mode.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1072lsin7dxadc0xyhy42wd0cw549axbbd4dy95wfmfcc1xbzjwv"))))
      (build-system emacs-build-system)
      (arguments
       `(#:tests? #f)) ; FIXME: Tests require ensime
      (home-page "https://github.com/hvesalai/emacs-scala-mode")
      (synopsis "Interact with scala inside emacs")
      (description "The mode intends to provide basic emacs support for the Scala
language, including local indenting, motion commands, and highlighting.")
      (license license:gpl3+))))
