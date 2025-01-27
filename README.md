# Stacks Talent Marketplace Smart Contract

## Overview

The Talent Marketplace Smart Contract facilitates an ecosystem for talents to monetize their skills through auctions. Talents can register, create auctions, and interact with bidders in a secure, decentralized environment. The contract ensures fairness and transparency through well-defined rules and error handling mechanisms.

---

## Key Features

### Registration

- **Talents** can register themselves, enabling them to create auctions and manage their profiles.
- Each talent profile includes fields such as verification status, rating, total earnings, auctions completed, and the registration block height.

### Auctions

- **Create Auctions**: Talents can auction their services with a title, description, category, price, and duration.
- **Place Bids**: Users can bid on active auctions. Each bid must surpass the previous bid by at least 5%.
- **Complete Auctions**: Once an auction ends, the talent can finalize it, transferring the winning bid amount to their account.
- Refunds are processed for previous bidders when a new bid is placed.

### Fees

- A 5% fee is applied to all successful bids, collected by the contract owner.

### Validation and Error Handling

- Comprehensive error handling ensures a smooth user experience, covering scenarios such as invalid input, insufficient funds, unauthorized actions, and auction state violations.

---

## Constants

| Name                   | Description                                   | Value                     |
| ---------------------- | --------------------------------------------- | ------------------------- |
| `CONTRACT-OWNER`       | Address of the contract owner.                | `tx-sender`               |
| `FEE-RATE`             | Fee rate for each transaction (basis points). | `u50` (5%)                |
| `MIN-AUCTION-DURATION` | Minimum duration for an auction (blocks).     | `u144` (1 day)            |
| `MAX-AUCTION-DURATION` | Maximum duration for an auction (blocks).     | `u4320` (30 days)         |
| `MIN-PRICE`            | Minimum auction price in uSTX.                | `u1000000` (1 STX)        |
| `MAX-PRICE`            | Maximum auction price in uSTX.                | `u1000000000000` (1M STX) |

---

## Errors

| Error Code               | Description                                |
| ------------------------ | ------------------------------------------ |
| `ERR-NOT-AUTHORIZED`     | Unauthorized action attempted.             |
| `ERR-INVALID-STATE`      | Invalid state for the requested operation. |
| `ERR-NOT-FOUND`          | Resource not found.                        |
| `ERR-INVALID-DURATION`   | Auction duration is outside valid bounds.  |
| `ERR-INSUFFICIENT-FUNDS` | Insufficient funds for the operation.      |
| `ERR-ALREADY-REGISTERED` | Talent is already registered.              |
| `ERR-INVALID-PRICE`      | Price is outside the valid range.          |
| `ERR-AUCTION-EXPIRED`    | Auction has already expired.               |
| `ERR-AUCTION-NOT-ENDED`  | Auction has not yet ended.                 |
| `ERR-SELF-BIDDING`       | Self-bidding is not allowed.               |
| `ERR-INVALID-BID`        | Bid is invalid or too low.                 |
| `ERR-EMPTY-TITLE`        | Auction title is empty.                    |
| `ERR-EMPTY-DESCRIPTION`  | Auction description is empty.              |
| `ERR-EMPTY-CATEGORY`     | Auction category is empty.                 |
| `ERR-AUCTION-NOT-ACTIVE` | Auction is not currently active.           |

---

## Data Structures

### Talent Map

```clarity
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
```

### Auction Map

```clarity
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
```

---

## Functions

### Public Functions

#### `register-talent`

Registers a new talent if not already registered.

#### `create-auction`

Creates a new auction with the provided title, description, category, price, and duration.

#### `place-bid`

Places a bid on an active auction. Refunds the previous highest bidder and updates auction details.

#### `complete-auction`

Finalizes an auction after its end height. Transfers funds to the talent and updates statistics.

### Read-only Functions

#### `get-auction`

Retrieves details of a specific auction by ID.

#### `get-talent-info`

Retrieves information about a specific talent.

#### `get-contract-stats`

Provides global statistics such as total auctions completed and total fees collected.

#### `is-registered`

Checks if a given address is registered as a talent.

#### `can-complete-auction`

Determines if an auction is eligible for completion.

---

## Usage Example

### Registering a Talent

```clarity
(contract-call? .talent-marketplace register-talent)
```

### Creating an Auction

```clarity
(contract-call? .talent-marketplace create-auction
    "Website Design"
    "Design a modern website in 7 days."
    "Web Development"
    u5000000
    u288
)
```

### Placing a Bid

```clarity
(contract-call? .talent-marketplace place-bid
    u1
    u6000000
)
```

### Completing an Auction

```clarity
(contract-call? .talent-marketplace complete-auction u1)
```

---

## Deployment and Testing

- Deploy the contract to the Stacks blockchain.
- Interact using the Clarity CLI or compatible wallets.
- Thoroughly test edge cases to ensure robustness and security.

---

## Security Considerations

- Ensure private keys and sensitive data are securely managed.
- Audit the contract for vulnerabilities such as re-entrancy and overflow issues.
- Validate all inputs rigorously to prevent abuse or exploits.

---

## Future Enhancements

- **Rating System**: Allow users to rate talents post-auction.
- **Auction Extensions**: Enable automatic time extensions for last-minute bids.
- **Multi-category Auctions**: Support auctions across multiple categories.

---

## License

This contract is open-source and available under the MIT License.

