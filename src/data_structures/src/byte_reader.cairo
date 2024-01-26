use bytes_31::{one_shift_left_bytes_u128, one_shift_left_bytes_felt252};
use integer::u512;

#[derive(Copy, Clone, Drop)]
struct ByteReaderState<T> {
    data: @T,
    index: usize,
}

trait ByteReader<T> {
    /// Wraps the array of bytes in a ByteReader for sequential consumption of integers and/or bytes
    /// # Returns
    /// * `ByteReader` - The reader struct wrapping a read-only snapshot of this ByteArray
    fn reader(self: @T) -> ByteReaderState<T>;
    /// Checks that there are enough remaining bytes available
    /// # Arguments
    /// * `at` - the start index position of the byte data
    /// * `count` - the number of bytes required
    /// # Returns
    /// * `bool` - `true` when there are `count` bytes remaining, `false` otherwise.
    fn remaining(self: @T, at: usize, count: usize) -> bool;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in big endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u16>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u16(self: @T, offset: usize) -> Option<u16>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in little endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u16>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u16_le(self: @T, offset: usize) -> Option<u16>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in big endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u32>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u32(self: @T, offset: usize) -> Option<u32>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in little endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u32>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u32_le(self: @T, offset: usize) -> Option<u32>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in big endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u64>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u64(self: @T, offset: usize) -> Option<u64>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in little endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u64>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u64_le(self: @T, offset: usize) -> Option<u64>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in big endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u128>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u128(self: @T, offset: usize) -> Option<u128>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in little endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u128>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u128_le(self: @T, offset: usize) -> Option<u128>;
    /// Reads a u8 unsigned integer
    /// # Returns
    /// `Option<u8>` - If there are enough bytes remaining an optional integer is returned
    fn read_u8(ref self: ByteReaderState<T>) -> Option<u8>;
    /// Reads a u16 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u16>` - If there are enough bytes remaining an optional integer is returned
    fn read_u16(ref self: ByteReaderState<T>) -> Option<u16>;
    /// Reads a u16 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u16>` - If there are enough bytes remaining an optional integer is returned
    fn read_u16_le(ref self: ByteReaderState<T>) -> Option<u16>;
    /// Reads a u32 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u32>` - If there are enough bytes remaining an optional integer is returned
    fn read_u32(ref self: ByteReaderState<T>) -> Option<u32>;
    /// Reads a u32 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u32>` - If there are enough bytes remaining an optional integer is returned
    fn read_u32_le(ref self: ByteReaderState<T>) -> Option<u32>;
    /// Reads a u64 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u64>` - If there are enough bytes remaining an optional integer is returned
    fn read_u64(ref self: ByteReaderState<T>) -> Option<u64>;
    /// Reads a u64 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u64>` - If there are enough bytes remaining an optional integer is returned
    fn read_u64_le(ref self: ByteReaderState<T>) -> Option<u64>;
    /// Reads a u128 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u218>` - If there are enough bytes remaining an optional integer is returned
    fn read_u128(ref self: ByteReaderState<T>) -> Option<u128>;
    /// Reads a u128 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u218>` - If there are enough bytes remaining an optional integer is returned
    fn read_u128_le(ref self: ByteReaderState<T>) -> Option<u128>;
    /// Reads a u256 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u256>` - If there are enough bytes remaining an optional integer is returned
    fn read_u256(ref self: ByteReaderState<T>) -> Option<u256>;
    /// Reads a u256 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u256>` - If there are enough bytes remaining an optional integer is returned
    fn read_u256_le(ref self: ByteReaderState<T>) -> Option<u256>;
    /// Reads a u512 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u512>` - If there are enough bytes remaining an optional integer is returned
    fn read_u512(ref self: ByteReaderState<T>) -> Option<u512>;
    /// Reads a u512 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u512>` - If there are enough bytes remaining an optional integer is returned
    fn read_u512_le(ref self: ByteReaderState<T>) -> Option<u512>;
    /// Reads an i8 signed integer in two's complement encoding from the ByteArray
    /// # Returns
    /// `Option<i8>` - If there are enough bytes remaining an optional integer is returned
    fn read_i8(ref self: ByteReaderState<T>) -> Option<i8>;
    /// Reads an i16 signed integer in two's complement encoding from the ByteArray in big endian byte order
    /// # Returns
    /// `Option<i16>` - If there are enough bytes remaining an optional integer is returned
    fn read_i16(ref self: ByteReaderState<T>) -> Option<i16>;
    /// Reads an i16 signed integer in two's complement encoding from the ByteArray in little endian byte order
    /// # Returns
    /// `Option<i16>` - If there are enough bytes remaining an optional integer is returned
    fn read_i16_le(ref self: ByteReaderState<T>) -> Option<i16>;
    /// Reads an i32 signed integer in two's complement encoding from the ByteArray in big endian byte order
    /// # Returns
    /// `Option<i32>` - If there are enough bytes remaining an optional integer is returned
    fn read_i32(ref self: ByteReaderState<T>) -> Option<i32>;
    /// Reads an i32 signed integer in two's complement encoding from the ByteArray in little endian byte order
    /// # Returns
    /// `Option<i32>` - If there are enough bytes remaining an optional integer is returned
    fn read_i32_le(ref self: ByteReaderState<T>) -> Option<i32>;
    /// Reads an i64 signed integer in two's complement encoding from the ByteArray in big endian byte order
    /// # Returns
    /// `Option<i64>` - If there are enough bytes remaining an optional integer is returned
    fn read_i64(ref self: ByteReaderState<T>) -> Option<i64>;
    /// Reads an i64 signed integer in two's complement encoding from the ByteArray in little endian byte order
    /// # Returns
    /// `Option<i64>` - If there are enough bytes remaining an optional integer is returned
    fn read_i64_le(ref self: ByteReaderState<T>) -> Option<i64>;
    /// Reads an i128 signed integer in two's complement encoding from the ByteArray in big endian byte order
    /// # Returns
    /// `Option<i128>` - If there are enough bytes remaining an optional integer is returned
    fn read_i128(ref self: ByteReaderState<T>) -> Option<i128>;
    /// Reads an i128 signed integer in two's complement encoding from the ByteArray in little endian byte order
    /// # Returns
    /// `Option<i128>` - If there are enough bytes remaining an optional integer is returned
    fn read_i128_le(ref self: ByteReaderState<T>) -> Option<i128>;
    /// Remaining length count relative to what has already been consume/read
    /// # Returns
    /// `usize` - count number of bytes remaining
    fn len(self: @ByteReaderState<T>) -> usize;
}

impl ByteReaderImpl<T, +Drop<T>, +Len<T>, +IndexView<T, usize, @u8>> of ByteReader<T> {
    #[inline]
    fn reader(self: @T) -> ByteReaderState<T> {
        ByteReaderState { data: self, index: 0 }
    }

    #[inline]
    fn remaining(self: @T, at: usize, count: usize) -> bool {
        at + count - 1 < self.len()
    }

    #[inline]
    fn word_u16(self: @T, offset: usize) -> Option<u16> {
        if self.remaining(offset, 2) {
            let b1 = *self[offset];
            let b2 = *self[offset + 1];
            Option::Some(b1.into() * one_shift_left_bytes_u128(1).try_into().unwrap() + b2.into())
        } else {
            Option::None
        }
    }

    #[inline]
    fn word_u16_le(self: @T, offset: usize) -> Option<u16> {
        if self.remaining(offset, 2) {
            let b1 = *self[offset];
            let b2 = *self[offset + 1];
            Option::Some(b1.into() + b2.into() * one_shift_left_bytes_u128(1).try_into().unwrap())
        } else {
            Option::None
        }
    }

    #[inline]
    fn word_u32(self: @T, offset: usize) -> Option<u32> {
        if self.remaining(offset, 4) {
            let b1 = *self[offset];
            let b2 = *self[offset + 1];
            let b3 = *self[offset + 2];
            let b4 = *self[offset + 3];
            Option::Some(
                b1.into() * one_shift_left_bytes_u128(3).try_into().unwrap()
                    + b2.into() * one_shift_left_bytes_u128(2).try_into().unwrap()
                    + b3.into() * one_shift_left_bytes_u128(1).try_into().unwrap()
                    + b4.into()
            )
        } else {
            Option::None
        }
    }

    #[inline]
    fn word_u32_le(self: @T, offset: usize) -> Option<u32> {
        if self.remaining(offset, 4) {
            let b1 = *self[offset];
            let b2 = *self[offset + 1];
            let b3 = *self[offset + 2];
            let b4 = *self[offset + 3];
            Option::Some(
                b1.into()
                    + b2.into() * one_shift_left_bytes_u128(1).try_into().unwrap()
                    + b3.into() * one_shift_left_bytes_u128(2).try_into().unwrap()
                    + b4.into() * one_shift_left_bytes_u128(3).try_into().unwrap()
            )
        } else {
            Option::None
        }
    }

    #[inline]
    fn word_u64(self: @T, offset: usize) -> Option<u64> {
        if self.remaining(offset, 8) {
            let b1 = *self[offset];
            let b2 = *self[offset + 1];
            let b3 = *self[offset + 2];
            let b4 = *self[offset + 3];
            let b5 = *self[offset + 4];
            let b6 = *self[offset + 5];
            let b7 = *self[offset + 6];
            let b8 = *self[offset + 7];
            Option::Some(
                b1.into() * one_shift_left_bytes_u128(7).try_into().unwrap()
                    + b2.into() * one_shift_left_bytes_u128(6).try_into().unwrap()
                    + b3.into() * one_shift_left_bytes_u128(5).try_into().unwrap()
                    + b4.into() * one_shift_left_bytes_u128(4).try_into().unwrap()
                    + b5.into() * one_shift_left_bytes_u128(3).try_into().unwrap()
                    + b6.into() * one_shift_left_bytes_u128(2).try_into().unwrap()
                    + b7.into() * one_shift_left_bytes_u128(1).try_into().unwrap()
                    + b8.into()
            )
        } else {
            Option::None
        }
    }

    #[inline]
    fn word_u64_le(self: @T, offset: usize) -> Option<u64> {
        if self.remaining(offset, 8) {
            let b1 = *self[offset];
            let b2 = *self[offset + 1];
            let b3 = *self[offset + 2];
            let b4 = *self[offset + 3];
            let b5 = *self[offset + 4];
            let b6 = *self[offset + 5];
            let b7 = *self[offset + 6];
            let b8 = *self[offset + 7];
            Option::Some(
                b1.into()
                    + b2.into() * one_shift_left_bytes_u128(1).try_into().unwrap()
                    + b3.into() * one_shift_left_bytes_u128(2).try_into().unwrap()
                    + b4.into() * one_shift_left_bytes_u128(3).try_into().unwrap()
                    + b5.into() * one_shift_left_bytes_u128(4).try_into().unwrap()
                    + b6.into() * one_shift_left_bytes_u128(5).try_into().unwrap()
                    + b7.into() * one_shift_left_bytes_u128(6).try_into().unwrap()
                    + b8.into() * one_shift_left_bytes_u128(7).try_into().unwrap()
            )
        } else {
            Option::None
        }
    }

    #[inline]
    fn word_u128(self: @T, offset: usize) -> Option<u128> {
        if self.remaining(offset, 16) {
            let b01 = *self[offset];
            let b02 = *self[offset + 1];
            let b03 = *self[offset + 2];
            let b04 = *self[offset + 3];
            let b05 = *self[offset + 4];
            let b06 = *self[offset + 5];
            let b07 = *self[offset + 6];
            let b08 = *self[offset + 7];
            let b09 = *self[offset + 8];
            let b10 = *self[offset + 9];
            let b11 = *self[offset + 10];
            let b12 = *self[offset + 11];
            let b13 = *self[offset + 12];
            let b14 = *self[offset + 13];
            let b15 = *self[offset + 14];
            let b16 = *self[offset + 15];
            Option::Some(
                b01.into() * one_shift_left_bytes_u128(15).try_into().unwrap()
                    + b02.into() * one_shift_left_bytes_u128(14).try_into().unwrap()
                    + b03.into() * one_shift_left_bytes_u128(13).try_into().unwrap()
                    + b04.into() * one_shift_left_bytes_u128(12).try_into().unwrap()
                    + b05.into() * one_shift_left_bytes_u128(11).try_into().unwrap()
                    + b06.into() * one_shift_left_bytes_u128(10).try_into().unwrap()
                    + b07.into() * one_shift_left_bytes_u128(09).try_into().unwrap()
                    + b08.into() * one_shift_left_bytes_u128(08).try_into().unwrap()
                    + b09.into() * one_shift_left_bytes_u128(07).try_into().unwrap()
                    + b10.into() * one_shift_left_bytes_u128(06).try_into().unwrap()
                    + b11.into() * one_shift_left_bytes_u128(05).try_into().unwrap()
                    + b12.into() * one_shift_left_bytes_u128(04).try_into().unwrap()
                    + b13.into() * one_shift_left_bytes_u128(03).try_into().unwrap()
                    + b14.into() * one_shift_left_bytes_u128(02).try_into().unwrap()
                    + b15.into() * one_shift_left_bytes_u128(01).try_into().unwrap()
                    + b16.into()
            )
        } else {
            Option::None
        }
    }

    #[inline]
    fn word_u128_le(self: @T, offset: usize) -> Option<u128> {
        if self.remaining(offset, 16) {
            let b01 = *self[offset];
            let b02 = *self[offset + 1];
            let b03 = *self[offset + 2];
            let b04 = *self[offset + 3];
            let b05 = *self[offset + 4];
            let b06 = *self[offset + 5];
            let b07 = *self[offset + 6];
            let b08 = *self[offset + 7];
            let b09 = *self[offset + 8];
            let b10 = *self[offset + 9];
            let b11 = *self[offset + 10];
            let b12 = *self[offset + 11];
            let b13 = *self[offset + 12];
            let b14 = *self[offset + 13];
            let b15 = *self[offset + 14];
            let b16 = *self[offset + 15];
            Option::Some(
                b01.into()
                    + b02.into() * one_shift_left_bytes_u128(01).try_into().unwrap()
                    + b03.into() * one_shift_left_bytes_u128(02).try_into().unwrap()
                    + b04.into() * one_shift_left_bytes_u128(03).try_into().unwrap()
                    + b05.into() * one_shift_left_bytes_u128(04).try_into().unwrap()
                    + b06.into() * one_shift_left_bytes_u128(05).try_into().unwrap()
                    + b07.into() * one_shift_left_bytes_u128(06).try_into().unwrap()
                    + b08.into() * one_shift_left_bytes_u128(07).try_into().unwrap()
                    + b09.into() * one_shift_left_bytes_u128(08).try_into().unwrap()
                    + b10.into() * one_shift_left_bytes_u128(09).try_into().unwrap()
                    + b11.into() * one_shift_left_bytes_u128(10).try_into().unwrap()
                    + b12.into() * one_shift_left_bytes_u128(11).try_into().unwrap()
                    + b13.into() * one_shift_left_bytes_u128(12).try_into().unwrap()
                    + b14.into() * one_shift_left_bytes_u128(13).try_into().unwrap()
                    + b15.into() * one_shift_left_bytes_u128(14).try_into().unwrap()
                    + b16.into() * one_shift_left_bytes_u128(15).try_into().unwrap()
            )
        } else {
            Option::None
        }
    }

    fn read_u8(ref self: ByteReaderState<T>) -> Option<u8> {
        if self.data.remaining(self.index, 1) {
            let result = *self.data[self.index];
            self.index += 1;
            Option::Some(result)
        } else {
            Option::None
        }
    }

    fn read_u16(ref self: ByteReaderState<T>) -> Option<u16> {
        let result = self.data.word_u16(self.index)?;
        self.index += 2;
        Option::Some(result)
    }

    fn read_u16_le(ref self: ByteReaderState<T>) -> Option<u16> {
        let result = self.data.word_u16_le(self.index)?;
        self.index += 2;
        Option::Some(result)
    }

    fn read_u32(ref self: ByteReaderState<T>) -> Option<u32> {
        let result = self.data.word_u32(self.index)?;
        self.index += 4;
        Option::Some(result)
    }

    fn read_u32_le(ref self: ByteReaderState<T>) -> Option<u32> {
        let result = self.data.word_u32_le(self.index)?;
        self.index += 4;
        Option::Some(result)
    }

    fn read_u64(ref self: ByteReaderState<T>) -> Option<u64> {
        let result = self.data.word_u64(self.index)?;
        self.index += 8;
        Option::Some(result)
    }

    fn read_u64_le(ref self: ByteReaderState<T>) -> Option<u64> {
        let result = self.data.word_u64_le(self.index)?;
        self.index += 8;
        Option::Some(result)
    }

    fn read_u128(ref self: ByteReaderState<T>) -> Option<u128> {
        let result = self.data.word_u128(self.index)?;
        self.index += 16;
        Option::Some(result)
    }

    fn read_u128_le(ref self: ByteReaderState<T>) -> Option<u128> {
        let result = self.data.word_u128_le(self.index)?;
        self.index += 16;
        Option::Some(result)
    }

    fn read_u256(ref self: ByteReaderState<T>) -> Option<u256> {
        let result = u256 {
            high: self.data.word_u128(self.index)?, low: self.data.word_u128(self.index + 16)?
        };
        self.index += 32;
        Option::Some(result)
    }

    fn read_u256_le(ref self: ByteReaderState<T>) -> Option<u256> {
        let result = u256 {
            low: self.data.word_u128_le(self.index)?, high: self.data.word_u128_le(self.index + 16)?
        };
        self.index += 32;
        Option::Some(result)
    }

    fn read_u512(ref self: ByteReaderState<T>) -> Option<u512> {
        let result = u512 {
            limb3: self.data.word_u128(self.index)?,
            limb2: self.data.word_u128(self.index + 16)?,
            limb1: self.data.word_u128(self.index + 32)?,
            limb0: self.data.word_u128(self.index + 48)?
        };
        self.index += 64;
        Option::Some(result)
    }

    fn read_u512_le(ref self: ByteReaderState<T>) -> Option<u512> {
        let result = u512 {
            limb0: self.data.word_u128_le(self.index)?,
            limb1: self.data.word_u128_le(self.index + 16)?,
            limb2: self.data.word_u128_le(self.index + 32)?,
            limb3: self.data.word_u128_le(self.index + 48)?
        };
        self.index += 64;
        Option::Some(result)
    }

    fn read_i8(ref self: ByteReaderState<T>) -> Option<i8> {
        let felt: felt252 = self.read_u8()?.into();
        parse_signed(felt, 1)
    }

    fn read_i16(ref self: ByteReaderState<T>) -> Option<i16> {
        let felt: felt252 = self.read_u16()?.into();
        parse_signed(felt, 2)
    }

    fn read_i16_le(ref self: ByteReaderState<T>) -> Option<i16> {
        let felt: felt252 = self.read_u16_le()?.into();
        parse_signed(felt, 2)
    }

    fn read_i32(ref self: ByteReaderState<T>) -> Option<i32> {
        let felt: felt252 = self.read_u32()?.into();
        parse_signed(felt, 4)
    }

    fn read_i32_le(ref self: ByteReaderState<T>) -> Option<i32> {
        let felt: felt252 = self.read_u32_le()?.into();
        parse_signed(felt, 4)
    }

    fn read_i64(ref self: ByteReaderState<T>) -> Option<i64> {
        let felt: felt252 = self.read_u64()?.into();
        parse_signed(felt, 8)
    }

    fn read_i64_le(ref self: ByteReaderState<T>) -> Option<i64> {
        let felt: felt252 = self.read_u64_le()?.into();
        parse_signed(felt, 8)
    }

    fn read_i128(ref self: ByteReaderState<T>) -> Option<i128> {
        let felt: felt252 = self.read_u128()?.into();
        parse_signed(felt, 16)
    }

    fn read_i128_le(ref self: ByteReaderState<T>) -> Option<i128> {
        let felt: felt252 = self.read_u128_le()?.into();
        parse_signed(felt, 16)
    }

    #[inline]
    fn len(self: @ByteReaderState<T>) -> usize {
        Len::len(self)
    }
}

fn parse_signed<T, +TryInto<felt252, T>>(value: felt252, bytes: usize) -> Option<T> {
    match value.try_into() {
        Option::Some(pos) => Option::Some(pos),
        Option::None => {
            let negated: felt252 = value - one_shift_left_bytes_felt252(bytes);
            negated.try_into()
        },
    }
}

/// Len trait that abstracts the `len()` property of `Array<u8>`, `Span<u8>` and `ByteArray` types
trait Len<T> {
    fn len(self: @T) -> usize;
}

impl ArrayU8LenImpl of Len<Array<u8>> {
    #[inline]
    fn len(self: @Array<u8>) -> usize {
        core::array::array_len::<u8>(self)
    }
}

impl SpanU8LenImpl of Len<Span<u8>> {
    #[inline]
    fn len(self: @Span<u8>) -> usize {
        SpanTrait::<u8>::len(*self)
    }
}


impl ByteArrayLenImpl of Len<ByteArray> {
    #[inline]
    fn len(self: @ByteArray) -> usize {
        ByteArrayTrait::len(self)
    }
}

impl ByteReaderLenImpl<T, +Len<T>> of Len<ByteReaderState<T>> {
    /// Returns the remaining length of the ByteReader
    /// # Returns
    /// `usize` - The number of bytes remaining, considering the number of bytes that have already been consumed
    #[inline]
    fn len(self: @ByteReaderState<T>) -> usize {
        let byte_array = *self.data;
        let byte_array_len = byte_array.len();
        byte_array_len - *self.index
    }
}

impl ByteArrayIndexViewAsSnapshotImpl of IndexView<ByteArray, usize, @u8> {
    #[inline(always)]
    fn index(self: @ByteArray, index: usize) -> @u8 {
        @self.at(index).expect('Index out of bounds')
    }
}

impl ByteReaderIndexViewImpl<
    T, impl TIndexView: IndexView<T, usize, @u8>
> of IndexView<ByteReaderState<T>, usize, @u8> {
    #[inline(always)]
    fn index(self: @ByteReaderState<T>, index: usize) -> @u8 {
        TIndexView::index(*self.data, index)
    }
}

impl ArrayU8ReaderImpl = ByteReaderImpl<Array<u8>>;
impl SpanU8ReaderImpl = ByteReaderImpl<Span<u8>>;
impl ByteArrayReaderImpl = ByteReaderImpl<ByteArray>;
