use core::byte_array::ByteArrayTrait;
use core::integer::u512;
use core::num::traits::Zero;
use core::ops::{AddAssign, MulAssign};
use super::bit_array::{one_shift_left_bytes_felt252, one_shift_left_bytes_u128};

/// Generic support trait for appending signed and unsigned integers onto byte storage.
/// There are two functions, one for each of big and little endian byte order due to
/// performance considerations. The byte reversal could be used in the naïve case when
/// only one implementation is worthwhile.
pub trait ByteAppenderSupportTrait<T> {
    /// Appends `bytes` data of size `count` ordered in big endian
    /// # Arguments
    /// * `bytes` - big endian ordered bytes to append
    /// * `count` - number of bytes from input to append
    fn append_bytes_be(ref self: T, bytes: felt252, count: usize);
    /// Appends `bytes` data of size `count` ordered in little endian
    /// # Arguments
    /// * `bytes` - little endian ordered bytes to append
    /// * `count` - number of bytes from input to append
    fn append_bytes_le(ref self: T, bytes: felt252, count: usize);
}

impl ByteAppenderSupportArrayU8Impl of ByteAppenderSupportTrait<Array<u8>> {
    fn append_bytes_be(ref self: Array<u8>, bytes: felt252, mut count: usize) {
        assert(count <= 16, 'count too big');
        let u256 { low, high: _high } = bytes.into();
        while (count != 0) {
            let next = (low / one_shift_left_bytes_u128(count - 1)) % 0x100;
            // Unwrap safe by definition of modulus operation 0x100
            self.append(next.try_into().unwrap());
            count -= 1;
        };
    }

    fn append_bytes_le(ref self: Array<u8>, bytes: felt252, count: usize) {
        assert(count <= 16, 'count too big');
        let u256 { mut low, high: _high } = bytes.into();
        let mut index = 0;
        while (index != count) {
            let (remaining_bytes, next) = DivRem::div_rem(low, 0x100_u128.try_into().unwrap());
            low = remaining_bytes;
            // Unwrap safe by definition of remainder from division by 0x100
            self.append(next.try_into().unwrap());
            index += 1;
        };
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
        assert(count <= 16, 'count too big');
        let u256 { low, high: _high } = bytes.into();
        let (reversed, _) = reversing(low, count, 0x100);
        self.append_word(reversed.into(), count);
    }
}

pub trait ByteAppender<T> {
    /// Appends an unsigned 16 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 16 bit unsigned integer typed as u16
    fn append_u16(ref self: T, word: u16);
    /// Appends an unsigned 16 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 16 bit unsigned integer typed as u16
    fn append_u16_le(ref self: T, word: u16);
    /// Appends an unsigned 32 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 32 bit unsigned integer typed as u32
    fn append_u32(ref self: T, word: u32);
    /// Appends an unsigned 32 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 32 bit unsigned integer typed as u32
    fn append_u32_le(ref self: T, word: u32);
    /// Appends an unsigned 64 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 64 bit unsigned integer typed as u64
    fn append_u64(ref self: T, word: u64);
    /// Appends an unsigned 64 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 64 bit unsigned integer typed as u64
    fn append_u64_le(ref self: T, word: u64);
    /// Appends an unsigned 128 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 128 bit unsigned integer typed as u128
    fn append_u128(ref self: T, word: u128);
    /// Appends an unsigned 128 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 128 bit unsigned integer typed as u128
    fn append_u128_le(ref self: T, word: u128);
    /// Appends an unsigned 256 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 256 bit unsigned integer typed as u256
    fn append_u256(ref self: T, word: u256);
    /// Appends an unsigned 256 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 256 bit unsigned integer typed as u256
    fn append_u256_le(ref self: T, word: u256);
    /// Appends an unsigned 512 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 512 bit unsigned integer typed as u32
    fn append_u512(ref self: T, word: u512);
    /// Appends an unsigned 512 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 512 bit unsigned integer typed as u32
    fn append_u512_le(ref self: T, word: u512);
    /// Appends a signed 8 bit integer
    /// # Arguments
    /// * `word` - an 8 bit signed integer typed as i8
    fn append_i8(ref self: T, word: i8);
    /// Appends a signed 16 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 16 bit signed integer typed as i16
    fn append_i16(ref self: T, word: i16);
    /// Appends a signed 16 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 16 bit signed integer typed as i16
    fn append_i16_le(ref self: T, word: i16);
    /// Appends a signed 32 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 32 bit signed integer typed as i32
    fn append_i32(ref self: T, word: i32);
    /// Appends a signed 32 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 32 bit signed integer typed as i32
    fn append_i32_le(ref self: T, word: i32);
    /// Appends a signed 64 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 64 bit signed integer typed as i64
    fn append_i64(ref self: T, word: i64);
    /// Appends a signed 64 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 64 bit signed integer typed as i64
    fn append_i64_le(ref self: T, word: i64);
    /// Appends a signed 128 bit integer encoded in big endian
    /// # Arguments
    /// * `word` - a 128 bit signed integer typed as i128
    fn append_i128(ref self: T, word: i128);
    /// Appends a signed 128 bit integer encoded in little endian
    /// # Arguments
    /// * `word` - a 128 bit signed integer typed as i128
    fn append_i128_le(ref self: T, word: i128);
}

impl ByteAppenderImpl<T, +Drop<T>, +ByteAppenderSupportTrait<T>> of ByteAppender<T> {
    fn append_u16(ref self: T, word: u16) {
        self.append_bytes_be(word.into(), 2);
    }

    fn append_u16_le(ref self: T, word: u16) {
        self.append_bytes_le(word.into(), 2);
    }

    fn append_u32(ref self: T, word: u32) {
        self.append_bytes_be(word.into(), 4);
    }

    fn append_u32_le(ref self: T, word: u32) {
        self.append_bytes_le(word.into(), 4);
    }

    fn append_u64(ref self: T, word: u64) {
        self.append_bytes_be(word.into(), 8);
    }

    fn append_u64_le(ref self: T, word: u64) {
        self.append_bytes_le(word.into(), 8);
    }

    fn append_u128(ref self: T, word: u128) {
        self.append_bytes_be(word.into(), 16);
    }

    fn append_u128_le(ref self: T, word: u128) {
        self.append_bytes_le(word.into(), 16);
    }

    fn append_u256(ref self: T, word: u256) {
        let u256 { low, high } = word;
        self.append_u128(high);
        self.append_u128(low);
    }

    fn append_u256_le(ref self: T, word: u256) {
        let u256 { low, high } = word;
        self.append_u128_le(low);
        self.append_u128_le(high);
    }

    fn append_u512(ref self: T, word: u512) {
        let u512 { limb0, limb1, limb2, limb3 } = word;
        self.append_u128(limb3);
        self.append_u128(limb2);
        self.append_u128(limb1);
        self.append_u128(limb0);
    }

    fn append_u512_le(ref self: T, word: u512) {
        let u512 { limb0, limb1, limb2, limb3 } = word;
        self.append_u128_le(limb0);
        self.append_u128_le(limb1);
        self.append_u128_le(limb2);
        self.append_u128_le(limb3);
    }

    fn append_i8(ref self: T, word: i8) {
        if word >= 0_i8 {
            self.append_bytes_be(word.into(), 1);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(1), 1);
        }
    }

    fn append_i16(ref self: T, word: i16) {
        if word >= 0_i16 {
            self.append_bytes_be(word.into(), 2);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(2), 2);
        }
    }

    fn append_i16_le(ref self: T, word: i16) {
        if word >= 0_i16 {
            self.append_bytes_le(word.into(), 2);
        } else {
            self.append_bytes_le(word.into() + one_shift_left_bytes_felt252(2), 2);
        }
    }

    fn append_i32(ref self: T, word: i32) {
        if word >= 0_i32 {
            self.append_bytes_be(word.into(), 4);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(4), 4);
        }
    }

    fn append_i32_le(ref self: T, word: i32) {
        if word >= 0_i32 {
            self.append_bytes_le(word.into(), 4);
        } else {
            self.append_bytes_le(word.into() + one_shift_left_bytes_felt252(4), 4);
        }
    }

    fn append_i64(ref self: T, word: i64) {
        if word >= 0_i64 {
            self.append_bytes_be(word.into(), 8);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(8), 8);
        }
    }

    fn append_i64_le(ref self: T, word: i64) {
        if word >= 0_i64 {
            self.append_bytes_le(word.into(), 8);
        } else {
            self.append_bytes_le(word.into() + one_shift_left_bytes_felt252(8), 8);
        }
    }

    fn append_i128(ref self: T, word: i128) {
        if word >= 0_i128 {
            self.append_bytes_be(word.into(), 16);
        } else {
            self.append_bytes_be(word.into() + one_shift_left_bytes_felt252(16), 16);
        }
    }

    fn append_i128_le(ref self: T, word: i128) {
        if word >= 0_i128 {
            self.append_bytes_le(word.into(), 16);
        } else {
            self.append_bytes_le(word.into() + one_shift_left_bytes_felt252(16), 16);
        }
    }
}

impl ArrayU8ByteAppenderImpl = ByteAppenderImpl<Array<u8>>;
impl ByteArrayByteAppenderImpl = ByteAppenderImpl<ByteArray>;

// Duplicated functions from encoding. To fix dependency publish problem.

#[inline]
pub fn reversing<
    T,
    +Copy<T>,
    +Zero<T>,
    +TryInto<T, NonZero<T>>,
    +DivRem<T>,
    +Drop<T>,
    +MulAssign<T, T>,
    +Rem<T>,
    +AddAssign<T, T>,
>(
    word: T, size: usize, step: T,
) -> (T, T) {
    let result = Zero::zero();
    reversing_partial_result(word, result, size, step)
}

#[inline]
pub fn reversing_partial_result<
    T,
    +Copy<T>,
    +DivRem<T>,
    +TryInto<T, NonZero<T>>,
    +Drop<T>,
    +MulAssign<T, T>,
    +Rem<T>,
    +AddAssign<T, T>,
>(
    mut word: T, mut onto: T, size: usize, step: T,
) -> (T, T) {
    let mut i: usize = 0;
    while i != size {
        let (new_word, remainder) = DivRem::div_rem(word, step.try_into().unwrap());
        word = new_word;
        onto *= step.into();
        onto += remainder;
        i += 1;
    }
    (onto, word)
}
