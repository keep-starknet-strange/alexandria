//! Zeller's congruence is an algorithm devised by Christian Zeller in the 19th century
//! to calculate the day of the week for any Julian or Gregorian calendar date.
//! It can be considered to be based on the conversion between Julian day and the calendar date.

/// Compute the day of the week for the given Gregorian date.
/// The returned value is an integer in the range 0 to 6, where 0 is Saturday, 1 is Sunday, 2 is Monday, and so on.
/// # Arguments
/// * `date` - The date of the month
/// * `month` - The month of the year
/// * `year` - The year
/// # Returns
/// * `Option::None(())` - If the input parameters are invalid
/// * `Option::Some(day_of_week)` - The day of the week
/// # Examples
/// ```
/// use alexandria::math::zellers_congruence::day_of_week;
/// let day_of_week = day_of_week(1, 1, 2020);
/// ```
/// # TODO
/// - Change the return type to `Result`
fn day_of_week(mut date: u128, mut month: u128, mut year: u128) -> Option<u128> {
    // Check input parameters
    if !check_input_parameters(date, month, year) {
        return Option::None(());
    }
    if month < 3 {
        month = month + 12;
        year = year - 1;
    }

    let day = (date
        + (26 * (month + 1) / 10)
        + (year % 100)
        + ((year % 100) / 4)
        + ((year / 100) / 4)
        + 5 * (year / 100)) % 7;

    Option::Some(day)
}

/// Check the input parameters for the `day_of_week` function.
/// # Arguments
/// * `date` - The date of the month
/// * `month` - The month of the year
/// * `year` - The year
/// # Returns
/// * `true` - If the input parameters are valid
/// * `false` - If the input parameters are invalid
fn check_input_parameters(date: u128, month: u128, year: u128) -> bool {
    // Check the date
    // Must be in the range 1 to 31
    if date < 1 {
        return false;
    }
    if date > 31 {
        return false;
    }
    // Check the month
    // Must be in the range 1 to 12
    if month < 1 {
        return false;
    }
    if month > 12 {
        return false;
    }
    // Check the year
    // Must be > 0
    if year < 1 {
        return false;
    }
    true
}
