# verify

Verify Starknet storage proof. For reference see: - ([state](https://docs.starknet.io/documentation/architecture_and_concepts/State/starknet-state/)) - ([pathfinder_getproof API endpoint](https://github.com/eqlabs/pathfinder/blob/main/doc/rpc/pathfinder_rpc_api.json)) - ([pathfinder storage implementation](https://github.com/eqlabs/pathfinder/blob/main/crates/merkle-tree/main/src/tree.rs))

## Arguments

- `expected_state_commitment` - state root `proof` is going to be verified against
- `contract_address` - `contract_address` of the value to be verified
- `storage_address` - `storage_address` of the value to be verified
- `proof` - `ContractStateProof` representing storage proof

## Returns

- `felt252` - `value` at `storage_address` if verified, panic otherwise.

Fully qualified path: `alexandria_merkle_tree::storage_proof::verify`

```rust
pub fn verify(
    expected_state_commitment: felt252,
    contract_address: felt252,
    storage_address: felt252,
    proof: ContractStateProof,
) -> felt252
```
