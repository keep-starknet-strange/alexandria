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
}
