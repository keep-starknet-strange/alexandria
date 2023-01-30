// Core lib imports
use array::ArrayTrait;
use option::OptionTrait;
use hash::LegacyHash;

/// MerkleTree representation.
#[derive(Drop)]
struct MerkleTree {}

trait MerkleTreeTrait {
    fn new() -> MerkleTree;
    /// Compute the merkle root of a given proof.
    fn compute_root(ref self: MerkleTree, current_node: felt, proof: Array::<felt>) -> felt;
}
impl MerkleTreeImpl of MerkleTreeTrait {
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
        let proof_len = u128_to_felt(ArrayTrait::len(ref proof));
        internal_compute_root(current_node, 0_u128, proof_len, proof)
    }
}

fn internal_compute_root(
    current_node: felt, proof_index: u128, proof_len: felt, mut proof: Array::<felt>
) -> felt {
    // Check if out of gas.
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
    if proof_len == 0 {
        return current_node;
    }
    let mut node = 0;
    // Get the next element of the proof.
    let proof_element = ArrayTrait::at(ref proof, proof_index);

    let h = LegacyHash::hash(current_node, proof_element);
    if current_node < proof_element {
        node = LegacyHash::hash(current_node, proof_element);
    } else {
        node = LegacyHash::hash(proof_element, current_node);
    }
    // Recursively compute the root.
    internal_compute_root(node, proof_index + 1_u128, proof_len - 1, proof)
}
// Add traits for inner generic types if needed.
//impl OptionFeltCopy of Copy::<Option::<felt>>;
//impl OptionFeltDrop of Drop::<Option::<felt>>;


