use alexandria_evm::evm_enum::EVMTypes;
use alexandria_evm::utils::{has_dynamic, is_dynamic_type};

#[test]
fn test_has_dynamic_static_types() {
    let static_types = array![
        EVMTypes::Uint256, EVMTypes::Address, EVMTypes::Bool, EVMTypes::Bytes32,
    ]
        .span();

    assert!(!has_dynamic(static_types));
}

#[test]
fn test_has_dynamic_with_array() {
    let array_types = array![EVMTypes::Uint128].span();
    let types_with_array = array![
        EVMTypes::Uint256, EVMTypes::Array(array_types), EVMTypes::Address,
    ]
        .span();

    assert!(has_dynamic(types_with_array));
}

#[test]
fn test_has_dynamic_with_bytes() {
    let types_with_bytes = array![EVMTypes::Uint256, EVMTypes::Bytes, EVMTypes::Address].span();

    assert!(has_dynamic(types_with_bytes));
}

#[test]
fn test_has_dynamic_with_string() {
    let types_with_string = array![EVMTypes::Uint256, EVMTypes::String, EVMTypes::Address].span();

    assert!(has_dynamic(types_with_string));
}

#[test]
fn test_has_dynamic_with_dynamic_tuple() {
    let dynamic_tuple_types = array![EVMTypes::Uint128, EVMTypes::Bytes].span();
    let types_with_dynamic_tuple = array![EVMTypes::Uint256, EVMTypes::Tuple(dynamic_tuple_types)]
        .span();

    assert!(has_dynamic(types_with_dynamic_tuple));
}

#[test]
fn test_has_dynamic_with_static_tuple() {
    let static_tuple_types = array![EVMTypes::Uint128, EVMTypes::Address].span();
    let types_with_static_tuple = array![EVMTypes::Uint256, EVMTypes::Tuple(static_tuple_types)]
        .span();

    assert!(!has_dynamic(types_with_static_tuple));
}

#[test]
fn test_is_dynamic_type_individual() {
    // Test static types
    assert!(!is_dynamic_type(@EVMTypes::Uint256));
    assert!(!is_dynamic_type(@EVMTypes::Address));
    assert!(!is_dynamic_type(@EVMTypes::Bool));
    assert!(!is_dynamic_type(@EVMTypes::Bytes32));

    // Test dynamic types
    assert!(is_dynamic_type(@EVMTypes::Bytes));
    assert!(is_dynamic_type(@EVMTypes::String));

    let array_types = array![EVMTypes::Uint128].span();
    assert!(is_dynamic_type(@EVMTypes::Array(array_types)));

    // Test tuple with dynamic content
    let dynamic_tuple_types = array![EVMTypes::Uint128, EVMTypes::Bytes].span();
    assert!(is_dynamic_type(@EVMTypes::Tuple(dynamic_tuple_types)));

    // Test tuple with static content
    let static_tuple_types = array![EVMTypes::Uint128, EVMTypes::Address].span();
    assert!(!is_dynamic_type(@EVMTypes::Tuple(static_tuple_types)));
}

#[test]
fn test_empty_types_span() {
    let empty_types = array![].span();
    assert!(!has_dynamic(empty_types));
}
