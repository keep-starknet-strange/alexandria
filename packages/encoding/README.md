# Encoding

## [Base64](./src/base64.cairo)

Base64 is a binary-to-text encoding scheme used for transferring binary data safely over media designed for text. It divides input data into 3-byte blocks, each converted into 4 ASCII characters using a specific index table. If input bytes aren't divisible by three, it's padded with '=' characters. The process is reversed for decoding.

## [Solidity ABI](./src/sol_abi.cairo)

**sol_abi** is a wrapper around `alexandria_bytes::Bytes` providing easy to use interfaces to mimic Solidity's `abi` functions.

### Examples

1. **Encode** and **EncodePacked**

Solidity's `abi.encode` calls go from :

```solidity
uint8 v1 = 0x1a;
uint128 v2 = 0x101112131415161718191a1b1c1d1e1f;
bool v3 = true;
address v4 = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF;
bytes7 v5 = 0x000a0b0c0d0e0f;

abi.encode(v1, v2, v3, v4, v5);
```

to the Cairo equivalent :

```rust
use alexandria_bytes::{Bytes, BytesTrait};
use alexandria_encoding::sol_abi::{SolBytesTrait, SolAbiEncodeTrait};
use starknet::{ContractAddress, eth_address::U256IntoEthAddress, EthAddress};

fn main() {
    let eth_address: EthAddress = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF_u256.into();
    let mut encoded: Bytes = BytesTrait::new_empty();
    encoded = encoded
        .encode(0x1a_u8)
        .encode(0x101112131415161718191a1b1c1d1e1f_u128)
        .encode(true)
        .encode(eth_address)
        .encode(SolBytesTrait::bytes7(0xa0b0c0d0e0f));
}
```

Which will properly pad individual types according to Solidity's spec. A similar interface is also supported for `abi.encodePacked` with the Cairo `encode_packed`.

2. **Decode**

Solidity's `abi.decode` calls go from :

```solidity
bytes memory encoded = ...
(uint8 o1, uint128 o2, bool o3, address o4, bytes7 o5) = abi.decode(encoded, (uint8, uint128, bool, address, bytes7));
```

to the Cairo equivalent :

```rust
use alexandria_bytes::{Bytes, BytesTrait};
use alexandria_encoding::sol_abi::{SolBytesTrait, SolAbiDecodeTrait};
use starknet::{ContractAddress, eth_address::U256IntoEthAddress, EthAddress};

fn main() {
    let encoded: Bytes = ...

    let mut offset = 0;
    let o1: u8 = encoded.decode(ref offset);
    let o2: u128 = encoded.decode(ref offset);
    let o3: bool = encoded.decode(ref offset);
    let o4: EthAddress = encoded.decode(ref offset);
    let o5: Bytes = SolBytesTrait::<Bytes>::bytes7(encoded.decode(ref offset));
}
```

Which decodes bytes formatted like from an `encode` call.

3. **BytesX**

Solidity supports types `bytes1`, `bytes2`, ..., and `bytes32`, which are left-aligned/right-padded byte arrays when encoded.

This module adds the `SolBytesTrait` wrapper for `alexandria_bytes::Bytes`, so declaring and using these is easier in Cairo.

Solidity bytes declarations :

```solidity
bytes3 v1 = 0xabcdef;
bytes32 v2 = 0x101112131415161718191a1b1c1d1e1f0102030405060708090a0b0c0d0e1011;
bytes7 v3 = 0x01020304050607;
```

can be done in Cairo like :

```rust
use alexandria_bytes::{Bytes, BytesTrait};
use alexandria_encoding::sol_abi::SolBytesTrait;

let v1: Bytes = SolBytesTrait::bytes3(0xabcdef_u128);
let v2: Bytes = SolBytesTrait::bytes32(0x101112131415161718191a1b1c1d1e1f0102030405060708090a0b0c0d0e1011_u256);
let v3: Bytes = SolBytesTrait::bytes7(BytesTrait::new(16, array![0x01020304050607000000000000000000]));
```
