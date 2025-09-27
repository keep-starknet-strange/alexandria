use alexandria_json::json::serialize_json;
use alexandria_math::decimal::{Decimal, DecimalTrait};

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

// Test struct with multiple numeric fields
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
fn test_serialize_mixed_types() {
    let mut user_tags = array![];
    user_tags.append("developer");
    user_tags.append("blockchain");
    user_tags.append("cairo");

    let user = User { name: "Alice Johnson", age: 28, is_active: true, tags: user_tags };

    let json_string = serialize_json(@user);

    // Verify JSON contains all expected fields
    assert!(json_string.len() > 50);

    // JSON should be properly formatted (basic validation)
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"name\": \"Alice Johnson\", \"age\": 28, \"is_active\": true, \"tags\": [\"developer\", \"blockchain\", \"cairo\"]}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_string_fields() {
    let profile = Profile {
        id: "user_12345",
        name: "Bob Smith",
        email: "bob@example.com",
        description: "Senior Blockchain Developer with 5+ years experience",
        location: "San Francisco, CA",
    };

    let json_string = serialize_json(@profile);

    // Verify all string fields are serialized
    assert!(json_string.len() > 100);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"id\": \"user_12345\", \"name\": \"Bob Smith\", \"email\": \"bob@example.com\", \"description\": \"Senior Blockchain Developer with 5+ years experience\", \"location\": \"San Francisco, CA\"}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_numeric_fields() {
    let account = Account {
        user_id: 10, balance: 1000000, credit_score: 100, transaction_count: 42,
    };

    let json_string = serialize_json(@account);

    // Verify numeric serialization
    assert!(json_string.len() > 30);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"user_id\": 10, \"balance\": 1000000, \"credit_score\": 100, \"transaction_count\": 42}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_boolean_fields() {
    let settings = Settings {
        notifications_enabled: true, dark_mode: false, auto_save: true, is_premium: false,
    };

    let json_string = serialize_json(@settings);

    // Verify boolean serialization
    assert!(json_string.len() > 50);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"notifications_enabled\": true, \"dark_mode\": false, \"auto_save\": true, \"is_premium\": false}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_array_fields() {
    let mut skills = array![];
    skills.append("Rust");
    skills.append("Cairo");
    skills.append("Solidity");
    skills.append("JavaScript");

    let user = User { name: "Array Test User", age: 30, is_active: true, tags: skills };

    let json_string = serialize_json(@user);

    // Verify array serialization
    assert!(json_string.len() > 60);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"name\": \"Array Test User\", \"age\": 30, \"is_active\": true, \"tags\": [\"Rust\", \"Cairo\", \"Solidity\", \"JavaScript\"]}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_empty_arrays() {
    let user = User { name: "Empty Array User", age: 25, is_active: false, tags: array![] };

    let json_string = serialize_json(@user);

    // Should still produce valid JSON with empty array
    assert!(json_string.len() > 20);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"name\": \"Empty Array User\", \"age\": 25, \"is_active\": false, \"tags\": []}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_special_characters() {
    let profile = Profile {
        id: "user_special",
        name: "Test User",
        email: "test@domain.co.uk",
        description: "User with special chars: !@#$%^&*()",
        location: "New York, NY 10001",
    };

    let json_string = serialize_json(@profile);

    // Should handle special characters in strings
    assert!(json_string.len() > 80);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"id\": \"user_special\", \"name\": \"Test User\", \"email\": \"test@domain.co.uk\", \"description\": \"User with special chars: !@#$%^&*()\", \"location\": \"New York, NY 10001\"}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_large_numbers() {
    let account = Account {
        user_id: 999999999,
        balance: 18446744073709551615, // Large number
        credit_score: 100,
        transaction_count: 5000,
    };

    let json_string = serialize_json(@account);

    // Should handle large numbers
    assert!(json_string.len() > 40);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"user_id\": 999999999, \"balance\": 18446744073709551615, \"credit_score\": 100, \"transaction_count\": 5000}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_decimal_struct() {
    // Test serializing struct with Decimal field
    let price = Price { amount: DecimalTrait::from_int(25), currency: "USD" };

    let json_string = serialize_json(@price);

    // Should produce valid JSON
    assert!(json_string.len() > 10);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json = "{\"amount\": 25.0, \"currency\": \"USD\"}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_mixed_types_with_decimal() {
    // Test struct with multiple field types including Decimal
    let product = Product {
        name: "Premium Widget",
        price: DecimalTrait::from_int(199),
        discount: DecimalTrait::from_int(20),
        in_stock: true,
        quantity: 123,
    };

    // Serialize
    let json_string = serialize_json(@product);
    assert!(json_string.len() > 50);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"name\": \"Premium Widget\", \"price\": 199.0, \"discount\": 20.0, \"in_stock\": true, \"quantity\": 123}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_decimal_edge_cases() {
    // Test edge cases for decimal serialization
    let edge_product = Product {
        name: "Edge Case",
        price: DecimalTrait::from_int(0), // Zero
        discount: DecimalTrait::from_int(1), // Small number
        in_stock: false,
        quantity: 0,
    };

    // Test serialization
    let json_string = serialize_json(@edge_product);
    assert!(json_string.len() > 30);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected values
    let expected_json =
        "{\"name\": \"Edge Case\", \"price\": 0.0, \"discount\": 1.0, \"in_stock\": false, \"quantity\": 0}";
    assert!(json_string == expected_json);
}

#[test]
fn test_serialize_decimal_precision() {
    // Test decimal numbers with fractional parts
    let precision_product = Product {
        name: "Precise Item",
        price: DecimalTrait::from_parts(99, 5), // 99.5
        discount: DecimalTrait::from_parts(5, 25), // 5.25
        in_stock: true,
        quantity: 10,
    };

    // Test serialization
    let json_string = serialize_json(@precision_product);
    assert!(json_string.len() > 40);
    assert!(json_string.at(0).unwrap() == '{');
    assert!(json_string.at(json_string.len() - 1).unwrap() == '}');

    // Test the full string contains expected decimal values
    let expected_json =
        "{\"name\": \"Precise Item\", \"price\": 99.5, \"discount\": 5.25, \"in_stock\": true, \"quantity\": 10}";
    assert!(json_string == expected_json);
}
