//! # Alexandria EVM
//!
//! EVM compatibility utilities for Cairo, including ABI encoding/decoding,
//! function selectors, and signature verification.

pub mod constants;
pub mod decoder;
pub mod encoder;
pub mod evm_enum;
pub mod evm_struct;
pub mod selector;
pub mod signature;

pub mod utils;
