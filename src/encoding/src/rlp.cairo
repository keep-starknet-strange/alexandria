use alexandria_data_structures::array_ext::{SpanTraitExt, ArrayTraitExt};
use alexandria_numeric::integers::U32Trait;
use core::result::ResultTrait;

use debug::PrintTrait;
// Possible RLP types
#[derive(Drop, PartialEq)]
enum RLPType {
    String,
    List
}

#[derive(Drop, Copy, PartialEq)]
enum RLPItem {
    String: Span<u8>,
    List: Span<RLPItem>
}

#[generate_trait]
impl RLPImpl of RLPTrait {
    /// Returns RLPType from the leading byte with
    /// its offset in the array as well as its size.
    ///
    /// # Arguments
    /// * `input` - Array of byte to decode
    /// # Returns
    /// * `(RLPType, offset, size)` - A tuple containing the RLPType
    /// the offset and the size of the RLPItem to decode
    /// # Errors
    /// * RLPError::EmptyInput - if the input is empty
    /// * RLPError::InputTooShort - if the input is too short for a given
    fn decode_type(input: Span<u8>) -> (RLPType, u32, u32) {
        let input_len = input.len();
        if input_len == 0 {
            panic_with_felt252('empty input');
        }

        let prefix_byte = *input[0];

        if prefix_byte < 0x80 { // Char
            (RLPType::String, 0, 1)
        } else if prefix_byte < 0xb8 { // Short String
            (RLPType::String, 1, prefix_byte.into() - 0x80)
        } else if prefix_byte < 0xc0 { // Long String
            let len_bytes_count: u32 = (prefix_byte - 0xb7).into();
            if input_len <= len_bytes_count {
                panic_with_felt252('input too short');
            }
            let string_len_bytes = input.slice(1, len_bytes_count);
            let string_len: u32 = U32Trait::from_bytes(string_len_bytes).unwrap();

            (RLPType::String, 1 + len_bytes_count, string_len)
        } else if prefix_byte < 0xf8 { // Short List
            (RLPType::List, 1, prefix_byte.into() - 0xc0)
        } else { // Long List
            let len_bytes_count = prefix_byte.into() - 0xf7;
            if input.len() <= len_bytes_count {
                panic_with_felt252('input too short');
            }

            let list_len_bytes = input.slice(1, len_bytes_count);
            let list_len: u32 = U32Trait::from_bytes(list_len_bytes).unwrap();
            (RLPType::List, 1 + len_bytes_count, list_len)
        }
    }

    /// RLP encodes multiple RLPItem
    /// # Arguments
    /// * `input` - Span of RLPItem to encode
    /// # Returns
    /// * `ByteArray - RLP encoded ByteArray
    /// # Errors
    /// * RLPError::RlpEmptyInput - if the input is empty
    fn encode(mut input: Span<RLPItem>) -> Span<u8> {
        if input.len() == 0 {
            panic_with_felt252('empty input');
        }

        let mut output: Array<u8> = Default::default();
        let item = input.pop_front().unwrap();

        match item {
            RLPItem::String(string) => { output.concat_span(RLPTrait::encode_string(*string)); },
            RLPItem::List(list) => {
                if (*list).len() == 0 {
                    output.append(0xc0);
                } else {
                    let payload = RLPTrait::encode(*list);
                    let payload_len = payload.len();
                    if payload_len > 55 {
                        let len_in_bytes = payload_len.to_bytes();
                        output.append(0xf7 + len_in_bytes.len().try_into().unwrap());
                        output.concat_span(len_in_bytes);
                    } else {
                        output.append(0xc0 + payload_len.try_into().unwrap());
                    }
                    output.concat_span(payload);
                }
            }
        }

        if input.len() > 0 {
            output.concat_span(RLPTrait::encode(input));
        }

        output.span()
    }

    /// RLP encodes a Span<u8>, which is the underlying type used to represent
    /// string data in Cairo.  Since RLP encoding is only used for eth_address
    /// computation by calculating the RLP::encode(deployer_address, deployer_nonce)
    /// and then hash it, the input is a ByteArray and not a Span<u8>
    /// # Arguments
    /// * `input` - Span<u8> to encode
    /// # Returns
    /// * `ByteArray - RLP encoded ByteArray
    /// # Errors
    /// * RLPError::RlpEmptyInput - if the input is empty
    fn encode_string(input: Span<u8>) -> Span<u8> {
        let len = input.len();
        if len == 0 {
            return array![0x80].span();
        } else if len == 1 && *input[0] < 0x80 {
            return input;
        } else if len < 56 {
            let mut encoding: Array<u8> = Default::default();
            encoding.append(0x80 + len.try_into().unwrap());
            encoding.concat_span(input);
            return encoding.span();
        } else {
            let mut encoding: Array<u8> = Default::default();
            let len_as_bytes = len.to_bytes();
            let len_bytes_count = len_as_bytes.len();
            let prefix = 0xb7 + len_bytes_count.try_into().unwrap();
            encoding.append(prefix);
            encoding.concat_span(len_as_bytes);
            encoding.concat_span(input);
            return encoding.span();
        }
    }

    /// RLP decodes a rlp encoded byte array
    /// as described in https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/
    ///
    /// # Arguments
    /// * `input` - Array of bytes to decode
    /// # Returns
    /// * `Span<RLPItem>` - Span of RLPItem
    /// # Errors
    /// * RLPError::InputTooShort - if the input is too short for a given
    fn decode(input: Span<u8>) -> Span<RLPItem> {
        let mut output: Array<RLPItem> = Default::default();
        let input_len = input.len();

        let (rlp_type, offset, len) = RLPTrait::decode_type(input);

        if input_len < offset + len {
            panic_with_felt252('input too short');
        }

        match rlp_type {
            RLPType::String => {
                // checking for default value `0`
                if (len == 0) {
                    output.append(RLPItem::String(array![0].span()));
                } else {
                    output.append(RLPItem::String(input.slice(offset, len)));
                }
            },
            RLPType::List => {
                if len > 0 {
                    let res = RLPTrait::decode(input.slice(offset, len));
                    output.append(RLPItem::List(res));
                } else {
                    output.append(RLPItem::List(array![].span()));
                }
            }
        };

        let total_item_len = len + offset;
        if total_item_len < input_len {
            return output
                .span()
                .concat(RLPTrait::decode(input.slice(total_item_len, input_len - total_item_len)));
        }

        output.span()
    }
}
