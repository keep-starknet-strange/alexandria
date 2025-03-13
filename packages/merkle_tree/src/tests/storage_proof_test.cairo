use alexandria_merkle_tree::storage_proof::verify;
use alexandria_merkle_tree::tests::storage_proof_test_data::{balance_proof, total_balance_proof};

const DAI: felt252 = 0x00da114221cb83fa859dbdb4c44beeaa0bb37c7537ad5ae66fe5e0efd20e6eb3;
const ETH: felt252 = 0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7;

#[test]
#[available_gas(2000000)]
fn balance_lsb_proof_test() {
    let state_commitment = 0x07dc88984a2d8f9c2a6d2d431b2d8f2c32957da514c16ceef0761b6933121708;
    let contract_address = DAI;
    let storage_address = 0x4ae51d08cd202d1472587dfe63dbf2d5ec767cbf4218b59b7ab71956780c6ee;
    let expected_value = 8700000000000000005;
    let proof = balance_proof();
    let value = verify(state_commitment, contract_address, storage_address, proof);
    assert_eq!(expected_value, value);
}

#[test]
#[should_panic(expected: ('invalid proof path',))]
#[available_gas(2000000)]
fn balance_msb_proof_test() {
    let state_commitment = 0x07dc88984a2d8f9c2a6d2d431b2d8f2c32957da514c16ceef0761b6933121708;
    let contract_address = DAI;
    let storage_address = 0x4ae51d08cd202d1472587dfe63dbf2d5ec767cbf4218b59b7ab71956780c6ef;
    let expected_value = 8700000000000000005;
    let proof = balance_proof();
    let value = verify(state_commitment, contract_address, storage_address, proof);
    assert_eq!(expected_value, value);
}

#[test]
#[should_panic(expected: ('invalid node hash',))]
#[available_gas(2000000)]
fn wrong_contract_address_proof_test() {
    let state_commitment = 0x07dc88984a2d8f9c2a6d2d431b2d8f2c32957da514c16ceef0761b6933121708;
    let contract_address = ETH;
    let storage_address = 0x4ae51d08cd202d1472587dfe63dbf2d5ec767cbf4218b59b7ab71956780c6ee;
    let expected_value = 8700000000000000005;
    let proof = balance_proof();
    let value = verify(state_commitment, contract_address, storage_address, proof);
    assert_eq!(expected_value, value);
}

#[test]
#[available_gas(50000000)]
fn total_balance_lsb_proof_test() {
    let state_commitment = 0x07dc88984a2d8f9c2a6d2d431b2d8f2c32957da514c16ceef0761b6933121708;
    let contract_address = DAI;
    let storage_address = 0x37a9774624a0e3e0d8e6b72bd35514f62b3e8e70fbaff4ed27181de4ffd4604;
    let expected_value = 2970506847688829412026631;
    let proof = total_balance_proof();
    let value = verify(state_commitment, contract_address, storage_address, proof);
    assert_eq!(expected_value, value);
}
