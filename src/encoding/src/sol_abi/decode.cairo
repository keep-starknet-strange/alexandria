use alexandria_bytes::{Bytes, BytesTrait};
use alexandria_encoding::sol_abi::sol_bytes::SolBytesTrait;
use starknet::{ContractAddress, EthAddress};

/// Decode trait meant to provide an interface similar to Solidity's abi.decode
/// function. It is meant to be used in a chain where the passed in `offset` is
/// updated after each decode operation.
/// Values are expected to be 32 bytes long, and will be interpreted as if they
/// were encoded using the `abi.encode` function in Solidity.
pub trait SolAbiDecodeTrait<T> {
    fn decode(self: @Bytes, ref offset: usize) -> T;
}

/// Decode int types
/// Integers are decoded by reading 32 bytes from the `offset`
/// `Bytes` encoding is right-aligned/left-paddded Big-endian.

pub impl SolAbiDecodeU8 of SolAbiDecodeTrait<u8> {
    fn decode(self: @Bytes, ref offset: usize) -> u8 {
        let (new_offset, decodedU8) = self.read_u256(offset);
        offset = new_offset;
        decodedU8.try_into().expect('Couldn\'t convert to u8')
    }
}

pub impl SolAbiDecodeU16 of SolAbiDecodeTrait<u16> {
    fn decode(self: @Bytes, ref offset: usize) -> u16 {
        let (new_offset, decodedU16) = self.read_u256(offset);
        offset = new_offset;
        decodedU16.try_into().expect('Couldn\'t convert to u16')
    }
}

pub impl SolAbiDecodeU32 of SolAbiDecodeTrait<u32> {
    fn decode(self: @Bytes, ref offset: usize) -> u32 {
        let (new_offset, decodedU32) = self.read_u256(offset);
        offset = new_offset;
        decodedU32.try_into().expect('Couldn\'t convert to u32')
    }
}

pub impl SolAbiDecodeU64 of SolAbiDecodeTrait<u64> {
    fn decode(self: @Bytes, ref offset: usize) -> u64 {
        let (new_offset, decodedU64) = self.read_u256(offset);
        offset = new_offset;
        decodedU64.try_into().expect('Couldn\'t convert to u64')
    }
}

pub impl SolAbiDecodeU128 of SolAbiDecodeTrait<u128> {
    fn decode(self: @Bytes, ref offset: usize) -> u128 {
        let (new_offset, decodedU128) = self.read_u256(offset);
        offset = new_offset;
        decodedU128.try_into().expect('Couldn\'t convert to u128')
    }
}

pub impl SolAbiDecodeU256 of SolAbiDecodeTrait<u256> {
    fn decode(self: @Bytes, ref offset: usize) -> u256 {
        let (new_offset, decodedU256) = self.read_u256(offset);
        offset = new_offset;
        decodedU256
    }
}

/// Decode other primitives
/// Primitives are decoded by reading 32 bytes from the `offset`
/// `Bytes` encoding is right-aligned/left-paddded Big-endian.

pub impl SolAbiDecodeBool of SolAbiDecodeTrait<bool> {
    fn decode(self: @Bytes, ref offset: usize) -> bool {
        let (new_offset, decodedBool) = self.read_u256(offset);
        offset = new_offset;
        decodedBool != 0
    }
}

pub impl SolAbiDecodeFelt252 of SolAbiDecodeTrait<felt252> {
    fn decode(self: @Bytes, ref offset: usize) -> felt252 {
        let (new_offset, decodedFelt252) = self.read_u256(offset);
        offset = new_offset;
        decodedFelt252.try_into().expect('Couldn\'t convert to felt252')
    }
}

pub impl SolAbiDecodeBytes31 of SolAbiDecodeTrait<bytes31> {
    fn decode(self: @Bytes, ref offset: usize) -> bytes31 {
        let (new_offset, decodedBytes31) = self.read_u256(offset);
        offset = new_offset;
        let decodedBytes31: felt252 = decodedBytes31
            .try_into()
            .expect('Couldn\'t convert to felt252');
        decodedBytes31.try_into().expect('Couldn\'t convert to bytes31')
    }
}

/// Decode byte types
/// Bytes are decoded by reading 32 bytes from the `offset`
/// `Bytes` encoding is left-aligned/right-paddded

pub impl SolAbiDecodeBytes of SolAbiDecodeTrait<Bytes> {
    fn decode(self: @Bytes, ref offset: usize) -> Bytes {
        let (new_offset, decodedBytes) = self.read_u256(offset);
        offset = new_offset;
        SolBytesTrait::bytes32(decodedBytes)
    }
}

pub impl SolAbiDecodeByteArray of SolAbiDecodeTrait<ByteArray> {
    fn decode(self: @Bytes, ref offset: usize) -> ByteArray {
        let (new_offset, decodedBytes) = self.read_u256(offset);
        offset = new_offset;
        SolBytesTrait::bytes32(decodedBytes).into()
    }
}

/// Decode address types
/// Addresses are decoded by reading 32 bytes from the `offset`
/// `Bytes` encoding is right-aligned/left-paddded Big-endian.

pub impl SolAbiDecodeStarknetAddress of SolAbiDecodeTrait<ContractAddress> {
    fn decode(self: @Bytes, ref offset: usize) -> ContractAddress {
        let (new_offset, decodedAddress) = self.read_u256(offset);
        offset = new_offset;
        let decodedAddress: felt252 = decodedAddress
            .try_into()
            .expect('Couldn\'t convert to felt252');
        decodedAddress.try_into().expect('Couldn\'t convert to address')
    }
}

pub impl SolAbiDecodeEthAddress of SolAbiDecodeTrait<EthAddress> {
    fn decode(self: @Bytes, ref offset: usize) -> EthAddress {
        let (new_offset, decodedAddress) = self.read_u256(offset);
        offset = new_offset;
        decodedAddress.try_into().expect('Couldn\'t convert to address')
    }
}
