use core::array::ArrayTrait;
use integer::u256_overflow_mul;
use poseidon::poseidon_hash_span;
use alexandria_math::BitShift;

// documentation
// https://docs.starknet.io/documentation/architecture_and_concepts/State/starknet-state/
// https://github.com/eqlabs/pathfinder/blob/main/crates/merkle-tree/src/tree.rs
// https://github.com/eqlabs/pathfinder/blob/main/doc/rpc/pathfinder_rpc_api.json
// https://github.com/NethermindEth/starknet-state-verifier/blob/main/contracts/contracts/SNStateProofVerifier.sol


#[derive(Drop)]
struct BinaryNode {
    left: felt252,
    right: felt252,
}

#[derive(Drop)]
struct EdgeNode {
    child: felt252,
    path: felt252,
    length: u8,
}

#[derive(Drop)]
enum TrieNode {
    Binary: BinaryNode,
    Edge: EdgeNode,
}

#[derive(Destruct)]
struct ContractData {
    class_hash: felt252,
    nonce: felt252,
    contract_state_hash_version: felt252,
    storage_proof: Array<TrieNode>
}

#[derive(Destruct)]
struct ContractStateProof {
    class_commitment: felt252,
    contract_proof: Array<TrieNode>,
    contract_data: ContractData
}

fn verify(
    expected_state_commitment: felt252,
    contract_address: felt252,
    storage_address: felt252,
    proof: ContractStateProof
) -> felt252 {
    let (contract_root_hash, storage_value) = traverse(
        storage_address.into(),
        proof.contract_data.storage_proof
    );

    let contract_state_hash = pedersen(
        pedersen(
            pedersen(proof.contract_data.class_hash, contract_root_hash),
            proof.contract_data.nonce),
        proof.contract_data.contract_state_hash_version
    );

    let (contracts_tree_root, expected_contract_state_hash) = traverse(
        contract_address.into(),
        proof.contract_proof
    );

    assert(
        expected_contract_state_hash == contract_state_hash,
        'wrong contract_state_hash'
    );

    let state_commitment = poseidon_hash_span(array![
        'STARKNET_STATE_V0',
        contracts_tree_root,
        proof.class_commitment
    ].span());

    assert(
        expected_state_commitment == state_commitment,
        'wrong state_commitment'
    );

    storage_value
}

fn traverse(leaf_path: u256, proof: Array<TrieNode>) -> (felt252, felt252) {
    let mut path_length = 0_u8;

    let mut path = leaf_path;
    let mut nodes = proof;
    let root_hash = node_hash(nodes.at(0));
    let mut expected_hash = root_hash;
    loop {
        match nodes.pop_front() {
            Option::Some(node) => {
                assert(expected_hash == node_hash(@node), 'invalid proof node hash');
                match node {
                    TrieNode::Binary(binary_node) => {
                        expected_hash = if shr251(path, 250) == 1_u256 {
                            binary_node.right
                        } else {
                            binary_node.left
                        };
                        path = shl251(path, 1);
                        path_length += 1;
                    },
                    TrieNode::Edge(edge_node) => {
                        assert(shr251(path, 251 - edge_node.length) == (edge_node.path).into(), 'invalid proof node path');
                        expected_hash = edge_node.child;
                        path = shl251(path, edge_node.length);
                        path_length += edge_node.length;
                    }
                }
            },
            Option::None => {
                assert(path_length == 251, 'invalid proof path');
                break;
            }
        };
    };
    (root_hash, expected_hash)
}

#[inline]
fn shl251(x: u256, bits: u8) -> u256 {
    let (r, _) = u256_overflow_mul(x, BitShift::fpow(2_u256, bits.into()));
    r & 0x7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff_u256
}

#[inline]
fn shr251(x: u256, bits: u8) -> u256 {
    x / BitShift::fpow(2_u256, bits.into())
}

#[inline]
fn node_hash(node: @TrieNode) -> felt252 {
    match node {
        TrieNode::Binary(binary_node) => {
            pedersen(*binary_node.left, *binary_node.right)
        },
        TrieNode::Edge(edge_node) => {
            pedersen(*edge_node.child, *edge_node.path)
            + (*edge_node.length).into()
        }
    }
}

#[inline]
fn pedersen(a: felt252, b: felt252) -> felt252 {
    hash::LegacyHash::hash(a, b)
}
