use alexandria_math::const_pow;

/// Fixed-point decimal number using separate 64-bit fields
/// int_part: integer portion (0 to 2^64-1)
/// frac_part: fractional portion in raw DECIMAL_SCALE units (0 to 2^64-1)
#[derive(Drop, Copy, PartialEq, Debug)]
pub struct Decimal {
    pub int_part: u64, // Integer portion
    pub frac_part: u64 // Fractional portion (raw units)
}

pub const DECIMAL_SCALE: u128 = 0x10000000000000000; // 2^64

#[generate_trait]
pub impl DecimalImpl of DecimalTrait {
    /// Create a decimal from an integer part
    fn from_int(int_part: u64) -> Decimal {
        Decimal { int_part, frac_part: 0 }
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
        Decimal { int_part, frac_part }
    }

    /// Create a decimal from integer and raw fractional parts (internal use)
    /// frac_part should be in range [0, 2^64) - raw fractional units
    fn from_raw_parts(int_part: u64, frac_part: u64) -> Decimal {
        Decimal { int_part, frac_part }
    }

    /// Create a decimal from a felt252 (treating it as integer)
    fn from_felt(value: felt252) -> Decimal {
        let int_part: u64 = value.try_into().unwrap_or(0);
        Self::from_int(int_part)
    }

    /// Get the integer part
    fn int_part(self: @Decimal) -> u64 {
        *self.int_part
    }

    /// Get the fractional part
    fn frac_part(self: @Decimal) -> u64 {
        *self.frac_part
    }

    /// Convert to felt252 (truncates fractional part)
    fn to_felt(self: @Decimal) -> felt252 {
        self.int_part().into()
    }

    /// Add two decimals
    fn add(self: @Decimal, other: @Decimal) -> Decimal {
        let total_frac: u128 = (*self.frac_part).into() + (*other.frac_part).into();
        let carry = (total_frac / DECIMAL_SCALE).try_into().unwrap_or(0);
        let new_frac = (total_frac % DECIMAL_SCALE).try_into().unwrap_or(0);
        Decimal { int_part: *self.int_part + *other.int_part + carry, frac_part: new_frac }
    }

    /// Subtract two decimals
    fn sub(self: @Decimal, other: @Decimal) -> Decimal {
        let self_total: u128 = (*self.int_part).into() * DECIMAL_SCALE + (*self.frac_part).into();
        let other_total: u128 = (*other.int_part).into() * DECIMAL_SCALE
            + (*other.frac_part).into();
        let result_total = self_total - other_total;

        let new_int_part = (result_total / DECIMAL_SCALE).try_into().unwrap_or(0);
        let new_frac_part = (result_total % DECIMAL_SCALE).try_into().unwrap_or(0);

        Decimal { int_part: new_int_part, frac_part: new_frac_part }
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

        Decimal { int_part: new_int_part, frac_part: new_frac_part }
    }

    /// Divide two decimals
    fn div(self: @Decimal, other: @Decimal) -> Decimal {
        // Handle division by zero
        let other_total: u128 = (*other.int_part).into() * DECIMAL_SCALE
            + (*other.frac_part).into();
        if other_total == 0 {
            return Decimal { int_part: 0, frac_part: 0 };
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

        Decimal { int_part: new_int_part, frac_part: new_frac_part }
    }

    /// Convert to string representation (basic implementation)
    fn to_string(self: @Decimal) -> ByteArray {
        let int_part = self.int_part();
        let frac_part = self.frac_part();

        // Convert integer part
        let int_str = convert_u64_to_string(int_part);

        // Convert fractional part to decimal representation
        // This is a simplified version - for production, you'd want more precision
        let frac_decimal: u64 = ((frac_part.into() * 1000000_u128) / DECIMAL_SCALE)
            .try_into()
            .unwrap_or(0); // 6 decimal places
        let frac_str = convert_u64_to_string(frac_decimal);

        // Combine parts
        let mut result = int_str;
        result.append(@".");

        // Pad fractional part with leading zeros if needed
        if frac_decimal < 100000 {
            result.append(@"0");
        }
        if frac_decimal < 10000 {
            result.append(@"0");
        }
        if frac_decimal < 1000 {
            result.append(@"0");
        }
        if frac_decimal < 100 {
            result.append(@"0");
        }
        if frac_decimal < 10 {
            result.append(@"0");
        }

        result.append(@frac_str);
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
