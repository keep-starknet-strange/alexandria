use alexandria_data_structures::byte_array_reader::{ByteArrayReader, ByteArrayReaderTrait};
use alexandria_encoding::reversible::ArrayReversibleBytes;
use array::{serialize_array_helper, deserialize_array_helper};
use byte_array::ByteArray;
use bytes_31::{one_shift_left_bytes_felt252, one_shift_left_bytes_u128, BYTES_IN_BYTES31};
use integer::u512;
use traits::DivRem;
use core::serde::into_felt252_based::SerdeImpl;

trait ByteArrayTraitExt {
    /// Appends an unsigned 16 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 16 bit unsigned integer typed as u16
    fn append_u16(ref self: ByteArray, word: u16);
    /// Appends an unsigned 16 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 16 bit unsigned integer typed as u16
    fn append_u16_le(ref self: ByteArray, word: u16);
    /// Appends an unsigned 32 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 32 bit unsigned integer typed as u32
    fn append_u32(ref self: ByteArray, word: u32);
    /// Appends an unsigned 32 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 32 bit unsigned integer typed as u32
    fn append_u32_le(ref self: ByteArray, word: u32);
    /// Appends an unsigned 64 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 64 bit unsigned integer typed as u64
    fn append_u64(ref self: ByteArray, word: u64);
    /// Appends an unsigned 64 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 64 bit unsigned integer typed as u64
    fn append_u64_le(ref self: ByteArray, word: u64);
    /// Appends an unsigned 128 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 128 bit unsigned integer typed as u128
    fn append_u128(ref self: ByteArray, word: u128);
    /// Appends an unsigned 128 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 128 bit unsigned integer typed as u128
    fn append_u128_le(ref self: ByteArray, word: u128);
    /// Appends an unsigned 256 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 256 bit unsigned integer typed as u256
    fn append_u256(ref self: ByteArray, word: u256);
    /// Appends an unsigned 256 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 256 bit unsigned integer typed as u256
    fn append_u256_le(ref self: ByteArray, word: u256);
    /// Appends an unsigned 512 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 512 bit unsigned integer typed as u32
    fn append_u512(ref self: ByteArray, word: u512);
    /// Appends an unsigned 512 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 512 bit unsigned integer typed as u32
    fn append_u512_le(ref self: ByteArray, word: u512);
    /// Appends a signed 8 bit integer
    /// # Arguments
    /// * `word` - an 8 bit signed integer typed as i8
    fn append_i8(ref self: ByteArray, word: i8);
    /// Appends a signed 16 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 16 bit signed integer typed as i16
    fn append_i16(ref self: ByteArray, word: i16);
    /// Appends a signed 16 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 16 bit signed integer typed as i16
    fn append_i16_le(ref self: ByteArray, word: i16);
    /// Appends a signed 32 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 32 bit signed integer typed as i32
    fn append_i32(ref self: ByteArray, word: i32);
    /// Appends a signed 32 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 32 bit signed integer typed as i32
    fn append_i32_le(ref self: ByteArray, word: i32);
    /// Appends a signed 64 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 64 bit signed integer typed as i64
    fn append_i64(ref self: ByteArray, word: i64);
    /// Appends a signed 64 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 64 bit signed integer typed as i64
    fn append_i64_le(ref self: ByteArray, word: i64);
    /// Appends a signed 128 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 128 bit signed integer typed as i128
    fn append_i128(ref self: ByteArray, word: i128);
    /// Appends a signed 128 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 128 bit signed integer typed as i128
    fn append_i128_le(ref self: ByteArray, word: i128);
    /// Reads consecutive bytes from a specified offset as an unsigned integer in big endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u16>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u16(self: @ByteArray, offset: usize) -> Option<u16>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in little endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u16>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u16_le(self: @ByteArray, offset: usize) -> Option<u16>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in big endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u32>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u32(self: @ByteArray, offset: usize) -> Option<u32>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in little endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u32>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u32_le(self: @ByteArray, offset: usize) -> Option<u32>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in big endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u64>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u64(self: @ByteArray, offset: usize) -> Option<u64>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in little endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u64>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u64_le(self: @ByteArray, offset: usize) -> Option<u64>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in big endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u128>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u128(self: @ByteArray, offset: usize) -> Option<u128>;
    /// Reads consecutive bytes from a specified offset as an unsigned integer in little endian
    /// # Arguments
    /// * `offset` - the start location of the consecutive bytes to read
    /// # Returns
    /// * `Option<u128>` - Returns an integer if there are enough consecutive bytes available in the ByteArray
    fn word_u128_le(self: @ByteArray, offset: usize) -> Option<u128>;
    /// Wraps the ByteArray in a ByteArrayReader for sequential consumption of integers and/or bytes
    /// # Returns
    /// * `ByteArrayReader` - The reader struct wrapping a read-only snapshot of this ByteArray
    fn reader(self: @ByteArray) -> ByteArrayReader;
}

impl ByteArrayImpl of ByteArrayTraitExt {
    fn append_u16(ref self: ByteArray, word: u16) {
        self.append_word(word.into(), 2);
    }

    fn append_u16_le(ref self: ByteArray, word: u16) {
        self.append_word(word.reverse_bytes().into(), 2);
    }

    fn append_u32(ref self: ByteArray, word: u32) {
        self.append_word(word.into(), 4);
    }

    fn append_u32_le(ref self: ByteArray, word: u32) {
        self.append_word(word.reverse_bytes().into(), 4);
    }

    fn append_u64(ref self: ByteArray, word: u64) {
        self.append_word(word.into(), 8);
    }

    fn append_u64_le(ref self: ByteArray, word: u64) {
        self.append_word(word.reverse_bytes().into(), 8);
    }

    fn append_u128(ref self: ByteArray, word: u128) {
        self.append_word(word.into(), 16);
    }

    fn append_u128_le(ref self: ByteArray, word: u128) {
        self.append_word(word.reverse_bytes().into(), 16);
    }

    fn append_u256(ref self: ByteArray, word: u256) {
        let u256{low, high } = word;
        self.append_u128(high);
        self.append_u128(low);
    }

    fn append_u256_le(ref self: ByteArray, word: u256) {
        let u256{low, high } = word;
        self.append_u128_le(low);
        self.append_u128_le(high);
    }

    fn append_u512(ref self: ByteArray, word: u512) {
        let u512{limb0, limb1, limb2, limb3 } = word;
        self.append_u128(limb3);
        self.append_u128(limb2);
        self.append_u128(limb1);
        self.append_u128(limb0);
    }

    fn append_u512_le(ref self: ByteArray, word: u512) {
        let u512{limb0, limb1, limb2, limb3 } = word;
        self.append_u128_le(limb0);
        self.append_u128_le(limb1);
        self.append_u128_le(limb2);
        self.append_u128_le(limb3);
    }

    fn append_i8(ref self: ByteArray, word: i8) {
        if word >= 0_i8 {
            self.append_word(word.into(), 1);
        } else {
            self.append_word(word.into() + one_shift_left_bytes_felt252(1), 1);
        }
    }

    fn append_i16(ref self: ByteArray, word: i16) {
        if word >= 0_i16 {
            self.append_word(word.into(), 2);
        } else {
            self.append_word(word.into() + one_shift_left_bytes_felt252(2), 2);
        }
    }

    fn append_i16_le(ref self: ByteArray, word: i16) {
        let felt: felt252 = if word >= 0_i16 {
            word.into()
        } else {
            word.into() + one_shift_left_bytes_felt252(2)
        };
        let unsigned: u16 = felt.try_into().unwrap();
        self.append_word(unsigned.reverse_bytes().into(), 2);
    }

    fn append_i32(ref self: ByteArray, word: i32) {
        if word >= 0_i32 {
            self.append_word(word.into(), 4);
        } else {
            self.append_word(word.into() + one_shift_left_bytes_felt252(4), 4);
        }
    }

    fn append_i32_le(ref self: ByteArray, word: i32) {
        let felt: felt252 = if word >= 0_i32 {
            word.into()
        } else {
            word.into() + one_shift_left_bytes_felt252(4)
        };
        let unsigned: u32 = felt.try_into().unwrap();
        self.append_word(unsigned.reverse_bytes().into(), 4);
    }

    fn append_i64(ref self: ByteArray, word: i64) {
        if word >= 0_i64 {
            self.append_word(word.into(), 8);
        } else {
            self.append_word(word.into() + one_shift_left_bytes_felt252(8), 8);
        }
    }

    fn append_i64_le(ref self: ByteArray, word: i64) {
        let felt: felt252 = if word >= 0_i64 {
            word.into()
        } else {
            word.into() + one_shift_left_bytes_felt252(8)
        };
        let unsigned: u64 = felt.try_into().unwrap();
        self.append_word(unsigned.reverse_bytes().into(), 8);
    }

    fn append_i128(ref self: ByteArray, word: i128) {
        if word >= 0_i128 {
            self.append_word(word.into(), 16);
        } else {
            self.append_word(word.into() + one_shift_left_bytes_felt252(16), 16);
        }
    }

    fn append_i128_le(ref self: ByteArray, word: i128) {
        let felt: felt252 = if word >= 0_i128 {
            word.into()
        } else {
            word.into() + one_shift_left_bytes_felt252(16)
        };
        let unsigned: u128 = felt.try_into().unwrap();
        self.append_word(unsigned.reverse_bytes().into(), 16);
    }

    fn word_u16(self: @ByteArray, offset: usize) -> Option<u16> {
        let b1 = self.at(offset)?;
        let b2 = self.at(offset + 1)?;
        Option::Some(b1.into() * one_shift_left_bytes_u128(1).try_into().unwrap() + b2.into())
    }

    fn word_u16_le(self: @ByteArray, offset: usize) -> Option<u16> {
        let b1 = self.at(offset)?;
        let b2 = self.at(offset + 1)?;
        Option::Some(b1.into() + b2.into() * one_shift_left_bytes_u128(1).try_into().unwrap())
    }

    fn word_u32(self: @ByteArray, offset: usize) -> Option<u32> {
        let b1 = self.at(offset)?;
        let b2 = self.at(offset + 1)?;
        let b3 = self.at(offset + 2)?;
        let b4 = self.at(offset + 3)?;
        Option::Some(
            b1.into() * one_shift_left_bytes_u128(3).try_into().unwrap()
                + b2.into() * one_shift_left_bytes_u128(2).try_into().unwrap()
                + b3.into() * one_shift_left_bytes_u128(1).try_into().unwrap()
                + b4.into()
        )
    }

    fn word_u32_le(self: @ByteArray, offset: usize) -> Option<u32> {
        let b1 = self.at(offset)?;
        let b2 = self.at(offset + 1)?;
        let b3 = self.at(offset + 2)?;
        let b4 = self.at(offset + 3)?;
        Option::Some(
            b1.into()
                + b2.into() * one_shift_left_bytes_u128(1).try_into().unwrap()
                + b3.into() * one_shift_left_bytes_u128(2).try_into().unwrap()
                + b4.into() * one_shift_left_bytes_u128(3).try_into().unwrap()
        )
    }

    fn word_u64(self: @ByteArray, offset: usize) -> Option<u64> {
        let b1 = self.at(offset)?;
        let b2 = self.at(offset + 1)?;
        let b3 = self.at(offset + 2)?;
        let b4 = self.at(offset + 3)?;
        let b5 = self.at(offset + 4)?;
        let b6 = self.at(offset + 5)?;
        let b7 = self.at(offset + 6)?;
        let b8 = self.at(offset + 7)?;
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
    }

    fn word_u64_le(self: @ByteArray, offset: usize) -> Option<u64> {
        let b1 = self.at(offset)?;
        let b2 = self.at(offset + 1)?;
        let b3 = self.at(offset + 2)?;
        let b4 = self.at(offset + 3)?;
        let b5 = self.at(offset + 4)?;
        let b6 = self.at(offset + 5)?;
        let b7 = self.at(offset + 6)?;
        let b8 = self.at(offset + 7)?;
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
    }

    fn word_u128(self: @ByteArray, offset: usize) -> Option<u128> {
        let b01 = self.at(offset)?;
        let b02 = self.at(offset + 1)?;
        let b03 = self.at(offset + 2)?;
        let b04 = self.at(offset + 3)?;
        let b05 = self.at(offset + 4)?;
        let b06 = self.at(offset + 5)?;
        let b07 = self.at(offset + 6)?;
        let b08 = self.at(offset + 7)?;
        let b09 = self.at(offset + 8)?;
        let b10 = self.at(offset + 9)?;
        let b11 = self.at(offset + 10)?;
        let b12 = self.at(offset + 11)?;
        let b13 = self.at(offset + 12)?;
        let b14 = self.at(offset + 13)?;
        let b15 = self.at(offset + 14)?;
        let b16 = self.at(offset + 15)?;
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
    }

    fn word_u128_le(self: @ByteArray, offset: usize) -> Option<u128> {
        let b01 = self.at(offset)?;
        let b02 = self.at(offset + 1)?;
        let b03 = self.at(offset + 2)?;
        let b04 = self.at(offset + 3)?;
        let b05 = self.at(offset + 4)?;
        let b06 = self.at(offset + 5)?;
        let b07 = self.at(offset + 6)?;
        let b08 = self.at(offset + 7)?;
        let b09 = self.at(offset + 8)?;
        let b10 = self.at(offset + 9)?;
        let b11 = self.at(offset + 10)?;
        let b12 = self.at(offset + 11)?;
        let b13 = self.at(offset + 12)?;
        let b14 = self.at(offset + 13)?;
        let b15 = self.at(offset + 14)?;
        let b16 = self.at(offset + 15)?;
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
    }

    fn reader(self: @ByteArray) -> ByteArrayReader {
        ByteArrayReaderTrait::new(self)
    }
}

impl ByteArraySerde of Serde<ByteArray> {
    fn serialize(self: @ByteArray, ref output: Array<felt252>) {
        let len = self.len();
        len.serialize(ref output);
        let bytes31_arr = self.data.span();
        serialize_array_helper(bytes31_arr, ref output);

        if (*self.pending_word_len > 0) {
            output.append(*self.pending_word);
        }
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<ByteArray> {
        let length = *serialized.pop_front()?;
        let length: usize = length.try_into().unwrap();
        let denominator: NonZero<usize> = BYTES_IN_BYTES31.try_into().unwrap();
        let (felt_length, pending_word_len) = DivRem::div_rem(length, denominator);
        let mut arr: Array<bytes31> = array![];
        let bytes31_arr = deserialize_array_helper(ref serialized, arr, felt_length.into())?;

        let pending_word = if pending_word_len > 0 {
            *serialized.pop_front()?
        } else {
            0
        };

        Option::Some(
            ByteArray {
                data: bytes31_arr,
                pending_word: pending_word,
                pending_word_len: pending_word_len.try_into().unwrap()
            }
        )
    }
}
