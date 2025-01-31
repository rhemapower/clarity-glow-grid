;; Tutorial Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-found (err u404))
(define-constant err-unauthorized (err u401))
(define-constant err-invalid-price (err u402))

;; Data Variables
(define-map tutorials uint 
  {
    creator: principal,
    title: (string-utf8 128),
    description: (string-utf8 512),
    content-hash: (string-utf8 64),
    price: uint,
    category: (string-utf8 32),
    created-at: uint,
    updated-at: (optional uint)
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
  (begin
    (asserts! (>= price u0) err-invalid-price)
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
          created-at: block-height,
          updated-at: none
        }
      )
      (var-set tutorial-counter tutorial-id)
      (ok tutorial-id)
    )
  )
)

;; Get tutorial by id
(define-read-only (get-tutorial (tutorial-id uint))
  (match (map-get? tutorials tutorial-id)
    tutorial (ok tutorial)
    err-not-found
  )
)

;; Update tutorial 
(define-public (update-tutorial
  (tutorial-id uint)
  (title (string-utf8 128))
  (description (string-utf8 512))
  (content-hash (string-utf8 64))
  (price uint)
  (category (string-utf8 32)))
  (let ((tutorial (unwrap! (get-tutorial tutorial-id) err-not-found)))
    (asserts! (is-eq tx-sender (get creator tutorial)) err-unauthorized)
    (asserts! (>= price u0) err-invalid-price)
    (ok (map-set tutorials tutorial-id
      (merge tutorial {
        title: title,
        description: description,
        content-hash: content-hash,
        price: price,
        category: category,
        updated-at: (some block-height)
      })
    ))
  )
)
