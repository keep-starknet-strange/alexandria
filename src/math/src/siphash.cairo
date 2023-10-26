use alexandria_data_structures::byte_reader::{ByteReader, ByteReaderState};
use alexandria_encoding::reversible::ReversibleBytes;
use traits::DivRem;
use integer::{u64_wide_mul, u64_wrapping_add};

const C0: u64 = 0x736f6d6570736575;
const C1: u64 = 0x646f72616e646f6d;
const C2: u64 = 0x6c7967656e657261;
const C3: u64 = 0x7465646279746573;

trait SipHash<T> {
    /// Takes the input byte data and performs a SipHash-2-4:
    /// it takes a 128-bit key, does 2 compression rounds, 4
    /// finalization rounds, and returns a 64-bit tag.
    /// Note: When loading the key parts from a collection of
    /// bytes, it is the little endian interpretation of each
    /// key 64-bit part.
    /// # Arguments
    /// `self` - the byte data to be hashed by SipHash-2-4
    /// `key0` - the first 64 bits of the 128 bit key
    /// `key1` - the last 64 bits of the 128 bit key
    /// # Returns
    /// `u64` - The little endian uint of the resulting bytes
    fn sip_hash(self: @T, key0: u64, key1: u64) -> u64;
}

impl SipHashImpl<T, +Drop<T>, +ByteReader<T>> of SipHash<T> {
    fn sip_hash(self: @T, key0: u64, key1: u64) -> u64 {
        let mut reader = self.reader();
        let mut state = _InternalSiphHash::<T>::initialize(key0, key1);
        state.sip_hash(ref reader)
    }
}

#[derive(Copy, Drop)]
struct SipHashState<T> {
    v0: u64,
    v1: u64,
    v2: u64,
    v3: u64,
}

#[generate_trait]
impl _InternalSiphHashImpl<T, +Drop<T>, +ByteReader<T>> of _InternalSiphHash<T> {
    #[inline(always)]
    fn initialize(key0: u64, key1: u64) -> SipHashState<T> {
        let key0 = key0;
        let key1 = key1;
        let v0 = C0 ^ key0;
        let v1 = C1 ^ key1;
        let v2 = C2 ^ key0;
        let v3 = C3 ^ key1;
        SipHashState { v0, v1, v2, v3 }
    }

    #[inline(always)]
    fn sipround(ref self: SipHashState<T>) {
        self.v0 = u64_wrapping_add(self.v0, self.v1);
        self.v2 = u64_wrapping_add(self.v2, self.v3);
        self.v1 = _rotl(self.v1, BITS_13);
        self.v3 = _rotl(self.v3, BITS_16);
        self.v1 = self.v1 ^ self.v0;
        self.v3 = self.v3 ^ self.v2;
        self.v0 = _rotl(self.v0, BITS_32);
        self.v2 = u64_wrapping_add(self.v2, self.v1);
        self.v0 = u64_wrapping_add(self.v0, self.v3);
        self.v1 = _rotl(self.v1, BITS_17);
        self.v3 = _rotl(self.v3, BITS_21);
        self.v1 = self.v1 ^ self.v2;
        self.v3 = self.v3 ^ self.v0;
        self.v2 = _rotl(self.v2, BITS_32);
    }

    #[inline(always)]
    fn compression(ref self: SipHashState<T>, word: u64) {
        self.v3 = self.v3 ^ word;
        self.sipround();
        self.sipround();
        self.v0 = self.v0 ^ word;
    }

    #[inline]
    fn sip_hash(ref self: SipHashState<T>, ref reader: ByteReaderState<T>) -> u64 {
        let len: u64 = reader.len().into();
        let b = (len % 0x100) * 0x100000000000000;
        loop {
            match reader.read_u64_le() {
                Option::Some(word) => { self.compression(word); },
                Option::None => { break; }
            }
        };
        let last_word = b + reader.load_last_word();
        self.compression(last_word);
        self.finalize().reverse_bytes() // little endian byte order
    }

    #[inline(always)]
    fn finalize(ref self: SipHashState<T>) -> u64 {
        self.v2 = self.v2 ^ 0xff;
        self.sipround();
        self.sipround();
        self.sipround();
        self.sipround();
        self.v0 ^ self.v1 ^ self.v2 ^ self.v3
    }

    #[inline]
    fn load_last_word(ref self: ByteReaderState<T>) -> u64 {
        let mut last_word: u64 = 0;
        let mut index = 0x1_u64;
        loop {
            match self.read_u8() {
                Option::Some(byte) => {
                    last_word += byte.into() * index;
                    index *= 0x100;
                },
                Option::None => { break; },
            }
        };
        last_word
    }
}

// helper function optimized for the small number of rotl cases performed
// avoiding to call any power function for the precomputed values below
const BITS_13: u64 = 0b10000000000000;
const BITS_16: u64 = 0b10000000000000000;
const BITS_17: u64 = 0b100000000000000000;
const BITS_21: u64 = 0b1000000000000000000000;
const BITS_32: u64 = 0b100000000000000000000000000000000;
const PARTITION64_KEY: u128 = 0x00000000000000010000000000000000;

#[inline(always)]
fn _rotl(word: u64, bits: u64) -> u64 {
    let word128 = u64_wide_mul(word, bits);
    let (quotient, remainder) = DivRem::div_rem(word128, PARTITION64_KEY.try_into().unwrap());
    (quotient + remainder).try_into().unwrap()
}
