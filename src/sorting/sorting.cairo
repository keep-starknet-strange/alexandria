use array::SpanTrait;
use option::OptionTrait;

// Check if two arrays are equal.
/// * `a` - The first array.
/// * `b` - The second array.
/// # Returns
/// * `bool` - True if the arrays are equal, false otherwise.
fn is_equal(mut a: Span<u32>, mut b: Span<u32>) -> bool {
    if a.len() != b.len() {
        return false;
    }
    loop {
        match a.pop_front() {
            Option::Some(val1) => {
                let val2 = b.pop_front().unwrap();
                if *val1 != *val2 {
                    break false;
                }
            },
            Option::None(_) => {
                break true;
            },
        };
    }
}
