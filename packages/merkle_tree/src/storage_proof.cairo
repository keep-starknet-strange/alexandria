use alexandria_math::const_pow::pow2_felt252;
use core::hash::HashStateTrait;
use core::pedersen::PedersenTrait;
use core::poseidon::PoseidonTrait;

/// Represents a binary node in a Merkle Patricia Trie
///
/// A binary node contains exactly two children, commonly used in Merkle trees
/// to represent internal nodes that split paths into left and right branches.
/// This structure is fundamental for Starknet's storage proof verification.
///
/// ### Fields
/// * `left` - Hash of the left child node
/// * `right` - Hash of the right child node
#[derive(Drop, Serde)]
pub struct BinaryNode {
    left: felt252,
    right: felt252,
}

/// Trait for creating and manipulating BinaryNode instances
#[generate_trait]
pub impl BinaryNodeImpl of BinaryNodeTrait {
    /// Creates a new BinaryNode with the specified left and right child hashes
    ///
    /// #### Arguments
    /// * `left` - Hash of the left child node
    /// * `right` - Hash of the right child node
    ///
    /// #### Returns
    /// * `BinaryNode` - A new BinaryNode instance with the specified children
    fn new(left: felt252, right: felt252) -> BinaryNode {
        BinaryNode { left, right }
    }
}

/// Represents an edge node in a Merkle Patricia Trie
///
/// An edge node compresses a path of nodes in the trie, storing both the compressed
/// path and the hash of the child node. This optimization reduces the depth of the trie
/// when consecutive nodes have only one child, improving efficiency in Starknet storage proofs.
///
/// #### Fields
/// * `path` - The compressed path as a felt252 value
/// * `child` - Hash of the child node at the end of this path
/// * `length` - Length of the compressed path in bits
#[derive(Drop, Copy, Serde)]
pub struct EdgeNode {
    path: felt252,
    child: felt252,
    length: u8,
}

/// Trait for creating and manipulating EdgeNode instances
#[generate_trait]
pub impl EdgeNodeImpl of EdgeNodeTrait {
    /// Creates a new EdgeNode with the specified path, child hash, and path length
    ///
    /// #### Arguments
    /// * `path` - The compressed path as a felt252 value
    /// * `child` - Hash of the child node at the end of this path
    /// * `length` - Length of the compressed path in bits
    ///
    /// #### Returns
    /// * `EdgeNode` - A new EdgeNode instance with the specified parameters
    fn new(path: felt252, child: felt252, length: u8) -> EdgeNode {
        EdgeNode { path, child, length }
    }
}

/// Represents a node in a Merkle Patricia Trie
///
/// This enum encapsulates the two types of nodes that can exist in a Merkle Patricia Trie:
/// binary nodes (which have exactly two children) and edge nodes (which compress paths).
///
/// #### Variants
/// * `Binary` - A binary node with left and right children
/// * `Edge` - An edge node with a compressed path and single child
#[derive(Drop, Serde)]
pub enum TrieNode {
    Binary: BinaryNode,
    Edge: EdgeNode,
}

/// Represents contract-specific data needed for storage proof verification
///
/// This structure contains all the necessary information about a contract's state,
/// including its class hash, nonce, state hash version, and the storage proof itself.
///
/// #### Fields
/// * `class_hash` - The hash of the contract's class
/// * `nonce` - The contract's current nonce
/// * `contract_state_hash_version` - Version identifier for the contract state hash format
/// * `storage_proof` - Array of TrieNode representing the storage proof path
#[derive(Destruct, Serde)]
pub struct ContractData {
    class_hash: felt252,
    nonce: felt252,
    contract_state_hash_version: felt252,
    storage_proof: Array<TrieNode>,
}

#[generate_trait]
pub impl ContractDataImpl of ContractDataTrait {
    /// Creates a new ContractData instance with the specified parameters
    /// #### Arguments
    /// * `class_hash` - The class hash of the contract
    /// * `nonce` - The nonce of the contract
    /// * `contract_state_hash_version` - The version of the contract state hash
    /// * `storage_proof` - Array of TrieNode representing the storage proof
    /// #### Returns
    /// * `ContractData` - A new ContractData instance
    fn new(
        class_hash: felt252,
        nonce: felt252,
        contract_state_hash_version: felt252,
        storage_proof: Array<TrieNode>,
    ) -> ContractData {
        ContractData { class_hash, nonce, contract_state_hash_version, storage_proof }
    }
}

/// Represents a complete contract state proof for verification
///
/// This structure contains all components needed to verify a contract's state against
/// the Starknet global state commitment, including the class commitment, contract proof,
/// and contract-specific data.
///
/// #### Fields
/// * `class_commitment` - The commitment hash for contract classes
/// * `contract_proof` - Array of TrieNode representing the contract proof path
/// * `contract_data` - ContractData containing contract-specific information and storage proof
#[derive(Destruct, Serde)]
pub struct ContractStateProof {
    class_commitment: felt252,
    contract_proof: Array<TrieNode>,
    contract_data: ContractData,
}

#[generate_trait]
pub impl ContractStateProofImpl of ContractStateProofTrait {
    /// Creates a new ContractStateProof instance with the specified parameters
    /// #### Arguments
    /// * `class_commitment` - The class commitment hash
    /// * `contract_proof` - Array of TrieNode representing the contract proof
    /// * `contract_data` - ContractData containing contract-specific information
    /// #### Returns
    /// * `ContractStateProof` - A new ContractStateProof instance
    fn new(
        class_commitment: felt252, contract_proof: Array<TrieNode>, contract_data: ContractData,
    ) -> ContractStateProof {
        ContractStateProof { class_commitment, contract_proof, contract_data }
    }
}

/// Verify Starknet storage proof. For reference see:
/// -
/// ([state](https://docs.starknet.io/documentation/architecture_and_concepts/State/starknet-state/))
/// - ([pathfinder_getproof API
/// endpoint](https://github.com/eqlabs/pathfinder/blob/main/doc/rpc/pathfinder_rpc_api.json))
/// - ([pathfinder storage
/// implementation](https://github.com/eqlabs/pathfinder/blob/main/crates/merkle-tree/main/src/tree.rs))
/// #### Arguments
/// * `expected_state_commitment` - state root `proof` is going to be verified against
/// * `contract_address` - `contract_address` of the value to be verified
/// * `storage_address` - `storage_address` of the value to be verified
/// * `proof` - `ContractStateProof` representing storage proof
/// #### Returns
/// * `felt252` - `value` at `storage_address` if verified, panic otherwise.
pub fn verify(
    expected_state_commitment: felt252,
    contract_address: felt252,
    storage_address: felt252,
    proof: ContractStateProof,
) -> felt252 {
    let contract_data = proof.contract_data;

    let (contract_root_hash, storage_value) = traverse(
        storage_address, contract_data.storage_proof,
    );

    let contract_state_hash = pedersen_hash_4(
        contract_data.class_hash,
        contract_root_hash,
        contract_data.nonce,
        contract_data.contract_state_hash_version,
    );

    let (contracts_tree_root, expected_contract_state_hash) = traverse(
        contract_address, proof.contract_proof,
    );

    assert(expected_contract_state_hash == contract_state_hash, 'wrong contract_state_hash');

    let state_commitment = poseidon_hash(
        'STARKNET_STATE_V0', contracts_tree_root, proof.class_commitment,
    );

    assert(expected_state_commitment == state_commitment, 'wrong state_commitment');

    storage_value
}

/// Traverses the Merkle Patricia Trie using the provided proof nodes
///
/// This function validates the proof by traversing from leaf to root, ensuring that
/// each node hash matches the expected hash and that the path construction is correct.
///
/// #### Arguments
/// * `expected_path` - The expected path to traverse in the trie
/// * `proof` - Array of TrieNode representing the proof path
/// #### Returns
/// * `(felt252, felt252)` - Tuple containing (root_hash, leaf_value)
fn traverse(expected_path: felt252, proof: Array<TrieNode>) -> (felt252, felt252) {
    let mut nodes = proof.span();
    let expected_path_u256: u256 = expected_path.into();

    let leaf = *match nodes.pop_back().unwrap() {
        TrieNode::Binary(_) => panic!("expected Edge got Leaf"),
        TrieNode::Edge(edge) => edge,
    };

    let mut expected_hash = node_hash(@TrieNode::Edge(leaf));
    let value = leaf.child;
    let mut path = leaf.path;
    let mut path_length_pow2 = pow2_felt252(leaf.length.into());

    loop {
        match nodes.pop_back() {
            Option::Some(node) => {
                match node {
                    TrieNode::Binary(binary_node) => {
                        if expected_path_u256 & path_length_pow2.into() > 0 {
                            assert(expected_hash == *binary_node.right, 'invalid node hash');
                            path += path_length_pow2;
                        } else {
                            assert(expected_hash == *binary_node.left, 'invalid node hash');
                        }
                        path_length_pow2 *= 2;
                    },
                    TrieNode::Edge(edge_node) => {
                        assert(expected_hash == *edge_node.child, 'invalid node hash');
                        path += *edge_node.path * path_length_pow2;
                        path_length_pow2 *= pow2_felt252((*edge_node.length).into());
                    },
                }
                expected_hash = node_hash(node);
            },
            Option::None => { break; },
        };
    }
    assert(expected_path == path, 'invalid proof path');
    (expected_hash, value)
}


/// Computes the hash of a trie node based on its type
///
/// Binary nodes use Pedersen hash of left and right children.
/// Edge nodes use Pedersen hash of child and path, plus the path length.
///
/// #### Arguments
/// * `node` - Reference to the TrieNode to hash
/// #### Returns
/// * `felt252` - The computed hash of the node
#[inline]
fn node_hash(node: @TrieNode) -> felt252 {
    match node {
        TrieNode::Binary(binary) => pedersen_hash(*binary.left, *binary.right),
        TrieNode::Edge(edge) => pedersen_hash(*edge.child, *edge.path) + (*edge.length).into(),
    }
}


/// Computes Pedersen hash of two felt252 values
/// #### Arguments
/// * `a` - First input value
/// * `b` - Second input value
/// #### Returns
/// * `felt252` - Pedersen hash result
fn pedersen_hash(a: felt252, b: felt252) -> felt252 {
    PedersenTrait::new(a).update(b).finalize()
}


/// Computes Pedersen hash of four felt252 values
/// #### Arguments
/// * `a` - First input value
/// * `b` - Second input value
/// * `c` - Third input value
/// * `d` - Fourth input value
/// #### Returns
/// * `felt252` - Pedersen hash result
#[inline(always)]
fn pedersen_hash_4(a: felt252, b: felt252, c: felt252, d: felt252) -> felt252 {
    PedersenTrait::new(a).update(b).update(c).update(d).finalize()
}


/// Computes Poseidon hash of three felt252 values
/// #### Arguments
/// * `a` - First input value
/// * `b` - Second input value
/// * `c` - Third input value
/// #### Returns
/// * `felt252` - Poseidon hash result
#[inline(always)]
fn poseidon_hash(a: felt252, b: felt252, c: felt252) -> felt252 {
    PoseidonTrait::new().update(a).update(b).update(c).finalize()
}
