//! MerkleTree implementation.
//!
//! # Example
//! ```
//! use quaireaux_data_structures::merkle_tree::MerkleTreeTrait;
//!
//! // Create a new merkle tree instance.
//! let mut merkle_tree = MerkleTreeTrait::new();
//! let mut proof = ArrayTrait::new();
//! proof.append(element_1);
//! proof.append(element_2);
//! // Compute the merkle root.
//! let root = merkle_tree.compute_root(leaf, proof);

// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;
use hash::LegacyHash;
use traits::Into;

/// MerkleTree representation.
#[derive(Drop)]
struct MerkleTree {}

/// MerkleTree trait.
trait MerkleTreeTrait {
    /// Create a new merkle tree instance.
    fn new() -> MerkleTree;
    /// Compute the merkle root of a given proof.
    fn compute_root(ref self: MerkleTree, current_node: felt252, proof: Array<felt252>) -> felt252;
    /// Verify a merkle proof.
    fn verify(ref self: MerkleTree, root: felt252, leaf: felt252, proof: Array<felt252>) -> bool;
}

/// MerkleTree implementation.
impl MerkleTreeImpl of MerkleTreeTrait {
    /// Create a new merkle tree instance.
    #[inline(always)]
    fn new() -> MerkleTree {
        MerkleTree {}
    }

    /// Compute the merkle root of a given proof.
    /// # Arguments
    /// * `current_node` - The current node of the proof.
    /// * `proof` - The proof.
    /// # Returns
    /// The merkle root.
    fn compute_root(
        ref self: MerkleTree, current_node: felt252, mut proof: Array<felt252>
    ) -> felt252 {
        let proof_len = proof.len();
        internal_compute_root(current_node, 0, proof_len, proof)
    }

    /// Verify a merkle proof.
    /// # Arguments
    /// * `root` - The merkle root.
    /// * `leaf` - The leaf to verify.
    /// * `proof` - The proof.
    /// # Returns
    /// True if the proof is valid, false otherwise.
    fn verify(
        ref self: MerkleTree, root: felt252, leaf: felt252, mut proof: Array<felt252>
    ) -> bool {
        let computed_root = self.compute_root(leaf, proof);
        computed_root == root
    }
}

/// Compute the merkle root of a given proof.
/// This is an internal function that is used to recursively compute the merkle root.
/// # Arguments
/// * `current_node` - The current node of the proof.
/// * `proof_index` - The current index of the proof.
/// * `proof_len` - The length of the proof.
/// * `proof` - The proof.
/// # Returns
/// The merkle root.
fn internal_compute_root(
    current_node: felt252, proof_index: u32, proof_len: usize, mut proof: Array<felt252>
) -> felt252 {
    // Check if out of gas.
    // Note: we need to call `check_gas()` because we need to call `LegacyHash::hash`
    // which uses `Pedersen` builtin.
    quaireaux_utils::check_gas();

    // Loop until we have reached the end of the proof.
    if proof_len == 0 {
        return current_node;
    }
    let mut node = 0;
    // Get the next element of the proof.
    let proof_element = *proof[proof_index];

    // Compute the hash of the current node and the current element of the proof.
    // We need to check if the current node is smaller than the current element of the proof.
    // If it is, we need to swap the order of the hash.
    if current_node.into() < proof_element.into() {
        node = LegacyHash::hash(current_node, proof_element);
    } else {
        node = LegacyHash::hash(proof_element, current_node);
    }
    // Recursively compute the root.
    internal_compute_root(node, proof_index + 1, proof_len - 1, proof)
}
