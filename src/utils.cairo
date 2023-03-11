//! Utilities for quaireaux standard library.
use array::ArrayTrait;
use option::OptionTrait;
use traits::TryInto;
use traits::Into;

/// Panic with a custom message.
/// # Arguments
/// * `msg` - The message to panic with. Must be a short string to fit in a felt.
fn panic_with(err: felt) {
    let mut data = ArrayTrait::new();
    data.append(err);
    panic(data);
}

/// Convert a `felt` to a `NonZero` type.
/// # Arguments
/// * `felt` - The `felt` to convert.
/// # Returns
/// * `Option::<NonZero::<felt>>` - The `felt` as a `NonZero` type.
/// * `Option::<NonZero::<felt>>::None` - If `felt` is 0.
fn to_non_zero(felt: felt) -> Option::<NonZero::<felt>> {
    let res = felt_is_zero(felt);
    match res {
        IsZeroResult::Zero(()) => Option::<NonZero::<felt>>::None(()),
        IsZeroResult::NonZero(val) => Option::<NonZero::<felt>>::Some(val),
    }
}


/// Force conversion from `felt` to `u128`.
fn unsafe_felt_to_u128(a: felt) -> u128 {
    a.try_into().unwrap()
}

/// Perform euclidean division on `felt` types.
fn unsafe_euclidean_div_no_remainder(a: felt, b: felt) -> felt {
    let a_u128 = unsafe_felt_to_u128(a);
    let b_u128 = unsafe_felt_to_u128(b);
    (a_u128 / b_u128).into()
}

fn unsafe_euclidean_div(a: felt, b: felt) -> (felt, felt) {
    let a_u128 = unsafe_felt_to_u128(a);
    let b_u128 = unsafe_felt_to_u128(b);
    ((a_u128 / b_u128).into(), (a_u128 % b_u128).into())
}

//TODO: fix by using generic integer types
// fn max(a: felt, b: felt) -> felt {
//     if a > b {
//         return a;
//     } else {
//         return b;
//     }
// }

// Function to count the number of digits in a number.
/// # Arguments
/// * `num` - The number to count the digits of.
/// * `base` - Base in which to count the digits.
/// # Returns
/// * `felt` - The number of digits in num of base
fn count_digits_of_base(num: felt, base: felt) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    match num {
        0 => 0,
        _ => {
            let quotient = unsafe_euclidean_div_no_remainder(num, base);
            count_digits_of_base(quotient, base) + 1
        }
    }
}

// Raise a number to a power.
/// * `base` - The number to raise.
/// * `exp` - The exponent.
/// # Returns
/// * `felt` - The result of base raised to the power of exp.
fn pow(base: felt, exp: felt) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    match exp {
        0 => 1,
        _ => base * pow(base, exp - 1),
    }
}

// Split an array into two arrays.
/// * `arr` - The array to split.
/// * `index` - The index to split the array at.
/// # Returns
/// * `(Array::<T>, Array::<T>)` - The two arrays.
fn split_array<T, impl TCopy: Copy::<T>>(
    ref arr: Array::<T>, index: u32
) -> (Array::<T>, Array::<T>) {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    let mut arr1 = array_new::<T>();
    let mut arr2 = array_new::<T>();
    let len = arr.len();

    fill_array(ref arr1, ref arr, 0_u32, index);
    fill_array(ref arr2, ref arr, index, len - index);

    (arr1, arr2)
}

/// * `dst` - The array to fill.
/// * `src` - The array to fill with.
/// * `index` - The index to start filling at.
/// * `count` - The number of elements to fill.
fn fill_array<T, impl TCopy: Copy::<T>>(
    ref dst: Array::<T>, ref src: Array::<T>, index: u32, count: u32
) {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

    if count == 0_u32 {
        return ();
    }
    if index >= src.len() {
        return ();
    }
    let element = src.at(index);
    dst.append(*element);

    fill_array(ref dst, ref src, index + 1_u32, count - 1_u32)
}

// Check if two arrays are equal.
/// * `a` - The first array.
/// * `b` - The second array.
/// * `index` - The index used to loop through the arrays.
/// # Returns
/// * `bool` - True if the arrays are equal, false otherwise.
fn is_equal(ref a: Array::<u32>, ref b: Array::<u32>, index: u32) -> bool {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match gas::get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }

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

//TODO use a snapshot here once bug fixed in the recursive function
/// Returns the slice of an array.
/// * `arr` - The array to slice.
/// * `begin` - The index to start the slice at.
/// * `end` - The index to end the slice at (not included).
/// # Returns
/// * `Array::<u256>` - The slice of the array.
fn array_slice<T, impl TCopy: Copy::<T>>(
    ref src: Array::<T>, begin: usize, end: usize
) -> Array::<T> {
    let mut slice = ArrayTrait::<T>::new();
    fill_array(ref dst: slice, ref :src, index: begin, count: end);
    slice
}
