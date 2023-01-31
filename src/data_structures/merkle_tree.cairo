//! MerkleTree implementation.
//!
//! # Example
//! ```
//! use quaireaux::data_structures::merkle_tree::MerkleTreeTrait;
//!
//! // Create a new merkle tree instance.
//! let mut merkle_tree = MerkleTreeTrait::new();
//! let mut proof = ArrayTrait::<felt>::new();
//! proof.append(element_1);
//! proof.append(element_2);
//! // Compute the merkle root.
//! let root = merkle_tree.compute_root(leaf, proof);

// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;
use hash::LegacyHash;

/// MerkleTree representation.
#[derive(Drop)]
struct MerkleTree {}

/// MerkleTree trait.
trait MerkleTreeTrait {
    /// Create a new merkle tree instance.
    fn new() -> MerkleTree;
    /// Compute the merkle root of a given proof.
    fn compute_root(ref self: MerkleTree, current_node: felt, proof: Array::<felt>) -> felt;
    /// Verify a merkle proof.
    fn verify(ref self: MerkleTree, root: felt, leaf: felt, proof: Array::<felt>) -> bool;
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
    fn compute_root(ref self: MerkleTree, current_node: felt, mut proof: Array::<felt>) -> felt {
        let proof_len = proof.len();
        internal_compute_root(current_node, 0_u64, proof_len, proof)
    }

    /// Verify a merkle proof.
    /// # Arguments
    /// * `root` - The merkle root.
    /// * `leaf` - The leaf to verify.
    /// * `proof` - The proof.
    /// # Returns
    /// True if the proof is valid, false otherwise.
    fn verify(ref self: MerkleTree, root: felt, leaf: felt, mut proof: Array::<felt>) -> bool {
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
    current_node: felt, proof_index: u64, proof_len: usize, mut proof: Array::<felt>
) -> felt {
    // Check if out of gas.
    // Note: we need to call `get_gas_all(get_builtin_costs())` because we need to call `LegacyHash::hash`
    // which uses `Pedersen` builtin.
    // TODO: Remove when automatically handled by compiler.
    match get_gas_all(get_builtin_costs()) {
        Option::Some(_) => {},
        Option::None(_) => {
            let mut data = ArrayTrait::new();
            data.append('OOG');
            panic(data);
        }
    }
    // Loop until we have reached the end of the proof.
    if proof_len == 0_u64 {
        return current_node;
    }
    let mut node = 0;
    // Get the next element of the proof.
    let proof_element = ArrayTrait::at(ref proof, proof_index);

    // Compute the hash of the current node and the current element of the proof.
    // We need to check if the current node is smaller than the current element of the proof.
    // If it is, we need to swap the order of the hash.
    if current_node < proof_element {
        node = LegacyHash::hash(current_node, proof_element);
    } else {
        node = LegacyHash::hash(proof_element, current_node);
    }
    // Recursively compute the root.
    internal_compute_root(node, proof_index + 1_u64, proof_len - 1_u64, proof)
}

