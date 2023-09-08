//! MerkleTree implementation.
//!
//! # Example
//! ```
//! use alexandria::data_structures::merkle_tree::{MerkleTree, HashMethod, MerkleTreeTrait};
//!
//! // Create a new merkle tree legacy instance, this version uses the pedersen hash method.
//! let hash_method = HashMethod::Pedersen(());
//! let mut merkle_tree: MerkleTree = MerkleTreeTrait::new(hash_method);
//! let mut proof = array![];
//! proof.append(element_1);
//! proof.append(element_2);
//! // Compute the merkle root.
//! let root = merkle_tree.compute_root(leaf, proof);
//!
//! // Create a new merkle tree instance, this version uses the poseidon hash method.
//! let hash_method = HashMethod::Poseidon(());
//! let mut merkle_tree: MerkleTree = MerkleTreeTrait::new(hash_method);
//! let mut proof = array![];
//! proof.append(element_1);
//! proof.append(element_2);
//! // Compute the merkle root.
//! let root = merkle_tree.compute_root(leaf, proof);

// Core lib imports
use array::{ArrayTrait, SpanTrait};
use pedersen::PedersenTrait;
use poseidon::PoseidonTrait;
use hash::HashStateTrait;
use traits::Into;

/// MerkleTree representations.
#[derive(Drop)]
struct MerkleTree {
    hash_method: HashMethod,
}

#[derive(Serde, Copy, Drop)]
enum HashMethod {
    Pedersen: (),
    Poseidon: (),
}

/// MerkleTree trait.
trait MerkleTreeTrait<T> {
    /// Create a new merkle tree instance.
    fn new(hash_method: HashMethod) -> T;
    /// Compute the merkle root of a given proof.
    fn compute_root(ref self: T, current_node: felt252, proof: Span<felt252>) -> felt252;
    /// Verify a merkle proof.
    fn verify(ref self: T, root: felt252, leaf: felt252, proof: Span<felt252>) -> bool;
    /// Compute a merkle proof of given leaves and at a given index.
    fn compute_proof(ref self: T, leaves: Array<felt252>, index: u32) -> Span<felt252>;
}

/// MerkleTree Legacy implementation.
impl MerkleTreeImpl of MerkleTreeTrait<MerkleTree> {
    /// Create a new merkle tree instance.
    #[inline(always)]
    fn new(hash_method: HashMethod) -> MerkleTree {
        MerkleTree { hash_method }
    }

    /// Compute the merkle root of a given proof using the pedersen hash method.
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
                    current_node = match self.hash_method {
                        HashMethod::Pedersen(()) => {
                            if Into::<felt252, u256>::into(current_node) < (*proof_element).into() {
                                let mut state = PedersenTrait::new(current_node);
                                state = state.update(*proof_element);
                                state.finalize()
                            } else {
                                let mut state = PedersenTrait::new(*proof_element);
                                state = state.update(current_node);
                                state.finalize()
                            }
                        },
                        HashMethod::Poseidon(()) => {
                            let mut state = PoseidonTrait::new();
                            if Into::<felt252, u256>::into(current_node) < (*proof_element).into() {
                                state = state.update(current_node);
                                state = state.update(*proof_element);
                            } else {
                                state = state.update(*proof_element);
                                state = state.update(current_node);
                            };
                            state.finalize()
                        },
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

    /// Compute a merkle proof of given leaves and at a given index using the pedersen hash method.
    /// # Arguments
    /// * `leaves` - The sorted leaves.
    /// * `index` - The index of the given.
    /// # Returns
    /// The merkle proof.
    fn compute_proof(
        ref self: MerkleTree, mut leaves: Array<felt252>, index: u32
    ) -> Span<felt252> {
        let mut proof: Array<felt252> = array![];
        _compute_proof(leaves, index, self.hash_method, ref proof);
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
fn _get_next_level(mut nodes: Span<felt252>, hash_method: HashMethod) -> Array<felt252> {
    let mut next_level: Array<felt252> = array![];
    loop {
        if nodes.is_empty() {
            break;
        }
        let left = *nodes.pop_front().expect('Index out of bounds');
        let right = *nodes.pop_front().expect('Index out of bounds');
        let node = match hash_method {
            HashMethod::Pedersen(()) => {
                if Into::<felt252, u256>::into(left) < right.into() {
                    let mut state = PedersenTrait::new(left);
                    state = state.update(right);
                    state.finalize()
                } else {
                    let mut state = PedersenTrait::new(right);
                    state = state.update(left);
                    state.finalize()
                }
            },
            HashMethod::Poseidon(()) => {
                let mut state = PoseidonTrait::new();
                if Into::<felt252, u256>::into(left) < right.into() {
                    state = state.update(left);
                    state = state.update(right);
                } else {
                    state = state.update(right);
                    state = state.update(left);
                };
                state.finalize()
            },
        };
        next_level.append(node);
    };
    next_level
}
