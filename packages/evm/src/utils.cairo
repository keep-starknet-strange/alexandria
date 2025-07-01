use crate::evm_enum::EVMTypes;

/// Checks if any of the provided EVM types are dynamic.
///
/// Dynamic types in Solidity/EVM include arrays, strings, and bytes.
/// These types are not encoded inline and instead use an offset pointing to
/// their actual data location elsewhere in calldata. This helper is used to
/// determine if special encoding/decoding logic is needed.
///
/// #### Arguments
/// * `types` - A span of `EVMTypes` representing the types to check.
///
/// #### Returns
/// * `true` if any type is dynamic; otherwise, `false`.
///
/// #### Examples
/// ```
/// let static_types = array![EVMTypes::Uint256, EVMTypes::Address].span();
/// assert!(!has_dynamic(static_types));
///
/// let dynamic_types = array![EVMTypes::Uint256, EVMTypes::Bytes].span();
/// assert!(has_dynamic(dynamic_types));
/// ```
pub fn has_dynamic(types: Span<EVMTypes>) -> bool {
    for evm_type in types {
        if is_dynamic_type(evm_type) {
            return true;
        }
    }
    false
}

/// Checks if a single EVM type is dynamic.
///
/// #### Arguments
/// * `evm_type` - The EVM type to check.
///
/// #### Returns
/// * `true` if the type is dynamic; otherwise, `false`.
pub fn is_dynamic_type(evm_type: @EVMTypes) -> bool {
    match evm_type {
        EVMTypes::Array(_) => true,
        EVMTypes::String => true,
        EVMTypes::Bytes => true,
        EVMTypes::Tuple(tuple_types) => has_dynamic(*tuple_types),
        _ => false,
    }
}
