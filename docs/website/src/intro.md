# Starknet Alexandria Library Documents

## About

Alexandria is a community maintained standard library for Cairo.
It is a collection of useful algorithms and data structures implemented in Cairo.

## Version

Actual version is **0.5.1** compatible with starknet **2.11.2**

## Features

This repository is composed of multiple crates:

- [ASCII](./alexandria_ascii/alexandria_ascii.md)
- [Bytes](./alexandria_bytes/alexandria_bytes_info.md)
- [Data Structures](./alexandria_data_structures/alexandria_data_structures_info.md)
- [Encoding](./alexandria_encoding/alexandria_encoding_info.md)
- [Evm](./alexandria_evm/alexandria_evm_info.md)
- [Linalg](./alexandria_linalg/alexandria_linalg_info.md)
- [Math](./alexandria_math/alexandria_math_info.md)
- [Merkle Tree](./alexandria_merkle_tree/alexandria_merkle_tree_info.md)
- [Numeric](./alexandria_numeric/alexandria_numeric_info.md)
- [Searching](./alexandria_searching/alexandria_searching_info.md)
- [Sorting](./alexandria_sorting/alexandria_sorting_info.md)
- [Storage](./alexandria_storage/alexandria_storage_info.md)
- [Utils](./alexandria_utils/alexandria_utils_info.md)

## Getting Started

### Prerequisites

- [Cairo](https://github.com/starkware-libs/cairo)
- [Scarb](https://docs.swmansion.com/scarb)
- [Rust](https://www.rust-lang.org/tools/install)

### Installation from Scarb registries

- ASCII : `scarb add alexandria_ascii@0.5.1`
- Bytes : `scarb add alexandria_bytes@0.5.1`
- Data Structures : `scarb add alexandria_data_structures@0.5.1`
- Encoding : `scarb add alexandria_encoding@0.5.1`
- Evm : `scarb add alexandria_evm@0.5.1`
- Linalg : `scarb add alexandria_linalg@0.5.1`
- Math : `scarb add alexandria_math@0.5.1`
- MerkleTree: `scarb add alexandria_merkle_tree@0.5.1`
- Numeric : `scarb add alexandria_numeric@0.5.1`
- Searching : `scarb add alexandria_searching@0.5.1`
- Sorting : `scarb add alexandria_sorting@0.5.1`
- Storage : `scarb add alexandria_storage@0.5.1`
- Utils : `scarb add alexandria_utils@0.5.1`

## Usage

### Build

```bash
scarb build
```

### Test

```bash
scarb test
```

Running a specific subset of tests

```bash
scarb test -f math
```

### Format

```bash
scarb fmt
```

## Roadmap

See the [open issues](https://github.com/keep-starknet-strange/alexandria/issues) for a list of proposed features (and known issues).

- [Top Feature Requests](https://github.com/keep-starknet-strange/alexandria/issues?q=label%3Aenhancement+is%3Aopen+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Top Bugs](https://github.com/keep-starknet-strange/alexandria/issues?q=is%3Aissue+is%3Aopen+label%3Abug+sort%3Areactions-%2B1-desc) (Add your votes using the 👍 reaction)
- [Newest Bugs](https://github.com/keep-starknet-strange/alexandria/issues?q=is%3Aopen+is%3Aissue+label%3Abug)

## Support

Reach out to the maintainer at one of the following places:

- [GitHub Discussions](https://github.com/keep-starknet-strange/alexandria/discussions)
- Contact options listed on [this GitHub profile](https://github.com/starknet-exploration)

## Project assistance

If you want to say **thank you** or/and support active development of Alexandria:

- Add a [GitHub Star](https://github.com/keep-starknet-strange/alexandria) to the project.
- Tweet about the Alexandria.
- Write interesting articles about the project on [Dev.to](https://dev.to/), [Medium](https://medium.com/) or your personal blog.

Together, we can make Alexandria **better**!
