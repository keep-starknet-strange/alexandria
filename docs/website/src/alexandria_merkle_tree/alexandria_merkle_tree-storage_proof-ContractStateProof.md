# ContractStateProof

Fully qualified path: `alexandria_merkle_tree::storage_proof::ContractStateProof`

```rust
#[derive(Destruct, Serde)]
pub struct ContractStateProof {
    class_commitment: felt252,
    contract_proof: Array<TrieNode>,
    contract_data: ContractData,
}
```

