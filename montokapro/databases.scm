(define-module (montokapro databases)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages perl)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages))

(define-public postgresql-12
  (package
    (inherit postgresql)
    (name "postgresql")
    (version "12.3")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://ftp.postgresql.org/pub/source/v"
                                  version "/postgresql-" version ".tar.bz2"))
              (sha256
               (base32
                "0hfg3n7rlz96579cj3z1dh2idl15rh3wfvn8jl31jj4h2yk69vcl"))))))

(define-public postgresql-ivm
  (let ((commit "63ee2d5c7c541be5385c6d8751b7406d3f8ffd49")
        (revision "0"))
    (package
      (inherit postgresql)
      (name "postgresql")
      (version (git-version "IVM" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/sraoss/pgsql-ivm.git")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0g4v22z8ymix8v8j81hd6syd8d0yk62v70gb9cj8d1vvp80izb9a"))))
      (native-inputs
       `(("bison" ,bison)
         ("flex" ,flex)
         ("perl" ,perl))))))
