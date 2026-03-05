//! # Alexandria Bytes
//!
//! Byte manipulation utilities for Cairo, including a `Bytes` type (similar to Solidity bytes),
//! bit arrays, byte readers, and byte array extensions.

pub mod bit_array;
pub mod byte_appender;
pub mod byte_array_ext;
pub mod byte_reader;
pub mod bytes;
pub mod reversible;
pub mod storage;

pub mod utils;


pub use bytes::{Bytes, BytesIndex, BytesTrait};
pub use storage::BytesStore;
