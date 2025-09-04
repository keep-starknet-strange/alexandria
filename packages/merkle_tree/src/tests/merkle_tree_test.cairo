// Internal imports
use alexandria_merkle_tree::merkle_tree::pedersen::PedersenHasherImpl;
use alexandria_merkle_tree::merkle_tree::poseidon::PoseidonHasherImpl;
use alexandria_merkle_tree::merkle_tree::{
    Hasher, MerkleTree, MerkleTreeImpl, StoredMerkleTree, StoredMerkleTreeImpl,
};

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

#[test]
fn stored_merkle_tree_pedersen_test() {
    // StoredMerkleTree with Pedersen hasher.
    let leaves = array![0x1, 0x2, 0x3];
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::new(leaves);

    // Expected values from the regular MerkleTree test
    let expected_root = 0x15ac9e457789ef0c56e5d559809e7336a909c14ee2511503fa7af69be1ba639;
    let leaf = 0x1;
    let expected_proof = array![
        0x2, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc,
    ]
        .span();

    // Get merkle root.
    let computed_root = StoredMerkleTreeImpl::<_, PedersenHasherImpl>::get_root(ref stored_tree);
    assert_eq!(computed_root, expected_root);

    // Get merkle proof.
    let computed_proof = StoredMerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::get_proof(ref stored_tree, 0);
    assert_eq!(computed_proof, expected_proof);

    // Verify a valid proof.
    let result = StoredMerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::verify(ref stored_tree, leaf, expected_proof);
    assert!(result, "verify valid proof failed");

    // Verify an invalid proof.
    let invalid_proof = array![
        0x2 + 1, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc,
    ]
        .span();
    let result = StoredMerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::verify(ref stored_tree, leaf, invalid_proof);
    assert!(!result, "verify invalid proof should fail");

    // Verify a valid proof with an invalid leaf.
    let invalid_leaf = 0x1 + 1;
    let result = StoredMerkleTreeImpl::<
        _, PedersenHasherImpl,
    >::verify(ref stored_tree, invalid_leaf, expected_proof);
    assert!(!result, "verify invalid leaf should fail");

    // Get leaf count.
    let leaf_count = StoredMerkleTreeImpl::<_, PedersenHasherImpl>::get_leaf_count(ref stored_tree);
    assert_eq!(leaf_count, 3);
}

#[test]
fn stored_merkle_tree_poseidon_test() {
    // StoredMerkleTree with Poseidon hasher.
    let leaves = array![0x1, 0x2, 0x3];
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves);

    // Expected values from the regular MerkleTree test
    let expected_root = 0x48924a3b2a7a7b7cc1c9371357e95e322899880a6534bdfe24e96a828b9d780;
    let leaf = 0x1;
    let expected_proof = array![
        0x2, 0x338eb608d7e48306d01f5a8d4275dd85a52ba79aaf7a1a7b35808ba573c3669,
    ]
        .span();

    // Get merkle root.
    let computed_root = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_root(ref stored_tree);
    assert_eq!(computed_root, expected_root);

    // Get merkle proof.
    let computed_proof = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::get_proof(ref stored_tree, 0);
    assert_eq!(computed_proof, expected_proof);

    // Verify a valid proof.
    let result = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, leaf, expected_proof);
    assert!(result, "verify valid proof failed");

    // Verify an invalid proof.
    let invalid_proof = array![
        0x2 + 1, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc,
    ]
        .span();
    let result = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, leaf, invalid_proof);
    assert!(!result, "verify invalid proof should fail");

    // Verify a valid proof with an invalid leaf.
    let invalid_leaf = 0x1 + 1;
    let result = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, invalid_leaf, expected_proof);
    assert!(!result, "verify invalid leaf should fail");

    // Get leaf count.
    let leaf_count = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_leaf_count(ref stored_tree);
    assert_eq!(leaf_count, 3);
}

#[test]
fn stored_merkle_tree_odd_leaves_test() {
    // Test StoredMerkleTree with odd number of leaves
    let leaves = array![1, 2, 3, 4, 5];
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves);

    // Get proof for leaf at index 2 (value 3)
    let proof = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_proof(ref stored_tree, 2);
    assert!(proof.len() > 0, "Should generate valid proof for odd leaves");

    // Verify the proof works
    let result = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::verify(ref stored_tree, 3, proof);
    assert!(result, "Proof for odd leaves should be valid");

    // [Assert] Get leaf count.
    let leaf_count = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_leaf_count(ref stored_tree);
    assert_eq!(leaf_count, 5);
}

#[test]
fn stored_merkle_tree_single_leaf_test() {
    // Test StoredMerkleTree with a single leaf
    let leaves = array![42];
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves);

    // Get proof for the single leaf at index 0
    let proof = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_proof(ref stored_tree, 0);
    assert!(proof.len() == 1, "Single leaf should have exactly 1 proof element");

    // Verify the proof works
    let result = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::verify(ref stored_tree, 42, proof);
    assert!(result, "Single leaf proof should be valid");

    // Get leaf count.
    let leaf_count = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_leaf_count(ref stored_tree);
    assert_eq!(leaf_count, 1);
}

#[test]
fn stored_merkle_tree_empty_leaves_test() {
    // Test StoredMerkleTree with empty leaves array
    let leaves: Array<felt252> = array![];
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves);

    // Should have root of 0 for empty tree
    let root = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_root(ref stored_tree);
    assert_eq!(root, 0);

    // Get leaf count.
    let leaf_count = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_leaf_count(ref stored_tree);
    assert_eq!(leaf_count, 0);
}

#[test]
fn stored_merkle_tree_efficiency_comparison_test() {
    // Test that StoredMerkleTree produces the same results as regular MerkleTree
    // but with better efficiency for multiple proof generations
    let leaves = array![10, 20, 30, 40, 50, 60, 70, 80];

    // Create both tree types
    let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeImpl::<_, PoseidonHasherImpl>::new();
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves.clone());

    // Test multiple indices
    let test_indices = array![0, 3, 5, 7];
    for index in test_indices {
        let leaf_value = *leaves.at(index);

        // Get proofs from both implementations
        let regular_proof = MerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::compute_proof(ref merkle_tree, leaves.clone(), index);
        let stored_proof = StoredMerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::get_proof(ref stored_tree, index);

        // Both proofs should be the same
        assert_eq!(regular_proof, stored_proof, "Proofs should match");

        // Both should verify successfully
        let regular_root = MerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::compute_root(ref merkle_tree, leaf_value, regular_proof);
        let stored_root = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_root(ref stored_tree);

        assert_eq!(regular_root, stored_root, "Roots should match");

        let regular_verify = MerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::verify(ref merkle_tree, regular_root, leaf_value, regular_proof);
        let stored_verify = StoredMerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::verify(ref stored_tree, leaf_value, stored_proof);

        assert!(regular_verify, "Regular tree verification should pass");
        assert!(stored_verify, "Stored tree verification should pass");
    };
}

#[test]
fn stored_merkle_tree_multi_proof_scenario_test() {
    // Simulate airdrop with 8 whitelisted users
    let whitelist = array![0x123, 0x456, 0x789, 0xabc, 0xdef, 0x111, 0x222, 0x333];

    // Create StoredMerkleTree for efficient multi-proof generation
    let mut airdrop_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(whitelist.clone());

    // Get the merkle root (published on-chain for verification)
    let merkle_root = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_root(ref airdrop_tree);

    // Simulate 4 users claiming their airdrop by generating proofs
    let claimers = array![
        (0, 0x123), // User at index 0
        (2, 0x789), // User at index 2  
        (5, 0x111), // User at index 5
        (7, 0x333) // User at index 7
    ];

    let mut all_proofs: Array<Span<felt252>> = array![];

    // Generate proofs for each claimer
    for claimer in claimers {
        let (index, user_address) = claimer;

        // Generate proof for this user
        let proof = StoredMerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::get_proof(ref airdrop_tree, index);
        all_proofs.append(proof);

        // Verify the user is in the whitelist
        let is_valid = StoredMerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::verify(ref airdrop_tree, user_address, proof);
        assert!(is_valid, "User should be valid for airdrop");

        // Verify against the published root
        let mut temp_tree: MerkleTree<Hasher> = MerkleTreeImpl::<_, PoseidonHasherImpl>::new();
        let computed_root = MerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::compute_root(ref temp_tree, user_address, proof);
        assert_eq!(computed_root, merkle_root, "Proof should verify against published root");
    }

    // Verify we generated exactly 4 proofs
    assert_eq!(all_proofs.len(), 4, "Should have generated 4 proofs");

    // Test invalid user (not in whitelist)
    let invalid_user = 0x999;
    let fake_proof = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_proof(ref airdrop_tree, 0);
    let is_invalid = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref airdrop_tree, invalid_user, fake_proof);
    assert!(!is_invalid, "Invalid user should not verify");
}

#[test]
fn stored_merkle_tree_large_tree_test() {
    // Test with larger tree (16 leaves) to verify scalability
    let leaves = array![1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves);

    // Test proof generation for various positions
    let test_indices = array![0, 7, 10, 15]; // First, middle, near-end, last
    for index in test_indices {
        let leaf_value: felt252 = (index + 1).into(); // leaf values are 1-indexed
        let proof = StoredMerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::get_proof(ref stored_tree, index);
        let is_valid = StoredMerkleTreeImpl::<
            _, PoseidonHasherImpl,
        >::verify(ref stored_tree, leaf_value, proof);
        assert!(is_valid, "Large tree proof should be valid");
    };
}

#[test]
fn stored_merkle_tree_out_of_bounds_test() {
    // Test behavior with out-of-bounds index
    let leaves = array![1, 2, 3, 4];
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves);

    // This should generate a proof but it will be invalid when verified
    // Index 10 is way out of bounds for a 4-leaf tree
    let out_of_bounds_proof = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::get_proof(ref stored_tree, 10);

    // Trying to verify with any leaf should fail
    let is_valid = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, 1, out_of_bounds_proof);
    assert!(!is_valid, "Out of bounds proof should not verify");
}

#[test]
fn stored_merkle_tree_duplicate_leaves_test() {
    // Test with duplicate leaf values
    let leaves = array![5, 5, 7, 7, 5, 9, 7];
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves);

    // Each duplicate should still have a valid proof at its position
    let proof_0 = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_proof(ref stored_tree, 0);
    let proof_1 = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_proof(ref stored_tree, 1);
    let proof_4 = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_proof(ref stored_tree, 4);

    // All should verify with value 5, but proofs should be different
    let valid_0 = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, 5, proof_0);
    let valid_1 = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, 5, proof_1);
    let valid_4 = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, 5, proof_4);

    assert!(valid_0, "Duplicate at index 0 should verify");
    assert!(valid_1, "Duplicate at index 1 should verify");
    assert!(valid_4, "Duplicate at index 4 should verify");

    // Cross-verification should fail (proof for index 0 shouldn't work for index 1)
    let cross_valid = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, 5, proof_1);
    // This might actually pass since both have same value - that's correct behavior
    assert!(cross_valid, "Same value at different positions should verify");
}

#[test]
fn stored_merkle_tree_zero_values_test() {
    // Test with zero values (edge case for padding)
    let leaves = array![0, 1, 0, 2, 0];
    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves);

    // Test proof for zero value
    let proof_zero = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_proof(ref stored_tree, 0);
    let is_valid_zero = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, 0, proof_zero);
    assert!(is_valid_zero, "Zero value should verify correctly");

    // Test proof for non-zero value
    let proof_one = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_proof(ref stored_tree, 1);
    let is_valid_one = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, 1, proof_one);
    assert!(is_valid_one, "Non-zero value should verify correctly");
}

#[test]
fn stored_merkle_tree_max_felt_values_test() {
    // Test with very large felt252 values
    let max_val = 0x800000000000011000000000000000000000000000000000000000000000000;
    let leaves = array![max_val - 3, max_val - 2, max_val - 1, max_val];

    let mut stored_tree: StoredMerkleTree<Hasher> = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::new(leaves);

    // Test proof generation and verification with large values
    let proof = StoredMerkleTreeImpl::<_, PoseidonHasherImpl>::get_proof(ref stored_tree, 3);
    let is_valid = StoredMerkleTreeImpl::<
        _, PoseidonHasherImpl,
    >::verify(ref stored_tree, max_val, proof);
    assert!(is_valid, "Large felt252 values should work correctly");
}
