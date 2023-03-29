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
/// * `Option::<u128>::None(())` - If the input parameters are invalid
/// * `Option::<u128>::Some(day_of_week)` - The day of the week
/// # Examples
/// ```
/// use quaireaux::zellers_congruence::day_of_week;
/// let day_of_week = day_of_week(1, 1, 2020);
/// ```
/// # TODO
/// - Change the return type to `Result`
fn day_of_week(date: u128, month: u128, year: u128) -> Option::<u128> {
    // Check input parameters
    if !check_input_parameters(date, month, year) {
        return Option::<u128>::None(());
    }
    let q = date;
    let mut m = month;
    let mut y = year;
    if month < 3_u128 {
        m = month + 12_u128;
        y = year - 1_u128;
    }

    let day = (q
        + (26_u128 * (m + 1_u128) / 10_u128)
        + (y % 100_u128)
        + ((y % 100_u128) / 4_u128)
        + ((y / 100_u128) / 4_u128)
        + 5_u128 * (y / 100_u128)) % 7_u128;

    Option::<u128>::Some(day)
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
    if date < 1_u128 {
        return false;
    }
    if date > 31_u128 {
        return false;
    }
    // Check the month
    // Must be in the range 1 to 12
    if month < 1_u128 {
        return false;
    }
    if month > 12_u128 {
        return false;
    }
    // Check the year
    // Must be > 0
    if year < 1_u128 {
        return false;
    }
    true
}
