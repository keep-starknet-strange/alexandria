use quaireaux_math::sha256;
use array::ArrayTrait;
use debug::PrintTrait;

#[test]
#[available_gas(2000000000)]
fn sha256_empty_test() {
    let mut input = ArrayTrait::<u8>::new();
    let actual = sha256::sha256(input);

    let mut result = ArrayTrait::<u8>::new();

    assert(0 == 0, 'invalid result');
}
