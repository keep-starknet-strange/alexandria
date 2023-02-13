//! # GCD for N numbers

// Core library imports.
use option::OptionTrait;
use array::ArrayTrait;
// Internal imports.
use quaireaux::utils;

fn gcd(ref n: Array::<felt>) -> felt {
    if n.len() == 0_usize {
        let mut data = array_new::<felt>();
        array_append::<felt>(ref data, 'EI');
        panic(data);
    }
    _gcd(ref n)
}

fn _gcd(ref n: Array::<felt>) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }
    if n.len() == 1_usize {
        return n.pop_front().unwrap();
    }
    let a = n.pop_front().unwrap();
    let b = _gcd(ref n);
    gcd_two_numbers(a, b)
}

fn gcd_two_numbers(a: felt, b: felt) -> felt {
    // Check if out of gas.
    // TODO: Remove when automatically handled by compiler.
    match get_gas() {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = array_new::<felt>();
            array_append::<felt>(ref data, 'OOG');
            panic(data);
        },
    }
    match b {
        0 => a,
        _ => {
            let (_, r) = utils::unsafe_euclidean_div(a, b);
            gcd_two_numbers(b, r)
        },
    }
}
