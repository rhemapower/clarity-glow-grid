;; Tutorial Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-found (err u404))
(define-constant err-unauthorized (err u401))

;; Data Variables
(define-map tutorials uint 
  {
    creator: principal,
    title: (string-utf8 128),
    description: (string-utf8 512),
    content-hash: (string-utf8 64),
    price: uint,
    category: (string-utf8 32),
    created-at: uint
  }
)

(define-data-var tutorial-counter uint u0)

;; Create new tutorial
(define-public (create-tutorial 
  (title (string-utf8 128))
  (description (string-utf8 512))
  (content-hash (string-utf8 64))
  (price uint)
  (category (string-utf8 32)))
  (let 
    (
      (tutorial-id (+ (var-get tutorial-counter) u1))
    )
    (map-set tutorials tutorial-id
      {
        creator: tx-sender,
        title: title,
        description: description,
        content-hash: content-hash,
        price: price,
        category: category,
        created-at: block-height
      }
    )
    (var-set tutorial-counter tutorial-id)
    (ok tutorial-id)
  )
)

;; Get tutorial by id
(define-read-only (get-tutorial (tutorial-id uint))
  (match (map-get? tutorials tutorial-id)
    tutorial (ok tutorial)
    err-not-found
  )
)
