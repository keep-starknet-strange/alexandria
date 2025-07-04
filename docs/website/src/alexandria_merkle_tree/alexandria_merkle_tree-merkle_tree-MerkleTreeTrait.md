# MerkleTreeTrait

MerkleTree trait defining operations for Merkle tree construction and verification.

Fully qualified path: `alexandria_merkle_tree::merkle_tree::MerkleTreeTrait`

```rust
pub trait MerkleTreeTrait<T>
```

## Trait functions

### new

Create a new merkle tree instance.

#### Returns

- `MerkleTree<T>` - A new merkle tree with the specified hasher type

Fully qualified path: `alexandria_merkle_tree::merkle_tree::MerkleTreeTrait::new`

```rust
fn new() -> MerkleTree<T>
```

### compute_root

Compute the merkle root of a given proof by iteratively hashing with proof elements.

#### Arguments

- `self` - The merkle tree instance
- `current_node` - The starting leaf node (felt252 hash value)
- `proof` - Array of sibling hashes needed to compute the root

#### Returns

- `felt252` - The computed merkle root hash

Fully qualified path: `alexandria_merkle_tree::merkle_tree::MerkleTreeTrait::compute_root`

```rust
fn compute_root(ref self: MerkleTree<T>, current_node: felt252, proof: Span<felt252>) -> felt252
```

### verify

Verify that a leaf belongs to the merkle tree with the given root.

#### Arguments

- `self` - The merkle tree instance
- `root` - The expected merkle root hash
- `leaf` - The leaf value to verify
- `proof` - Array of sibling hashes for verification path

#### Returns

- `bool` - True if the leaf is valid for the given root, false otherwise

Fully qualified path: `alexandria_merkle_tree::merkle_tree::MerkleTreeTrait::verify`

```rust
fn verify(ref self: MerkleTree<T>, root: felt252, leaf: felt252, proof: Span<felt252>) -> bool
```

### compute_proof

Generate a merkle proof for a specific leaf at the given index. WARNING: This rebuilds the entire tree and is O(n) complexity. Use StoredMerkleTree for efficiency.

#### Arguments

- `self` - The merkle tree instance
- `leaves` - Array of all leaf values in the tree (will be sorted)
- `index` - The index of the leaf to generate proof for

#### Returns

- `Span<felt252>` - Array of sibling hashes forming the merkle proof

Fully qualified path: `alexandria_merkle_tree::merkle_tree::MerkleTreeTrait::compute_proof`

```rust
fn compute_proof(ref self: MerkleTree<T>, leaves: Array<felt252>, index: u32) -> Span<felt252>
```
