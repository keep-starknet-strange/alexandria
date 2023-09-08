//! MerkleTree implementation.
//!
//! # Example
//! ```
//! use alexandria::data_structures::merkle_tree::{MerklTree, MerkleTreeLegacy, MerkleTreeTrait};
//!
//! // Create a new merkle tree legacy instance, this version uses the pedersen hash method.
//! let mut merkle_tree: MerkleTreeLegacy = MerkleTreeTrait::new();
//! let mut proof = array![];
//! proof.append(element_1);
//! proof.append(element_2);
//! // Compute the merkle root.
//! let root = merkle_tree.compute_root(leaf, proof);
//!
//! // Create a new merkle tree instance, this version uses the poseidon hash method.
//! let mut merkle_tree: MerkleTree = MerkleTreeTrait::new();
//! let mut proof = array![];
//! proof.append(element_1);
//! proof.append(element_2);
//! // Compute the merkle root.
//! let root = merkle_tree.compute_root(leaf, proof);

// Core lib imports
use array::{ArrayTrait, SpanTrait};
use hash::LegacyHash;
use poseidon::poseidon_hash_span;
use traits::Into;

/// MerkleTree Legacy representation.
#[derive(Drop)]
struct MerkleTreeLegacy {}

/// MerkleTree representation.
#[derive(Drop)]
struct MerkleTree {}

#[derive(Serde, Copy, Drop)]
enum HashMethod {
    Pedersen: (),
    Poseidon: (),
}

/// MerkleTree trait.
trait MerkleTreeTrait<T> {
    /// Create a new merkle tree instance.
    fn new() -> T;
    /// Compute the merkle root of a given proof.
    fn compute_root(ref self: T, current_node: felt252, proof: Span<felt252>) -> felt252;
    /// Verify a merkle proof.
    fn verify(ref self: T, root: felt252, leaf: felt252, proof: Span<felt252>) -> bool;
    /// Compute a merkle proof of given leaves and at a given index.
    fn compute_proof(ref self: T, leaves: Array<felt252>, index: u32) -> Span<felt252>;
}

/// MerkleTree Legacy implementation.
impl MerkleTreeLegacyImpl of MerkleTreeTrait<MerkleTreeLegacy> {
    /// Create a new merkle tree instance.
    #[inline(always)]
    fn new() -> MerkleTreeLegacy {
        MerkleTreeLegacy {}
    }

    /// Compute the merkle root of a given proof using the pedersen hash method.
    /// # Arguments
    /// * `current_node` - The current node of the proof.
    /// * `proof` - The proof.
    /// # Returns
    /// The merkle root.
    fn compute_root(
        ref self: MerkleTreeLegacy, mut current_node: felt252, mut proof: Span<felt252>
    ) -> felt252 {
        loop {
            match proof.pop_front() {
                Option::Some(proof_element) => {
                    // Compute the pedersen hash of the current node and the current element of the proof.
                    // We need to check if the current node is smaller than the current element of the proof.
                    // If it is, we need to swap the order of the hash.
                    current_node =
                        if Into::<felt252, u256>::into(current_node) < (*proof_element).into() {
                            LegacyHash::hash(current_node, *proof_element)
                        } else {
                            LegacyHash::hash(*proof_element, current_node)
                        };
                },
                Option::None => {
                    break current_node;
                },
            };
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
        ref self: MerkleTreeLegacy, root: felt252, leaf: felt252, mut proof: Span<felt252>
    ) -> bool {
        let computed_root = self.compute_root(leaf, proof);
        computed_root == root
    }

    /// Compute a merkle proof of given leaves and at a given index using the pedersen hash method.
    /// # Arguments
    /// * `leaves` - The sorted leaves.
    /// * `index` - The index of the given.
    /// # Returns
    /// The merkle proof.
    fn compute_proof(
        ref self: MerkleTreeLegacy, mut leaves: Array<felt252>, index: u32
    ) -> Span<felt252> {
        let mut proof: Array<felt252> = array![];
        _compute_proof(leaves, index, HashMethod::Pedersen(()), ref proof);
        proof.span()
    }
}

/// MerkleTree legacy implementation.
impl MerkleTreeImpl of MerkleTreeTrait<MerkleTree> {
    /// Create a new merkle tree instance.
    #[inline(always)]
    fn new() -> MerkleTree {
        MerkleTree {}
    }

    /// Compute the merkle root of a given proof using the poseidon hash method.
    /// # Arguments
    /// * `current_node` - The current node of the proof.
    /// * `proof` - The proof.
    /// # Returns
    /// The merkle root.
    fn compute_root(
        ref self: MerkleTree, mut current_node: felt252, mut proof: Span<felt252>
    ) -> felt252 {
        loop {
            match proof.pop_front() {
                Option::Some(proof_element) => {
                    // Compute the hash of the current node and the current element of the proof.
                    // We need to check if the current node is smaller than the current element of the proof.
                    // If it is, we need to swap the order of the hash.
                    current_node =
                        if Into::<felt252, u256>::into(current_node) < (*proof_element).into() {
                            poseidon_hash_span(array![current_node, *proof_element].span())
                        } else {
                            poseidon_hash_span(array![*proof_element, current_node].span())
                        };
                },
                Option::None => {
                    break current_node;
                },
            };
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

    /// Compute a merkle proof of given leaves and at a given index using the poseidon hash method.
    /// # Arguments
    /// * `leaves` - The sorted leaves.
    /// * `index` - The index of the given.
    /// # Returns
    /// The merkle proof.
    fn compute_proof(
        ref self: MerkleTree, mut leaves: Array<felt252>, index: u32
    ) -> Span<felt252> {
        let mut proof: Array<felt252> = array![];
        _compute_proof(leaves, index, HashMethod::Poseidon(()), ref proof);
        proof.span()
    }
}

/// Helper function to compute a merkle proof of given leaves and at a given index.
/// # Arguments
/// * `nodes` - The sorted nodes.
/// * `index` - The index of the given.
/// * `method` - The hash method to use.
/// * `proof` - The proof array to fill.
fn _compute_proof(
    mut nodes: Array<felt252>, index: u32, method: HashMethod, ref proof: Array<felt252>
) {
    // Break if we have reached the top of the tree
    if nodes.len() == 1 {
        return;
    }

    // If odd number of nodes, add a null virtual leaf
    if nodes.len() % 2 != 0 {
        nodes.append(0);
    }

    // Compute next level
    let mut next_level: Array<felt252> = _get_next_level(nodes.span(), method);

    // Find neighbor node
    let mut index_parent = 0;
    let mut i = 0;
    loop {
        if i == index {
            index_parent = i / 2;
            if i % 2 == 0 {
                proof.append(*nodes.at(i + 1));
            } else {
                proof.append(*nodes.at(i - 1));
            }
            break;
        }
        i += 1;
    };

    _compute_proof(next_level, index_parent, method, ref proof)
}

/// Helper function to compute the next layer of a merkle tree providing a layer of nodes.
/// # Arguments
/// * `nodes` - The sorted nodes.
/// * `method` - The hash method to use.
/// # Returns
/// The next layer of nodes.
fn _get_next_level(mut nodes: Span<felt252>, method: HashMethod) -> Array<felt252> {
    let mut next_level: Array<felt252> = array![];
    loop {
        if nodes.is_empty() {
            break;
        }
        let left = *nodes.pop_front().expect('Index out of bounds');
        let right = *nodes.pop_front().expect('Index out of bounds');
        let node = if Into::<felt252, u256>::into(left) < right.into() {
            match method {
                HashMethod::Pedersen => LegacyHash::hash(left, right),
                HashMethod::Poseidon => poseidon_hash_span(array![left, right].span()),
            }
        } else {
            match method {
                HashMethod::Pedersen => LegacyHash::hash(right, left),
                HashMethod::Poseidon => poseidon_hash_span(array![right, left].span()),
            }
        };
        next_level.append(node);
    };
    next_level
}
