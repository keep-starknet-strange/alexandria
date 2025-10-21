use core::bytes_31::bytes31;
use core::integer::u512;
use core::ops::index::IndexView;
use core::serde::Serde;
use core::serde::into_felt252_based::SerdeImpl;

const SELECT_BIT: u128 = 0b10;
const POW_2_128: felt252 = 0x100000000000000000000000000000000;
const BYTES_IN_U128: usize = 16;
const BYTES_IN_BYTES31: usize = 31;
const BYTES_IN_BYTES31_MINUS_ONE: usize = BYTES_IN_BYTES31 - 1;

#[derive(Clone, Drop)]
pub struct BitArray {
    data: Array<bytes31>,
    current: felt252,
    read_pos: usize,
    write_pos: usize,
}

impl BitArrayDefaultImpl of Default<BitArray> {
    fn default() -> BitArray {
        BitArray { data: array![], current: 0, read_pos: 0, write_pos: 0 }
    }
}

pub trait BitArrayTrait {
    /// Creates a new BitArray instance.
    /// #### Arguments
    /// * `data` - Array of bytes31 data
    /// * `current` - Current working felt252 value
    /// * `read_pos` - Current read position
    /// * `write_pos` - Current write position
    fn new(data: Array<bytes31>, current: felt252, read_pos: usize, write_pos: usize) -> BitArray;
    /// Gets the current working felt252 value.
    /// #### Arguments
    /// * `self` - The BitArray to get the current value from
    fn current(self: @BitArray) -> felt252;
    /// Gets the underlying data array.
    /// #### Arguments
    /// * `self` - The BitArray to get the data from
    fn data(self: BitArray) -> Array<bytes31>;
    /// Appends a single bit to the BitArray
    /// #### Arguments
    /// * `self` - The BitArray to append to
    /// * `bit` - either true or false, representing a single bit to be appended
    fn append_bit(ref self: BitArray, bit: bool);
    /// Reads a single bit from the array
    /// #### Arguments
    /// * `self` - The BitArray to read from
    /// * `index` - the index into the array to read
    /// #### Returns
    /// `Option<bool>` - if the index is found, the stored bool is returned
    fn at(self: @BitArray, index: usize) -> Option<bool>;
    /// The current length of the BitArray
    /// #### Arguments
    /// * `self` - The BitArray to get the length of
    /// #### Returns
    /// `usize` - length in bits of the BitArray
    fn len(self: @BitArray) -> usize;
    /// Returns and removes the first element of the BitArray
    /// #### Arguments
    /// * `self` - The BitArray to pop from
    /// #### Returns
    /// `Option<bool>` - If the array is non-empty, a `bool` is removed from the front and returned
    fn pop_front(ref self: BitArray) -> Option<bool>;
    /// Reads a single word of the specified length up to 248 bits in big endian bit representation
    /// #### Arguments
    /// * `self` - The BitArray to read from
    /// * `length` - The bit length of the word to read, max 248
    /// #### Returns
    /// `Option<felt252>` - If there are `length` bits remaining, the word is returned as felt252
    fn read_word_be(ref self: BitArray, length: usize) -> Option<felt252>;
    /// Reads a single word of the specified length up to 256 bits in big endian representation.
    /// For words shorter than (or equal to) 248 bits use `read_word_be(...)` instead.
    /// #### Arguments
    /// * `self` - The BitArray to read from
    /// * `length` - The bit length of the word to read, max 256
    /// #### Returns
    /// `Option<u256>` - If there are `length` bits remaining, the word is returned as u256
    fn read_word_be_u256(ref self: BitArray, length: usize) -> Option<u256>;
    /// Reads a single word of the specified length up to 512 bits in big endian representation.
    /// For words shorter than (or equal to) 256 bits consider the other read calls instead.
    /// #### Arguments
    /// * `self` - The BitArray to read from
    /// * `length` - The bit length of the word to read, max 512
    /// #### Returns
    /// `Option<u512>` - If there are `length` bits remaining, the word is returned as u512
    fn read_word_be_u512(ref self: BitArray, length: usize) -> Option<u512>;
    /// Writes the bits of the specified length from `word` onto the BitArray
    /// in big endian representation
    /// #### Arguments
    /// * `self` - The BitArray to write to
    /// * `word` - The value to store onto the bit array of type `felt252`
    /// * `length` - The length of the word in bits, maximum 248
    fn write_word_be(ref self: BitArray, word: felt252, length: usize);
    /// Writes the bits of the specified length from `word` onto the BitArray
    /// in big endian representation
    /// #### Arguments
    /// * `self` - The BitArray to write to
    /// * `word` - The value to store onto the bit array of type `u256`
    /// * `length` - The length of the word in bits, maximum 256
    fn write_word_be_u256(ref self: BitArray, word: u256, length: usize);
    /// Writes the bits of the specified length from `word` onto the BitArray
    /// in big endian representation
    /// #### Arguments
    /// * `self` - The BitArray to write to
    /// * `word` - The value to store onto the bit array of type `u512`
    /// * `length` - The length of the word in bits, maximum 512
    fn write_word_be_u512(ref self: BitArray, word: u512, length: usize);
    /// Reads a single word of the specified length up to 248 bits in little endian bit
    /// representation
    /// #### Arguments
    /// * `self` - The BitArray to read from
    /// * `length` - The bit length of the word to read, max 248
    /// #### Returns
    /// `Option<felt252>` - If there are `length` bits remaining, the word is returned as felt252
    fn read_word_le(ref self: BitArray, length: usize) -> Option<felt252>;
    /// Reads a single word of the specified length up to 256 bits in little endian representation.
    /// For words shorter than (or equal to) 248 bits use `read_word_be(...)` instead.
    /// #### Arguments
    /// * `self` - The BitArray to read from
    /// * `length` - The bit length of the word to read, max 256
    /// #### Returns
    /// `Option<u256>` - If there are `length` bits remaining, the word is returned as u256
    fn read_word_le_u256(ref self: BitArray, length: usize) -> Option<u256>;
    /// Reads a single word of the specified length up to 512 bits in little endian representation.
    /// For words shorter than (or equal to) 256 bits consider the other read calls instead.
    /// #### Arguments
    /// * `self` - The BitArray to read from
    /// * `length` - The bit length of the word to read, max 512
    /// #### Returns
    /// `Option<u512>` - If there are `length` bits remaining, the word is returned as u512
    fn read_word_le_u512(ref self: BitArray, length: usize) -> Option<u512>;
    /// Writes the bits of the specified length from `word` onto the BitArray
    /// in little endian representation
    /// #### Arguments
    /// * `self` - The BitArray to write to
    /// * `word` - The value to store onto the bit array of type `felt252`
    /// * `length` - The length of the word in bits, maximum 248
    fn write_word_le(ref self: BitArray, word: felt252, length: usize);
    /// Writes the bits of the specified length from `word` onto the BitArray
    /// in little endian representation
    /// #### Arguments
    /// * `self` - The BitArray to write to
    /// * `word` - The value to store onto the bit array of type `u256`
    /// * `length` - The length of the word in bits, maximum 256
    fn write_word_le_u256(ref self: BitArray, word: u256, length: usize);
    /// Writes the bits of the specified length from `word` onto the BitArray
    /// in little endian representation
    /// #### Arguments
    /// * `self` - The BitArray to write to
    /// * `word` - The value to store onto the bit array of type `u512`
    /// * `length` - The length of the word in bits, maximum 512
    fn write_word_le_u512(ref self: BitArray, word: u512, length: usize);
}

impl BitArrayImpl of BitArrayTrait {
    fn new(data: Array<bytes31>, current: felt252, read_pos: usize, write_pos: usize) -> BitArray {
        BitArray { data, current, read_pos, write_pos }
    }

    fn current(self: @BitArray) -> felt252 {
        *self.current
    }

    fn data(self: BitArray) -> Array<bytes31> {
        self.data
    }

    fn append_bit(ref self: BitArray, bit: bool) {
        let (byte_number, bit_offset) = DivRem::div_rem(
            self.write_pos, 8_usize.try_into().unwrap(),
        );
        let byte_offset = BYTES_IN_BYTES31_MINUS_ONE - (byte_number % BYTES_IN_BYTES31);
        let bit_offset = 7 - bit_offset;
        self.write_pos += 1;
        if bit {
            self.current += one_shift_left_bytes_felt252(byte_offset).into()
                * shift_bit(bit_offset).into();
        }
        if byte_offset + bit_offset == 0 {
            self.data.append(self.current.try_into().unwrap());
            self.current = 0;
        }
    }

    fn at(self: @BitArray, index: usize) -> Option<bool> {
        if index >= self.len() {
            Option::None
        } else {
            let (word, byte_offset, bit_offset) = self.word_and_offset(index + *self.read_pos);
            Option::Some(select(word, byte_offset, bit_offset))
        }
    }

    #[inline]
    fn len(self: @BitArray) -> usize {
        *self.write_pos - *self.read_pos
    }

    fn pop_front(ref self: BitArray) -> Option<bool> {
        let result = self.at(0)?;
        self.read_pos += 1;
        Option::Some(result)
    }

    fn read_word_be(ref self: BitArray, length: usize) -> Option<felt252> {
        assert(length <= 248, 'illegal length');
        self._read_word_be_recursive(0, length)
    }

    fn read_word_be_u256(ref self: BitArray, length: usize) -> Option<u256> {
        assert(length <= 256, 'illegal length');
        Option::Some(
            if length > 128 {
                let high = self._read_word_be_recursive(0, length - 128)?.try_into().unwrap();
                let low = self._read_word_be_recursive(0, 128)?.try_into().unwrap();
                u256 { low, high }
            } else {
                let high = 0;
                let low = self._read_word_be_recursive(0, length)?.try_into().unwrap();
                u256 { low, high }
            },
        )
    }

    fn read_word_be_u512(ref self: BitArray, length: usize) -> Option<u512> {
        assert(length <= 512, 'illegal length');
        Option::Some(
            if length > 384 {
                let limb3 = self._read_word_be_recursive(0, length - 384)?.try_into().unwrap();
                let limb2 = self._read_word_be_recursive(0, 128)?.try_into().unwrap();
                let limb1 = self._read_word_be_recursive(0, 128)?.try_into().unwrap();
                let limb0 = self._read_word_be_recursive(0, 128)?.try_into().unwrap();
                u512 { limb0, limb1, limb2, limb3 }
            } else if length > 256 {
                let limb3 = 0;
                let limb2 = self._read_word_be_recursive(0, length - 256)?.try_into().unwrap();
                let limb1 = self._read_word_be_recursive(0, 128)?.try_into().unwrap();
                let limb0 = self._read_word_be_recursive(0, 128)?.try_into().unwrap();
                u512 { limb0, limb1, limb2, limb3 }
            } else if length > 128 {
                let limb3 = 0;
                let limb2 = 0;
                let limb1 = self._read_word_be_recursive(0, length - 256)?.try_into().unwrap();
                let limb0 = self._read_word_be_recursive(0, 128)?.try_into().unwrap();
                u512 { limb0, limb1, limb2, limb3 }
            } else {
                let limb3 = 0;
                let limb2 = 0;
                let limb1 = 0;
                let limb0 = self._read_word_be_recursive(0, length)?.try_into().unwrap();
                u512 { limb0, limb1, limb2, limb3 }
            },
        )
    }

    fn write_word_be(ref self: BitArray, word: felt252, length: usize) {
        assert(length <= 248, 'illegal length');
        if length == 0 {
            return;
        }
        let (mut byte_offset, mut bit_offset) = DivRem::div_rem(
            length - 1, 8_usize.try_into().unwrap(),
        );
        loop {
            self.append_bit(select(word, byte_offset, bit_offset));
            if bit_offset == 0 {
                if byte_offset == 0 {
                    break;
                } else {
                    bit_offset = 8;
                    byte_offset -= 1;
                }
            }
            bit_offset -= 1;
        };
    }

    fn write_word_be_u256(ref self: BitArray, word: u256, length: usize) {
        assert(length <= 256, 'illegal length');
        let u256 { low, high } = word;
        if length > 128 {
            self.write_word_be(high.into(), length - 128);
            self.write_word_be(low.into(), 128);
        } else {
            self.write_word_be(low.into(), length);
        }
    }

    fn write_word_be_u512(ref self: BitArray, word: u512, length: usize) {
        assert(length <= 512, 'illegal length');
        let u512 { limb0, limb1, limb2, limb3 } = word;

        if length > 384 {
            self.write_word_be(limb3.into(), length - 384);
            self.write_word_be(limb2.into(), 128);
            self.write_word_be(limb1.into(), 128);
            self.write_word_be(limb0.into(), 128);
        } else if length > 256 {
            self.write_word_be(limb2.into(), length - 256);
            self.write_word_be(limb1.into(), 128);
            self.write_word_be(limb0.into(), 128);
        } else if length > 128 {
            self.write_word_be(limb1.into(), length - 128);
            self.write_word_be(limb0.into(), 128);
        } else {
            self.write_word_be(limb0.into(), length);
        }
    }

    fn read_word_le(ref self: BitArray, length: usize) -> Option<felt252> {
        assert(length <= 248, 'illegal length');
        if length == 0 {
            return Option::None;
        }
        // For byte-order LE: read bytes from LSB to MSB
        // Within each byte, bits are read from MSB to LSB (same as BE)
        let (num_bytes, remainder_bits) = DivRem::div_rem(length, 8_usize.try_into().unwrap());
        let total_bytes = if remainder_bits > 0 {
            num_bytes + 1
        } else {
            num_bytes
        };

        let mut result: felt252 = 0;
        let mut byte_offset: usize = 0;

        loop {
            if byte_offset >= total_bytes {
                break;
            }

            // Calculate bits in this byte
            let bits_in_byte = if byte_offset == total_bytes - 1 && remainder_bits > 0 {
                remainder_bits
            } else {
                8
            };

            // Read bits from MSB to LSB within this byte
            let mut byte_value: felt252 = 0;
            let mut bit_idx = bits_in_byte;
            loop {
                if bit_idx == 0 {
                    break;
                }
                bit_idx -= 1;

                match self.pop_front() {
                    Option::Some(bit) => { if bit {
                        byte_value += shift_bit(bit_idx).into();
                    } },
                    Option::None => { return Option::None; },
                }
            }

            // Place this byte at its correct position (LE: byte 0 at lowest position)
            result += byte_value * one_shift_left_bytes_felt252(byte_offset);
            byte_offset += 1;
        }

        Option::Some(result)
    }

    fn read_word_le_u256(ref self: BitArray, length: usize) -> Option<u256> {
        assert(length <= 256, 'illegal length');
        Option::Some(
            if length > 128 {
                let low = self.read_word_le(128)?.try_into().unwrap();
                let high = self.read_word_le(length - 128)?.try_into().unwrap();
                u256 { low, high }
            } else {
                let low = self.read_word_le(length)?.try_into().unwrap();
                let high = 0;
                u256 { low, high }
            },
        )
    }

    fn read_word_le_u512(ref self: BitArray, length: usize) -> Option<u512> {
        assert(length <= 512, 'illegal length');
        Option::Some(
            if length > 384 {
                let limb0 = self.read_word_le(128)?;
                let limb1 = self.read_word_le(128)?;
                let limb2 = self.read_word_le(128)?;
                let limb3 = self.read_word_le(length - 384)?;
                u512 {
                    limb0: limb0.try_into().unwrap(),
                    limb1: limb1.try_into().unwrap(),
                    limb2: limb2.try_into().unwrap(),
                    limb3: limb3.try_into().unwrap(),
                }
            } else if length > 256 {
                let limb0 = self.read_word_le(128)?;
                let limb1 = self.read_word_le(128)?;
                let limb2 = self.read_word_le(length - 256)?;
                let limb3 = 0;
                u512 {
                    limb0: limb0.try_into().unwrap(),
                    limb1: limb1.try_into().unwrap(),
                    limb2: limb2.try_into().unwrap(),
                    limb3,
                }
            } else if length > 128 {
                let limb0 = self.read_word_le(128)?;
                let limb1 = self.read_word_le(length - 128)?;
                let limb2 = 0;
                let limb3 = 0;
                u512 {
                    limb0: limb0.try_into().unwrap(),
                    limb1: limb1.try_into().unwrap(),
                    limb2,
                    limb3,
                }
            } else {
                let limb0 = self.read_word_le(length)?;
                let limb1 = 0;
                let limb2 = 0;
                let limb3 = 0;
                u512 { limb0: limb0.try_into().unwrap(), limb1, limb2, limb3 }
            },
        )
    }

    fn write_word_le(ref self: BitArray, word: felt252, length: usize) {
        assert(length <= 248, 'illegal length');
        if length == 0 {
            return;
        }
        // For little-endian, write bytes from LSB (byte 0) to MSB
        // Within each byte, write bits from MSB to LSB (same as BE)
        let (num_bytes, remainder_bits) = DivRem::div_rem(length, 8_usize.try_into().unwrap());
        let total_bytes = if remainder_bits > 0 {
            num_bytes + 1
        } else {
            num_bytes
        };

        let mut byte_offset: usize = 0;
        loop {
            if byte_offset >= total_bytes {
                break;
            }

            // Calculate bits in this byte
            let bits_in_byte = if byte_offset == total_bytes - 1 && remainder_bits > 0 {
                remainder_bits
            } else {
                8
            };

            // Write bits from MSB to LSB within this byte
            let mut bit_offset = bits_in_byte;
            loop {
                if bit_offset == 0 {
                    break;
                }
                bit_offset -= 1;
                self.append_bit(select(word, byte_offset, bit_offset));
            }

            byte_offset += 1;
        };
    }

    fn write_word_le_u256(ref self: BitArray, word: u256, length: usize) {
        assert(length <= 256, 'illegal length');
        let u256 { low, high } = word;
        // For LE, write low bytes first, then high bytes
        if length > 128 {
            self.write_word_le(low.into(), 128);
            self.write_word_le(high.into(), length - 128);
        } else {
            self.write_word_le(low.into(), length);
        }
    }

    fn write_word_le_u512(ref self: BitArray, word: u512, length: usize) {
        assert(length <= 512, 'illegal length');
        let u512 { limb0, limb1, limb2, limb3 } = word;
        if length > 384 {
            self.write_word_le(limb0.into(), 128);
            self.write_word_le(limb1.into(), 128);
            self.write_word_le(limb2.into(), 128);
            self.write_word_le(limb3.into(), length - 384);
        } else if length > 256 {
            self.write_word_le(limb0.into(), 128);
            self.write_word_le(limb1.into(), 128);
            self.write_word_le(limb2.into(), length - 256);
        } else if length > 128 {
            self.write_word_le(limb0.into(), 128);
            self.write_word_le(limb1.into(), length - 128);
        } else {
            self.write_word_le(limb0.into(), length);
        }
    }
}

#[generate_trait]
impl BitArrayInternalImpl of BitArrayInternalTrait {
    #[inline]
    fn word_and_offset(self: @BitArray, index: usize) -> (felt252, usize, usize) {
        let (byte_number, bit_offset) = DivRem::div_rem(index, 8_usize.try_into().unwrap());
        let (word_index, byte_offset) = DivRem::div_rem(
            byte_number, BYTES_IN_BYTES31.try_into().unwrap(),
        );
        let bit_offset = 7_usize - bit_offset;
        let byte_offset = BYTES_IN_BYTES31_MINUS_ONE - byte_offset;
        let word = if word_index == self.data.len() {
            *self.current
        } else {
            let w = *self.data.at(word_index);
            w.into()
        };
        (word, byte_offset, bit_offset)
    }

    fn _write_word_le_recursive(ref self: BitArray, word: u128, length: usize) {
        assert(length <= 128, 'illegal length');
        if length == 0 {
            return;
        }
        let bit = word % SELECT_BIT;
        self.append_bit(bit == 1);
        self._write_word_le_recursive(word / SELECT_BIT, length - 1);
    }

    fn _read_word_be_recursive(
        ref self: BitArray, current: felt252, length: usize,
    ) -> Option<felt252> {
        if length == 0 {
            return Option::Some(current);
        }

        let bit = self.pop_front()?;
        let next = if bit {
            1
        } else {
            0
        };
        self._read_word_be_recursive(current * 2 + next, length - 1)
    }
}

impl BitArrayIndexView of IndexView<BitArray, usize> {
    type Target = bool;
    fn index(self: @BitArray, index: usize) -> bool {
        self.at(index).expect('Index out of bounds')
    }
}

impl BitArraySerde of Serde<BitArray> {
    fn serialize(self: @BitArray, ref output: Array<felt252>) {
        self.len().serialize(ref output);
        self.data.serialize(ref output);
        output.append(*self.current);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<BitArray> {
        let write_pos = Serde::<u32>::deserialize(ref serialized)?;
        let bytes31_arr = Serde::<Array<bytes31>>::deserialize(ref serialized)?;
        let current = *serialized.pop_front()?;
        Option::Some(BitArray { data: bytes31_arr, current, read_pos: 0, write_pos })
    }
}

/// Computes 2^number for bit positions 0-7 within a byte
///
/// This helper function returns the value of 2 raised to the given power,
/// specifically designed for bit manipulation within a single byte (0-7 bit positions).
/// It provides fast lookup for common bit shift operations.
///
/// #### Arguments
/// * `number` - The bit position (0-7) to compute 2^number for
///
/// #### Returns
/// * `u8` - The value 2^number as a u8, panics if number > 7
#[inline(always)]
pub fn shift_bit(number: usize) -> u8 {
    if number == 0 {
        1_u8
    } else if number == 1 {
        0b10_u8
    } else if number == 2 {
        0b100_u8
    } else if number == 3 {
        0b1000_u8
    } else if number == 4 {
        0b10000_u8
    } else if number == 5 {
        0b100000_u8
    } else if number == 6 {
        0b1000000_u8
    } else if number == 7 {
        0b10000000_u8
    } else {
        panic!("invalid shift")
    }
}

#[inline(always)]
fn select(word: felt252, byte_index: usize, bit_index: usize) -> bool {
    let u256 { low, high } = word.into();
    let shifted_bytes = if byte_index >= BYTES_IN_U128 {
        high / one_shift_left_bytes_u128(byte_index - BYTES_IN_U128)
    } else {
        low / one_shift_left_bytes_u128(byte_index)
    };
    (shifted_bytes / shift_bit(bit_index).into()) % SELECT_BIT == 1
}

/// Computes 256^n_bytes for felt252 byte shifting operations
///
/// This function calculates the value needed to shift bytes within a felt252 value.
/// Since felt252 can hold up to 31 bytes, this function handles the full range
/// by splitting calculations between the low and high 128-bit parts when necessary.
///
/// #### Arguments
/// * `n_bytes` - The number of byte positions to shift (0-30)
///
/// #### Returns
/// * `felt252` - The value 256^n_bytes for byte shifting operations
pub fn one_shift_left_bytes_felt252(n_bytes: usize) -> felt252 {
    if n_bytes < BYTES_IN_U128 {
        one_shift_left_bytes_u128(n_bytes).into()
    } else {
        one_shift_left_bytes_u128(n_bytes - BYTES_IN_U128).into() * POW_2_128
    }
}

/// Computes 256^n_bytes for u128 byte shifting operations
///
/// This function provides a lookup table for powers of 256 up to 256^15,
/// which covers the full range of byte positions within a u128 value.
/// Each position represents shifting by one byte (8 bits) to the left.
///
/// #### Arguments
/// * `n_bytes` - The number of byte positions to shift (0-15)
///
/// #### Returns
/// * `u128` - The value 256^n_bytes, panics if n_bytes > 15
pub fn one_shift_left_bytes_u128(n_bytes: usize) -> u128 {
    match n_bytes {
        0 => 0x1,
        1 => 0x100,
        2 => 0x10000,
        3 => 0x1000000,
        4 => 0x100000000,
        5 => 0x10000000000,
        6 => 0x1000000000000,
        7 => 0x100000000000000,
        8 => 0x10000000000000000,
        9 => 0x1000000000000000000,
        10 => 0x100000000000000000000,
        11 => 0x10000000000000000000000,
        12 => 0x1000000000000000000000000,
        13 => 0x100000000000000000000000000,
        14 => 0x10000000000000000000000000000,
        15 => 0x1000000000000000000000000000000,
        _ => core::panic_with_felt252(
            'n_bytes too big',
        ) // For some reason we can't use panic!("") macro here... (running out of gas)
    }
}
