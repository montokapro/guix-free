(define-module (montokapro linux)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (gnu packages linux)
  #:use-module (guix packages))

(define-public linux-firmware
  (let ((commit "99d64b4f788c16e81b6550ef94f43c6b91cfad2d"))
    (package
      (name "linux-firmware")
      (version (string-append "2025.07.08-" (string-take commit 7)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                        (url (string-append
                              "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware"))
                        (commit commit)))
                (sha256
                 (base32
                  "1fnkbbgsdsg2pr146vhbjw6621s281xcgphfh8m9p2ils81pp7sc"))))
      (build-system trivial-build-system)
      (arguments
       `(#:modules ((guix build utils))
         #:builder
         (begin
           (use-modules (guix build utils))

           (let* ((source   (assoc-ref %build-inputs "source"))
                  (out      (assoc-ref %outputs "out"))
                  (firmware (string-append out "/lib/firmware")))
             (mkdir-p firmware)
             (copy-recursively source firmware)))))
      (home-page "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/about")
      (synopsis "Linux firmware")
      (description "Linux firmware")
      (license #f))))

;; This isn't "free" so probably is best suited for another repo
(define-public linux-vanilla
  (package
    (inherit linux-libre)
    (version "6.14.11")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://cdn.kernel.org/pub/linux/kernel/v6.x/"
                    "linux-" version ".tar.xz"))
              (sha256
               (base32
                "06rvydmc2yfspidnsay5hin3i8p4fxy3bvzwnry7gjf9dl5cs71z"))))))
