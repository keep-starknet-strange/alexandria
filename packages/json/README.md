# JSON

## [JSON Parser](./src/json.cairo)

The JSON parser provides comprehensive functionality for parsing JSON strings into structured data and serializing Cairo data structures back to JSON format. The parser supports all standard JSON types including objects, arrays, strings, numbers, booleans, null values, and decimal numbers for precise financial calculations.

The JSON parser includes helper traits for extracting specific types from JSON values, with proper error handling for type mismatches and malformed data. It integrates seamlessly with the Alexandria math package's decimal system for handling precise decimal numbers commonly found in JSON APIs.

### Key Features:

- **Complete JSON support**: Handles all standard JSON types with proper error handling
- **Derive macros**: Automatic serialization/deserialization with `#[derive(JsonSerialize, JsonDeserialize)]`
- **Decimal integration**: Seamless support for precise decimal arithmetic using Alexandria's math package
- **Type safety**: Strong typing with comprehensive error types for different failure scenarios
- **Roundtrip accuracy**: Maintains data integrity through serialize/deserialize cycles

### Example Usage:

```cairo
use alexandria_math::decimal::DecimalTrait;
use alexandria_json::json::{serialize_json, deserialize_json};

// JSON serialization with derive macros
#[derive(JsonSerialize, JsonDeserialize)]
struct Invoice {
    amount: Decimal,
    tax: Decimal,
    total: Decimal,
}

// Create decimals using math package
let price = DecimalTrait::from_parts(99, 95);  // 99.95
let tax_rate = DecimalTrait::from_parts(0, 825);  // 0.825 (8.25%)

let invoice = Invoice {
    amount: price,
    tax: price * tax_rate,
    total: price + (price * tax_rate),
};

// Serialize to JSON
let json_string = serialize_json(@invoice);

// Deserialize back from JSON
let result: Result<Invoice, JsonError> = deserialize_json(json_string);
```

The parser package provides a robust foundation for JSON processing in Cairo applications, with particular emphasis on integration with Alexandria's mathematical types for precise calculations.