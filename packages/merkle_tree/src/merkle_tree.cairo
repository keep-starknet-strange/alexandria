//! MerkleTree implementation.
//!
//! ## Examples
//!
//! ```
//! // This version uses the pedersen hash method because the PedersenHasherImpl is in the scope.
//! use alexandria_data_structures::merkle_tree::{Hasher, MerkleTree, pedersen::PedersenHasherImpl,
//! MerkleTreeTrait};
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
//! use alexandria_data_structures::merkle_tree::{ Hasher, MerkleTree, poseidon::PoseidonHasherImpl,
//! MerkleTreeTrait };
//!
//! // Create a new merkle tree instance.
//! let mut merkle_tree: MerkleTree<PoseidonHasher> = MerkleTreeTrait::new();
//! let mut proof = array![element_1, element_2];
//! // Compute the merkle root.
//! let root = merkle_tree.compute_root(leaf, proof);
//! ```

/// Hasher trait.

pub trait HasherTrait<T> {
    fn new() -> T;
    fn hash(ref self: T, data1: felt252, data2: felt252) -> felt252;
}


// Hasher representations.

#[derive(Drop, Copy)]
pub struct Hasher {}

/// Hasher impls.

pub mod pedersen {
    use super::{Hasher, HasherTrait};

    pub impl PedersenHasherImpl of HasherTrait<Hasher> {
        fn new() -> Hasher {
            Hasher {}
        }
        fn hash(ref self: Hasher, data1: felt252, data2: felt252) -> felt252 {
            core::pedersen::pedersen(data1, data2)
        }
    }
}

pub mod poseidon {
    use core::poseidon::hades_permutation;
    use super::{Hasher, HasherTrait};

    pub impl PoseidonHasherImpl of HasherTrait<Hasher> {
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
pub struct MerkleTree<T> {
    hasher: T,
}

/// Efficient MerkleTree with pre-built tree storage for O(log n) proof generation.
///
/// ## When to use StoredMerkleTree vs MerkleTree:
///
/// **Use StoredMerkleTree when:**
/// - Generating 2+ proofs from the same tree (35% gas savings for multiple proofs)
/// - Need consistent O(log n) performance for proof generation
///
/// **Use regular MerkleTree when:**
/// - Only generating 1 proof (70% less gas for single proof)
/// - Memory/storage is constrained
/// - Tree data changes frequently (StoredMerkleTree requires rebuilding)
///
/// ## Gas Comparison (8 leaves):
/// - Single proof: MerkleTree 96k gas vs StoredMerkleTree 165k gas
/// - Multiple proofs (4x): MerkleTree 378k gas vs StoredMerkleTree 247k gas (35% savings)
#[derive(Drop)]
pub struct StoredMerkleTree<T> {
    hasher: T,
    levels: Array<Array<felt252>>,
    leaf_count: u32,
}

/// MerkleTree trait defining operations for Merkle tree construction and verification.
pub trait MerkleTreeTrait<T> {
    /// Create a new merkle tree instance.
    /// #### Returns
    /// * `MerkleTree<T>` - A new merkle tree with the specified hasher type
    fn new() -> MerkleTree<T>;

    /// Compute the merkle root of a given proof by iteratively hashing with proof elements.
    /// #### Arguments
    /// * `self` - The merkle tree instance
    /// * `current_node` - The starting leaf node (felt252 hash value)
    /// * `proof` - Array of sibling hashes needed to compute the root
    /// #### Returns
    /// * `felt252` - The computed merkle root hash
    fn compute_root(
        ref self: MerkleTree<T>, current_node: felt252, proof: Span<felt252>,
    ) -> felt252;

    /// Verify that a leaf belongs to the merkle tree with the given root.
    /// #### Arguments
    /// * `self` - The merkle tree instance
    /// * `root` - The expected merkle root hash
    /// * `leaf` - The leaf value to verify
    /// * `proof` - Array of sibling hashes for verification path
    /// #### Returns
    /// * `bool` - True if the leaf is valid for the given root, false otherwise
    fn verify(ref self: MerkleTree<T>, root: felt252, leaf: felt252, proof: Span<felt252>) -> bool;

    /// Generate a merkle proof for a specific leaf at the given index.
    /// WARNING: This rebuilds the entire tree and is O(n) complexity. Use StoredMerkleTree for
    /// efficiency.
    /// #### Arguments
    /// * `self` - The merkle tree instance
    /// * `leaves` - Array of all leaf values in the tree (will be sorted)
    /// * `index` - The index of the leaf to generate proof for
    /// #### Returns
    /// * `Span<felt252>` - Array of sibling hashes forming the merkle proof
    fn compute_proof(ref self: MerkleTree<T>, leaves: Array<felt252>, index: u32) -> Span<felt252>;
}

/// StoredMerkleTree trait defining operations for efficient Merkle tree with pre-computed storage.
pub trait StoredMerkleTreeTrait<T> {
    /// Create a new stored merkle tree instance from leaves.
    /// Pre-computes and stores all levels for efficient proof generation.
    /// #### Arguments
    /// * `leaves` - Array of leaf values to build the tree from
    /// #### Returns
    /// * `StoredMerkleTree<T>` - A new stored merkle tree with pre-computed levels
    fn new(leaves: Array<felt252>) -> StoredMerkleTree<T>;

    /// Get the merkle root of the stored tree.
    /// #### Arguments
    /// * `self` - The stored merkle tree instance
    /// #### Returns
    /// * `felt252` - The merkle root hash
    fn get_root(ref self: StoredMerkleTree<T>) -> felt252;

    /// Generate a merkle proof for a specific leaf at the given index.
    /// Efficient O(log n) operation using pre-stored tree levels.
    /// #### Arguments
    /// * `self` - The stored merkle tree instance
    /// * `index` - The index of the leaf to generate proof for
    /// #### Returns
    /// * `Span<felt252>` - Array of sibling hashes forming the merkle proof
    fn get_proof(ref self: StoredMerkleTree<T>, index: u32) -> Span<felt252>;

    /// Verify that a leaf belongs to the merkle tree.
    /// #### Arguments
    /// * `self` - The stored merkle tree instance
    /// * `leaf` - The leaf value to verify
    /// * `proof` - Array of sibling hashes for verification path
    /// #### Returns
    /// * `bool` - True if the leaf is valid, false otherwise
    fn verify(ref self: StoredMerkleTree<T>, leaf: felt252, proof: Span<felt252>) -> bool;

    /// Get the number of leaves in the tree.
    /// #### Arguments
    /// * `self` - The stored merkle tree instance
    /// #### Returns
    /// * `u32` - The number of leaves in the tree
    fn get_leaf_count(ref self: StoredMerkleTree<T>) -> u32;
}

/// MerkleTree Legacy implementation.
pub impl MerkleTreeImpl<T, +HasherTrait<T>, +Copy<T>, +Drop<T>> of MerkleTreeTrait<T> {
    /// Create a new merkle tree instance.
    fn new() -> MerkleTree<T> {
        MerkleTree { hasher: HasherTrait::new() }
    }

    /// Compute the merkle root of a given proof using the generic T hasher.
    /// #### Arguments
    /// * `current_node` - The current node of the proof.
    /// * `proof` - The proof.
    /// #### Returns
    /// The merkle root.
    fn compute_root(
        ref self: MerkleTree<T>, mut current_node: felt252, mut proof: Span<felt252>,
    ) -> felt252 {
        for proof_element in proof {
            // Compute the hash of the current node and the current element of the proof.
            // We need to check if the current node is smaller than the current element of the
            // proof.
            // If it is, we need to swap the order of the hash.
            current_node =
                if Into::<felt252, u256>::into(current_node) < (*proof_element).into() {
                    self.hasher.hash(current_node, *proof_element)
                } else {
                    self.hasher.hash(*proof_element, current_node)
                }
        }
        current_node
    }

    /// Verify a merkle proof using the generic T hasher.
    /// #### Arguments
    /// * `root` - The merkle root.
    /// * `leaf` - The leaf to verify.
    /// * `proof` - The proof.
    /// #### Returns
    /// True if the proof is valid, false otherwise.
    fn verify(
        ref self: MerkleTree<T>, root: felt252, mut leaf: felt252, mut proof: Span<felt252>,
    ) -> bool {
        for proof_element in proof {
            // Compute the hash of the current node and the current element of the proof.
            // We need to check if the current node is smaller than the current element of the
            // proof.
            // If it is, we need to swap the order of the hash.
            leaf =
                if Into::<felt252, u256>::into(leaf) < (*proof_element).into() {
                    self.hasher.hash(leaf, *proof_element)
                } else {
                    self.hasher.hash(*proof_element, leaf)
                };
        }
        leaf == root
    }

    /// Compute a merkle proof of given leaves and at a given index using the generic T hasher.
    /// #### Arguments
    /// * `leaves` - The sorted leaves.
    /// * `index` - The index of the given.
    /// #### Returns
    /// The merkle proof.
    fn compute_proof(
        ref self: MerkleTree<T>, mut leaves: Array<felt252>, index: u32,
    ) -> Span<felt252> {
        let mut proof: Array<felt252> = array![];

        // As we require an even number of nodes, if odd number of nodes => add a null virtual leaf
        if leaves.len() % 2 != 0 {
            leaves.append(0);
        }

        compute_proof(leaves, self.hasher, index, ref proof);

        proof.span()
    }
}

/// Helper function to compute a merkle proof of given leaves and at a given index.
/// Should only be used with an even number of leaves.
/// #### Arguments
/// * `nodes` - The sorted nodes.
/// * `index` - The index of the given.
/// * `hasher` - The hasher to use.
/// * `proof` - The proof array to fill.
fn compute_proof<T, +HasherTrait<T>, +Drop<T>>(
    mut nodes: Array<felt252>, mut hasher: T, index: u32, ref proof: Array<felt252>,
) {
    if index % 2 == 0 {
        proof.append(*nodes.at(index + 1));
    } else {
        proof.append(*nodes.at(index - 1));
    }

    // Break if we have reached the top of the tree (next_level would be root)
    if nodes.len() == 2 {
        return;
    }
    // Compute next level
    let next_level: Array<felt252> = get_next_level(nodes.span(), ref hasher);

    compute_proof(next_level, hasher, index / 2, ref proof)
}

/// Helper function to compute the next layer of a merkle tree providing a layer of nodes.
///
/// For odd number of nodes at any level, the last unpaired node is duplicated and hashed
/// with itself.
///
/// #### Example with odd nodes:
/// ```
/// Level: [H1, H2, H3]  <- 3 nodes (odd)
/// Pairs: (H1,H2), (H3,H3)  <- H3 duplicated
/// Result: [hash(H1,H2), hash(H3,H3)]
/// ```
///
/// #### Arguments
/// * `nodes` - The sorted nodes from the current level.
/// * `hasher` - The hasher to use for computing parent nodes.
/// #### Returns
/// The next layer of nodes (parent level).
fn get_next_level<T, +HasherTrait<T>, +Drop<T>>(
    mut nodes: Span<felt252>, ref hasher: T,
) -> Array<felt252> {
    let mut next_level: Array<felt252> = array![];
    while let Option::Some(left) = nodes.pop_front() {
        // Handle odd number of nodes by duplicating the last hash
        let right = if let Option::Some(right_node) = nodes.pop_front() {
            *right_node // Normal case: use the actual right sibling
        } else {
            *left // Odd case: duplicate the left node to pair with itself
        };

        // Hash the pair in sorted order to ensure deterministic results
        let node = if Into::<felt252, u256>::into(*left) < right.into() {
            hasher.hash(*left, right)
        } else {
            hasher.hash(right, *left)
        };
        next_level.append(node);
    }
    next_level
}

/// StoredMerkleTree implementation with efficient O(log n) proof generation.
pub impl StoredMerkleTreeImpl<T, +HasherTrait<T>, +Copy<T>, +Drop<T>> of StoredMerkleTreeTrait<T> {
    /// Create a new stored merkle tree instance from leaves.
    /// Pre-computes and stores all levels for efficient proof generation.
    fn new(mut leaves: Array<felt252>) -> StoredMerkleTree<T> {
        let leaf_count = leaves.len();
        let mut levels: Array<Array<felt252>> = array![];

        // Handle edge case of empty leaves
        if leaf_count == 0 {
            levels.append(array![0]);
            return StoredMerkleTree { hasher: HasherTrait::new(), levels, leaf_count: 0 };
        }

        // Ensure even number of leaves by padding with 0 if necessary
        if leaves.len() % 2 != 0 {
            leaves.append(0);
        }

        let mut current_level = leaves.clone();
        levels.append(current_level.clone());

        let mut hasher: T = HasherTrait::new();

        // Build all levels of the tree
        while current_level.len() > 1 {
            current_level = get_next_level(current_level.span(), ref hasher);
            levels.append(current_level.clone());
        }

        StoredMerkleTree {
            hasher: HasherTrait::new(), levels, leaf_count: leaf_count.try_into().unwrap(),
        }
    }

    /// Get the merkle root of the stored tree.
    fn get_root(ref self: StoredMerkleTree<T>) -> felt252 {
        let top_level_index = self.levels.len() - 1;
        let root_level = self.levels.at(top_level_index);
        *root_level.at(0)
    }

    /// Generate a merkle proof for a specific leaf at the given index.
    /// Efficient O(log n) operation using pre-stored tree levels.
    fn get_proof(ref self: StoredMerkleTree<T>, mut index: u32) -> Span<felt252> {
        let mut proof: Array<felt252> = array![];

        // Iterate through each level (except the root level)
        let mut level_index = 0;
        while level_index < self.levels.len() - 1 {
            let current_level = self.levels.at(level_index);

            // Find the sibling of the current index
            let sibling_index = if index % 2 == 0 {
                index + 1
            } else {
                index - 1
            };

            // Add sibling to proof if it exists, otherwise add 0 (for padding)
            if sibling_index < current_level.len() {
                proof.append(*current_level.at(sibling_index));
            } else {
                proof.append(0);
            }

            // Move to parent index for next level
            index = index / 2;
            level_index += 1;
        }

        proof.span()
    }

    /// Verify that a leaf belongs to the merkle tree.
    fn verify(ref self: StoredMerkleTree<T>, leaf: felt252, proof: Span<felt252>) -> bool {
        let root = self.get_root();
        let mut current_node = leaf;

        // Recompute root using the proof
        for proof_element in proof {
            current_node =
                if Into::<felt252, u256>::into(current_node) < (*proof_element).into() {
                    self.hasher.hash(current_node, *proof_element)
                } else {
                    self.hasher.hash(*proof_element, current_node)
                };
        }

        current_node == root
    }

    /// Get the number of leaves in the tree.
    fn get_leaf_count(ref self: StoredMerkleTree<T>) -> u32 {
        self.leaf_count
    }
}
