use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use alexandria_data_structures::array_ext::ArrayTraitExt;
use alexandria_numeric::integers::UIntBytes;

// Possible RLP errors
#[derive(Drop, Copy, PartialEq)]
pub enum RLPError {
    EmptyInput,
    InputTooShort,
    PayloadTooLong,
}

// Possible RLP types
#[derive(Drop, PartialEq)]
pub enum RLPType {
    String,
    List,
}

#[derive(Drop, Copy, PartialEq)]
pub enum RLPItem {
    String: Span<u8>,
    List: Span<RLPItem>,
}

#[derive(Drop, PartialEq)]
pub enum RLPItemByteArray {
    String: ByteArray,
    List: Span<RLPItemByteArray>,
}

#[generate_trait]
pub impl RLPImpl of RLPTrait {
    /// Returns RLPType from the leading byte with
    /// its offset in the array as well as its size.
    ///
    /// # Arguments
    /// * `input` - Array of byte to decode
    /// # Returns
    /// * `(RLPType, offset, size)` - A tuple containing the RLPType
    /// the offset and the size of the RLPItem to decode
    /// # Errors
    /// * empty input - if the input is empty
    /// * input too short - if the input is too short for a given
    fn decode_type(input: Span<u8>) -> Result<(RLPType, u32, u32), RLPError> {
        let input_len = input.len();
        if input_len == 0 {
            return Result::Err(RLPError::EmptyInput);
        }

        let prefix_byte = *input[0];

        if prefix_byte < 0x80 { // Char
            return Result::Ok((RLPType::String, 0, 1));
        } else if prefix_byte < 0xb8 { // Short String
            return Result::Ok((RLPType::String, 1, prefix_byte.into() - 0x80));
        } else if prefix_byte < 0xc0 { // Long String
            let len_bytes_count: u32 = (prefix_byte - 0xb7).into();
            if input_len <= len_bytes_count {
                return Result::Err(RLPError::InputTooShort);
            }
            let string_len_bytes = input.slice(1, len_bytes_count);
            let string_len: u32 = UIntBytes::from_bytes(string_len_bytes)
                .ok_or(RLPError::PayloadTooLong)?;

            return Result::Ok((RLPType::String, 1 + len_bytes_count, string_len));
        } else if prefix_byte < 0xf8 { // Short List
            return Result::Ok((RLPType::List, 1, prefix_byte.into() - 0xc0));
        } else { // Long List
            let len_bytes_count = prefix_byte.into() - 0xf7;
            if input.len() <= len_bytes_count {
                return Result::Err(RLPError::InputTooShort);
            }
            let list_len_bytes = input.slice(1, len_bytes_count);
            let list_len: u32 = UIntBytes::from_bytes(list_len_bytes)
                .ok_or(RLPError::PayloadTooLong)?;
            return Result::Ok((RLPType::List, 1 + len_bytes_count, list_len));
        }
    }

    /// Recursively encodes multiple a list of RLPItems
    /// # Arguments
    /// * `input` - Span of RLPItem to encode
    /// # Returns
    /// * `Span<u8> - RLP encoded items as a span of bytes
    /// # Errors
    /// * empty input - if the input is empty
    #[deprecated(
        feature: "deprecated-encode",
        note: "Use `alexandria_encoding::rlp::RLPTrait::encode_byte_array`.",
        since: "2.11.1",
    )]
    fn encode(mut input: Span<RLPItem>) -> Result<Span<u8>, RLPError> {
        if input.len() == 0 {
            return Result::Err(RLPError::EmptyInput);
        }

        let mut output: Array<u8> = Default::default();
        // Safe to unwrap because input length is not 0
        let item = input.pop_front().unwrap();

        match item {
            RLPItem::String(string) => { output.extend_from_span(Self::encode_string(*string)?); },
            RLPItem::List(list) => {
                if (*list).len() == 0 {
                    output.append(0xc0);
                } else {
                    let payload = Self::encode(*list)?;
                    let payload_len = payload.len();
                    if payload_len > 55 {
                        let len_in_bytes = payload_len.to_bytes();
                        // The payload length being a u32, the length in bytes
                        // will maximum be equal to 4, making the unwrap safe
                        output.append(0xf7 + len_in_bytes.len().try_into().unwrap());
                        output.extend_from_span(len_in_bytes);
                    } else {
                        // Safe to unwrap because payload_len<55
                        output.append(0xc0 + payload_len.try_into().unwrap());
                    }
                    output.extend_from_span(payload);
                }
            },
        }

        if input.len() > 0 {
            output.extend_from_span(Self::encode(input)?);
        }

        Result::Ok(output.span())
    }

    /// RLP encodes a Array of bytes representing a RLP String.
    /// # Arguments
    /// * `input` - Array of bytes representing a RLP String to encode
    /// # Returns
    /// * `Span<u8> - RLP encoded items as a span of bytes
    fn encode_string(input: Span<u8>) -> Result<Span<u8>, RLPError> {
        let len = input.len();
        if len == 0 {
            return Result::Ok(array![0x80].span());
        } else if len == 1 && *input[0] < 0x80 {
            return Result::Ok(input);
        } else if len < 56 {
            let mut encoding: Array<u8> = Default::default();
            // Safe to unwrap because len<56
            encoding.append(0x80 + len.try_into().unwrap());
            encoding.extend_from_span(input);
            return Result::Ok(encoding.span());
        } else {
            let mut encoding: Array<u8> = Default::default();
            let len_as_bytes = len.to_bytes();
            let len_bytes_count = len_as_bytes.len();
            // The payload length being a u32, the length in bytes
            // will maximum be equal to 4, making the unwrap safe
            let prefix = 0xb7 + len_bytes_count.try_into().unwrap();
            encoding.append(prefix);
            encoding.extend_from_span(len_as_bytes);
            encoding.extend_from_span(input);
            return Result::Ok(encoding.span());
        }
    }

    /// Recursively decodes a rlp encoded byte array
    /// as described in https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/
    ///
    /// # Arguments
    /// * `input` - Array of bytes to decode
    /// # Returns
    /// * `Span<RLPItem>` - Span of RLPItem
    /// # Errors
    /// * input too short - if the input is too short for a given
    #[deprecated(
        feature: "deprecated-decode",
        note: "Use `alexandria_encoding::rlp::RLPTrait::decode_byte_array`.",
        since: "2.11.1",
    )]
    fn decode(input: Span<u8>) -> Result<Span<RLPItem>, RLPError> {
        let mut output: Array<RLPItem> = Default::default();
        let input_len = input.len();

        let (rlp_type, offset, len) = Self::decode_type(input)?;

        if input_len < offset + len {
            return Result::Err(RLPError::InputTooShort);
        }

        match rlp_type {
            RLPType::String => {
                if (len == 0) {
                    output.append(RLPItem::String(array![].span()));
                } else {
                    output.append(RLPItem::String(input.slice(offset, len)));
                }
            },
            RLPType::List => {
                if len > 0 {
                    let res = Self::decode(input.slice(offset, len))?;
                    output.append(RLPItem::List(res));
                } else {
                    output.append(RLPItem::List(array![].span()));
                }
            },
        }

        let total_item_len = len + offset;
        if total_item_len < input_len {
            output
                .extend_from_span(
                    Self::decode(input.slice(total_item_len, input_len - total_item_len))?,
                );
        }

        Result::Ok(output.span())
    }

    /// Encodes a Span of `RLPItemByteArray` (which can be either strings or lists) into a single
    /// RLP-encoded ByteArray.
    /// This function handles recursive encoding for nested lists.
    ///
    /// # Parameters
    /// * `input`: A Span containing RLP items, where each item is either a string (ByteArray) or a
    /// nested list (Span<RLPItemByteArray>).
    ///
    /// # Returns
    /// * `Result<@ByteArray, RLPError>`: The RLP-encoded result or an error if input is empty.
    fn encode_byte_array(mut input: Span<RLPItemByteArray>) -> Result<@ByteArray, RLPError> {
        if input.len() == 0 {
            return Result::Err(RLPError::EmptyInput);
        }

        let mut output: ByteArray = Default::default();
        // Safe to unwrap because input length is not 0
        let item = input.pop_front().unwrap();

        match item {
            RLPItemByteArray::String(string) => {
                output.append(Self::encode_byte_array_string(string).unwrap());
            },
            RLPItemByteArray::List(list) => {
                if (*list).len() == 0 {
                    output.append_byte(0xc0);
                } else {
                    let payload = Self::encode_byte_array(*list)?;
                    let payload_len = payload.len();

                    if payload_len > 55 {
                        let len_byte_size = get_byte_size(payload_len.into());
                        let prefix = 0xf7 + len_byte_size;
                        output.append_byte(prefix);
                        output.append_word(payload_len.into(), len_byte_size.into());
                    } else {
                        let prefix = 0xc0 + payload_len;

                        output.append_word(prefix.into(), 1);
                    }
                    output.append(payload);
                }
            },
        }

        if input.len() > 0 {
            output.append(Self::encode_byte_array(input)?);
        }

        Result::Ok(@output)
    }

    /// Encodes a ByteArray as an RLP string (not a list).
    ///
    /// # Parameters
    /// * `input`: A reference to the ByteArray to encode.
    ///
    /// # Returns
    /// * `Result<@ByteArray, RLPError>`: The RLP-encoded result or an error.
    ///
    /// ## RLP Encoding Rules for Strings:
    /// * For empty string, the encoding is 0x80.
    /// * For single byte less than 0x80, it’s the byte itself (no prefix).
    /// * For strings with length < 56, prefix is 0x80 + length.
    /// * For strings with length >= 56, prefix is 0xb7 + length-of-length, followed by actual
    /// length and data.
    fn encode_byte_array_string(input: @ByteArray) -> Result<@ByteArray, RLPError> {
        let mut output: ByteArray = Default::default();
        let len = input.len();
        if len == 0 {
            output.append_byte(0x80); // TODO: use append_byte ?
        } else if len == 1 && ((input.at(0).unwrap()) == 0_u8) {
            output.append_byte(0x80);
        } else if len == 1 && ((input.at(0).unwrap()) < 0x80_u8) {
            output.append_byte(input.at(0).unwrap().into()); // TODO: use append_byte ?
        } else if len < 56 {
            let prefix = 0x80 + len;
            output.append_word(prefix.into(), 1); // TODO: use append_byte ?
            output.append(input);
        } else {
            let len_byte_size = get_byte_size(len.into());
            let prefix = 0xb7 + len_byte_size;
            let prefix_length = get_byte_size(prefix.into());
            output.append_word(prefix.into(), prefix_length.into());
            output.append_word(len.into(), len_byte_size.into());
            output.append(input);
        }

        Result::Ok(@output)
    }


    /// Recursively decodes a rlp encoded byte array
    /// as described in https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/
    ///
    /// # Arguments
    /// * `input` - ByteArray decode
    /// # Returns
    /// * `Span<ByteArray>` - decoded ByteArray
    /// # Errors
    /// * input too short - if the input is too short for a given
    /// * empty input - if the input is len is 0
    fn decode_byte_array(input: @ByteArray) -> Result<Span<ByteArray>, RLPError> {
        let mut output: Array<ByteArray> = Default::default();
        let input_len = input.len();

        if input_len == 0 {
            return Result::Err(RLPError::EmptyInput);
        }

        let mut i = 0;

        while i != input_len {
            let (_, slice) = input.read_bytes(i, input_len - i);
            let (ba, offset, rlp_type) = Self::decode_byte_array_type(@slice)?;
            match rlp_type {
                RLPType::String => { output.append(ba); },
                RLPType::List => {
                    if ba.len() > 0 {
                        let nested = Self::decode_byte_array(@ba)?;
                        output.extend_from_span(nested);
                    } else {
                        output.append(Default::default());
                    }
                },
            }

            i += offset;
        }

        Result::Ok(output.span())
    }

    /// Decodes the RLP prefix of the input and determines the type (String or List),
    /// returning the decoded payload, the total bytes read, and the inferred RLP type.
    ///
    /// # Parameters
    /// * `input`: Reference to a ByteArray that represents RLP-encoded data.
    ///
    /// # Returns
    /// * `Ok((payload, total_bytes_read, RLPType))`: On success, returns the decoded payload,
    ///   how many bytes were consumed from input, and whether it was a String or List.
    /// * `Err(RLPError)`: If decoding fails due to invalid input length, or size issues.
    fn decode_byte_array_type(input: @ByteArray) -> Result<(ByteArray, u32, RLPType), RLPError> {
        let len = input.len();
        if len == 0 {
            return Result::Err(RLPError::EmptyInput);
        }

        let first_byte = input.at(0).unwrap();

        if first_byte < 0x80_u8 {
            // Single byte, value itself is the data
            let mut output: ByteArray = Default::default();
            output.append_byte(first_byte);
            return Result::Ok((output, 1, RLPType::String));
        } else if first_byte == 0x80_u8 {
            // Empty string
            let output: ByteArray = Default::default();
            return Result::Ok((output, 1, RLPType::String));
        } else if first_byte < 0xb8_u8 {
            // Short string
            let str_len = (first_byte - 0x80_u8);
            if len < 1 + str_len.into() {
                return Result::Err(RLPError::InputTooShort);
            }
            let (_, output) = input.read_bytes(1, str_len.into());
            return Result::Ok((output, 1 + output.len(), RLPType::String));
        } else if first_byte <= 0xbf_u8 {
            // Long string
            let len_of_len = (first_byte - 0xb7_u8);
            if len <= len_of_len.into() {
                return Result::Err(RLPError::InputTooShort);
            }
            let (_, len_bytes) = input.read_bytes(1, len_of_len.into());
            //limit data len to u32
            if (len_bytes.len() > 4) {
                return Result::Err(RLPError::PayloadTooLong);
            }
            let (_, data_len) = len_bytes.read_uint_within_size(0, len_bytes.len());
            if len <= len_of_len.into() + data_len {
                return Result::Err(RLPError::InputTooShort);
            }
            if len.into() > 1 + len_of_len.into() + data_len {
                return Result::Err(RLPError::PayloadTooLong);
            }
            let (_, output) = input.read_bytes(1 + len_of_len.into(), data_len);
            return Result::Ok((output, 1 + len_of_len.into() + output.len(), RLPType::String));
        } else if first_byte <= 0xf7_u8 {
            // Short list
            let list_len = (first_byte - 0xc0_u8);
            if len < 1 + list_len.into() {
                return Result::Err(RLPError::InputTooShort);
            }
            let (_, output) = input.read_bytes(1, list_len.into());
            return Result::Ok((output, 1 + output.len(), RLPType::List));
        } else {
            // Long list
            let len_of_len = (first_byte - 0xf7_u8);
            if len < 1 + len_of_len.into() {
                return Result::Err(RLPError::InputTooShort);
            }
            let (_, len_bytes) = input.read_bytes(1, len_of_len.into());
            //limit data len to u32
            if (len_bytes.len() > 4) {
                return Result::Err(RLPError::PayloadTooLong);
            }
            let (_, data_len) = len_bytes.read_uint_within_size(0, len_bytes.len());
            if len <= len_of_len.into() + data_len {
                return Result::Err(RLPError::InputTooShort);
            }
            if len.into() > 1 + len_of_len.into() + data_len {
                return Result::Err(RLPError::PayloadTooLong);
            }
            let (_, output) = input.read_bytes(1 + len_of_len.into(), data_len);
            return Result::Ok((output, 1 + len_of_len.into() + output.len(), RLPType::List));
        }
    }
}

fn get_byte_size(mut value: u64) -> u8 {
    if value == 0 {
        return 1_u8;
    }

    let mut bytes = 0_u8;

    while value > 0 {
        bytes += 1;
        value = value / 256; // Simulate `value >>= 8`
    }

    bytes
}
