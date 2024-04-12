use alexandria_bytes::{Bytes, BytesTrait};
use alexandria_math::{U128BitShift, U256BitShift};

/// Encode trait for arbitrarily sized encodings, meant to allow easy bytesX
/// type encodings. Encode the value `x` as `Bytes` with a specific `byteSize`.
/// Allows chaining of encode/encode_as calls to build up a `Bytes` object.
/// Use like :
/// `let encoded: Bytes = Bytes::new_empty().encode_as(32, x).encode_as(13, y)...`
pub trait SolAbiEncodeAsTrait<T> {
    fn encode_as(self: Bytes, byteSize: usize, x: T) -> Bytes;
}

/// Encode as from int types
/// Integers are encoded as `byteSize` bytes, which are right-aligned/left-padded Big-endian.

pub impl SolAbiEncodeAsU256 of SolAbiEncodeAsTrait<u256> {
    fn encode_as(mut self: Bytes, byteSize: usize, mut x: u256) -> Bytes {
        assert!(byteSize <= 32, "byteSize must be <= 32");
        x = U256BitShift::shl(x, 8 * (32 - byteSize.into()));
        let bytesRes: Bytes = BytesTrait::new(byteSize, array![x.high, x.low]);
        self.concat(@bytesRes);
        self
    }
}

pub impl SolAbiEncodeAsU128 of SolAbiEncodeAsTrait<u128> {
    fn encode_as(mut self: Bytes, byteSize: usize, mut x: u128) -> Bytes {
        if byteSize > 16 {
            self = self.encode_as(byteSize, Into::<u128, u256>::into(x));
        } else {
            x = U128BitShift::shl(x, 8 * (16 - byteSize.into()));
            let bytesRes: Bytes = BytesTrait::new(byteSize, array![x]);
            self.concat(@bytesRes);
        }
        self
    }
}

pub impl SolAbiEncodeAsFelt252 of SolAbiEncodeAsTrait<felt252> {
    fn encode_as(mut self: Bytes, byteSize: usize, x: felt252) -> Bytes {
        assert!(byteSize <= 32, "byteSize must be <= 32");
        let mut x: u256 = x.into();
        x = U256BitShift::shl(x, 8 * (32 - byteSize.into()));
        let bytesRes: Bytes = BytesTrait::new(byteSize, array![x.high, x.low]);
        self.concat(@bytesRes);
        self
    }
}

pub impl SolAbiEncodeAsBytes31 of SolAbiEncodeAsTrait<bytes31> {
    fn encode_as(mut self: Bytes, byteSize: usize, x: bytes31) -> Bytes {
        assert!(byteSize <= 32, "byteSize must be <= 32");
        let mut x: u256 = x.into();
        x = U256BitShift::shl(x, 8 * (32 - byteSize.into()));
        let bytesRes: Bytes = BytesTrait::new(byteSize, array![x.high, x.low]);
        self.concat(@bytesRes);
        self
    }
}

/// Encode as from bytes types
/// Bytes are encoded as `byteSize` bytes, which are left-aligned/right-padded.

pub impl SolAbiEncodeAsBytes of SolAbiEncodeAsTrait<Bytes> {
    fn encode_as(mut self: Bytes, byteSize: usize, x: Bytes) -> Bytes {
        self.concat(@BytesTrait::new(byteSize, x.data()));
        self
    }
}

pub impl SolAbiEncodeAsByteArray of SolAbiEncodeAsTrait<ByteArray> {
    fn encode_as(mut self: Bytes, byteSize: usize, x: ByteArray) -> Bytes {
        let x: Bytes = x.into();
        self.concat(@BytesTrait::new(byteSize, x.data()));
        self
    }
}
