// Internal imports
use alexandria_merkle_tree::merkle_tree::{
    Hasher, MerkleTree, pedersen::PedersenHasherImpl, poseidon::PoseidonHasherImpl, MerkleTreeTrait,
    MerkleTreeImpl
};


mod regular_call_merkle_tree_pedersen {
    // Internal imports
    use alexandria_merkle_tree::merkle_tree::{
        Hasher, MerkleTree, pedersen::PedersenHasherImpl, MerkleTreeTrait,
    };
    #[test]
    #[available_gas(2000000)]
    fn regular_call_merkle_tree_pedersen_test() {
        // [Setup] Merkle tree.
        let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeTrait::new();
        let root = 0x15ac9e457789ef0c56e5d559809e7336a909c14ee2511503fa7af69be1ba639;
        let leaf = 0x1;
        let valid_proof = array![
            0x2, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc
        ]
            .span();
        let leaves = array![0x1, 0x2, 0x3];

        // [Assert] Compute merkle root.
        let computed_root = merkle_tree.compute_root(leaf, valid_proof);
        assert!(computed_root == root, "compute valid root failed");

        // [Assert] Compute merkle proof.
        let mut input_leaves = leaves;
        let index = 0;
        let computed_proof = merkle_tree.compute_proof(input_leaves, index);
        assert!(computed_proof == valid_proof, "compute valid proof failed");

        // [Assert] Verify a valid proof.
        let result = merkle_tree.verify(root, leaf, valid_proof);
        assert!(result, "verify valid proof failed");

        // [Assert] Verify an invalid proof.
        let invalid_proof = array![
            0x2 + 1, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc
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
#[available_gas(2000000)]
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
        _, PedersenHasherImpl
    >::compute_root(ref merkle_tree, leaf, valid_proof);
    assert!(computed_root == root, "compute valid root failed");

    // [Assert] Compute merkle proof.
    let mut input_leaves = leaves;
    let index = 0;
    let computed_proof = MerkleTreeImpl::<
        _, PedersenHasherImpl
    >::compute_proof(ref merkle_tree, input_leaves, index);
    assert!(computed_proof == valid_proof, "compute valid proof failed");

    // [Assert] Verify a valid proof.
    let result = MerkleTreeImpl::<
        _, PedersenHasherImpl
    >::verify(ref merkle_tree, root, leaf, valid_proof);
    assert!(result, "verify valid proof failed");

    // [Assert] Verify an invalid proof.
    let invalid_proof = array![
        0x2 + 1, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc
    ]
        .span();
    let result = MerkleTreeImpl::<
        _, PedersenHasherImpl
    >::verify(ref merkle_tree, root, leaf, invalid_proof);
    assert!(!result, "verify invalid proof failed");

    // [Assert] Verify a valid proof with an invalid leaf.
    let invalid_leaf = 0x1 + 1;
    let result = MerkleTreeImpl::<
        _, PedersenHasherImpl
    >::verify(ref merkle_tree, root, invalid_leaf, valid_proof);
    assert!(!result, "wrong result");
}

#[test]
#[available_gas(2000000)]
fn merkle_tree_poseidon_test() {
    // [Setup] Merkle tree.
    let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeImpl::<_, PoseidonHasherImpl>::new();
    let root = 0x7abc09d19c8a03abd4333a23f7823975c7bdd325170f0d32612b8baa1457d47;
    let leaf = 0x1;
    let valid_proof = array![0x2, 0x47ef3ad11ad3f8fc055281f1721acd537563ec134036bc4bd4de2af151f0832]
        .span();
    let leaves = array![0x1, 0x2, 0x3];

    // [Assert] Compute merkle root.
    let computed_root = MerkleTreeImpl::<
        _, PoseidonHasherImpl
    >::compute_root(ref merkle_tree, leaf, valid_proof);
    assert!(computed_root == root, "compute valid root failed");

    // [Assert] Compute merkle proof.
    let mut input_leaves = leaves;
    let index = 0;
    let computed_proof = MerkleTreeImpl::<
        _, PoseidonHasherImpl
    >::compute_proof(ref merkle_tree, input_leaves, index);
    assert!(computed_proof == valid_proof, "compute valid proof failed");

    // [Assert] Verify a valid proof.
    let result = MerkleTreeImpl::<
        _, PoseidonHasherImpl
    >::verify(ref merkle_tree, root, leaf, valid_proof);
    assert!(result, "verify valid proof failed");

    // [Assert] Verify an invalid proof.
    let invalid_proof = array![
        0x2 + 1, 0x68ba2a188dd231112c1cb5aaa5d18be6d84f6c8683e5c3a6638dee83e727acc
    ]
        .span();
    let result = MerkleTreeImpl::<
        _, PoseidonHasherImpl
    >::verify(ref merkle_tree, root, leaf, invalid_proof);
    assert!(!result, "verify invalid proof failed");

    // [Assert] Verify a valid proof with an invalid leaf.
    let invalid_leaf = 0x1 + 1;
    let result = MerkleTreeImpl::<
        _, PoseidonHasherImpl
    >::verify(ref merkle_tree, root, invalid_leaf, valid_proof);
    assert!(!result, "wrong result");
}
