pub trait UIntBytes<T> {
    fn from_bytes(input: Span<u8>) -> Option<T>;
    fn to_bytes(self: T) -> Span<u8>;
}

impl U32BytesImpl of UIntBytes<u32> {
    /// Packs 4 bytes into a u32
    /// # Arguments
    /// * `input` a Span<u8> of len <=4
    /// # Returns
    /// * Option::Some(u32) if the operation succeeds
    /// * Option::None otherwise
    fn from_bytes(mut input: Span<u8>) -> Option<u32> {
        let len = input.len();
        if len == 0 {
            return Option::None;
        }
        if len > 4 {
            return Option::None;
        }
        let mut result: u32 = 0;
        for byte in input {
            let byte: u32 = (*byte).into();
            result = result * 0x100 + byte;
        }
        Option::Some(result)
    }

    /// Unpacks a u32 into an array of bytes
    /// # Arguments
    /// * `self` a `u32` value.
    /// # Returns
    /// * The bytes array representation of the value.
    fn to_bytes(mut self: u32) -> Span<u8> {
        let val0: u8 = (self & 0xFF).try_into().unwrap();
        let val1 = self & 0xFF00;
        let val2 = self & 0xFF0000;
        let val3 = self & 0xFF000000;
        if val3 != 0 {
            return array![
                (val3 / 0x1000000).try_into().unwrap(),
                (val2 / 0x10000).try_into().unwrap(),
                (val1 / 0x100).try_into().unwrap(),
                val0,
            ]
                .span();
        }

        if val2 != 0 {
            return array![
                (val2 / 0x10000).try_into().unwrap(), (val1 / 0x100).try_into().unwrap(), val0,
            ]
                .span();
        }

        if val1 != 0 {
            return array![(val1 / 0x100).try_into().unwrap(), val0].span();
        }
        array![val0].span()
    }
}
