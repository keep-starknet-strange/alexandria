use quaireaux_math::sha256;
use array::ArrayTrait;
use debug::PrintTrait;

#[test]
#[available_gas(2000000000)]
fn sha256_empty_test() {
    let mut input = ArrayTrait::<u8>::new();
    let result = sha256::sha256(input);

    // 0xE3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
    assert(result.len() == 32, 'invalid result length');
    assert(*result[0] == 0xE3, 'invalid result');
}
