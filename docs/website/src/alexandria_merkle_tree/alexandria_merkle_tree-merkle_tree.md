# merkle_tree

MerkleTree implementation. 

#### Examples
```cairo
// This version uses the pedersen hash method because the PedersenHasherImpl is in the scope.
use alexandria_data_structures::merkle_tree::{Hasher, MerkleTree, pedersen::PedersenHasherImpl,
MerkleTreeTrait};

// Create a new merkle tree instance.
let mut merkle_tree: MerkleTree<Hasher> = MerkleTreeTrait::new();
let mut proof = array![element_1, element_2];
// Compute the merkle root.
let root = merkle_tree.compute_root(leaf, proof);
```

```cairo
// This version uses the poseidon hash method because the PoseidonHasherImpl is in the scope.
use alexandria_data_structures::merkle_tree::{ Hasher, MerkleTree, poseidon::PoseidonHasherImpl,
MerkleTreeTrait };

// Create a new merkle tree instance.
let mut merkle_tree: MerkleTree<PoseidonHasher> = MerkleTreeTrait::new();
let mut proof = array![element_1, element_2];
// Compute the merkle root.
let root = merkle_tree.compute_root(leaf, proof);
```

Fully qualified path: `alexandria_merkle_tree::merkle_tree`

## Modules

- [pedersen](./alexandria_merkle_tree-merkle_tree-pedersen.md)

- [poseidon](./alexandria_merkle_tree-merkle_tree-poseidon.md)

## Structs

- [Hasher](./alexandria_merkle_tree-merkle_tree-Hasher.md)

- [MerkleTree](./alexandria_merkle_tree-merkle_tree-MerkleTree.md)

- [StoredMerkleTree](./alexandria_merkle_tree-merkle_tree-StoredMerkleTree.md)

## Traits

- [HasherTrait](./alexandria_merkle_tree-merkle_tree-HasherTrait.md)

- [MerkleTreeTrait](./alexandria_merkle_tree-merkle_tree-MerkleTreeTrait.md)

