pub mod bytes;
pub mod storage;

#[cfg(test)]
mod tests;
pub mod utils;

pub use bytes::{Bytes, BytesTrait, BytesIndex};
pub use storage::BytesStore;
