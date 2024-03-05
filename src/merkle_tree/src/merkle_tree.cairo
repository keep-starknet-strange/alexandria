//! MerkleTree implementation.
//!
//! # Examples
//!
//! ```
//! // This version uses the pedersen hash method because the PedersenHasherImpl is in the scope.
//! use alexandria_data_structures::merkle_tree::{Hasher, MerkleTree, pedersen::PedersenHasherImpl, MerkleTreeTrait};
//!
//! // Create a new merkle tree instance.
//! let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeTrait::new();
//! let mut proof = array![element_1, element_2];
//! // Compute the merkle root.
//! let root = merkle_tree.compute_root(leaf, proof);
//! ```
//!
//! ```
//! // This version uses the poseidon hash method because the PoseidonHasherImpl is in the scope.
//! use alexandria_data_structures::merkle_tree::{ Hasher, MerkleTree, poseidon::PoseidonHasherImpl, MerkleTreeTrait };
//!
//! // Create a new merkle tree instance.
//! let mut merkle_tree: MerkleTree<PoseidonHasher> = MerkleTreeTrait::new();
//! let mut proof = array![element_1, element_2];
//! // Compute the merkle root.
//! let root = merkle_tree.compute_root(leaf, proof);
//! ```

/// Hasher trait.

trait HasherTrait<T> {
    fn new() -> T;
    fn hash(ref self: T, data1: felt252, data2: felt252) -> felt252;
}


// Hasher representations.

#[derive(Drop, Copy)]
struct Hasher {}

/// Hasher impls.

mod pedersen {
    use hash::HashStateTrait;
    use super::{Hasher, HasherTrait};

    impl PedersenHasherImpl of HasherTrait<Hasher> {
        fn new() -> Hasher {
            Hasher {}
        }
        fn hash(ref self: Hasher, data1: felt252, data2: felt252) -> felt252 {
            pedersen::pedersen(data1, data2)
        }
    }
}

mod poseidon {
    use hash::HashStateTrait;
    use poseidon::hades_permutation;
    use super::{Hasher, HasherTrait};

    impl PoseidonHasherImpl of HasherTrait<Hasher> {
        fn new() -> Hasher {
            Hasher {}
        }
        fn hash(ref self: Hasher, data1: felt252, data2: felt252) -> felt252 {
            let (hash, _, _) = hades_permutation(data1, data2, 2);
            hash
        }
    }
}

/// MerkleTree representation.

#[derive(Drop)]
struct MerkleTree<T> {
    hasher: T
}

/// MerkleTree trait.
trait MerkleTreeTrait<T> {
    /// Create a new merkle tree instance.
    fn new() -> MerkleTree<T>;
    /// Compute the merkle root of a given proof.
    fn compute_root(
        ref self: MerkleTree<T>, current_node: felt252, proof: Span<felt252>
    ) -> felt252;
    /// Verify a merkle proof.
    fn verify(ref self: MerkleTree<T>, root: felt252, leaf: felt252, proof: Span<felt252>) -> bool;
    /// Compute a merkle proof of given leaves and at a given index.
    fn compute_proof(ref self: MerkleTree<T>, leaves: Array<felt252>, index: u32) -> Span<felt252>;
}

/// MerkleTree Legacy implementation.
impl MerkleTreeImpl<T, +HasherTrait<T>, +Copy<T>, +Drop<T>> of MerkleTreeTrait<T> {
    /// Create a new merkle tree instance.
    fn new() -> MerkleTree<T> {
        MerkleTree { hasher: HasherTrait::new() }
    }

    /// Compute the merkle root of a given proof using the generic T hasher.
    /// # Arguments
    /// * `current_node` - The current node of the proof.
    /// * `proof` - The proof.
    /// # Returns
    /// The merkle root.
    fn compute_root(
        ref self: MerkleTree<T>, mut current_node: felt252, mut proof: Span<felt252>
    ) -> felt252 {
        while let Option::Some(proof_element) = proof
            .pop_front() {
                // Compute the hash of the current node and the current element of the proof.
                // We need to check if the current node is smaller than the current element of the proof.
                // If it is, we need to swap the order of the hash.
                current_node =
                    if Into::<felt252, u256>::into(current_node) < (*proof_element).into() {
                        self.hasher.hash(current_node, *proof_element)
                    } else {
                        self.hasher.hash(*proof_element, current_node)
                    }
            };
        current_node
    }

    /// Verify a merkle proof using the generic T hasher.
    /// # Arguments
    /// * `root` - The merkle root.
    /// * `leaf` - The leaf to verify.
    /// * `proof` - The proof.
    /// # Returns
    /// True if the proof is valid, false otherwise.
    fn verify(
        ref self: MerkleTree<T>, root: felt252, mut leaf: felt252, mut proof: Span<felt252>
    ) -> bool {
        while let Option::Some(proof_element) = proof
            .pop_front() {
                // Compute the hash of the current node and the current element of the proof.
                // We need to check if the current node is smaller than the current element of the proof.
                // If it is, we need to swap the order of the hash.
                leaf =
                    if Into::<felt252, u256>::into(leaf) < (*proof_element).into() {
                        self.hasher.hash(leaf, *proof_element)
                    } else {
                        self.hasher.hash(*proof_element, leaf)
                    };
            };
        leaf == root
    }

    /// Compute a merkle proof of given leaves and at a given index using the generic T hasher.
    /// # Arguments
    /// * `leaves` - The sorted leaves.
    /// * `index` - The index of the given.
    /// # Returns
    /// The merkle proof.
    fn compute_proof(
        ref self: MerkleTree<T>, mut leaves: Array<felt252>, index: u32
    ) -> Span<felt252> {
        let mut proof: Array<felt252> = array![];
        compute_proof(leaves, self.hasher, index, ref proof);
        proof.span()
    }
}

/// Helper function to compute a merkle proof of given leaves and at a given index.
/// # Arguments
/// * `nodes` - The sorted nodes.
/// * `index` - The index of the given.
/// * `hasher` - The hasher to use.
/// * `proof` - The proof array to fill.
fn compute_proof<T, +HasherTrait<T>, +Drop<T>>(
    mut nodes: Array<felt252>, mut hasher: T, index: u32, ref proof: Array<felt252>
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
    let next_level: Array<felt252> = get_next_level(nodes.span(), ref hasher);

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

    compute_proof(next_level, hasher, index_parent, ref proof)
}

/// Helper function to compute the next layer of a merkle tree providing a layer of nodes.
/// # Arguments
/// * `nodes` - The sorted nodes.
/// * `hasher` - The hasher to use.
/// # Returns
/// The next layer of nodes.
fn get_next_level<T, +HasherTrait<T>, +Drop<T>>(
    mut nodes: Span<felt252>, ref hasher: T
) -> Array<felt252> {
    let mut next_level: Array<felt252> = array![];
    while let Option::Some(left) = nodes
        .pop_front() {
            let right = *nodes.pop_front().expect('Index out of bounds');
            let node = if Into::<felt252, u256>::into(*left) < right.into() {
                hasher.hash(*left, right)
            } else {
                hasher.hash(right, *left)
            };
            next_level.append(node);
        };
    next_level
}
