use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use alexandria_math::bitmap::Bitmap;
use alexandria_math::opt_math::OptBitShift;
use core::num::traits::Bounded;
use core::traits::DivRem;
use crate::constants::FELT252_MAX;
use crate::evm_enum::EVMTypes;
use crate::utils::has_dynamic;

#[derive(Clone, Drop, Serde)]
pub struct EVMCalldata {
    pub calldata: ByteArray,
    pub offset: usize,
    pub dynamic_data: ByteArray,
    pub dynamic_offset: usize,
}

pub trait AbiEncodeTrait {
    /// Encodes felt252 values into EVM calldata for the specified types.
    ///
    /// This function is the primary entry point for encoding values into EVM-compatible calldata
    /// in Starknet Cairo. It accepts a list of EVM-compatible types and a corresponding list of
    /// felt252 values, then encodes them according to EVM ABI encoding standards.
    ///
    /// This function is typically implemented as a dispatcher that calls appropriate encoding
    /// routines (e.g., `encode_uint`, `encode_tuple`, `encode_array`, etc.) based on the types
    /// passed in.
    ///
    /// #### Arguments
    /// * `self` - Reference to `EVMCalldata` context which maintains the calldata byte array,
    ///            current offset, dynamic data section and dynamic offset.
    /// * `types` - A list (`Span`) of `EVMTypes` to encode.
    /// * `values` - A list (`Span`) of `felt252` values to encode according to the types.
    ///
    /// #### Returns
    /// * `ByteArray` - The encoded EVM calldata as a byte array.
    ///
    /// #### Usage
    /// This function is typically called when preparing calldata for EVM contract calls
    /// from within Cairo smart contracts.
    ///
    fn encode(ref self: EVMCalldata, types: Span<EVMTypes>, values: Span<felt252>) -> ByteArray;
}


/// Calculates how many values from the values array are consumed by the given types.
///
/// #### Arguments
/// * `types` - A span of `EVMTypes` representing the types to calculate consumption for.
///
/// #### Returns
/// * `usize` - The number of values that would be consumed from a values array.
fn calculate_values_consumed(types: Span<EVMTypes>) -> usize {
    let mut consumed = 0;
    for evm_type in types {
        match evm_type {
            EVMTypes::Uint256 => { consumed += 2; },
            EVMTypes::Int256 => { consumed += 3; },
            EVMTypes::Bytes32 => { consumed += 4; },
            EVMTypes::Tuple(tuple_types) => {
                consumed += calculate_values_consumed(*tuple_types);
            },
            EVMTypes::Array(_) => { consumed += 1; },
            EVMTypes::Bytes => { consumed += 1; },
            EVMTypes::String => { consumed += 1; },
            _ => { consumed += 1; },
        };
    }
    consumed
}

pub impl EVMTypesImpl of AbiEncodeTrait {
    fn encode(ref self: EVMCalldata, types: Span<EVMTypes>, values: Span<felt252>) -> ByteArray {
        let mut value_index = 0;

        for evm_type in types {
            match evm_type {
                EVMTypes::Tuple(tuple_types) => {
                    let consumed = encode_tuple(
                        ref self,
                        *tuple_types,
                        values.slice(value_index, values.len() - value_index),
                    );
                    value_index += consumed;
                },
                EVMTypes::Array(array_types) => {
                    let consumed = encode_array(
                        ref self,
                        *array_types,
                        values.slice(value_index, values.len() - value_index),
                    );
                    value_index += consumed;
                },
                EVMTypes::FunctionSignature => {
                    encode_function_signature(ref self, *values.at(value_index));
                    value_index += 1;
                },
                EVMTypes::Address => {
                    encode_address(ref self, *values.at(value_index));
                    value_index += 1;
                },
                EVMTypes::Bool => {
                    encode_bool(ref self, *values.at(value_index));
                    value_index += 1;
                },
                EVMTypes::Uint8 => {
                    encode_uint(ref self, *values.at(value_index), 8_u32);
                    value_index += 1;
                },
                EVMTypes::Uint16 => {
                    encode_uint(ref self, *values.at(value_index), 16_u32);
                    value_index += 1;
                },
                EVMTypes::Uint24 => {
                    encode_uint(ref self, *values.at(value_index), 24_u32);
                    value_index += 1;
                },
                EVMTypes::Uint32 => {
                    encode_uint(ref self, *values.at(value_index), 32_u32);
                    value_index += 1;
                },
                EVMTypes::Uint40 => {
                    encode_uint(ref self, *values.at(value_index), 40_u32);
                    value_index += 1;
                },
                EVMTypes::Uint48 => {
                    encode_uint(ref self, *values.at(value_index), 48_u32);
                    value_index += 1;
                },
                EVMTypes::Uint56 => {
                    encode_uint(ref self, *values.at(value_index), 56_u32);
                    value_index += 1;
                },
                EVMTypes::Uint64 => {
                    encode_uint(ref self, *values.at(value_index), 64_u32);
                    value_index += 1;
                },
                EVMTypes::Uint72 => {
                    encode_uint(ref self, *values.at(value_index), 72_u32);
                    value_index += 1;
                },
                EVMTypes::Uint80 => {
                    encode_uint(ref self, *values.at(value_index), 80_u32);
                    value_index += 1;
                },
                EVMTypes::Uint88 => {
                    encode_uint(ref self, *values.at(value_index), 88_u32);
                    value_index += 1;
                },
                EVMTypes::Uint96 => {
                    encode_uint(ref self, *values.at(value_index), 96_u32);
                    value_index += 1;
                },
                EVMTypes::Uint104 => {
                    encode_uint(ref self, *values.at(value_index), 104_u32);
                    value_index += 1;
                },
                EVMTypes::Uint112 => {
                    encode_uint(ref self, *values.at(value_index), 112_u32);
                    value_index += 1;
                },
                EVMTypes::Uint120 => {
                    encode_uint(ref self, *values.at(value_index), 120_u32);
                    value_index += 1;
                },
                EVMTypes::Uint128 => {
                    encode_uint(ref self, *values.at(value_index), 128_u32);
                    value_index += 1;
                },
                EVMTypes::Uint136 => {
                    encode_uint(ref self, *values.at(value_index), 136_u32);
                    value_index += 1;
                },
                EVMTypes::Uint144 => {
                    encode_uint(ref self, *values.at(value_index), 144_u32);
                    value_index += 1;
                },
                EVMTypes::Uint152 => {
                    encode_uint(ref self, *values.at(value_index), 152_u32);
                    value_index += 1;
                },
                EVMTypes::Uint160 => {
                    encode_uint(ref self, *values.at(value_index), 160_u32);
                    value_index += 1;
                },
                EVMTypes::Uint168 => {
                    encode_uint(ref self, *values.at(value_index), 168_u32);
                    value_index += 1;
                },
                EVMTypes::Uint176 => {
                    encode_uint(ref self, *values.at(value_index), 176_u32);
                    value_index += 1;
                },
                EVMTypes::Uint184 => {
                    encode_uint(ref self, *values.at(value_index), 184_u32);
                    value_index += 1;
                },
                EVMTypes::Uint192 => {
                    encode_uint(ref self, *values.at(value_index), 192_u32);
                    value_index += 1;
                },
                EVMTypes::Uint200 => {
                    encode_uint(ref self, *values.at(value_index), 200_u32);
                    value_index += 1;
                },
                EVMTypes::Uint208 => {
                    encode_uint(ref self, *values.at(value_index), 208_u32);
                    value_index += 1;
                },
                EVMTypes::Uint216 => {
                    encode_uint(ref self, *values.at(value_index), 216_u32);
                    value_index += 1;
                },
                EVMTypes::Uint224 => {
                    encode_uint(ref self, *values.at(value_index), 224_u32);
                    value_index += 1;
                },
                EVMTypes::Uint232 => {
                    encode_uint(ref self, *values.at(value_index), 232_u32);
                    value_index += 1;
                },
                EVMTypes::Uint240 => {
                    encode_uint(ref self, *values.at(value_index), 240_u32);
                    value_index += 1;
                },
                EVMTypes::Uint248 => {
                    encode_uint(ref self, *values.at(value_index), 248_u32);
                    value_index += 1;
                },
                EVMTypes::Uint256 => {
                    encode_uint256(ref self, *values.at(value_index), *values.at(value_index + 1));
                    value_index += 2;
                },
                EVMTypes::Int8 => {
                    encode_int(ref self, *values.at(value_index), 8_u32);
                    value_index += 1;
                },
                EVMTypes::Int16 => {
                    encode_int(ref self, *values.at(value_index), 16_u32);
                    value_index += 1;
                },
                EVMTypes::Int24 => {
                    encode_int(ref self, *values.at(value_index), 24_u32);
                    value_index += 1;
                },
                EVMTypes::Int32 => {
                    encode_int(ref self, *values.at(value_index), 32_u32);
                    value_index += 1;
                },
                EVMTypes::Int40 => {
                    encode_int(ref self, *values.at(value_index), 40_u32);
                    value_index += 1;
                },
                EVMTypes::Int48 => {
                    encode_int(ref self, *values.at(value_index), 48_u32);
                    value_index += 1;
                },
                EVMTypes::Int56 => {
                    encode_int(ref self, *values.at(value_index), 56_u32);
                    value_index += 1;
                },
                EVMTypes::Int64 => {
                    encode_int(ref self, *values.at(value_index), 64_u32);
                    value_index += 1;
                },
                EVMTypes::Int72 => {
                    encode_int(ref self, *values.at(value_index), 72_u32);
                    value_index += 1;
                },
                EVMTypes::Int80 => {
                    encode_int(ref self, *values.at(value_index), 80_u32);
                    value_index += 1;
                },
                EVMTypes::Int88 => {
                    encode_int(ref self, *values.at(value_index), 88_u32);
                    value_index += 1;
                },
                EVMTypes::Int96 => {
                    encode_int(ref self, *values.at(value_index), 96_u32);
                    value_index += 1;
                },
                EVMTypes::Int104 => {
                    encode_int(ref self, *values.at(value_index), 104_u32);
                    value_index += 1;
                },
                EVMTypes::Int112 => {
                    encode_int(ref self, *values.at(value_index), 112_u32);
                    value_index += 1;
                },
                EVMTypes::Int120 => {
                    encode_int(ref self, *values.at(value_index), 120_u32);
                    value_index += 1;
                },
                EVMTypes::Int128 => {
                    encode_int(ref self, *values.at(value_index), 128_u32);
                    value_index += 1;
                },
                EVMTypes::Int136 => {
                    encode_int(ref self, *values.at(value_index), 136_u32);
                    value_index += 1;
                },
                EVMTypes::Int144 => {
                    encode_int(ref self, *values.at(value_index), 144_u32);
                    value_index += 1;
                },
                EVMTypes::Int152 => {
                    encode_int(ref self, *values.at(value_index), 152_u32);
                    value_index += 1;
                },
                EVMTypes::Int160 => {
                    encode_int(ref self, *values.at(value_index), 160_u32);
                    value_index += 1;
                },
                EVMTypes::Int168 => {
                    encode_int(ref self, *values.at(value_index), 168_u32);
                    value_index += 1;
                },
                EVMTypes::Int176 => {
                    encode_int(ref self, *values.at(value_index), 176_u32);
                    value_index += 1;
                },
                EVMTypes::Int184 => {
                    encode_int(ref self, *values.at(value_index), 184_u32);
                    value_index += 1;
                },
                EVMTypes::Int192 => {
                    encode_int(ref self, *values.at(value_index), 192_u32);
                    value_index += 1;
                },
                EVMTypes::Int200 => {
                    encode_int(ref self, *values.at(value_index), 200_u32);
                    value_index += 1;
                },
                EVMTypes::Int208 => {
                    encode_int(ref self, *values.at(value_index), 208_u32);
                    value_index += 1;
                },
                EVMTypes::Int216 => {
                    encode_int(ref self, *values.at(value_index), 216_u32);
                    value_index += 1;
                },
                EVMTypes::Int224 => {
                    encode_int(ref self, *values.at(value_index), 224_u32);
                    value_index += 1;
                },
                EVMTypes::Int232 => {
                    encode_int(ref self, *values.at(value_index), 232_u32);
                    value_index += 1;
                },
                EVMTypes::Int240 => {
                    encode_int(ref self, *values.at(value_index), 240_u32);
                    value_index += 1;
                },
                EVMTypes::Int248 => {
                    encode_int(ref self, *values.at(value_index), 248_u32);
                    value_index += 1;
                },
                EVMTypes::Int256 => {
                    encode_int256(
                        ref self,
                        *values.at(value_index),
                        *values.at(value_index + 1),
                        *values.at(value_index + 2),
                    );
                    value_index += 3;
                },
                EVMTypes::Bytes1 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 1_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes2 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 2_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes3 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 3_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes4 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 4_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes5 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 5_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes6 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 6_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes7 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 7_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes8 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 8_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes9 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 9_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes10 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 10_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes11 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 11_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes12 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 12_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes13 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 13_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes14 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 14_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes15 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 15_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes16 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 16_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes17 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 17_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes18 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 18_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes19 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 19_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes20 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 20_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes21 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 21_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes22 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 22_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes23 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 23_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes24 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 24_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes25 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 25_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes26 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 26_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes27 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 27_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes28 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 28_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes29 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 29_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes30 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 30_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes31 => {
                    encode_fixed_bytes(ref self, *values.at(value_index), 31_usize);
                    value_index += 1;
                },
                EVMTypes::Bytes32 => {
                    encode_bytes32(ref self, values.slice(value_index, 4));
                    value_index += 4;
                },
                EVMTypes::Bytes => {
                    let consumed = encode_bytes(
                        ref self, values.slice(value_index, values.len() - value_index),
                    );
                    value_index += consumed;
                },
                EVMTypes::String => {
                    let consumed = encode_bytes(
                        ref self, values.slice(value_index, values.len() - value_index),
                    );
                    value_index += consumed;
                },
                EVMTypes::Felt252 => {
                    encode_felt252(ref self, *values.at(value_index));
                    value_index += 1;
                },
            };
        }

        // Ensure all values were consumed
        assert!(value_index == values.len(), "Not all values were consumed");

        // Combine calldata and dynamic data
        let mut result = self.calldata.clone();
        result.append(@self.dynamic_data);
        result
    }
}

/// Calculates the static section size for a list of types.
/// Each type occupies 32 bytes in the static section (either the value or a pointer).
///
/// #### Arguments
/// * `types` - A span of `EVMTypes` to calculate static size for.
///
/// #### Returns
/// * `u32` - The total size in bytes of the static section.
fn calculate_static_size(types: Span<EVMTypes>) -> u32 {
    types.len() * 32
}

/// Encodes a Solidity/EVM tuple type into calldata.
///
/// #### Arguments
/// * `ctx` - The current EVM calldata encoding context.
/// * `types` - The types of the tuple elements.
/// * `values` - The values to encode.
///
/// #### Returns
/// The number of values consumed from the values span.
fn encode_tuple(ref ctx: EVMCalldata, types: Span<EVMTypes>, values: Span<felt252>) -> usize {
    if (has_dynamic(types)) {
        // Write offset to dynamic data
        write_u256(ref ctx.calldata, ctx.dynamic_offset.into());

        // Calculate the static section size for this tuple
        let static_size = calculate_static_size(types);

        // Encode tuple in dynamic section
        let mut temp_ctx = EVMCalldata {
            calldata: Default::default(),
            offset: 0,
            dynamic_data: Default::default(),
            dynamic_offset: static_size,
        };

        // Encode and track actual consumption
        let mut value_slice = values;
        temp_ctx.encode(types, value_slice);

        ctx.dynamic_data.append(@temp_ctx.calldata);
        ctx.dynamic_data.append(@temp_ctx.dynamic_data);
        ctx.dynamic_offset += temp_ctx.calldata.len() + temp_ctx.dynamic_data.len();

        // Return actual consumed values by checking remaining length
        values.len()
    } else {
        let mut temp_ctx = EVMCalldata {
            calldata: Default::default(),
            offset: 0,
            dynamic_data: Default::default(),
            dynamic_offset: 0,
        };

        temp_ctx.encode(types, values);
        ctx.calldata.append(@temp_ctx.calldata);

        // Return actual consumed values
        values.len()
    }
}

/// Encodes a dynamic array into EVM calldata.
fn encode_array(ref ctx: EVMCalldata, types: Span<EVMTypes>, values: Span<felt252>) -> usize {
    // Calculate the offset to where dynamic data will start
    // If this is the first dynamic data, it starts after the static part
    let offset = if ctx.dynamic_offset == 0 {
        32_usize // First dynamic element starts after one offset slot
    } else {
        ctx.dynamic_offset
    };

    // Write offset to dynamic data
    write_u256(ref ctx.calldata, offset.into());

    // First value should be array length
    let array_length = *values.at(0);
    write_u256(ref ctx.dynamic_data, array_length.into());

    let length: u32 = array_length.try_into().unwrap();
    let mut consumed = 1;

    let is_dynamic = has_dynamic(types);

    if is_dynamic {
        // For arrays of dynamic types, we need to write offset pointers first,
        // then the actual data
        let mut element_data: ByteArray = Default::default();
        let mut element_offsets: Array<usize> = array![];
        let mut current_offset = 32 * length; // Start after the offset table

        let mut i = 0;
        while i < length {
            // Calculate and store the offset for this element
            element_offsets.append(current_offset);

            // Encode this element to calculate its size
            let elem_consumed = match types.at(0) {
                EVMTypes::String |
                EVMTypes::Bytes => {
                    let elem_values = values.slice(consumed, values.len() - consumed);
                    let mut elem_values_ref = elem_values;
                    let _ba: ByteArray = Serde::<ByteArray>::deserialize(ref elem_values_ref)
                        .unwrap();
                    let actual_consumed = elem_values.len() - elem_values_ref.len();

                    // Encode this element directly as bytes/string (inline, not as dynamic)
                    let single_elem_values = values.slice(consumed, actual_consumed);
                    let mut elem_values_ref = single_elem_values;
                    let ba: ByteArray = Serde::<ByteArray>::deserialize(ref elem_values_ref)
                        .unwrap();

                    // Write length
                    write_u256(ref element_data, ba.len().into());

                    // Write data padded to 32-byte boundaries
                    let (slot_count, last_slot_bytes) = DivRem::<u32>::div_rem(ba.len(), 32);

                    let mut j = 0;
                    while j < slot_count {
                        // Extract 32 bytes and write as u256
                        let (_, value) = ba.read_u256(j * 32);
                        write_u256(ref element_data, value);
                        j += 1;
                    }

                    if last_slot_bytes > 0 {
                        // Write last partial slot with padding
                        let (_, partial_bytes) = ba.read_bytes(slot_count * 32, last_slot_bytes);
                        let mut padded_value: u256 = 0;
                        let mut k = 0;
                        while k < last_slot_bytes {
                            let (_, byte_val) = partial_bytes.read_u8(k);
                            let shift_amount = (31 - k) * 8;
                            padded_value = padded_value
                                + (byte_val.into()
                                    * OptBitShift::shl(1_u256, shift_amount.try_into().unwrap()));
                            k += 1;
                        }
                        write_u256(ref element_data, padded_value);
                    }

                    // Update offset for next element (length + padded data)
                    current_offset += 32 + ((ba.len() + 31) / 32) * 32;

                    actual_consumed
                },
                EVMTypes::Array(inner_array_types) => {
                    // Handle nested arrays (array of arrays)
                    let inner_array_length = *values.at(consumed);
                    let inner_length: u32 = inner_array_length.try_into().unwrap();

                    // Calculate size of inner array data (length + elements)
                    let inner_elem_size = calculate_values_consumed(*inner_array_types);
                    let total_inner_size = 1
                        + (inner_length * inner_elem_size); // 1 for length + elements

                    // Encode the inner array
                    let mut inner_ctx = EVMCalldata {
                        calldata: Default::default(),
                        offset: 0,
                        dynamic_data: Default::default(),
                        dynamic_offset: 0,
                    };

                    let inner_values = values.slice(consumed, total_inner_size);
                    inner_ctx
                        .encode(array![EVMTypes::Array(*inner_array_types)].span(), inner_values);

                    // Append the inner array's complete encoding (without the initial offset)
                    // For nested arrays, we need the dynamic data which contains the actual array
                    element_data.append(@inner_ctx.dynamic_data);

                    // Update offset for next element
                    current_offset += inner_ctx.dynamic_data.len();

                    total_inner_size
                },
                _ => {
                    // Static types
                    let elem_size = calculate_values_consumed(types);
                    let mut temp_ctx = EVMCalldata {
                        calldata: Default::default(),
                        offset: 0,
                        dynamic_data: Default::default(),
                        dynamic_offset: 0,
                    };
                    let elem_values = values.slice(consumed, elem_size);
                    temp_ctx.encode(types, elem_values);
                    element_data.append(@temp_ctx.calldata);

                    current_offset += temp_ctx.calldata.len();
                    elem_size
                },
            };

            consumed += elem_consumed;
            i += 1;
        }

        // Write all the offset pointers
        i = 0;
        while i < length {
            write_u256(ref ctx.dynamic_data, (*element_offsets.at(i)).into());
            i += 1;
        }

        // Write all the element data
        ctx.dynamic_data.append(@element_data);
    } else {
        // For arrays of static types, encode elements inline
        let mut temp_ctx = EVMCalldata {
            calldata: Default::default(),
            offset: 0,
            dynamic_data: Default::default(),
            dynamic_offset: 0,
        };

        let mut i = 0;
        while i < length {
            let elem_size = calculate_values_consumed(types);
            let elem_values = values.slice(consumed, elem_size);
            temp_ctx.encode(types, elem_values);
            consumed += elem_size;
            i += 1;
        }

        ctx.dynamic_data.append(@temp_ctx.calldata);
    }

    ctx.dynamic_offset = offset
        + 32
        + ctx.dynamic_data.len(); // Update offset for next dynamic data
    consumed
}

/// Encodes dynamic bytes into calldata.
fn encode_bytes(ref ctx: EVMCalldata, values: Span<felt252>) -> usize {
    let offset = if ctx.dynamic_offset == 0 {
        32_usize
    } else {
        ctx.dynamic_offset
    };
    // Write offset to dynamic data
    write_u256(ref ctx.calldata, offset.into());
    let mut values_ref = values;
    let ba: ByteArray = Serde::<ByteArray>::deserialize(ref values_ref).unwrap();

    // Write length
    write_u256(ref ctx.dynamic_data, ba.len().into());
    // Write data padded to 32-byte boundaries
    let (slot_count, last_slot_bytes) = DivRem::<u32>::div_rem(ba.len(), 32);

    let mut i = 0;
    while i < slot_count {
        // Extract 32 bytes and write as u256
        let (_, value) = ba.read_u256(i * 32);
        write_u256(ref ctx.dynamic_data, value);
        i += 1;
    }

    if last_slot_bytes > 0 {
        // Write last partial slot with padding
        let (_, partial_bytes) = ba.read_bytes(slot_count * 32, last_slot_bytes);
        let mut padded_value: u256 = 0;
        let mut j = 0;
        while j < last_slot_bytes {
            let (_, byte_val) = partial_bytes.read_u8(j);
            let shift_amount = (31 - j) * 8;
            padded_value = padded_value
                + (byte_val.into() * OptBitShift::shl(1_u256, shift_amount.try_into().unwrap()));
            j += 1;
        }
        write_u256(ref ctx.dynamic_data, padded_value);
    }

    ctx.dynamic_offset = offset + 32 + ((ba.len() + 31) / 32) * 32; // Length + padded data

    values.len() - values_ref.len()
}

/// Encodes a 32-byte value into calldata from serialized ByteArray (bytes31 + 1 byte).
fn encode_bytes32(ref ctx: EVMCalldata, bytes: Span<felt252>) {
    // ByteArray serialization for 32 bytes: [pending_word_len, bytes31_word, pending_byte,
    // array_len]
    // We need to reconstruct the full 32 bytes as u256
    let bytes31_value: u256 = (*bytes.at(1)).into();
    let last_byte: u256 = (*bytes.at(2)).into();

    // Shift bytes31 left by 8 bits and add the last byte
    let full_value = (bytes31_value * 256) + last_byte;
    write_u256(ref ctx.calldata, full_value);
}

/// Encodes fixed-length bytes into calldata.
fn encode_fixed_bytes(ref ctx: EVMCalldata, value: felt252, size: usize) {
    let u256_value: u256 = value.into();
    // Shift left to align bytes to the left of the 32-byte slot
    let shifted = OptBitShift::shl(u256_value, ((32 - size) * 8).try_into().unwrap());
    write_u256(ref ctx.calldata, shifted);
}

/// Encodes a function signature (4 bytes) into calldata.
fn encode_function_signature(ref ctx: EVMCalldata, value: felt252) {
    let u32_value: u32 = value.try_into().expect('Invalid function signature');
    // Pad to 32 bytes (left-aligned)
    let u256_value: u256 = u32_value.into();
    let shifted = OptBitShift::shl(u256_value, 224_u8); // Shift left by 28 bytes
    write_u256(ref ctx.calldata, shifted);
}

/// Encodes an Ethereum address (20 bytes) into calldata.
fn encode_address(ref ctx: EVMCalldata, value: felt252) {
    let u256_value: u256 = value.into();
    write_u256(ref ctx.calldata, u256_value);
}

/// Encodes a boolean value into calldata.
fn encode_bool(ref ctx: EVMCalldata, value: felt252) {
    let bool_value: u256 = if value == 0 {
        0
    } else {
        1
    };
    write_u256(ref ctx.calldata, bool_value);
}

/// Encodes an unsigned integer into calldata.
fn encode_uint(ref ctx: EVMCalldata, value: felt252, size: u32) {
    let u256_value: u256 = value.into();
    write_u256(ref ctx.calldata, u256_value);
}

/// Encodes a signed integer into calldata.
fn encode_int(ref ctx: EVMCalldata, value: felt252, size: u32) {
    let value_u256: u256 = value.into();
    let felt252_max_u256: u256 = FELT252_MAX.into();
    let half_felt252_max = felt252_max_u256 / 2;

    let u256_value: u256 = if value_u256 > half_felt252_max {
        // Negative value in Cairo (represented as FELT252_MAX - |value| + 1)
        let abs_value = felt252_max_u256 - value_u256 + 1;
        let u256_max: u256 = Bounded::MAX;
        (u256_max - abs_value) + 1
    } else {
        // Positive value
        value_u256
    };
    write_u256(ref ctx.calldata, u256_value);
}

/// Encodes a felt252 value into calldata.
fn encode_felt252(ref ctx: EVMCalldata, value: felt252) {
    let u256_value: u256 = value.into();
    write_u256(ref ctx.calldata, u256_value);
}

/// Encodes a 256-bit unsigned integer into calldata.
fn encode_uint256(ref ctx: EVMCalldata, low: felt252, high: felt252) {
    let u256_value = u256 { low: low.try_into().unwrap(), high: high.try_into().unwrap() };
    write_u256(ref ctx.calldata, u256_value);
}

/// Encodes a 256-bit signed integer into calldata.
fn encode_int256(ref ctx: EVMCalldata, low: felt252, high: felt252, sign_bit: felt252) {
    let u256_value = if sign_bit != 0 {
        // Negative value - convert from absolute representation
        let abs_value = u256 { low: low.try_into().unwrap(), high: high.try_into().unwrap() };
        let u256_max: u256 = Bounded::MAX;
        (u256_max - abs_value) + 1
    } else {
        // Positive value
        u256 { low: low.try_into().unwrap(), high: high.try_into().unwrap() }
    };
    write_u256(ref ctx.calldata, u256_value);
}

/// Helper function to write a u256 value to a ByteArray.
fn write_u256(ref ba: ByteArray, value: u256) {
    ba.append_u256(value);
}
