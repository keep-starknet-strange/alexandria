use alexandria_math::U256BitShift;
use core::num::traits::Zero;
/// pub trait ByteArrayExtTrait {
//
//     fn read_u256_array(self: @Bytes, offset: usize, array_length: usize) -> (usize, Array<u256>);
//     fn read_bytes31(self: @Bytes, offset: usize) -> (usize, bytes31);
//     fn append_bytes31(ref self: Bytes, value: bytes31);
// }

use starknet::ContractAddress;

pub trait ByteArrayTraitExt {
    fn read_u16(self: @ByteArray, offset: usize) -> (usize, u16);
    fn read_u32(self: @ByteArray, offset: usize) -> (usize, u32);
    fn read_usize(self: @ByteArray, offset: usize) -> (usize, usize);
    fn read_u64(self: @ByteArray, offset: usize) -> (usize, u64);
    fn read_u128(self: @ByteArray, offset: usize) -> (usize, u128);
    fn read_u128_array_packed(
        self: @ByteArray, offset: usize, array_length: usize, element_size: usize,
    ) -> (usize, Array<u128>);
    fn read_u256(self: @ByteArray, offset: usize) -> (usize, u256);
    fn read_u256_array(
        self: @ByteArray, offset: usize, array_length: usize,
    ) -> (usize, Array<u256>);
    fn read_felt252(self: @ByteArray, offset: usize) -> (usize, felt252);
    fn read_bytes31(self: @ByteArray, offset: usize) -> (usize, bytes31);
    fn read_address(self: @ByteArray, offset: usize) -> (usize, ContractAddress);
    fn read_bytes(self: @ByteArray, offset: usize, size: usize) -> (usize, ByteArray);
    fn append_u16(ref self: ByteArray, value: u16);
    fn append_u32(ref self: ByteArray, value: u32);
    fn append_u64(ref self: ByteArray, value: u64);
    fn append_u128(ref self: ByteArray, value: u128);
    fn append_u256(ref self: ByteArray, value: u256);
    fn append_felt252(ref self: ByteArray, value: felt252);
    fn append_address(ref self: ByteArray, value: ContractAddress);
    fn append_bytes31(ref self: ByteArray, value: bytes31);
    fn update_at(ref self: ByteArray, offset: usize, value: u8);
}


impl ByteArrayTraitExtImpl of ByteArrayTraitExt {
    /// Read a u16 from ByteArray
    #[inline(always)]
    fn read_u16(self: @ByteArray, offset: usize) -> (usize, u16) {
        read_uint::<u16>(self, offset, 2)
    }

    #[inline(always)]
    fn read_u32(self: @ByteArray, offset: usize) -> (usize, u32) {
        read_uint::<u32>(self, offset, 4)
    }

    #[inline(always)]
    fn read_usize(self: @ByteArray, offset: usize) -> (usize, usize) {
        read_uint::<usize>(self, offset, 4)
    }

    #[inline(always)]
    fn read_u64(self: @ByteArray, offset: usize) -> (usize, u64) {
        read_uint::<u64>(self, offset, 8)
    }

    #[inline(always)]
    fn read_u128(self: @ByteArray, offset: usize) -> (usize, u128) {
        read_uint::<u128>(self, offset, 16)
    }

    #[inline(always)]
    fn read_u256(self: @ByteArray, offset: usize) -> (usize, u256) {
        read_uint::<u256>(self, offset, 32)
    }

    #[inline(always)]
    fn read_felt252(self: @ByteArray, offset: usize) -> (usize, felt252) {
        let (new_offset, value) = read_uint::<u256>(self, offset, 32);
        (new_offset, value.try_into().expect('Couldn\'t convert to felt252'))
    }

    #[inline(always)]
    fn read_bytes31(self: @ByteArray, offset: usize) -> (usize, bytes31) {
        let one_u128 = 1_u128;
        let one_as_bytes31: bytes31 = one_u128.into();
        (1, one_as_bytes31)
    }

    /// read Contract Address from Bytes
    #[inline(always)]
    fn read_address(self: @ByteArray, offset: usize) -> (usize, ContractAddress) {
        let (new_offset, value) = self.read_u256(offset);
        let address: felt252 = value.try_into().expect('Couldn\'t convert to felt252');
        (new_offset, address.try_into().expect('Couldn\'t convert to address'))
    }

    #[inline(always)]
    fn read_bytes(self: @ByteArray, offset: usize, size: usize) -> (usize, ByteArray) {
        assert(offset + size <= self.len(), 'out of bound');

        if size == 0 {
            return (offset, Default::default());
        }

        let mut ba: ByteArray = Default::default();

        // read full array element for sub_bytes
        let mut offset = offset;
        //read per block of u32
        let mut sub_bytes_full_array_len = size / 4;

        while sub_bytes_full_array_len != 0 {
            let (new_offset, value) = self.read_u32(offset);
            ba.append_u32(value);
            offset = new_offset;
            sub_bytes_full_array_len -= 1;
        }

        // process last array element for sub_bytes
        // 1. read last element real value;
        // 2. make last element full with padding 0;
        let mut sub_bytes_last_element_size = size % 4;
        while sub_bytes_last_element_size != 0 {
            let value = self.at(offset).unwrap();
            ba.append_byte(value);
            sub_bytes_last_element_size -= 1;
            offset += 1;
        }

        return (offset, ba);
    }

    fn append_u16(ref self: ByteArray, value: u16) {
        self.append_word(value.into(), 2);
    }

    fn append_u32(ref self: ByteArray, value: u32) {
        self.append_word(value.into(), 4);
    }

    fn append_u64(ref self: ByteArray, value: u64) {
        self.append_word(value.into(), 8);
    }

    fn append_u128(ref self: ByteArray, value: u128) {
        self.append_word(value.into(), 16);
    }

    fn append_u256(ref self: ByteArray, value: u256) {
        self.append_u128(value.high);
        self.append_u128(value.low);
    }

    fn append_felt252(ref self: ByteArray, value: felt252) {
        let value: u256 = value.into();
        self.append_u256(value);
    }

    fn append_address(ref self: ByteArray, value: ContractAddress) {
        let address: felt252 = value.into();
        self.append_felt252(address);
    }

    /// Write bytes31 into Bytes
    #[inline(always)]
    fn append_bytes31(ref self: ByteArray, value: bytes31) {
        let mut value: u256 = value.into();
        value = U256BitShift::shl(value, 8);
        self.append_u256(value);
    }


    fn update_at(ref self: ByteArray, offset: usize, value: u8) {
        assert(offset <= self.len(), 'out of bound');

        let (_, temp_l) = self.read_bytes(0, offset);
        let (_, temp_r) = self.read_bytes(offset + 1, self.len() - 1 - offset);
        let mut new_byte_array: ByteArray = temp_l;
        new_byte_array.append_byte(value);
        new_byte_array.append(@temp_r);
        self = new_byte_array;
    }

    fn read_u128_array_packed(
        self: @ByteArray, offset: usize, array_length: usize, element_size: usize,
    ) -> (usize, Array<u128>) {
        assert(offset + array_length * element_size <= self.len(), 'out of bound');
        let mut array: Array<u128> = array![];

        if array_length == 0 {
            return (offset, array);
        }
        let mut offset = offset;
        let mut i = array_length;
        while i != 0 {
            let (new_offset, value) = self.read_bytes(offset, element_size);
            let (_, t) = value.read_u128(0);
            array.append(t);
            offset = new_offset;
            i -= 1;
        }
        (offset, array)
    }

    /// read a u256 array from Bytes
    fn read_u256_array(
        self: @ByteArray, offset: usize, array_length: usize,
    ) -> (usize, Array<u256>) {
        assert(offset + array_length * 32 <= self.len(), 'out of bound');
        let mut array = array![];

        if array_length == 0 {
            return (offset, array);
        }

        let mut offset = offset;
        let mut i = array_length;
        while i != 0 {
            let (new_offset, value) = self.read_u256(offset);
            array.append(value);
            offset = new_offset;
            i -= 1;
        }
        (offset, array)
    }
}

fn read_uint<T, +Add<T>, +Mul<T>, +Zero<T>, +TryInto<felt252, T>, +Drop<T>, +Into<u8, T>>(
    self: @ByteArray, offset: usize, mut size: usize,
) -> (usize, T) {
    //assert(offset + size <= self.len() && offset != 0, 'out of bound');

    if size > self.len() && offset == 0 {
        size = self.len() - offset;
    }

    let mut value: T = Zero::zero();
    let mut i = 0;

    while i < size {
        let byte: u8 = self.at(offset + i).unwrap();
        value = (value * 256.try_into().unwrap()) + byte.into();
        i += 1;
    }

    (offset + size, value)
}
