;; Enhanced Talent Marketplace Contract with Error Handling

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant FEE-RATE u50) ;; 5% fee (basis points)
(define-constant MIN-AUCTION-DURATION u144) ;; Minimum 1 day (144 blocks)
(define-constant MAX-AUCTION-DURATION u4320) ;; Maximum 30 days (4320 blocks)
(define-constant MIN-PRICE u1000000) ;; Minimum price in uSTX (1 STX)
(define-constant MAX-PRICE u1000000000000) ;; Maximum price in uSTX (1,000,000 STX)

;; Errors
(define-constant ERR-NOT-AUTHORIZED (err u1))
(define-constant ERR-INVALID-STATE (err u2))
(define-constant ERR-NOT-FOUND (err u3))
(define-constant ERR-INVALID-DURATION (err u4))
(define-constant ERR-INSUFFICIENT-FUNDS (err u5))
(define-constant ERR-ALREADY-REGISTERED (err u6))
(define-constant ERR-INVALID-PRICE (err u7))
(define-constant ERR-AUCTION-EXPIRED (err u8))
(define-constant ERR-AUCTION-NOT-ENDED (err u9))
(define-constant ERR-SELF-BIDDING (err u10))
(define-constant ERR-INVALID-BID (err u11))
(define-constant ERR-EMPTY-TITLE (err u12))
(define-constant ERR-EMPTY-DESCRIPTION (err u13))
(define-constant ERR-EMPTY-CATEGORY (err u14))
(define-constant ERR-AUCTION-NOT-ACTIVE (err u15))

;; Data Variables
(define-data-var next-auction-id uint u1)
(define-data-var total-auctions-completed uint u0)
(define-data-var total-fees-collected uint u0)

;; Maps
(define-map talents 
    principal 
    { 
        verified: bool,
        rating: uint,
        total-earnings: uint,
        auctions-completed: uint,
        registration-height: uint
    }
)

(define-map auctions 
    uint 
    {
        talent: principal,
        title: (string-ascii 100),
        description: (string-ascii 500),
        price: uint,
        end-height: uint,
        highest-bid: uint,
        highest-bidder: (optional principal),
        status: (string-ascii 10),
        category: (string-ascii 50),
        creation-height: uint
    }
)

;; Private Functions
(define-private (is-valid-string (str (string-ascii 500))) 
    (> (len str) u0)
)

(define-private (check-auction-active (auction-id uint))
    (match (map-get? auctions auction-id)
        auction (is-eq (get status auction) "active")
        false
    )
)