# Cairo BTC Utilities

This package provides a set of Cairo modules for interacting with Bitcoin-compatible cryptographic primitives. It is designed to ease interoperability between Starknet and Bitcoin by providing utilities for:

- Verifying Bitcoin legacy `secp256k1` signatures
- Verifying Bitcoin BIP340 `schnorr` signatures

## Package Structure

```rust
packages/btc/
├── bip340_signature.cairo   # Bitcoin bip340 (schnorr) signature verification
├── legacy_signature.cairo   # Bitcoin legacy (secp256k1) signature verification
```

---

## 📦 Modules

### 1. `bip340_signature.cairo` — Bitcoin BIP340 Signature Verification

This module enables signature validation from Bitcoin `schnorr` signatures, using Cairo's native `secp256k1` implementation.

#### Features

- Verifies `r`, `s`, and `v` (y_parity) signature format
- Recovers public key
- Compares against the expected public key

#### Example

```rust
let sig = Signature { r, s, y_parity };
verify_legacy_signature(msg_hash, sig, pub_key);
```

---

### . `legacy_signature.cairo` — Bitcoin Legacy Signature Verification

This module enables signature validation from Bitcoin `secp256k1` signatures, using Cairo's native `secp256k1` implementation.

#### Features

- Verifies `r`, `s` signature format
- Recovers public key
- Compares against the expected public key

#### Example

```rust
let sig = Signature { r, s, y_parity };
verify_bip340_signature(msg_hash, sig, pub_key);
```

---

## 🛠 Requirements

Make sure to import the relevant modules in your own contract/project:

```rust
use alexandria_btc::bip340_signature;
use alexandria_btc::legacy_signature;
```

---
