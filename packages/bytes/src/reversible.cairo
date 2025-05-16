use core::integer::u512;
use core::num::traits::Zero;
use core::ops::{AddAssign, MulAssign};

const SELECT_BYTE: u16 = 0x100;
const SELECT_BIT: u8 = 0b10;

/// Implies that there is an underlying byte order for type T that can be reversed
pub trait ReversibleBytes<T> {
    /// Reverses the byte order or endianness of `self`.
    /// For example, the word `0x1122_u16` is reversed into `0x2211_u16`.
    /// # Returns
    /// `T` - returns the byte reversal of `self` into the same type T
    fn reverse_bytes(self: @T) -> T;
}

/// Implies that there is an underlying bit order for type T that can be reversed
pub trait ReversibleBits<T> {
    /// Reverses the underlying ordering of the bit representation of `self`.
    /// For example, the word `0b10111010_u8` is reversed into `0b01011101`.
    /// # Returns
    /// `T` - the bit-representation of `self` reversed into the same type T
    fn reverse_bits(self: @T) -> T;
}

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

impl U8Reversible of ReversibleBytes<u8> {
    fn reverse_bytes(self: @u8) -> u8 {
        *self
    }
}

impl U8ReversibleBits of ReversibleBits<u8> {
    fn reverse_bits(self: @u8) -> u8 {
        let (result, _) = reversing(word: *self, size: 8, step: SELECT_BIT);
        result
    }
}

impl U16Reversible of ReversibleBytes<u16> {
    fn reverse_bytes(self: @u16) -> u16 {
        let (result, _) = reversing(word: *self, size: 2, step: SELECT_BYTE);
        result
    }
}

impl U16ReversibleBits of ReversibleBits<u16> {
    fn reverse_bits(self: @u16) -> u16 {
        let (result, _) = reversing(word: *self, size: 16, step: SELECT_BIT.into());
        result
    }
}

impl U32Reversible of ReversibleBytes<u32> {
    fn reverse_bytes(self: @u32) -> u32 {
        let (result, _) = reversing(word: *self, size: 4, step: SELECT_BYTE.into());
        result
    }
}

impl U32ReversibleBits of ReversibleBits<u32> {
    fn reverse_bits(self: @u32) -> u32 {
        let (result, _) = reversing(word: *self, size: 32, step: SELECT_BIT.into());
        result
    }
}

impl U64Reversible of ReversibleBytes<u64> {
    fn reverse_bytes(self: @u64) -> u64 {
        let (result, _) = reversing(word: *self, size: 8, step: SELECT_BYTE.into());
        result
    }
}

impl U64ReversibleBits of ReversibleBits<u64> {
    fn reverse_bits(self: @u64) -> u64 {
        let (result, _) = reversing(word: *self, size: 64, step: SELECT_BIT.into());
        result
    }
}

impl U128Reversible of ReversibleBytes<u128> {
    fn reverse_bytes(self: @u128) -> u128 {
        let (result, _) = reversing(word: *self, size: 16, step: SELECT_BYTE.into());
        result
    }
}

impl U128ReversibleBits of ReversibleBits<u128> {
    fn reverse_bits(self: @u128) -> u128 {
        let (result, _) = reversing(word: *self, size: 128, step: SELECT_BIT.into());
        result
    }
}

impl U256Reversible of ReversibleBytes<u256> {
    fn reverse_bytes(self: @u256) -> u256 {
        let u256 { low, high } = *self;
        let (low_reversed, _) = reversing(word: low, size: 16, step: SELECT_BYTE.into());
        let (high_reversed, _) = reversing(word: high, size: 16, step: SELECT_BYTE.into());
        u256 { low: high_reversed, high: low_reversed }
    }
}

impl U256ReversibleBits of ReversibleBits<u256> {
    fn reverse_bits(self: @u256) -> u256 {
        let u256 { low, high } = *self;
        let (low_reversed, _) = reversing(word: low, size: 128, step: SELECT_BIT.into());
        let (high_reversed, _) = reversing(word: high, size: 128, step: SELECT_BIT.into());
        u256 { low: high_reversed, high: low_reversed }
    }
}

impl U512Reversible of ReversibleBytes<u512> {
    fn reverse_bytes(self: @u512) -> u512 {
        let u512 { limb0, limb1, limb2, limb3 } = *self;
        let (limb0_reversed, _) = reversing(word: limb0, size: 16, step: SELECT_BYTE.into());
        let (limb1_reversed, _) = reversing(word: limb1, size: 16, step: SELECT_BYTE.into());
        let (limb2_reversed, _) = reversing(word: limb2, size: 16, step: SELECT_BYTE.into());
        let (limb3_reversed, _) = reversing(word: limb3, size: 16, step: SELECT_BYTE.into());
        u512 {
            limb0: limb3_reversed,
            limb1: limb2_reversed,
            limb2: limb1_reversed,
            limb3: limb0_reversed,
        }
    }
}

impl U512ReversibleBits of ReversibleBits<u512> {
    fn reverse_bits(self: @u512) -> u512 {
        let u512 { limb0, limb1, limb2, limb3 } = *self;
        let (limb0_reversed, _) = reversing(word: limb0, size: 128, step: SELECT_BIT.into());
        let (limb1_reversed, _) = reversing(word: limb1, size: 128, step: SELECT_BIT.into());
        let (limb2_reversed, _) = reversing(word: limb2, size: 128, step: SELECT_BIT.into());
        let (limb3_reversed, _) = reversing(word: limb3, size: 128, step: SELECT_BIT.into());
        u512 {
            limb0: limb3_reversed,
            limb1: limb2_reversed,
            limb2: limb1_reversed,
            limb3: limb0_reversed,
        }
    }
}

impl Bytes31Reversible of ReversibleBytes<bytes31> {
    // Consider A and C consisting of 15 bytes each. B carries a single byte of data.
    // Z is the zero padded remainder, then the following transformation is required:
    // low:  A B -> low_rev:  C_rev B_rev
    // high: C Z -> high_rev: A_rev Z
    fn reverse_bytes(self: @bytes31) -> bytes31 {
        let u256 { low, high } = (*self).into();
        let (c_rev, _) = reversing(word: high, size: 15, step: SELECT_BYTE.into());
        let (low_rev, a) = reversing_partial_result( // pushes b_rev yielding low_rev
            word: low, onto: c_rev, size: 1, step: SELECT_BYTE.into(),
        );
        let (high_rev, _) = reversing(word: a, size: 15, step: SELECT_BYTE.into());
        let felt: felt252 = u256 { low: low_rev, high: high_rev }.try_into().unwrap();
        felt.try_into().unwrap()
    }
}

impl Bytes31ReversibleBits of ReversibleBits<bytes31> {
    fn reverse_bits(self: @bytes31) -> bytes31 {
        let u256 { low, high } = (*self).into();
        let (c_rev, _) = reversing(word: high, size: 120, step: SELECT_BIT.into());
        let (low_rev, a) = reversing_partial_result( // pushes b_rev yielding low_rev
            word: low, onto: c_rev, size: 8, step: SELECT_BIT.into(),
        );
        let (high_rev, _) = reversing(word: a, size: 120, step: SELECT_BIT.into());
        let felt: felt252 = u256 { low: low_rev, high: high_rev }.try_into().unwrap();
        felt.try_into().unwrap()
    }
}

impl ArrayReversibleBytes<T, +Copy<T>, +Drop<T>, +ReversibleBytes<T>> of ReversibleBytes<Array<T>> {
    fn reverse_bytes(self: @Array<T>) -> Array<T> {
        let mut span = self.span();
        let mut result: Array<T> = Default::default();
        loop {
            match span.pop_back() {
                Option::Some(value) => { result.append(value.reverse_bytes()); },
                Option::None => { break; },
            }
        }
        result
    }
}

impl ArrayReversibleBits<T, +ReversibleBits<T>, +Copy<T>, +Drop<T>> of ReversibleBits<Array<T>> {
    fn reverse_bits(self: @Array<T>) -> Array<T> {
        let mut span = self.span();
        let mut result: Array<T> = Default::default();
        loop {
            match span.pop_back() {
                Option::Some(value) => { result.append(value.reverse_bits()); },
                Option::None => { break; },
            }
        }
        result
    }
}
