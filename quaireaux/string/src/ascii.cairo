use array::ArrayTrait;
use array::SpanTrait;

use option::OptionTrait;
use traits::Into;
use traits::TryInto;

use core::integer::u256_from_felt252;
use core::integer::u256_as_non_zero;
use core::integer::u256_safe_divmod;

use quaireaux_utils::utils::check_gas;


impl Intou256cycle of Into<u256, u256> {
    fn into(self: u256) -> u256 {
        self
    }
}

const ascii_0: u8 = 48;
const ascii_A: u8 = 65;
const ascii_a: u8 = 97;
const ascii_plus: u8 = 43;
const ascii_slash: u8 = 47;

fn insert_reverse(mut out: Array<u8>, mut data: Span<u8>) -> Array<u8> {
    check_gas();
    if data.len() == 0 {
        return out;
    }
    let nb = *data.pop_back().unwrap();
    out.append(nb);
    return insert_reverse(out, data);
}

fn ascii_representation<T, impl TInto: Into<T, u256>, impl TD: Destruct<T>>(i: T) -> Array<u8> {
    let reversed = _ascii_representation(ArrayTrait::<u8>::new(), i.into());
    insert_reverse(ArrayTrait::<u8>::new(), reversed.span())
}

fn _ascii_representation(mut out: Array<u8>, i: u256) -> Array<u8> {
    check_gas();
    let (q, r) = get_letter(i);
    out.append(r);
    if q == 0.into() {
        return out;
    }
    return _ascii_representation(out, q);
}

fn ascii_representation_hex<T, impl TInto: Into<T, u256>, impl TD: Destruct<T>>(i: T) -> Array<u8> {
    let reversed = _ascii_representation_hex(ArrayTrait::<u8>::new(), i.into());
    insert_reverse(ArrayTrait::<u8>::new(), reversed.span())
}

fn _ascii_representation_hex(mut out: Array<u8>, i: u256) -> Array<u8> {
    check_gas();
    let (q, r) = get_letter_hex(i);
    out.append(r);
    if q == 0.into() {
        return out;
    }
    return _ascii_representation_hex(out, q);
}

fn get_letter(i: u256, ) -> (u256, u8) {
    let (q, r) = u256_safe_divmod(i, u256_as_non_zero(10.into()));
    // We know that r < 10, so this is safe
    return (q, r.low.try_into().unwrap() + ascii_0);
}

fn get_letter_hex(i: u256, ) -> (u256, u8) {
    let (q, r) = u256_safe_divmod(i, u256_as_non_zero(16.into()));
    // We know that r < 16, so below is safe
    if r < 10.into() {
        return (q, r.low.try_into().unwrap() + ascii_0);
    }
    return (q, r.low.try_into().unwrap() + ascii_A - 10);
}
