use integer::u512;
use bytes_31::one_shift_left_bytes_felt252;
use byte_array::ByteArray;
use alexandria_data_structures::byte_array_ext::ByteArrayTraitExt;
use core::clone::Clone;

#[derive(Copy, Drop)]
struct ByteArrayReader {
    data: @ByteArray,
    reader_index: usize,
}

#[generate_trait]
impl ByteArrayReaderImpl of ByteArrayReaderTrait {
    fn new(from: @ByteArray) -> ByteArrayReader {
        ByteArrayReader { data: from, reader_index: 0, }
    }

    fn read_u8(ref self: ByteArrayReader) -> Option<u8> {
        let byte = self.data.at(self.reader_index)?;
        self.reader_index += 1;
        Option::Some(byte)
    }

    fn read_u16(ref self: ByteArrayReader) -> Option<u16> {
        let result = self.data.word_u16(self.reader_index)?;
        self.reader_index += 2;
        Option::Some(result)
    }

    fn read_u32(ref self: ByteArrayReader) -> Option<u32> {
        let result = self.data.word_u32(self.reader_index)?;
        self.reader_index += 4;
        Option::Some(result)
    }

    fn read_u64(ref self: ByteArrayReader) -> Option<u64> {
        let result = self.data.word_u64(self.reader_index)?;
        self.reader_index += 8;
        Option::Some(result)
    }

    fn read_u128(ref self: ByteArrayReader) -> Option<u128> {
        let result = self.data.word_u128(self.reader_index)?;
        self.reader_index += 16;
        Option::Some(result)
    }

    fn read_u256(ref self: ByteArrayReader) -> Option<u256> {
        let result = u256 {
            high: self.data.word_u128(self.reader_index)?,
            low: self.data.word_u128(self.reader_index + 16)?
        };
        self.reader_index += 32;
        Option::Some(result)
    }

    fn read_u512(ref self: ByteArrayReader) -> Option<u512> {
        let result = u512 {
            limb3: self.data.word_u128(self.reader_index)?,
            limb2: self.data.word_u128(self.reader_index + 16)?,
            limb1: self.data.word_u128(self.reader_index + 32)?,
            limb0: self.data.word_u128(self.reader_index + 48)?
        };
        self.reader_index += 64;
        Option::Some(result)
    }

    fn read_i8(ref self: ByteArrayReader) -> Option<i8> {
        let felt: felt252 = self.read_u8()?.into();
        Option::Some(parse_signed(felt, 1).unwrap())
    // match felt.try_into() {
    //     Option::Some(pos) => Option::Some(pos),
    //     Option::None => {
    //         let negated: felt252 = felt - 0x100;
    //         'negated'.print();
    //         negated.print();
    //             // - one_shift_left_bytes_felt252(1);
    //         Option::Some(negated.try_into().unwrap())
    //     },
    // }
    }

    fn read_i16(ref self: ByteArrayReader) -> Option<i16> {
        let felt: felt252 = self.read_u16()?.into();
        Option::Some(parse_signed(felt, 2).unwrap())
    }

    fn read_i32(ref self: ByteArrayReader) -> Option<i32> {
        let felt: felt252 = self.read_u32()?.into();
        Option::Some(parse_signed(felt, 4).unwrap())
    }

    fn read_i64(ref self: ByteArrayReader) -> Option<i64> {
        let felt: felt252 = self.read_u64()?.into();
        Option::Some(parse_signed(felt, 8).unwrap())
    }

    fn read_i128(ref self: ByteArrayReader) -> Option<i128> {
        let felt: felt252 = self.read_u128()?.into();
        Option::Some(parse_signed(felt, 16).unwrap())
    }

    // #[inline]
    fn len(self: @ByteArrayReader) -> usize {
        let byte_array = *self.data;
        let byte_array_len = byte_array.len();
        byte_array_len - *self.reader_index
    }
}

fn parse_signed<T, +TryInto<felt252, T>>(value: felt252, bytes: usize) -> Option<T> {
    match value.try_into() {
        Option::Some(pos) => Option::Some(pos),
        Option::None => {
            let negated: felt252 = value - one_shift_left_bytes_felt252(bytes);
            negated.try_into()
        },
    }
}

// impl ByteArrayReaderCloneImpl of Clone<ByteArrayReader> {
//     fn clone(self: @ByteArrayReader) -> ByteArrayReader {
//         ByteArrayReader { data: *self.data, reader_index: *self.reader_index }
//     }
// }