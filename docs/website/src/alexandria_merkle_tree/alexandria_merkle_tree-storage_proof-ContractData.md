# ContractData

Fully qualified path: `alexandria_merkle_tree::storage_proof::ContractData`

```rust
#[derive(Destruct, Serde)]
pub struct ContractData {
    class_hash: felt252,
    nonce: felt252,
    contract_state_hash_version: felt252,
    storage_proof: Array<TrieNode>,
}
```

