# day_of_week

Compute the day of the week for the given Gregorian date. The returned value is an integer in the range 0 to 6, where 0 is Saturday, 1 is Sunday, 2 is Monday, and so on.

## Arguments

- `date` - The date of the month
- `month` - The month of the year
- `year` - The year

## Returns

- `Option::None` - If the input parameters are invalid
- `Option::Some(day_of_week)` - The day of the week

#### Examples

```cairo
use alexandria::math::zellers_congruence::day_of_week;
let day_of_week = day_of_week(1, 1, 2020);
```

# TODO - Change the return type to `Result`

Fully qualified path: `alexandria_math::zellers_congruence::day_of_week`

```rust
pub fn day_of_week(mut date: u128, mut month: u128, mut year: u128) -> Option<u128>
```
