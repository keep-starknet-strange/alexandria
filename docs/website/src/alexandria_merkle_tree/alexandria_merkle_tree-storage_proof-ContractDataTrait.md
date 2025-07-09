# ContractDataTrait

Fully qualified path: `alexandria_merkle_tree::storage_proof::ContractDataTrait`

```rust
pub trait ContractDataTrait
```

## Trait functions

### new

Fully qualified path: `alexandria_merkle_tree::storage_proof::ContractDataTrait::new`

```rust
fn new(
    class_hash: felt252,
    nonce: felt252,
    contract_state_hash_version: felt252,
    storage_proof: Array<TrieNode>,
) -> ContractData
```

