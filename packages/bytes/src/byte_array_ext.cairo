use alexandria_math::opt_math::OptBitShift;
use core::integer::u512;
use core::num::traits::Zero;
use starknet::ContractAddress;
use crate::bit_array::one_shift_left_bytes_felt252;
use crate::byte_appender::{ByteAppender, ByteAppenderSupportTrait};


/// Implementation for converting a Span<u8> to a ByteArray
///
/// This conversion creates a new ByteArray by iterating through each byte
/// in the span and appending it to the ByteArray. This is useful for converting
/// byte spans to the more efficient ByteArray representation.
///
/// #### Arguments
/// * `self` - The Span<u8> to convert to ByteArray
///
/// #### Returns
/// * `ByteArray` - A new ByteArray containing all bytes from the input span
pub impl SpanU8IntoByteArray of Into<Span<u8>, ByteArray> {
    #[inline]
    fn into(self: Span<u8>) -> ByteArray {
        let mut reader: u32 = 0;
        let mut result: ByteArray = Default::default();
        while reader != self.len() {
            result.append_byte(*self.at(reader));
            reader = reader + 1;
        }
        result
    }
}

/// Implementation for converting an Array<u8> to a ByteArray
///
/// This conversion creates a new ByteArray from an Array<u8> by first converting
/// the array to a span and then using the SpanU8IntoByteArray implementation.
/// This provides a convenient way to convert byte arrays to ByteArray format.
///
/// #### Arguments
/// * `self` - The Array<u8> to convert to ByteArray
///
/// #### Returns
/// * `ByteArray` - A new ByteArray containing all bytes from the input array
impl ArrayU8IntoByteArray of Into<Array<u8>, ByteArray> {
    fn into(self: Array<u8>) -> ByteArray {
        self.span().into()
    }
}

/// Implementation for converting a ByteArray to an Array<u8>
///
/// This conversion creates a new Array<u8> by iterating through each byte
/// in the ByteArray and appending it to the array. This is useful when you need
/// to work with individual bytes or interface with functions that expect Array<u8>.
///
/// #### Arguments
/// * `self` - The ByteArray to convert to Array<u8>
///
/// #### Returns
/// * `Array<u8>` - A new Array<u8> containing all bytes from the input ByteArray
pub impl ByteArrayIntoArrayU8 of Into<ByteArray, Array<u8>> {
    fn into(self: ByteArray) -> Array<u8> {
        let mut reader: u32 = 0;
        let mut result = array![];
        while reader != self.len() {
            let (_, byte) = self.read_u8(reader);
            result.append(byte);
            reader = reader + 1;
        }
        result
    }
}

/// Extension trait for reading and writing different data types to `ByteArray`
pub trait ByteArrayTraitExt {
    /// Create a ByteArray from an array of u128
    /// #### Arguments
    /// * `size` - The size of the ByteArray
    /// * `data` - Array of u128 values to create ByteArray from
    /// #### Returns
    /// * `ByteArray` - A new ByteArray created from the input data
    fn new(size: usize, data: Array<u128>) -> ByteArray;
    /// instantiate a new ByteArray
    /// #### Returns
    /// * `ByteArray` - A new empty ByteArray
    fn new_empty() -> ByteArray;
    // get size. Same as len()
    /// #### Arguments
    /// * `self` - The ByteArray to get the size of
    /// #### Returns
    /// * `usize` - The size of the ByteArray
    fn size(self: @ByteArray) -> usize;
    /// Reads a 8-bit unsigned integer from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, u8)` - The new offset and the u8 value read
    fn read_u8(self: @ByteArray, offset: usize) -> (usize, u8);
    /// Reads a 16-bit unsigned integer from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, u16)` - The new offset and the u16 value read
    fn read_u16(self: @ByteArray, offset: usize) -> (usize, u16);
    /// Reads a 32-bit unsigned integer from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, u32)` - The new offset and the u32 value read
    fn read_u32(self: @ByteArray, offset: usize) -> (usize, u32);
    /// Reads a `usize` from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, usize)` - The new offset and the usize value read
    fn read_usize(self: @ByteArray, offset: usize) -> (usize, usize);
    /// Reads a 64-bit unsigned integer from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, u64)` - The new offset and the u64 value read
    fn read_u64(self: @ByteArray, offset: usize) -> (usize, u64);
    /// Reads a 128-bit unsigned integer from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, u128)` - The new offset and the u128 value read
    fn read_u128(self: @ByteArray, offset: usize) -> (usize, u128);
    /// Read value with size bytes from ByteArray, and packed into u128
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// * `size` - The number of bytes to read
    /// #### Returns
    /// * `(usize, u128)` - The new offset and the packed u128 value
    fn read_u128_packed(self: @ByteArray, offset: usize, size: usize) -> (usize, u128);
    /// Reads a packed array of `u128` values from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// * `array_length` - The length of the array to read
    /// * `element_size` - The size of each element in bytes
    /// #### Returns
    /// * `(usize, Array<u128>)` - The new offset and the array of u128 values
    fn read_u128_array_packed(
        self: @ByteArray, offset: usize, array_length: usize, element_size: usize,
    ) -> (usize, Array<u128>);
    /// Reads a 256-bit unsigned integer from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, u256)` - The new offset and the u256 value read
    fn read_u256(self: @ByteArray, offset: usize) -> (usize, u256);
    /// Reads an array of `u256` values from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// * `array_length` - The length of the array to read
    /// #### Returns
    /// * `(usize, Array<u256>)` - The new offset and the array of u256 values
    fn read_u256_array(
        self: @ByteArray, offset: usize, array_length: usize,
    ) -> (usize, Array<u256>);
    /// Reads a `felt252` (Starknet field element) from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, felt252)` - The new offset and the felt252 value read
    fn read_felt252(self: @ByteArray, offset: usize) -> (usize, felt252);
    /// Read value with size bytes from Bytes, and packed into felt252
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// * `size` - The number of bytes to read
    /// #### Returns
    /// * `(usize, felt252)` - The new offset and the packed felt252 value
    fn read_felt252_packed(self: @ByteArray, offset: usize, size: usize) -> (usize, felt252);
    /// Reads a `bytes31` value (31-byte sequence) from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, bytes31)` - The new offset and the bytes31 value read
    fn read_bytes31(self: @ByteArray, offset: usize) -> (usize, bytes31);
    /// Reads a Starknet contract address from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// #### Returns
    /// * `(usize, ContractAddress)` - The new offset and the contract address
    fn read_address(self: @ByteArray, offset: usize) -> (usize, ContractAddress);
    /// Reads a raw sequence of bytes of given `size` from the given offset.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// * `size` - The number of bytes to read
    /// #### Returns
    /// * `(usize, ByteArray)` - The new offset and the read bytes as ByteArray
    fn read_bytes(self: @ByteArray, offset: usize, size: usize) -> (usize, ByteArray);
    /// Appends a 8-bit unsigned integer to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u8(ref self: ByteArray, value: u8);
    /// Appends a 16-bit unsigned integer to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u16(ref self: ByteArray, value: u16);
    /// Appends a 16-bit unsigned integer to the `ByteArray` in little-endian format.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u16_le(ref self: ByteArray, value: u16);
    /// Appends a 32-bit unsigned integer to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u32(ref self: ByteArray, value: u32);
    /// Appends a 32-bit unsigned integer to the `ByteArray` in little-endian format.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u32_le(ref self: ByteArray, value: u32);
    /// Appends usize to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_usize(ref self: ByteArray, value: usize);
    /// Appends a 64-bit unsigned integer to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u64(ref self: ByteArray, value: u64);
    /// Appends a 64-bit unsigned integer to the `ByteArray` in little-endian format.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u64_le(ref self: ByteArray, value: u64);
    /// Appends a 128-bit unsigned integer to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u128(ref self: ByteArray, value: u128);
    /// Appends a 128-bit unsigned integer to the `ByteArray` in little-endian format.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u128_le(ref self: ByteArray, value: u128);
    /// Appends a 256-bit unsigned integer to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u256(ref self: ByteArray, value: u256);
    /// Appends a 256-bit unsigned integer to the `ByteArray` in little-endian format.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u256_le(ref self: ByteArray, value: u256);
    /// Appends a 512-bit unsigned integer to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_u512(ref self: ByteArray, value: u512);
    /// Appends a `felt252` to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_felt252(ref self: ByteArray, value: felt252);
    /// Appends bytes data of size `count` ordered in little endian
    /// #### Arguments
    /// * `bytes` - little endian ordered bytes to append
    /// * `count` - number of bytes from input to append
    fn append_bytes_le(ref self: ByteArray, bytes: felt252, count: usize);
    /// Appends a Starknet contract address to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_address(ref self: ByteArray, value: ContractAddress);
    /// Appends a `bytes31` value to the `ByteArray`.
    /// #### Arguments
    /// * `self` - The ByteArray to append to
    /// * `value` - The value to append
    fn append_bytes31(ref self: ByteArray, value: bytes31);
    /// Updates a byte at the given `offset` with a new value.
    /// #### Arguments
    /// * `self` - The ByteArray to update
    /// * `offset` - The offset to update at
    /// * `value` - The new value
    fn update_at(ref self: ByteArray, offset: usize, value: u8);
    /// Reads an unsigned integer of type T from the ByteArray starting at a given offset,
    /// with a specified size.
    /// #### Arguments
    /// * `self` - The ByteArray to read from
    /// * `offset` - The offset to read from
    /// * `size` - The number of bytes to read
    fn read_uint_within_size<
        T, +Add<T>, +Mul<T>, +Zero<T>, +TryInto<felt252, T>, +Drop<T>, +Into<u8, T>,
    >(
        self: @ByteArray, offset: usize, size: usize,
    ) -> (usize, T);
}


pub impl ByteArrayTraitExtImpl of ByteArrayTraitExt {
    /// Create a ByteArray from an array of u128
    #[inline(always)]
    fn new(size: usize, mut data: Array<u128>) -> ByteArray {
        if data.len() == 0 {
            return Default::default();
        }
        let mut index = 0;
        let mut ba: ByteArray = Default::default();
        while index != data.len() {
            Self::append_u128(ref ba, *data[index]);
            index += 1;
        }
        ba
    }

    /// instantiate a new ByteArray
    #[inline(always)]
    fn new_empty() -> ByteArray {
        Default::default()
    }

    /// get size. Same as len()
    #[inline(always)]
    fn size(self: @ByteArray) -> usize {
        self.len()
    }

    /// Read a u_ from ByteArray
    #[inline(always)]
    fn read_u8(self: @ByteArray, offset: usize) -> (usize, u8) {
        assert(offset <= self.len(), 'out of bound');
        (offset + 1, self.at(offset).unwrap())
    }

    /// Read a u16 from ByteArray
    #[inline(always)]
    fn read_u16(self: @ByteArray, offset: usize) -> (usize, u16) {
        read_uint::<u16>(self, offset, 2)
    }

    /// Read a u32 from ByteArray
    #[inline(always)]
    fn read_u32(self: @ByteArray, offset: usize) -> (usize, u32) {
        read_uint::<u32>(self, offset, 4)
    }

    /// Read a usize from ByteArray
    #[inline(always)]
    fn read_usize(self: @ByteArray, offset: usize) -> (usize, usize) {
        read_uint::<usize>(self, offset, 4)
    }

    /// Read a u64 from ByteArray
    #[inline(always)]
    fn read_u64(self: @ByteArray, offset: usize) -> (usize, u64) {
        read_uint::<u64>(self, offset, 8)
    }

    /// Read a u128 from ByteArray
    #[inline(always)]
    fn read_u128(self: @ByteArray, offset: usize) -> (usize, u128) {
        read_uint::<u128>(self, offset, 16)
    }

    /// Read value with size bytes from ByteArray, and packed into u128
    /// #### Arguments:
    ///  - offset: the offset in Bytes
    ///  - size: the number of bytes to read
    /// #### Returns:
    ///  - new_offset: next value offset in Bytes
    ///  - value: the value packed into u128
    #[inline(always)]
    fn read_u128_packed(self: @ByteArray, offset: usize, size: usize) -> (usize, u128) {
        // check
        assert(offset + size <= self.len(), 'out of bound');
        assert(size <= 16, 'too large');

        self.read_uint_within_size::<u128>(offset, size)
    }

    /// Read a u256 from ByteArray
    #[inline(always)]
    fn read_u256(self: @ByteArray, offset: usize) -> (usize, u256) {
        read_uint::<u256>(self, offset, 32)
    }

    /// Read value with size bytes from ByteArray, and packed into felt252
    /// #### Arguments:
    ///  - offset: the offset in Bytes
    ///  - size: the number of bytes to read
    /// #### Returns:
    ///  - new_offset: next value offset in Bytes
    ///  - value: the value packed into felt252
    #[inline(always)]
    fn read_felt252_packed(self: @ByteArray, offset: usize, size: usize) -> (usize, felt252) {
        // check
        assert(offset + size <= self.size(), 'out of bound');
        // Bytes unit is one byte
        // felt252 can hold 31 bytes max
        assert(size <= 31, 'too large');
        self.read_uint_within_size::<felt252>(offset, size)
    }


    #[inline(always)]
    fn read_felt252(self: @ByteArray, offset: usize) -> (usize, felt252) {
        let (new_offset, value) = read_uint::<felt252>(self, offset, 32);
        (new_offset, value.try_into().expect('Couldn\'t convert to felt252'))
    }

    /// Read a bytes31 from ByteArray
    #[inline(always)]
    fn read_bytes31(self: @ByteArray, offset: usize) -> (usize, bytes31) {
        assert(offset + 31 <= self.len(), 'out of bound');

        let (new_offset, high) = self.read_u128(offset);
        let (new_offset, low) = self.read_uint_within_size::<u128>(new_offset, 15);

        let low = OptBitShift::shl(low, 8);
        let mut value: u256 = u256 { high, low };
        value = OptBitShift::shr(value, 8);

        // Unwrap is always safe here, because highest byte is always 0
        let value: felt252 = value.try_into().expect('Couldn\'t convert to felt252');
        let value: bytes31 = value.try_into().expect('Couldn\'t convert to bytes31');
        (new_offset, value)
    }

    /// Read Contract Address from Bytes
    #[inline(always)]
    fn read_address(self: @ByteArray, offset: usize) -> (usize, ContractAddress) {
        let (new_offset, value) = self.read_u256(offset);
        let address: felt252 = value.try_into().expect('Couldn\'t convert to felt252');
        (new_offset, address.try_into().expect('Couldn\'t convert to address'))
    }

    /// Read bytes from ByteArray
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
            Self::append_u32(ref ba, value);
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

    /// Read an array of u128 values from ByteArray
    #[inline(always)]
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
            let (new_offset, value) = self.read_uint_within_size::<u128>(offset, element_size);
            array.append(value);
            offset = new_offset;
            i -= 1;
        }
        (offset, array)
    }

    /// Read an array of u256 values from ByteArray
    #[inline(always)]
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

    /// Reads an unsigned integer of type T from the ByteArray starting at a given offset,
    /// with a specified size.
    ///
    /// Inputs:
    /// - self: A reference to the ByteArray from which to read.
    /// - offset: The starting position in the ByteArray to begin reading.
    /// - size: The number of bytes to read.
    ///
    /// Outputs:
    /// - A tuple containing:
    ///   - The new offset after reading the specified number of bytes.
    ///   - The value of type T read from the ByteArray.
    fn read_uint_within_size<
        T, +Add<T>, +Mul<T>, +Zero<T>, +TryInto<felt252, T>, +Drop<T>, +Into<u8, T>,
    >(
        self: @ByteArray, offset: usize, size: usize,
    ) -> (usize, T) {
        read_uint::<T>(self, offset, size)
    }

    /// Append a u8 to ByteArray
    fn append_u8(ref self: ByteArray, value: u8) {
        self.append_byte(value);
    }

    /// Append a u16 to ByteArray
    #[inline]
    fn append_u16(ref self: ByteArray, value: u16) {
        self.append_word(value.into(), 2);
    }

    /// Append a u16 to ByteArray in little-endian format
    #[inline]
    fn append_u16_le(ref self: ByteArray, value: u16) {
        Self::append_bytes_le(ref self, value.into(), 2);
    }

    /// Append a u32 to ByteArray
    #[inline]
    fn append_u32(ref self: ByteArray, value: u32) {
        self.append_word(value.into(), 4);
    }

    /// Append a u32 to ByteArray in little-endian format
    #[inline]
    fn append_u32_le(ref self: ByteArray, value: u32) {
        Self::append_bytes_le(ref self, value.into(), 4);
    }

    /// Append a usize to ByteArray
    fn append_usize(ref self: ByteArray, value: usize) {
        self.append_word(value.into(), 4);
    }

    /// Append a u64 to ByteArray
    #[inline]
    fn append_u64(ref self: ByteArray, value: u64) {
        self.append_word(value.into(), 8);
    }

    /// Append a u64 to ByteArray in little-endian format
    #[inline]
    fn append_u64_le(ref self: ByteArray, value: u64) {
        Self::append_bytes_le(ref self, value.into(), 8);
    }

    /// Append a u128 to ByteArray
    #[inline]
    fn append_u128(ref self: ByteArray, value: u128) {
        self.append_word(value.into(), 16);
    }

    /// Append a u128 to ByteArray in little-endian format
    #[inline]
    fn append_u128_le(ref self: ByteArray, value: u128) {
        Self::append_bytes_le(ref self, value.into(), 16);
    }

    /// Append a u256 to ByteArray
    fn append_u256(ref self: ByteArray, value: u256) {
        Self::append_u128(ref self, value.high);
        Self::append_u128(ref self, value.low);
    }

    /// Append a u256 to ByteArray in little-endian format
    fn append_u256_le(ref self: ByteArray, value: u256) {
        Self::append_u128_le(ref self, value.low);
        Self::append_u128_le(ref self, value.high);
    }

    /// Append a u512 to ByteArray
    fn append_u512(ref self: ByteArray, value: u512) {
        let u512 { limb0, limb1, limb2, limb3 } = value;
        Self::append_u128(ref self, limb3);
        Self::append_u128(ref self, limb2);
        Self::append_u128(ref self, limb1);
        Self::append_u128(ref self, limb0);
    }

    /// Append a felt252 to ByteArray
    fn append_felt252(ref self: ByteArray, value: felt252) {
        Self::append_u256(ref self, value.into());
    }

    /// Append bytes data of size `count` ordered in little endian
    fn append_bytes_le(ref self: ByteArray, bytes: felt252, count: usize) {
        assert(count <= 16, 'count too big');
        let u256 { mut low, high: _high } = bytes.into();
        let mut index = 0;
        while (index != count) {
            let (remaining_bytes, next) = DivRem::div_rem(low, 0x100_u128.try_into().unwrap());
            low = remaining_bytes;
            // Unwrap safe by definition of remainder from division by 0x100
            self.append_byte(next.try_into().unwrap());
            index += 1;
        };
    }

    /// Append a ContractAddress to ByteArray
    fn append_address(ref self: ByteArray, value: ContractAddress) {
        let address: felt252 = value.into();
        self.append_felt252(address);
    }

    /// Append a bytes31 to ByteArray
    fn append_bytes31(ref self: ByteArray, value: bytes31) {
        let mut value: u256 = value.into();
        value = OptBitShift::shl(value, 8);
        Self::append_u256(ref self, value);
    }

    /// Update a byte at a specific offset in ByteArray
    fn update_at(ref self: ByteArray, offset: usize, value: u8) {
        assert(offset <= self.len(), 'out of bound');

        let (_, temp_l) = self.read_bytes(0, offset);
        let (_, temp_r) = self.read_bytes(offset + 1, self.len() - 1 - offset);
        let mut new_byte_array: ByteArray = temp_l;
        new_byte_array.append_byte(value);
        new_byte_array.append(@temp_r);
        self = new_byte_array;
    }
}

impl ByteAppenderSupportByteArrayImpl of ByteAppenderSupportTrait<ByteArray> {
    #[inline(always)]
    fn append_bytes_be(ref self: ByteArray, bytes: felt252, count: usize) {
        assert(count <= 16, 'count too big');
        self.append_word(bytes.into(), count);
    }

    #[inline(always)]
    fn append_bytes_le(ref self: ByteArray, bytes: felt252, count: usize) {
        // Use the same DivRem approach as ByteArrayTraitExtImpl for consistency
        ByteArrayTraitExtImpl::append_bytes_le(ref self, bytes, count);
    }
}

pub impl ByteArrayAppenderImpl of ByteAppender<T: ByteArray> {
    fn append_u16(ref self: ByteArray, word: u16) {
        ByteArrayTraitExtImpl::append_u16(ref self, word);
    }

    fn append_u16_le(ref self: ByteArray, word: u16) {
        ByteArrayTraitExtImpl::append_u16_le(ref self, word);
    }

    fn append_u32(ref self: ByteArray, word: u32) {
        ByteArrayTraitExtImpl::append_u32(ref self, word);
    }

    fn append_u32_le(ref self: ByteArray, word: u32) {
        ByteArrayTraitExtImpl::append_u32_le(ref self, word);
    }

    fn append_u64(ref self: ByteArray, word: u64) {
        ByteArrayTraitExtImpl::append_u64(ref self, word);
    }

    fn append_u64_le(ref self: ByteArray, word: u64) {
        ByteArrayTraitExtImpl::append_u64_le(ref self, word);
    }

    fn append_u128(ref self: ByteArray, word: u128) {
        ByteArrayTraitExtImpl::append_u128(ref self, word);
    }

    fn append_u128_le(ref self: ByteArray, word: u128) {
        ByteArrayTraitExtImpl::append_u128_le(ref self, word);
    }

    fn append_u256(ref self: ByteArray, word: u256) {
        ByteArrayTraitExtImpl::append_u256(ref self, word);
    }

    fn append_u256_le(ref self: ByteArray, word: u256) {
        let u256 { low, high } = word;
        Self::append_u128_le(ref self, low);
        Self::append_u128_le(ref self, high);
    }

    fn append_u512(ref self: ByteArray, word: u512) {
        ByteArrayTraitExtImpl::append_u512(ref self, word);
    }

    fn append_u512_le(ref self: ByteArray, word: u512) {
        let u512 { limb0, limb1, limb2, limb3 } = word;
        Self::append_u128_le(ref self, limb0);
        Self::append_u128_le(ref self, limb1);
        Self::append_u128_le(ref self, limb2);
        Self::append_u128_le(ref self, limb3);
    }

    fn append_i8(ref self: ByteArray, word: i8) {
        if word >= 0_i8 {
            self.append_bytes_be(word.into(), 1);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(1), 1);
        }
    }

    fn append_i16(ref self: ByteArray, word: i16) {
        if word >= 0_i16 {
            self.append_bytes_be(word.into(), 2);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(2), 2);
        }
    }

    fn append_i16_le(ref self: ByteArray, word: i16) {
        if word >= 0_i16 {
            ByteArrayTraitExtImpl::append_bytes_le(ref self, word.into(), 2);
        } else {
            ByteArrayTraitExtImpl::append_bytes_le(
                ref self, word.into() + one_shift_left_bytes_felt252(2), 2,
            );
        }
    }

    fn append_i32(ref self: ByteArray, word: i32) {
        if word >= 0_i32 {
            self.append_bytes_be(word.into(), 4);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(4), 4);
        }
    }

    fn append_i32_le(ref self: ByteArray, word: i32) {
        if word >= 0_i32 {
            ByteArrayTraitExtImpl::append_bytes_le(ref self, word.into(), 4);
        } else {
            ByteArrayTraitExtImpl::append_bytes_le(
                ref self, word.into() + one_shift_left_bytes_felt252(4), 4,
            );
        }
    }

    fn append_i64(ref self: ByteArray, word: i64) {
        if word >= 0_i64 {
            self.append_bytes_be(word.into(), 8);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(8), 8);
        }
    }

    fn append_i64_le(ref self: ByteArray, word: i64) {
        if word >= 0_i64 {
            ByteArrayTraitExtImpl::append_bytes_le(ref self, word.into(), 8);
        } else {
            ByteArrayTraitExtImpl::append_bytes_le(
                ref self, word.into() + one_shift_left_bytes_felt252(8), 8,
            );
        }
    }

    fn append_i128(ref self: ByteArray, word: i128) {
        if word >= 0_i128 {
            self.append_bytes_be(word.into(), 16);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(16), 16);
        }
    }

    fn append_i128_le(ref self: ByteArray, word: i128) {
        if word >= 0_i128 {
            ByteArrayTraitExtImpl::append_bytes_le(ref self, word.into(), 16);
        } else {
            ByteArrayTraitExtImpl::append_bytes_le(
                ref self, word.into() + one_shift_left_bytes_felt252(16), 16,
            );
        }
    }
}

/// Reads an unsigned integer of type T from the ByteArray starting at a given offset,
/// with a specified size.
///
/// Inputs:
/// - self: A reference to the ByteArray from which to read.
/// - offset: The starting position in the ByteArray to begin reading.
/// - size: The number of bytes to read.
///
/// Outputs:
/// - A tuple containing:
///   - The new offset after reading the specified number of bytes.
///   - The value of type T read from the ByteArray.
fn read_uint<T, +Add<T>, +Mul<T>, +Zero<T>, +TryInto<felt252, T>, +Drop<T>, +Into<u8, T>>(
    self: @ByteArray, offset: usize, mut size: usize,
) -> (usize, T) {
    // Uncomment the following line to enforce bounds checking
    assert(offset + size <= self.len(), 'out of bound');

    // Adjust size if it exceeds the length of the ByteArray
    if size > self.len() && offset == 0 {
        size = self.len() - offset;
    }

    let mut value: T = Zero::zero();
    let mut i = 0;

    // Read bytes and accumulate the value
    while i < size {
        let byte: u8 = self.at(offset + i).unwrap();
        value = (value * 256.try_into().unwrap()) + byte.into();
        i += 1;
    }

    (offset + size, value)
}
