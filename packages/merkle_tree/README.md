# Merkle Tree related stuff

## [Merkle Tree](./src/merkle_tree.cairo)

The Merkle tree algorithm is a cryptographic hashing algorithm used to create a hash tree, which is a tree data structure where each leaf node represents a data block and each non-leaf node represents a hash of its child nodes.
The purpose of the Merkle tree algorithm is to provide a way to verify the integrity and authenticity of large amounts of data without needing to store the entire data set. The algorithm has applications in various areas of computer science, including cryptocurrency, file sharing, and database management.
The Merkle tree algorithm is also used in creating digital signatures and verifying the authenticity of transactions.
By providing a secure and efficient way to verify data integrity, the Merkle tree algorithm is an important tool in cryptography and information security.
A generic implementation is available to manage both pedersen (legacy) and poseidon hash methods.

## [Starknet Storage Proof Verifier](./src/storage_proof.cairo)

Implementation of Starknet ([storage proofs](https://docs.starknet.io/documentation/architecture_and_concepts/State/starknet-state/)) returned by `pathfinder_getproof` API endpoint ([see](https://github.com/eqlabs/pathfinder/blob/main/doc/rpc/pathfinder_rpc_api.json)).
