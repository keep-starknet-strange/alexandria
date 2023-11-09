use alexandria_data_structures::byte_array_ext::ByteArrayTraitExt;
use byte_array::ByteArray;
use bytes_31::one_shift_left_bytes_felt252;
use integer::u512;

/// A read-only snapshot of an underlying ByteArray that maintains
/// sequential access to the integers encoded in the array
#[derive(Copy, Drop)]
struct ByteArrayReader {
    /// A snapshot of the ByteArray
    data: @ByteArray,
    /// The `read_index` is incremented in accordance with the integers consumed
    reader_index: usize,
}

trait ByteArrayReaderTrait {
    /// Creates a ByteArrayReader from a ByteArray snapshot
    /// # Arguments
    /// * `from` - a ByteArray snapshot to read from
    /// # Returns
    /// `ByteArrayReader` - a new reader starting at the beginning of the underlying ByteArray
    fn new(from: @ByteArray) -> ByteArrayReader;
    /// Reads a u8 unsigned integer
    /// # Returns
    /// `Option<u8>` - If there are enough bytes remaining an optional integer is returned
    fn read_u8(ref self: ByteArrayReader) -> Option<u8>;
    /// Reads a u16 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u16>` - If there are enough bytes remaining an optional integer is returned
    fn read_u16(ref self: ByteArrayReader) -> Option<u16>;
    /// Reads a u16 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u16>` - If there are enough bytes remaining an optional integer is returned
    fn read_u16_le(ref self: ByteArrayReader) -> Option<u16>;
    /// Reads a u32 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u32>` - If there are enough bytes remaining an optional integer is returned
    fn read_u32(ref self: ByteArrayReader) -> Option<u32>;
    /// Reads a u32 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u32>` - If there are enough bytes remaining an optional integer is returned
    fn read_u32_le(ref self: ByteArrayReader) -> Option<u32>;
    /// Reads a u64 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u64>` - If there are enough bytes remaining an optional integer is returned
    fn read_u64(ref self: ByteArrayReader) -> Option<u64>;
    /// Reads a u64 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u64>` - If there are enough bytes remaining an optional integer is returned
    fn read_u64_le(ref self: ByteArrayReader) -> Option<u64>;
    /// Reads a u128 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u218>` - If there are enough bytes remaining an optional integer is returned
    fn read_u128(ref self: ByteArrayReader) -> Option<u128>;
    /// Reads a u128 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u218>` - If there are enough bytes remaining an optional integer is returned
    fn read_u128_le(ref self: ByteArrayReader) -> Option<u128>;
    /// Reads a u256 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u256>` - If there are enough bytes remaining an optional integer is returned
    fn read_u256(ref self: ByteArrayReader) -> Option<u256>;
    /// Reads a u256 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u256>` - If there are enough bytes remaining an optional integer is returned
    fn read_u256_le(ref self: ByteArrayReader) -> Option<u256>;
    /// Reads a u512 unsigned integer in big endian byte order
    /// # Returns
    /// `Option<u512>` - If there are enough bytes remaining an optional integer is returned
    fn read_u512(ref self: ByteArrayReader) -> Option<u512>;
    /// Reads a u512 unsigned integer in little endian byte order
    /// # Returns
    /// `Option<u512>` - If there are enough bytes remaining an optional integer is returned
    fn read_u512_le(ref self: ByteArrayReader) -> Option<u512>;
    /// Reads an i8 signed integer in two's complement encoding from the ByteArray
    /// # Returns
    /// `Option<i8>` - If there are enough bytes remaining an optional integer is returned
    fn read_i8(ref self: ByteArrayReader) -> Option<i8>;
    /// Reads an i16 signed integer in two's complement encoding from the ByteArray in big endian byte order
    /// # Returns
    /// `Option<i16>` - If there are enough bytes remaining an optional integer is returned
    fn read_i16(ref self: ByteArrayReader) -> Option<i16>;
    /// Reads an i16 signed integer in two's complement encoding from the ByteArray in little endian byte order
    /// # Returns
    /// `Option<i16>` - If there are enough bytes remaining an optional integer is returned
    fn read_i16_le(ref self: ByteArrayReader) -> Option<i16>;
    /// Reads an i32 signed integer in two's complement encoding from the ByteArray in big endian byte order
    /// # Returns
    /// `Option<i32>` - If there are enough bytes remaining an optional integer is returned
    fn read_i32(ref self: ByteArrayReader) -> Option<i32>;
    /// Reads an i32 signed integer in two's complement encoding from the ByteArray in little endian byte order
    /// # Returns
    /// `Option<i32>` - If there are enough bytes remaining an optional integer is returned
    fn read_i32_le(ref self: ByteArrayReader) -> Option<i32>;
    /// Reads an i64 signed integer in two's complement encoding from the ByteArray in big endian byte order
    /// # Returns
    /// `Option<i64>` - If there are enough bytes remaining an optional integer is returned
    fn read_i64(ref self: ByteArrayReader) -> Option<i64>;
    /// Reads an i64 signed integer in two's complement encoding from the ByteArray in little endian byte order
    /// # Returns
    /// `Option<i64>` - If there are enough bytes remaining an optional integer is returned
    fn read_i64_le(ref self: ByteArrayReader) -> Option<i64>;
    /// Reads an i128 signed integer in two's complement encoding from the ByteArray in big endian byte order
    /// # Returns
    /// `Option<i128>` - If there are enough bytes remaining an optional integer is returned
    fn read_i128(ref self: ByteArrayReader) -> Option<i128>;
    /// Reads an i128 signed integer in two's complement encoding from the ByteArray in little endian byte order
    /// # Returns
    /// `Option<i128>` - If there are enough bytes remaining an optional integer is returned
    fn read_i128_le(ref self: ByteArrayReader) -> Option<i128>;
    /// Returns the remaining length of the ByteArrayReader
    /// # Returns
    /// `usize` - The number of bytes remaining, considering the number of bytes that have already been consumed
    fn len(self: @ByteArrayReader) -> usize;
}

impl ByteArrayReaderImpl of ByteArrayReaderTrait {
    fn new(from: @ByteArray) -> ByteArrayReader {
        ByteArrayReader { data: from, reader_index: 0, }
    }

    fn read_u8(ref self: ByteArrayReader) -> Option<u8> {
        let byte = self.data.at(self.reader_index)?;
        self.reader_index += 1;
        Option::Some(byte)
    }

    fn read_u16(ref self: ByteArrayReader) -> Option<u16> {
        let result = self.data.word_u16(self.reader_index)?;
        self.reader_index += 2;
        Option::Some(result)
    }

    fn read_u16_le(ref self: ByteArrayReader) -> Option<u16> {
        let result = self.data.word_u16_le(self.reader_index)?;
        self.reader_index += 2;
        Option::Some(result)
    }

    fn read_u32(ref self: ByteArrayReader) -> Option<u32> {
        let result = self.data.word_u32(self.reader_index)?;
        self.reader_index += 4;
        Option::Some(result)
    }

    fn read_u32_le(ref self: ByteArrayReader) -> Option<u32> {
        let result = self.data.word_u32_le(self.reader_index)?;
        self.reader_index += 4;
        Option::Some(result)
    }

    fn read_u64(ref self: ByteArrayReader) -> Option<u64> {
        let result = self.data.word_u64(self.reader_index)?;
        self.reader_index += 8;
        Option::Some(result)
    }

    fn read_u64_le(ref self: ByteArrayReader) -> Option<u64> {
        let result = self.data.word_u64_le(self.reader_index)?;
        self.reader_index += 8;
        Option::Some(result)
    }

    fn read_u128(ref self: ByteArrayReader) -> Option<u128> {
        let result = self.data.word_u128(self.reader_index)?;
        self.reader_index += 16;
        Option::Some(result)
    }

    fn read_u128_le(ref self: ByteArrayReader) -> Option<u128> {
        let result = self.data.word_u128_le(self.reader_index)?;
        self.reader_index += 16;
        Option::Some(result)
    }

    fn read_u256(ref self: ByteArrayReader) -> Option<u256> {
        let result = u256 {
            high: self.data.word_u128(self.reader_index)?,
            low: self.data.word_u128(self.reader_index + 16)?
        };
        self.reader_index += 32;
        Option::Some(result)
    }

    fn read_u256_le(ref self: ByteArrayReader) -> Option<u256> {
        let result = u256 {
            low: self.data.word_u128_le(self.reader_index)?,
            high: self.data.word_u128_le(self.reader_index + 16)?
        };
        self.reader_index += 32;
        Option::Some(result)
    }

    fn read_u512(ref self: ByteArrayReader) -> Option<u512> {
        let result = u512 {
            limb3: self.data.word_u128(self.reader_index)?,
            limb2: self.data.word_u128(self.reader_index + 16)?,
            limb1: self.data.word_u128(self.reader_index + 32)?,
            limb0: self.data.word_u128(self.reader_index + 48)?
        };
        self.reader_index += 64;
        Option::Some(result)
    }

    fn read_u512_le(ref self: ByteArrayReader) -> Option<u512> {
        let result = u512 {
            limb0: self.data.word_u128_le(self.reader_index)?,
            limb1: self.data.word_u128_le(self.reader_index + 16)?,
            limb2: self.data.word_u128_le(self.reader_index + 32)?,
            limb3: self.data.word_u128_le(self.reader_index + 48)?
        };
        self.reader_index += 64;
        Option::Some(result)
    }

    fn read_i8(ref self: ByteArrayReader) -> Option<i8> {
        let felt: felt252 = self.read_u8()?.into();
        Option::Some(parse_signed(felt, 1).unwrap())
    }

    fn read_i16(ref self: ByteArrayReader) -> Option<i16> {
        let felt: felt252 = self.read_u16()?.into();
        Option::Some(parse_signed(felt, 2).unwrap())
    }

    fn read_i16_le(ref self: ByteArrayReader) -> Option<i16> {
        let felt: felt252 = self.read_u16_le()?.into();
        Option::Some(parse_signed(felt, 2).unwrap())
    }

    fn read_i32(ref self: ByteArrayReader) -> Option<i32> {
        let felt: felt252 = self.read_u32()?.into();
        Option::Some(parse_signed(felt, 4).unwrap())
    }

    fn read_i32_le(ref self: ByteArrayReader) -> Option<i32> {
        let felt: felt252 = self.read_u32_le()?.into();
        Option::Some(parse_signed(felt, 4).unwrap())
    }

    fn read_i64(ref self: ByteArrayReader) -> Option<i64> {
        let felt: felt252 = self.read_u64()?.into();
        Option::Some(parse_signed(felt, 8).unwrap())
    }

    fn read_i64_le(ref self: ByteArrayReader) -> Option<i64> {
        let felt: felt252 = self.read_u64_le()?.into();
        Option::Some(parse_signed(felt, 8).unwrap())
    }

    fn read_i128(ref self: ByteArrayReader) -> Option<i128> {
        let felt: felt252 = self.read_u128()?.into();
        Option::Some(parse_signed(felt, 16).unwrap())
    }

    fn read_i128_le(ref self: ByteArrayReader) -> Option<i128> {
        let felt: felt252 = self.read_u128_le()?.into();
        Option::Some(parse_signed(felt, 16).unwrap())
    }

    fn len(self: @ByteArrayReader) -> usize {
        let byte_array = *self.data;
        let byte_array_len = byte_array.len();
        byte_array_len - *self.reader_index
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
