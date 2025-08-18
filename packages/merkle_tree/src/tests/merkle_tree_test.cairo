// Internal imports
use alexandria_merkle_tree::merkle_tree::pedersen::PedersenHasherImpl;
use alexandria_merkle_tree::merkle_tree::poseidon::PoseidonHasherImpl;
use alexandria_merkle_tree::merkle_tree::{Hasher, MerkleTree, MerkleTreeImpl};

mod regular_call_merkle_tree_pedersen {
    // Internal imports
    use alexandria_merkle_tree::merkle_tree::pedersen::PedersenHasherImpl;
    use alexandria_merkle_tree::merkle_tree::{Hasher, MerkleTree, MerkleTreeTrait};
    #[test]
    fn regular_call_merkle_tree_pedersen_test() {
        // [Setup] Merkle tree.
        let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeTrait::new();
        let root = 0x15ac9e457789ef0c56e5d559809e7336a909c14ee2511503fa7af69be1ba639;
        let leaf = 0x1;
        let valid_proof = array![
            0x2, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc,
        ]
            .span();
        let leaves = array![0x1, 0x2, 0x3];

        // [Assert] Compute merkle root.
        let computed_root = merkle_tree.compute_root(leaf, valid_proof);
        assert_eq!(computed_root, root);

        // [Assert] Compute merkle proof.
        let mut input_leaves = leaves;
        let index = 0;
        let computed_proof = merkle_tree.compute_proof(input_leaves, index);
        assert_eq!(computed_proof, valid_proof);

        // [Assert] Verify a valid proof.
        let result = merkle_tree.verify(root, leaf, valid_proof);
        assert!(result, "verify valid proof failed");

        // [Assert] Verify an invalid proof.
        let invalid_proof = array![
            0x2 + 1, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc,
        ]
            .span();
        let result = merkle_tree.verify(root, leaf, invalid_proof);
        assert!(!result, "verify invalid proof failed");

        // [Assert] Verify a valid proof with an invalid leaf.
        let invalid_leaf = 0x1 + 1;
        let result = merkle_tree.verify(root, invalid_leaf, valid_proof);
        assert!(!result, "wrong result");
    }
}

#[test]
fn merkle_tree_pedersen_test() {
    // [Setup] Merkle tree.
    let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeImpl::<_, PedersenHasherImpl>::new();
    let root = 0x15ac9e457789ef0c56e5d559809e7336a909c14ee2511503fa7af69be1ba639;
    let leaf = 0x1;
    let valid_proof = array![0x2, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc]
        .span();
    let leaves = array![0x1, 0x2, 0x3];

    // [Assert] Compute merkle root.
    let computed_root = MerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::compute_root(ref merkle_tree, leaf, valid_proof);
    assert_eq!(computed_root, root);

    // [Assert] Compute merkle proof.
    let mut input_leaves = leaves;
    let index = 0;
    let computed_proof = MerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::compute_proof(ref merkle_tree, input_leaves, index);
    assert_eq!(computed_proof, valid_proof);

    // [Assert] Verify a valid proof.
    let result = MerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::verify(ref merkle_tree, root, leaf, valid_proof);
    assert!(result, "verify valid proof failed");

    // [Assert] Verify an invalid proof.
    let invalid_proof = array![
        0x2 + 1, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc,
    ]
        .span();
    let result = MerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::verify(ref merkle_tree, root, leaf, invalid_proof);
    assert!(!result, "verify invalid proof failed");

    // [Assert] Verify a valid proof with an invalid leaf.
    let invalid_leaf = 0x1 + 1;
    let result = MerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::verify(ref merkle_tree, root, invalid_leaf, valid_proof);
    assert!(!result, "wrong result");
}

#[test]
fn merkle_tree_poseidon_test() {
    // [Setup] Merkle tree.
    let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeImpl::<_, PoseidonHasherImpl>::new();
    let root = 0x48924a3b2a7a7b7cc1c9371357e95e322899880a6534bdfe24e96a828b9d780;
    let leaf = 0x1;
    let valid_proof = array![0x2, 0x338eb608d7e48306d01f5a8d4275dd85a52ba79aaf7a1a7b35808ba573c3669]
        .span();
    let leaves = array![0x1, 0x2, 0x3];

    // [Assert] Compute merkle root.
    let computed_root = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::compute_root(ref merkle_tree, leaf, valid_proof);
    assert_eq!(computed_root, root);

    // [Assert] Compute merkle proof.
    let mut input_leaves = leaves;
    let index = 0;
    let computed_proof = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::compute_proof(ref merkle_tree, input_leaves, index);
    assert_eq!(computed_proof, valid_proof);

    // [Assert] Verify a valid proof.
    let result = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref merkle_tree, root, leaf, valid_proof);
    assert!(result, "verify valid proof failed");

    // [Assert] Verify an invalid proof.
    let invalid_proof = array![
        0x2 + 1, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc,
    ]
        .span();
    let result = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref merkle_tree, root, leaf, invalid_proof);
    assert!(!result, "verify invalid proof failed");

    // [Assert] Verify a valid proof with an invalid leaf.
    let invalid_leaf = 0x1 + 1;
    let result = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref merkle_tree, root, invalid_leaf, valid_proof);
    assert!(!result, "wrong result");
}

#[test]
fn test_odd_number_of_leaves() {
    // Test that merkle tree handles odd number of leaves correctly
    // using the blockchain standard of duplicating the last hash
    let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeImpl::<_, PoseidonHasherImpl>::new();

    // Test with 5 leaves (odd) - this was the original failing case
    let leaves_5 = array![1, 2, 3, 4, 5];
    let proof_5 = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::compute_proof(ref merkle_tree, leaves_5, 2);
    assert!(proof_5.len() > 0, "5 leaves should generate valid proof");

    // Verify the proof works
    let root_5 = MerkleTreeImpl::<_, PoseidonHasherImpl>::compute_root(ref merkle_tree, 3, proof_5);
    let is_valid_5 = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref merkle_tree, root_5, 3, proof_5);
    assert!(is_valid_5, "Proof for 5 leaves should be valid");

    // Test with 7 leaves (odd)
    let leaves_7 = array![10, 20, 30, 40, 50, 60, 70];
    let proof_7 = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::compute_proof(ref merkle_tree, leaves_7, 4);
    assert!(proof_7.len() > 0, "7 leaves should generate valid proof");

    // Verify the proof works
    let root_7 = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::compute_root(ref merkle_tree, 50, proof_7);
    let is_valid_7 = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref merkle_tree, root_7, 50, proof_7);
    assert!(is_valid_7, "Proof for 7 leaves should be valid");

    // Test with 9 leaves (odd)
    let leaves_9 = array![100, 200, 300, 400, 500, 600, 700, 800, 900];
    let proof_9 = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::compute_proof(ref merkle_tree, leaves_9, 6);
    assert!(proof_9.len() > 0, "9 leaves should generate valid proof");

    // Verify the proof works
    let root_9 = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::compute_root(ref merkle_tree, 700, proof_9);
    let is_valid_9 = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref merkle_tree, root_9, 700, proof_9);
    assert!(is_valid_9, "Proof for 9 leaves should be valid");
}

#[test]
fn test_single_leaf_edge_case() {
    // Test the edge case of a single leaf (gets paired with 0)
    let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeImpl::<_, PoseidonHasherImpl>::new();

    let single_leaf = array![42];
    let proof = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::compute_proof(ref merkle_tree, single_leaf, 0);

    // Single leaf gets padded to [42, 0], so proof should contain the sibling (0)
    assert!(proof.len() == 1, "Single leaf should have exactly 1 proof element");
    assert!(*proof.at(0) == 0, "Single leaf proof should contain 0 as sibling");

    let root = MerkleTreeImpl::<_, PoseidonHasherImpl>::compute_root(ref merkle_tree, 42, proof);
    let is_valid = MerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref merkle_tree, root, 42, proof);
    assert!(is_valid, "Single leaf proof should be valid");
}
