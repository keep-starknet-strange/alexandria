use alexandria_bytes::byte_array_ext::ByteArrayTraitExt;
use alexandria_math::U256BitShift;
use alexandria_math::bitmap::Bitmap;
use core::num::traits::Bounded;
use core::traits::DivRem;
use crate::constants::FELT252_MAX;
use crate::evm_enum::EVMTypes;
use crate::evm_struct::EVMCalldata;
use crate::utils::has_dynamic;


pub trait AbiDecodeTrait {
    /// Decodes EVM calldata for the specified types into a Span of `felt252` values.
    ///
    /// This function is the primary entry point for decoding EVM calldata in Starknet Cairo.
    /// It accepts a list of EVM-compatible types and decodes values from calldata accordingly.
    /// The resulting span of `felt252` values can be directly used in Starknet's `call_syscall`.
    ///
    /// This function is typically implemented as a dispatcher that calls appropriate decoding
    /// routines (e.g., `decode_uint`, `decode_tuple`, `decode_array`, etc.) based on the types
    /// passed in.
    ///
    /// #### Arguments
    /// * `self` - Reference to `EVMCalldata` context which maintains the calldata byte array,
    ///            current offset, and relative offset for dynamic type resolution.
    /// * `types` - A list (`Span`) of `EVMTypes` to decode from the current calldata position.
    ///
    /// #### Returns
    /// * `Span<felt252>` - A Cairo Span containing the decoded values in a form compatible
    ///                     with Starknet syscalls (e.g., `call_syscall`).
    ///
    /// #### Usage
    /// This function is typically called within ABI decoding logic where calldata
    /// is parsed and converted into felt-based arguments for invoking other contracts.
    ///
    fn decode(
        ref self: EVMCalldata, types: Span<EVMTypes>,
    ) -> Span<felt252>; // Returns span of felt252 which directly will be passed to call_syscall
}


pub impl EVMTypesImpl of AbiDecodeTrait {
    fn decode(ref self: EVMCalldata, types: Span<EVMTypes>) -> Span<felt252> {
        let mut decoded = array![];

        for evm_type in types {
            let decoded_type = match evm_type {
                EVMTypes::Tuple(tuple_types) => { decode_tuple(ref self, *tuple_types) },
                EVMTypes::Array(array_types) => { decode_array(ref self, *array_types) },
                EVMTypes::FunctionSignature => { decode_function_signature(ref self) },
                EVMTypes::Address => { decode_address(ref self) },
                EVMTypes::Bool => { decode_bool(ref self) },
                EVMTypes::Uint8 => { decode_uint(ref self, 8_u32) },
                EVMTypes::Uint16 => { decode_uint(ref self, 16_u32) },
                EVMTypes::Uint24 => { decode_uint(ref self, 24_u32) },
                EVMTypes::Uint32 => { decode_uint(ref self, 32_u32) },
                EVMTypes::Uint40 => { decode_uint(ref self, 40_u32) },
                EVMTypes::Uint48 => { decode_uint(ref self, 48_u32) },
                EVMTypes::Uint56 => { decode_uint(ref self, 56_u32) },
                EVMTypes::Uint64 => { decode_uint(ref self, 64_u32) },
                EVMTypes::Uint72 => { decode_uint(ref self, 72_u32) },
                EVMTypes::Uint80 => { decode_uint(ref self, 80_u32) },
                EVMTypes::Uint88 => { decode_uint(ref self, 88_u32) },
                EVMTypes::Uint96 => { decode_uint(ref self, 96_u32) },
                EVMTypes::Uint104 => { decode_uint(ref self, 104_u32) },
                EVMTypes::Uint112 => { decode_uint(ref self, 112_u32) },
                EVMTypes::Uint120 => { decode_uint(ref self, 120_u32) },
                EVMTypes::Uint128 => { decode_uint(ref self, 128_u32) },
                EVMTypes::Uint136 => { decode_uint(ref self, 136_u32) },
                EVMTypes::Uint144 => { decode_uint(ref self, 144_u32) },
                EVMTypes::Uint152 => { decode_uint(ref self, 152_u32) },
                EVMTypes::Uint160 => { decode_uint(ref self, 160_u32) },
                EVMTypes::Uint168 => { decode_uint(ref self, 168_u32) },
                EVMTypes::Uint176 => { decode_uint(ref self, 176_u32) },
                EVMTypes::Uint184 => { decode_uint(ref self, 184_u32) },
                EVMTypes::Uint192 => { decode_uint(ref self, 192_u32) },
                EVMTypes::Uint200 => { decode_uint(ref self, 200_u32) },
                EVMTypes::Uint208 => { decode_uint(ref self, 208_u32) },
                EVMTypes::Uint216 => { decode_uint(ref self, 216_u32) },
                EVMTypes::Uint224 => { decode_uint(ref self, 224_u32) },
                EVMTypes::Uint232 => { decode_uint(ref self, 232_u32) },
                EVMTypes::Uint240 => { decode_uint(ref self, 240_u32) },
                EVMTypes::Uint248 => { decode_uint(ref self, 248_u32) },
                EVMTypes::Uint256 => { decode_uint256(ref self) },
                EVMTypes::Int8 => { decode_int(ref self, 8_u32) },
                EVMTypes::Int16 => { decode_int(ref self, 16_u32) },
                EVMTypes::Int24 => { decode_int(ref self, 24_u32) },
                EVMTypes::Int32 => { decode_int(ref self, 32_u32) },
                EVMTypes::Int40 => { decode_int(ref self, 40_u32) },
                EVMTypes::Int48 => { decode_int(ref self, 48_u32) },
                EVMTypes::Int56 => { decode_int(ref self, 56_u32) },
                EVMTypes::Int64 => { decode_int(ref self, 64_u32) },
                EVMTypes::Int72 => { decode_int(ref self, 72_u32) },
                EVMTypes::Int80 => { decode_int(ref self, 80_u32) },
                EVMTypes::Int88 => { decode_int(ref self, 88_u32) },
                EVMTypes::Int96 => { decode_int(ref self, 96_u32) },
                EVMTypes::Int104 => { decode_int(ref self, 104_u32) },
                EVMTypes::Int112 => { decode_int(ref self, 112_u32) },
                EVMTypes::Int120 => { decode_int(ref self, 120_u32) },
                EVMTypes::Int128 => { decode_int(ref self, 128_u32) },
                EVMTypes::Int136 => { decode_int(ref self, 136_u32) },
                EVMTypes::Int144 => { decode_int(ref self, 144_u32) },
                EVMTypes::Int152 => { decode_int(ref self, 152_u32) },
                EVMTypes::Int160 => { decode_int(ref self, 160_u32) },
                EVMTypes::Int168 => { decode_int(ref self, 168_u32) },
                EVMTypes::Int176 => { decode_int(ref self, 176_u32) },
                EVMTypes::Int184 => { decode_int(ref self, 184_u32) },
                EVMTypes::Int192 => { decode_int(ref self, 192_u32) },
                EVMTypes::Int200 => { decode_int(ref self, 200_u32) },
                EVMTypes::Int208 => { decode_int(ref self, 208_u32) },
                EVMTypes::Int216 => { decode_int(ref self, 216_u32) },
                EVMTypes::Int224 => { decode_int(ref self, 224_u32) },
                EVMTypes::Int232 => { decode_int(ref self, 232_u32) },
                EVMTypes::Int240 => { decode_int(ref self, 240_u32) },
                EVMTypes::Int248 => { decode_int(ref self, 248_u32) },
                EVMTypes::Int256 => { decode_int256(ref self) },
                EVMTypes::Bytes1 => { decode_fixed_bytes(ref self, 1_usize) },
                EVMTypes::Bytes2 => { decode_fixed_bytes(ref self, 2_usize) },
                EVMTypes::Bytes3 => { decode_fixed_bytes(ref self, 3_usize) },
                EVMTypes::Bytes4 => { decode_fixed_bytes(ref self, 4_usize) },
                EVMTypes::Bytes5 => { decode_fixed_bytes(ref self, 5_usize) },
                EVMTypes::Bytes6 => { decode_fixed_bytes(ref self, 6_usize) },
                EVMTypes::Bytes7 => { decode_fixed_bytes(ref self, 7_usize) },
                EVMTypes::Bytes8 => { decode_fixed_bytes(ref self, 8_usize) },
                EVMTypes::Bytes9 => { decode_fixed_bytes(ref self, 9_usize) },
                EVMTypes::Bytes10 => { decode_fixed_bytes(ref self, 10_usize) },
                EVMTypes::Bytes11 => { decode_fixed_bytes(ref self, 11_usize) },
                EVMTypes::Bytes12 => { decode_fixed_bytes(ref self, 12_usize) },
                EVMTypes::Bytes13 => { decode_fixed_bytes(ref self, 13_usize) },
                EVMTypes::Bytes14 => { decode_fixed_bytes(ref self, 14_usize) },
                EVMTypes::Bytes15 => { decode_fixed_bytes(ref self, 15_usize) },
                EVMTypes::Bytes16 => { decode_fixed_bytes(ref self, 16_usize) },
                EVMTypes::Bytes17 => { decode_fixed_bytes(ref self, 17_usize) },
                EVMTypes::Bytes18 => { decode_fixed_bytes(ref self, 18_usize) },
                EVMTypes::Bytes19 => { decode_fixed_bytes(ref self, 19_usize) },
                EVMTypes::Bytes20 => { decode_fixed_bytes(ref self, 20_usize) },
                EVMTypes::Bytes21 => { decode_fixed_bytes(ref self, 21_usize) },
                EVMTypes::Bytes22 => { decode_fixed_bytes(ref self, 22_usize) },
                EVMTypes::Bytes23 => { decode_fixed_bytes(ref self, 23_usize) },
                EVMTypes::Bytes24 => { decode_fixed_bytes(ref self, 24_usize) },
                EVMTypes::Bytes25 => { decode_fixed_bytes(ref self, 25_usize) },
                EVMTypes::Bytes26 => { decode_fixed_bytes(ref self, 26_usize) },
                EVMTypes::Bytes27 => { decode_fixed_bytes(ref self, 27_usize) },
                EVMTypes::Bytes28 => { decode_fixed_bytes(ref self, 28_usize) },
                EVMTypes::Bytes29 => { decode_fixed_bytes(ref self, 29_usize) },
                EVMTypes::Bytes30 => { decode_fixed_bytes(ref self, 30_usize) },
                EVMTypes::Bytes31 => { decode_fixed_bytes(ref self, 31_usize) },
                EVMTypes::Bytes32 => { decode_bytes_32(ref self) },
                EVMTypes::Bytes => { decode_bytes(ref self) },
                EVMTypes::String => { decode_bytes(ref self) },
                EVMTypes::Felt252 => { decode_felt252(ref self) },
            };
            decoded.append_span(decoded_type);
        }

        decoded.span()
    }
}

/// Decodes a Solidity/EVM tuple type from calldata.
///
/// #### Arguments
/// * `ctx` - The current EVM calldata decoding context.
/// * `types` - The types of the tuple elements.
///
/// #### Returns
/// A `Span<felt252>` representing the decoded tuple.
///
/// #### How it works:
/// - If any element in the tuple is dynamic (e.g., string, bytes, array),
///   the tuple is encoded using a pointer (offset) to the data region.
/// - In that case, a cloned context is used to decode the tuple at the dynamic offset.
/// - Otherwise, the tuple is decoded inline (statically).
fn decode_tuple(ref ctx: EVMCalldata, types: Span<EVMTypes>) -> Span<felt252> {
    if (has_dynamic(types)) {
        let (new_offset, data_start_offset) = ctx.calldata.read_u256(ctx.offset);
        let mut cloned_context = ctx.clone();
        // This has to be 0x80 for first array
        cloned_context.relative_offset = ctx.relative_offset
            + data_start_offset
                .try_into()
                .unwrap(); // 0x40 + 0x40 = 0x80 .. 0x40 + 0x100 = 0x140 second iter
        cloned_context.offset = ctx.relative_offset + data_start_offset.try_into().unwrap();
        ctx.offset = new_offset;
        return cloned_context.decode(types);
    } else {
        return ctx.decode(types);
    }
}

// Decodes a dynamic array from EVM calldata, based on its ABI type definition.
///
/// #### Arguments
/// * `ctx` - The current calldata parsing context, holding position and offsets.
/// * `types` - A span of EVM ABI types, representing the type of each array element.
///
/// #### Returns
/// * A `Span<felt252>` containing the serialized, decoded array contents.
///
/// #### How it works:
/// - Reads the pointer to the dynamic data from the calldata using the current `ctx.offset`.
/// - Calculates the true offset in calldata where the array data starts.
/// - Reads the array length from the data section.
/// - Iterates over each array element, decoding them based on the provided types.
/// - After decoding all elements, it restores the context offset to the defer offset (for continued
/// parsing).
fn decode_array(ref ctx: EVMCalldata, types: Span<EVMTypes>) -> Span<felt252> {
    let (defer_offset, data_start_offset) = ctx.calldata.read_u256(ctx.offset);

    let (new_offset, items_length) = ctx
        .calldata
        .read_u256(ctx.relative_offset + data_start_offset.try_into().unwrap());

    ctx.offset = new_offset;

    let mut decoded = array![items_length.try_into().unwrap()];
    let mut item_idx = 0;

    let mut cloned_context = ctx.clone();
    cloned_context.relative_offset = ctx.relative_offset + ctx.offset; // 0x40 + 0x0 in first iter

    while item_idx < items_length {
        let decoded_inner_type = cloned_context.decode(types);
        decoded.append_span(decoded_inner_type);
        item_idx += 1;
    }
    ctx.offset = defer_offset;
    decoded.span()
}

/// Decodes a dynamic-length `bytes` field from EVM calldata.
///
/// #### Returns
/// A `Span<felt252>` representing the decoded bytes.
///
/// #### How it works:
/// - Reads pointer to the dynamic `bytes` data.
/// - Reads its length, then iteratively reads the data slot-by-slot.
/// - Restores offset back to the caller after decoding is complete.
fn decode_bytes(ref ctx: EVMCalldata) -> Span<felt252> {
    let (defer_offset, data_start_offset) = ctx
        .calldata
        .read_u256(
            ctx.offset,
        ); // We will move back to defer_offset after complete reading this dynamic type
    ctx
        .offset = data_start_offset
        .try_into()
        .unwrap(); // Data start offset has to be lower than u32 range. TODO: Add check?
    let (new_offset, items_length) = ctx
        .calldata
        .read_u256(ctx.relative_offset + ctx.offset); // length of bytes
    ctx.offset = new_offset;

    let mut ba: ByteArray = Default::default();

    let (slot_count, last_slot_bytes) = DivRem::<u256>::div_rem(items_length, 32);

    let mut curr_slot_idx = 0;
    while curr_slot_idx < slot_count {
        let (new_offset, current_slot) = ctx.calldata.read_u256(ctx.offset);
        ctx.offset = new_offset;

        ba.append_word(current_slot.high.into(), 16);
        ba.append_word(current_slot.low.into(), 16);

        curr_slot_idx += 1;
    }

    // Append last bytes
    if (last_slot_bytes > 0) {
        let (new_offset, last_slot) = ctx.calldata.read_u256(ctx.offset);
        ctx.offset = new_offset;

        let last_word = U256BitShift::shr(last_slot, 256 - (last_slot_bytes * 8));
        ba
            .append_word(
                last_word.try_into().unwrap(), last_slot_bytes.try_into().unwrap(),
            ); // We can assume try_into is safe because we shifted bits line above.
    }
    ctx.offset = defer_offset;

    let mut serialized = array![];
    ba.serialize(ref serialized);
    serialized.span()
}

/// Decodes a fixed-length `bytes32` value from EVM calldata.
///
/// #### Returns
/// A `Span<felt252>` containing 32 bytes split into 31 bytes and the MSB.
#[inline(always)]
fn decode_bytes_32(ref ctx: EVMCalldata) -> Span<felt252> {
    let (_, value) = ctx.calldata.read_u256(ctx.offset);

    let mut ba: ByteArray = Default::default();
    ba.append_u256(value);

    let mut serialized = array![];
    ba.serialize(ref serialized);
    serialized.span()
}

/// Decodes a fixed-length byte array from EVM calldata.
///
/// #### Arguments
/// * `size` - Number of bytes to extract (must be <= 32).
///
/// #### Returns
/// - `Span<felt252>` containing the extracted byte segment.
#[inline(always)]
fn decode_fixed_bytes(ref ctx: EVMCalldata, size: usize) -> Span<felt252> {
    let (new_offset, value) = ctx.calldata.read_uint_within_size::<u256>(ctx.offset, size);
    ctx.offset = new_offset;

    let mut ba: ByteArray = Default::default();
    ba.append_u256(value);

    let mut serialized = array![];
    ba.serialize(ref serialized);
    serialized.span()
}

/// Decodes the first 4 bytes of calldata as an Ethereum function selector.
///
/// #### Returns
/// - `Span<felt252>` containing the 4-byte function selector.
#[inline(always)]
fn decode_function_signature(ref ctx: EVMCalldata) -> Span<felt252> {
    let (new_offset, value) = ctx.calldata.read_u32(ctx.offset);
    ctx.offset = new_offset;
    array![value.into()].span()
}

/// Decodes a 20-byte Ethereum address from calldata.
///
/// #### Returns
/// - `Span<felt252>` containing the address.
#[inline(always)]
fn decode_address(ref ctx: EVMCalldata) -> Span<felt252> {
    let (new_offset, value) = ctx.calldata.read_u256(ctx.offset);
    ctx.offset = new_offset;
    let val: felt252 = value.try_into().unwrap();
    array![val].span()
}

/// Decodes a boolean value from calldata (truthy if non-zero).
///
/// #### Returns
/// - `Span<felt252>` with 0 or 1.
#[inline(always)]
fn decode_bool(ref ctx: EVMCalldata) -> Span<felt252> {
    let (new_offset, value) = ctx.calldata.read_u256(ctx.offset);
    ctx.offset = new_offset;
    array![value.try_into().unwrap()].span()
}

/// Decodes an unsigned integer of arbitrary size (≤ 256 bits).
///
/// #### Arguments
/// * `size` - Bit size of the uint (e.g., 8, 16, 64, 256).
///
/// #### Returns
/// - `Span<felt252>` containing the decoded value.
#[inline(always)]
fn decode_uint(ref ctx: EVMCalldata, size: u32) -> Span<felt252> {
    // TODO: maybe range check with size?
    let (new_offset, value) = ctx.calldata.read_u256(ctx.offset);
    ctx.offset = new_offset;
    array![value.try_into().unwrap()].span()
}

/// Decodes a signed integer of arbitrary size (≤ 256 bits).
///
/// #### Returns
/// - `Span<felt252>` with signed integer encoded into a felt252.
#[inline(always)]
fn decode_int(ref ctx: EVMCalldata, size: u32) -> Span<felt252> {
    // Todo: add range checks maybe??
    let (new_offset, value) = ctx.calldata.read_u256(ctx.offset);
    ctx.offset = new_offset;

    let msb: bool = Bitmap::get_bit_at(value, 255);
    if (msb) {
        let u256_max: u256 = Bounded::MAX;
        let value = (u256_max - value) + 1; // Absolute value

        let sn_value = FELT252_MAX.into() - value + 1;

        array![sn_value.try_into().unwrap()].span()
    } else {
        array![value.try_into().unwrap()].span()
    }
}

/// Decodes a single felt252 value from calldata.
///
/// #### Panics
/// If the value exceeds felt252 limits.
///
/// #### Returns
/// - `Span<felt252>` containing the decoded value.
#[inline(always)]
fn decode_felt252(ref ctx: EVMCalldata) -> Span<felt252> {
    let (new_offset, value) = ctx.calldata.read_u256(ctx.offset);
    ctx.offset = new_offset;
    let value: felt252 = value.try_into().expect('value higher than felt252 limit');
    array![value].span()
}

/// Decodes a 256-bit unsigned integer from calldata.
///
/// #### Returns
/// - `Span<felt252>` containing two felts: `[low, high]`.
#[inline(always)]
fn decode_uint256(ref ctx: EVMCalldata) -> Span<felt252> {
    let (new_offset, value) = ctx.calldata.read_u256(ctx.offset);
    ctx.offset = new_offset;
    array![value.low.into(), value.high.into()].span()
}

/// Decodes a 256-bit signed integer from calldata.
///
/// #### Returns
/// - `Span<felt252>`: `[low, high, sign_bit]`, where sign_bit is 0 or 1.
#[inline(always)]
fn decode_int256(ref ctx: EVMCalldata) -> Span<felt252> {
    let (new_offset, value) = ctx.calldata.read_u256(ctx.offset);
    ctx.offset = new_offset;

    if (value == 0) {
        return array![0x0, 0x0, 0x0].span();
    }
    let msb: bool = Bitmap::get_bit_at(value, 255); // TBD

    if (msb) {
        let u256_max: u256 = Bounded::MAX;
        let value = (u256_max - value) + 1; // Because zero is msb == false
        return array![value.low.into(), value.high.into(), msb.into()].span();
    } else {
        return array![value.low.into(), value.high.into(), msb.into()].span();
    }
}
