// Core lib imports
use array::ArrayTrait;
use hash::LegacyHash;
// Internal imports
use quaireaux::data_structures::merkle_tree::MerkleTreeTrait;
use quaireaux::data_structures::merkle_tree::internal_compute_root;
use quaireaux::utils;

#[test]
#[available_gas(2000000)]
fn merkle_tree_test() {
    let mut merkle_tree = MerkleTreeTrait::new();

    // Create a proof.
    let mut proof = ArrayTrait::<felt>::new();
    proof.append(1);
    proof.append(2);
    proof.append(3);

    let leaf = 123456;
    // Compute the root.
    let merkle_root = merkle_tree.compute_root(leaf, proof);

    // Create a valid proof.
    let mut valid_proof = ArrayTrait::<felt>::new();
    valid_proof.append(1);
    valid_proof.append(2);
    valid_proof.append(3);

    // Verify the proof.
    let valid_proof = merkle_tree.verify(merkle_root, leaf, valid_proof);
    assert(valid_proof == true, 'Proof should be valid');

    // Create an invalid proof.
    let mut invalid_proof = ArrayTrait::<felt>::new();
    invalid_proof.append(1);
    invalid_proof.append(2);
    invalid_proof.append(4);

    // Verify the proof.
    let valid_proof = merkle_tree.verify(merkle_root, leaf, invalid_proof);
    assert(valid_proof == false, 'Proof should be invalid');
}
