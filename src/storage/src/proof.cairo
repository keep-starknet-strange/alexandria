use core::traits::Into;
use core::array::ArrayTrait;
use poseidon::poseidon_hash_span;

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
    let contract_data = proof.contract_data;

    let (contract_root_hash, storage_value) = traverse(
        storage_address, contract_data.storage_proof
    );

    let contract_state_hash = pedersen(
        pedersen(pedersen(contract_data.class_hash, contract_root_hash), contract_data.nonce),
        contract_data.contract_state_hash_version
    );

    let (contracts_tree_root, expected_contract_state_hash) = traverse(
        contract_address, proof.contract_proof
    );

    assert(expected_contract_state_hash == contract_state_hash, 'wrong contract_state_hash');

    let state_commitment = poseidon_hash(
        'STARKNET_STATE_V0', contracts_tree_root, proof.class_commitment
    );

    assert(expected_state_commitment == state_commitment, 'wrong state_commitment');

    storage_value
}

fn traverse(expected_path: felt252, proof: Array<TrieNode>) -> (felt252, felt252) {

    let mut path: felt252 = 0;
    let mut remaining_depth: u8 = 251;

    let mut nodes = proof;
    let mut expected_hash = node_hash(nodes.at(0));

    let root_hash = expected_hash;

    let expected_path_u256: u256 = expected_path.into();

    loop {
        match nodes.pop_front() {
            Option::Some(node) => {
                assert(expected_hash == node_hash(@node), 'invalid proof node hash');
                match node {
                    TrieNode::Binary(binary_node) => {
                        remaining_depth -= 1;
                        if expected_path_u256 & pow(2, remaining_depth).into() > 0 {
                            expected_hash = binary_node.right;
                            path = shl(path, 1) + 1;
                        } else {
                            expected_hash = binary_node.left;
                            path = shl(path, 1);
                        };
                    },
                    TrieNode::Edge(edge_node) => {
                        expected_hash = edge_node.child;
                        path = shl(path, edge_node.length) + edge_node.path;
                        remaining_depth -= edge_node.length;
                    }
                }
            },
            Option::None => {
                break;
            }
        };
    };
    assert(expected_path == path, 'invalid proof path');
    (root_hash, expected_hash)
}

#[inline]
fn node_hash(node: @TrieNode) -> felt252 {
    match node {
        TrieNode::Binary(binary_node) => {
            pedersen(*binary_node.left, *binary_node.right)
        },
        TrieNode::Edge(edge_node) => {
            pedersen(*edge_node.child, *edge_node.path) + (*edge_node.length).into()
        }
    }
}

fn pow<
    T, impl TMul: Mul<T>, impl TInto: Into<felt252, T>, impl TDrop: Drop<T>, impl TCopy: Copy<T>
>(
    x: T, n: u8
) -> T {
    if n == 0 {
        1.into()
    } else if n == 1 {
        x
    } else if (n & 1) == 1 {
        x * pow(x * x, n / 2)
    } else {
        pow(x * x, n / 2)
    }
}

#[inline]
fn shl(x: felt252, b: u8) -> felt252 {
    x * pow(2, b)
}

#[inline]
fn pedersen(a: felt252, b: felt252) -> felt252 {
    hash::LegacyHash::hash(a, b)
}

#[inline]
fn poseidon_hash(a: felt252, b: felt252, c: felt252) -> felt252 {
    poseidon_hash_span(array![a, b, c].span())
}
