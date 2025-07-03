# StoredMerkleTree

Efficient MerkleTree with pre-built tree storage for O(log n) proof generation.

Fully qualified path: `alexandria_merkle_tree::merkle_tree::StoredMerkleTree`

```rust
#[derive(Drop)]
pub struct StoredMerkleTree<T> {
    hasher: T,
    levels: Array<Array<felt252>>,
    leaf_count: u32,
}
```

