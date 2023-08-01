// Core lib imports
use array::ArrayTrait;
use hash::LegacyHash;
// Internal imports
use alexandria::data_structures::merkle_tree::{MerkleTree, MerkleTreeTrait};

#[test]
#[available_gas(2000000)]
fn merkle_tree_test() {
    let mut merkle_tree = MerkleTreeTrait::new();
    // Create a proof.
    let proof = generate_proof_2_elements(
        275015828570532818958877094293872118179858708489648969448465143543997518327,
        3081470326846576744486900207655708080595997326743041181982939514729891127832
    );

    let leaf = 1743721452664603547538108163491160873761573033120794192633007665066782417603;
    let expected_merkle_root =
        455571898402516024591265345720711356365422160584912150000578530706912124657;
    test_case_compute_root(ref merkle_tree, proof, leaf, expected_merkle_root);

    // Create a valid proof.
    let mut valid_proof = generate_proof_2_elements(
        275015828570532818958877094293872118179858708489648969448465143543997518327,
        3081470326846576744486900207655708080595997326743041181982939514729891127832
    );
    // Verify the proof is valid.
    test_case_verify(ref merkle_tree, expected_merkle_root, leaf, valid_proof, true);

    // Create an invalid proof.
    let invalid_proof = generate_proof_2_elements(
        275015828570532818958877094293872118179858708489648969448465143543997518327 + 1,
        3081470326846576744486900207655708080595997326743041181982939514729891127832
    );
    // Verify the proof is invalid.
    test_case_verify(ref merkle_tree, expected_merkle_root, leaf, invalid_proof, false);

    // Create a valid proof but we will pass a wrong leaf.
    let valid_proof = generate_proof_2_elements(
        275015828570532818958877094293872118179858708489648969448465143543997518327,
        3081470326846576744486900207655708080595997326743041181982939514729891127832
    );
    // Verify the proof is invalid when passed the wrong leaf to verify.
    test_case_verify(
        ref merkle_tree,
        expected_merkle_root,
        1743721452664603547538108163491160873761573033120794192633007665066782417603 + 1,
        valid_proof,
        false
    );
}

fn test_case_compute_root(
    ref merkle_tree: MerkleTree, proof: Array<felt252>, leaf: felt252, expected_root: felt252
) {
    let mut merkle_tree = MerkleTreeTrait::new();
    let root = merkle_tree.compute_root(leaf, proof.span());
    assert(root == expected_root, 'wrong result');
}

fn test_case_verify(
    ref merkle_tree: MerkleTree,
    root: felt252,
    leaf: felt252,
    proof: Array<felt252>,
    expected_result: bool
) {
    let result = merkle_tree.verify(root, leaf, proof.span());
    assert(result == expected_result, 'wrong result');
}

fn generate_proof_2_elements(element_1: felt252, element_2: felt252) -> Array<felt252> {
    array![element_1, element_2]
}
