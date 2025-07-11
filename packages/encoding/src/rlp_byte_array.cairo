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

#[derive(Drop, PartialEq)]
pub enum RLPItemByteArray {
    String: ByteArray,
    List: Span<RLPItemByteArray>,
}

#[generate_trait]
pub impl RLPImpl of RLPTrait {
    /// Encodes a Span of `RLPItemByteArray` (which can be either strings or lists) into a single
    /// RLP-encoded ByteArray.
    /// This function handles recursive encoding for nested lists.
    ///
    /// #### Arguments
    /// * `input`: A Span containing RLP items, where each item is either a string (ByteArray) or a
    /// nested list (Span<RLPItemByteArray>).
    /// * `prefix`: can be used for ex eip1559 is 0x2
    /// #### Returns
    /// * `Result<@ByteArray, RLPError>`: The RLP-encoded result or an error if input is empty.
    fn encode_byte_array(
        mut input: Span<RLPItemByteArray>, prefix: u8,
    ) -> Result<@ByteArray, RLPError> {
        if input.len() == 0 {
            return Result::Err(RLPError::EmptyInput);
        }

        let mut output: ByteArray = Default::default();

        if (prefix > 0) {
            output.append_byte(prefix);
        }

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
                    let payload = Self::encode_byte_array(*list, 0)?;
                    output.append(Self::encode_byte_array_list(array![payload].span(), 0).unwrap());
                }
            },
        }

        if input.len() > 0 {
            output.append(Self::encode_byte_array(input, 0)?);
        }

        Result::Ok(@output)
    }

    /// Encodes a ByteArray as an RLP string (not a list).
    ///
    /// #### Arguments
    /// * `input`: A reference to the ByteArray to encode.
    ///
    /// #### Returns
    /// * `Result<@ByteArray, RLPError>`: The RLP-encoded result or an error.
    ///
    /// #### RLP Encoding Rules for Strings:
    /// * For empty string, the encoding is 0x80.
    /// * For single byte less than 0x80, it’s the byte itself (no prefix).
    /// * For strings with length < 56, prefix is 0x80 + length.
    /// * For strings with length >= 56, prefix is 0xb7 + length-of-length, followed by actual
    /// length and data.
    fn encode_byte_array_string(input: @ByteArray) -> Result<@ByteArray, RLPError> {
        let mut output: ByteArray = Default::default();
        let len = input.len();
        if len == 0 {
            output.append_byte(0x80);
        } else if len == 1 && ((input.at(0).unwrap()) == 0_u8) {
            output.append_byte(0x80);
        } else if len == 1 && ((input.at(0).unwrap()) < 0x80_u8) {
            output.append_byte(input.at(0).unwrap().into());
        } else if len < 56 {
            let prefix = 0x80 + len;
            output.append_word(prefix.into(), 1);
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


    /// Encodes a list of RLP-encoded ByteArrays into a single RLP list item.
    ///
    /// Assumes all input elements are already RLP-encoded.
    /// Used for creating composite structures like transaction lists or EIP-1559 typed payloads.
    ///
    /// #### Arguments
    /// * `inputs` - Span of RLP-encoded `@ByteArray` items to be wrapped in a list.
    /// * `prefix` - Optional prefix byte (e.g., 0x2 for EIP-1559), 0 if unused.
    ///
    /// #### Returns
    /// * `@ByteArray` - a new RLP-encoded ByteArray representing the list.
    ///
    /// #### Behavior
    /// * Uses short or long list prefix depending on total payload size.
    /// * Adds prefix byte if `prefix > 0`.
    fn encode_byte_array_list(
        mut inputs: Span<@ByteArray>, prefix: u8,
    ) -> Result<@ByteArray, RLPError> {
        let mut output: ByteArray = Default::default();

        let mut current_len = 0;
        let mut i = 0;
        while i != inputs.len() {
            current_len = current_len + inputs[i].len();
            i = i + 1;
        }

        if (prefix > 0) {
            output.append_word(prefix.into(), 1);
        }

        if current_len == 0 {
            output.append_word(0xc0, 1);
            return Result::Ok(@output);
        }

        if current_len > 55 {
            let len_byte_size = get_byte_size(current_len.into());
            let prefix = 0xf7 + len_byte_size;
            output.append_word(prefix.into(), get_byte_size(prefix.into()).into());
            output.append_word(current_len.into(), len_byte_size.into());
        } else {
            let prefix = 0xc0 + current_len;
            output.append_word(prefix.into(), 1);
        }

        while true {
            match inputs.pop_front() {
                Option::Some(input) => { output.append(*input); },
                Option::None => { break; },
            };
        }

        return Result::Ok(@output);
    }


    /// Recursively decodes a rlp encoded byte array
    /// as described in https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/
    ///
    /// #### Arguments
    /// * `input` - ByteArray decode
    /// #### Returns
    /// * `Span<ByteArray>` - decoded ByteArray
    /// #### Errors
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
    /// #### Arguments
    /// * `input`: Reference to a ByteArray that represents RLP-encoded data.
    ///
    /// #### Returns
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
