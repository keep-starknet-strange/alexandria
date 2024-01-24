# bytes

**bytes** is an implementation similar to Solidity bytes written in Cairo 1 by [zkLink](https://zk.link/). It is notable for its built-in implementation of `Keccak` and `Sha256` hash functions, offering convenience for migrating EVM Contracts written in Solidity to the Starknet ecosystem.

## Example

**bytes** implements read and write operations for all Cairo built-in types, as well as `keccak/sha256` operations. For example, in Solidity, if there is a `Token` type, and we want to calculate the keccak256 hash of an instance of this structure.

```solidity
struct Token {
    uint16 tokenId;
    address tokenAddress;
    uint8 decimals;
}
```

In Solidity, we can achieve this by doing the following:

```solidity
keccak256(abi.encodePacked(tokenId, tokenAddress, decimals));
```

In Cairo, we can effortlessly achieve the same using `Bytes`:

```rust
use alexandria_bytes::Bytes;
use alexandria_bytes::BytesTrait;
use debug::PrintTrait;
use starknet::contract_address_const;

fn main() {
    let mut bytes: Bytes = BytesTrait::new(0, array![]);
    bytes.append_u16(1);
    bytes.append_address(contract_address_const::<0x123>());
    bytes.append_u8(16);
    let keccak_hash = bytes.keccak();
    keccak_hash.print();
}
```