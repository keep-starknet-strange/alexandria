use crate::parse::{parse_struct_info, FieldInfo, StructInfo};
use cairo_lang_macro::{derive_macro, ProcMacroResult, TokenStream};

fn generate_field_deserialization(field: &FieldInfo) -> String {
    let field_name = &field.name;
    let field_type = &field.field_type;

    match normalize_type(field_type).as_str() {
        "felt252" => {
            format!("let {field_name} = alexandria_json::json::JsonValueHelper::as_number(@alexandria_json::json::JsonValueHelper::get_object_field(@value, \"{field_name}\")?)?;")
        }
        "bool" => {
            format!("let {field_name} = alexandria_json::json::JsonValueHelper::as_bool(@alexandria_json::json::JsonValueHelper::get_object_field(@value, \"{field_name}\")?)?;")
        }
        "Array<ByteArray>" => {
            format!(
                "let {field_name}_json = alexandria_json::json::JsonValueHelper::get_object_field(@value, \"{field_name}\")?;\n        let {field_name}_array = alexandria_json::json::JsonValueHelper::as_array(@{field_name}_json)?;\n        let mut {field_name} = array![];\n        let mut {field_name}_i = 0;\n        while {field_name}_i < {field_name}_array.len() {{\n            let {field_name}_item = alexandria_json::json::JsonValueHelper::as_string({field_name}_array.at({field_name}_i))?;\n            {field_name}.append({field_name}_item);\n            {field_name}_i += 1;\n        }};"
            )
        }
        "u256" => {
            format!("let {field_name} = alexandria_json::json::JsonValueHelper::as_u256(@alexandria_json::json::JsonValueHelper::get_object_field(@value, \"{field_name}\")?)?;")
        }
        "Decimal" => {
            format!("let {field_name} = alexandria_json::json::JsonValueHelper::as_decimal(@alexandria_json::json::JsonValueHelper::get_object_field(@value, \"{field_name}\")?)?;")
        }
        _ => {
            // Default to ByteArray/string
            format!("let {field_name} = alexandria_json::json::JsonValueHelper::as_string(@alexandria_json::json::JsonValueHelper::get_object_field(@value, \"{field_name}\")?)?;")
        }
    }
}

fn normalize_type(type_str: &str) -> String {
    // Clean up and normalize Cairo type strings
    let clean = type_str
        .trim()
        .replace(" ", "")
        .replace("core::", "")
        .replace("byte_array::", "")
        .replace("array::", "");

    // Handle common patterns
    if clean.contains("Array<ByteArray>") || clean.contains("Array<byte_array::ByteArray>") {
        "Array<ByteArray>".to_string()
    } else if clean == "felt252" {
        "felt252".to_string()
    } else if clean == "bool" {
        "bool".to_string()
    } else if clean == "u256" {
        "u256".to_string()
    } else if clean == "Decimal"
        || clean.contains("decimal::Decimal")
        || clean.contains("parser::decimal::Decimal")
    {
        "Decimal".to_string()
    } else if clean == "ByteArray" || clean.is_empty() {
        "ByteArray".to_string()
    } else {
        // Default to ByteArray for unknown types
        "ByteArray".to_string()
    }
}

fn generate_field_serialization(field: &FieldInfo) -> String {
    let field_name = &field.name;
    let field_type = &field.field_type;
    let normalized = normalize_type(field_type);

    // For debugging - generate a comment showing what type was detected
    let debug_comment =
        format!("// Field: {field_name}, Type: {field_type}, Normalized: {normalized}");

    let serialization_code = match normalized.as_str() {
        "felt252" => {
            format!(
                "fields.append((\"{field_name}\", alexandria_json::json::JsonValue::Number(*self.{field_name})));"
            )
        }
        "bool" => {
            format!(
                "fields.append((\"{field_name}\", alexandria_json::json::JsonValue::Bool(*self.{field_name})));"
            )
        }
        "Array<ByteArray>" => {
            format!(
                "let mut {field_name}_json = array![];\n        let mut {field_name}_i = 0;\n        while {field_name}_i < self.{field_name}.len() {{\n            {field_name}_json.append(alexandria_json::json::JsonValue::String(self.{field_name}.at({field_name}_i).clone()));\n            {field_name}_i += 1;\n        }};\n        fields.append((\"{field_name}\", alexandria_json::json::JsonValue::Array({field_name}_json)));"
            )
        }
        "u256" => {
            format!("fields.append((\"{field_name}\", alexandria_json::json::JsonValue::Number((*self.{field_name}).try_into().unwrap())));")
        }
        "Decimal" => {
            format!(
                "fields.append((\"{field_name}\", alexandria_json::json::JsonValue::Decimal(*self.{field_name})));"
            )
        }
        _ => {
            // Default to ByteArray/string
            format!("fields.append((\"{field_name}\", alexandria_json::json::JsonValue::String(self.{field_name}.clone())));")
        }
    };

    format!("{debug_comment}\n        {serialization_code}")
}

fn generate_json_deserialize_impl(s: &StructInfo) -> String {
    // Generate actual JSON field extraction using intelligent type detection
    let field_extractions = s
        .fields
        .iter()
        .map(generate_field_deserialization)
        .collect::<Vec<_>>()
        .join("\n        ");

    // Generate struct construction
    let struct_fields = s
        .fields
        .iter()
        .map(|field| field.name.clone())
        .collect::<Vec<_>>()
        .join(", ");

    // Generate the implementation following the exact working pattern from existing implementations
    format!(
        "
pub impl {}JsonDeserializeImpl of alexandria_json::json::JsonDeserialize<{}> {{
    fn from_json(value: alexandria_json::json::JsonValue) -> Result<{}, alexandria_json::json::JsonError> {{
        {}
        
        Result::Ok({} {{ {} }})
    }}
}}",
        s.name,
        s.name,
        s.name,
        field_extractions,
        s.name,
        struct_fields
    )
}

/// Automatically implements the `alexandria_json::json::JsonDeserialize` trait.
///
/// This derive macro generates a `JsonDeserialize` implementation that extracts
/// struct fields from a JSON object using field names as JSON keys.
///
/// Type detection is based on actual Cairo type information from the AST:
/// - `ByteArray` fields → `as_string()`
/// - `felt252` fields → `as_number()`
/// - `bool` fields → `as_bool()`
/// - `Decimal` fields → `as_decimal()` for fixed-point numbers
/// - `Array<ByteArray>` fields → `as_array()` with string element conversion
/// - Other types → defaults to `as_string()`
///
/// ```
/// #[derive(JsonDeserialize, Drop, Clone, PartialEq, Debug)]
/// struct User {
///     id: felt252,
///     name: ByteArray,
///     price: Decimal,
///     is_active: bool,
///     tags: Array<ByteArray>,
/// }
///
/// // Generated implementation allows:
/// let json_str = "{\"id\": 123, \"name\": \"Alice\", \"price\": 19.99, \"is_active\": true, \"tags\": [\"rust\", \"cairo\"]}";
/// let user: Result<User, JsonError> = deserialize_json(json_str);
/// ```
#[derive_macro]
pub fn json_deserialize(token_stream: TokenStream) -> ProcMacroResult {
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_json_deserialize_impl(&s)))
}

fn generate_json_serialize_impl(s: &StructInfo) -> String {
    // Generate field serialization code using intelligent type detection
    let field_serializations = s
        .fields
        .iter()
        .map(generate_field_serialization)
        .collect::<Vec<_>>()
        .join("\n        ");

    // Generate the implementation
    format!(
        "
pub impl {}JsonSerializeImpl of alexandria_json::json::JsonSerialize<{}> {{
    fn to_json(self: @{}) -> alexandria_json::json::JsonValue {{
        let mut fields = array![];
        {}
        alexandria_json::json::JsonValue::Object(fields)
    }}
}}",
        s.name, s.name, s.name, field_serializations
    )
}

/// Automatically implements the `alexandria_json::json::JsonSerialize` trait.
///
/// This derive macro generates a `JsonSerialize` implementation that converts
/// struct fields to JSON object key-value pairs using field names as JSON keys.
///
/// Type detection is based on actual Cairo type information from the AST:
/// - `ByteArray` fields → `JsonValue::String`
/// - `felt252` fields → `JsonValue::Number`
/// - `bool` fields → `JsonValue::Bool`
/// - `Decimal` fields → `JsonValue::Decimal` for fixed-point numbers
/// - `Array<ByteArray>` fields → `JsonValue::Array` with string elements
/// - Other types → defaults to `JsonValue::String`
///
/// ```
/// #[derive(JsonSerialize, Drop, Clone, PartialEq, Debug)]
/// struct User {
///     id: felt252,
///     name: ByteArray,
///     price: Decimal,
///     is_active: bool,
///     tags: Array<ByteArray>,
/// }
///
/// // Generated implementation allows:
/// let user = User { id: 123, name: "Alice", price: DecimalTrait::from_int(99), is_active: true, tags: array!["rust", "cairo"] };
/// let json_str = serialize_json(@user);
/// // Results in: {"id": 123, "name": "Alice", "price": 99.000000, "is_active": true, "tags": ["rust", "cairo"]}
/// ```
#[derive_macro]
pub fn json_serialize(token_stream: TokenStream) -> ProcMacroResult {
    let s = parse_struct_info(token_stream);

    ProcMacroResult::new(TokenStream::new(generate_json_serialize_impl(&s)))
}
