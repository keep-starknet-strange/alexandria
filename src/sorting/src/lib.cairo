mod bubble_sort;
mod merge_sort;
mod quick_sort;

#[cfg(test)]
mod tests;
use alexandria_data_structures::vec::{Felt252Vec, VecTrait};

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
            Option::None => { break true; },
        };
    }
}


/// * `a` - The first Felt252Vec.
/// * `b` - The second array.
/// # Returns
/// * `bool` - True if the arrays are equal, false otherwise.
fn is_equal_vec(mut a: Felt252Vec<u32>, mut b: Span<u32>) -> bool {
    if a.len() != b.len() {
        return false;
    }

    let mut compare_id = 0;

    loop {
        if compare_id == b.len() {
            break true;
        }

        if a[compare_id] != *b[compare_id] {
            break false;
        }

        compare_id += 1;
    }
}
