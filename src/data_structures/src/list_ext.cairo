use alexandria_data_structures::byte_appender::{ByteAppenderImpl, ByteAppenderSupportTrait};
use alexandria_data_structures::byte_reader::{ByteReaderImpl, Len};
use alexandria_storage::list::{AListIndexViewImpl, List, ListTrait};
use bytes_31::{one_shift_left_bytes_u128};

impl ListU8LenImpl of Len<List<u8>> {
    #[inline(always)]
    fn len(self: @List<u8>) -> usize {
        ListTrait::<u8>::len(self)
    }
}

impl ListU8IndexView of IndexView<List<u8>, usize, @u8> {
    #[inline(always)]
    fn index(self: @List<u8>, index: usize) -> @u8 {
        @AListIndexViewImpl::<u8>::index(self, index)
    }
}
impl ListU8ReaderImpl = ByteReaderImpl<List<u8>>;

impl ByteAppenderSupportListU8Impl of ByteAppenderSupportTrait<List<u8>> {
    fn append_bytes_be(ref self: List<u8>, bytes: felt252, mut count: usize) {
        assert(count <= 31, 'count too big');
        let u256{low, high } = bytes.into();
        loop {
            if count <= 16 {
                break;
            }
            let next = (high / one_shift_left_bytes_u128(count - 17)) % 0x100;
            // Unwrap safe by definition of modulus operation 0x100
            self.append(next.try_into().unwrap());
            count -= 1;
        };
        loop {
            if count == 0 {
                break;
            }
            let next = (low / one_shift_left_bytes_u128(count - 1)) % 0x100;
            // Unwrap safe by definition of modulus operation 0x100
            self.append(next.try_into().unwrap());
            count -= 1;
        };
    }

    fn append_bytes_le(ref self: List<u8>, bytes: felt252, count: usize) {
        assert(count <= 31, 'count too big');
        let u256{mut low, mut high } = bytes.into();
        let mut current = 0;
        let mut index = 0;
        loop {
            if index == count {
                break;
            }
            if count <= 16 {
                current = low;
            } else {
                current = high;
            }
            loop {
                if index == 16 || index == count {
                    break;
                }
                let (remaining_bytes, next) = DivRem::div_rem(
                    current, 0x100_u128.try_into().unwrap()
                );
                current = remaining_bytes;
                // Unwrap safe by definition of remainder from division by 0x100
                self.append(next.try_into().unwrap());
                index += 1;
            };
        };
    }
}
impl ListU8ByteAppenderImpl = ByteAppenderImpl<List<u8>>;
