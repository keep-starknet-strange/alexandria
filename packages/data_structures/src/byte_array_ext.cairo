use alexandria_data_structures::byte_reader::ByteReader;

#[deprecated(
    feature: "deprecated-into()",
    note: "Use `alexandria_bytes::byte_array_ext::SpanU8IntoBytearray::into()`.",
    since: "2.11.1",
)]
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

#[deprecated(
    feature: "deprecated-into()",
    note: "Use `alexandria_bytes::byte_array_ext::ArrayU8IntoByteArray::into()`.",
    since: "2.11.1",
)]
impl ArrayU8IntoByteArray of Into<Array<u8>, ByteArray> {
    fn into(self: Array<u8>) -> ByteArray {
        self.span().into()
    }
}

#[deprecated(
    feature: "deprecated-into()",
    note: "Use `alexandria_bytes::byte_array_ext::ByteArrayIntoArrayU8::into()`.",
    since: "2.11.1",
)]
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
