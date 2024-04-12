use alexandria_bytes::bytes::{Bytes, BytesTrait};
use alexandria_encoding::sol_abi::encode_as::SolAbiEncodeAsTrait;

/// Solidity Bytes Trait meant to provide an interface similar to Solidity's
/// bytesX types, like `bytes1`, `bytes2`, `bytes3`, ..., `bytes32`. Acts as
/// a wrapper around the `encode_as` to make it easier to understand and use.
/// Use like this:
/// `let bytes7Val: Bytes = SolBytesTrait::bytes7(0x01020304050607_u128);`
pub trait SolBytesTrait<T> {
    fn bytes1(val: T) -> Bytes;
    fn bytes2(val: T) -> Bytes;
    fn bytes3(val: T) -> Bytes;
    fn bytes4(val: T) -> Bytes;
    fn bytes5(val: T) -> Bytes;
    fn bytes6(val: T) -> Bytes;
    fn bytes7(val: T) -> Bytes;
    fn bytes8(val: T) -> Bytes;
    fn bytes9(val: T) -> Bytes;
    fn bytes10(val: T) -> Bytes;
    fn bytes11(val: T) -> Bytes;
    fn bytes12(val: T) -> Bytes;
    fn bytes13(val: T) -> Bytes;
    fn bytes14(val: T) -> Bytes;
    fn bytes15(val: T) -> Bytes;
    fn bytes16(val: T) -> Bytes;
    fn bytes17(val: T) -> Bytes;
    fn bytes18(val: T) -> Bytes;
    fn bytes19(val: T) -> Bytes;
    fn bytes20(val: T) -> Bytes;
    fn bytes21(val: T) -> Bytes;
    fn bytes22(val: T) -> Bytes;
    fn bytes23(val: T) -> Bytes;
    fn bytes24(val: T) -> Bytes;
    fn bytes25(val: T) -> Bytes;
    fn bytes26(val: T) -> Bytes;
    fn bytes27(val: T) -> Bytes;
    fn bytes28(val: T) -> Bytes;
    fn bytes29(val: T) -> Bytes;
    fn bytes30(val: T) -> Bytes;
    fn bytes31(val: T) -> Bytes;
    fn bytes32(val: T) -> Bytes;

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
