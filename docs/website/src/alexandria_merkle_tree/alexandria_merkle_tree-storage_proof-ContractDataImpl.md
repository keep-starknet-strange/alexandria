# ContractDataImpl

Fully qualified path: `alexandria_merkle_tree::storage_proof::ContractDataImpl`

```rust
pub impl ContractDataImpl of ContractDataTrait
```

## Impl functions

### new

Fully qualified path: `alexandria_merkle_tree::storage_proof::ContractDataImpl::new`

```rust
fn new(
    class_hash: felt252,
    nonce: felt252,
    contract_state_hash_version: felt252,
    storage_proof: Array<TrieNode>,
) -> ContractData
```

