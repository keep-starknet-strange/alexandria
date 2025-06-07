# Cairo EVM Utilities

This package provides a set of Cairo modules for interacting with Ethereum-compatible calldata and cryptographic primitives. It is designed to ease interoperability between Starknet and Ethereum by providing utilities for:

- Decoding EVM calldata
- Computing function selectors (EVM-style)
- Verifying Ethereum `secp256k1` signatures

## Package Structure

```rust
packages/evm/
├── decoder.cairo     # EVM calldata decoding logic
├── selector.cairo    # Function selector (keccak-based) computation
├── signature.cairo   # Ethereum signature verification & address recovery
```

---

## 📦 Modules

### 1. `decoder.cairo` — EVM Calldata Decoder

This module provides type-aware decoding of Ethereum-style calldata into `felt252` spans.

#### Features

- Decodes:
  - Static types: `uint`, `int`, `address`, `bool`
  - Dynamic types: `bytes`, `string`, dynamic arrays
  - Composite types: `tuple`, `fixed bytes`, `function selector`
- Handles dynamic offset resolution in calldata
- Returns `Span<felt252>`

#### Example

```rust
let types = array![EVMTypes::Uint(256), EVMTypes::Array].span();
let decoded: Span<felt252> = ctx.decode(types);
```

---

### 2. `selector.cairo` — Keccak Function Selector

This module computes EVM-style function selectors based on a hashed function signature.

#### Logic

- Applies Keccak-256 to a byte-encoded function signature
- Returns the first 4 bytes (most significant, big-endian) as `felt252`

#### Example

```rust
let data: ByteArray = "transfer(address,uint256)";
let selector_value = SelectorTrait::compute_selector(data);
```

---

### 3. `signature.cairo` — Ethereum Signature Verification

This module enables signature validation and address recovery from Ethereum `secp256k1` signatures, using Cairo's native `secp256k1` implementation.

#### Features

- Verifies `r`, `s`, and `v` (y_parity) signature format
- Recovers public key and computes Ethereum address
- Compares against the expected signer

#### Example

```rust
let sig = Signature { r, s, y_parity };
verify_eth_signature(msg_hash, sig, expected_eth_address);
```

---

## 🛠 Requirements

Make sure to import the relevant modules in your own contract/project:

```rust
use alexandria_evm::decoder;
use alexandria_evm::selector;
use alexandria_evm::signature;
```

---
