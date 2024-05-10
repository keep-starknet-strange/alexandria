use alexandria_math::BitShift;

pub trait UIntBytes<T> {
    fn from_bytes(input: Span<u8>) -> Option<T>;
    fn to_bytes(self: T) -> Span<u8>;
    fn bytes_used(self: T) -> u8;
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
        while let Option::Some(byte) = input
            .pop_front() {
                let byte: u32 = (*byte).into();
                result = result * 0x100 + byte;
            };
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
                val3.try_into().unwrap(), val2.try_into().unwrap(), val1.try_into().unwrap(), val0
            ];
        }
    }

    /// Returns the number of bytes used to represent a `u32` value.
    /// # Arguments
    /// * `self` - The value to check.
    /// # Returns
    /// The number of bytes used to represent the value.
    fn bytes_used(self: u32) -> u8 {
        if self < 0x10000 { // 256^2
            if self < 0x100 { // 256^1
                if self == 0 {
                    return 0;
                } else {
                    return 1;
                };
            }
            return 2;
        } else {
            if self < 0x1000000 { // 256^6
                return 3;
            }
            return 4;
        }
    }
}
