// Core lib imports
use array::ArrayTrait;
// Internal imports
use quaireaux::data_structures::merkle_tree::MerkleTreeTrait;

#[test]
#[available_gas(200000)]
fn merkle_tree_test() {
    let mut merkle_tree = MerkleTreeTrait::new();
    let mut proof = ArrayTrait::<felt>::new();

    let leaf = 1234;
    let merkle_root = merkle_tree.compute_root(leaf, proof);
    debug::print_felt(merkle_root);
}
