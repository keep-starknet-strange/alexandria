use alexandria_data_structures::byte_appender::ByteAppender;
use alexandria_data_structures::byte_reader::ByteReader;
use array::{serialize_array_helper, deserialize_array_helper};
use bytes_31::BYTES_IN_BYTES31;
use traits::DivRem;
use core::serde::into_felt252_based::SerdeImpl;
use traits::Into;


impl ByteArraySerde of Serde<ByteArray> {
    fn serialize(self: @ByteArray, ref output: Array<felt252>) {
        let len = self.len();
        len.serialize(ref output);
        let bytes31_arr = self.data.span();
        serialize_array_helper(bytes31_arr, ref output);

        if (*self.pending_word_len > 0) {
            output.append(*self.pending_word);
        }
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<ByteArray> {
        let length = *serialized.pop_front()?;
        let length: usize = length.try_into().unwrap();
        let denominator: NonZero<usize> = BYTES_IN_BYTES31.try_into().unwrap();
        let (felt_length, pending_word_len) = DivRem::div_rem(length, denominator);
        let mut arr: Array<bytes31> = array![];
        let bytes31_arr = deserialize_array_helper(ref serialized, arr, felt_length.into())?;

        let pending_word = if pending_word_len > 0 {
            *serialized.pop_front()?
        } else {
            0
        };

        Option::Some(
            ByteArray {
                data: bytes31_arr,
                pending_word: pending_word,
                pending_word_len: pending_word_len.try_into().unwrap()
            }
        )
    }
}

impl SpanU8IntoBytearray of Into<Span<u8>, ByteArray> {
    #[inline]
    fn into(self: Span<u8>) -> ByteArray {
        let mut reader = self.reader();
        let mut result: ByteArray = Default::default();
        loop {
            match reader.read_u8() {
                Option::Some(byte) => result.append_byte(byte),
                Option::None => { break; },
            }
        };
        result
    }
}

impl ArrayU8IntoByteArray of Into<Array<u8>, ByteArray> {
    fn into(self: Array<u8>) -> ByteArray {
        self.span().into()
    }
}

impl ByteArrayIntoArrayU8 of Into<ByteArray, Array<u8>> {
    fn into(self: ByteArray) -> Array<u8> {
        let mut reader = self.reader();
        let mut result = array![];
        loop {
            match reader.read_u8() {
                Option::Some(byte) => result.append(byte),
                Option::None => { break; },
            }
        };
        result
    }
}
