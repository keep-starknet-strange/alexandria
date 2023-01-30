use quaireaux::math::zellers_congruence;
use option::OptionTrait;

// Define a test case function to avoid code duplication.
fn test_case(day: u128, month: u128, year: u128, expected: u128, error_expected: bool) {
    let day = zellers_congruence::day_of_week(day, month, year);
    // If error is expected, day must be none
    if error_expected {
        assert(day.is_none(), 'expected error');
    } // Otherwise, unwrap the day and check it
    else {
        let day = day.unwrap();
        assert(day == expected, 'day is invalid');
    }
}

#[test]
#[available_gas(2000000)]
fn zellers_congruence_test() {
    test_case(25_u128, 1_u128, 2013_u128, 6_u128, false);
    test_case(16_u128, 4_u128, 2022_u128, 0_u128, false);
    test_case(14_u128, 12_u128, 1978_u128, 5_u128, false);
    test_case(15_u128, 6_u128, 2021_u128, 3_u128, false);
}

#[test]
#[available_gas(2000000)]
fn zellers_congruence_invalid_parameters_test() {
    // Invalid day
    // Must be between 1 and 31
    test_case(0_u128, 1_u128, 2013_u128, 0_u128, true);
    test_case(32_u128, 1_u128, 2013_u128, 0_u128, true);
    // Invalid month
    // Must be between 1 and 12
    test_case(25_u128, 0_u128, 2013_u128, 0_u128, true);
    test_case(25_u128, 13_u128, 2013_u128, 0_u128, true);
    // Invalid year
    // Must be > 0
    test_case(25_u128, 1_u128, 0_u128, 0_u128, true);
}

