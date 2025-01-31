;; Creator Profile Contract

;; Data Variables
(define-map creators principal 
  {
    name: (string-utf8 64),
    bio: (string-utf8 256),
    expertise: (string-utf8 64),
    verified: bool,
    total-tutorials: uint,
    rating: uint
  }
)

;; Error constants
(define-constant err-not-found (err u404))
(define-constant err-already-registered (err u100))

;; Register new creator
(define-public (register-creator 
  (name (string-utf8 64))
  (bio (string-utf8 256))
  (expertise (string-utf8 64)))
  (let ((creator-exists (get-creator-by-id tx-sender)))
    (if (is-ok creator-exists)
      err-already-registered
      (ok (map-set creators tx-sender {
        name: name,
        bio: bio,
        expertise: expertise,
        verified: false,
        total-tutorials: u0,
        rating: u0
      }))))
)

;; Get creator profile
(define-read-only (get-creator-by-id (creator-id principal))
  (match (map-get? creators creator-id)
    profile (ok profile)
    err-not-found
  )
)

;; Update creator profile
(define-public (update-profile
  (name (string-utf8 64))
  (bio (string-utf8 256))
  (expertise (string-utf8 64)))
  (let ((creator (unwrap! (get-creator-by-id tx-sender) err-not-found)))
    (ok (map-set creators tx-sender
      (merge creator {
        name: name,
        bio: bio,
        expertise: expertise
      })
    ))
  )
)
