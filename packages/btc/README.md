# Cairo Bitcoin Utilities

This package provides a comprehensive set of Cairo modules for Bitcoin protocol operations and cryptographic primitives. It is designed to enable Bitcoin functionality on Starknet by providing utilities for:

- Bitcoin transaction encoding/decoding
- Bitcoin address generation and validation
- ECDSA and BIP-340 Schnorr signature verification
- BIP-322 message hashing
- Bitcoin key management and derivation
- Taproot operations and script trees
- Bitcoin hashing primitives

## Package Structure

```rust
packages/btc/
├── address.cairo           # Bitcoin address generation and validation
├── bip340.cairo           # BIP-340 Schnorr signatures for Taproot
├── bip322.cairo           # BIP-322 message hashing
├── decoder.cairo          # Bitcoin transaction decoding logic
├── encoder.cairo          # Bitcoin transaction encoding logic
├── hash.cairo             # Bitcoin cryptographic hash functions
├── keys.cairo             # Bitcoin key generation and management
├── legacy_signature.cairo # Bitcoin ECDSA signature operations
├── taproot.cairo          # Taproot address and script operations
├── types.cairo            # Bitcoin data structures and types
```

---

## 📦 Modules

### 1. `address.cairo` — Bitcoin Address Generation

This module provides functionality for generating and validating Bitcoin addresses across all standard formats.

#### Features

- Generates addresses for all Bitcoin types:
  - `P2PKH` (Pay to Public Key Hash) - Legacy addresses
  - `P2SH` (Pay to Script Hash) - Script addresses
  - `P2WPKH` (Pay to Witness Public Key Hash) - SegWit v0
  - `P2WSH` (Pay to Witness Script Hash) - SegWit v0 scripts
  - `P2TR` (Pay to Taproot) - SegWit v1 Taproot
- Supports mainnet, testnet, and regtest networks
- Address validation and format detection

#### Example

```rust
let private_key = create_private_key(0x1234..., BitcoinNetwork::Mainnet, true);
let address = private_key_to_address(private_key, BitcoinAddressType::P2WPKH);
```

---

### 2. `keys.cairo` — Bitcoin Key Management

This module handles Bitcoin private/public key operations using secp256k1 elliptic curve cryptography.

#### Features

- Private key generation and validation
- Public key derivation from private keys
- Compressed and uncompressed public key formats
- Key serialization to Bitcoin wire format
- Public key hash computation

#### Example

```rust
let private_key = create_private_key(key_value, BitcoinNetwork::Mainnet, true);
let public_key = private_key_to_public_key(private_key);
let pubkey_hash = public_key_hash(public_key);
```

---

### 3. `legacy_signature.cairo` — ECDSA Signature Operations

This module provides Bitcoin ECDSA signature verification and transaction signing capabilities.

#### Features

- ECDSA signature verification using Cairo's secp256k1 implementation
- Public key recovery from signatures
- DER signature format parsing
- Transaction signature hash generation
- Support for all SIGHASH types (`SIGHASH_ALL`, `SIGHASH_NONE`, etc.)

#### Example

```rust
let signature = Signature { r, s, y_parity };
let valid = verify_ecdsa_signature(message_hash, signature, public_key);
let tx_hash = create_signature_hash(transaction_data, SIGHASH_ALL);
```

---

### 4. `bip322.cairo` — BIP322 Message hash

This module implements BIP-322 message hasing used in Bitcoin Taproot.

#### Features

- BIP-322 message hash compute
- Compatible with Bitcoin's Taproot upgrade

#### Example

```rust
let pubkey: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
let message = "Message to sign";
let sighash_type = SighashType.ALL;
let message_hash = bip322_msg_hash_p2tr(sighash_type, pubkey, message);
// Process hash sig verify or other flows
```

```rust
let pubkey_x: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
let pubkey = BitcoinPublicKeyTrait::from_x_coordinate(pubkey_x, true)

let message = "Message to sign";
let sighash_type = SighashType.ALL;
let message_hash = bip322_msg_hash_p2wpkh(sighash_type, pubkey, message);
// Process hash sig verify or other flows
```

---

### 5. `bip340.cairo` — Schnorr Signatures

This module implements BIP-340 Schnorr signatures used in Bitcoin Taproot.

#### Features

- BIP-340 Schnorr signature verification
- Optimized implementation with pre-computed tag hashes
- Compatible with Bitcoin's Taproot upgrade
- Deterministic signature validation

#### Example

```rust
let pubkey: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
let signature = Signature { r, s, y_parity };
verify_bip340_signature(message, signature, pubkey);
```

---

### 6. `taproot.cairo` — Taproot Operations

This module provides Taproot address generation and script tree operations for Bitcoin's latest upgrade.

#### Features

- Taproot key-path spending addresses
- Script-path spending with Merkle trees
- Key tweaking with script commitments
- Tagged hash computation for Taproot
- Script tree construction and validation

#### Example

```rust
let internal_key: u256 = 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798;
let output_key = create_key_path_output(internal_key);
let script_tree = create_script_tree(scripts.span());
```

---

### 7. `encoder.cairo` / `decoder.cairo` — Transaction Processing

These modules handle Bitcoin transaction serialization and deserialization in the standard Bitcoin wire format.

#### Features

- **Encoder**: Serializes Bitcoin transactions to raw bytes

  - Legacy and SegWit transaction formats
  - Compact size encoding for variable-length fields
  - Little-endian integer encoding
  - Witness data serialization

- **Decoder**: Parses Bitcoin transactions from raw bytes
  - Automatic SegWit detection
  - Compact size decoding
  - Transaction input/output parsing
  - Witness data extraction

#### Example

```rust
// Encoding
let mut encoder = TransactionEncoderTrait::new();
let encoded_data = encoder.encode_transaction(transaction);

// Decoding
let mut decoder = TransactionDecoderTrait::new(raw_data);
let decoded_tx = decoder.decode_transaction();
```

---

### 8. `hash.cairo` — Cryptographic Hashing

This module provides Bitcoin-specific cryptographic hash functions.

#### Features

- `hash160` (RIPEMD160 of SHA256) for address generation
- `hash256` (double SHA256) for transaction hashing
- Merkle tree hash computation
- Script hash generation

#### Example

```rust
let pubkey_bytes = public_key_to_bytes(public_key);
let pubkey_hash = hash160(pubkey_bytes.span());
let tx_hash = hash256(transaction_data.span());
```

---

### 9. `types.cairo` — Bitcoin Data Structures

This module defines all Bitcoin data structures and type definitions.

#### Key Types

- `BitcoinPublicKey` - 33/65 byte public key representation
- `BitcoinPrivateKey` - Private key with network and compression info
- `BitcoinAddress` - Complete address with type and script data
- `BitcoinTransaction` - Full transaction structure
- `TransactionInput`/`TransactionOutput` - Transaction components
- Network and address type enums

---

## 🛠 Requirements

Make sure to import the relevant modules in your own contract/project:

```rust
use alexandria_btc::address;
use alexandria_btc::keys;
use alexandria_btc::legacy_signature;
use alexandria_btc::bip322;
use alexandria_btc::bip340;
use alexandria_btc::taproot;
use alexandria_btc::encoder;
use alexandria_btc::decoder;
use alexandria_btc::hash;
use alexandria_btc::types::{BitcoinNetwork, BitcoinAddressType, BitcoinPublicKey};
```

---

## 🔧 Common Workflows

### Generate a Bitcoin Address

```rust
// 1. Create or import private key
let private_key = create_private_key(
    0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef,
    BitcoinNetwork::Mainnet,
    true  // compressed
);

// 2. Generate address for desired type
let address = private_key_to_address(private_key, BitcoinAddressType::P2WPKH);
```

### Verify a Bitcoin Transaction Signature

```rust
// 1. Parse signature and public key
let signature = parse_der_signature(der_bytes.span()).unwrap();
let public_key = BitcoinPublicKeyTrait::from_hex(pubkey_hex);

// 2. Create transaction hash
let sighash = create_signature_hash(tx_data.span(), SIGHASH_ALL);

// 3. Verify signature
let valid = verify_ecdsa_signature(sighash, signature, public_key);
```

### Decode a Bitcoin Transaction

```rust
// 1. Create decoder with raw transaction bytes
let mut decoder = TransactionDecoderTrait::new(raw_tx_data);

// 2. Decode transaction
let transaction = decoder.decode_transaction();

// 3. Access transaction components
let inputs = transaction.inputs;
let outputs = transaction.outputs;
let is_segwit = transaction.is_segwit;
```

---
