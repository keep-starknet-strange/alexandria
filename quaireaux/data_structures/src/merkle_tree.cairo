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
use array::SpanTrait;
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
    fn compute_root(ref self: MerkleTree, current_node: felt252, proof: Span<felt252>) -> felt252;
    /// Verify a merkle proof.
    fn verify(ref self: MerkleTree, root: felt252, leaf: felt252, proof: Span<felt252>) -> bool;
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
        ref self: MerkleTree, mut current_node: felt252, mut proof: Span<felt252>
    ) -> felt252 {
        let mut proof_len = proof.len();
        let mut current_node = current_node;
        let mut proof_index = 0;

        // TODO We could pop_front proof and get rid of proof_len and proof_index
        // But due to a bug it cannot atm. 
        loop {
            if proof_len == 0 {
                break current_node;
            }
            // Get the next element of the proof.
            let proof_element = *proof[proof_index];

            // Compute the hash of the current node and the current element of the proof.
            // We need to check if the current node is smaller than the current element of the proof.
            // If it is, we need to swap the order of the hash.
            if current_node.into() < proof_element.into() {
                current_node = LegacyHash::hash(current_node, proof_element);
            } else {
                current_node = LegacyHash::hash(proof_element, current_node);
            }
            proof_index = proof_index + 1;
            proof_len = proof_len - 1;
        }
    }

    /// Verify a merkle proof.
    /// # Arguments
    /// * `root` - The merkle root.
    /// * `leaf` - The leaf to verify.
    /// * `proof` - The proof.
    /// # Returns
    /// True if the proof is valid, false otherwise.
    fn verify(
        ref self: MerkleTree, root: felt252, leaf: felt252, mut proof: Span<felt252>
    ) -> bool {
        let computed_root = self.compute_root(leaf, proof);
        computed_root == root
    }
}
