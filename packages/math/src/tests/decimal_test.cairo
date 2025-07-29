use alexandria_math::decimal::{DECIMAL_SCALE, DecimalTrait};

#[test]
fn test_decimal_construction_from_int() {
    // Test creating decimals from integers
    let zero = DecimalTrait::from_int(0);
    assert!(zero.int_part() == 0);
    assert!(zero.frac_part() == 0);

    let small = DecimalTrait::from_int(5);
    assert!(small.int_part() == 5);
    assert!(small.frac_part() == 0);

    let large = DecimalTrait::from_int(999999);
    assert!(large.int_part() == 999999);
    assert!(large.frac_part() == 0);
}

#[test]
fn test_decimal_construction_from_parts() {
    // Test creating decimals from integer and decimal parts (user-friendly)
    let simple = DecimalTrait::from_parts(10, 0); // 10.0
    assert!(simple.int_part() == 10);
    assert!(simple.frac_part() == 0);

    let quarter = DecimalTrait::from_parts(5, 25); // 5.25
    assert!(quarter.int_part() == 5);
    // 0.25 = 1/4 of DECIMAL_SCALE = DECIMAL_SCALE/4
    let expected_frac = DECIMAL_SCALE / 4;
    assert!(quarter.frac_part() == expected_frac.try_into().unwrap());

    let half = DecimalTrait::from_parts(42, 5); // 42.5
    assert!(half.int_part() == 42);
    // 0.5 = 1/2 of DECIMAL_SCALE = DECIMAL_SCALE/2
    let expected_half_frac = DECIMAL_SCALE / 2;
    assert!(half.frac_part() == expected_half_frac.try_into().unwrap());

    let decimal_places = DecimalTrait::from_parts(3, 14); // 3.14
    assert!(decimal_places.int_part() == 3);
    // 0.14 = 14/100 of DECIMAL_SCALE
    let expected_14_frac = (14 * DECIMAL_SCALE) / 100;
    assert!(decimal_places.frac_part() == expected_14_frac.try_into().unwrap());

    let three_decimals = DecimalTrait::from_parts(56, 678); // 56.678
    assert!(three_decimals.int_part() == 56);
    // 0.678 = 678/1000 of DECIMAL_SCALE
    let expected_678_frac = (678 * DECIMAL_SCALE) / 1000;
    assert!(three_decimals.frac_part() == expected_678_frac.try_into().unwrap());
}

#[test]
fn test_decimal_basic_operations_integration() {
    // Test basic decimal operations integration
    let dec1 = DecimalTrait::from_int(10);
    let dec2 = DecimalTrait::from_int(5);

    let sum = dec1.add(@dec2);
    assert!(sum.int_part() == 15);

    let diff = dec1.sub(@dec2);
    assert!(diff.int_part() == 5);
}

#[test]
fn test_decimal_string_conversion_integration() {
    // Test decimal to string conversion integration
    let dec = DecimalTrait::from_int(42);
    let string_repr = dec.to_string();
    assert!(string_repr.len() > 0);
}

#[test]
fn test_decimal_construction_from_felt() {
    // Test creating decimals from felt252 values
    let zero_felt = DecimalTrait::from_felt(0);
    assert!(zero_felt.int_part() == 0);

    let small_felt = DecimalTrait::from_felt(25);
    assert!(small_felt.int_part() == 25);
    assert!(small_felt.frac_part() == 0);

    let large_felt = DecimalTrait::from_felt(12345);
    assert!(large_felt.int_part() == 12345);
    assert!(large_felt.frac_part() == 0);
}

#[test]
fn test_decimal_to_felt_conversion() {
    // Test converting decimals back to felt252 (truncates fractional part)
    let integer_dec = DecimalTrait::from_int(100);
    assert!(integer_dec.to_felt() == 100);

    let fractional_dec = DecimalTrait::from_parts(42, 75); // 42.75
    assert!(fractional_dec.to_felt() == 42); // Truncates fractional part

    let zero_dec = DecimalTrait::from_int(0);
    assert!(zero_dec.to_felt() == 0);
}

#[test]
fn test_decimal_addition() {
    // Test addition operations
    let a = DecimalTrait::from_int(10);
    let b = DecimalTrait::from_int(5);
    let sum = a.add(@b);
    assert!(sum.int_part() == 15);
    assert!(sum.frac_part() == 0);

    // Test addition with fractional parts using user-friendly from_parts
    let c = DecimalTrait::from_parts(5, 25); // 5.25
    let d = DecimalTrait::from_parts(3, 75); // 3.75
    let frac_sum = c.add(@d);
    assert!(frac_sum.int_part() == 9); // 5.25 + 3.75 = 9.0
    assert!(frac_sum.frac_part() == 0); // Should be exactly 9.0 with no fractional part

    // Test addition where fractional parts don't sum to whole number
    let e = DecimalTrait::from_parts(2, 5); // 2.5
    let f = DecimalTrait::from_parts(1, 25); // 1.25
    let frac_sum2 = e.add(@f);
    assert!(frac_sum2.int_part() == 3); // 2.5 + 1.25 = 3.75
    // 0.75 = 3/4 of DECIMAL_SCALE
    let expected_75_frac = (3 * DECIMAL_SCALE) / 4;
    assert!(frac_sum2.frac_part() == expected_75_frac.try_into().unwrap());

    // Test zero addition
    let zero = DecimalTrait::from_int(0);
    let num = DecimalTrait::from_int(42);
    let zero_sum = num.add(@zero);
    assert!(zero_sum.int_part() == 42);
    assert!(zero_sum.frac_part() == 0);
}

#[test]
fn test_decimal_subtraction() {
    // Test subtraction operations
    let a = DecimalTrait::from_int(10);
    let b = DecimalTrait::from_int(3);
    let diff = a.sub(@b);
    assert!(diff.int_part() == 7);
    assert!(diff.frac_part() == 0);

    // Test subtraction with fractional parts
    let c = DecimalTrait::from_parts(5, 75); // 5.75
    let d = DecimalTrait::from_parts(2, 25); // 2.25
    let frac_diff = c.sub(@d);
    assert!(frac_diff.int_part() == 3); // 5.75 - 2.25 = 3.5
    // 0.5 = 1/2 of DECIMAL_SCALE
    let expected_half_frac = DECIMAL_SCALE / 2;
    assert!(frac_diff.frac_part() == expected_half_frac.try_into().unwrap());

    // Test subtraction resulting in different fractional part
    let e = DecimalTrait::from_parts(10, 25); // 10.25
    let f = DecimalTrait::from_parts(3, 75); // 3.75
    let carry_diff = e.sub(@f);
    assert!(carry_diff.int_part() == 6); // 10.25 - 3.75 = 6.5
    let expected_half_frac2 = DECIMAL_SCALE / 2;
    assert!(carry_diff.frac_part() == expected_half_frac2.try_into().unwrap());

    // Test subtraction with same values
    let c = DecimalTrait::from_int(25);
    let same_diff = c.sub(@c);
    assert!(same_diff.int_part() == 0);
    assert!(same_diff.frac_part() == 0);

    // Test zero subtraction
    let num = DecimalTrait::from_int(100);
    let zero = DecimalTrait::from_int(0);
    let zero_diff = num.sub(@zero);
    assert!(zero_diff.int_part() == 100);
}

#[test]
fn test_decimal_multiplication() {
    // Test multiplication operations with fixed overflow handling

    // Test multiplication by zero
    let zero = DecimalTrait::from_int(0);
    let num = DecimalTrait::from_int(5);
    let zero_product = num.mul(@zero);
    assert!(zero_product.int_part() == 0);
    assert!(zero_product.frac_part() == 0);

    // Test multiplication by one
    let one = DecimalTrait::from_int(1);
    let one_product = num.mul(@one);
    assert!(one_product.int_part() == 5);
    assert!(one_product.frac_part() == 0);

    // Test basic integer multiplication
    let a = DecimalTrait::from_int(3);
    let b = DecimalTrait::from_int(4);
    let product = a.mul(@b);
    assert!(product.int_part() == 12);
    assert!(product.frac_part() == 0);

    // Test multiplication with fractional parts
    let c = DecimalTrait::from_parts(2, 5); // 2.5
    let d = DecimalTrait::from_parts(3, 0); // 3.0
    let frac_product = c.mul(@d);
    assert!(frac_product.int_part() == 7); // 2.5 * 3 = 7.5
    // 0.5 = 1/2 of DECIMAL_SCALE
    let expected_half = DECIMAL_SCALE / 2;
    assert!(frac_product.frac_part() == expected_half.try_into().unwrap());

    // Test fractional * fractional
    let e = DecimalTrait::from_parts(1, 5); // 1.5
    let f = DecimalTrait::from_parts(2, 0); // 2.0
    let frac_frac_product = e.mul(@f);
    assert!(frac_frac_product.int_part() == 3); // 1.5 * 2 = 3.0
    assert!(frac_frac_product.frac_part() == 0);
}

#[test]
fn test_decimal_division() {
    // Test division operations with fixed overflow handling

    // Test basic integer division
    let a = DecimalTrait::from_int(6);
    let b = DecimalTrait::from_int(3);
    let quotient = a.div(@b);
    assert!(quotient.int_part() == 2);
    assert!(quotient.frac_part() == 0);

    // Test division resulting in fractional part
    let c = DecimalTrait::from_int(5);
    let d = DecimalTrait::from_int(2);
    let frac_quotient = c.div(@d);
    assert!(frac_quotient.int_part() == 2); // 5 / 2 = 2.5
    // 0.5 = 1/2 of DECIMAL_SCALE
    let expected_half = DECIMAL_SCALE / 2;
    assert!(frac_quotient.frac_part() == expected_half.try_into().unwrap());

    // Test division with fractional inputs
    let e = DecimalTrait::from_parts(7, 5); // 7.5
    let f = DecimalTrait::from_parts(2, 5); // 2.5
    let frac_frac_quotient = e.div(@f);
    assert!(frac_frac_quotient.int_part() == 3); // 7.5 / 2.5 = 3.0
    assert!(frac_frac_quotient.frac_part() == 0);

    // Test division by one
    let g = DecimalTrait::from_parts(12, 34); // 12.34
    let one = DecimalTrait::from_int(1);
    let div_by_one = g.div(@one);
    assert!(div_by_one.int_part() == 12);
    // Should preserve fractional part: 0.34 = 34/100 of DECIMAL_SCALE
    let expected_34_frac = (34 * DECIMAL_SCALE) / 100;
    assert!(div_by_one.frac_part() == expected_34_frac.try_into().unwrap());

    // Test division by zero (should return 0)
    let h = DecimalTrait::from_int(10);
    let zero = DecimalTrait::from_int(0);
    let div_by_zero = h.div(@zero);
    assert!(div_by_zero.int_part() == 0);
    assert!(div_by_zero.frac_part() == 0);
}

#[test]
fn test_decimal_operator_overloads() {
    // Test operator overloads - only addition and subtraction work without overflow
    let a = DecimalTrait::from_int(6);
    let b = DecimalTrait::from_int(3);

    // Test addition operator
    let sum = a + b;
    assert!(sum.int_part() == 9);

    // Test subtraction operator
    let diff = a - b;
    assert!(diff.int_part() == 3);

    // Test multiplication and division operators (now fixed)
    let product = a * b;
    assert!(product.int_part() == 18);
    assert!(product.frac_part() == 0);

    let quotient = a / b;
    assert!(quotient.int_part() == 2);
    assert!(quotient.frac_part() == 0);
}

#[test]
fn test_decimal_chained_operations() {
    // Test chaining operations - only addition and subtraction work without overflow
    let a = DecimalTrait::from_int(4);
    let b = DecimalTrait::from_int(2);
    let c = DecimalTrait::from_int(2);

    // Test 4 + (2 + 2) = 8
    let result2 = a + (b + c);
    assert!(result2.int_part() == 8);

    // Test (4 + 2) - 2 = 4
    let result3 = (a + b) - c;
    assert!(result3.int_part() == 4);

    // Test multiplication and division in chains (now fixed)
    let result1 = (a + b) / c; // (4 + 2) / 2 = 3
    assert!(result1.int_part() == 3);
    assert!(result1.frac_part() == 0);

    let result4 = (a - b) * c; // (4 - 2) * 2 = 4
    assert!(result4.int_part() == 4);
    assert!(result4.frac_part() == 0);
}

#[test]
fn test_decimal_precision_boundaries() {
    // Test precision with user-friendly interface
    let large_int = DecimalTrait::from_int(18446744073709551615);
    assert!(large_int.int_part() == 18446744073709551615);
    assert!(large_int.frac_part() == 0);

    let half = DecimalTrait::from_parts(100, 5); // 100.5
    assert!(half.int_part() == 100);

    let quarter = DecimalTrait::from_parts(0, 25); // 0.25
    assert!(quarter.int_part() == 0);
}

#[test]
fn test_decimal_string_conversion_basic() {
    // Test basic string conversion
    let zero = DecimalTrait::from_int(0);
    let zero_str = zero.to_string();
    assert!(zero_str.len() > 0);

    let simple = DecimalTrait::from_int(42);
    let simple_str = simple.to_string();
    assert!(simple_str.len() > 0);

    let large = DecimalTrait::from_int(12345);
    let large_str = large.to_string();
    assert!(large_str.len() > 0);
}

#[test]
fn test_decimal_string_parsing_basic() {
    // Test basic string parsing - limited to what the current implementation supports
    let zero_opt = DecimalTrait::from_string("0");
    assert!(zero_opt.is_some());
    let zero_dec = zero_opt.unwrap();
    assert!(zero_dec.int_part() == 0);

    let simple_opt = DecimalTrait::from_string("42");
    assert!(simple_opt.is_some());
    let simple_dec = simple_opt.unwrap();
    assert!(simple_dec.int_part() == 42);

    // Note: decimal parsing like "3.14" may not be fully implemented yet
    // Testing with simpler cases for now
    let small_opt = DecimalTrait::from_string("5");
    assert!(small_opt.is_some());
    let small_dec = small_opt.unwrap();
    assert!(small_dec.int_part() == 5);
}

#[test]
fn test_decimal_string_parsing_edge_cases() {
    // Test parsing edge cases
    let invalid1 = DecimalTrait::from_string("abc");
    assert!(invalid1.is_none());

    let invalid2 = DecimalTrait::from_string("");
    assert!(invalid2.is_none());

    let invalid3 = DecimalTrait::from_string("12.34.56");
    assert!(invalid3.is_none());

    // Test valid edge cases
    let single_digit = DecimalTrait::from_string("5");
    assert!(single_digit.is_some());
    assert!(single_digit.unwrap().int_part() == 5);
}

#[test]
fn test_decimal_equality() {
    // Test decimal equality
    let a = DecimalTrait::from_int(10);
    let b = DecimalTrait::from_int(10);
    let c = DecimalTrait::from_int(5);

    assert!(a == b);
    assert!(!(a == c));

    // Test equality with fractional parts
    let d = DecimalTrait::from_parts(5, 25); // 5.25
    let e = DecimalTrait::from_parts(5, 25); // 5.25
    let f = DecimalTrait::from_parts(5, 5); // 5.5

    assert!(d == e);
    assert!(!(d == f));
}

#[test]
fn test_decimal_scale_constant() {
    // Test that DECIMAL_SCALE constant is correct
    assert!(DECIMAL_SCALE == 0x10000000000000000); // 2^64

    // Test that scale is used correctly in construction
    let one = DecimalTrait::from_int(1);
    assert!(one.int_part == 1);
    assert!(one.frac_part == 0);

    let two = DecimalTrait::from_int(2);
    assert!(two.int_part == 2);
    assert!(two.frac_part == 0);
}

#[test]
fn test_decimal_internal_representation() {
    // Test understanding of internal representation with separate fields
    let zero = DecimalTrait::from_int(0);
    assert!(zero.int_part == 0);
    assert!(zero.frac_part == 0);

    let one = DecimalTrait::from_int(1);
    assert!(one.int_part == 1);
    assert!(one.frac_part == 0);

    // Test internal representation with raw parts for low-level testing
    let fractional = DecimalTrait::from_raw_parts(0, 1);
    assert!(fractional.int_part == 0);
    assert!(fractional.frac_part == 1);

    let mixed = DecimalTrait::from_raw_parts(1, 1);
    assert!(mixed.int_part == 1);
    assert!(mixed.frac_part == 1);
}

#[test]
fn test_comprehensive_fractional_verification() {
    // Test comprehensive fractional part verification for various decimal representations

    // Test single decimal places
    let one_tenth = DecimalTrait::from_parts(0, 1); // 0.1
    let expected_1_frac = DECIMAL_SCALE / 10;
    assert!(one_tenth.frac_part() == expected_1_frac.try_into().unwrap());

    let nine_tenths = DecimalTrait::from_parts(0, 9); // 0.9
    let expected_9_frac = (9 * DECIMAL_SCALE) / 10;
    assert!(nine_tenths.frac_part() == expected_9_frac.try_into().unwrap());

    // Test two decimal places
    let quarter = DecimalTrait::from_parts(0, 25); // 0.25
    let expected_25_frac = DECIMAL_SCALE / 4;
    assert!(quarter.frac_part() == expected_25_frac.try_into().unwrap());

    let seventy_five = DecimalTrait::from_parts(0, 75); // 0.75
    let expected_75_frac = (3 * DECIMAL_SCALE) / 4;
    assert!(seventy_five.frac_part() == expected_75_frac.try_into().unwrap());

    // Test three decimal places
    let one_eighth = DecimalTrait::from_parts(0, 125); // 0.125
    let expected_125_frac = DECIMAL_SCALE / 8;
    assert!(one_eighth.frac_part() == expected_125_frac.try_into().unwrap());

    let three_eighths = DecimalTrait::from_parts(0, 375); // 0.375
    let expected_375_frac = (3 * DECIMAL_SCALE) / 8;
    assert!(three_eighths.frac_part() == expected_375_frac.try_into().unwrap());

    // Test with integer parts
    let pi_approx = DecimalTrait::from_parts(3, 14159); // 3.14159
    assert!(pi_approx.int_part() == 3);
    let expected_pi_frac = (14159 * DECIMAL_SCALE) / 100000;
    assert!(pi_approx.frac_part() == expected_pi_frac.try_into().unwrap());

    let e_approx = DecimalTrait::from_parts(2, 71828); // 2.71828
    assert!(e_approx.int_part() == 2);
    let expected_e_frac = (71828 * DECIMAL_SCALE) / 100000;
    assert!(e_approx.frac_part() == expected_e_frac.try_into().unwrap());
}

#[test]
fn test_decimal_performance_operations() {
    // Test that operations complete without overflow - addition and subtraction only
    let a = DecimalTrait::from_int(50);
    let b = DecimalTrait::from_int(25);

    // These complete successfully
    let sum = a + b;
    assert!(sum.int_part() == 75);

    let diff = a - b;
    assert!(diff.int_part() == 25);

    // Test multiplication and division (now fixed)
    let product = DecimalTrait::from_int(5) * DecimalTrait::from_int(3);
    assert!(product.int_part() == 15);
    assert!(product.frac_part() == 0);

    let quotient = DecimalTrait::from_int(50) / DecimalTrait::from_int(5);
    assert!(quotient.int_part() == 10);
    assert!(quotient.frac_part() == 0);
}

#[test]
fn test_decimal_mathematical_properties() {
    // Test mathematical properties - addition and subtraction only
    let a = DecimalTrait::from_int(2);
    let b = DecimalTrait::from_int(3);
    let zero = DecimalTrait::from_int(0);

    // Test additive identity: a + 0 = a
    assert!((a + zero) == a);

    // Test commutativity of addition: a + b = b + a
    assert!((a + b) == (b + a));

    // Test subtraction: a - a = 0
    assert!((a - a) == zero);

    // Test multiplication properties (now fixed)
    let one = DecimalTrait::from_int(1);
    assert!((a * one) == a); // Multiplicative identity
    assert!((a * b) == (b * a)); // Commutativity of multiplication

    // Test multiplicative identity with fractions
    let frac = DecimalTrait::from_parts(3, 14); // 3.14
    assert!((frac * one) == frac);

    // Test division properties
    assert!((a / one) == a); // Division by one
    assert!((a / a).int_part() == 1); // Self division
    assert!((a / a).frac_part() == 0);
}
