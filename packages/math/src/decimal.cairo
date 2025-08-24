use alexandria_math::const_pow;

/// Fixed-point decimal number using separate 64-bit fields
/// int_part: integer portion (0 to 2^64-1)
/// frac_part: fractional portion in raw DECIMAL_SCALE units (0 to 10^18-1)
/// is_negative: sign of the decimal number
#[derive(Drop, Copy, PartialEq, Debug)]
pub struct Decimal {
    pub int_part: u64, // Integer portion
    pub frac_part: u64, // Fractional portion (raw units)
    pub is_negative: bool // Sign of the number
}

pub const DECIMAL_SCALE: u128 = 1000000000000000000; // 10^18 for better decimal precision

#[generate_trait]
pub impl DecimalImpl of DecimalTrait {
    /// Create a decimal from an integer part
    fn from_int(int_part: u64) -> Decimal {
        Decimal { int_part, frac_part: 0, is_negative: false }
    }

    /// Create a decimal from integer and decimal parts (user-friendly)
    /// int_part: integer portion (e.g., 3 for 3.35)
    /// decimal_part: decimal portion as integer (e.g., 35 for 0.35)
    /// Example: from_parts(3, 35) creates 3.35, from_parts(56, 678) creates 56.678
    fn from_parts(int_part: u64, decimal_part: u64) -> Decimal {
        // Determine the number of decimal digits to calculate the proper divisor
        let mut temp = decimal_part;
        let mut divisor = 1_u64;
        while temp > 0 {
            temp = temp / 10;
            divisor = divisor * 10;
        }

        // Handle zero decimal part
        if decimal_part == 0 {
            divisor = 1;
        }

        let frac_part = ((decimal_part.into() * DECIMAL_SCALE) / divisor.into())
            .try_into()
            .unwrap_or(0);
        Decimal { int_part, frac_part, is_negative: false }
    }

    /// Create a decimal from integer and raw fractional parts (internal use)
    /// frac_part should be in range [0, 10^18) - raw DECIMAL_SCALE units
    fn from_raw_parts(int_part: u64, frac_part: u64) -> Decimal {
        Decimal { int_part, frac_part, is_negative: false }
    }

    /// Create a signed decimal from integer and raw fractional parts (internal use)
    /// frac_part should be in range [0, 10^18) - raw DECIMAL_SCALE units
    fn from_raw_parts_signed(int_part: u64, frac_part: u64, is_negative: bool) -> Decimal {
        Decimal { int_part, frac_part, is_negative }
    }

    /// Create a decimal from a felt252 (treating it as integer)
    /// Note: This method treats all felt252 values as positive
    /// For negative values, use from_felt_signed or other constructors
    fn from_felt(value: felt252) -> Decimal {
        let int_part: u64 = value.try_into().unwrap_or(0);
        Self::from_int(int_part)
    }

    /// Create a signed decimal from a felt252
    fn from_felt_signed(value: felt252, is_negative: bool) -> Decimal {
        let int_part: u64 = value.try_into().unwrap_or(0);
        Decimal { int_part, frac_part: 0, is_negative }
    }

    /// Create a signed decimal from integer and decimal parts (user-friendly)
    /// int_part: integer portion (e.g., 3 for 3.35)
    /// decimal_part: decimal portion as integer (e.g., 35 for 0.35)
    /// is_negative: sign of the number
    /// Example: from_parts_signed(3, 35, true) creates -3.35
    fn from_parts_signed(int_part: u64, decimal_part: u64, is_negative: bool) -> Decimal {
        // Determine the number of decimal digits to calculate the proper divisor
        let mut temp = decimal_part;
        let mut divisor = 1_u64;
        while temp > 0 {
            temp = temp / 10;
            divisor = divisor * 10;
        }

        // Handle zero decimal part
        if decimal_part == 0 {
            divisor = 1;
        }

        let frac_part = ((decimal_part.into() * DECIMAL_SCALE) / divisor.into())
            .try_into()
            .unwrap_or(0);
        Decimal { int_part, frac_part, is_negative }
    }

    /// Get the integer part
    fn int_part(self: @Decimal) -> u64 {
        *self.int_part
    }

    /// Get the fractional part
    fn frac_part(self: @Decimal) -> u64 {
        *self.frac_part
    }

    /// Get the sign (true if negative)
    fn is_negative(self: @Decimal) -> bool {
        *self.is_negative
    }

    /// Convert to felt252 (truncates fractional part)
    fn to_felt(self: @Decimal) -> felt252 {
        let value: felt252 = self.int_part().into();
        if *self.is_negative {
            -value
        } else {
            value
        }
    }

    /// Add two decimals
    fn add(self: @Decimal, other: @Decimal) -> Decimal {
        // Convert to total values for comparison
        let self_total: u128 = (*self.int_part).into() * DECIMAL_SCALE + (*self.frac_part).into();
        let other_total: u128 = (*other.int_part).into() * DECIMAL_SCALE
            + (*other.frac_part).into();

        // Handle sign cases
        if *self.is_negative == *other.is_negative {
            // Same signs: add magnitudes, keep sign
            let result_total = self_total + other_total;
            let new_int_part = (result_total / DECIMAL_SCALE).try_into().unwrap_or(0);
            let new_frac_part = (result_total % DECIMAL_SCALE).try_into().unwrap_or(0);
            Decimal {
                int_part: new_int_part, frac_part: new_frac_part, is_negative: *self.is_negative,
            }
        } else {
            // Different signs: subtract smaller from larger
            if self_total >= other_total {
                let result_total = self_total - other_total;
                let new_int_part = (result_total / DECIMAL_SCALE).try_into().unwrap_or(0);
                let new_frac_part = (result_total % DECIMAL_SCALE).try_into().unwrap_or(0);
                // If result is zero, always make it positive
                let is_negative = if new_int_part == 0 && new_frac_part == 0 {
                    false
                } else {
                    *self.is_negative
                };
                Decimal { int_part: new_int_part, frac_part: new_frac_part, is_negative }
            } else {
                let result_total = other_total - self_total;
                let new_int_part = (result_total / DECIMAL_SCALE).try_into().unwrap_or(0);
                let new_frac_part = (result_total % DECIMAL_SCALE).try_into().unwrap_or(0);
                // If result is zero, always make it positive
                let is_negative = if new_int_part == 0 && new_frac_part == 0 {
                    false
                } else {
                    *other.is_negative
                };
                Decimal { int_part: new_int_part, frac_part: new_frac_part, is_negative }
            }
        }
    }

    /// Subtract two decimals
    fn sub(self: @Decimal, other: @Decimal) -> Decimal {
        // Subtraction is equivalent to adding the negative
        let negated_other = Decimal {
            int_part: *other.int_part,
            frac_part: *other.frac_part,
            is_negative: !*other.is_negative,
        };
        self.add(@negated_other)
    }

    /// Multiply two decimals
    fn mul(self: @Decimal, other: @Decimal) -> Decimal {
        // Convert to total u128 values, then use u256 for multiplication to prevent overflow
        let self_total: u128 = (*self.int_part).into() * DECIMAL_SCALE + (*self.frac_part).into();
        let other_total: u128 = (*other.int_part).into() * DECIMAL_SCALE
            + (*other.frac_part).into();

        let a: u256 = self_total.into();
        let b: u256 = other_total.into();
        let scale: u256 = DECIMAL_SCALE.into();

        // Multiply and then divide by scale to maintain fixed-point representation
        let result = (a * b) / scale;

        // Convert back to separate fields
        let max_u128: u256 = 0xffffffffffffffffffffffffffffffff;
        let result_total: u128 = if result > max_u128 {
            0xffffffffffffffffffffffffffffffff // Cap at maximum value
        } else {
            result.try_into().unwrap_or(0xffffffffffffffffffffffffffffffff)
        };

        let new_int_part = (result_total / DECIMAL_SCALE).try_into().unwrap_or(0);
        let new_frac_part = (result_total % DECIMAL_SCALE).try_into().unwrap_or(0);

        // Result is negative if signs differ
        let is_negative = *self.is_negative != *other.is_negative;
        Decimal { int_part: new_int_part, frac_part: new_frac_part, is_negative }
    }

    /// Divide two decimals
    fn div(self: @Decimal, other: @Decimal) -> Decimal {
        // Handle division by zero
        let other_total: u128 = (*other.int_part).into() * DECIMAL_SCALE
            + (*other.frac_part).into();
        if other_total == 0 {
            return Decimal { int_part: 0, frac_part: 0, is_negative: false };
        }

        // Convert to total values and use u256 for intermediate calculation to prevent overflow
        let self_total: u128 = (*self.int_part).into() * DECIMAL_SCALE + (*self.frac_part).into();

        let dividend: u256 = self_total.into();
        let divisor: u256 = other_total.into();
        let scale: u256 = DECIMAL_SCALE.into();

        let result_256 = (dividend * scale) / divisor;

        // Convert back to separate fields
        let max_u128: u256 = 0xffffffffffffffffffffffffffffffff;
        let result_total: u128 = if result_256 > max_u128 {
            0xffffffffffffffffffffffffffffffff // Cap at maximum value
        } else {
            result_256.try_into().unwrap_or(0xffffffffffffffffffffffffffffffff)
        };

        let new_int_part = (result_total / DECIMAL_SCALE).try_into().unwrap_or(0);
        let new_frac_part = (result_total % DECIMAL_SCALE).try_into().unwrap_or(0);

        // Result is negative if signs differ
        let is_negative = *self.is_negative != *other.is_negative;
        Decimal { int_part: new_int_part, frac_part: new_frac_part, is_negative }
    }

    /// Convert to string representation
    fn to_string(self: @Decimal) -> ByteArray {
        let int_part = self.int_part();
        let frac_part = self.frac_part();

        // Convert integer part to string
        let int_str = convert_u64_to_string(int_part);

        // Handle special case where fractional part is zero
        if frac_part == 0 {
            let mut result: ByteArray = "";
            // Only add minus sign for negative non-zero values
            if *self.is_negative && int_part != 0 {
                result.append(@"-");
            }
            result.append(@int_str);
            result.append(@".0");
            return result;
        }

        const MAX_PRECISION: u128 = 1000000000000000000; // 10^18
        let high_precision_frac: u128 = (frac_part.into() * MAX_PRECISION) / DECIMAL_SCALE;

        // Split into chunks that fit in u64 for string conversion
        let high_part: u64 = (high_precision_frac / 1000000000)
            .try_into()
            .unwrap_or(0); // First 9 digits
        let low_part: u64 = (high_precision_frac % 1000000000)
            .try_into()
            .unwrap_or(0); // Last 9 digits

        // Convert each part to string with proper padding
        let high_str = convert_u64_to_string(high_part);
        let low_str = convert_u64_to_string(low_part);

        // Combine fractional parts with proper zero padding
        let mut full_frac_str: ByteArray = "";
        full_frac_str.append(@high_str);

        // Pad low_part to exactly 9 digits with leading zeros
        let low_len = low_str.len();
        let mut zeros_to_add = 9_u32 - low_len;
        while zeros_to_add > 0 {
            full_frac_str.append(@"0");
            zeros_to_add -= 1;
        }
        full_frac_str.append(@low_str);

        // Remove trailing zeros for cleaner output
        let mut trimmed_frac: ByteArray = "";
        let frac_len = full_frac_str.len();
        let mut last_non_zero_pos = 0_u32;
        let mut i = 0_u32;

        // Find last non-zero digit
        while i < frac_len {
            let current_byte = full_frac_str.at(i).unwrap();
            if current_byte != '0' {
                last_non_zero_pos = i;
            }
            i += 1;
        }

        // Build trimmed fractional string (keep at least one digit)
        i = 0;
        while i <= last_non_zero_pos {
            trimmed_frac.append_byte(full_frac_str.at(i).unwrap());
            i += 1;
        }

        // If all digits were zero, keep just one zero
        if trimmed_frac.len() == 0 {
            trimmed_frac.append(@"0");
        }

        // Combine all parts with proper sign handling
        let mut result: ByteArray = "";
        // Add minus sign for negative values (avoid -0.0 case)
        if *self.is_negative && (int_part != 0 || frac_part != 0) {
            result.append(@"-");
        }
        result.append(@int_str);
        result.append(@".");
        result.append(@trimmed_frac);

        result
    }

    /// Parse a decimal from string (basic implementation)
    fn from_string(s: ByteArray) -> Option<Decimal> {
        // Find decimal point
        let mut decimal_pos = Option::None;
        let mut i = 0;
        while i < s.len() {
            if s.at(i).unwrap() == '.' {
                decimal_pos = Option::Some(i);
                break;
            }
            i += 1;
        }

        match decimal_pos {
            Option::Some(pos) => {
                // Split into integer and fractional parts
                let int_str = substring(@s, 0, pos);
                let frac_str = substring(@s, pos + 1, s.len());

                let int_part = parse_u64_from_string(int_str)?;
                let frac_len = frac_str.len();
                let frac_digits = parse_u64_from_string(frac_str)?;

                // Convert fractional digits to fixed-point representation
                let mut frac_part = frac_digits;

                // Scale fractional part based on number of digits
                if frac_len <= 6 {
                    let scale_factor = pow_10(6 - frac_len);
                    frac_part = frac_part * scale_factor;
                    frac_part = ((frac_part.into() * DECIMAL_SCALE) / 1000000_u128)
                        .try_into()
                        .unwrap_or(0);
                } else {
                    // Truncate if more than 6 digits
                    let truncate_factor = pow_10(frac_len - 6);
                    frac_part = frac_part / truncate_factor;
                    frac_part = ((frac_part.into() * DECIMAL_SCALE) / 1000000_u128)
                        .try_into()
                        .unwrap_or(0);
                }

                Option::Some(Self::from_raw_parts(int_part, frac_part.try_into().unwrap_or(0)))
            },
            Option::None => {
                // No decimal point, treat as integer
                let int_part = parse_u64_from_string(s)?;
                Option::Some(Self::from_int(int_part))
            },
        }
    }
}

// Helper functions

/// Convert a u64 number to string representation (complete implementation)
/// Supports all u64 values from 0 to 2^64-1
fn convert_u64_to_string(n: u64) -> ByteArray {
    if n == 0 {
        return "0";
    }

    let mut result: ByteArray = "";
    let mut num = n;
    let mut digits: Array<u8> = array![];

    // Extract digits in reverse order
    while num > 0 {
        let digit = (num % 10).try_into().unwrap_or(0);
        digits.append(digit + 48); // Convert to ASCII (0-9 are 48-57)
        num = num / 10;
    }

    // Reverse the digits to get correct order
    let mut i = digits.len();
    while i > 0 {
        i -= 1;
        result.append_byte(*digits.at(i));
    }

    result
}

/// Parse a u64 number from string representation (complete implementation)
/// Supports all valid numeric strings that fit in u64
/// Returns None for invalid strings or numbers too large for u64
fn parse_u64_from_string(s: ByteArray) -> Option<u64> {
    if s.len() == 0 {
        return Option::None;
    }

    let mut result: u64 = 0;
    let mut i = 0;

    while i < s.len() {
        let byte = s.at(i).unwrap();

        // Check if character is a digit (ASCII 48-57)
        if byte < 48 || byte > 57 {
            return Option::None;
        }

        let digit = byte - 48;

        // Check for overflow before multiplying
        let max_before_multiply = 0xffffffffffffffff / 10; // u64::MAX / 10
        if result > max_before_multiply {
            return Option::None;
        }

        result = result * 10;

        // Check for overflow before adding
        if result > 0xffffffffffffffff - digit.into() {
            return Option::None;
        }

        result = result + digit.into();
        i += 1;
    }

    Option::Some(result)
}

/// Extract a substring from a ByteArray
/// Returns bytes from start index (inclusive) to end index (exclusive)
fn substring(s: @ByteArray, start: usize, end: usize) -> ByteArray {
    let mut result: ByteArray = "";
    let mut i = start;
    while i < end && i < s.len() {
        result.append_byte(s.at(i).unwrap());
        i += 1;
    }
    result
}

/// Calculate 10 raised to the power of exp using the math package implementation
/// Returns 10^exp for exponents 0-37, panics for larger values
fn pow_10(exp: usize) -> u64 {
    const_pow::pow10(exp.try_into().unwrap_or(0)).try_into().unwrap_or(0)
}

// Operator overloads for convenient decimal arithmetic

/// Implementation of the + operator for Decimal types
impl DecimalAdd of Add<Decimal> {
    fn add(lhs: Decimal, rhs: Decimal) -> Decimal {
        lhs.add(@rhs)
    }
}

/// Implementation of the - operator for Decimal types
impl DecimalSub of Sub<Decimal> {
    fn sub(lhs: Decimal, rhs: Decimal) -> Decimal {
        lhs.sub(@rhs)
    }
}

/// Implementation of the * operator for Decimal types
impl DecimalMul of Mul<Decimal> {
    fn mul(lhs: Decimal, rhs: Decimal) -> Decimal {
        lhs.mul(@rhs)
    }
}

/// Implementation of the / operator for Decimal types
impl DecimalDiv of Div<Decimal> {
    fn div(lhs: Decimal, rhs: Decimal) -> Decimal {
        lhs.div(@rhs)
    }
}
