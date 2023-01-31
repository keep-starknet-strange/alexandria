// Core lib imports
use array::ArrayTrait;
use hash::LegacyHash;
// Internal imports
use quaireaux::data_structures::merkle_tree::MerkleTree;
use quaireaux::data_structures::merkle_tree::MerkleTreeTrait;
use quaireaux::data_structures::merkle_tree::internal_compute_root;
use quaireaux::utils;

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
    ref merkle_tree: MerkleTree, proof: Array::<felt>, leaf: felt, expected_root: felt
) {
    let mut merkle_tree = MerkleTreeTrait::new();
    let root = merkle_tree.compute_root(leaf, proof);
    assert(root == expected_root, 'Root should be equal to expected root');
}

fn test_case_verify(
    ref merkle_tree: MerkleTree, root: felt, leaf: felt, proof: Array::<felt>, expected_result: bool
) {
    let result = merkle_tree.verify(root, leaf, proof);
    assert(result == expected_result, 'Result should be equal to expected result');
}

fn generate_proof_2_elements(element_1: felt, element_2: felt) -> Array::<felt> {
    let mut proof = ArrayTrait::<felt>::new();
    proof.append(element_1);
    proof.append(element_2);
    proof
}
