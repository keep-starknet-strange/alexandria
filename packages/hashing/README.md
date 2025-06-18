# Cairo Hashing Utilities

This package provides optimized cryptographic hash function implementations for Cairo, designed for use in blockchain and cryptographic applications on Starknet.

**Note**: The RIPEMD-160 implementation is based on the original work by [j1mbo64](https://github.com/j1mbo64/ripemd160_cairo), enhanced with performance optimizations and comprehensive testing.

## Package Structure

```
packages/hashing/
├── ripemd160.cairo    # RIPEMD-160 hash function implementation
└── tests/
    └── ripemd160_tests.cairo    # Comprehensive test suite
```

---

## 📦 Modules

### 1. `ripemd160.cairo` — RIPEMD-160 Hash Function

A complete, optimized implementation of the RIPEMD-160 cryptographic hash function that produces 160-bit (20-byte) hash digests.

#### Features

- **Standards Compliant**: Full implementation according to RIPEMD-160 specification
- **Multiple Output Formats**: 
  - `u256` for numerical operations
  - `ByteArray` for byte-level processing  
  - `Array<u32>` for word-level access

---

## 🚀 Usage Examples

### Basic Hashing

```rust
use alexandria_hashing::ripemd160::{ripemd160_hash, ripemd160_context_as_u256};

// Hash a simple message
let message: ByteArray = "Hello, World!";
let hash_context = ripemd160_hash(@message);
let hash_value = ripemd160_context_as_u256(@hash_context);
```

### Multiple Output Formats

```rust
use alexandria_hashing::ripemd160::{
    ripemd160_hash, 
    ripemd160_context_as_u256, 
    ripemd160_context_as_bytes,
    ripemd160_context_as_array
};

let data: ByteArray = "example data";
let ctx = ripemd160_hash(@data);

// Get hash as different formats
let hash_u256 = ripemd160_context_as_u256(@ctx);      // For numerical operations
let hash_bytes = ripemd160_context_as_bytes(@ctx);    // For byte manipulation
let hash_array = ripemd160_context_as_array(@ctx);    // For word-level access

assert_eq!(hash_bytes.len(), 20);  // 160 bits = 20 bytes
assert_eq!(hash_array.len(), 5);   // 160 bits = 5 × 32-bit words
```

### Ethereum-Style Function Selectors

```rust
// Hash function signatures for Ethereum compatibility
let signature: ByteArray = "transfer(address,uint256)";
let ctx = ripemd160_hash(@signature);
let selector = ripemd160_context_as_u256(@ctx);
```


---


## 📚 References

- [Original Cairo Implementation](https://github.com/j1mbo64/ripemd160_cairo) - Base implementation by j1mbo64
- [RIPEMD-160 Specification](https://homes.esat.kuleuven.be/~bosselae/ripemd160.html)
- [RFC 2104: HMAC](https://tools.ietf.org/html/rfc2104) (for HMAC-RIPEMD160)
- [Cryptographic Hash Algorithm Reference](https://csrc.nist.gov/projects/hash-functions)

---

## 🛠 Requirements

```rust
use alexandria_hashing::ripemd160::{
    RIPEMD160Context,
    ripemd160_hash,
    ripemd160_context_as_u256,
    ripemd160_context_as_bytes,
    ripemd160_context_as_array
};
```

---