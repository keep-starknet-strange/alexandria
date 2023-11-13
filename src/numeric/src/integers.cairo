use alexandria_math::BitShift;

#[generate_trait]
impl U32Impl of U32Trait {
    /// Packs 4 bytes into a u32
    /// # Arguments
    /// * `input` a Span<u8> of len <=4
    /// # Returns
    /// * Option::Some(u32) if the operation succeeds
    /// * Option::None otherwise
    fn from_bytes(input: Span<u8>) -> Option<u32> {
        let len = input.len();
        if len == 0 {
            return Option::None;
        }
        if len > 4 {
            return Option::None;
        }
        let offset: u32 = len - 1;
        let mut result: u32 = 0;
        let mut i: u32 = 0;
        loop {
            if i == len {
                break ();
            }
            let byte: u32 = (*input.at(i)).into();
            result += BitShift::shl(byte, 8 * (offset - i));

            i += 1;
        };
        Option::Some(result)
    }
}
