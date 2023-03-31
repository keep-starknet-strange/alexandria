//! Utilities for quaireaux standard library.
use array::ArrayTrait;
use option::OptionTrait;
use traits::TryInto;
use traits::Into;


/// Convert a `felt252` to a `NonZero` type.
/// # Arguments
/// * `felt252` - The `felt252` to convert.
/// # Returns
/// * `Option::<NonZero::<felt252>>` - The `felt252` as a `NonZero` type.
/// * `Option::<NonZero::<felt252>>::None` - If `felt252` is 0.
fn to_non_zero(felt252: felt252) -> Option::<NonZero::<felt252>> {
    let res = felt252_is_zero(felt252);
    match res {
        IsZeroResult::Zero(()) => Option::<NonZero::<felt252>>::None(()),
        IsZeroResult::NonZero(val) => Option::<NonZero::<felt252>>::Some(val),
    }
}

// Fill an array with a value.
/// * `dst` - The array to fill.
/// * `src` - The array to fill with.
/// * `index` - The index to start filling at.
/// * `count` - The number of elements to fill.
fn fill_array_256(ref dst: Array::<u256>, src: @Array::<u256>, index: u32, count: u32) {
    check_gas();

    if count == 0_u32 {
        return ();
    }
    if index >= src.len() {
        return ();
    }
    let element = src.at(index);
    dst.append(*element);

    fill_array_256(ref dst, src, index + 1_u32, count - 1_u32)
}

// Check if two arrays are equal.
/// * `a` - The first array.
/// * `b` - The second array.
/// * `index` - The index used to loop through the arrays.
/// # Returns
/// * `bool` - True if the arrays are equal, false otherwise.
fn is_equal(ref a: Array::<u32>, ref b: Array::<u32>, index: u32) -> bool {
    check_gas();

    let len = a.len();
    if len != b.len() {
        return false;
    }
    let mut i = 0_u32;
    if index == len {
        return true;
    }

    let a_element = a.at(index);
    let b_element = b.at(index);
    if *a_element != *b_element {
        return false;
    }

    is_equal(ref a, ref b, index + 1_u32)
}

/// Returns the slice of an array.
/// * `arr` - The array to slice.
/// * `begin` - The index to start the slice at.
/// * `end` - The index to end the slice at (not included).
/// # Returns
/// * `Array::<u256>` - The slice of the array.
fn array_slice(src: @Array::<u256>, begin: usize, end: usize) -> Array::<u256> {
    let mut slice = ArrayTrait::new();
    fill_array_256(ref dst: slice, :src, index: begin, count: end);
    slice
}


// Fake macro to compute gas left
// TODO: Remove when automatically handled by compiler.
#[inline(always)]
fn check_gas() {
    match gas::withdraw_gas_all(get_builtin_costs()) {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('Out of gas');
            panic(data);
        }
    }
}
