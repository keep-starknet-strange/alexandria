use alexandria_data_structures::byte_reader::ByteReader;

pub impl SpanU8IntoBytearray of Into<Span<u8>, ByteArray> {
    #[inline]
    fn into(self: Span<u8>) -> ByteArray {
        let mut reader = self.reader();
        let mut result: ByteArray = Default::default();
        loop {
            match reader.read_u8() {
                Option::Some(byte) => result.append_byte(byte),
                Option::None => { break; },
            }
        }
        result
    }
}

impl ArrayU8IntoByteArray of Into<Array<u8>, ByteArray> {
    fn into(self: Array<u8>) -> ByteArray {
        self.span().into()
    }
}

pub impl ByteArrayIntoArrayU8 of Into<ByteArray, Array<u8>> {
    fn into(self: ByteArray) -> Array<u8> {
        let mut reader = self.reader();
        let mut result = array![];
        while let Option::Some(byte) = reader.read_u8() {
            result.append(byte);
        }
        result
    }
}
