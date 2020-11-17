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
      (description "The mode intends to provide basic emacs support for the
Scala language, including local indenting, motion commands, and highlighting.")
      (license license:gpl3+))))

(define-public emacs-treemacs-unstable
  (let ((version "2.6")
        (commit "81b69d9ee26326178cef08d5aef2811df4f659ed")
        (revision "1"))
    (package
      (inherit emacs-treemacs)
      (name "emacs-treemacs")
      (version (git-version version revision commit))
      (source (origin
		(method git-fetch)
		(uri (git-reference
		      (url "https://github.com/Alexander-Miller/treemacs.git")
		      (commit commit)))
		(file-name (git-file-name name version))
		(sha256
		 (base32
		  "138iw9sva5s6d2asl1ch0723q3q8zqlyllhxrac3phgmqzjdw68c"))))
      (arguments
       `(#:tests? #t ; TODO
	 #:phases
	 (modify-phases %standard-phases
	   (add-after 'unpack 'fix-makefile
	     (lambda _
	       (substitute* "Makefile"
		 (("@\\$\\(CASK\\) exec ") "")
		 (("prepare\n") "\n")
		 )
	       #t))
	   (add-after 'fix-makefile 'chdir-elisp
	     ;; Elisp directory is not in root of the source.
	     (lambda _
	       (chdir "src/elisp")))
	   (replace 'check
	     (lambda _
	       (with-directory-excursion "../.." ;treemacs root
		 (chmod "test/test-treemacs.el" #o644)
		 (emacs-substitute-sexps "test/test-treemacs.el"
		   ("(describe \"treemacs--parse-collapsed-dirs\""
		    ""))
		 (invoke "make" "test"))))
	   (add-before 'install 'patch-paths
	     (lambda* (#:key inputs outputs #:allow-other-keys)
	       (with-directory-excursion "../.." ;treemacs root
		 (chmod "src/elisp/treemacs-core-utils.el" #o644)
		 (emacs-substitute-variables "src/elisp/treemacs-core-utils.el"
		   ("treemacs-dir"
		    (string-append (assoc-ref outputs "out") "/")))
		 (chmod "src/elisp/treemacs-icons.el" #o644)
		 (substitute* "src/elisp/treemacs-icons.el"
		   (("icons/default") "share/emacs-treemacs/images"))
		 (chmod "src/elisp/treemacs-customization.el" #o644)
		 (emacs-substitute-variables "src/elisp/treemacs-customization.el"
		   ("treemacs-python-executable"
		    (string-append (assoc-ref inputs "python") "/bin/python3")))
		 (chmod "src/elisp/treemacs-async.el" #o644)
		 (substitute* "src/elisp/treemacs-async.el"
		   (("src/scripts") (string-append "share/" ,name "/scripts"))))
	       #t))
	   (add-after 'install 'install-data
	     (lambda* (#:key outputs #:allow-other-keys)
	       (let ((out (assoc-ref outputs "out")))
		 (with-directory-excursion "../.." ;treemacs root
		   (copy-recursively "icons/default"
				     (string-append out "/share/" ,name "/images"))
		   (copy-recursively
		    "src/scripts"
		    (string-append out "/share/" ,name "/scripts"))
		   #t))))))))))

(define-public emacs-lsp-treemacs
  (let ((version "20200220")  ; no proper tag, use date of commit
        (commit "2e3606eebfa8bd909b45b88e59d8eecc6afea4a2")
        (revision "1"))
    (package
      (name "emacs-lsp-treemacs")
      (version (git-version version revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/emacs-lsp/lsp-treemacs")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "08xpf677jj1cnfkbpb148h3wld8lvlarp2yq89539nfcmajx53ch"))))
      (build-system emacs-build-system)
      (propagated-inputs
       `(("emacs-dash" ,emacs-dash)
         ("emacs-f" ,emacs-s)
         ("emacs-ht" ,emacs-f)
         ("emacs-treemacs" ,emacs-treemacs-unstable)
         ("emacs-lsp-mode" ,emacs-lsp-mode)))
      (arguments
       `(#:tests? #f)) ; TODO
      (home-page "https://github.com/emacs-lsp/lsp-treemacs")
      (synopsis "Integrate lsp-mode and treemacs")
      (description "Integration between lsp-mode and treemacs and implementation
of treeview controls using treemacs as a tree renderer.")
      (license license:gpl3+))))
