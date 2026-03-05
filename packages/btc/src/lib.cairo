//! # Alexandria BTC
//!
//! Bitcoin utilities for Cairo, including address generation, BIP-322/340 signature
//! verification, transaction encoding/decoding, and key management.

pub mod address;
pub mod bip322;
pub mod bip340;
pub mod decoder;
pub mod encoder;
pub mod hash;
pub mod keys;
pub mod legacy_signature;
pub mod taproot;
pub mod types;
