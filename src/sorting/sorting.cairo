use array::SpanTrait;
use option::OptionTrait;

// Check if two arrays are equal.
/// * `a` - The first array.
/// * `b` - The second array.
/// * `index` - The index used to loop through the arrays.
/// # Returns
/// * `bool` - True if the arrays are equal, false otherwise.
fn is_equal(a: Span<u32>, b: Span<u32>) -> bool {
    let mut a = a;
    let mut b = b;
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
