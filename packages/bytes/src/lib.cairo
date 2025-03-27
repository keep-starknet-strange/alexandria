pub mod byte_array_ext;
pub mod bytes;
pub mod storage;

#[cfg(test)]
mod tests;
pub mod utils;


pub use bytes::{Bytes, BytesIndex, BytesTrait};
pub use storage::BytesStore;
