use alexandria_bytes::bytes::{Bytes, BytesTrait};
use alexandria_encoding::sol_abi::encode_as::SolAbiEncodeAsTrait;

/// Solidity Bytes Trait meant to provide an interface similar to Solidity's
/// bytesX types, like `bytes1`, `bytes2`, `bytes3`, ..., `bytes32`. Acts as
/// a wrapper around the `encode_as` to make it easier to understand and use.
/// Use like this:
/// `let bytes7Val: Bytes = SolBytesTrait::bytes7(0x01020304050607_u128);`
pub trait SolBytesTrait<T> {
    /// Creates 1-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 1 byte
    /// #### Returns
    /// * `Bytes` - 1-byte encoded representation
    fn bytes1(val: T) -> Bytes;
    /// Creates 2-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 2 bytes
    /// #### Returns
    /// * `Bytes` - 2-byte encoded representation
    fn bytes2(val: T) -> Bytes;
    /// Creates 3-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 3 bytes
    /// #### Returns
    /// * `Bytes` - 3-byte encoded representation
    fn bytes3(val: T) -> Bytes;
    /// Creates 4-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 4 bytes
    /// #### Returns
    /// * `Bytes` - 4-byte encoded representation
    fn bytes4(val: T) -> Bytes;
    /// Creates 5-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 5 bytes
    /// #### Returns
    /// * `Bytes` - 5-byte encoded representation
    fn bytes5(val: T) -> Bytes;
    /// Creates 6-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 6 bytes
    /// #### Returns
    /// * `Bytes` - 6-byte encoded representation
    fn bytes6(val: T) -> Bytes;
    /// Creates 7-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 7 bytes
    /// #### Returns
    /// * `Bytes` - 7-byte encoded representation
    fn bytes7(val: T) -> Bytes;
    /// Creates 8-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 8 bytes
    /// #### Returns
    /// * `Bytes` - 8-byte encoded representation
    fn bytes8(val: T) -> Bytes;
    /// Creates 9-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 9 bytes
    /// #### Returns
    /// * `Bytes` - 9-byte encoded representation
    fn bytes9(val: T) -> Bytes;
    /// Creates 10-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 10 bytes
    /// #### Returns
    /// * `Bytes` - 10-byte encoded representation
    fn bytes10(val: T) -> Bytes;
    /// Creates 11-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 11 bytes
    /// #### Returns
    /// * `Bytes` - 11-byte encoded representation
    fn bytes11(val: T) -> Bytes;
    /// Creates 12-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 12 bytes
    /// #### Returns
    /// * `Bytes` - 12-byte encoded representation
    fn bytes12(val: T) -> Bytes;
    /// Creates 13-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 13 bytes
    /// #### Returns
    /// * `Bytes` - 13-byte encoded representation
    fn bytes13(val: T) -> Bytes;
    /// Creates 14-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 14 bytes
    /// #### Returns
    /// * `Bytes` - 14-byte encoded representation
    fn bytes14(val: T) -> Bytes;
    /// Creates 15-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 15 bytes
    /// #### Returns
    /// * `Bytes` - 15-byte encoded representation
    fn bytes15(val: T) -> Bytes;
    /// Creates 16-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 16 bytes
    /// #### Returns
    /// * `Bytes` - 16-byte encoded representation
    fn bytes16(val: T) -> Bytes;
    /// Creates 17-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 17 bytes
    /// #### Returns
    /// * `Bytes` - 17-byte encoded representation
    fn bytes17(val: T) -> Bytes;
    /// Creates 18-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 18 bytes
    /// #### Returns
    /// * `Bytes` - 18-byte encoded representation
    fn bytes18(val: T) -> Bytes;
    /// Creates 19-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 19 bytes
    /// #### Returns
    /// * `Bytes` - 19-byte encoded representation
    fn bytes19(val: T) -> Bytes;
    /// Creates 20-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 20 bytes
    /// #### Returns
    /// * `Bytes` - 20-byte encoded representation
    fn bytes20(val: T) -> Bytes;
    /// Creates 21-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 21 bytes
    /// #### Returns
    /// * `Bytes` - 21-byte encoded representation
    fn bytes21(val: T) -> Bytes;
    /// Creates 22-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 22 bytes
    /// #### Returns
    /// * `Bytes` - 22-byte encoded representation
    fn bytes22(val: T) -> Bytes;
    /// Creates 23-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 23 bytes
    /// #### Returns
    /// * `Bytes` - 23-byte encoded representation
    fn bytes23(val: T) -> Bytes;
    /// Creates 24-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 24 bytes
    /// #### Returns
    /// * `Bytes` - 24-byte encoded representation
    fn bytes24(val: T) -> Bytes;
    /// Creates 25-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 25 bytes
    /// #### Returns
    /// * `Bytes` - 25-byte encoded representation
    fn bytes25(val: T) -> Bytes;
    /// Creates 26-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 26 bytes
    /// #### Returns
    /// * `Bytes` - 26-byte encoded representation
    fn bytes26(val: T) -> Bytes;
    /// Creates 27-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 27 bytes
    /// #### Returns
    /// * `Bytes` - 27-byte encoded representation
    fn bytes27(val: T) -> Bytes;
    /// Creates 28-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 28 bytes
    /// #### Returns
    /// * `Bytes` - 28-byte encoded representation
    fn bytes28(val: T) -> Bytes;
    /// Creates 29-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 29 bytes
    /// #### Returns
    /// * `Bytes` - 29-byte encoded representation
    fn bytes29(val: T) -> Bytes;
    /// Creates 30-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 30 bytes
    /// #### Returns
    /// * `Bytes` - 30-byte encoded representation
    fn bytes30(val: T) -> Bytes;
    /// Creates 31-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 31 bytes
    /// #### Returns
    /// * `Bytes` - 31-byte encoded representation
    fn bytes31(val: T) -> Bytes;
    /// Creates 32-byte representation of a value
    /// #### Arguments
    /// * `val` - The value to encode as 32 bytes
    /// #### Returns
    /// * `Bytes` - 32-byte encoded representation
    fn bytes32(val: T) -> Bytes;

    /// Creates n-byte representation of a value
    /// #### Arguments
    /// * `len` - The number of bytes to use for encoding
    /// * `val` - The value to encode
    /// #### Returns
    /// * `Bytes` - n-byte encoded representation
    fn bytes(len: usize, val: T) -> Bytes;
}

pub impl SolBytesImpl<T, +Drop<T>, +SolAbiEncodeAsTrait<T>> of SolBytesTrait<T> {
    fn bytes1(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(1, val)
    }
    fn bytes2(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(2, val)
    }
    fn bytes3(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(3, val)
    }
    fn bytes4(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(4, val)
    }
    fn bytes5(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(5, val)
    }
    fn bytes6(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(6, val)
    }
    fn bytes7(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(7, val)
    }
    fn bytes8(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(8, val)
    }
    fn bytes9(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(9, val)
    }
    fn bytes10(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(10, val)
    }
    fn bytes11(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(11, val)
    }
    fn bytes12(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(12, val)
    }
    fn bytes13(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(13, val)
    }
    fn bytes14(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(14, val)
    }
    fn bytes15(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(15, val)
    }
    fn bytes16(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(16, val)
    }
    fn bytes17(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(17, val)
    }
    fn bytes18(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(18, val)
    }
    fn bytes19(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(19, val)
    }
    fn bytes20(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(20, val)
    }
    fn bytes21(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(21, val)
    }
    fn bytes22(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(22, val)
    }
    fn bytes23(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(23, val)
    }
    fn bytes24(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(24, val)
    }
    fn bytes25(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(25, val)
    }
    fn bytes26(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(26, val)
    }
    fn bytes27(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(27, val)
    }
    fn bytes28(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(28, val)
    }
    fn bytes29(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(29, val)
    }
    fn bytes30(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(30, val)
    }
    fn bytes31(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(31, val)
    }
    fn bytes32(val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(32, val)
    }

    fn bytes(len: usize, val: T) -> Bytes {
        BytesTrait::new_empty().encode_as(len, val)
    }
}
