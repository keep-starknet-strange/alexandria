use alexandria_bytes::utils::{
    keccak_u128s_be, pad_left_data, read_sub_u128, u128_array_slice, u128_join, u128_split,
    u32s_to_u256,
};
use alexandria_math::opt_math::OptBitShift;
use core::byte_array::ByteArrayTrait;
use core::ops::index::IndexView;
use core::serde::Serde;
use core::serde::into_felt252_based::SerdeImpl;
use core::sha256;
use starknet::ContractAddress;
/// Bytes is a dynamic array of u128, where each element contains 16 bytes.
pub const BYTES_PER_ELEMENT: usize = 16;

/// Note that:   In Bytes, there are many variables about size and length.
///              We use size to represent the number of bytes in Bytes.
///              We use length to represent the number of elements in Bytes.
///
/// Bytes is a cairo implementation of solidity Bytes in Big-endian.
/// It is a dynamic array of u128, where each element contains 16 bytes.
/// To save cost, the last element MUST be filled fully.
/// That means that every element should and MUST contain 16 bytes.
///
/// For example, if we have a Bytes with 33 bytes, we will have 3 elements.
/// Theoretically, the bytes look like this:
///      first element:  [16 bytes]
///      second element: [16 bytes]
///      third element:  [1 byte]
/// But in alexandria bytes, the last element should be padded with zero to make
/// it 16 bytes. So the alexandria bytes look like this:
///      first element:  [16 bytes]
///      second element: [16 bytes]
///      third element:  [1 byte] + [15 bytes zero padding]
///
/// Bytes is a dynamic array of u128, where each element contains 16 bytes.
///  - size: the number of bytes in the Bytes
///  - data: the data of the Bytes
#[derive(Drop, Clone, PartialEq)]
pub struct Bytes {
    size: usize,
    data: Array<u128>,
}

/// Implementation of IndexView trait for Bytes.
/// Allows indexing into the Bytes structure to access individual u128 elements.
pub impl BytesIndex of IndexView<Bytes, usize> {
    type Target = @u128;
    fn index(self: @Bytes, index: usize) -> @u128 {
        self.data[index]
    }
}


pub trait BytesTrait {
    /// Create a Bytes from an array of u128
    #[deprecated(
        feature: "deprecated-new",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::new`.",
        since: "2.11.1",
    )]
    fn new(size: usize, data: Array<u128>) -> Bytes;
    /// Create an empty Bytes
    #[deprecated(
        feature: "deprecated-new_empty",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::new_empty`.",
        since: "2.11.1",
    )]
    fn new_empty() -> Bytes;
    /// Create a Bytes with size bytes 0
    fn zero(size: usize) -> Bytes;
    /// Locate offset in Bytes
    fn locate(offset: usize) -> (usize, usize);
    /// Get Bytes size
    #[deprecated(
        feature: "deprecated-size",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::size`.",
        since: "2.11.1",
    )]
    fn size(self: @Bytes) -> usize;
    /// Get data
    fn data(self: Bytes) -> Array<u128>;
    /// update specific value (1 bytes) at specific offset
    #[deprecated(
        feature: "deprecated-size",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::size`.",
        since: "2.11.1",
    )]
    fn update_at(ref self: Bytes, offset: usize, value: u8);
    /// Read value with size bytes from Bytes, and packed into u128
    #[deprecated(
        feature: "deprecated-read_u128_packed",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u128_packed`.",
        since: "2.11.1",
    )]
    fn read_u128_packed(self: @Bytes, offset: usize, size: usize) -> (usize, u128);
    /// Read value with element_size bytes from Bytes, and packed into u128 array
    #[deprecated(
        feature: "deprecated-read_u128_array_packed",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u128_array_packed`.",
        since: "2.11.1",
    )]
    fn read_u128_array_packed(
        self: @Bytes, offset: usize, array_length: usize, element_size: usize,
    ) -> (usize, Array<u128>);
    /// Read value with size bytes from Bytes, and packed into felt252
    #[deprecated(
        feature: "deprecated-read_felt252_packed",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_felt252_packed`.",
        since: "2.11.1",
    )]
    fn read_felt252_packed(self: @Bytes, offset: usize, size: usize) -> (usize, felt252);
    /// Read a u8 from Bytes
    #[deprecated(
        feature: "deprecated-read_u8",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u8`.",
        since: "2.11.1",
    )]
    fn read_u8(self: @Bytes, offset: usize) -> (usize, u8);
    /// Read a u16 from Bytes
    #[deprecated(
        feature: "deprecated-read_u16",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u16`.",
        since: "2.11.1",
    )]
    fn read_u16(self: @Bytes, offset: usize) -> (usize, u16);
    /// Read a u32 from Bytes
    #[deprecated(
        feature: "deprecated-read_u32",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u32`.",
        since: "2.11.1",
    )]
    fn read_u32(self: @Bytes, offset: usize) -> (usize, u32);
    /// Read a usize from Bytes
    #[deprecated(
        feature: "deprecated-read_usize",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_usize`.",
        since: "2.11.1",
    )]
    fn read_usize(self: @Bytes, offset: usize) -> (usize, usize);
    /// Read a u64 from Bytes
    #[deprecated(
        feature: "deprecated-read_u64",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u64`.",
        since: "2.11.1",
    )]
    fn read_u64(self: @Bytes, offset: usize) -> (usize, u64);
    /// Read a u128 from Bytes
    #[deprecated(
        feature: "deprecated-read_u128",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u128`.",
        since: "2.11.1",
    )]
    fn read_u128(self: @Bytes, offset: usize) -> (usize, u128);
    /// Read a u256 from Bytes
    #[deprecated(
        feature: "deprecated-read_u256",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u256`.",
        since: "2.11.1",
    )]
    fn read_u256(self: @Bytes, offset: usize) -> (usize, u256);
    /// Read a u256 array from Bytes
    #[deprecated(
        feature: "deprecated-read_u256_array",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_u256_array`.",
        since: "2.11.1",
    )]
    fn read_u256_array(self: @Bytes, offset: usize, array_length: usize) -> (usize, Array<u256>);
    /// Read sub Bytes with size bytes from Bytes
    #[deprecated(
        feature: "deprecated-read_bytes",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_bytes`.",
        since: "2.11.1",
    )]
    fn read_bytes(self: @Bytes, offset: usize, size: usize) -> (usize, Bytes);
    /// Read felt252 from Bytes, which stored as u256
    #[deprecated(
        feature: "deprecated-read_felt252",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_felt252`.",
        since: "2.11.1",
    )]
    fn read_felt252(self: @Bytes, offset: usize) -> (usize, felt252);
    /// Read bytes31 from Bytes
    #[deprecated(
        feature: "deprecated-read_bytes31",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_bytes31`.",
        since: "2.11.1",
    )]
    fn read_bytes31(self: @Bytes, offset: usize) -> (usize, bytes31);
    /// Read a ContractAddress from Bytes
    #[deprecated(
        feature: "deprecated-read_address",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::read_address`.",
        since: "2.11.1",
    )]
    fn read_address(self: @Bytes, offset: usize) -> (usize, ContractAddress);
    /// Write value with size bytes into Bytes, value is packed into u128
    fn append_u128_packed(ref self: Bytes, value: u128, size: usize);
    /// Write u8 into Bytes
    #[deprecated(
        feature: "deprecated-append_u8",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u8`.",
        since: "2.11.1",
    )]
    fn append_u8(ref self: Bytes, value: u8);
    /// Write u16 into Bytes
    #[deprecated(
        feature: "deprecated-append_u16",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u16`.",
        since: "2.11.1",
    )]
    fn append_u16(ref self: Bytes, value: u16);
    /// Write u32 into Bytes
    #[deprecated(
        feature: "deprecated-append_u32",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u32`.",
        since: "2.11.1",
    )]
    fn append_u32(ref self: Bytes, value: u32);
    /// Write usize into Bytes
    #[deprecated(
        feature: "deprecated-append_usize",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_usize`.",
        since: "2.11.1",
    )]
    fn append_usize(ref self: Bytes, value: usize);
    /// Write u64 into Bytes
    #[deprecated(
        feature: "deprecated-append_u64",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u64`.",
        since: "2.11.1",
    )]
    fn append_u64(ref self: Bytes, value: u64);
    /// Write u128 into Bytes
    #[deprecated(
        feature: "deprecated-append_u128",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u128`.",
        since: "2.11.1",
    )]
    fn append_u128(ref self: Bytes, value: u128);
    /// Write u256 into Bytes
    #[deprecated(
        feature: "deprecated-append_u256",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_u256`.",
        since: "2.11.1",
    )]
    fn append_u256(ref self: Bytes, value: u256);
    /// Write felt252 into Bytes, which stored as u256
    #[deprecated(
        feature: "deprecated-append_felt252",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_felt252`.",
        since: "2.11.1",
    )]
    fn append_felt252(ref self: Bytes, value: felt252);
    /// Write bytes31 into Bytes
    #[deprecated(
        feature: "deprecated-append_bytes31",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_bytes31`.",
        since: "2.11.1",
    )]
    fn append_bytes31(ref self: Bytes, value: bytes31);
    /// Write address into Bytes
    #[deprecated(
        feature: "deprecated-append_address",
        note: "Use `alexandria_bytes::byte_array_ext::ByteArrayTraitExt::append_address`.",
        since: "2.11.1",
    )]
    fn append_address(ref self: Bytes, value: ContractAddress);
    /// concat with other Bytes
    #[deprecated(
        feature: "deprecated-concat", note: "Use `core::byte_array::concat`.", since: "2.11.1",
    )]
    fn concat(ref self: Bytes, other: @Bytes);
    /// keccak hash
    #[deprecated(
        feature: "deprecated-keccak",
        note: "Use `core::keccak::compute_keccak_byte_array`.",
        since: "2.7.0",
    )]
    fn keccak(self: @Bytes) -> u256;
    /// sha256 hash
    #[deprecated(
        feature: "deprecated-sha256",
        note: "Use `core::sha256::compute_sha256_byte_array`.",
        since: "2.7.0",
    )]
    fn sha256(self: @Bytes) -> u256;
}

/// Implementation of BytesTrait for the Bytes struct.
/// Provides functionality for creating, reading, writing, and manipulating byte arrays.
impl BytesImpl of BytesTrait {
    #[inline(always)]
    fn new(size: usize, data: Array<u128>) -> Bytes {
        Bytes { size, data: pad_left_data(data, BYTES_PER_ELEMENT) }
    }

    #[inline(always)]
    fn new_empty() -> Bytes {
        Bytes { size: 0_usize, data: array![] }
    }

    fn zero(size: usize) -> Bytes {
        let mut data = array![];
        let (data_index, mut data_len) = DivRem::div_rem(
            size, BYTES_PER_ELEMENT.try_into().expect('Division by 0'),
        );

        if data_index != 0 {
            data_len += 1;
        }

        while data_len != 0 {
            data.append(0_u128);
            data_len -= 1;
        }

        Bytes { size, data }
    }

    /// Locate offset in Bytes
    /// #### Arguments:
    ///  - offset: the offset in Bytes
    /// #### Returns:
    ///  - element_index: the index of the element in Bytes
    ///  - element_offset: the offset in the element
    #[inline(always)]
    fn locate(offset: usize) -> (usize, usize) {
        DivRem::div_rem(offset, BYTES_PER_ELEMENT.try_into().expect('Division by 0'))
    }

    /// Get Bytes size
    #[inline(always)]
    fn size(self: @Bytes) -> usize {
        *self.size
    }


    /// Gets the underlying data array from the Bytes struct.
    /// #### Returns
    /// * `Array<u128>` - The array of u128 elements containing the byte data
    fn data(self: Bytes) -> Array<u128> {
        self.data
    }

    /// update specific value (1 bytes) at specific offset
    fn update_at(ref self: Bytes, offset: usize, value: u8) {
        assert(offset < self.size(), 'update out of bound');
        let mut new_bytes = Self::new_empty();

        // if update first bytes, ignore
        if offset > 0 {
            let (_, left) = self.read_bytes(0, offset);
            new_bytes.concat(@left);
        }
        new_bytes.append_u8(value);

        // if update last bytes, ignore
        if offset < self.size() - 1 {
            let (_, right) = self.read_bytes(offset + 1, self.size() - offset - 1);
            new_bytes.concat(@right);
        }
        self = new_bytes;
    }

    /// Read value with size bytes from Bytes, and packed into u128
    /// #### Arguments:
    ///  - offset: the offset in Bytes
    ///  - size: the number of bytes to read
    /// #### Returns:
    ///  - new_offset: next value offset in Bytes
    ///  - value: the value packed into u128
    fn read_u128_packed(self: @Bytes, offset: usize, size: usize) -> (usize, u128) {
        // check
        assert(offset + size <= self.size(), 'out of bound');
        assert(size <= 16, 'too large');

        // check value in one element or two
        // if value in one element, just read it
        // if value in two elements, read them and join them
        let (element_index, element_offset) = Self::locate(offset);
        let value_in_one_element = element_offset + size <= BYTES_PER_ELEMENT;
        let value = if value_in_one_element {
            read_sub_u128(*self.data[element_index], BYTES_PER_ELEMENT, element_offset, size)
        } else {
            let (_, end_element_offset) = Self::locate(offset + size);
            let left = read_sub_u128(
                *self.data[element_index],
                BYTES_PER_ELEMENT,
                element_offset,
                BYTES_PER_ELEMENT - element_offset,
            );
            let right = read_sub_u128(
                *self.data[element_index + 1], BYTES_PER_ELEMENT, 0, end_element_offset,
            );
            u128_join(left, right, end_element_offset)
        };
        (offset + size, value)
    }

    /// Reads an array of u128 values from Bytes, each element packed with specified size.
    /// #### Arguments
    /// * `offset` - The starting offset in Bytes
    /// * `array_length` - The number of elements to read
    /// * `element_size` - The size in bytes of each element
    /// #### Returns
    /// * `(usize, Array<u128>)` - New offset and array of packed u128 values
    fn read_u128_array_packed(
        self: @Bytes, offset: usize, array_length: usize, element_size: usize,
    ) -> (usize, Array<u128>) {
        assert(offset + array_length * element_size <= self.size(), 'out of bound');
        let mut array = array![];

        if array_length == 0 {
            return (offset, array);
        }
        let mut offset = offset;
        let mut i = array_length;
        while i != 0 {
            let (new_offset, value) = self.read_u128_packed(offset, element_size);
            array.append(value);
            offset = new_offset;
            i -= 1;
        }
        (offset, array)
    }

    /// Read value with size bytes from Bytes, and packed into felt252
    /// #### Arguments
    /// * `offset` - The starting offset in Bytes
    /// * `size` - The number of bytes to read (max 31)
    /// #### Returns
    /// * `(usize, felt252)` - New offset and the packed felt252 value
    fn read_felt252_packed(self: @Bytes, offset: usize, size: usize) -> (usize, felt252) {
        // check bounds
        assert(offset + size <= self.size(), 'out of bound');
        // felt252 can hold 31 bytes max
        assert(size <= 31, 'too large');

        if size <= 16 {
            // Read directly as u128 and convert to felt252
            let (new_offset, value) = self.read_u128_packed(offset, size);
            return (new_offset, value.into());
        } else {
            // Read as two parts: high and low u128 values
            let (new_offset, high) = self.read_u128_packed(offset, size - 16);
            let (new_offset, low) = self.read_u128_packed(new_offset, 16);
            return (new_offset, u256 { low, high }.try_into().unwrap());
        }
    }

    /// Read a u8 from Bytes
    #[inline(always)]
    fn read_u8(self: @Bytes, offset: usize) -> (usize, u8) {
        let (new_offset, value) = self.read_u128_packed(offset, 1);
        (new_offset, value.try_into().unwrap())
    }
    /// Read a u16 from Bytes
    #[inline(always)]
    fn read_u16(self: @Bytes, offset: usize) -> (usize, u16) {
        let (new_offset, value) = self.read_u128_packed(offset, 2);
        (new_offset, value.try_into().unwrap())
    }
    /// Read a u32 from Bytes
    #[inline(always)]
    fn read_u32(self: @Bytes, offset: usize) -> (usize, u32) {
        let (new_offset, value) = self.read_u128_packed(offset, 4);
        (new_offset, value.try_into().unwrap())
    }
    /// Read a usize from Bytes
    #[inline(always)]
    fn read_usize(self: @Bytes, offset: usize) -> (usize, usize) {
        let (new_offset, value) = self.read_u128_packed(offset, 4);
        (new_offset, value.try_into().unwrap())
    }
    /// Read a u64 from Bytes
    #[inline(always)]
    fn read_u64(self: @Bytes, offset: usize) -> (usize, u64) {
        let (new_offset, value) = self.read_u128_packed(offset, 8);
        (new_offset, value.try_into().unwrap())
    }

    /// read a u128 from Bytes
    #[inline(always)]
    fn read_u128(self: @Bytes, offset: usize) -> (usize, u128) {
        self.read_u128_packed(offset, 16)
    }

    /// read a u256 from Bytes
    #[inline(always)]
    fn read_u256(self: @Bytes, offset: usize) -> (usize, u256) {
        // check
        assert(offset + 32 <= self.size(), 'out of bound');

        let (new_offset, high) = self.read_u128(offset);
        let (new_offset, low) = self.read_u128(new_offset);

        (new_offset, u256 { low, high })
    }

    /// read a u256 array from Bytes
    fn read_u256_array(self: @Bytes, offset: usize, array_length: usize) -> (usize, Array<u256>) {
        assert(offset + array_length * 32 <= self.size(), 'out of bound');
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

    /// read sub Bytes from Bytes
    fn read_bytes(self: @Bytes, offset: usize, size: usize) -> (usize, Bytes) {
        // check
        assert(offset + size <= self.size(), 'out of bound');

        if size == 0 {
            return (offset, Self::new_empty());
        }

        let mut array = array![];

        // read full array element for sub_bytes
        let mut offset = offset;
        let mut sub_bytes_full_array_len = size / BYTES_PER_ELEMENT;
        while sub_bytes_full_array_len != 0 {
            let (new_offset, value) = self.read_u128(offset);
            array.append(value);
            offset = new_offset;
            sub_bytes_full_array_len -= 1;
        }

        // process last array element for sub_bytes
        // 1. read last element real value;
        // 2. make last element full with padding 0;
        let sub_bytes_last_element_size = size % BYTES_PER_ELEMENT;
        if sub_bytes_last_element_size > 0 {
            let (new_offset, value) = self.read_u128_packed(offset, sub_bytes_last_element_size);
            let padding = BYTES_PER_ELEMENT - sub_bytes_last_element_size;
            let value = u128_join(value, 0, padding);
            array.append(value);
            offset = new_offset;
        }

        return (offset, Self::new(size, array));
    }

    /// read felt252 from Bytes
    /// felt252 stores as u256 in Bytes
    #[inline(always)]
    fn read_felt252(self: @Bytes, offset: usize) -> (usize, felt252) {
        let (new_offset, value) = self.read_u256(offset);
        (new_offset, value.try_into().expect('Couldn\'t convert to felt252'))
    }

    /// read bytes31 from Bytes
    #[inline(always)]
    fn read_bytes31(self: @Bytes, offset: usize) -> (usize, bytes31) {
        // Read 31 bytes of data ( 16 bytes high + 15 bytes low )
        let (new_offset, high) = self.read_u128(offset);
        let (new_offset, low) = self.read_u128_packed(new_offset, 15);
        // low bits shifting to remove the left padded 0 byte on u128 type
        let low = OptBitShift::shl(low, 8);
        let mut value: u256 = u256 { high, low };
        // shift left aligned 31 bytes to the right
        // thus the value is stored in the last 31 bytes of u256
        value = OptBitShift::shr(value, 8);
        // Unwrap is always safe here, because highest byte is always 0
        let value: felt252 = value.try_into().expect('Couldn\'t convert to felt252');
        let value: bytes31 = value.try_into().expect('Couldn\'t convert to bytes31');
        (new_offset, value)
    }

    /// read Contract Address from Bytes
    #[inline(always)]
    fn read_address(self: @Bytes, offset: usize) -> (usize, ContractAddress) {
        let (new_offset, value) = self.read_u256(offset);
        let address: felt252 = value.try_into().expect('Couldn\'t convert to felt252');
        (new_offset, address.try_into().expect('Couldn\'t convert to address'))
    }

    /// Write value with size bytes into Bytes, value is packed into u128
    /// #### Arguments
    /// * `value` - The u128 value to append
    /// * `size` - The number of bytes to write (max 16)
    fn append_u128_packed(ref self: Bytes, value: u128, size: usize) {
        assert(size <= 16, 'size must be less than 16');

        let Bytes { size: old_bytes_size, mut data } = self;
        let (last_data_index, last_element_size) = Self::locate(old_bytes_size);

        if last_element_size == 0 {
            // No partial element, create new padded element
            let padded_value = u128_join(value, 0, BYTES_PER_ELEMENT - size);
            data.append(padded_value);
        } else {
            // Partial element exists, need to merge
            let (last_element_value, _) = u128_split(*data[last_data_index], 16, last_element_size);
            data = u128_array_slice(@data, 0, last_data_index);
            if size + last_element_size > BYTES_PER_ELEMENT {
                // Value spans two elements
                let (left, right) = u128_split(value, size, BYTES_PER_ELEMENT - last_element_size);
                let value_full = u128_join(
                    last_element_value, left, BYTES_PER_ELEMENT - last_element_size,
                );
                let value_padded = u128_join(
                    right, 0, 2 * BYTES_PER_ELEMENT - size - last_element_size,
                );
                data.append(value_full);
                data.append(value_padded);
            } else {
                // Value fits in current element
                let value = u128_join(last_element_value, value, size);
                let value_padded = u128_join(
                    value, 0, BYTES_PER_ELEMENT - size - last_element_size,
                );
                data.append(value_padded);
            }
        }
        self = Bytes { size: old_bytes_size + size, data }
    }

    /// Write u8 into Bytes
    #[inline(always)]
    fn append_u8(ref self: Bytes, value: u8) {
        self.append_u128_packed(value.into(), 1)
    }

    /// Write u16 into Bytes
    #[inline(always)]
    fn append_u16(ref self: Bytes, value: u16) {
        self.append_u128_packed(value.into(), 2)
    }

    /// Write u32 into Bytes
    #[inline(always)]
    fn append_u32(ref self: Bytes, value: u32) {
        self.append_u128_packed(value.into(), 4)
    }

    /// Write usize into Bytes
    #[inline(always)]
    fn append_usize(ref self: Bytes, value: usize) {
        self.append_u128_packed(value.into(), 4)
    }

    /// Write u64 into Bytes
    #[inline(always)]
    fn append_u64(ref self: Bytes, value: u64) {
        self.append_u128_packed(value.into(), 8)
    }

    /// Write u128 into Bytes
    #[inline(always)]
    fn append_u128(ref self: Bytes, value: u128) {
        self.append_u128_packed(value, 16)
    }

    /// Write u256 into Bytes
    #[inline(always)]
    fn append_u256(ref self: Bytes, value: u256) {
        self.append_u128(value.high);
        self.append_u128(value.low);
    }

    /// Write felt252 into Bytes, which stored as u256
    #[inline(always)]
    fn append_felt252(ref self: Bytes, value: felt252) {
        let value: u256 = value.into();
        self.append_u256(value)
    }

    /// Write bytes31 into Bytes
    #[inline(always)]
    fn append_bytes31(ref self: Bytes, value: bytes31) {
        let mut value: u256 = value.into();
        value = OptBitShift::shl(value, 8);
        self.concat(@Self::new(31, array![value.high, value.low]));
    }

    /// Write address into Bytes
    #[inline(always)]
    fn append_address(ref self: Bytes, value: ContractAddress) {
        let address: felt252 = value.into();
        self.append_felt252(address)
    }

    /// Concatenate with other Bytes
    /// #### Arguments
    /// * `other` - The Bytes to concatenate with this one
    fn concat(ref self: Bytes, other: @Bytes) {
        // Read full u128 elements from other Bytes
        let mut offset = 0;
        let mut sub_bytes_full_array_len = *other.size / BYTES_PER_ELEMENT;
        while sub_bytes_full_array_len != 0 {
            let (new_offset, value) = other.read_u128(offset);
            self.append_u128(value);
            offset = new_offset;
            sub_bytes_full_array_len -= 1;
        }

        // Process remaining partial element
        let sub_bytes_last_element_size = *other.size % BYTES_PER_ELEMENT;
        if sub_bytes_last_element_size > 0 {
            let (_, value) = other.read_u128_packed(offset, sub_bytes_last_element_size);
            self.append_u128_packed(value, sub_bytes_last_element_size);
        }
    }

    /// Compute keccak hash of the Bytes
    /// #### Returns
    /// * `u256` - The keccak hash of the bytes
    fn keccak(self: @Bytes) -> u256 {
        let (last_data_index, last_element_size) = Self::locate(self.size());
        if last_element_size == 0 {
            // No partial element, hash all data directly
            return keccak_u128s_be(self.data.span(), self.size());
        } else {
            // Partial element exists, remove padding before hashing
            let mut hash_data = u128_array_slice(self.data, 0, last_data_index);
            // Remove zero padding from last element
            let (last_element_value, _) = u128_split(
                *self.data[last_data_index], BYTES_PER_ELEMENT, last_element_size,
            );
            hash_data.append(last_element_value);
            return keccak_u128s_be(hash_data.span(), self.size());
        }
    }

    /// Compute sha256 hash of the Bytes
    /// #### Returns
    /// * `u256` - The sha256 hash of the bytes
    fn sha256(self: @Bytes) -> u256 {
        let mut i: usize = 0;
        let mut offset: usize = 0;
        let mut hash_data_byte_array = "";
        // Convert Bytes to ByteArray for sha256 computation
        while i != self.size() {
            let (new_offset, hash_data_item) = self.read_u8(offset);
            hash_data_byte_array.append_byte(hash_data_item);
            offset = new_offset;
            i += 1;
        }

        // Compute sha256 hash and convert to u256
        let output = sha256::compute_sha256_byte_array(@hash_data_byte_array);
        u32s_to_u256(output.span())
    }
}

/// Implementation for converting a ByteArray to a Bytes struct
///
/// This conversion creates a new Bytes structure from a ByteArray by iterating
/// through each byte in the ByteArray and appending it to the Bytes structure.
/// The conversion preserves all data and maintains byte order.
///
/// #### Arguments
/// * `self` - The ByteArray to convert to a Bytes struct
///
/// #### Returns
/// * `Bytes` - A new Bytes struct containing all bytes from the input ByteArray
pub impl ByteArrayIntoBytes of Into<ByteArray, Bytes> {
    fn into(self: ByteArray) -> Bytes {
        let mut res = BytesTrait::new_empty();
        let mut len = 0;
        while len < self.len() {
            res.append_u8(self[len]);
            len += 1;
        }
        res
    }
}

/// Implementation for converting a Bytes struct to a ByteArray
///
/// This conversion efficiently transfers data from a Bytes structure to a ByteArray
/// by reading data in optimal chunks (31-byte words when possible, single bytes otherwise).
/// The conversion preserves all data and maintains byte order.
///
/// #### Arguments
/// * `self` - The Bytes struct to convert to ByteArray
///
/// #### Returns
/// * `ByteArray` - A new ByteArray containing all bytes from the input Bytes struct
pub impl BytesIntoByteArray of Into<Bytes, ByteArray> {
    fn into(self: Bytes) -> ByteArray {
        let mut res: ByteArray = Default::default();
        let mut offset = 0;
        while offset < self.size() {
            if offset + 31 <= self.size() {
                let (new_offset, value) = self.read_bytes31(offset);
                res.append_word(value.into(), 31);
                offset = new_offset;
            } else {
                let (new_offset, value) = self.read_u8(offset);
                res.append_byte(value);
                offset = new_offset;
            }
        }
        res
    }
}

/// Implementation of Serde trait for Bytes.
/// Provides serialization and deserialization functionality for Bytes structures.
impl BytesSerde of Serde<Bytes> {
    fn serialize(self: @Bytes, ref output: Array<felt252>) {
        self.size.serialize(ref output);
        self.data.serialize(ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<Bytes> {
        let size = Serde::<usize>::deserialize(ref serialized)?;
        let data = Serde::<Array<u128>>::deserialize(ref serialized)?;
        Option::Some(Bytes { size, data: pad_left_data(data, BYTES_PER_ELEMENT) })
    }
}

