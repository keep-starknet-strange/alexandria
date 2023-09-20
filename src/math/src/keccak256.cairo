use keccak::cairo_keccak;

#[generate_trait]
impl U64Impl of U64Trait {
    /// Converts a little-endian byte slice to a 64-bit unsigned integer
    ///
    /// # Arguments
    ///
    /// * `self` - A `Span<u8>` slice of size n <=8.
    ///
    /// # Returns
    ///
    /// A tuple containing the converted 64-bit unsigned integer and the amount of bytes consumed
    fn from_le_bytes(mut self: Span<u8>) -> (u64, u32) {
        // Pack full value
        let mut value: u64 = 0;
        let mut n_bytes: u32 = self.len();
        loop {
            let byte = match self.pop_back() {
                Option::Some(byte) => *byte,
                Option::None => {
                    break;
                },
            };
            value = value * 0x100 + (byte.into());
        };
        (value, n_bytes)
    }
}

/// Reverse the endianness of an u256
fn reverse_endianness(value: u256) -> u256 {
    let new_low = integer::u128_byte_reverse(value.high);
    let new_high = integer::u128_byte_reverse(value.low);
    u256 { low: new_low, high: new_high }
}

/// Computes the Solidity-compatible Keccak hash of an array of bytes.
///
/// # Arguments
///
/// * `self` - A `Array<u8>` of bytes.
///
/// # Returns
///
/// A `u256` value representing the Keccak hash of the input bytes array.
fn keccak256(mut self: Span<u8>) -> u256 {
    // Converts byte array to little endian 8 byte words array.
    let mut words64: Array<u64> = Default::default();
    let (last_word, last_word_bytes) = loop {
        // Specifically handle last word
        if self.len() < 8 {
            let (value, n_bytes) = U64Trait::from_le_bytes(self);
            break (value, n_bytes);
        };
        let mut current_word = self.slice(0, 8);
        let (value, n_bytes) = U64Trait::from_le_bytes(current_word);
        words64.append(value);
        self = self.slice(8, self.len() - 8);
    };
    let mut hash = reverse_endianness(cairo_keccak(ref words64, last_word, last_word_bytes));
    hash
}

