//! Utilities for quaireaux standard library.
use array::ArrayTrait;

// Fake macro to compute gas left
// TODO: Remove when automatically handled by compiler.
#[inline(always)]
fn check_gas() {
    gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas')
}
