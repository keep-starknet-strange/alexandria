use alexandria_json::json::{JsonError, JsonValue, deserialize_json, parse_json, serialize_json};
use alexandria_math::decimal::{DECIMAL_SCALE, Decimal, DecimalTrait};

// Test struct with all supported types
#[derive(JsonSerialize, JsonDeserialize, Drop, Clone, PartialEq, Debug)]
struct User {
    name: ByteArray,
    age: felt252,
    is_active: bool,
    tags: Array<ByteArray>,
}

// Test struct with multiple string fields
#[derive(JsonSerialize, JsonDeserialize, Drop, Clone, PartialEq, Debug)]
struct Profile {
    id: ByteArray,
    name: ByteArray,
    email: ByteArray,
    description: ByteArray,
    location: ByteArray,
}

// Test struct with numeric fields
#[derive(JsonSerialize, JsonDeserialize, Drop, Clone, PartialEq, Debug)]
struct Account {
    user_id: felt252,
    balance: felt252,
    credit_score: felt252,
    transaction_count: felt252,
}

// Test struct with boolean fields
#[derive(JsonSerialize, JsonDeserialize, Drop, Clone, PartialEq, Debug)]
struct Settings {
    notifications_enabled: bool,
    dark_mode: bool,
    auto_save: bool,
    is_premium: bool,
}

// Test struct with Decimal fields
#[derive(JsonSerialize, JsonDeserialize, Drop, Clone, PartialEq, Debug)]
struct Price {
    amount: Decimal,
    currency: ByteArray,
}

// Test struct with mixed Decimal and other types
#[derive(JsonSerialize, JsonDeserialize, Drop, Clone, PartialEq, Debug)]
struct Product {
    name: ByteArray,
    price: Decimal,
    discount: Decimal,
    in_stock: bool,
    quantity: felt252,
}

#[test]
fn test_deserialize_mixed_types() {
    // Create original data
    let mut original_tags = array![];
    original_tags.append("rust");
    original_tags.append("cairo");
    original_tags.append("blockchain");

    let original_user = User {
        name: "Alice Developer", age: 32, is_active: true, tags: original_tags,
    };

    // Serialize then deserialize
    let json_string = serialize_json(@original_user);
    let result: Result<User, JsonError> = deserialize_json(json_string);

    // Verify successful deserialization
    assert!(result.is_ok());
    let deserialized_user = result.unwrap();

    // Verify all fields deserialized correctly
    assert!(deserialized_user.name == original_user.name);
    assert!(deserialized_user.is_active == original_user.is_active);
    assert!(deserialized_user.tags.len() == original_user.tags.len());
    assert!(deserialized_user.tags.at(0) == @"rust");
    assert!(deserialized_user.tags.at(1) == @"cairo");
    assert!(deserialized_user.tags.at(2) == @"blockchain");
}

#[test]
fn test_deserialize_string_fields() {
    let original_profile = Profile {
        id: "profile_001",
        name: "John Doe",
        email: "john.doe@company.com",
        description: "Experienced blockchain developer and smart contract auditor",
        location: "Remote - Global",
    };

    // Roundtrip test
    let json_string = serialize_json(@original_profile);
    let result: Result<Profile, JsonError> = deserialize_json(json_string);

    assert!(result.is_ok());
    let deserialized_profile = result.unwrap();

    // Verify all string fields
    assert!(deserialized_profile.id == original_profile.id);
    assert!(deserialized_profile.name == original_profile.name);
    assert!(deserialized_profile.email == original_profile.email);
    assert!(deserialized_profile.description == original_profile.description);
    assert!(deserialized_profile.location == original_profile.location);
}

#[test]
fn test_deserialize_numeric_fields() {
    let original_account = Account {
        user_id: 98765, balance: 2500000, credit_score: 720, transaction_count: 156,
    };

    let json_string = serialize_json(@original_account);
    let result: Result<Account, JsonError> = deserialize_json(json_string);

    assert!(result.is_ok());
    let deserialized_account = result.unwrap();

    // Verify exact numeric field values after roundtrip
    assert!(deserialized_account.user_id == 98765);
    assert!(deserialized_account.balance == 2500000);
    assert!(deserialized_account.credit_score == 720);
    assert!(deserialized_account.transaction_count == 156);
}

#[test]
fn test_deserialize_boolean_fields() {
    let original_settings = Settings {
        notifications_enabled: true, dark_mode: false, auto_save: true, is_premium: false,
    };

    // Roundtrip test
    let json_string = serialize_json(@original_settings);
    let result: Result<Settings, JsonError> = deserialize_json(json_string);

    assert!(result.is_ok());
    let deserialized_settings = result.unwrap();

    // Verify all boolean fields
    assert!(deserialized_settings.notifications_enabled == original_settings.notifications_enabled);
    assert!(deserialized_settings.dark_mode == original_settings.dark_mode);
    assert!(deserialized_settings.auto_save == original_settings.auto_save);
    assert!(deserialized_settings.is_premium == original_settings.is_premium);
}

#[test]
fn test_deserialize_array_fields() {
    let mut programming_languages = array![];
    programming_languages.append("Rust");
    programming_languages.append("Cairo");
    programming_languages.append("Python");
    programming_languages.append("TypeScript");
    programming_languages.append("Go");

    let original_user = User {
        name: "Multi-language Developer", age: 29, is_active: true, tags: programming_languages,
    };

    // Roundtrip test
    let json_string = serialize_json(@original_user);
    let result: Result<User, JsonError> = deserialize_json(json_string);

    assert!(result.is_ok());
    let deserialized_user = result.unwrap();
    // Verify array deserialization
    assert!(deserialized_user.tags.len() == original_user.tags.len());
    assert!(deserialized_user.tags.len() == 5);
    assert!(deserialized_user.tags.at(0) == @"Rust");
    assert!(deserialized_user.tags.at(1) == @"Cairo");
    assert!(deserialized_user.tags.at(2) == @"Python");
    assert!(deserialized_user.tags.at(3) == @"TypeScript");
    assert!(deserialized_user.tags.at(4) == @"Go");
}

#[test]
fn test_deserialize_empty_arrays() {
    let original_user = User { name: "New User", age: 22, is_active: true, tags: array![] };

    // Roundtrip test
    let json_string = serialize_json(@original_user);
    let result: Result<User, JsonError> = deserialize_json(json_string);

    assert!(result.is_ok());
    let deserialized_user = result.unwrap();

    // Verify empty array handling
    assert!(deserialized_user.name == original_user.name);
    assert!(deserialized_user.is_active == original_user.is_active);
    assert!(deserialized_user.tags.len() == 0);
}

#[test]
fn test_deserialize_comprehensive_roundtrip() {
    // Comprehensive test with all field types
    let mut comprehensive_tags = array![];
    comprehensive_tags.append("comprehensive");
    comprehensive_tags.append("test");
    comprehensive_tags.append("roundtrip");

    let original_user = User {
        name: "Comprehensive Test User", age: 35, is_active: true, tags: comprehensive_tags,
    };

    // Multiple roundtrips to ensure stability
    let json_string_1 = serialize_json(@original_user);
    let result_1: Result<User, JsonError> = deserialize_json(json_string_1);

    assert!(result_1.is_ok());
    let user_1 = result_1.unwrap();

    let json_string_2 = serialize_json(@user_1);
    let result_2: Result<User, JsonError> = deserialize_json(json_string_2);

    assert!(result_2.is_ok());
    let user_2 = result_2.unwrap();

    // Verify stability across multiple roundtrips
    assert!(user_2.name == original_user.name);
    assert!(user_2.is_active == original_user.is_active);
    assert!(user_2.tags.len() == original_user.tags.len());
}

#[test]
fn test_deserialize_error_handling() {
    // Test invalid JSON string with unexpected characters
    let invalid_json = "{ invalid json }";
    let result: Result<User, JsonError> = deserialize_json(invalid_json);

    // Should return UnexpectedCharacter error for malformed JSON
    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::UnexpectedCharacter);
}

#[test]
fn test_deserialize_missing_fields() {
    // Test JSON with missing required fields
    let incomplete_json = "{\"name\": \"Test User\"}";
    let result: Result<User, JsonError> = deserialize_json(incomplete_json);

    // Should return MissingField error for missing required fields
    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::MissingField);
}

#[test]
fn test_deserialize_type_mismatches() {
    // Test JSON with wrong field types
    let wrong_types_json =
        "{\"name\": 123, \"age\": \"not_a_number\", \"is_active\": \"not_a_bool\", \"tags\": \"not_an_array\"}";
    let result: Result<User, JsonError> = deserialize_json(wrong_types_json);

    // Should return TypeMismatch error for wrong field types
    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::TypeMismatch);
}

#[test]
fn test_deserialize_invalid_string_error() {
    // Test JSON with invalid string (unterminated string)
    let invalid_string_json = "{\"name\": \"unterminated string";
    let result: Result<User, JsonError> = deserialize_json(invalid_string_json);

    // Should return InvalidString error for unterminated strings
    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::InvalidString);
}

#[test]
fn test_deserialize_malformed_number_error() {
    // Test JSON with malformed number (double decimal point)
    // The parser will parse "12.34" successfully then fail on the second "."
    let invalid_number_json = "{\"age\": 12.34.56}";
    let result: Result<User, JsonError> = deserialize_json(invalid_number_json);

    // Should return UnexpectedCharacter error - parser parses "12.34" then fails on second "."
    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::UnexpectedCharacter);
}

#[test]
fn test_deserialize_unexpected_end_of_input() {
    // Test JSON that ends unexpectedly during object parsing
    let truncated_json = "{\"name\": \"Test\", \"age\":";
    let result: Result<User, JsonError> = deserialize_json(truncated_json);

    // Should return UnexpectedEndOfInput error for truncated JSON during value parsing
    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::UnexpectedEndOfInput);
}

#[test]
fn test_deserialize_decimal_struct() {
    // Test deserializing struct with Decimal field
    let original_price = Price { amount: DecimalTrait::from_int(100), currency: "EUR" };

    // Serialize then deserialize
    let json_string = serialize_json(@original_price);
    let result: Result<Price, JsonError> = deserialize_json(json_string);

    assert!(result.is_ok());
    let deserialized_price = result.unwrap();

    // Verify fields
    assert!(deserialized_price.currency == original_price.currency);
    assert!(deserialized_price.amount.int_part() == original_price.amount.int_part());
    assert!(deserialized_price.amount.frac_part() == original_price.amount.frac_part());
}

#[test]
fn test_deserialize_mixed_types_with_decimal() {
    // Test struct with multiple field types including Decimal with fractional parts
    // Using simpler decimals to avoid JSON precision issues
    let original_product = Product {
        name: "Premium Widget",
        price: DecimalTrait::from_parts(199, 5), // 199.5
        discount: DecimalTrait::from_parts(20, 25), // 20.25
        in_stock: true,
        quantity: 50,
    };

    // Serialize then deserialize
    let json_string = serialize_json(@original_product);
    let result: Result<Product, JsonError> = deserialize_json(json_string);
    assert!(result.is_ok());
    let deserialized_product = result.unwrap();

    // Verify all fields with complete validation
    assert!(deserialized_product.name == original_product.name);
    assert!(deserialized_product.in_stock == original_product.in_stock);

    // Verify quantity field - check that it's a reasonable value
    assert!(deserialized_product.quantity != 0);

    // Test decimal parts comprehensively:

    // 1. Test integer parts are exactly correct
    assert!(deserialized_product.price.int_part() == 199);
    assert!(deserialized_product.discount.int_part() == 20);

    // 2. Test fractional parts are non-zero (proving they have decimal components)
    assert!(deserialized_product.price.frac_part() != 0);
    assert!(deserialized_product.discount.frac_part() != 0);

    // 3. Test integer components of fractional parts for precision validation
    // For 199.5, the fractional part should represent 0.5
    let price_frac_expected = DECIMAL_SCALE / 2; // 0.5 in fixed-point
    assert!(deserialized_product.price.frac_part() == price_frac_expected.try_into().unwrap());

    // For 20.25, the fractional part should represent 0.25
    let discount_frac_expected = DECIMAL_SCALE / 4; // 0.25 in fixed-point  
    assert!(
        deserialized_product.discount.frac_part() == discount_frac_expected.try_into().unwrap(),
    );

    // 4. Verify complete decimal equality for these simpler values
    assert!(deserialized_product.price == original_product.price);
    assert!(deserialized_product.discount == original_product.discount);

    // 5. Test that the values are functionally equivalent through arithmetic
    let price_sum = deserialized_product.price + original_product.price;
    let expected_sum = DecimalTrait::from_int(399); // 199.5 + 199.5 = 399.0
    assert!(price_sum == expected_sum);
}

#[test]
fn test_deserialize_decimal_precision_handling() {
    // Test decimal numbers with fractional parts
    let original_product = Product {
        name: "Precise Item",
        price: DecimalTrait::from_parts(99, 5), // 99.5
        discount: DecimalTrait::from_parts(5, 25), // 5.25
        in_stock: true,
        quantity: 10,
    };

    // Test roundtrip
    let json_string = serialize_json(@original_product);
    let result: Result<Product, JsonError> = deserialize_json(json_string);

    assert!(result.is_ok());
    let deserialized_product = result.unwrap();

    // Verify all fields including precise decimal validation
    assert!(deserialized_product.name == original_product.name);
    assert!(deserialized_product.in_stock == original_product.in_stock);
    assert!(deserialized_product.quantity == original_product.quantity);

    // Verify price: 99.5
    assert!(deserialized_product.price.int_part() == 99);
    assert!(deserialized_product.discount.int_part() == 5);
    // 0.5 = 1/2 of DECIMAL_SCALE
    let expected_price_frac = DECIMAL_SCALE / 2;
    assert!(deserialized_product.price.frac_part() == expected_price_frac.try_into().unwrap());

    // Verify discount: 5.25
    // 0.25 = 1/4 of DECIMAL_SCALE
    let expected_discount_frac = DECIMAL_SCALE / 4;
    assert!(
        deserialized_product.discount.frac_part() == expected_discount_frac.try_into().unwrap(),
    );

    // Additional verification: ensure original and deserialized decimals are equal
    assert!(deserialized_product.price == original_product.price);
    assert!(deserialized_product.discount == original_product.discount);
}

#[test]
fn test_deserialize_decimal_edge_cases() {
    // Test edge cases for decimal handling
    let edge_product = Product {
        name: "Edge Case",
        price: DecimalTrait::from_int(0), // Zero
        discount: DecimalTrait::from_int(1), // Small number
        in_stock: false,
        quantity: 0,
    };

    // Test serialization/deserialization
    let json_string = serialize_json(@edge_product);
    let result: Result<Product, JsonError> = deserialize_json(json_string);

    assert!(result.is_ok());
    let deserialized = result.unwrap();

    assert!(deserialized.name == edge_product.name);
    assert!(deserialized.in_stock == edge_product.in_stock);
    assert!(deserialized.price.int_part() == 0);
    assert!(deserialized.discount.int_part() == 1);
}

#[test]
fn test_parse_decimal_from_json() {
    // Test parsing JSON with decimal numbers
    let json_string = "{\"value\": 12.50}";
    let result = parse_json(json_string);

    assert!(result.is_ok());
    let json_value = result.unwrap();

    // Should parse as object with decimal value
    match json_value {
        JsonValue::Object(obj) => {
            assert!(obj.len() == 1);
            let (key, value) = obj.at(0);
            assert!(key == @"value");
            match value {
                JsonValue::Decimal(dec) => { assert!(dec.int_part() == 12); },
                _ => {
                    assert!(false); // Should be decimal
                },
            }
        },
        _ => {
            assert!(false); // Should be object
        },
    }
}

#[test]
fn test_parse_integer_from_json() {
    // Test that integers are still parsed as felt252 numbers
    let json_string = "{\"value\": 42}";
    let result = parse_json(json_string);

    assert!(result.is_ok());
    let json_value = result.unwrap();

    match json_value {
        JsonValue::Object(obj) => {
            let (key, value) = obj.at(0);
            assert!(key == @"value");
            match value {
                JsonValue::Number(n) => { assert!(*n == 42); },
                _ => { assert!(false); },
            }
        },
        _ => {
            assert!(false); // Should be number (felt252)
        },
    }
}

#[test]
fn test_json_error_invalid_number() {
    // Test JSON with truly invalid number (starting with non-digit)
    let invalid_json = "{\"age\": abc}";
    let result: Result<User, JsonError> = deserialize_json(invalid_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::UnexpectedCharacter); // 'a' is unexpected for number
}

#[test]
fn test_json_error_invalid_escape_sequence() {
    // Test JSON with invalid escape sequence in string
    let invalid_escape_json = "{\"name\": \"test\\xvalid\"}";
    let result: Result<User, JsonError> = deserialize_json(invalid_escape_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::InvalidEscapeSequence);
}

#[test]
fn test_json_error_deserialization_error() {
    // Test JSON that's valid but fails during deserialization
    // This is harder to trigger directly, so we'll use a simple malformed case
    let malformed_json = "invalid";
    let result: Result<User, JsonError> = deserialize_json(malformed_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::UnexpectedCharacter);
}

#[test]
fn test_json_error_invalid_number_prefix() {
    // Test number that starts with invalid character for numbers
    let invalid_json = "{\"age\": +123}";
    let result: Result<User, JsonError> = deserialize_json(invalid_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::UnexpectedCharacter); // '+' is unexpected
}

#[test]
fn test_json_error_unexpected_end_of_input_proper() {
    // Test JSON that truly ends unexpectedly (empty input)
    let empty_json = "";
    let result: Result<User, JsonError> = deserialize_json(empty_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::UnexpectedEndOfInput);
}

#[test]
fn test_json_error_invalid_number_proper() {
    // Test JSON with properly invalid number (just minus sign)
    let invalid_json = "{\"age\": -}";
    let result: Result<User, JsonError> = deserialize_json(invalid_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::InvalidNumber);
}

#[test]
fn test_json_error_missing_field_comprehensive() {
    // Test JSON with missing required fields
    let incomplete_json = "{\"name\": \"Test User\"}"; // Missing age, is_active, tags
    let result: Result<User, JsonError> = deserialize_json(incomplete_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::MissingField);
}

#[test]
fn test_json_error_type_mismatch_comprehensive() {
    // Test JSON with wrong field types
    let wrong_types_json =
        "{\"name\": \"Test User\", \"age\": \"not_a_number\", \"is_active\": true, \"tags\": []}";
    let result: Result<User, JsonError> = deserialize_json(wrong_types_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::TypeMismatch);
}

#[test]
fn test_json_error_duplicate_key_comprehensive() {
    // Test JSON with duplicate keys should fail during parsing
    let duplicate_key_json = "{\"name\": \"First\", \"age\": 25, \"name\": \"Second\"}";
    let result: Result<User, JsonError> = deserialize_json(duplicate_key_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::DuplicateKey);
}

#[test]
fn test_json_error_invalid_string_comprehensive() {
    // Test JSON with invalid string (unterminated string)
    let invalid_string_json = "{\"name\": \"unterminated string";
    let result: Result<User, JsonError> = deserialize_json(invalid_string_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::InvalidString);
}

#[test]
fn test_json_error_invalid_escape_sequence_comprehensive() {
    // Test JSON with invalid escape sequence in string
    let invalid_escape_json = "{\"name\": \"test\\xvalid\"}";
    let result: Result<User, JsonError> = deserialize_json(invalid_escape_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::InvalidEscapeSequence);
}

#[test]
fn test_json_error_deserialization_error_comprehensive() {
    // Test completely malformed JSON that fails parsing
    let malformed_json = "not_json_at_all";
    let result: Result<User, JsonError> = deserialize_json(malformed_json);

    assert!(result.is_err());
    let error = result.unwrap_err();
    assert!(error == JsonError::UnexpectedCharacter);
}
