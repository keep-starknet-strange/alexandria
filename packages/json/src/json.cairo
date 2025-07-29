use alexandria_math::decimal::{Decimal, DecimalTrait};

#[derive(Drop, Clone, PartialEq, Debug)]
pub enum JsonValue {
    Object: Array<(ByteArray, JsonValue)>,
    Array: Array<JsonValue>,
    String: ByteArray,
    Number: felt252,
    Decimal: Decimal,
    Bool: bool,
    Null,
}

#[derive(Drop, Clone, PartialEq, Debug)]
pub enum JsonError {
    UnexpectedCharacter,
    UnexpectedEndOfInput,
    InvalidNumber,
    InvalidString,
    InvalidEscapeSequence,
    DeserializationError,
    MissingField,
    TypeMismatch,
    DuplicateKey,
}

#[derive(Drop)]
pub struct JsonParser {
    input: ByteArray,
    position: usize,
}

#[generate_trait]
pub impl JsonParserImpl of JsonParserTrait {
    fn new(input: ByteArray) -> JsonParser {
        JsonParser { input, position: 0 }
    }

    fn parse(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        self.skip_whitespace();
        self.parse_value()
    }

    fn parse_value(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        self.skip_whitespace();

        if self.is_at_end() {
            return Result::Err(JsonError::UnexpectedEndOfInput);
        }

        let current_char = self.current_char()?;

        if current_char == '{' {
            self.parse_object()
        } else if current_char == '[' {
            self.parse_array()
        } else if current_char == '"' {
            let s = self.parse_string()?;
            Result::Ok(JsonValue::String(s))
        } else if current_char == 't' || current_char == 'f' {
            self.parse_bool()
        } else if current_char == 'n' {
            self.parse_null()
        } else if current_char == '-' || (current_char >= '0' && current_char <= '9') {
            self.parse_number()
        } else {
            Result::Err(JsonError::UnexpectedCharacter)
        }
    }

    fn parse_object(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        self.consume_char('{')?;
        self.skip_whitespace();

        let mut object = array![];

        if self.check_char('}') {
            self.advance();
            return Result::Ok(JsonValue::Object(object));
        }

        loop {
            self.skip_whitespace();

            let key = self.parse_string()?;
            self.skip_whitespace();
            self.consume_char(':')?;
            self.skip_whitespace();
            let value = self.parse_value()?;

            // Check for duplicate keys
            let mut i = 0;
            while i < object.len() {
                let (existing_key, _) = object.at(i);
                if existing_key == @key {
                    return Result::Err(JsonError::DuplicateKey);
                }
                i += 1;
            }

            object.append((key, value));

            self.skip_whitespace();
            if self.check_char('}') {
                self.advance();
                break;
            }

            self.consume_char(',')?;
        }

        Result::Ok(JsonValue::Object(object))
    }

    fn parse_array(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        self.consume_char('[')?;
        self.skip_whitespace();

        let mut arr = array![];

        if self.check_char(']') {
            self.advance();
            return Result::Ok(JsonValue::Array(arr));
        }

        loop {
            self.skip_whitespace();
            let value = self.parse_value()?;
            arr.append(value);

            self.skip_whitespace();
            if self.check_char(']') {
                self.advance();
                break;
            }

            self.consume_char(',')?;
        }

        Result::Ok(JsonValue::Array(arr))
    }

    fn parse_string(ref self: JsonParser) -> Result<ByteArray, JsonError> {
        self.consume_char('"')?;

        let mut result: ByteArray = Default::default();

        while !self.is_at_end() && !self.check_char('"') {
            let ch = self.current_char()?;

            if ch == '\\' {
                self.advance();
                if self.is_at_end() {
                    return Result::Err(JsonError::InvalidEscapeSequence);
                }

                let escaped = self.current_char()?;
                if escaped == '"' {
                    result.append_byte('"');
                } else if escaped == '\\' {
                    result.append_byte('\\');
                } else if escaped == 'n' {
                    result.append_byte('\n');
                } else if escaped == 't' {
                    result.append_byte('\t');
                } else {
                    return Result::Err(JsonError::InvalidEscapeSequence);
                }
            } else {
                result.append_byte(ch);
            }

            self.advance();
        }

        if self.is_at_end() {
            return Result::Err(JsonError::InvalidString);
        }

        self.consume_char('"')?;
        Result::Ok(result)
    }

    fn parse_number(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        let mut is_negative = false;

        if self.check_char('-') {
            is_negative = true;
            self.advance();
        }

        if self.is_at_end() || !self.is_digit(self.current_char()?) {
            return Result::Err(JsonError::InvalidNumber);
        }

        // Parse integer part
        let mut int_part: u64 = 0;
        while !self.is_at_end() && self.is_digit(self.current_char()?) {
            let digit = (self.current_char()? - '0').into();
            int_part = int_part * 10 + digit;
            self.advance();
        }

        // Check for decimal point
        if !self.is_at_end() && self.check_char('.') {
            self.advance();

            // Parse fractional part
            let mut frac_part: u64 = 0;
            let mut frac_digits = 0;

            while !self.is_at_end() && self.is_digit(self.current_char()?) {
                if frac_digits == 6 {
                    break;
                }
                let digit = (self.current_char()? - '0').into();
                frac_part = frac_part * 10 + digit;
                frac_digits += 1;
                self.advance();
            }

            // Skip remaining fractional digits if more than 6
            while !self.is_at_end() && self.is_digit(self.current_char()?) {
                self.advance();
            }

            // Scale fractional part to 6 digits
            let scale_factor = match frac_digits {
                0 => 1000000,
                1 => 100000,
                2 => 10000,
                3 => 1000,
                4 => 100,
                5 => 10,
                6 => 1,
                _ => 1,
            };
            frac_part = frac_part * scale_factor;

            // Convert to fixed-point fractional representation
            let decimal_scale: u128 = 0x10000000000000000; // 2^64
            let frac_fixed = (frac_part.into() * decimal_scale) / 1000000;

            let decimal = DecimalTrait::from_raw_parts(
                int_part, frac_fixed.try_into().unwrap_or(0),
            );

            Result::Ok(JsonValue::Decimal(decimal))
        } else {
            // Integer number - return as felt252 for compatibility
            let mut result: felt252 = int_part.into();
            if is_negative {
                result = -result;
            }
            Result::Ok(JsonValue::Number(result))
        }
    }

    fn parse_bool(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        if self.check_string("true") {
            self.advance_by(4);
            Result::Ok(JsonValue::Bool(true))
        } else if self.check_string("false") {
            self.advance_by(5);
            Result::Ok(JsonValue::Bool(false))
        } else {
            Result::Err(JsonError::UnexpectedCharacter)
        }
    }

    fn parse_null(ref self: JsonParser) -> Result<JsonValue, JsonError> {
        if self.check_string("null") {
            self.advance_by(4);
            Result::Ok(JsonValue::Null)
        } else {
            Result::Err(JsonError::UnexpectedCharacter)
        }
    }

    fn skip_whitespace(ref self: JsonParser) {
        while !self.is_at_end() {
            let ch = self.current_char();
            if ch.is_ok() {
                let c = ch.unwrap();
                if c == ' ' || c == '\t' || c == '\n' || c == '\r' {
                    self.advance();
                } else {
                    break;
                }
            } else {
                break;
            }
        }
    }

    fn current_char(ref self: JsonParser) -> Result<u8, JsonError> {
        if self.is_at_end() {
            Result::Err(JsonError::UnexpectedEndOfInput)
        } else {
            match self.input.at(self.position) {
                Option::Some(ch) => Result::Ok(ch),
                Option::None => Result::Err(JsonError::UnexpectedEndOfInput),
            }
        }
    }

    fn check_char(ref self: JsonParser, expected: u8) -> bool {
        if self.is_at_end() {
            false
        } else {
            match self.input.at(self.position) {
                Option::Some(ch) => ch == expected,
                Option::None => false,
            }
        }
    }

    fn check_string(ref self: JsonParser, expected: ByteArray) -> bool {
        if self.position + expected.len() > self.input.len() {
            return false;
        }

        let mut i = 0;
        while i < expected.len() {
            let input_char = match self.input.at(self.position + i) {
                Option::Some(ch) => ch,
                Option::None => { return false; },
            };
            let expected_char = match expected.at(i) {
                Option::Some(ch) => ch,
                Option::None => { return false; },
            };
            if input_char != expected_char {
                return false;
            }
            i += 1;
        }
        true
    }

    fn consume_char(ref self: JsonParser, expected: u8) -> Result<(), JsonError> {
        if self.check_char(expected) {
            self.advance();
            Result::Ok(())
        } else {
            Result::Err(JsonError::UnexpectedCharacter)
        }
    }

    fn advance(ref self: JsonParser) {
        if !self.is_at_end() {
            self.position += 1;
        }
    }

    fn advance_by(ref self: JsonParser, count: usize) {
        let mut i = 0;
        while i < count && !self.is_at_end() {
            self.advance();
            i += 1;
        };
    }

    fn is_at_end(ref self: JsonParser) -> bool {
        self.position >= self.input.len()
    }

    fn is_digit(self: @JsonParser, ch: u8) -> bool {
        ch >= '0' && ch <= '9'
    }
}

pub fn parse_json(input: ByteArray) -> Result<JsonValue, JsonError> {
    let mut parser = JsonParserImpl::new(input);
    parser.parse()
}

pub trait JsonDeserialize<T> {
    fn from_json(value: JsonValue) -> Result<T, JsonError>;
}

pub trait JsonSerialize<T> {
    fn to_json(self: @T) -> JsonValue;
}

#[generate_trait]
pub impl JsonValueHelperImpl of JsonValueHelper {
    fn get_object_field(self: @JsonValue, key: ByteArray) -> Result<JsonValue, JsonError> {
        match self {
            JsonValue::Object(obj) => {
                let mut i = 0;
                while i < obj.len() {
                    let (field_key, field_value) = obj.at(i);
                    if field_key == @key {
                        return Result::Ok(field_value.clone());
                    }
                    i += 1;
                }
                Result::Err(JsonError::MissingField)
            },
            _ => Result::Err(JsonError::TypeMismatch),
        }
    }

    fn as_string(self: @JsonValue) -> Result<ByteArray, JsonError> {
        match self {
            JsonValue::String(s) => Result::Ok(s.clone()),
            _ => Result::Err(JsonError::TypeMismatch),
        }
    }

    fn as_number(self: @JsonValue) -> Result<felt252, JsonError> {
        match self {
            JsonValue::Number(n) => Result::Ok(*n),
            _ => Result::Err(JsonError::TypeMismatch),
        }
    }

    fn as_u256(self: @JsonValue) -> Result<u256, JsonError> {
        match self {
            JsonValue::Number(n) => Result::Ok((*n).into()),
            _ => Result::Err(JsonError::TypeMismatch),
        }
    }

    fn as_decimal(self: @JsonValue) -> Result<Decimal, JsonError> {
        match self {
            JsonValue::Decimal(d) => Result::Ok(*d),
            JsonValue::Number(n) => Result::Ok(DecimalTrait::from_felt(*n)),
            _ => Result::Err(JsonError::TypeMismatch),
        }
    }

    fn as_bool(self: @JsonValue) -> Result<bool, JsonError> {
        match self {
            JsonValue::Bool(b) => Result::Ok(*b),
            _ => Result::Err(JsonError::TypeMismatch),
        }
    }

    fn as_array(self: @JsonValue) -> Result<Array<JsonValue>, JsonError> {
        match self {
            JsonValue::Array(arr) => Result::Ok(arr.clone()),
            _ => Result::Err(JsonError::TypeMismatch),
        }
    }

    fn as_object(self: @JsonValue) -> Result<Array<(ByteArray, JsonValue)>, JsonError> {
        match self {
            JsonValue::Object(obj) => Result::Ok(obj.clone()),
            _ => Result::Err(JsonError::TypeMismatch),
        }
    }

    fn is_null(self: @JsonValue) -> bool {
        match self {
            JsonValue::Null => true,
            _ => false,
        }
    }

    fn to_json_string(self: @JsonValue) -> ByteArray {
        match self {
            JsonValue::String(s) => {
                let mut result: ByteArray = "\"";
                result.append(@escape_json_string(s));
                result.append(@"\"");
                result
            },
            JsonValue::Number(n) => { convert_felt_to_string(*n) },
            JsonValue::Decimal(d) => { d.to_string() },
            JsonValue::Bool(b) => { if *b {
                "true"
            } else {
                "false"
            } },
            JsonValue::Null => { "null" },
            JsonValue::Array(arr) => {
                let mut result: ByteArray = "[";
                let mut i = 0;
                while i < arr.len() {
                    if i > 0 {
                        result.append(@", ");
                    }
                    result.append(@arr.at(i).to_json_string());
                    i += 1;
                }
                result.append(@"]");
                result
            },
            JsonValue::Object(obj) => {
                let mut result: ByteArray = "{";
                let mut i = 0;
                while i < obj.len() {
                    if i > 0 {
                        result.append(@", ");
                    }
                    let (key, value) = obj.at(i);
                    result.append(@"\"");
                    result.append(@escape_json_string(key));
                    result.append(@"\": ");
                    result.append(@value.to_json_string());
                    i += 1;
                }
                result.append(@"}");
                result
            },
        }
    }
}

fn escape_json_string(s: @ByteArray) -> ByteArray {
    let mut result: ByteArray = "";
    let mut i = 0;
    while i < s.len() {
        let ch = s.at(i).unwrap();
        if ch == '"' {
            result.append(@"\\\"");
        } else if ch == '\\' {
            result.append(@"\\\\");
        } else if ch == '\n' {
            result.append(@"\\n");
        } else if ch == '\t' {
            result.append(@"\\t");
        } else {
            result.append_byte(ch);
        }
        i += 1;
    }
    result
}

/// Convert a felt252 number to its string representation
/// Handles any felt252 value by converting to u256 and processing digits
fn convert_felt_to_string(n: felt252) -> ByteArray {
    // Handle zero specially
    if n == 0 {
        return "0";
    }

    // Convert felt252 to u256 for processing
    let value: u256 = n.into();

    // Convert u256 to string by extracting digits
    let mut digits: Array<u8> = array![];
    let mut temp_value = value;

    // Extract digits in reverse order
    while temp_value > 0 {
        let digit = (temp_value % 10).try_into().unwrap_or(0);
        digits.append(digit + 48); // Convert to ASCII (0-9 are 48-57)
        temp_value = temp_value / 10;
    }

    // Build result string by reversing the digits
    let mut result: ByteArray = "";
    let mut i = digits.len();
    while i > 0 {
        i -= 1;
        result.append_byte(*digits.at(i));
    }

    result
}

pub fn deserialize_json<T, +JsonDeserialize<T>>(input: ByteArray) -> Result<T, JsonError> {
    let json_value = parse_json(input)?;
    JsonDeserialize::from_json(json_value)
}

pub fn serialize_json<T, +JsonSerialize<T>>(value: @T) -> ByteArray {
    let json_value = JsonSerialize::to_json(value);
    json_value.to_json_string()
}

