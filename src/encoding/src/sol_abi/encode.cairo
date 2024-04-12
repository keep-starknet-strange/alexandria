use alexandria_bytes::{Bytes, BytesTrait};
use core::traits::TryInto;
use starknet::{ContractAddress, EthAddress};

/// Encode selector trait meant to provide an interface similar to Solidity's
/// abi.encodeWithSelector function. It is meant to be the first call in an
/// encode chain, adding the function selector to the encoded data. Value encoded
/// is only 4 bytes long representing the function selector.
/// Use like this:
/// BytesTrait::new_empty().encode_selector(selector).encode(arg1).encode(arg2)...
pub trait SolAbiEncodeSelectorTrait {
    fn encode_selector(self: Bytes, selector: u32) -> Bytes;
}

pub impl SolAbiEncodeSelector of SolAbiEncodeSelectorTrait {
    fn encode_selector(mut self: Bytes, selector: u32) -> Bytes {
        self.append_u32(selector);
        self
    }
}

/// Encode trait meant to provide an interface similar to Solidity's abi.encode
/// function. It is meant to allow chaining of encode calls to build up a `Bytes`
/// object. Values are encoded in 32 bytes chunks, and padding is added as necessary.
/// Also provides a packed version of the encoding similar to Solidity's
/// abi.encodePacked, which does not add padding.
/// Use like this: BytesTrait::new_empty().encode(arg1).encode(arg2)...
/// Or like this: BytesTrait::new_empty().encode_packed(arg1).encode_packed(arg2)...
pub trait SolAbiEncodeTrait<T> {
    fn encode(self: Bytes, x: T) -> Bytes;
    fn encode_packed(self: Bytes, x: T) -> Bytes;
}

/// Encode int types
/// Integers are encoded as 32 bytes long, which are right-aligned/left-padded Big-endian.
/// Packed encodings are not padded and only append the bytes of the value based on type.

pub impl SolAbiEncodeU8 of SolAbiEncodeTrait<u8> {
    fn encode(mut self: Bytes, x: u8) -> Bytes {
        self.append_u256(x.into());
        self
    }

    fn encode_packed(mut self: Bytes, x: u8) -> Bytes {
        self.append_u8(x);
        self
    }
}

pub impl SolAbiEncodeU16 of SolAbiEncodeTrait<u16> {
    fn encode(mut self: Bytes, x: u16) -> Bytes {
        self.append_u256(x.into());
        self
    }

    fn encode_packed(mut self: Bytes, x: u16) -> Bytes {
        self.append_u16(x);
        self
    }
}

pub impl SolAbiEncodeU32 of SolAbiEncodeTrait<u32> {
    fn encode(mut self: Bytes, x: u32) -> Bytes {
        self.append_u256(x.into());
        self
    }

    fn encode_packed(mut self: Bytes, x: u32) -> Bytes {
        self.append_u32(x);
        self
    }
}

pub impl SolAbiEncodeU64 of SolAbiEncodeTrait<u64> {
    fn encode(mut self: Bytes, x: u64) -> Bytes {
        self.append_u256(x.into());
        self
    }

    fn encode_packed(mut self: Bytes, x: u64) -> Bytes {
        self.append_u64(x);
        self
    }
}

pub impl SolAbiEncodeU128 of SolAbiEncodeTrait<u128> {
    fn encode(mut self: Bytes, x: u128) -> Bytes {
        self.append_u256(x.into());
        self
    }

    fn encode_packed(mut self: Bytes, x: u128) -> Bytes {
        self.append_u128(x);
        self
    }
}

pub impl SolAbiEncodeU256 of SolAbiEncodeTrait<u256> {
    fn encode(mut self: Bytes, x: u256) -> Bytes {
        self.append_u256(x);
        self
    }

    fn encode_packed(mut self: Bytes, x: u256) -> Bytes {
        self.append_u256(x);
        self
    }
}

/// Encode other primitives
/// Primitives are encoded as 32 bytes long, which are right-aligned/left-padded Big-endian.
/// Packed encodings are not padded and only append the bytes of the value based on type.

pub impl SolAbiEncodeBool of SolAbiEncodeTrait<bool> {
    fn encode(mut self: Bytes, x: bool) -> Bytes {
        if x {
            self.append_u256(1);
        } else {
            self.append_u256(0);
        }
        self
    }

    fn encode_packed(mut self: Bytes, x: bool) -> Bytes {
        if x {
            self.append_u8(1);
        } else {
            self.append_u8(0);
        }
        self
    }
}

pub impl SolAbiEncodeFelt252 of SolAbiEncodeTrait<felt252> {
    fn encode(mut self: Bytes, x: felt252) -> Bytes {
        self.append_u256(x.into());
        self
    }

    fn encode_packed(mut self: Bytes, x: felt252) -> Bytes {
        self.append_felt252(x);
        self
    }
}

pub impl SolAbiEncodeBytes31 of SolAbiEncodeTrait<bytes31> {
    fn encode(mut self: Bytes, x: bytes31) -> Bytes {
        self.append_u256(x.into());
        self
    }

    fn encode_packed(mut self: Bytes, x: bytes31) -> Bytes {
        self.append_bytes31(x);
        self
    }
}

/// Encode byte types
/// Bytes are encoded as 32 bytes long, which are left-aligned/right-padded.
/// Packed encodings are not padded and only append the bytes up to the length of the value.

pub impl SolAbiEncodeBytes of SolAbiEncodeTrait<Bytes> {
    fn encode(mut self: Bytes, mut x: Bytes) -> Bytes {
        self.concat(@x);
        self.concat(@BytesTrait::zero(32 - (x.size() % 32)));
        self
    }

    fn encode_packed(mut self: Bytes, x: Bytes) -> Bytes {
        self.concat(@x);
        self
    }
}

pub impl SolAbiEncodeByteArray of SolAbiEncodeTrait<ByteArray> {
    fn encode(mut self: Bytes, x: ByteArray) -> Bytes {
        let x_len: usize = x.len();
        self.concat(@x.into());
        self.concat(@BytesTrait::zero(32 - (x_len % 32)));
        self
    }

    fn encode_packed(mut self: Bytes, x: ByteArray) -> Bytes {
        self.concat(@x.into());
        self
    }
}

/// Encode address types
/// Addresses are encoded as 32 bytes long, which are right-aligned/left-padded Big-endian.
/// Packed encodings are not padded and only append the bytes of the value based on type.

pub impl SolAbiEncodeStarknetAddress of SolAbiEncodeTrait<ContractAddress> {
    fn encode(mut self: Bytes, x: ContractAddress) -> Bytes {
        let address_felt252: felt252 = x.into();
        let address_u256: u256 = address_felt252.into();
        self.append_u256(address_u256);
        self
    }

    fn encode_packed(mut self: Bytes, x: ContractAddress) -> Bytes {
        self.append_address(x);
        self
    }
}

pub impl SolAbiEncodeEthAddress of SolAbiEncodeTrait<EthAddress> {
    fn encode(mut self: Bytes, x: EthAddress) -> Bytes {
        let x: felt252 = x.into();
        self.append_u256(x.into());
        self
    }

    fn encode_packed(mut self: Bytes, x: EthAddress) -> Bytes {
        let x: felt252 = x.into();
        let mut address256: u256 = x.into();
        address256 = alexandria_math::U256BitShift::shl(address256, 96); // 12 * 8
        self.concat(@BytesTrait::new(20, array![address256.high, address256.low]));
        self
    }
}
